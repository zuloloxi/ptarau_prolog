send_yes_no_query(L,P,Fact,_Query,Answer):-
  asserted(asked(L,P,Fact,Answer)),
  !.
send_yes_no_query(L,P,Fact,Query,Answer):-
  return(Query),
  from_engine(Answer),
  asserta(asked(L,P,Fact,Answer)).


guess_age(L,P):-
  guess_age(L,P,5,95).
     
guess_age(_L,_P,Min,Max):-Min>=Max,
   return(['It',is,great,to,be,Min,years,old,',',
           despite,of,being,mortal,'.']),
  fail.
guess_age(L,P,Min,Max):-
  Min<Max,
  Mid is (Min+Max)//2,
  Mid1 is Mid+1,
  Fact=older_than(Mid),
  Query=['Are',you,older,than,Mid,'?'],
  ( send_yes_no_query(L,P,Fact,Query,Answer),
    Answer=yes->guess_age(L,P,Mid1,Max)
  ; guess_age(L,P,Min,Mid)
  ).
  
guess_meaning(L,P,Ws):-
  wq(Ws,Fact,Query,Final),
  send_yes_no_query(L,P,Fact,Query,Answer),
  Answer=yes,
  !,
  return(Final),
  fail.

get_obsession(Ws):-
  member(Ws,[
    [sex],[fun],[style],[elegance],[beauty],
    [girlfriend],[boyfriend],[man],[woman],
    [work],[love],[money],[sport],[art],
    [music],[life],[weather],[politics],
    [success],[hope],[faith],[chance],[story],
    [business],[game],[shopping],[society]
  ]).
