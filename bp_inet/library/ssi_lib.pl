% BinProlog SSI library
% Copyright (C) BinNet Corp. 1998-1999
% Author: Paul Tarau
% version 9.x

:-['../library/script_tools'].
:-['../library/psa_lib'].

/*
library supporting SSI scripts for querying BinProlog over the net
using persistent state of BinProlog HTTP server http_server.pl

see example: http_query.pl
*/

% runs a script using POST method to read input over a socket
% end to return output to the browser

run_ssi(Socket,ContentLength,Agent,File):-
  run_cgi(0,Socket,ContentLength,Agent,File).

run_cgi(Timeout,Socket,ContentLength,Agent,File):-
  tcall(Timeout,
    run_cgi_goal(Socket,ContentLength,Agent,File)
  ).

run_cgi_goal(Socket,L,Agent,File):-
  interactive(no),
  %let(socket,Socket),
  %let(content_length,L),
  %let(user_agent,Agent),
  %let(action_file,File),
  debugmes('HEADER cgi_goal'),
  % header_to(Socket),
  debugmes('POST_START_GOAL'),
  (to_data_dir,body(Socket,L,Agent,File)->debugmes('FAILED_GOAL')),
  % footer_to(Socket),
  debugmes('POST_END_GOAL').
  
body(S,L,A,F):-
  debugmes('STARTING_SCRIPT_BODY'),
  %val(socket,S),
  %val(content_length,L),
  %val(user_agent,A),
  %!,
  debugmes('START_READ_SOCKET_INPUT'(S,length(L),agent(A),file(F))),
  read_socket_input(A,L,S,Cs),
  debugmes('END_READ_SOCKET_INPUT'(S,length(L),agent(A),file(F))),
  split_post(Cs,Alist),
  debugmes('POST_QUERY_DECODED'(Alist)),
  process_alist(S,F,Alist),
  !.
body(S,L,A,F):-
  println('PROCESSING BODY FAILS!'(S,L,A,F)).
  
/*
  writes a term T to current service socket
*/

snl(S):-sprint_cs(S,[10]).
  
sprintln(S,T):-
  term_codes(T,Cs),
  synchronize(sock_writeln(S,Cs)).

sprint_cs(S,Cs):-
  synchronize(sock_writeln(S,Cs)).
  
/*
  writes a list of char lists like ["hello ","world"] 
  to current service socket
*/

sprint_css(S,Css):-
   appendN(Css,Cs),
   synchronize(sock_writeln(S,Cs)).
  
% writes back HTTP answer header to client
header_to(S):-
  header(H),
  synchronize(sprint_cs(S,H)).


% last thing written back on service socket
footer_to(S):-
  footer(F),
  synchronize(sprint_cs(S,F)).

show_document(Socket,BaseURL,File,Frame):-
  make_document(BaseURL,File,Frame,Cmd),
  synchronize(sprint_cs(Socket,Cmd)).

/*
sprintln(T):-
  val(socket,S),
  term_codes(T,Cs),
  sock_writeln(S,Cs).

sprint_cs(Cs):-
  val(socket,S),
  sock_writeln(S,Cs).

sprint_css(Css):-
   val(socket,S),
   sprint_css(S,Css).
*/