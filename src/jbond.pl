% jbond.pl
:-spy a/1.
:-spy c/1.

b(X):-a(X),c(X).

a(1).
a(2).

c(2).
c(3).