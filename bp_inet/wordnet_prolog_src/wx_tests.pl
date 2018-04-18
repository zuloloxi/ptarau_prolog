:-[wx_top].

% scatalog('/paul/wordnet/stories/stories.pl').
% sfile('/paul/wordnet/stories/grimm/145.txt').
% sfile('/paul/wordnet/stories/hgwells.txt').
sfile('/paul/wordnet/stories/dilbert.txt').
% sfile('/paul/wordnet/stories/tao.txt').
% sfile('/paul/wordnet/stories/bible.txt').
% sfile('/paul/wordnet/stories/theonion.txt').

% VALIDATION TESTS

j1:-
  w(milk,Ds),w(sugar,Cs),
  rjoin(hyp,any,3,Ds,Cs,K,Is),
  is2wss(Is,Wss),
  println(K:Is+Wss),
  fail.

j2:-
  w(dog,Ds),w(sky,Cs),
  rjoin(gen,any,16,Ds,Cs,K,Is),
  is2wss(Is,Wss),
  println(K:Is+Wss),
  fail.
    
tt:-
  rtrace(humble),
  fail
; 
  nl,
  E=e(bagging,X),
  E,
  println(E),
  fail
; member(Y,[noun,verb]),
  nl,
  T=t(X,Y),
  I=i(X,_S),
  once(T),
  I,
  println(T),
  println(I),
  fail.
  
    
rtrace(W):-
   w(W,Is), 
   println(w(W,Is)),
   member(I,Is),
   nl,
   member(F,[i,l,g,r]),
   P=..[F,I,_],
   P, 
   println(P),
   fail
; true.
   
xtrace(F):-
  member(F,[t,e,k,n]),
  P=..[F,_W,_I],
  once(P),
  println(P). 

t0:-
  sentence_of('test.txt',S),
  println(S),
  tokens2info(S,Xss),
   foreach(member(X,Xss),(tab(4),println(X))),
  info2synsets(Xss,Is,_Wss),
  tab(2),println(Is), 
  fail.

t11:-
  ltrace(9,
     "The toad kissed the beautiful girl and then turned into a prince."). 

t12:-
   ltrace(12,
     "female snake woman"). 

t1:-
  ltrace(8,
     "As Picasso said, computers are useless; they only give answers."). 

tw:-
  ltrace(8,
     "The woman said ""The serpent deceived me, and I ate""."). 
     
t2:-ntrace.

t3:-project([[story]]).

bt:-project([noun:[man],verb:[tell]]).

t5:-project([noun:[leader],verb:[punish]]).

t6:-project([noun:[reptile],verb:[punish]]).

tl:-project([noun:[female],noun:[reptile]]).

tp:-project([noun:[idea],noun:[beauty]]).

e1:-project([noun:[person],noun:[reptile]]).

e2:-project([noun:[person],verb:[kill],noun:[animal]]).

e3:-project([noun:[female],verb:[say],noun:[reptile]]).

t6a:-project([noun:[reptile]]).
t6b:-project([verb:[punish]]).

tt1:-project([noun:[person],verb:[say],adj:[bad]]).

tt2:-project([noun:[earth],noun:[heaven]]).

tt3:-project([noun:[heaven]]).

tt4:-project([adv:[well]]).

project(CWs):-
  defaultHBDR(H,B,D,R),
  println(ontology=CWs),
  println(defaultHBDR=[quantifier=H,breadth=B,depth=D,relation=R]),
  sfile(File),
  covers_file(File,H,B,D,R,CWs,Xs),
  write_words(Xs),nl,nl,
  fail
; true. 
      
ntrace:-sfile(F),ntrace(F).

ntrace(File):-
  explore(File,1,2,hyp,noun).

vtrace:-sfile(F),vtrace(F).

vtrace(File):-
  explore(File,1,2,gen,verb).

strace:-sfile(F),strace(F).

strace(File):-
  explore(File,1,2,gen,any).

n(K):-sfile(F),explore(F,K,K,gen,noun).

v(K):-sfile(F),explore(F,K,K,gen,verb).

av(K):-sfile(F),explore(F,K,K,gen,adverb).

nf:-sfile(F),freq_words(F,[noun]).

vf:-sfile(F),freq_words(F,[verb]).

fx:-sfile(F),freq_words(F,[verb]). 

st:-
  sfile(F),
  file2synsets(F,S,_),
  println(S),
  fail
; true.

% PERFORMANCE TESTS

ctime:-
  sfile(F),
  ctime(T1),
  foreach(char_of(F,_),fail),
  ctime(T2),
  T is T2-T1,
  println(T).
  
stime:-
  sfile(F),
  ctime(T1),
  foreach(sentence_of(F,_),fail),
  ctime(T2),
  T is T2-T1,
  println(T).

ttime:-
  sfile(F),
  ctime(T1),
  foreach(
    sentence_of(F,Ts),
    tokens2synsets(Ts,_Ws,_Is)
  ),
  ctime(T2),
  T is T2-T1,
  println(T).

otime:-
  sfile(F),
  ctime(T1),
  foreach(
    covers_file(F,[noun:[leader]],Xs),
    println(Xs)
  ),
  ctime(T2),
  T is T2-T1,
  println(T).
  
gtime:-reltime(gen).

htime:-reltime(hyp).

reltime(Rel):-
  sfile(F),
  ctime(T1),
  foreach(
    sentence_of(F,Ts),
    reltime(Rel,Ts)
  ),
  ctime(T2),
  T is T2-T1,
  println(T).

reltime(Rel,Ts):-
  tokens2synsets(Ts,Is,_Ws),
  member(I,Is),
  ocall(Rel,I,_).
    
