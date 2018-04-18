:-[psa_step]. % application specific code

% file processing happens in data_dir - 
% which defaults to '.' if <www,root> is set to '.'

% BinProlog server  
bp_server(Port):-
  Root='.', % makes also data_dir = '.'
  bb_let(www,root,Root),
  bg(http_server(Port,none)).
  
process_alist(Socket,FileCs,Alist):-
  name(File,FileCs),
  url2codes(File,Cs),
  collect_patterns(Cs,Ps),
  process_output(Alist,Ps,Css),
  sprint_css(Socket,Css).
  
process_output(Alist1,Ps,Css):-
  % show_alist(Alist1),
  once(member(query=QCs,Alist1)),
  psa_step(QCs,ACs),
  make_chat_history("guest",QCs,ACs, Hs),
  apply_patterns(Ps,[(answer=ACs),(history=Hs)|Alist1],_Alist2,Css).

% Jinni server
jinni_server(Port):-bg(run_http_server(Port,'.')).

post_method_handler(Alist,Template,Output):-
  % statistics(symbols,[SN1,_]),println(start_syms=SN1),
  url2codes(Template,Cs),
  collect_patterns(Cs,Ps),
  once(member(query=QCs,Alist)),
  psa_step(QCs,ACs),
  make_chat_history("guest",QCs,ACs, Hs),
  apply_patterns(Ps,[(answer=ACs),(history=Hs)|Alist],_NewAlist,Css),
  % statistics(symbols,[SN2,_]),SN is SN2-SN1,println(delta_syms=SN),
  appendN(Css,Codes),name(Output,Codes).
     
% common code
make_chat_history(LCs,QCs,ACs, Hs):-
  appendN([LCs,": ",QCs,[10],"agent: ",ACs,[10,10]],Hs0),
  assertz(history(Hs0)),
  findall(Xs,asserted(history(Xs)),Hss),
  appendN(Hss,Hs).
  
