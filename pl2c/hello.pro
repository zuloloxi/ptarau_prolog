:-write('this is a simple program'),nl.

go:-
  nl,
  write([hello,this,is,a,'BinProlog',standalone,'C-ified',executable]),
  nl,
  foreach(call_a(X),println(called=a(X))).

% if main/0 is absent the toplevel prompt "?-" will show up,
% otherwise execution will start with main/0.

% main:-listing,go.

:-dynamic a/1.

a(1).
a(2).

call_a(X):-a(X).
