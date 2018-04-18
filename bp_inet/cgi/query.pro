% CGI script for querying BinProlog over the net
% Copyright (C) BinNet Corp. 1998

:-['../library/cgi_lib'].

main:-run_cgi(5,body).

test:-
  %run_it(Ls,       Ps,      Ms,              Hs,      Qs,       Es)
  run_it("guest1","evrika","a@b.c.d","http://boo.com","a(X)", "a(1). a(2). ").

% POST method body
body:-
  get_cgi_input(Alist),
  Alist=
    [ login=Ls,
      passwd=Ps,
      email=Ms,
      home=Hs,
      query=Qs,
      editor=Es
   ]
->
  ( run_it(Ls,Ps,Ms,Hs,Qs,Es)->true
  ; write('Error in query: '),write_chars(Qs),nl
  )
; ( write('Non matching fields in form'),
    det_append(Alist,[],Closed),
    member(K=Xs,Closed),
    write(K),write('='),write_chars(Xs),nl,
    fail
  ; nl
  ).

run_it(Ls,Ps,Ms,Hs,Qs,Es):-
  show_identity(Ls,Ms,Hs),nl,
  write('?-'),write_chars(Qs),nl,nl,
  read_term_from_chars(Qs,Query,Vars),
  % println(query=Query+Vars),
  ( catch_query(Query,Ls,Ps,Ms,Hs,Es,Todo)-> 
    Todo
  ; sandbox,
    assert_from_chars(Es),
    ( eval_query(Query,Vars,YN)->write(YN),nl
    ; true % succeeds anyway
    ),!
  ).


% handles save/load special queries

catch_query(save,Ls,Ps,Ms,Hs,Es,Todo):-!,
  check_identity(Ls,Ps,Ms,Hs,File),
  SavedText=Es,
  Todo=log_to(File,saved_text(SavedText)).
catch_query(show,Ls,Ps,Ms,Hs,_,Todo):-!,
  check_identity(Ls,Ps,Ms,Hs,File),
  Todo=show_saved_text(File).

show_saved_text(File):-
  findall(Time-Text,term_of(File,saved_text(Time,Text)),Ts),
  reverse(Ts,Rs),
  member(Time-R,Rs),
    write('%-------------:'),write(Time),write(': ---------------------'),nl,
    write_chars(R),nl,nl,
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

show_identity(Ls,Ms,Hs):-
  write('<b>login='),write_chars(Ls),write('</b>'),nl,
  write('<i>e-mail='),write_chars(Ms),write('</i>'),nl,
  write('<i>home='),write_chars(Hs),write('</i>'),nl.

check_password_in(PFile,Login,ThisPassword,Mail,WWW,Code):-
  ( exists_file(PFile),term_of(PFile,user_id(_stamp,Login,ThatPassword,Mail,WWW))->
    ( ThatPassword==ThisPassword -> Code=good
    ; Code=bad
    )
  ; Code=new 
  ).

% one step toplevel

eval_query(Goal,[],YN):-!,(topcall(Goal)->YN=yes;YN=no).
eval_query(Goal,[V|Vs],YN):-
  topcall(Goal),
    report_var(V),report_vars(Vs),ttyprint(';'),nl,
  fail
; YN=no,!.

report_var(V=E):-ttyprin(V),ttyprin(=),ttyout(writeq(E)).

report_vars(Eqs):-
  member(Eq,Eqs),
  ttyprint(','),report_var(Eq),
  fail.
report_vars(_).
