-- kria iii v1.7.0 display (load via fs_run_file from kria_iii.lua)
function dnav()
for t=1,4 do gl(t,8,mute[t] and(t==at and M or 1)or(t==at and BF or 5)) end
for i=1,4 do gl(5+i,8,((vm==11 and i==1)or(vm==12 and i==2)or(vm==13 and i==3))and(blk and BF or D)or vm==i and BF or D) end
gl(11,8,mlh and BF or D)
gl(12,8,mth and BF or D)
gl(13,8,mph and BF or D)
gl(15,8,(vm==6) and BF or D)
gl(16,8,tr2 and(cbt==0 and BF or(cpls and M or D))or(vm==7 and BF or D))
end
function dtr()
for t=1,4 do
local mu=mute[t] local sel=(t==at)
for s=1,STEPS do
local b
if s==ph[t] and tr2 then b=mu and 9 or BF
elseif inl(t,s) then
if tr[t][s] then b=mu and (sel and 7 or 4) or (sel and 12 or M)
else b=mu and (sel and 2 or 1) or (sel and D or 1) end
else b=tr[t][s] and 2 or F end
gl(s,t,b)
end
end
gl(6,7,D)
gl(7,7,D)
gl(15,7,tr2 and BF or D)
gl(16,7,D)
end
function dno()
local np=tclk[at] and nph[at] or ph[at]
local il=inl
for r=1,7 do
local si2=(7-r)+1
for s=1,STEPS do
local b
local hn=no[at][s]==si2
local ht=tr[at][s]
local iph=tr2 and s==np
if hn and (ht or not nsyn) then
if iph then b=BF elseif il(at,s) then b=ht and H or D else b=ht and M or D end
elseif iph then b=D elseif r==7 then b=(not nsyn and ht) and D or 1 else b=F end
gl(s,r,b)
end
end
end
function dano()
for r=1,7 do
local av=7-r
for s=1,STEPS do
local b
local iph=tr2 and s==aph[at]
local itr=tr[at][s]
if an2[at][s]==av and itr then
if iph then b=BF elseif ainl(at,s) then b=H else b=M end
else
if iph then b=D elseif r==7 and itr then b=1 else b=F end
end
gl(s,r,b)
end
end
end
function dve()
local t=at
for s=1,STEPS do
local iph=tr2 and s==ph[t]
local itr=tr[t][s]
local vr=8-(ve[t][s] or 6)
for r=1,7 do
local b
if r==vr and itr then
if iph then b=BF elseif inl(t,s) then b=H else b=M end
elseif iph then b=D
else b=F end
gl(s,r,b)
end
end
end
function doc()
for x=1,16 do gl(x,1,F) end
for c=1,8 do gl(c,1,(c==go2[at]) and BF or D) end
for s=1,STEPS do
local sel=oc[at][s] local iph=(tr2 and s==ph[at]) local itr=tr[at][s]
for r=2,7 do
local b local inf
if sel<5 then inf=(r>=sel and r<=5)
elseif sel>5 then inf=(r>=5 and r<=sel)
else inf=(r==5) end
if r==sel then
if iph then b=BF elseif itr then b=H else b=F end
elseif inf then
if iph then b=M elseif itr then b=D else b=F end
else
if r==5 then
if sel==5 then
if iph then b=BF elseif itr then b=H else b=1 end
else b=iph and D or 1 end
else b=iph and D or F end
end
gl(s,r,b)
end
end
end
function ddu()
for s=1,STEPS do
local sel=du[at][s] local iph=(tr2 and s==ph[at]) local itr=tr[at][s]
for r=1,7 do
local b
if r==1 then
if s==gdu[at] then b=BF else b=F end
else
if itr and r<=7-sel then
if iph then b=BF else b=M end
elseif iph and r==2 then b=BF
else b=F end
end
gl(s,r,b)
end
end
end
function drch()
for s=1,STEPS do
local nd=rdv[at][s] or 1
local iph=(tr2 and s==ph[at]) local itr=tr[at][s]
gl(s,1,iph and M or D)
for r=2,6 do
local slot=7-r
local b
if slot<=nd then
if itr then
if rget(at,s,slot) then
if iph then b=BF else b=H end
else
if iph then b=BF else b=3 end
end
else b=F end
else b=iph and 1 or F end
gl(s,r,b)
end
gl(s,7,iph and M or D)
end
end
function dsc()
if sch then
for x=1,16 do gl(x,sch,(x==TCH[sch]) and BF or D) end
for t=1,4 do if t~=sch then gl(1,t,t==at and M or D) end end
else
for t=1,4 do gl(1,t,t==at and M or D) end
end
for t=1,4 do
if t~=sch then
gl(2,t,tclk[t] and BF or (t==at and M or D))
for c=4,8 do gl(c,t,(sdir[t]==c-3) and BF or (t==at and M or D)) end
end
end
for i=1,8 do gl(i,6,(i==asd or scfl==i) and BF or D) end
for i=1,8 do gl(i,7,(i+8==asd or scfl==i+8) and BF or D) end
local ro=(sr-48)%12
for i=1,7 do
local o=WK:byte(i) local c=8+i
if ro==o then gl(c,7,BF)
elseif ro==o+1 and i~=3 and i~=7 then gl(c,7,blk and BF or D)
else gl(c,7,F) end
end
gl(16,7,shphl and BF or D)
for r=1,6 do
if r~=sch then
local idx=7-r
local iv=si[idx]
local ni=8-r
local adj=sadj[ni] or 0
for c=9,16 do
local s2=c-9
if s2==iv then gl(c,r,BF)
elseif adj~=0 and s2==(iv+adj)%8 then gl(c,r,D)
elseif s2==0 then gl(c,r,1)
else gl(c,r,F) end
end
end
end
end
function dprb()
for s=1,STEPS do
local p=prb[at][s] or 5
local sel=6-p
local iph=tr2 and s==ph[at]
local itr=tr[at][s]
for r=1,5 do
local b
if r==sel then
if iph then b=BF elseif itr then b=H else b=D end
elseif r>sel then
if iph then b=M else b=D end
else b=iph and D or F end
gl(s,r,b)
end
end
end
function dpat()
if pflash>0 then pflash=pflash-1 end
for p=1,NP do
local b
if pflash>0 then b=BF
elseif p==ap then b=psx[p] and H or M
elseif cued and p==cued then b=9
elseif psx[p] then b=4 else b=1 end
gl(p,1,b)
end
if cclk<1 then cclk=1 end
local cpos=ccc%cclk
for x=1,16 do
local b=F
if tr2 and x==cpos+1 then b=13
elseif x==cclk then b=4
elseif x<=cclk then b=1 end
gl(x,2,b)
end
gl(1,7,D)
gl(2,7,pclh and H or 1)
gl(3,7,D)
gl(6,7,D) gl(7,7,D)
gl(15,7,tr2 and BF or D)
gl(16,7,D)
end
function dcfg()
local nb=nsyn and H or D
for r=3,6 do for c=2,5 do
if r==3 or r==6 or c==2 or c==5 then gl(c,r,nb) end
end end
gl(7,7,blk and BF or D)
gl(12,3,lsyn==1 and BF or D)
gl(14,3,lsnap and BF or 1)
for c=11,14 do gl(c,6,lsyn==2 and BF or D) end
gl(9,8,tie and BF or D)
end
function dtim()
local pb=cbt==0 and BF or D
if ms then
gl(8,1,pb)
local db=clamp(math.floor(1+(60*sp/(cpd*24)-30)/270*15),1,16)
for x=1,16 do gl(x,2,x==db and BF or D) end
local dc=(sp==12 and 6 or sp==8 and 7 or sp==6 and 8 or sp==4 and 9 or sp==3 and 10 or sp==2 and 11 or 0)
for x=6,11 do gl(x,3,x==dc and BF or D) end
else
gl(8,1,pb)
for x=1,16 do gl(x,2,(x==tro+1) and BF or D) end
for x=1,16 do gl(x,3,(x==tfi+1) and BF or D) end
gl(7,4,D) gl(8,4,D) gl(9,4,D) gl(10,4,D)
end
gl(6,7,blk and BF or D)
end
function dlp()
local nm=vm==12
for t=1,4 do
local lw=nm and als[t] or ls[t]
local lx=nm and ale[t] or le[t]
local wr=liw(t) if nm then wr=aliw(t) end
local sel=(t==at) local mu=mute[t]
for s=1,STEPS do
local b local iep=(s==lw or s==lx) local iin
if wr then iin=(s>lw or s<lx) else iin=(s>lw and s<lx) end
local sph=nm and aph[t] or ph[t]
local itr=tr[t][s]
if tr2 and s==sph then b=mu and 9 or BF
elseif iep then
if mu then b=sel and (itr and 1 or 2) or 1
else b=itr and (sel and 13 or M) or (sel and D or 1) end
elseif iin then
if itr then b=mu and (sel and 7 or 4) or (sel and 13 or M)
else b=mu and (sel and 2 or 1) or (sel and D or 1) end
else
b=itr and 1 or F
end
if lft==t and lfc==s then b=BF end
gl(s,t,b)
end
if psnap[t] then local b=blk and D or F gl(psnap[t][1],t,b) gl(psnap[t][2],t,b) end
end
end
function dtm()
for t=1,4 do
local sel=(t==at)
local dv=vm==12 and sel and adv2[t] or dv2[t]
for x=1,16 do
local b=F
if x==dv then b=sel and BF or H
else b=sel and D or 1 end
gl(x,t,b)
end
end
end
function rd()
cg("step",1)
bct=bct+1
if bct==2 then blk=not blk end
if bct>=4 then bct=0 end
grid_led_all(F)
if cfh then dcfg()
elseif tmh then dtim()
else
dnav()
if mlh then
if vm==12 and not nsyn and lsyn==0 then dano()
else dlp() end
elseif mth then dtm()
elseif mph then dprb()
elseif vm==11 then drch()
elseif vm==12 then dano()
elseif vm==13 then dve()
elseif vm==1 then dtr()
elseif vm==2 then dno()
elseif vm==3 then doc()
elseif vm==4 then ddu()
elseif vm==6 then dsc()
elseif vm==7 then dpat()
end
if alpflash then for r=1,7 do gl(als[at],r,BF) gl(ale[at],r,BF) end end
if (mlh or mth or mph) and not (mlh and vm==12 and not nsyn and lsyn==0) then
gl(6,7,D) gl(7,7,D)
gl(15,7,tr2 and BF or D) gl(16,7,D)
end
end
gr()
end
