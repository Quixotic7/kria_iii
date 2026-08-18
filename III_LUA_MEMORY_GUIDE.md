# Memory survival guide for monome iii Lua scripts (RP2040)

Hard-won lessons from developing **rake** (an arc iii script that hit the heap
ceiling four times and recovered every time without losing features). Written to
be self-contained: hand this to any session working on an iii script — arc or
grid — with memory problems. All techniques were verified on-device.

---

## 1. The platform has THREE separate budgets

Confusing them wastes days. A change can pass one budget and die on another.

1. **Source size: ≤ 32 KB per file.** A compile-time check per uploaded file.
   Comments count. You can have **multiple files** — `fs_run_file("other.lua")`
   loads a second file, and each gets its own 32 KB. Splitting is free capacity.
2. **Resident heap** — what `mem()` shows after boot. Rake runs ~161 KB steady.
3. **The load-time allocation peak** — the real killer. The device can print
   `-- compiled ok` on upload and still die with `-- out of memory!` while
   *running*. A config can boot today and OOM after a +1 KB feature. The peak
   moments during boot are (measured, in order of allocation):
   compile of the main file → data-file load → big-table allocation → function
   definitions → **`pset_read` (parsing the saved state file was rake's single
   worst moment)**.

**Rule: `mem()` after boot understates risk.** Budget against the peak, not the
steady state.

## 2. Allocation SHAPE matters as much as size (fragmentation)

The decisive, non-obvious lesson. The RP2040 heap fragments; a build that is
**larger in total bytes can boot while a smaller one OOMs**, because the smaller
one asked for a big *contiguous* block.

Evidence from rake: a "flat bank" layout (one 320-slot Lua array ≈ 5 KB
contiguous) OOM'd at 163.8 KB measured, while a per-field layout (10 arrays of
32 each — tiny power-of-2 blocks) **booted at 165.4 KB measured**. Same data,
different shape.

**Rules:**
- Prefer **many small arrays** over one big one. Best structure found for
  per-voice/per-cell state: **per-field parallel arrays** —
  `bank[FIELD][k]` (10 arrays × 32 entries) — not per-slot tables and not one
  flat stride array.
- Avoid anything that needs one big block: large `table.unpack` calls (the
  argument list is a stack spike), huge single-table constructors, big
  string concatenations.
- Small allocations (short strings, small tables, bytecode) are "shape-safe" —
  they slot into fragments.

## 3. Lua table overhead is the usual hidden cost

On the device a table costs roughly **40 bytes of header/allocator overhead
before storing a single value** — and small tables round their array part up.

- **Per-item tables are poison at scale.** 96 slot-tables of 11 fields spent
  more on overhead than on data. → per-field arrays (see §2).
- **Lua rounds a table's array part up to a power of two on *incremental*
  insertion.** Filling 320 entries one-by-one allocates capacity 512 (37%
  waste). An 11-element table constructor allocates 16. Sizing dodge: build via
  a constructor/`SETLIST` (`{ n = 0, table.unpack(zeros, 1, N) }` sizes
  *exactly*) — but beware the unpack stack spike (§2); for big data prefer
  per-field arrays sized at powers of two anyway.
- **Dozens of tiny constant tables are a silent few-KB.** rake had ~60 little
  LED/scale tables (5–16 small ints each). Packing them into **byte strings**
  read with `s:byte(i)` reclaimed several KB — a string is one object, no
  per-entry overhead. Encodings that worked:
  - plain lists: one byte per value (`"\3\6\12\24\96"`)
  - signed values: store with an offset (`:byte(i) - 2`)
  - booleans/flags: `"0"`/`"1"` character strings (`:byte(i) == 49`)
  - grouped lists: `\0`-separated runs; pairs: consecutive bytes
  - brightness patterns: hex-character strings, `tonumber(s:sub(i,i), 16)`
  - **Gotcha:** Lua string indices are **negative-from-the-end**. A lookup that
    used to be a safe hash miss (`t[d]` → nil) becomes `s:byte(d+1)` reading
    the *last byte* when `d` is negative. **Range-guard first.**
- **Generate packed strings with a script** (from the source data/JSON), never
  hand-type them; verify by rendering/diffing output.

## 4. Reclaim levers, ranked by measured payoff in rake

1. **Restructure per-item tables → per-field arrays** (biggest; also fixes
   shape). Doubled pattern capacity (16→32 slots) *and* lowered total RAM.
2. **Make rarely-used permanent tables transient** (~4 KB). rake's pset
   snapshot was a ~60-entry global hash alive all session but only needed
   during `pset_write`. Build it as a **local**, let it be garbage after use.
   Run `collectgarbage()` before the use so the transient starts on a clean
   heap. Grid scripts often have equivalents: UI scratch, preset staging.
