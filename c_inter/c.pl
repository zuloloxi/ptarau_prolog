go:-
    c_test,fail
  ; cut_test(Xs,Ys,[1,2]),write(Xs+Ys),nl,fail
  ; engine_test1,fail
  ; engine_test2,fail
  ; engine_test3,fail
  ; ecall_test,fail
  ; float_test,fail
  ; simple_test,fail
  ; list_test.

c_test:-
  for(I,1,13),
    new_builtin(I,I,R),
    write(c_test(I=R)),nl,
  fail
; X=1,
  if0(X>0,write(yes),write(no)),nl.

simple_test:-
  println(passing_simple_data),
  new_builtin(16,2.78,R1),write(returned=R1),nl.

list_test:-
  println(passing_a_list),
  new_builtin(17,[a_string,3.14,2003],R1),write(returned=R1),nl.
    
/*
  calls a simple double->double function after converting arguments
*/
float_test:-
  println(passing_an_int),
  new_builtin(15,10,R1),write(returned=R1),nl,
  println(passing_a_double),
  new_builtin(15,2.5,R2),write(returned=R2),nl,
  println(passing_a_string_represented_float),
  new_builtin(15,'10.001',R3),write(returned=R3),nl,
  println(passing_not_a_number(should_fail)),
  new_builtin(15,not(a,number),R4),write(returned=R4),nl.
  
example1(I,O):-new_builtin(1,I,O).

c_append(I,O):-new_builtin(8,I,O).

% uncomment this if you want BinProlog to start from here
% main:-c_test.


cut_test(X,Y,Z):-
  for(I,1,10),
  (I<6->write(I),nl,fail
  ; !, write(cut_test),nl,append(X,Y,Z)
  ).

% tests the NEW, first-order engine based interface

% the most efficient one
engine_test1:-new_builtin(11,from_prolog,R),write(R),nl.

% the easier one
engine_test2:-new_builtin(12,from_prolog,R),write(R),nl.

engine_test3:-new_builtin(13,accumulating_solutions,R),
  write(returned_from_C=R),nl.

ecall_test:-
  new_builtin(14,_,F),
  call_external(F,"external_hello",R),
  println(fun(F)+R),
  name(N,R),
  write(N),nl.

/* expected output:

?- engine_test1.
new_engine_test
from_prolog
100
200
300
_2340
yes

?- engine_test2.
Answer = 0
Answer = s(0)        <=== multiple answers
Answer = s(s(0))
Answer = [a,b,c]
_2357
yes


*/
