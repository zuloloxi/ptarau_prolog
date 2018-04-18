wi(W,I):-
 w(W,Is),
 member(I,Is).
   
w2i([W|Ws],I):-
  wi(W,I),
  i2w(I,[W|Ws]).

% see cw2is !!!
  
% Ws are in decreasing order by length and increasing order by IdNum
  
w2itn([W|Ws],I,Type,IdNum):-
  wi(W,I),
  i2wtn(I,[W|Ws],Type,IdNum).  

w2t(WWs,T):-
  w2i(WWs,I),
  i2t(I,T).

w2w(Ws,SimWs):-w2w(Ws,SimWs,_I,_T).

w2w(Ws,SimWs,I,T):-w2itn(Ws,I,T,_),i2wtn(I,SimWs,T,_).

w2wx(Ws,SimWs,I,T):-w2w(Ws,SimWs,I,T),Ws\==SimWs.

% coordinate terms: share a hypernym
w2c(Ws,Cs,J,T):-w2w(Ws,SimWs,I,T),(Cs=SimWs,J=I;coord(I,J),J=\=I,i2wtn(J,Cs,T,_)).
  
i2w(I,WWs):-i2wtn(I,WWs,_,_).

i2wtn(I,WWs,T,N):-
  i(I,Fs),
  f2w(Fs,WWs,T,N).

i2t(I,T):-i(I,Fs),f2t(Fs,T).

f2t([F|_],T):-arg(3,F,T0),ss_type(T0,T).

f2w(Fs,WWs,T,N):-  
  member(f(N,WWs,T0,_,_),Fs),
  ss_type(T0,T).

w2itf([W|Ws],I,T,Freq):-
  wi(W,I),
  i2wtf(I,[W|Ws],T,Freq).

i2wtf(I,WWs,T,Freq):-
  i(I,Fs),
  member(f(_,WWs,T0,_,Freq),Fs),
  ss_type(T0,T).
  
f2ws(Fs,T,N,Wss):-
  (var(N)->N=10000;true),
  map(words_of_type(T,N),Fs,Wss).

words_of_type(T,N,f(N0,WWs,T0,_,_),N0/WWs):-
  N0<N,
  ss_type(T0,T).

i2ws(I,Wss):-
  i(I,Fs),
  map(arg(2),Fs,Wss).
     
is2ws(Is,Wss):-member(I,Is),i2ws(I,Wss).

is2wss(Ids,Wss):-
  findall(Ws,is2ws(Ids,Ws),Usss),
  % do not sort !!!
  appendN(Usss,Wss).
  
defs(Wss,Dss):-g(I,S),i2ws(I,Wss),findall(Ds,member(def(Ds),S),Dss).
exs(Wss,Ess):-g(I,S),i2ws(I,Wss),findall(Es,member(ex(Es),S),Ess).

expl_of(I,EsOrDs):-expl_of(I,EsOrDs,_).

expl_of(I,EsOrDs,F):-g(I,S),member(T,S),functor(T,F,1),arg(1,T,EsOrDs).

def_of(I,Ds):-g(I,S),member(def(Ds),S).
ex_of(I,Es):-g(I,S),member(ex(Es),S).

/*
xhyp(Cs,X):-member(hyp(X),Cs).
xent(Cs,X):-member(ent(X),Cs).
xsim(Cs,X):-member(sim(X),Cs).  
xmm(Cs,X):-member(mm(X),Cs).
xms(Cs,X):-member(ms(X),Cs).
xmp(Cs,X):-member(mp(X),Cs).  
xcs(Cs,X):-member(cs(X),Cs).  
xvgp(Cs,WNum,OtherId,OtherNum):-member(vgp(WNum,OtherId,OtherNum),Cs).  
xat(Cs,X):-member(at(X),Cs).  
xant(Cs,WNum,OtherId,OtherNum):-member(ant(WNum,OtherId,OtherNum),Cs).
xppl(Cs,WNum,OtherId,OtherNum):-member(ppl(WNum,OtherId,OtherNum),Cs).
xper(Cs,WNum,OtherId,OtherNum):-member(per(WNum,OtherId,OtherNum),Cs).
*/

xsa(Cs,WNum,OtherId,OtherNum):-
  member(sa(WNum0,OtherId,OtherNum0),Cs),
  zero2any(WNum0,WNum),
  zero2any(OtherNum0,OtherNum). 
  
xfr(Cs,FNum,WNum):-
  member(fr(FNum,WNum0),Cs),
  zero2any(WNum0,WNum).  

% matters only for sa/4 and fr/4 - no 0 in the other
zero2any(Zero,_):-Zero=:=0,!.
zero2any(Other,Other).

hyp(Id,X):-l(Id,Cs),member(hyp(X),Cs).
ent(Id,X):-l(Id,Cs),member(ent(X),Cs).
cs(Id,X):-l(Id,Cs),member(cs(X),Cs).  
sim(Id,X):-l(Id,Cs),member(sim(X),Cs).  
mm(Id,X):-l(Id,Cs),member(mm(X),Cs).
ms(Id,X):-l(Id,Cs),member(ms(X),Cs).
mp(Id,X):-l(Id,Cs),member(mp(X),Cs).  
vgp(Id,WNum,OtherId,OtherNum):-l(Id,Cs),member(vgp(WNum,OtherId,OtherNum),Cs).  
at(Id,X):-l(Id,Cs),member(at(X),Cs).  
ant(Id,WNum,OtherId,OtherNum):-l(Id,Cs),member(ant(WNum,OtherId,OtherNum),Cs).
sa(Id,WNum,OtherId,OtherNum):-l(Id,Cs),xsa(Cs,WNum,OtherId,OtherNum). 
ppl(Id,WNum,OtherId,OtherNum):-l(Id,Cs),member(ppl(WNum,OtherId,OtherNum),Cs).
per(Id,WNum,OtherId,OtherNum):-l(Id,Cs),member(per(WNum,OtherId,OtherNum),Cs).
fr(Id,FNum,WNum):-l(Id,Cs),xfr(Cs,FNum,WNum).
der(Id,WNum,OtherId,OtherNum):-l(Id,Cs),member(der(WNum,OtherId,OtherNum),Cs).  
cls(Id,OtherId,Type):-l(Id,Cs),member(cls(OtherId,Type),Cs).  
 
% reversed relations of the form: r<rel>(X,Y):-<rel>(Y,X)

rhyp(Id,X):-r(Id,Cs),xrhyp(Cs,X).
rmm(Id,X):-r(Id,Cs),xrmm(Cs,X).
rms(Id,X):-r(Id,Cs),xrms(Cs,X).
rmp(Id,X):-r(Id,Cs),xrmp(Cs,X).  
rcs(Id,X):-r(Id,Cs),xrcs(Cs,X).  
rent(Id,X):-r(Id,Cs),xrent(Cs,X).
rcls(Id,X,D):-r(Id,Cs),xrcls(Cs,X,D).
rcls(Id,X):-rcls(Id,X,_).

xrhyp(Cs,X):-member(hyp(Xs),Cs),member(X,Xs).
xrmm(Cs,X):-member(mm(Xs),Cs),member(X,Xs).
xrms(Cs,X):-member(ms(Xs),Cs),member(X,Xs).
xrmp(Cs,X):-member(mp(Xs),Cs),member(X,Xs).  
xrcs(Cs,X):-member(cs(Xs),Cs),member(X,Xs).  
xrent(Cs,X):-member(ent(Xs),Cs),member(X,Xs).
xrcls(Cs,X,D):-member(cls(XsDs),Cs),member([X,D],XsDs).

