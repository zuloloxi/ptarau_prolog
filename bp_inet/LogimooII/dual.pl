% remote Linda operations - local client/server, good for debugging
:-[ssi_lib].

that_target(dual).

that_out(X):- out(X).
that_rd(X):-  rd(X).
that_cin(X):-  cin(X).
that_cout(X):-cout(X).
that_all(X,G,Xs):-all(X,G,Xs).

that_mes(Mes):-fix_mes(Mes,Cs),say(Cs).

writeln(Xs):-Xs=[_,_]->forall(member(X,Xs),(print(X),write(' '))),nl;println(Xs).

wnl:-nl.

traceln(_).
%traceln(Xs):-writeln(Xs).

