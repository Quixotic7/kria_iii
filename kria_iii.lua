-- kria iii v1.7.0
collectgarbage("collect")
STEPS=16
tro=6 tfi=0 cpd=0.125
TCH={1,2,3,4}
MC8={0xF8} MCA={0xFA} MCC={0xFC} gcc=0
DV="\1\2\3\4\5\6\7\8\10\12\14\16\20\24\28\32"
SDF="2212221212221212221222221221221221221221221221222"
function gSDR(s) local t={} for i=1,7 do local c=SDF:byte((s-1)*7+i) t[i]=c and c-48 or 1 end return t end
SD={} for i=1,7 do SD[i]=gSDR(i) end
local _c=gSDR(8) for i=8,16 do SD[i]=_c end
F=0 D=5 M=9 H=13 BF=15
ODR=5
NP=16
DM={16,14,12,10,8,4,2,1,.75,.625,.5,.375,.25,.187,.125,.0625}
VL="\20\40\60\80\95\112\127"
PP="00001000101011101111"
WK="\0\2\4\5\7\9\11"
sr=48 si={2,2,1,2,2,2,1} asd=1 cs={}
sadj={0,0,0,0,0,0,0}
shk=nil
gl=grid_led gr=grid_refresh cg=collectgarbage mr=math.random tu=table.unpack SC=string.char mx=math.max

