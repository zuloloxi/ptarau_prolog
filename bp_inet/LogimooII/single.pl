% remote Linda operations - single user mode
:-[ssi_lib].

that_target(single).

that_out(X):-db_assert(user,X).
that_cout(X):-db_clause(user,X,true)->true;db_assert(user,X).
that_cin(X):-db_retract1(user,X).
that_rd(X):-db_clause(user,X,true),!.
that_all(X,G,Xs):-findall(X,db_clause(user,G,true),Xs).
that_mes(Mes):-show_mes(Mes).

writeln(Xs):-Xs=[_,_]->forall(member(X,Xs),(print(X),write(' '))),nl;println(Xs).

wnl:-nl.

traceln(_).
%traceln(Xs):-writeln(Xs).
