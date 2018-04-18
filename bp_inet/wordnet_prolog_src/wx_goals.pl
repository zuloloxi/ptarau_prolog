% goal oriented agent behavior

% goal_step(L,P,Is,Qs,Stage1,Stage2):-println(here(L,P,Stage1)=Is),fail.
goal_step(L,P,Is,Qs,Stage1,Stage2):-
  \+member(Stage1,[thinking(_),search]),
  \+(is_short_answer(Is,_)),
  start_thinking(L,P,Is,Qs,Stage1,Stage2),
  !.
goal_step(_L,_P,Is,Qs,Stage1,Stage2):-
  is_short_answer(Is,Key),
  % succeeds but may stop the thinking process ...
  short_answer_step(Key,Qs,Stage1,Stage2),
  !.
goal_step(_L,_P,_Is,_Qs,thinking(E),none):-
  % stops the thinking process and fails
  % println(stopping_engine(E)),
  stop(E),
  fail.
   
short_answer_step(Key, Os,thinking(E), thinking(E)):-
  thinking_step(E,Key, Os),
  !.
short_answer_step(Key,Os,_Stage1,none):-
  default_short_answer(Key,Os).
  
thinking_step(E,Key, Qs):-
  to_engine(E,Key),
  get(E,the(Qs)).

heap(2000).
stack(500).
trail(500).
  
start_thinking(L,P,Is,Os,Stage1,thinking(E)):-
  make_goal(L,P,Is,Stage1,Goal),
  new_engine(none,Goal,E),
  get(E,the(Os)).

make_goal(L,P,Is,_Stage,Goal):-
  in_short_context([verb,noun],Is,[Is],W,_T),
  !,
  Goal=guess_meaning(L,P,[W]).
make_goal(L,P,Is,_Stage,Goal):-
  member(X,[age,young,old]),
  member(X,Is),
  !,
  Goal=guess_age(L,P).

in_short_context(Types,Ys,Wss,W,T):-
  member(Words,Wss),
  pick_core_word(Types,Words,W,T),
  intersect(Ys,Words,[_|_]).
  
pick_core_word(Types,Words,W,T):-  
  member(W,Words),
  Ws=[W],
  content_only(Ws),
  w2t(Ws,T),
  member(T,Types).
  
/*
make_goal(Is,_Stage,Os,explore_nouns(Is,Os)).

explore_nouns(Is,Os):-
  pick_core_word([noun],Is,W,_),
  Os=['Would',you,like,to,chat,about,W,'?'].
*/

is_short_answer([],empty).    
is_short_answer([I|Is],yes):-
  yes_word(I),
  (Is=[];Is=['.']).
is_short_answer([I|Is],no):-
  no_word(I),
  (Is=[];Is=['.']).
is_short_answer([why|Is],why):-
  (Is=[];Is=['?']).
is_short_answer([when|Is],when):-
 (Is=[];Is=['?']).
is_short_answer([who|Is],who):-
  (Is=[];Is=['?']).
is_short_answer([what|Is],what):-
  (Is=[];Is=['?']).  
is_short_answer([where|Is],where):-
  (Is=[];Is=['?']).
is_short_answer([which|Is],which):-
  (Is=[];Is=['?']).
is_short_answer([I|Is],maybe):-
  ( maybe_word(I),(Is=[];Is=['.'])
  ; Is=['?'],(yes_word(I);no_word(I))
  ).

default_short_answer(yes,['I',think,so,too,'.']).
default_short_answer(no,['You',might,know,this,better,than,'I','.']).
default_short_answer(why,['Why',not,'?']).
default_short_answer(when,['Once',upon,a,time,'.']).
default_short_answer(where,['Somewere',under,the,rainbow,'.']).
default_short_answer(who,['Someone',you,probably,know,'.']).
default_short_answer(what,['Something',you,probably,know,'.']).
default_short_answer(which,['One',you, would,never,guess,'.']).
default_short_answer(maybe,['That',surprised,me,too,'.']).

% end

% disamb(Ws,M):-w2itn(Ws,I,T,N),gen(I,H),\+(gen

w2h(Rel,Ws,TH,Wss):-findall(Ws:T/H-I,(w2itn(Ws,I,T,_),call(Rel,I,H)),THWss0),keygroup(THWss0,TH,Wss).

  