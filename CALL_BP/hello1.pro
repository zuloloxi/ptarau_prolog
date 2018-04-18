/*
  To learn quickly about how to build more powerful DLLs using
  BinProlog's C interface try to adapt hello.c to support this file
  instead of hello.c
*/
go:-
  write('--->: your C program calls BinProlog DLL'),nl,
  write('BinpProlog says Welcome!'),nl,
  nl,
  write(
   '<---: BinProlog calls your C code defined as new_builtin/3, arg 1='),
   write(In),nl,
  nl,
  ( new_builtin(1,In,Out)-> write('C code succeeds')
  ; write('C code fails')
  ),
  nl,nl,
  write('--->: your C code returns control to to Prolog again:'),nl,
  write(Out),nl,
  !.
go:-
  write('something failing in hello.pro'),nl.





