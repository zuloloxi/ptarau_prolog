% example SSI script for querying BinProlog over the net
% using persistent state of BinProlog HTTP server
% Copyright (C) BinNet Corp. 1998

% for maximum performance, include server
% instead of dynamically loading scripts
%
% comment out next 2 lines if you want to
% run this as a dynamically loaded script
%

% :-['../http_server']. % contains ../server/ssi_lib.pl et ../library/http_tools.pl
:-[http_server].
:-[ssi_lib].
:-[http_tools].
:-[moo].
:-[cgi_guest].
%:-[english].

%password(none).
%login(wizard).

main:-go.

go:-%sandbox, % secure execution
    P=8888,
    println(http_server_on_port(P)),
    http_server(P).

%oldserver:-logimoo_server.
%server:-http_server. % run server on this port

% called from ../cgi/http_query.html

% POST method body

body:-
  assumed(socket(S)),
  assumed(content_length(L)),!,
  read_socket_input(L,S,Cs),
  split_post(Cs,Alist),
  process_alist(S,Alist).
body:-
  println('PROCESSING BODY FAILS!').

process_alist(Socket,Alist):-
  Alist=
    [ login=Ls,
      passwd=Ps,
      email=Ms,
      home=Hs,
      language=Ns,
      query=Qs,
      editor=Es
   ]
->
  ( run_it(Socket,Ls,Ps,Ms,Hs,Ns,Qs,Es)->true
  ; writeln(["Error in query: ",Qs])
  )
; ( writeln(["Non matching fields in form"]),
    det_append(Alist,[],Closed),
    member(K=Xs,Closed),name(K,Ks),
    writeln([Ks,"=",Xs]),
    fail
  ; wnl
  ).

run_it(Socket,Ls,Ps,Ms,Hs,Ns,Qs,Es):-
  show_identity(Socket,Ls,Ms,Hs),
  name(L,Ls),name(P,Ps),name(H,Hs),name(M,Ms),name(N,Ns),
  ( member(N,[french,spanish,chinese])->Language=N
  ; Language=english
  ),
  sprint_css(Socket,["<= ",Qs]),
  traceln(chars=Qs),
  % sprint_cs(Es),
  assume_from_chars(Es), % assumes temporary code from Prolog window
  password(P)=>>home(H)=>>email(M)=>>[Language]=>
  ( [CmdTag]="@",Qs=[CmdTag|CmdQs],read_term_from_chars(CmdQs,Query,Vars),
    eval_query(Query,Vars,YN)->sprintln(YN)
  ; iam(L),eval_nat(Qs)->true
  ; writeln(['error: query failed!'])
  ).

show_identity(S,Ls,Ms,Hs):-
  sprint_css(S,["<b>login=",Ls,"</b>"]),
  sprint_css(S,["<i>e-mail=",Ms,"</i>"]),
  sprint_css(S,["<i>home=",Hs,"</i>"]).

% one step toplevel

eval_query(Goal,[],YN):-!,(topcall(Goal)->YN=yes;YN=no).
eval_query(Goal,[V|Vs],YN):-
  topcall(Goal),
    report_vars([V|Vs]),
  fail
; YN=no,!.

report_vars(Eqs):-
  assumed(socket(S)),!,
  report_vars(S,Eqs).

report_vars(S,Eqs):-
  member(Eq,Eqs),
  report_var(S,"  ",Eq,""),
  fail.
report_vars(S,_):-
  sprint_css(S,[";"]).

report_var(S,Pre,V=E,Post):-
  name(V,Vs),
  term_chars(E,Es),
  sprint_css(S,[Pre,Vs,"=",Es,Post]).
