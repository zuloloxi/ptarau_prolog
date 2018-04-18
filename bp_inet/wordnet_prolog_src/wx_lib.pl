% tools

detag_string(String,R):-detag_string(0,String,R).

detag_string(Max,String,R):-
  new_java_class('jwn.DeTagger',C),
  invoke_java_method(C,detagString(Max,String),Detagged),
  \+(Detagged='$null'),
  R=Detagged.

detag(URL,R):-detag(0,URL,R).
  
detag(Max,URL,R):-
  new_java_class('jwn.DeTagger',C),
  invoke_java_method(C,detag(Max,URL),S),
  \+(S='$null'),
  R=S.  
    
pp_fact(Term):-[Dot]=".",writeq(Term),put(Dot),nl.

proper_sublist_of(Ls,[M|Ss]):-
  append(_Bs,MsAs,Ls),
  append([M|Ss],_As,MsAs).
  
intersect(Qs,As,Xs):-findall(X,(member(X,Qs),member(X,As)),Xs).

difference(Qs,As,Xs):-findall(X,(member(X,Qs),\+(member(X,As))),Xs).

xor_op(Qs,As,XQs,XAs):-difference(Qs,As,XQs),difference(As,Qs,XAs).

xor_op(Qs,As,XQs-XAs):-xor_op(Qs,As,XQs,XAs).

xix(Qs,As,i(X,I,Y)):-intersect(Qs,As,I),xor_op(Qs,As,X,Y).

xix(XIY):-call(omqa(Qs,As)),xix(Qs,As,XIY).

words_hash(Ws,N):-term_hash(Ws,H),N is 10000+H mod 100000. 

forAll(Goal,OtherGoal):- \+ ((Goal, \+ OtherGoal)).
 

sel(X,Xs,Ys):-ins(X,Ys,Xs).

last_of([X],X).
last_of([_,Y|Ys],X):-last_of([Y|Ys],X).

% end

/*
shuffle(Xs,Rs):-
  nonvar(Xs),
  add_random_keys(Xs,KsXs),
  keysort(KsXs,KsRs),
  map(arg(2),KsRs,Rs).

add_random_keys([],[]).
add_random_keys([X|Xs],[K-X|Ys]):-
  random(K),
  add_random_keys(Xs,Ys).
*/

shuffle(Xs,Rs):-rank_order(ranord,0,Xs,Rs).

rank_order(Xs,Rs):-
  rank_order(rk,1.0,Xs,Rs).

rank_order(Rel,Def,Xs,Rs):-
  nonvar(Xs),
  add_ranks(Xs,Rel,Def,KsXs),
  keysort(KsXs,KsRs),
  map(arg(2),KsRs,Rs).

add_ranks([],_,_,[]).
add_ranks([X|Xs],Rel,Def,[K-X|Ys]):-
  % (call(Rel,X,K)->true;K=Def),
  call_order(Rel,Def,X,K),
  add_ranks(Xs,Rel,Def,Ys).

call_order(Rel,_Def,X,K):-call(Rel,X,K),!.
call_order(_Rel,Def,_,Def).
    
ranord(_,K):-random(K).

follows_in([A,B|_],A,B).
follows_in([_,B,C|Xs],U,V):-follows_in([B,C|Xs],U,V).
