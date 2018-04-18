has_first_upper(W):-name(W,[C|_]),to_upper_char(C,C).
   
to_lower_first([],[]).
to_lower_first([W|Ws],[L|Ws]):-
  to_lower_word(W,L).
    
to_upper_first([],[]).
to_upper_first([W|Ws],[L|Ws]):-
  to_upper_word(W,L).

to_lower_word(W,L):-
  atom(W),
  !,
  atom_codes(W,Cs),
  to_lower_chars(Cs,Ls),
  atom_codes(L,Ls).
to_lower_word(W,W).

to_upper_word(W,L):-
  atom(W),
  !,
  atom_codes(W,Cs),
  to_upper_first_char(Cs,Ls),
  atom_codes(L,Ls).
to_upper_word(W,W).
    
to_upper_first_char([],[]).
to_upper_first_char([L|Cs],[U|Cs]):-to_upper_char(L,U).

ensure_last(Ws,Last,NewWs):-ensure_last_is(Ws,['.','?','!'],Last,NewWs).

ensure_last_is([A,B|Xs],Others,Last,[A|Ys]):-!,ensure_last_is([B|Xs],Others,Last,Ys).
ensure_last_is([Other],Others,Last,[Last]):-member(Other,Others),!.
ensure_last_is([A],_,Last,[A,Last]):-!.
ensure_last_is([],_,Last,[Last]).

is_lp('!').
is_lp('.').
is_lp('?').
is_lp((';')).
is_lp((',')).

trim_last_punct([P1,P2],[P2]):-is_lp(P1),is_lp(P2),!.
trim_last_punct([],[]):-!.
trim_last_punct([X|Xs],[X|Ys]):-trim_last_punct(Xs,Ys).

