debug_match(Name,_Is,_Os):-println('!!! rule_name'=Name).

% file, state, periodicity of state backup
state_preds('../data/wchat_state.pl',[memqa/6,learnedq/4,asked/4],30).
log_file('../data/wchat_log').
log_count_file('../data/wchat_log_count.pl').

% not working - has a bug of its own
chat_test:-
  chat_step("ants_treasure","paul","eur2eka","what is the title of the story?",R),
  write_chars(R),nl.

schat:-
  set_param(sview,yes),
   set_param(view,yes),
  chat0.

chat:-
  set_param(sview,no),
  chat0.
    
chat0:-
  repeat,
  ( chat1->fail
  ; !
  ).
  
chat1:-
  write_chars("> "),flush,
  read_line(L),
  atom_codes(L,ICs),
  ICs=[_|_],
  chat_step(ICs,OCs),
  write_chars(OCs),nl.
  
chat_step(ICs,OCs):-
  call_ifdef(story_file(Ss),Ss="none"),
  chat_step(Ss,ICs,OCs).

chat_step(Ss,ICs,OCs):-chat_step(Ss,"guest","eur5eka",ICs,OCs).

vchat_step(ICs,OCs,VGoal):-
  chat_step("none","guest","eur5eka",ICs,OCs,VGoal).

% also used by Web based PSA agent - 5 args
chat_step(Ss,LCs,PCs,ICs,OCs):-
  chat_step(Ss,LCs,PCs,ICs,OCs,VGoal),
  % Goal=true if sview is not set
  call(VGoal).

chat_step(Ss,LCs,PCs,ICs,OCs,VGoal):-
  basic_chat_step(Ss,LCs,PCs,ICs,OCs,TheMemWss),
  sgo(TheMemWss,VGoal). % computes VGoal - a visualize instruction

basic_chat_step(Ss,LCs,PCs,ICs,OCs,MemWss):-
  name(Login,LCs),name(Password,PCs),
  codes_words(ICs,IWs0), 
  agent_step(Ss,Login,Password,IWs0,UWs,MemWss),
  %println(here=UWs),
  codes_words(OCs,UWs),
  %println(there=OCs),
  show_chat_step(LCs,ICs,OCs).
 
agent_step(Ss,Login,Password,IWs0,UWs,MemWss):-
  get_state,
  get_stage(Login,Password,Stage1),
  debug_match(entering_wx_agent_step(Stage1),IWs0,[Login,Password]),  
  to_lower_first(IWs0,IWs1),
  fix_idioms(IWs1,IWs),
  scollect(Login,Password,IWs,MemWss),
  wchat_handler(Ss,Login,Password,IWs,OWs,Stage1,Stage2),
  asserta(memqa(Login,Password,IWs,OWs,Stage1,Stage2)),
  to_upper_first(OWs,UWs),
  debug_match(exiting_wx_agent_step(Stage2),IWs0,UWs),
  set_stage(Login,Password,Stage2),
  put_state.

scollect(Login,Password,NewIWs,the([NewIWs|Wss])):-
  get_param(sview,yes),
  !,
  findall(IWs,asserted(memqa(Login,Password,IWs,_OWs,_Stage1,_Stage2)),Wss).
scollect(_Login,_Password,_,no).
   
qpp(H):-[Dot]=".",writeq(H),put(Dot),nl.
  
show_chat_step(LCs,ICs,OCs):-
  write_chars(LCs),write_chars(": "),write_chars(ICs),nl,
  write_chars("agent: "),write_chars(OCs),nl,nl.

% Ss=story context,LCs=login,_PCs=pwd

% bad_pwd(L,P):-member('',[L,P]),!.
bad_pwd(_L,P,Os):-
  name(P,Ps),
  ( length(Ps,N),N<4 
  /*; "09"=[D0,D9],
    findall(D, (member(D,Ps),D>=D0,D=<D9), Ds),
    Ds=[] */
  ),
  !,
  Os=['Please',chose,a,login,and,a,password,',',made,of,four,or,more,letters,and,numbers,'!'].
  
wchat_handler(_Ss,_L,_P,Is,Os,_S1,_S2):-
  debug_match(wx_entering_wchat_handler,Is,Os),
  fail.
wchat_handler(_Ss,L,P,Is,Os,_Stage,none):-
  bad_pwd(L,P,Os),
  !,
  debug_match(mx_please_step,Is,Os).
wchat_handler(_Ss,L,P,Ys,Os,Stage1,Stage2):-
  try_short_match(L,P,Ys,Os,Stage1,Stage2),
  !,
  debug_match(short,Ys,Os).
wchat_handler(StoryCs,_Login,_Pwd,Is,Os,_Stage,story(File)):-
  atom_codes(File,StoryCs),
  call_ifdef(story_step(File,Is,Os),fail),
  !,
  debug_match(mx_story_step,Is,Os).  
wchat_handler(_Ss,L,P,Is,Os,_Stage,om):-
  call_ifdef(om_step(Is,Os),fail),
  new_answer(L,P,Os),
  !,
  debug_match(mx_om_step_new_answer,Is,Os). 
wchat_handler(_Ss,L,P,Ys,Os,_Stage,learning):-
  try_to_learn(L,P,Ys,Os),
  !,
  debug_match(short,Ys,Os).  
wchat_handler(_,Login,Password,Is,Os,Stage1,reactive):-
  answer_current_topic(Login,Password,Is,Os,Stage1),
  !,
  debug_match(mx_current_topic,Is,Os).
wchat_handler(_Ss,Login,Password,Is,Os,S1,S2):-
  goal_step(Login,Password,Is,Os,S1,S2),
  !,
  debug_match(mx_goal_step,Is,Os).
wchat_handler(_Ss,L,P,Ys,Os,Stage1,personal):-
  Stage1\==personal,
  me2yous(Ys,Is),
  Ys\==Is,
  intersect(Ys,Is,Cs),
  rotate_answer(L,[P,Cs],answer_personal(Ys,Cs,Os),Os),
  debug_match(mx_personal,Is,Os).  
wchat_handler(_,_Login,_Password,Is,Os,_Stage,search):-
  call_ifdef(search_step(Is,Os),fail),
  !.
wchat_handler(_,Login,Pwd,Is,Os,Stage,past):-
  Stage\==past,
  call_ifdef(answer_past_topic(Login,Pwd,Is,Os),fail),
  !,
  debug_match(mx_past_topic,Is,Os).
wchat_handler(_,Login,_Pwd,_Is,
  ['Sorry',Login,',','I',do,not,know,how,to,answer,that,'.'],_Stage,none).
  
/*
% uses local speech server

vchat:-
  repeat,
  ( vchat1->fail
  ; !
  ),
  speak(end_of_file).
  
vchat1:-
  [Q,A]="?.",
  write_chars("> "),flush,
  read_line(L),
  atom_codes(L,ICs),
  ICs=[_|_],
  name(IL,[Q|ICs]),speak(IL),
  chat_step("ants_treasure","guest","eureka",ICs,OCs),
  write_chars(OCs),nl,
  name(OL,[A|OCs]),
  speak(OL).

speak(X):-speak(localhost,7001,X).
 
speak(H,P,X):-remote_run(H,P,'{',X,'}',_).

stop_speach(H,P):-speak(H,P,end_of_file).

stop_speach:-speak(end_of_file).
*/
    



      