get_stage(Login,Pwd,Stage):-bb_val(Login,Pwd,S),!,Stage=S.
get_stage(_,_,none).

set_stage(Login,Pwd,Stage):-bb_let(Login,Pwd,Stage).

clear_log_count:-
   log_count_file(CF),
   telling(Old),
   tell(CF),
     println('% count cleared'),nl,
   told,
   tell(Old),
   (abolish(log_count,1)->true;true).
   
new_log_count(N1):-
  log_count_file(CF),
  get_state(CF,log_count/1),
  (retract1(log_count(N0))->N=N0;N=0),
  N1 is N+1,
  assert(log_count(N1)),
  save_state(CF,log_count/1).
  
new_log_name(F):-new_log_count(N),log_file(F0),make_cmd([F0,'_',N,'.pl'],F).

count_step(N1):-bb_val(chat,step,N),N1 is N+1,bb_set(chat,step,N1).
count_step(N):-N=1,bb_def(chat,step,N).

clear_state:-
   state_preds(File,FNs,_),
   new_log_name(Log),
   save_state(Log,FNs),
   telling(Old),
   tell(File),
     println('% state cleared'),nl,
   told,
   tell(Old),
   foreach(member(F/N,FNs),abolish(F,N)).
   
get_state:-
  state_preds(File,FNs,_),
  get_state(File,FNs).
  
get_state(File,[F/N|_]):-
  functor(P,F,N),
  \+(is_dynamic(P)),
  exists_file(File),
  consult(File),
  !.
get_state(_,_).
  
put_state:-
  count_step(N),
  state_preds(File,FNs,Max),
  0=:=N mod Max,
  save_state(File,FNs),
  !.
put_state.  

save_state:-
  state_preds(File,FNs,_),
  save_state(File,FNs),
  !.
save_state.
 
save_state(File,FNs):-
  telling(Old),
  tell(File),
  ( member(F/N,FNs),
    functor(H,F,N),
    is_dynamic(H),
    asserted(H),
    qpp(H),
    fail
  ; true
  ),
  told,
  tell(Old),
  println(state_saved_to(File,FNs)),
  !.
save_state(File,FNs):-
  println(failed_saving_to(File,FNs)).
