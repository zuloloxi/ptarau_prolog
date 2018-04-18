csv2wss(F,Wss):-
  line_of(F,Cs),
  parse_csv(Cs,Xss),
  map(codes_words,Xss,Wss).
  
parse_csv(Cs,Xss):-parse_csv(Xss,Cs,[]).

parse_csv([Cs|Css])-->dqitem(Cs),!,parse_csv1(Css).
parse_csv([])-->[].
  
parse_csv1([Cs|Css])-->",",dqitem(Cs),!,parse_csv1(Css).
parse_csv1([])-->[].

dqitem(Cs)--> {[Q]=""""},[Q],!,match_before(Q,Cs).
dqitem(Cs)--> {[Comma]=","},plain_item(Cs,Comma).

plain_item([C|Cs],Stop)-->[C],{C=\=Stop},plain_item(Cs,Stop).
plain_item([],_)-->[].

% debug

y(T)-->[X],{println(T=>X),nl,fail}.
y(_)-->[].

y-->[X],{println(X),nl,fail}.
y-->[].
