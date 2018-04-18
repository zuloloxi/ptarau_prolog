/* QA learning: minimum edit transform from Q A - try to express
   it in a way that can be generalized using things like lub - or other
   - explore Hopfield networks - use encoding based on
     classpath on gen hierarchy
     #w +1/2#s(w)+1/4#s(s(w)) ....
*/

% :-[wx_omqa].

% OpenMind processor

omdatadir('\paul\wordnet\open_mind\openminddata').

from_aiml:-
  from_aiml('orig_aiml.pl','wx_aiml.pl').

from_aiml(From,To):-
  tell(To),
  foreach(term_of(From,T),pp_clause(T)),
  nl,
  told.
/*
om_step(Qs,As):-
  is_compiled(qa(_,_)),
  aiml_step(Qs,As).
  
om_step(Qs,As):-
  is_compiled(omqa(_,_)),
  qvariant(Qs,Vs),
  omqa(Vs,As).
  
aiml_step(Qs,As):-
  call(qa([Qs|_],[[As|_]|_])).
*/

om_view:-
  new_java_object('jnet.WordGraph',G),
  foreach(term_of('wx_omqa.pl',omqa(Is,Os)),learn_qa(G,Is,Os)),
  invoke_java_method(G,draw(20),_).

om_skip:-random(M),X is M mod 50,X=:=0.
  
learn_qa(G,Is0,Os):-
  om_skip,
  (nonvar(Is0),append(S,['?'],Is0),nonvar(S),S=[_]->Is=S;Is=Is0),
  I=..[q|Is],
  O=..[a|Os],
  invoke_java_method(G,associate(I,O),_).
  
om_test:-
  clear_state,
  foreach(term_of('wx_omqa.pl',T),db_assert('om_db',T)),
  tell('../data/om_test.txt'),
    foreach(db_asserted('om_db',omqa(Is,Os)),compare_qa(Is,Os)),
  told,
  db_clean('om_db'),
  true.

compare_qa(Is,Os):-
  L='AgentTrainer',P='none',name(L,LCs),
  codes_words(ICs,Is),codes_words(OCs,Os), 
  agent_step("none",L,P,Is,As,_),
  codes_words(ACs,As),
  nl,show_chat_step(LCs,ICs,ACs),
  show_chat_step("OpenMind",ICs,OCs),
  println('--------------------------'),
  nl,nl.
    
om_step(Qs,As):-
  is_compiled(omqa(_,_)),
  debug_match(mx_entering_om_step,Qs,As), 
  qvariant(Qs,Vs),
  omqa(Vs,Rs),
  to_upper_first(Rs,As),
  debug_match(mx_existing_om_step,Qs,As).
  
  
% tools to build omqa/2 database

trim_repeated(File,NewFile):-
  db_clean(temp),
  foreach(
    ( clause_of(File,(H:-B)),
      \+ db_clause(temp,H,B)
    ),
    db_assert(temp,(H:-B))
  ),
  tell(NewFile),
  foreach(db_clause(temp,H,B),qpp((H:-B))),
  db_clean(temp).
  
  
    
  
omallfiles(Fs):-
  omdatadir(D),
  dir2files(D,Fs).
 
omlispfiles(Fs):-
  findall(F,omlispfile(F),Fs).
   
omlispfile(F):-
  omallfiles(Fs),
  member(F,Fs),
  \+(omspecfile(F)).
  
omspecfile(F):-omfile(_spec,Fs),member(F,Fs).
  
omfile(flat,[
  descriptions,
  differences,
  differencebetween2,
  i,
  is,
  it,
  ithas,
  itis,
  itisa,
  misc,
  misc2,
  misc3,
  'misc.txt',
  mostpeople,
  picturedescriptions,
  short,
  similarity,
  someone,
  somepeople,
  thatis,
  things,
  while2,
  you,
  your
  ]).
  
omfile(qa,[helpanswerquestion]).
omfile(storysteps,[storysteps]).
omfile(scenarios,[whenyoudo]). 

word_lines_of(File,Wss):-
  findall(Ws,word_line_of(File,Ws),Wss).
  
word_line_of(File,Ws):-
  see(File),
  repeat,
    ( read_words(Ws)->true
    ; seen,!,fail
    ).
    
om2ws(File,Ws):-
  omdatadir(D),
  namecat(D,'\',File,DF),
  word_line_of(DF,Ws).

om2qa(Q,A):-
  omfile(qa,Fs),member(F,Fs),
  om2ws(F,Ws),Ws=[_|_],
  lisp2qa(Ws,Q0,A0),
  fix_disj(Q0,Q),
  fix_disj(A0,A). 

om2wqa(W,QAs):-
  findall(W-qa(Q,A),om2qa([W|Q],A),WQAs),
  keygroup(WQAs,W,QAs).

fix_disj([],[]).
fix_disj([W|Ws],[F|Fs]):-
  (W=(';')->F=('.');F=W),
  fix_disj(Ws,Fs).

lisp2qa(Ws,Qs,As):-
  match_pattern([
     '(',the,statement,
     '(',A,')',
     helps,answer,the,question,
     '(',Q,')',
     ')'],Ws),
   !,
   ensure_last(Q,'?',Qs),
   ensure_last(A,'.',As).
lisp2qa(Ws,_,_):-
  println(faling_to_process_lisp_qa(Ws)),
  fail.
  
build_omqa:-
  %foreach(term_of('wx_ops_no.pl',':-'(OPY)),OPY),
  %once(current_op(Pri,Assoc,(';'))),
  %op(0,Assoc,(';')),
  tell('wx_omqa.pl'),
    foreach(om2qa(Q,A),qpp(omqa(Q,A))),
  told.
  %foreach(term_of('wx_ops_yes.pl',':-'(OPN)),OPN),
  %op(Pri,Assoc,(';'))

/*  
% learning patterns from QA

qa(Q,A)

qa(Q,A):-match(P,Q),fill_vars(P,A).


*/

% end
