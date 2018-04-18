/*
 BinNet Internet Programming Toolkit
 Copyright (C) BinNet Corp. 1999

 BinNet HTTP server
*/


%:-['../library/http_tools']. % various tools
%:-['../server/ssi_lib']. % support for basic CGI-style queries

/*
  Runs HTTP server on default port
*/
http_server:-http_server(8888).

/*
   Runs HTTP server on given port
*/

http_server(Port):-port(Port)=>>run_line_server.

/*
  Runs HTTP server in background (available on platforms supporting
  multi-threading, like win32)  
*/

bg_http_server:-bg_http_server(8888).

bg_http_server(Port):-bg(http_server(Port)).

/*
  File type we want to handle:
*/

handling_suffix(S,T):-is_assumed(suffix(_,_)),!,assumed(suffix(S,T)),!.
handling_suffix(".pro","text/plain").
handling_suffix(".pl","text/plain").
handling_suffix(".txt","text/plain").
handling_suffix(".html","text/html").
handling_suffix(".htm","text/html").


% IMPLEMENTATION

run_line_server:-
  % we override generic server with special action
  server_action(line_server_action)=>>run_server.
 
line_server_action(ServiceSocket):-
  % defines http server specific action step
  socket(ServiceSocket)=>>line_server_step(ServiceSocket).

/*
   Basic server step, triggered by
   each client connection.
*/
line_server_step(Socket):-
  ( assumed(fallback_server(FallBackServer))->true
  ; FallBackServer="http://localhost:80"
  ),
  server_try(Socket,sock_readln(Socket,Question)),
  http_get_client_header(Socket,Css),
  http_process_query(Socket,Question,Css,FallBackServer).

/*
  Processes query, coming in on socket.
*/
http_process_query(Socket,Qs,Css,FallBackServer):-
  quiet(Quiet),
  (Quiet<3->write_chars(Qs),nl;true),
  (Quiet<2->forall(member(Cs,Css),(write_chars(Cs),nl));true),
  (
  #<Qs,
  member(Ms,["GET ","POST "]),match_word(Ms),
  match_before(" ",PathFile,_),
  match_word("HTTP/"),
  #>_version,
  name(Method,Ms)
  ->
    ( % handles a request for a text/html file
      Method=='GET ',
      split_path_file(PathFile,Ds,Fs),
      has_text_file_sufix(Fs,Suf),
      handling_suffix(Suf,Type)
      ->
      send_header(Socket,Type),
      http_serve_GET(Socket,Ds,Fs)
    ;
      % handles CGI script style requests to run Prolog code
      Method=='POST '
      ->
      send_header(Socket,"text/html"),
      http_serve_POST(Socket,PathFile,Css)
    ; 
      % delegates what it cannot handle to a default HTTP server
      write('redirecting '),write_chars(PathFile),nl,
      http_send_line(Socket,"HTTP/1.0 302 Found"),
      make_cmd0(["Location: ",FallBackServer,PathFile],Redirect),
      http_send_line(Socket,Redirect),
      http_send_line(Socket,"")
    )
  ; write_chars("*** server error on: "),write_chars(Qs),nl
  ),
  % println(closing_socket(Socket)),
  close_socket(Socket).

/*
  Reads header info from client
*/
http_get_client_header(Socket,[L|Ls]):-
  server_try(Socket,sock_readln(Socket,L)),L=[_|_],!,
  http_get_client_header(Socket,Ls).
http_get_client_header(_,[]).

/*
  Writes a line on open socket
*/
http_send_line(Socket,Line):-
  server_try(Socket,sock_writeln(Socket,Line)).

% handles GET request for a file
http_serve_GET(Socket,Ds,Fs):-
  name(Path,Ds),name(File,Fs),
  file2line(Path,File,Cs),
  http_send_line(Socket,Cs),
  fail
; true.

% handles POST query from CGI forms
http_serve_POST(Socket,PathFile,Css):-
  quiet(Q), Q<2,
  println('READING_SOCKET'(Socket)),
  write('QUERY ARG: '),write_chars(PathFile),nl,
  member(Cs,Css),
  write_chars(Cs),nl,
  fail
; 
  get_content_length(Css,L),
  %println(cl=L),
  % UNCOMMENT next line IF YOU WANT TO DYNAMICALLY LOAD SCRIPT GIVEN AS PathFile
  % [PathFile]=>
  run_ssi(Socket,L).

% sends back header to client
send_header(Socket,Type):-
   http_send_line(Socket,"HTTP/1.0 200 Ok"),
   http_send_line(Socket,"Server: BinNet Server 1.0"),
   det_append("Content-type: ",Type,Line),
   http_send_line(Socket,Line),
   http_send_line(Socket,"").

% extracts content-length info from header
get_content_length(Css,L):-
  nonvar(Css),
  append("content-length: ",Ls,Ys),
  member(Xs,Css),
  to_lower_chars(Xs,Ys),
  !,
  name(L,Ls).

% reads a char from socket
read_socket_char(Socket,C):-
  sock_readln(Socket,L),
  ( member(C,L)
  ; C=10
  ; read_socket_char(Socket,C)
  ).
  
% reads input chars Cs, using content length L, from Socket
read_socket_input(L,Socket,Cs):-
  find_at_most(L,C,read_socket_char(Socket,C),Cs).
  