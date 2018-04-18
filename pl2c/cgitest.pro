main:-
  header,
  inc(X),
  write(hello(X)),nl.

fname('./counter.pro').

header:-
  write('220 ok'),nl,
  write('content-type: text/html'),nl,
  nl.

inc(X):-fname(F),
   ( see_or_fail(F)-> [F]=>counter(X)
   ; X=0
   ),
   X1 is X+1,
   tell(F),
   write(counter(X1)),write('.'),nl,
   told.
