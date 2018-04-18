answer_current_topic(Login,Password,Is,Os,_Stage):-
  try_match(Login,Password,Is,Os),
  !.

try_match(L,P,Ys,Os):-
  ensure_last(Ys,'.',Is),
  match_pattern([V:compare_word(V),This,C:together_word(C),That,'.'],Is),
  println('!!'=This+That),
  rotate_answer(This,[That,L,P],metaphor(This,That,Rs),Rs),
  ensure_last(Rs,'.',Os),
  debug_match(mx_compare,Ys,Os).
try_match(L,P,Ys,Os):-
  ensure_last(Ys,'.',Is),
  match_pattern([V:link_word(V),This,C:together_word(C),That,'.'],Is),
  rotate_answer(This,[That,L,P],relate(This,That,K-Rs),K-Rs),
  appendN([[after,scratching,my,head,K,times,',',relating],
            This,[to],That,[makes,me,think,about|Rs]],Ds),
  ensure_last(Ds,'.',Os),
  debug_match(mx_related,Ys,Os).
try_match(L,P,Ys,Os):-
  ensure_last(Ys,'?',Is),
  % What do you <know> about <life>?
  match_pattern([V:wh_word(V),do,you,Verb:is_verb_phrase([Verb|_]),about,Ws,'?'],Is),
  to_ngroup(Ws,Obs),
  rotate_answer(L,P,what_do_you(Verb,Obs,Ds),Ds),
  ensure_last(Ds,'.',Os),
  debug_match(mx_what_do_you,Ys,Os).
try_match(L,P,Ys,Os):-
  ensure_last(Ys,'?',Is),
  % What does ... mean
  match_pattern([V:wh_word(V),does,Obs,mean,'?'],Is),
  rotate_answer(L,[P,Obs],words_def(Obs,Ds),Ds),
  ensure_last(Ds,'.',Os),
  debug_match(mx_does_mean,Ys,Os).
try_match(L,P,Ys,Os):-
  ensure_last(Ys,'?',Is),
  % Who is <Caesar>?
  % What is a <Caesar salad>?
  % What do you know about
  match_pattern([V:wh_word(V),_,C:(aux_is_word(C);C=about),Ws,'?'],Is),
  to_ngroup(Ws,Xs),
  explain_words(L,P,Xs,Os),
  debug_match(mx_what_is,Ys,Os).  
try_match(L,P,Ys,Os):-
  ensure_last(Ys,'.',Is),
  % Tell me about ...
  match_pattern([V:tell_word(V),_,about,Obs,'.'],Is),
  rotate_answer(L,[P,Obs],words_ex(Obs,Ds),Ds),
  ensure_last(Ds,'.',Os),
  debug_match(mx_tell_about,Ys,Os).
    
explain_words(L,P,Ws,Es):-
  rotate_answer(L,[P,Ws],explain_words0(Ws,Es),Es).
  
explain_words0(Ws,Es):-
  ( words_def(Ws,Os),appendN([['I',know,about|Ws],[','],Os],Ds)
  ; words_ex(Ws,Os),appendN([['I',heard,this,about|Ws],[':'],Os],Ds)
  ),
  ensure_last(Ds,'.',Es).
     
what_do_you(_Verb,Obs,Ds):-
  get_obsession(Phrase), % in wx_games
  relate_words(Phrase,Obs,Rs),
  Ds=['It',is,all,about|Rs].
what_do_you(_Verb,Obs,Ds):-something_about(Obs,Ds).
what_do_you(Verb,_Obs,Ds):-something_about([Verb],Ds).
  
something_about(Ws,Ds):-
  ( words_ex(Ws,Os), appendN([['Something',about|Ws],[','],Os],Ds)
  ; words_def(Ws,Os),appendN([['I',have,never,seen,or,touched|Ws],[';'],Os],Ds)
  ).
            

