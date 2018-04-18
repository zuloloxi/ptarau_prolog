% BinProlog CGI library
% Copyright (C) BinNet Corp. 1998-2003
% Author: Paul Tarau
% version 9.x

:-['../library/deprecated.pl'].
:-['../library/http_tools'].

:-['../library/script_tools'].

run_cgi(Goal):-run_cgi_goal(Goal,0). % no timeout

run_cgi(Timeout,Goal):-run_cgi(Timeout,Goal,0).

run_cgi(Timeout,Goal,ContentLength):-
  tcall(Timeout,run_cgi_goal(Goal,ContentLength)).

run_cgi_goal(Goal,L):-
  interactive(no),
  header,
  let(content_length,L),
  debugmes('POST_START_GOAL'(Goal)),
    (to_data_dir,Goal->true;debugmes('FAILED_GOAL')),
  debugmes('POST_END_GOAL'),
  footer.

header:-
  % quiet(6),
  println('Content-type: text/html'),nl,
  header(Cs),
  name(H,Cs),
  write(H).

footer:-
  footer(Cs),
  name(F,Cs),
  write(F),
  quiet(5).

get_cgi_fields(Pred,Schema,Record):-
  get_cgi_input(Input),
  extract_cgi_fields(Input,Pred,Schema,Record).

get_cgi_input(Alist):-
  get_content_length(C),
  read_input(C,Input),
  % write('INPUT: '),write_chars(Input),nl, % debug!
  split_post(Input,Alist).

% reads to a list of chars
read_input(0,[]):-!.
read_input(N,[C|Cs]) :-
        N>0,
        get0(C),
        N1 is N - 1,
        read_input(N1,Cs).

get_content_length(L):-
  ( unix_getenv('CONTENT_LENGTH',CLS)->name(CLS,CL),name(L,CL)
  ; val(content_length,L0)->println(got_it(L0)),L=L0
  ; errmes('cgi error: maybe_not_in script mode','undefined: CONTENT_LENGTH')
  ).

show_document(BaseURL,File,Frame):-
  make_document(BaseURL,File,Frame,Cmd),
  write(' '),write(Cmd),nl.
