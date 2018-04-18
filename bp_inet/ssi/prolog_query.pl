% example SSI script for querying BinProlog over the net
% using persistent state of BinProlog HTTP server
% Copyright (C) BinNet Corp. 1998

% for maximum performance, include server
% instead of dynamically loading scripts
%
% comment out next 2 lines if you want to
% run this as a dynamically loaded script
%

:-['../library/http_server'].

% POST method body

process_alist(Socket,File,Alist):-
   header_to(Socket),
   ( process_alist0(Socket,File,Alist)->true
   ; sprintln(Socket,ssi_query_failed(Alist))
   ),
   footer_to(Socket).
     
process_alist0(Socket,File,Alist):-
  debugmes(script_file(File)),
  Alist=
    [ login=Ls,
      passwd=Ps,
      email=Ms,
      home=Hs,
      submit_button=_Ss,
      query=Qs,
      editor=Es
   ]
->
  ( run_it(Socket,Ls,Ps,Ms,Hs,Qs,Es)->true
  ; write('Error in query: '),write_chars(Qs),nl
  )
; ( write('Non matching fields in form:'),nl,
    det_append(Alist,[],Closed),
    member(K=Xs,Closed),
    write(K),write('='),write_chars(Xs),nl,
    fail
  ; nl
  ).

run_it(Socket,Ls,Ps,Ms,Hs,Qs,Es):-
  show_identity(Socket,Ls,Ms,Hs),
  name(Db,Ls),
  sprint_css(Socket,["?-",Qs]),
  read_term_from_chars(Qs,Query,Vars),
  debugmes(query=Query+Vars),
  set_db(Db),
  ( catch_query(Query,Socket,Ls,Ps,Ms,Hs,Es,Todo)-> 
    Todo,
    debugmes(caught_query=Todo)
  ; % sandbox,
    db_clean,
    assert_from_chars(Es),
    ( eval_query(Socket,Query,Vars,YN)->sprintln(Socket,YN),debugmes(eval_query=YN)
    ; true % succeeds anyway
    ),!
  ).


% handles save/load special queries

catch_query(save,Socket,Ls,Ps,Ms,Hs,Es,Todo):-!,
  check_identity(Ls,Ps,Ms,Hs,File),
  % name(SavedText,Es),
  SavedText=Es,
  Todo=log_to(File,saved_text(SavedText)),
  sprintln(Socket,saved).
catch_query(show,Socket,Ls,Ps,Ms,Hs,_,Todo):-!,
  check_identity(Ls,Ps,Ms,Hs,File),
  Todo=show_saved_text(Socket,File).

show_saved_text(S,File):-
  exists_file(File),
  findall(Time-Text,term_of(File,saved_text(Time,Text)),Ts),
  reverse(Ts,Rs),
  member(Time-R,Rs),
    name(Time,TCs),
    sprint_css(S,["%-------------:",TCs,": ---------------------"]),
    sprint_cs(S,R),
  fail
; true.

check_identity(Ls,Ps,Ms,Hs,File):-
  PFile='users.txt',
  name(Login,Ls),name(ThisPassword,Ps),
  check_password_in(PFile,Login,ThisPassword,Mail,WWW,Code),
  ( Code=bad->errmes(password_taken_by(Login),'Try again with new login and password')
  ; Code=good->true
  ; % Code=new
    name(WWW,Hs),name(Mail,Ms),
    log_to(PFile,user_id(Login,ThisPassword,Mail,WWW))
  ),
  namecat('home/',Login,'.txt',File).

show_identity(S,Ls,Ms,Hs):-
  sprint_css(S,["<b>login=",Ls,"</b>"]),
  sprint_css(S,["<i>e-mail=",Ms,"</i>"]),
  sprint_css(S,["<i>home=",Hs,"</i>"]).

check_password_in(PFile,Login,ThisPassword,Mail,WWW,Code):-
  ( exists_file(PFile),
    term_of(PFile,user_id(_stamp,Login,ThatPassword,Mail,WWW))->
    ( ThatPassword==ThisPassword -> Code=good
    ; Code=bad
    )
  ; Code=new 
  ).

% one step toplevel

eval_query(_S,Goal,[],YN):-!,(topcall(Goal)->YN=yes;YN=no).
eval_query(S,Goal,[V|Vs],YN):-
  topcall(Goal),
    debugmes(evaluated_goal=Goal),
    report_vars(S,[V|Vs]),
  fail
; YN=no,!.

report_vars(S,Eqs):-
  member(Eq,Eqs),
  report_var(S,"  ",Eq,""),
  fail.
report_vars(S,_):-
  sprint_css(S,[";"]).

report_var(S,Pre,V=E,Post):-
  name(V,Vs),
  term_codes(E,Es),
  sprint_css(S,[Pre,Vs,"=",Es,Post]).
