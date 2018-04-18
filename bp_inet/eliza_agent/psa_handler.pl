% Jinni server
/*
post_method_handler(_Alist,_Template,Output):-
  println(testing),
  name(Output,"<html><body><p>test</p></body></html>"),
  stat,nl.
*/
post_method_handler(Alist,Template,Output):-
  % statistics(symbols,[SN1,_]),println(start_syms=SN1),
  url2codes(Template,Cs),
  collect_patterns(Cs,Ps),
  once(member(query=QCs,Alist)),
  once(member(login=LCs,Alist)),
  chat_step(QCs,ACs),
  make_chat_history(LCs,QCs,ACs, Hs),
  apply_patterns(Ps,[(answer=ACs),(history=Hs)|Alist],_NewAlist,Css),
  % statistics(symbols,[SN2,_]),SN is SN2-SN1,println(delta_syms=SN),
  appendN(Css,Codes),name(Output,Codes).
     
% BinProlog server  
process_alist(Socket,FileCs,Alist):-
  name(File,FileCs),
  url2codes(File,Cs),
  collect_patterns(Cs,Ps),
  process_output(Alist,Ps,Css),
  sprint_css(Socket,Css).
  
process_output(Alist1,Ps,Css):-
  % show_alist(Alist1),
  once(member(query=QCs,Alist1)),
  once(member(login=LCs,Alist1)),
  chat_step(QCs,ACs),
  make_chat_history(LCs,QCs,ACs, Hs),
  apply_patterns(Ps,[(answer=ACs),(history=Hs)|Alist1],_Alist2,Css).
 
% common code

make_chat_history(LCs,QCs,ACs, Hs):-
  appendN([LCs,": ",QCs,[10],"agent: ",ACs,[10,10]],Hs0),
  assertz(history(Hs0)),
  findall(Xs,asserted(history(Xs)),Hss),
  appendN(Hss,Hs).
  