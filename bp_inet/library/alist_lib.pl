:-['../library/match_lib'].

/**
get_patterns(URL,Vars,Pattern):

  Induces a pattern from annotated prototypes
  to be used on real Web pages. Two simple annotations
  are used:
  
  {{!...}} means ask/create clauses based on input.
  
  {{?...}} means tell/paste the results)
*/


collect_patterns(Cs,Ps):-collect_patterns(Ps,End,Cs,End).

collect_patterns([text(T),pattern(P)|Ps],End) --> 
  match_internal([T,"{{",P,"}}"]),
  !,
  collect_patterns(Ps,End).
collect_patterns([text(End)],End)-->[].
 
show_patterns(Ps):-
  member(P,Ps),
  P=..[F,Cs],
  write(F),write(': <'),write_chars(Cs),write('>'),nl,
  fail
; nl.

apply_patterns(Ps,Alist1,Alist2,Css):-apply_patterns(Ps,Alist1,Alist2,Css,[]).

apply_patterns([],S,S)-->[].
apply_patterns([P|Ps],S1,S3)-->apply_pattern(P,S1,S2),apply_patterns(Ps,S2,S3).

apply_pattern(text(T),S,S)-->[T].
apply_pattern(pattern(P),S1,S2)-->{P=[Op|Cs],eval_pattern(Op,Cs,S1,S2,R)},[R].

eval_pattern(Op,Cs,Alist1,Alist2,NewCs):-[Op]="?",
  !,
  name(Key,Cs),
  % get from alist and paste into page
  alist_get(Key,NewCs,Alist1,Alist2).
eval_pattern(Op,Cs,Alist1,Alist2,[]):-[Op]="!",
  !,
  term_codes(Key=Val,Cs),
  name(Val,Vs),
  % get from page and put into alist
  alist_put(Key,Vs,Alist1,Alist2).
eval_pattern(Op,Cs,Alist,Alist,[Op|Cs]):-
  name(N,[Op|Cs]),
  println('!!!undefined_or_psa_pattern'(N)).

alist_get(Key,Cs,Alist,NewAlist):-member(Key=Cs,Alist),!,NewAlist=Alist.
alist_get(_Key,[],Alist,Alist).
% alist_get(Key,Cs,Alist,Alist):-name(Key,Ks),det_append("$not_found:",Ks,Cs).

alist_put(Key,Cs,Alist,[(Key=Cs)|Alist]).

show_alist(Alist):-
  nonvar(Alist),
  member((K=Cs),Alist),
  write(K),write('='),write_chars(Cs),nl,
  fail
; true.

