% can be used as basis for a callback mechanism
% when BinProlog starts Jinni on a JVM

jtest:-call_java_prolog(true,Answer),println(Answer).
  
call_java_prolog(Query):-
  call_java_prolog(Query,Answer),
  % println(answer=Answer),
  Answer=the(Query).

call_java_prolog(Goal,Answer):-call_java_prolog(Goal,Goal,Answer).

call_java_prolog(Pattern,Goal,Answer):-
  call_java_prolog_term(the(Pattern,Goal),R),
  ( R=the(Y),Y=the(X,_)->Answer=the(X)
  ; Answer=no
  ).

call_java_prolog_term(Query,Answer):-
  term_codes(Query,Qs),
  call_java_prolog_string(Qs,As),
  % write_chars(As),nl,
  term_codes(Answer,As).
    
call_java_prolog_string(Qs,As):-
  vget(callback,int(F)),
  call_external(F,Qs,As),
  !.
call_java_prolog_string(_,"no").