function bsc()
cs[1]=sr
for i=2,7 do cs[i]=cs[i-1]+si[i-1] end
for i=8,14 do cs[i]=cs[i-7]+12 end
for i=15,21 do cs[i]=cs[i-14]+24 end
end
function rget(t,s,i) return rsl[t][s] & (1 << (i-1)) ~= 0 end
function rset(t,s,i,v)
if v then rsl[t][s] = rsl[t][s] | (1 << (i-1))
else rsl[t][s] = rsl[t][s] & ~(1 << (i-1)) end
end
function ucpd() local b=tro<7 and 30+tro*15 or 120+(tro-6)*20 cpd=15/(b+tfi) if tr2 and not ms then icl.time=cpd/sp end end
function nls(t,s)
local r=du[t][s] or 0 local m=DM[17-gdu[t]] or 1
local frac=r==0 and 0.1 or r/5
return mx(cpd*DV:byte(dv2[t] or 1)*frac*m,.02)
end
function aliw(t) return als[t]>ale[t] end
function ainl(t,s)
if aliw(t) then return s>=als[t] or s<=ale[t] else return s>=als[t] and s<=ale[t] end
end
function allen(t)
if aliw(t) then return STEPS-als[t]+ale[t]+1 else return ale[t]-als[t]+1 end
end
function gnxs(t,p,sw,ew,wfn,lfn,dr)
local s=p[t] or 1
local d=sdir[t] or 1
if dr[t]==nil then dr[t]=1 end
if d==1 then
s=s+1
if wfn(t) then
if s>STEPS then s=1 end
if s>ew[t] and s<sw[t] then s=sw[t] end
else
if s>ew[t] or s>STEPS then s=sw[t] end
end
elseif d==2 then
s=s-1 if s<1 then s=STEPS end
if wfn(t) then if s>ew[t] and s<sw[t] then s=ew[t] end
else if s<sw[t] or s>ew[t] then s=ew[t] end end
elseif d==3 then
s=s+dr[t]
if s>ew[t] then s=ew[t] dr[t]=-1
elseif s<sw[t] then s=sw[t] dr[t]=1 end
elseif d==4 then
dr[t]=(mr(2)==1) and 1 or -1 s=s+dr[t]
if wfn(t) then
if s<1 then s=STEPS end if s>STEPS then s=1 end
if s>ew[t] and s<sw[t] then s=sw[t] end
else
if s<sw[t] then s=ew[t] elseif s>ew[t] then s=sw[t] end
end
elseif d==5 then
s=sw[t]+mr(lfn(t))-1
if wfn(t) and s>STEPS then s=s-STEPS end
end
return s
end
function anxs(t) return gnxs(t,aph,als,ale,aliw,allen,addr) end
function adva(t)
adc[t]=(adc[t] or 0)+1
if adc[t]<DV:byte(adv2[t] or 1) then return end
adc[t]=0
aph[t]=anxs(t)
end
function mnf(t,s)
local ni=no[t][s] or 1
local as=aph[t] or 1
local av=an2[t][as] or 0
ni=((ni-1)+av)%7+1
local adj=sadj[((ni-1)%7)+1] or 0
return clamp((cs[ni] or sr)+adj+(5-(oc[t][s] or 5))*12+((go2[t] or 3)-3)*12,0,127)
end
function son(t,s)
if mute[t] then return end
local mn=mnf(t,s)
local prev=an[t] nom[t]:stop()
if not tie and prev>=0 then midi_note_off(prev,0,TCH[t]) end
midi_note_on(mn,VL:byte(ve[t][s] or 6),TCH[t]) an[t]=mn nom[t]:start(nls(t,s))
if tie and prev>=0 and prev~=mn then midi_note_off(prev,0,TCH[t]) end
end
function sof(t)
if an[t]>=0 then midi_note_off(an[t],0,TCH[t]) an[t]=-1 nom[t]:stop() end
end
function ano() for t=1,4 do ram[t]:stop() rsc[t]=0 sof(t) end end
function liw(t) return ls[t]>le[t] end
function inl(t,s)
if liw(t) then return s>=ls[t] or s<=le[t] else return s>=ls[t] and s<=le[t] end
end
function llen(t)
if liw(t) then return STEPS-ls[t]+le[t]+1 else return le[t]-ls[t]+1 end
end
function nxs(t) return gnxs(t,ph,ls,le,liw,llen,ddr) end
pld=false
function advnph(t)
local s=nph[t]+1
if liw(t) then
if s>STEPS then s=1 end
if s>le[t] and s<ls[t] then s=ls[t] end
else if s>le[t] or s>STEPS then s=ls[t] end end
nph[t]=s
end
function adv(t)
dc[t]=(dc[t] or 0)+1
if dc[t]<DV:byte(dv2[t] or 1) then return false end
dc[t]=0
if not pld then
ph[t]=nxs(t) adva(t)
local d2=sdir[t] or 1
if (d2==2 and ph[t]==le[t]) or (d2~=2 and ph[t]==ls[t]) then
lc[t]=(lc[t]+1)%4
local tl=llen(t) local ml=0 for i=1,4 do local l=llen(i) if l>ml then ml=l end end
for tt=1,4 do if psnap[tt] then local sl=(psnap[tt][2]-psnap[tt][1]+STEPS)%STEPS+1 if tl>=sl or tl>=ml then ls[tt]=psnap[tt][1] le[tt]=psnap[tt][2] ph[tt]=psnap[tt][1] psnap[tt]=nil end end end
end
end
if mute[t] then sof(t) return true end
if tr[t][ph[t]] then
if PP:byte((prb[t][ph[t]] or 5)*4+lc[t]-3)==49 then
local nd=rdv[t][ph[t]] or 1
local ns=tclk[t] and nph[t] or ph[t]
if nd<=1 then
if rget(t,ph[t],1) then son(t,ns) if tclk[t] and not pld then advnph(t) end end
else
sof(t) rsc[t]=0
local ri=mx(cpd/nd,.02)
rsc[t]=1
if rget(t,ph[t],1) then son(t,ns) if tclk[t] and not pld then advnph(t) end end
if nd>1 then ram[t]:start(ri) end
end
end
end
return true
end
function tka()
if not tr2 then return end
if not ms then midi_out(MC8) cp=cp+1 if cp<sp then return end cp=0 end
cpls=not cpls
cbt=(cbt+1)%4
gcc=gcc+1
if gcc>=64 then gcc=0 cg("step",1) end
local upd=cbt==0
for t=1,4 do if adv(t) then upd=true end end
pld=false
if cman then
ccc=ccc+1
if ccc>=cclk then
if cued then ldp(cued,false) cued=nil end
ccc=0
end
else
local mx2=0
for t=1,4 do
local len=llen(t)*DV:byte(dv2[t] or 1)
if len>mx2 then mx2=len clt=t end
end
cclk=llen(clt)
cdc=cdc+1
if cdc>=DV:byte(dv2[clt] or 1) then
cdc=0
ccc=ccc+1
if ccc>=cclk then
if cued then ldp(cued,false) cued=nil end
ccc=0
end
end
end
if upd then rd() end
end
function event_midi(b1,b2,b3)
if b1==0xF8 then
if not tr2 or not ms then return end
local now=get_time() table.insert(pt,now)
if #pt>PB then table.remove(pt,1) end
if not ms then ms=true icl:stop() cp=0 for t=1,4 do dc[t]=0 adc[t]=0 end end
if #pt>=2 then cpd=((pt[#pt]-pt[1])/(#pt-1))*sp end
cp=cp+1 if cp>=sp then cp=0 tka() end
elseif b1==0xFA or b1==0xFB then
if tr2 and not ms then return end
ms=true tr2=true icl:stop() idl:stop() cp=0 pt={} cbt=0 cpls=false ccc=0
for t=1,4 do lc[t]=0 end
for t=1,4 do
ph[t]=(sdir[t]==2 and le[t] or ls[t]) dc[t]=0 aph[t]=(sdir[t]==2 and ale[t] or als[t]) adc[t]=0 nph[t]=ls[t]
if tr[t][ph[t]] then son(t,ph[t]) else sof(t) end
end
rd()
elseif b1==0xFC then if not ms then return end tr2=false ms=false pt={} ucpd() ano() idl:start()
for t=1,4 do ph[t]=(sdir[t]==2 and le[t] or ls[t]) aph[t]=(sdir[t]==2 and ale[t] or als[t]) nph[t]=ls[t] lc[t]=0 end
rd()
end
end
function cap()
local b={} local r={}
for t=1,4 do
for s=1,STEPS do
r[s]=SC((tr[t][s] and 1 or 0),no[t][s],oc[t][s],du[t][s],prb[t][s],rdv[t][s],rsl[t][s],an2[t][s]+50)
end
r[17]=SC(ph[t],ls[t],le[t],dv2[t],aph[t],als[t],ale[t],adv2[t])
b[t]=table.concat(r,"",1,17)
end
b[5]=SC(sr,asd,si[1],si[2],si[3],si[4],si[5],si[6],si[7])
b[6]=SC(go2[1],go2[2],go2[3],go2[4],gdu[1],gdu[2],gdu[3],gdu[4],sdir[1],sdir[2],sdir[3],sdir[4],mute[1] and 1 or 0,mute[2] and 1 or 0,mute[3] and 1 or 0,mute[4] and 1 or 0)
local n=0
for t=1,4 do for s=1,STEPS do n=n+1 r[n]=SC(ve[t][s]) end end
b[7]=table.concat(r,"",1,n)
b[8]=SC(tclk[1] and 1 or 0,tclk[2] and 1 or 0,tclk[3] and 1 or 0,tclk[4] and 1 or 0,nsyn and 1 or 0,lsyn,lsnap and 1 or 0)
n=0
for p=1,16 do local sp=SD[p] for i=1,7 do n=n+1 r[n]=SC(sp[i] or 1) end end
b[9]=table.concat(r,"",1,n)
b[10]=SC(tie and 1 or 0)
return table.concat(b,"",1,10)
end
function rst(d)
if type(d)~="string" then return end
local B=string.byte
for t=1,4 do
local tb=(t-1)*136
for s=1,STEPS do
local o=tb+(s-1)*8
tr[t][s]=B(d,o+1)==1
no[t][s]=B(d,o+2)
local ov=B(d,o+3)
if ov<2 or ov>7 then ov=ODR end
oc[t][s]=ov
local dv=B(d,o+4)
if dv>5 then dv=1 end
du[t][s]=dv
prb[t][s]=clamp(B(d,o+5) or 5,1,5)
rdv[t][s]=clamp(B(d,o+6) or 1,1,5)
rsl[t][s]=B(d,o+7) or 1
an2[t][s]=clamp((B(d,o+8) or 50)-50,0,6)
end
local b=tb+128
ph[t]=clamp(B(d,b+1) or 1,1,STEPS)
ls[t]=clamp(B(d,b+2) or 1,1,STEPS)
le[t]=clamp(B(d,b+3) or STEPS,1,STEPS)
dv2[t]=clamp(B(d,b+4) or 1,1,16)
aph[t]=clamp(B(d,b+5) or 1,1,STEPS)
als[t]=clamp(B(d,b+6) or 1,1,STEPS)
ale[t]=clamp(B(d,b+7) or STEPS,1,STEPS)
adv2[t]=clamp(B(d,b+8) or 1,1,16)
ddr[t]=1 dc[t]=0 adc[t]=0 addr[t]=1 nph[t]=ls[t]
end
local g=544
sr=B(d,g+1) asd=B(d,g+2)
for i=1,7 do si[i]=B(d,g+2+i) end SD[asd]={tu(si)}
local q=g+9
for t=1,4 do go2[t]=clamp(B(d,q+t),1,8) gdu[t]=clamp(B(d,q+4+t),1,16) sdir[t]=clamp(B(d,q+8+t),1,5) mute[t]=B(d,q+12+t)==1 end
if #d>=633 then for t=1,4 do for s=1,STEPS do ve[t][s]=clamp(B(d,570+(t-1)*16+(s-1)) or 6,1,7) end end end
if #d>=637 then for t=1,4 do tclk[t]=B(d,633+t)==1 end end
if #d>=639 then nsyn=B(d,638)==1 lsyn=B(d,639) end
if #d>=640 then lsnap=B(d,640)==1 end
if #d>=752 then for p=1,16 do SD[p]={} for i=1,7 do SD[p][i]=B(d,640+(p-1)*7+i) end end si={tu(SD[asd])} end
if #d>=753 then tie=B(d,753)==1 end
if asd<1 or asd>16 then asd=1 end
bsc() crs() scph=nil shk=nil
end
function ldp(p,sync)
if pats[p] then rst(pats[p])
else
for t=1,4 do
for s=1,STEPS do
tr[t][s]=false no[t][s]=1 oc[t][s]=ODR du[t][s]=5 prb[t][s]=5
rdv[t][s]=1 rsl[t][s]=1 an2[t][s]=0 ve[t][s]=6
end
ph[t]=1 ls[t]=1 le[t]=STEPS dv2[t]=1 dc[t]=0
aph[t]=1 als[t]=1 ale[t]=STEPS adv2[t]=1 adc[t]=0 addr[t]=1 nph[t]=1 tclk[t]=false
end
end
ap=p if sync~=false then ccc=0 end
if sync~=false then ano() end
for t=1,4 do ram[t]:stop() rsc[t]=0 end
for t=1,4 do ph[t]=(sdir[t]==2 and le[t] or ls[t]) aph[t]=(sdir[t]==2 and ale[t] or als[t]) adc[t]=0 nph[t]=ls[t]
if sync==false then dc[t]=0 sof(t) if tr[t][ph[t]] then son(t,ph[t]) end
else dc[t]=DV:byte(dv2[t] or 1)-1 end end
if sync~=false then pld=true end
end
function svp(p)
pats[p]=nil cg("collect")
pats[p]=cap() psx[p]=true
cg("collect")
end
function crs() for i=1,7 do sadj[i]=0 end end
function pinit() if not psi then pset_init("ki") psi=true end end
function hx(s) return(s:gsub(".",function(c) return string.format("%02x",c:byte())end))end
function dhx(s) return(s:gsub("..",function(h) return SC(tonumber(h,16))end))end
function fsave(p)
pinit()
if pats[p] then pcall(pset_write,p,hx(pats[p])) end
end
function fload()
pinit()
for p=1,NP do
pats[p]=nil cg("collect")
local ok,d=pcall(pset_read,p)
if ok and d and type(d)=="string" and #d>=1138 then pats[p]=dhx(d) psx[p]=true end
end
cg("collect")
end
function fsaveall()
pinit()
pcall(svp,ap)
for p=1,NP do
if pats[p] then pcall(pset_write,p,hx(pats[p])) end
cg("collect")
end
end
if not pcall(fs_run_file,"kria_iii_gfx.lua") then print("missing kria_iii_gfx.lua - upload it too") end
cg("collect")
function pts()
if tr2 then tr2=false ano() idl:start()
if not ms then icl:stop() midi_out(MCC) end
for t=1,4 do ph[t]=(sdir[t]==2 and le[t] or ls[t]) aph[t]=(sdir[t]==2 and ale[t] or als[t]) nph[t]=ls[t] lc[t]=0 end
else tr2=true cbt=0 cpls=false ccc=0
for t=1,4 do ph[t]=(sdir[t]==2 and le[t] or ls[t]) dc[t]=DV:byte(dv2[t] or 1)-1 aph[t]=(sdir[t]==2 and ale[t] or als[t]) adc[t]=0 nph[t]=ls[t] lc[t]=0 end
pld=true idl:stop()
if not ms then ucpd() icl:stop() cp=0 icl:start(cpd/sp) midi_out(MCA) end
end
rd()
end
function rts()
ccc=0
for t=1,4 do ph[t]=(sdir[t]==2 and le[t] or ls[t]) dc[t]=0 aph[t]=(sdir[t]==2 and ale[t] or als[t]) adc[t]=0 nph[t]=ls[t] lc[t]=0 end
if tr2 then
for t=1,4 do if not mute[t] and tr[t][ph[t]] then son(t,ph[t]) end end
cp=0 if not ms then icl:stop() icl:start(cpd/sp) end
end
rd()
end
function tadj(k)
local d=k==7 and -4 or k==8 and -1 or k==9 and 1 or 4
tfi=tfi+d
if tfi>15 then if tro<15 then tro=tro+1 tfi=0 else tfi=15 end
elseif tfi<0 then if tro>0 then tro=tro-1 tfi=15 else tfi=0 end end
ucpd() rd()
end
function event_grid(x,y,z)
if y==8 then
if x==11 then
mlh=(z==1)
if z==0 then lfc=nil lft=nil end
rd() return
end
if x==12 then mth=(z==1) rd() return end
if x==13 then mph=(z==1) rd() return end
if x==15 then
if z==1 then
blk=false
if vm~=6 then pvm=vm vm=6 else vm=pvm end
end
rd() return
end
if x==16 then
if z==1 then
blk=false
vm=7 pth=true
else pth=false end
rd() return
end
if z==0 then
if x>=1 and x<=4 then cpt=nil clrt=nil shm:stop() end
return
end
if mlh and x>=1 and x<=4 then
mute[x]=not mute[x]
if mute[x] then sof(x) end
rd() return
end
if (mth or mph) and x>=1 and x<=4 then rd() return end
if x>=1 and x<=4 then
if cpt and cpt~=x then
if vm==1 then
for s=1,STEPS do tr[x][s]=tr[cpt][s] end
elseif vm==11 then
for s=1,STEPS do tr[x][s]=tr[cpt][s] rsl[x][s]=rsl[cpt][s] rdv[x][s]=rdv[cpt][s] end
elseif vm==2 then
for s=1,STEPS do no[x][s]=no[cpt][s] tr[x][s]=tr[cpt][s] end
elseif vm==12 then
for s=1,STEPS do no[x][s]=no[cpt][s] tr[x][s]=tr[cpt][s] an2[x][s]=an2[cpt][s] end
elseif vm==3 then
for s=1,STEPS do oc[x][s]=oc[cpt][s] end
elseif vm==13 then
for s=1,STEPS do ve[x][s]=ve[cpt][s] end
elseif vm==4 then
for s=1,STEPS do du[x][s]=du[cpt][s] end
end
at=x cpt=nil clrt=nil shm:stop() rd()
gl(x,8,BF) gr()
return
end
at=x cpt=x
if vm>=1 and vm<=4 or vm==11 or vm==12 or vm==13 then clrt=x shm:stop() shm:start(2.0) end
elseif x==6 then
if vm==1 then vm=11
elseif vm==11 then vm=1 blk=false
else blk=false vm=1 end
elseif x==7 then
if vm==2 then vm=12
elseif vm==12 then vm=2 blk=false
else blk=false vm=2 end
elseif x==8 then
if vm==3 then vm=13
elseif vm==13 then vm=3 blk=false
else blk=false vm=3 end
elseif x==9 then
if cfh then tie=not tie else blk=false vm=4 end
end
rd() return
end
if (mlh or mth or mph) and y==7 and not (mlh and vm==12 and not nsyn and lsyn==0) then
if x==7 then if z==1 then cfh=not cfh if cfh then tmh=false thk=nil shm:stop() end end rd() return end
if x==6 then if z==1 then tmh=not tmh if tmh then cfh=false else thk=nil shm:stop() end end rd() return end
if x==15 and z==1 then pts() return end
if x==16 and z==1 then rts() return end
end
if mlh then
if vm==12 and not nsyn and lsyn==0 then
if z==1 and y>=1 and y<=7 and x>=1 and x<=STEPS then
if lft==nil then
lft=at lfc=x als[at]=x ale[at]=x
else
als[lft]=lfc ale[lft]=x
if not ainl(lft,aph[lft]) then aph[lft]=lfc end
lft=nil lfc=nil alpflash=true shm:stop() shm:start(0.4)
end
rd()
end
return
end
if y>=1 and y<=4 and x>=1 and x<=STEPS then
local t=y
if z==1 then
local nm=vm==12
if lft==nil then
lft=t lfc=x
if nm then if lsyn==2 then for tt=1,4 do als[tt]=x ale[tt]=x end else als[t]=x ale[t]=x end
elseif not lsnap then if lsyn==2 then for tt=1,4 do ls[tt]=x le[tt]=x end else ls[t]=x le[t]=x end end
else
local lf=lft
local snapped=false
if lsnap and not nm then
snapped=true psnap[lf]={lfc,x} lft=nil lfc=nil
end
if not snapped then
if nm then als[lf]=lfc ale[lf]=x
if not ainl(lf,aph[lf]) then aph[lf]=lfc end
else ls[lf]=lfc le[lf]=x
if not inl(lf,ph[lf]) then ph[lf]=lfc end end
end
if not snapped then
local ref=lft or t
local P1,P2=nm and als or ls,nm and ale or le
local Q1,Q2=nm and ls or als,nm and le or ale
if lsyn==2 then for tt=1,4 do P1[tt]=P1[ref] P2[tt]=P2[ref] Q1[tt]=P1[tt] Q2[tt]=P2[tt] end
else if lsyn==1 or nsyn then Q1[ref]=P1[ref] Q2[ref]=P2[ref] end end
end
end
else
if lft==t and lfc==x then if lsnap and vm~=2 and vm~=12 then psnap[lft]={x,x} end lft=nil lfc=nil end
end
rd()
end
return
end
if mth then
if z==0 then return end
if y>=1 and y<=4 and x>=1 and x<=16 then
if vm==12 and y==at then adv2[at]=x adc[at]=0
else dv2[y]=x dc[y]=0 end
rd()
end
return
end
if mph then
if z==0 then return end
if y>=1 and y<=5 and x>=1 and x<=STEPS then
prb[at][x]=6-y
rd()
end
return
end
if vm==11 then
if z==1 and (y==1 or y==7) then
if tr[at][x] then rchy=y rchx=x shm:start(HT) end
return
end
if z==0 then
if (y==1 or y==7) and rchx==x and rchy==y then
shm:stop()
if tr[at][x] then
if y==1 then
local nd=(rdv[at][x] or 1)+1
if nd>5 then nd=5 end
rdv[at][x]=nd rset(at,x,nd,true)
elseif y==7 then
local nd=(rdv[at][x] or 1)-1
if nd<1 then nd=1 end
rdv[at][x]=nd
rset(at,x,nd+1,false)
end
end
rchy=nil rchx=nil rd()
elseif rchy==y then
shm:stop() rchy=nil rchx=nil
end
return
end
if y>=2 and y<=6 and x>=1 and x<=STEPS and z==1 then
if not tr[at][x] then return end
local slot=7-y
local nd=rdv[at][x] or 1
if slot>nd then
for i=nd+1,slot-1 do rset(at,x,i,false) end
rdv[at][x]=slot
rset(at,x,slot,true)
else
rset(at,x,slot,not rget(at,x,slot))
end
rd()
end
return
end
if vm==12 then
if z==0 then return end
if y>=1 and y<=7 and x>=1 and x<=STEPS then
an2[at][x]=7-y
rd()
end
return
end
if vm==13 then
if z==0 then return end
if y>=1 and y<=7 and x>=1 and x<=STEPS then
local vv=8-y
if nsyn then
if ve[at][x]==vv and tr[at][x] then tr[at][x]=false rdv[at][x]=1 rsl[at][x]=1
else ve[at][x]=vv tr[at][x]=true end
else ve[at][x]=vv end
rd()
end
return
end
if vm==6 and z==0 then
if shk and shk[1]==y and shk[2]==x then shk=nil end
if scph and scph[1]==y and scph[2]==x then scph=nil end
if y==7 and x==16 then shphl=false rd() end
return
end
if y==7 and x==7 and (vm==1 or vm==7 or mlh or mth or mph or cfh) then
if z==1 then cfh=not cfh if cfh then tmh=false thk=nil shm:stop() end end
rd() return
end
if y==7 and x==6 and (vm==1 or vm==7 or mlh or mth or mph or tmh) then
if z==1 then tmh=not tmh if tmh then cfh=false else thk=nil shm:stop() end end
rd() return
end
if y==7 and x==15 and z==1 and (mlh or mth or mph) then pts() return end
if y==7 and x==16 and z==1 and (mlh or mth or mph) then rts() return end
if cfh then
if z==0 then return end
if y>=3 and y<=6 and x>=2 and x<=5 then
nsyn=not nsyn rd()
elseif y==3 and x==12 then
lsyn=(lsyn==1) and 0 or 1 rd()
elseif y==3 and x==14 then
lsnap=not lsnap if lsnap and lsyn==2 then lsyn=0 end rd()
elseif y==6 and x>=11 and x<=14 then
lsyn=(lsyn==2) and 0 or 2 if lsyn==2 and lsnap then lsnap=false end rd()
end
return
end
if tmh then
if not ms then
if z==1 then
if y==2 and x>=1 and x<=16 then
tro=x-1 ucpd() rd()
elseif y==3 and x>=1 and x<=16 then
tfi=x-1 ucpd() rd()
elseif y==4 and x>=7 and x<=10 then
tadj(x) thk=x shm:start(0.4)
end
elseif z==0 then
if y==4 and thk then thk=nil shm:stop() end
end
else
if z==1 and y==3 and x>=6 and x<=11 then
sp=(x==6 and 12 or x==7 and 8 or x==8 and 6 or x==9 and 4 or x==10 and 3 or 2)
cp=0 rd()
end
end
return
end
if z==0 then
if vm==7 and y==1 and phl then
if phl==x then
shm:stop()
ccc=0 cdc=0 cman=false
ldp(x) rd()
end
phl=nil
end
if vm==7 and y==7 and x==1 and fld then
fld=nil shm:stop() rd()
end
if vm==7 and y==7 and x==2 then
pclh=false rd()
end
if vm==7 and y==7 and x==3 then fsa=nil shm:stop() end
return
end
if vm==1 then
if y>=1 and y<=4 and x>=1 and x<=STEPS then
tr[y][x]=not tr[y][x]
if not tr[y][x] then rdv[y][x]=1 rsl[y][x]=1 end
rd()
elseif y==7 and x==15 then pts()
elseif y==7 and x==16 then rts()
end
elseif vm==2 then
if y>=1 and y<=7 and x>=1 and x<=STEPS then
local si2=(7-y)+1
if nsyn then
if no[at][x]==si2 and tr[at][x] then tr[at][x]=false rdv[at][x]=1 rsl[at][x]=1
else no[at][x]=si2 tr[at][x]=true end
else
no[at][x]=si2
end
rd()
end
elseif vm==3 then
if y==1 and x>=1 and x<=8 then go2[at]=x rd()
elseif y>=2 and y<=7 and x>=1 and x<=STEPS then
if nsyn then
if oc[at][x]==y and tr[at][x] then tr[at][x]=false rdv[at][x]=1 rsl[at][x]=1
else oc[at][x]=y tr[at][x]=true end
else oc[at][x]=y end
rd() end
elseif vm==4 then
if y==1 and x>=1 and x<=16 then gdu[at]=x rd()
elseif y>=2 and y<=7 and x>=1 and x<=STEPS then
local dv=7-y
if nsyn then
if du[at][x]==dv and tr[at][x] then tr[at][x]=false rdv[at][x]=1 rsl[at][x]=1
else du[at][x]=dv tr[at][x]=true end
else du[at][x]=dv end
rd() end
elseif vm==6 then
if sch and y==sch and x>=1 and x<=16 then
TCH[sch]=x sch=nil rd()
elseif y>=1 and y<=4 and x==1 and not sch then
sch=y rd()
elseif y>=1 and y<=4 and x==2 and not sch then
tclk[y]=not tclk[y] nph[y]=ls[y] rd()
elseif (y==6 or y==7) and x>=1 and x<=8 then
local slot=y==6 and x or x+8
if shphl then
SD[slot]=gSDR(slot)
if asd==slot then si={tu(SD[slot])} crs() end
elseif scph then
local src=scph[1]==6 and scph[2] or scph[2]+8
SD[slot]={tu(SD[src])}
asd=slot si={tu(SD[slot])} crs()
scfl=slot scph=nil shm:stop() shm:start(0.4)
shk=nil bsc() rd()
return
else
SD[asd]={tu(si)}
if slot~=asd then asd=slot si={tu(SD[slot])} crs() end
scph={y,x}
end
shk=nil bsc() rd()
elseif x>=4 and x<=8 and y>=1 and y<=4 then
sdir[y]=x-3 ddr[y]=1 rd()
elseif y==7 and x==16 then
shphl=true rd()
elseif y==7 and x>=9 and x<=15 then
local o=WK:byte(x-8) local wk=48+o
if shphl then
if x~=11 and x~=15 then sr=(sr==wk+1) and wk or wk+1 else sr=wk end
else
if sr==wk and x~=11 and x~=15 then sr=wk+1 elseif sr==wk+1 then sr=wk else sr=wk end
end
bsc() rd()
elseif x>=9 and x<=16 and y>=1 and y<=6 then
local idx=7-y
local ni=8-y
local nv=x-9
if shk and shk[1]==y then
sadj[ni]=nv-si[idx]
bsc() rd()
elseif shphl and idx<6 then
local d=nv-si[idx] si[idx]=nv si[idx+1]=mx(si[idx+1]-d,0)
sadj[ni]=0 SD[asd]={tu(si)} bsc() rd()
else
si[idx]=nv sadj[ni]=0 SD[asd]={tu(si)} shk={y,x} bsc() rd()
end
end
elseif vm==7 then
if y==1 and x>=1 and x<=NP then
if pclh then
pats[x]=nil psx[x]=false pcall(pset_write,x,"")
if ap==x then ap=1 end
cg("collect")
rd()
elseif pth then
cued=x rd()
else
phl=x shm:start(1.0)
end
elseif y==2 and x>=1 and x<=16 then
cclk=x cman=true rd()
elseif y==7 and x==1 then
fld=get_time() shm:stop() shm:start(2.0)
elseif y==7 and x==2 then
pclh=true rd()
elseif y==7 and x==3 then
fsa=get_time() shm:stop() shm:start(2.0)
elseif y==7 and x==15 then pts()
elseif y==7 and x==16 then rts()
end
end
end
bsc()
ap=1 pats={} psx={}
vm=1 at=1
nsyn=true lsyn=2 tie=false
mlh=false mth=false mph=false cfh=false tmh=false lfc=nil lft=nil alpflash=false
tr={} no={} oc={} du={} ph={} ls={} le={} dv2={} dc={} an={}
go2={3,3,3,3} gdu={9,9,9,9} sdir={1,1,1,1} ddr={1,1,1,1}
mute={false,false,false,false}
prb={} rdv={} rsl={}
an2={} ve={} aph={} als={} ale={} adv2={} adc={} addr={}
tclk={false,false,false,false} nph={1,1,1,1}
blk=false bct=0 shphl=false
lsnap=false psnap={}
for t=1,4 do
tr[t]={} no[t]={} oc[t]={} du[t]={} prb[t]={} rdv[t]={} rsl[t]={}
an2[t]={} ve[t]={}
ph[t]=1 ls[t]=1 le[t]=6 dv2[t]=1 dc[t]=0 an[t]=-1
aph[t]=1 als[t]=1 ale[t]=le[t] adv2[t]=1 adc[t]=0 addr[t]=1
for s=1,STEPS do
tr[t][s]=false no[t][s]=1 oc[t][s]=ODR du[t][s]=5 prb[t][s]=5
rdv[t][s]=1 rsl[t][s]=1
an2[t][s]=0 ve[t][s]=6
end
end
lc={0,0,0,0}
ms=false tr2=false cp=0 pt={} PB=8 sp=6 cpls=false cbt=0
thk=nil sch=nil cpt=nil clrt=nil fld=nil fsa=nil psi=false pclh=false
nom={}
for t=1,4 do
local tc=t
nom[t]=metro.init(function()
if an[tc]>=0 then midi_note_off(an[tc],0,TCH[tc]) an[tc]=-1 end
nom[tc]:stop()
end,0.1,1)
end
rsc={0,0,0,0}
ram={}
for t=1,4 do
local tc=t
ram[t]=metro.init(function()
local s=ph[tc]
rsc[tc]=rsc[tc]+1
if rsc[tc]>(rdv[tc][s] or 1) then ram[tc]:stop() return end
if rget(tc,s,rsc[tc]) then
local ns=tclk[tc] and nph[tc] or s
son(tc,ns) if tclk[tc] then advnph(tc) end
end
end,.1)
end
icl=metro.init(tka,.125)
icl:stop()
idl=metro.init(rd,0.25)
idl:start()
phl=nil HT=0.8 scph=nil pvm=1 scfl=nil
cued=nil cclk=16 ccc=0 cdc=0 clt=1 cman=false pth=false pflash=0
rchy=nil rchx=nil
shm=metro.init(function()
if thk then
tadj(thk)
elseif rchy~=nil and rchx~=nil then
if rchy==1 then
for s=1,STEPS do
local nd=rdv[at][s] or 1
for i=1,nd do rset(at,s,i,true) end
end
elseif rchy==7 then
rdv[at][rchx]=1 rsl[at][rchx]=1
end
rchy=nil rchx=nil shm:stop() rd()
elseif clrt then
local t=clrt
if vm==1 or vm==11 then
for s=1,STEPS do tr[t][s]=false no[t][s]=1 oc[t][s]=ODR du[t][s]=5 prb[t][s]=5 rdv[t][s]=1 rsl[t][s]=1 an2[t][s]=0 ve[t][s]=6 end
go2[t]=3 gdu[t]=9
ls[t]=1 le[t]=6 als[t]=1 ale[t]=6
dv2[t]=1 adv2[t]=1 sdir[t]=1 tclk[t]=false
sof(t) ram[t]:stop() rsc[t]=0
ph[t]=1 aph[t]=1 nph[t]=1 dc[t]=0 adc[t]=0 lc[t]=0 addr[t]=1
elseif vm==2 or vm==12 then
for s=1,STEPS do no[t][s]=1 tr[t][s]=false end
elseif vm==3 then
for s=1,STEPS do oc[t][s]=ODR end go2[t]=3
elseif vm==4 then
for s=1,STEPS do du[t][s]=5 end gdu[t]=9
elseif vm==13 then
for s=1,STEPS do ve[t][s]=6 end
end
clrt=nil shm:stop() rd()
gl(t,8,BF) gr()
elseif phl and vm==7 then
local ok=pcall(svp,phl)
if ok then ap=phl pflash=3 end
shm:stop() phl=nil rd()
elseif fld or fsa then
if fld then fload() pflash=3 rd() end
if fsa then fsaveall() pflash=3 fsa=nil rd() end
shm:stop()
elseif alpflash then alpflash=false shm:stop() rd()
elseif scfl then scfl=nil shm:stop() rd()
else shm:stop() end
end,0.4)
shm:stop()
grid_led_all(F)
tr2=false
cg("collect")
rd()
function cleanup() ano() end
