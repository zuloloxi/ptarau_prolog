% transforms and optimizes xw.pl xd.pl

:-[wx_top]. % generator
:-[xd].
:-[xw].

basic_file('/paul/wordnet/wruntime/wnet.pl').

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
      
newi(I,N):-val(I,'$map',R),!,N is R.
newi(I,N):-get_newi(R),def(I,'$map',R),N is R.

get_newi(N1):-val('$ctr','$map',N),!,N1 is N+1,set('$ctr','$map',N1).
get_newi(N):-N=1,def('$ctr','$map',N).

newis([],[]).
newis([I|Is],[N|Ns]):-newi(I,N),newis(Is,Ns).

new_rel(i(NI,F)):-i(I,F),newi(I,NI).
new_rel(l(NI,NFs)):-l(I,Fs),newi(I,NI),new_links(Fs,NFs).
new_rel(g(NI,F)):-g(I,F),newi(I,NI).
new_rel(w(W,Ns)):-w(W,Is),newis(Is,Ns).

new_rel(r(NI,NFs)):-r(I,Fs),newi(I,NI),new_llist(Fs,NFs).
new_rel(e(W,XNs)):-e(W,XIs),new_assoc(XIs,XNs).
new_rel(t(NI,T)):-t(I,T),newi(I,NI).
new_rel(k(W,K)):-k(W,K).
new_rel(n(W,K)):-n(W,K).

new_assoc([],[]).
new_assoc([X/I|XIs],[X/N|XNs]):-newi(I,N),new_assoc(XIs,XNs).

new_links([],[]).
new_links([L|Ls],[NL|NLs]):-do_new_link(L,NL),new_links(Ls,NLs).

do_new_link(X,Y):-new_link(X,Y),!.
do_new_link(X,_Y):-ttyprint(unexpected_link=X),ttynl,fail.

new_llist([],[]).
new_llist([L|Ls],[NL|NLs]):-do_new_llist(L,NL),new_llist(Ls,NLs).

do_new_llist(FXs,FYs):-FXs=..[F,Xs],map_newi(Xs,Ys),FYs=..[F,Ys],!.
do_new_llist(FXs,_Y):-ttyprint(unexpected_llist=FXs),ttynl,fail.

map_newi([],[]).
map_newi([L|Ls],[NL|NLs]):-xnewi(L,NL),map_newi(Ls,NLs).

xnewi(L,NL):-integer(L),!,newi(L,NL).
xnewi([L|Xs],[NL|Xs]):-newi(L,NL).

new_link(hyp(I),hyp(N)):-newi(I,N).
new_link(ent(I),ent(N)):-newi(I,N).
new_link(cs(I),cs(N)):-newi(I,N).
new_link(sim(I),sim(N)):-newi(I,N).
new_link(mm(I),mm(N)):-newi(I,N).
new_link(ms(I),ms(N)):-newi(I,N).
new_link(mp(I),mp(N)):-newi(I,N).
new_link(vgp(A,I,B),vgp(A,N,B)):-newi(I,N).
new_link(at(I),at(N)):-newi(I,N).
new_link(ant(A,I,B),ant(A,N,B)):-newi(I,N).
new_link(sa(A,I,B),sa(A,N,B)):-newi(I,N).
new_link(ppl(A,I,B),ppl(A,N,B)):-newi(I,N).
new_link(per(A,I,B),per(A,N,B)):-newi(I,N).
new_link(fr(A,B),fr(A,B)).
new_link(cls(J,D),cls(M,D)):-newi(J,M).
new_link(der(A,I,B),der(A,N,B)):-newi(I,N).
