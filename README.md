# kria iii

4 track midi step sequencer for [monome grid](https://monome.org/docs/grid/) running on the [iii scripting environment](https://github.com/monome/iii).

based on the original [ansible kria](https://monome.org/docs/ansible/kria/) by monome, adapted for midi output with additional features.

## files

- **kria_iii.lua** — the script to upload to iii
- **kria_iii_manual.html** — open in a browser for the full manual
   https://aktsom.github.io/kria_iii/kria_iii_manual.html


## features

- 4 tracks, 16 steps, 4 parameter pages: trigger, note, octave, duration
- trigger ratcheting — up to 5 individually toggled sub-triggers per step
- alternate note — second note sequence with its own loop and clock division
- per-track loop with wrap-around, 5 direction modes, clock division
- per-step probability and note quantization mode
- 16 scale presets with editable intervals, live micro-adjust
- 16 pattern slots with flash persistence and quantized cueing
- internal tempo control (30-300bpm) and external MIDI clock input
- configurable MIDI channel per track, MIDI clock output

## what's new in v1.4.0

* **probability expanded to 5 rows** - 100 / 75 / 50 / 25 / 0%. now deterministic: each level follows a fixed 4-loop cycle rather than random rolls, so patterns are predictable
* **white-key root selection with sharps** - scale page root now uses a piano-style layout. press a white key for natural, press again to sharpen (C# D# F# G# A#). sharp root blinks while active
* **sharp root shortcut** - hold step 16 on the scale page + press any root key to toggle sharp immediately, without double-tapping. useful when changing root live
* **velocity page** - per-step velocity control added as a second-press sub-page on the octave button (blinks when active)
* **duration page** improved behaviour
* **muted tracks dim** - muted tracks are always visible but dimmed on all pages. loop brace, triggers and playhead remain readable at reduced brightness
* **loop snap** - config toggle (step 14, row 3) for quantized loop setting. when on, a new loop is held as a pending snap and fires when a running track long enough to contain it completes a cycle, keeping loop changes in sync
* **pattern load feedback** - saved pattern slots now light up at the same moment as the load confirmation, making the visual feedback clear and instant
* **idle animation** - buttons continue to blink and animate when transport is stopped, so the grid stays informative while editing
* **ui improvements** - cleaner visual feedback across pattern, navigation, and scale pages
## requirements

- designed for monome grid one (128). should work on grid zero (256) using the top 8 rows — untested.
- iii scripting environment

## usage

upload `kria_iii.lua` via the iii web interface. See `kria_iii_manual.html` for full documentation.

## version

v1.4.0
