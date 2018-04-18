answer_personal(Is,_,Os):-
  match_erules(Is,Os).
answer_personal(Is,_,Os):-
  ( Ns=['Why',are,'you',saying,':'|Is],
    ensure_last(Ns,'?',Os)
  ; edefaults(Oss),
    member(Os,Oss)
  ).
