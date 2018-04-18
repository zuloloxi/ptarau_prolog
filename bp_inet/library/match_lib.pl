/*
- matches Pattern0 against input list
- Pattern0 can contain any combination of constants, constrained vars of the form
  X:P where P is a predicate about X, and Gap vars
*/
match_pattern(Pattern0,Input0):-
  Begin='$begin$',End='$end$',
  nonvar(Pattern0),nonvar(Input0),
  det_append([Begin|Input0],[End],Input),
  det_append([Begin|Pattern0],[End],Pattern),
  match_internal(Pattern,Input,[]).
   
/*
  - matches Pattern against input List
  - Input should _start_ and _end_ with a const or X:P component
  - Components found Before and After the patterns are also returned
  
  - deprecated !!! use match_pattern/2
  
  match_pattern(+Pattern,+Input,?Before,?After):-
*/
match_pattern(Pattern,Input,Before,After):-
  nonvar(Pattern),nonvar(Input),
  [Before|Pattern]=NewPattern, % adds initial collector variable
  !,
  match_internal(NewPattern,Input,After),
  !. % matches the first occurence of the pattern

/*
  match_internal(+Pattern,+Input,-LeftOver): matches pattern
  against input list and returns what's left over in input
  
  some extensions are possible, a typical one would be:
    -A*P=As - collect all A such that P into As
    -and A+P=As - collect one or more A such that P into As
    
  still, the same can be achieved by just iterating over match_internal itself
  
  Note that match_gap expects a list of the form (in regexp notation): 
  
                {selector,gapvar}+
*/

%  match_internal(Xs,_,O):-println(trace=Xs+O),fail.
match_internal([])-->[].
match_internal([X|Xs])--> {nonvar(X)},start_nonvar(X),match_internal(Xs).
match_internal([X|Xs])-->{var(X)},start_var_gaps(Xs,X).

start_nonvar(X)-->[A],match_constant_pattern(A,X).

/*
   gap starts here - but we can be at the end of the pattern - this need special care
*/
start_var_gaps([],[])-->[].
start_var_gaps([X|Xs],As)-->{nonvar(X)},[A],match_var_gap(A,X,As,[]),match_internal(Xs).

%match_var_gap(A,End,As,As)-->{println(var_gap:A+End+As),fail}.
match_var_gap(A,End,As,As)-->match_constant_pattern(A,End).
match_var_gap(A,End,[A|As],NewAs)-->[B],match_var_gap(B,End,As,NewAs).

/*
  extend this if you want to add more notation for
  specialized pattern processors - for instance eol, eof, quotes etc.
  note that the last clause allows handling embedded patterns in a nice way
  
*/
match_constant_pattern(A,X)-->{atomic(X)},!,{X=A}.
match_constant_pattern(A,X)-->{float(X)},!,{X=A}.
match_constant_pattern(A,(A:P))-->!,{call(P)}.
match_constant_pattern(A,[B|Bs])-->!,
  % conjunctive subpattern
  match_constant_pattern(A,B),
  match_internal(Bs).
match_constant_pattern(A,'!'(B))-->!,
  % CUT subpattern: commits to first match for B (which can b a list)
  match_constant_pattern(A,B),
  !.
match_constant_pattern(A,([B|Bs];[C|Cs]))-->!,
  % disjunctive subpattern
  (  match_constant_pattern(A,B),match_internal(Bs)
  ;  match_constant_pattern(A,C),match_internal(Cs)
  ).
match_constant_pattern(A,(X+P=>Xs))-->
  match_plus_pattern(A,X,P,Xs).

/*
  handles repetitive patterns - X+P=>Xs will match 
   one or more X such that P and collect them to a list Xs  
*/
   
match_plus_pattern(A,X,P,[A|Xs])-->
  {copy_term(X+P,A+PA),call(PA)},
  [B],
  match_star_pattern(B,X,P,Xs).

/*
  should only be be used after 
*/
match_star_pattern(A,X,P,[A|Xs])-->
  {copy_term(X*P,A*PA),call(PA)},[B],
  !,
  match_star_pattern(B,X,P,Xs).
match_star_pattern(_A,_X,_P,[])-->[].

/******************************************************************
  Specialized lower level operations - they might be slightly
  faster, but probably not worth using, except for very time critical
  operations.
*******************************************************************/

/*
  collects until reaches given constant
*/ 
collect_to(End,Collected)-->{nonvar(End)},collect_to_such(X,End=X,Collected).
 
/*
  collects until finds X with property F(..X..) - more
*/ 
collect_to_such(End,F,[])-->[End],{call(F)}. % put ! to commit to first
collect_to_such(End,F,[X|Xs])-->[X],collect_to_such(End,F,Xs).
