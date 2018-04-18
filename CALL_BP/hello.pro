go:-
  println('BinProlog says Hello!'),
  unix_argv(0,EXE),
  write('multi-threaded bp_lib.dll called from: '),write(EXE),nl,
  unix_argv(Xs),write(args=Xs),nl,
  sleep(1),
  bg(my_thread(1),T1),println(launching(thread(T1))),
  bg(my_thread(2),T2),println(launching(thread(T2))),
  thread_join(T1),
  thread_join(T2),
  println(finished_joining_threads(T1,T2)),
  println('BinProlog says Bye!').


my_thread(N):-
  for(I,1,5),
   println(thread(N,step(I),go_sleeping)),
   sleep(1),
  fail
; println(thread(N,end)).

