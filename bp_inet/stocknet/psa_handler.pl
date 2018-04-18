% BinProlog server  
bp_server(Port):-
  Root='.', % makes also data_dir = '.'
  bb_let(www,root,Root),
  bg(http_server(Port,none)).
  
process_alist(Socket,_FileCs,Alist):-
  process_query(_File,Alist,Css),
  sprint_css(Socket,Css).

% Jinni server
post_method_handler(Alist,TemplateFile,Output):-
  process_query(TemplateFile,Alist,Css),
  appendN(Css,Codes),name(Output,Codes).
 
% common stuff
process_query(File,Alist,Css):-
  catch(process_query1(File,Alist,Css),_any,fail),
  !.
process_query(_File,_Alist,Css):-
  Css=["<b>Bad data entry</b>"].
   
process_query1(_File,Alist,Css):-
  sheader(Hs),
  sfooter(Fs),
  member(stock=Ts,Alist),
  atom_codes(Ticker,Ts),
  statistics(runtime,_),
  stock2file(Ticker,File),
  statistics(runtime,[_,TimeMs]),
  Time is TimeMs//1000,
  number_codes(Time,Secs),
  atom_codes(File,Ns),
  show_link(Ns,Rs),
  show_last(Ticker,Ls),
  show_months(Ticker,Ms),
  show_moving(Ticker,30,As30),
  show_moving(Ticker,100,As100),
  Css=[Hs,
    "Prolog file for stock ticker: <b>",Ts,"</b>",[10,10],
    Rs,
    [10],
    "Please right click on the link and choose <i>Save Link As</i> to save the file.",
    [10,10],
    "Last Quote: ",
    Ls,
    [10,10],
    As30,
    [10,10],
    As100,
    [10,10],
    "Average Monthly Performance",
    [10,10],
    Ms,
    [10],
    "Processing time in seconds: ",
    Secs,
    Fs],
  !.

show_moving(S,N,As):-
  avg_of(S,N,V),
  make_cmd0(["The Moving Average for the last ",N," days is: ",V],As).
  
show_last(S,Ls):-
  last_of(S,N,date(WD,Y,M,D)),
  make_cmd0([N," on ",WD," ",M,"/",D,"/",Y],Ls).
  
show_months(S,Ms):-
  findall(Mx,show_month(S,Mx),Mss),
  appendN(Mss,Ms).
  
show_month(S,MsVs):-
  month_of(S,M,V),
  atom_codes(M,Ms),
  number_codes(V,Vs),
  appendN([Ms,"=",Vs,[10]],MsVs).

show_link(Ls,Rs):-
  Xss=["<A href=""",Ls,""">",Ls,"</A>",[10]],
  appendN(Xss,Rs).

sheader(H):-
  make_cmd0(
   [
     "<html><title>Jinni Server Agent Script Output</title>",
     [10],
     "<body bgcolor=ffffff>",
     [10],
     "<pre>",
     [10]
   ],
   H
  ).

sfooter(F):-
  make_cmd0([
   "</pre>",
   [10],
   "</body>",
   [10],
   "</html>",
   [10]
  ],
  F
).
