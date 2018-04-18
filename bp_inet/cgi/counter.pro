main:-header,inc(X),show_counter(X).

header:-
  % write('220 ok'),nl,
  write('content-type: text/html'),nl,nl.

show_counter(X):-write(counter(X)),write('.'),nl.

inc(X):-
  F='../data/cstate.pro',
  ( see_or_fail(F)-> see(F),read(counter(X)),seen
  ; X=0
  ),X1 is X+1,
  tell(F),show_counter(X1),told.
