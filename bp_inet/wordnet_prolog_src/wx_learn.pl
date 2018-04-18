try_to_learn(L,P,[No,Punct|Ws],['Ok','I',will,remember,that,'!']):-
  Ws=[_|_],
  no_word(No),
  member(Punct,[(','),('.')]),
  get_last_statement(L,P,Qs,_Bs,_Stage1,_Stage2),
  intersect(Qs,Ws,[_,_|_]),
  me2yous(Ws,Us),
  ensure_last(Us,'.',Gs),
  learn_instead(L,P,Qs,Gs),
  !. 
try_to_learn(L,P,Is,Os):-
  get_learned(L,P,Is,Os).

get_learned(L,P,Qs,As):-asserted(learnedq(L,P,Qs,As)).
  
learn_instead(L,P,Qs,Ws):-
  retractall(learnedq(L,P,Qs,_)),
  asserta(learnedq(L,P,Qs,Ws)).

get_last_statement(Login,Pwd,Qs,As,Stage1,Stage2):-
  asserted(memqa(Login,Pwd,Qs,As,Stage1,Stage2)),!.
