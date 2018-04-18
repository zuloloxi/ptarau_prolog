% tools

sizeof(G,L):-sizeof(G,G,L).

sizeof(X,G,L):-findall(X,G,Xs),length(Xs,L).

ucall(Goal):-findonce(Goal,Goal).

findonce(X,G):-findonce(X,G,_,_).

findonce(X,G,K):-findonce(X,G,K,_).

% returns solutions by decreasing frequency order
findonce(X,G,Count,Total):-
  findall(X,G,Repeated),
  length(Repeated,N),
  findall(X-K,nth_member(X,Repeated,K),Pairs),
  findall(L-X,
    ( keygroup(Pairs,X,Ns),
      length(Ns,L)
    ),
  LsXs),  
  keysort(LsXs,Sorted),
  reverse(Sorted,Reved),
  member(K-X,Reved),
  Count=K,Total=N.

rotate_answer(Key1,Key2,Goal,Answer):-
  if((Goal, \+(db_asserted(Key1,answer(Key2,Answer)))),
   ( % then add new answer
     db_assertz(Key1,answer(Key2,Answer))
   ),
   ( % else rotate and reuse
     db_retract1(Key1,answer(Key2,Answer)),
     db_assertz(Key1,answer(Key2,Answer))
   )
  ).
   
random_answer(Goal):-random_answer(Goal,Goal).

random_answer(X,Goal):-
  findall(X,Goal,Xs),
  random_member(X,Xs).
  
random_member(X,Xs):-
  nonvar(Xs),Xs=[_|_],
  length(Xs,L),
  random(N),
  I is 1 + (N mod L),
  nth_member(X,Xs,I).
  
explore_sentence(Words,Rel,Cond,K,CompWhere,Is-Ws,NIss-NWss):- 
  tokens2synsets(Words,Is,Ws),
  findall(R,explore_synsets(Is,Rel,Cond,K,CompWhere,R),Xss),
  map(arg(1),Xss,NIss),
  map(arg(2),Xss,NWss).
  
  
explore_synsets(Is,Rel,Cond,K,CompWhere,NewIs-Wss):-
  member(Ix,Is),
  % println(here=I),
  explore_ids(Rel,Cond,K,Ix,CompWhere,NewIs),
  NewIs=[_|_],
  is2wss(NewIs,Wss).
  
/*
  starting with synsets in FromIds explores a Rel
  up to K levels providing edges subject to Cond true about each
  node and collects Ids
  if CompWhere is =(Where) it only retuns data found at level Where=K
     in particular if Where is unbound, data at any level
  if CompWhere is <(Where) it sets Where as lower limit, i.e.
     it only retuns data found at level K such that Where<K
  if CompWhere is >(Where) it sets Where as upper limit, i.e. it
     only retuns data found at level K such that Where>K
*/
explore_ids(Rel,Cond,K,FromIds,CompareWhere,ToIds):-
  findall(Id,tc(Rel,Cond,K,FromIds,CompareWhere,Id),Unsorted),
  sort(Unsorted,ToIds).

/*
  finds least common ancestors for two sets of meanings
*/
 

rjoin(Rel,Cond,Max,Is,Js,K,Rs):-
  findall(K-Id,rjoin1(Rel,Cond,Max,Is,Js,K,Id),KRs),
  keygroup(KRs,K,Rs).

rjoin1(Rel,Cond,Max,Is,Js,K,Id):-
  findall(Id-K,
    rjoin0(Rel,Cond,Max,Is,Js,K,Id),
    IKs
  ),
  keygroup(IKs,Id,Ks0),
  sort(Ks0,[K|_]).
  
rjoin0(Rel,Cond,Max,Is,Js,K,Id):-
  tc(Rel,Cond,Max,Is,=(I),Id),
  tc(Rel,Cond,Max,Js,=(J),Id),
  K is I+J.
   
tc(Rel,Cond,N,FromIds,FN,Id):-
  new_mark(M),
  member(Start,FromIds),
  tc1(Rel,Cond,0,N,Start,FN,Id,M).
      
tc1(_Rel,Cond,K,N,Id,CompWhere,Id,_M):-
  K=<N,
  call(CompWhere,K),
  call(Cond,Id).
tc1(Rel,Cond,K,N,From,CompWhere,End,M):-
  K<N,
  K1 is K+1,
  mcall(Rel,From,To,M),
  tc1(Rel,Cond,K1,N,To,CompWhere,End,M).

mcall(Rel,From,To,M):-call(Rel,From,To),mark_or_fail(To,M).

ocall((R1,R2),X):-!,ocall(R1,X),ocall(R2,X).
ocall((R1;R2),X):-!,ocall(R1,X);ocall(R2,X).
ocall(not(R),X):-!, \+(ocall(R,X)).
ocall(Cond,X):-nonvar(Cond),call(Cond,X).

ocall((R1,R2),From,To):-!,ocall(R1,From,To),ocall(R2,From,To).
ocall((R1;R2),From,To):-!,ocall(R1,From,To);ocall(R2,From,To).
ocall(not(R),From,To):-!, \+(ocall(R,From,To)).
ocall(Rel,From,To):-nonvar(Rel),call(Rel,From,To).


new_mark(N):-bb_val(node_mark,V),!,N is V+1,bb_set(node_mark,N).
new_mark(N):-N=1,bb_def(node_mark,N).

mark_or_fail(Node,N):-bb_val(marked,Node,N),!,fail.
mark_or_fail(Node,N):-bb_let(marked,Node,N).

wtop_of(Ws,Ts,N):-w2i(Ws,I),top_of(I,T,N),i2w(T,Ts).

top_of(I,T,N):-
  Rel=hyp,
  member(Cond,[verb,noun]),
  tc(Rel,Cond,20,[I],=(N),T),
  t(T,Cond),
  true.
  