3. **Pack tiny constant tables into byte strings** (several KB; see §3).
4. **Derive instead of store.** Any table computable from another in one
   expression should not exist (`beats = pulses/24` killed a float table).
5. **Move data AND functions into a second file** loaded via `fs_run_file`.
   This relieves the 32 KB source budget (it does NOT reduce resident heap —
   bytecode is resident either way) and lowers the single-file compile spike.
   Functions there can reference main-file globals freely (resolved at call
   time), so load order doesn't matter for definitions.
6. **`collectgarbage()` at the load-time choke points**: right after each
   `fs_run_file`, right **before `pset_read`** (rake's peak moment, ~5 KB of
   headroom recovered), and at the end of `init()` before the frame loop.

## 5. Measurement methodology (this is what actually worked)

**Desktop proxy.** Build a harness on desktop Lua that stubs the iii C API
(`arc_led`/`grid_led`, `metro`, `midi_*`, `pset_*`, `get_time`, `clamp`, …) and
`dofile`s the script. After load: `collectgarbage(); collectgarbage("count")`.
Absolute KB differ from the device (64-bit vs 32-bit) but the number **tracks
relatively** and brackets the cliff:

- Keep a table of proxy-figure → device-outcome pairs (rake's: 166.4 booted,
  167.2 OOM'd — the cliff bracketed to under 1 KB).
- **Compare against the last-known-good commit**: `git show <good>:file.lua`,
  load both in the harness, diff the counts. Never guess a feature's cost.
- **Trust the proxy's ordering for size** — if the new build measures above a
  config that OOM'd, it will OOM. But the proxy **cannot see shape** (§2): a
  build measuring *below* a booted config can still die if it added a big
  contiguous allocation. Check both.

**On-device breadcrumbs.** When an OOM does happen, bisect the boot:
`print("hp1") mem()` after compile, after data load, after big allocations,
after function defs, after `pset_read`, after final GC. The last breadcrumb
printed before `-- out of memory!` names the dying phase. Remove them after
diagnosis (they cost source bytes).

**Budget rule that emerged:** know your cliff number on the proxy scale, and
keep the measured figure at least ~2 KB under it. Measure BEFORE flashing;
if within a KB of the line, reclaim first, then add the feature.

## 6. Boot/steady profile of a healthy script (rake, for calibration)

| phase | mem() | delta |
|---|---|---|
| after main-file compile + pset_init | 140.0 | — |
| after data file (byte strings) | 140.4 | +0.4 |
| after banks (10×32 per-field ×3) | 148.3 | +7.9 |
| after all function definitions | 156.1 | +7.8 |
| after `pset_read` (**peak**) | 163.4 | +7.3 |
| steady after final GC | 157.8 | −5.6 |

Notable: packed **data is nearly free** (+0.4); **function definitions cost as
much as the data structures** (~8 KB — every global closure + bytecode);
**the pset parse is the peak**.

## 7. Odds and ends that bit us

- The frame loop should allocate **nothing** (preallocate and reuse all
  scratch); GC pauses cause audible/visible hitches and churn fragments.
- String ops in hot paths are fine **if read-only** (`:byte`, `:sub` on
  constants); never *build* strings per frame.
- pcall-guard every callback (`metro`, `event_*`) so errors print instead of
  the script dying silently — an OOM mid-callback otherwise looks like a hang.
- After renaming a script, its `pset_init` name changes → old saved state is
  orphaned; the old pset file still occupies flash and its parse cost vanishes
  (a rename is accidentally a fresh-state test).
- Re-running a script without a power cycle allocates fresh timers/state each
  time (stock iii scripts behave the same) — always reset before re-running,
  or memory numbers lie.
- 60 fps × ~100 iterations of simple per-frame work is fine CPU-wise on the
  RP2040; memory, not CPU, is the binding constraint at this scale.

## 8. Suggested attack plan for a script with memory issues

1. Build/borrow the desktop harness; get the proxy number for the current tree
   and for the last commit that booted (if any). Bracket the cliff.
2. If it OOMs on-device now: add `mem()` breadcrumbs, flash once, identify the
   dying phase.
3. Inventory the heap: count tables (`grep`-able constructors), find per-item
   table populations, permanent-but-rarely-used tables, derivable tables,
   incremental fills of big arrays.
4. Apply §4 levers in order of payoff; **measure after each** on the proxy.
5. Re-check the 32 KB source budget after edits (comments count); split into a
   second `fs_run_file` file if needed.
6. Add `collectgarbage()` at the §4.6 choke points if absent.
7. Verify behavior with a regression suite run under the harness — memory
   refactors (especially table→string and per-field restructures) touch many
   access sites; tests catch the strays. Flash, confirm boot, record `mem()`.
