% remote Linda operations - multi user mode

that_target(multi_cgi).

that_out(X):- local_out(X).
that_rd(X):-  local_rd(X).
that_cin(X):-  local_cin(X).
that_cout(X):-local_cout(X).
that_all(X,G,Xs):-local_all(X,G,Xs).

that_mes(Mes):-fix_mes(Mes,Cs),sprint_cs(Cs).

%writeln(X):-println(X).

writeln(Xs):-writeln(Xs,Cs),sprint_cs(Cs).

writeln(Xs,Cs):-
  (nonvar(Xs),Xs=[_|_]->
    findall(C,(
       member(X,Xs),
       (
          term_chars(X,Is);Is=" "),member(C,Is),
          [C]\="'"
       ),
       Cs
    )
  ; term_chars(Xs,Cs)
  ).

qwriteln(Xs):-qwriteln(Xs,Cs),sprint_cs(Cs).

qwriteln(Xs,Cs):-
  (nonvar(Xs),Xs=[_|_]->
    findall(C,(
       member(X,Xs),
       (
          term_chars(X,Is);Is=" "),member(C,Is)
       ),
       Cs
    )
  ; term_chars(Xs,Cs)
  ).

%traceln(X):-writeln(Xs).
traceln(_).


wnl:-sprint_cs("").
