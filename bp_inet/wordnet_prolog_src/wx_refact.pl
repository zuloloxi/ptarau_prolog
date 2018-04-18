% transforms and optimizes xw.pl xd.pl

:-[wx_top]. % generator
:-[xd].
:-[xw].

basic_file('/paul/wordnet/wruntime/wn.pl').

btrans:-
  basic_file(B),
  tell(B),
  new_rel(R),
  pp_fact(R),
  fail.
btrans:-
  told.

% not needed
ftrans:-basic_file(F),fcompile(F).

badi(I):- \+integer(I),!.
badi(I):- I<10000.

newi(I,_):- badi(I),!,ttyprint(unexpected_data_in_newi(I)),fail. 
newi(I,N):-val(I,'$map',R),!,N is R.
newi(I,N):-get_newi(R),def(I,'$map',R),N is R.

get_newi(N1):-val('$ctr','$map',N),!,N1 is N+1,set('$ctr','$map',N1).
get_newi(N):-N=1,def('$ctr','$map',N).

% begin spec for new relations

new_rel(v(NI/Num,D,xn-F)):-i(I,Fs),newi(I,NI),member(f(Num,Ws,T,Freq,Count),Fs),
  member(D-F,[
    Ws-words,
    T-type,
    Freq-freq,
    Count-count
  ]).

new_rel(v(NI,x-F)):-l(I,Fs),newi(I,NI),member(S,Fs),do_link(S,J,F),J==none.
new_rel(v(NI,x-DE)):-g(I,Fs),newi(I,NI),member(DE,Fs).
new_rel(v(NI,x-top(T))):-t(I,T),newi(I,NI).
new_rel(v(W,w-old(K))):-k(W,K).
new_rel(v(W,w-new(K))):-n(W,K).
  
new_rel(e(W,N,w/x-wnet)):-w(W,Is),member(I,Is),newi(I,N).
new_rel(e(W,N,w/x-exc(Ws))):-e(W,XIs),new_assoc(XIs,XNs),member(Ws/N,XNs).

new_rel(e(NI,J,x/x-F)):-l(I,Fs),newi(I,NI),member(S,Fs),do_link(S,J,F),integer(J).
new_rel(e(NI,J,x/x-RF)):-r(I,Fs),newi(I,NI),member(S,Fs),do_llist(S,Js,F),member(J,Js),integer(J),revrel(F,RF).

new_rel(e(NI/A,J/B,xn/xn-F)):-l(I,Fs),newi(I,NI),member(S,Fs),do_link(S,[A,J,B],F),integer(J).


% end of new relations

do_link(X,Y,F):-new_link(X,R,F),!,Y=R.
do_link(X,_,_):-ttyprint(unexpected_link=X),ttynl,fail.

revrel(FX,RX):-FX=..[F|Xs],namecat('r','',F,R),RX=..[R|Xs].

do_llist(FXs,Ys,F):-FXs=..[F,Xs],map_newi(Xs,Rs),!,Rs=Ys.
do_llist(FXs,_,_):-ttyprint(unexpected_llist=FXs),ttynl,fail.

map_newi([],[]).
map_newi([L|Ls],[NL|NLs]):-xnewi(L,NL),map_newi(Ls,NLs).

xnewi(L,NL):-integer(L),!,newi(L,NL).
xnewi([L|Xs],[NL|Xs]):-integer(L),newi(L,NL).

new_assoc([],[]).
new_assoc([X/I|XIs],[X/N|XNs]):-newi(I,N),new_assoc(XIs,XNs).

new_link(fr(A,B),none,fr(A,B)).
new_link(hyp(I),N,hyp):-newi(I,N).
new_link(ent(I),N,ent):-newi(I,N).
new_link(cs(I),N,cs):-newi(I,N).
new_link(sim(I),N,sim):-newi(I,N).
new_link(mm(I),N,mm):-newi(I,N).
new_link(ms(I),N,ms):-newi(I,N).
new_link(mp(I),N,mp):-newi(I,N).
new_link(at(I),N,at):-newi(I,N).
new_link(cls(J,D),M,CD):-newi(J,M),namecat(cls,'_',D,CD).

new_link(vgp(A,I,B),[A,N,B],vgp):-newi(I,N).
new_link(ant(A,I,B),[A,N,B],ant):-newi(I,N).
new_link(sa(A,I,B),[A,N,B],sa):-newi(I,N).
new_link(ppl(A,I,B),[A,N,B],ppl):-newi(I,N).
new_link(per(A,I,B),[A,N,B],per):-newi(I,N).
new_link(der(A,I,B),[A,N,B],der):-newi(I,N).
