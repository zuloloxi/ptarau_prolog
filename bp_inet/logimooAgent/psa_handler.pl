% Jinni server
post_method_handler(Alist,TemplateFile,Output):-
  process_query(TemplateFile,Alist,Css),
  %println(alist=Alist),
  appendN(Css,Codes),name(Output,Codes).
  
% BinProlog server  
process_alist(Socket,FileCs,Alist):-
  name(TemplateFile,FileCs),
  process_query(TemplateFile,Alist,Css),
  sprint_css(Socket,Css).
  
% common stuff

run_chat_step(LSs,LCs,PCs,QCs,ACs):-
  Host=localhost,
  Port=7002,
  Goal=chat_step(LSs,LCs,PCs,QCs,ACs),
  Password=none,
  Answer=ACs,
  println(remote_run(Host,Port,Answer,Goal,Password,Reply)),
  As="ok",
  % remote_run(chat_step(LSs,LCs,PCs,QCs,ACs)),
  ( Reply=the(As)->ACs=As
  ; ACs="Sorry, I have failed to contact my agent server"
  ).
  
process_query(File,Alist,Css):-
  %statistics(symbols,[SN1,_]),println(start_syms=SN1),
  % show_alist(Alist),
  url2codes(File,Cs),
  collect_patterns(Cs,Ps),
  once(member(query=QCs,Alist)),
  if(member(login=LCs,Alist),true,LCs="you"),
  if(member(passwd=PCs,Alist),true,PCs=""),
  if(member(story=LSs,Alist),true,LSs=""),
  run_chat_step(LSs,LCs,PCs,QCs,ACs),
  get_chat_history(LCs,PCs,QCs,ACs,Hs),
  %statistics(symbols,[SN2,_]),SN is SN2-SN1,println(delta_syms=SN),
  to_spoken(ACs,SACs),to_spoken(QCs,SQCs),
  apply_patterns(Ps,[(spoken_answer=SACs),(spoken_query=SQCs),(answer=ACs),(history=Hs)|Alist],_NewAlist,Css),
  !.
process_query(_File,_Alist,Css):-
  Css=["System Error: Unexpected Script Failure!"].
  

get_chat_history("","",_,_,Hs):-!,Hs="Chat history will display only if you chose a <b>login</b> and <b>password!</b>".
get_chat_history(LCs,PCs,QCs,ACs,Hs):-
  find_at_most(8,Es,get_history_element(LCs,PCs,QCs,ACs,Es),Ess),
  reverse(Ess,Hss),
  appendN(Hss,Hs).
  
get_history_element(LCs,PCs,Q0s,A0s,Es):-
  name(Login,LCs),name(Passwd,PCs),
  asserta(user_qa(Login,Passwd,Q0s,A0s)),
  asserted(user_qa(Login,Passwd,Qs,As)),
  appendN([LCs,": ",Qs,[10],"agent: ",As,[10,10]],Es).

to_spoken([]," ").  
to_spoken(Cs,As):-map(to_alpha,Cs,As).

to_alpha(X,R):-
  [A,Z,LA,LZ,N0,N9]="AZaz09",
  ( X>=A,X=<Z
  ; X>=LA,X=<LZ
  ; X>=N0,X=<N9
  ; member(X,",.?!:;-'")
  ),
  !,
  R=X.
to_alpha(_,S):-[S]=" ".

  
  
  
    