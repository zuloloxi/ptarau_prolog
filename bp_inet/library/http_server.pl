/*
 BinNet Internet Programming Toolkit
 Copyright (C) BinNet Corp. 1999-2003

 BinNet HTTP server
*/

% :-['../library/http_tools']. % various tools - already included in http_client
:-['../library/ssi_lib']. % support for basic CGI-style queries

/*
  Runs HTTP server on default port
*/
% http_server:-http_server(8080).

/*
   Runs HTTP server on given port - see def later
*/

/*
  Runs HTTP server in background (available on platforms supporting
  multi-threading, like win32)  
*/

bg_http_server:-bg_http_server(8080).

bg_http_server(Port):-bg(http_server(Port)).

/*
  File type we want to handle:
*/

/*
handling_suffix(".pro","text/plain").
handling_suffix(".pl","text/plain").
handling_suffix(".txt","text/plain").
handling_suffix(".html","text/html").
handling_suffix(".htm","text/html").

handling_suffix(".xml","text/x-sgml").
handling_suffix(".xsl","text/x-sgml").
handling_suffix(".wrl","model/vrml"). % x-world/x-vrml

handling_suffix(".jpg","image/jpg").
handling_suffix(".gif","image/gif").
handling_suffix(".ppt","application/powerpoint").
*/

% IMPLEMENTATION

http_server:-http_server(8080).

http_server(P):-
  default_password(W),
  http_server(P,W).

http_server(Port,Password):-
  default_timeout(T),
  http_server(Port,Password,T).

http_server(Port,Password,Timeout):-
  new_server(Port,Server),
  println(http_server_started(port=Port,service_timeout=Timeout)),
  http_serve(Server,Password,Timeout,http_bg).
    
http_serve(Server,Password,Timeout,Closure):-
  repeat,
    ( new_service(Server,Timeout,Service)->
      call(Closure,http_service_loop(Service,Password)),
      fail
    ; true
    ),
    !.

http_fg(Goal):-Goal.

http_bg(Goal):-http_bg(4000,1000,1000,Goal).

http_bg(H,S,T,Goal):-
  call_ifdef(bg(Goal,H,S,T,Thread,EngineAddr,EngineID),bg(Goal)),
  debugmes(starting_http_task(Goal,H,S,T,Thread,EngineAddr,EngineID)).

starting_http_service:-let(http_service_finished,no).
stop_http_service:-let(http_service_finished,yes).
http_service_stopped:-val(http_service_finished,yes).

http_service_loop(Service,_Password):-
  starting_http_service,
  %repeat,
    ( http_service_stopped->true
    ; line_server_step(Service)->fail
    ; true
    ),
  !,
  'close_socket'(Service).
  

/*
   Basic server step, triggered by
   each client connection.
*/
line_server_step(Socket):-
  (val(fallback,server,FallBackServer)->true
  ; FallBackServer="http://localhost:80/"
  ),
  socket_try(Socket,sock_readln(Socket,Question)),
  http_get_client_header(Socket,Css),
  http_process_query(Socket,Question,Css,FallBackServer).

/*
  Processes query, coming in on socket.
*/
http_process_query(Socket,Qs,Css,FallBackServer):-
 quiet(Quiet),
 synchronize((Quiet<2->write('QUERY='),write_chars(Qs),nl;true)),
 synchronize((Quiet<2->forall(member(Cs,Css),(write_chars(Cs),nl));true)),
 (
  member(Ms,["GET ","POST "]),match_word(Ms,Qs,Qs1),
  match_before(" ",PathFile,_,Qs1,Qs2),
  match_word("HTTP/",Qs2,_version),
  name(Method,Ms)
  % ,println('$method' = Method+Ms)
  ->
    ( % handles a request for a text/html file
      Method=='GET ',
      split_path_file(PathFile,Ds0,Fs),
      www_root(WR),name(WR,Rs),det_append(Rs,Ds0,Ds)
      %,has_text_file_sufix(Fs,Suf),
      % handling_suffix(Suf,Type)
      ->
      % make_cmd(["!!!",Qs,"!!!root=",WR],Cmd),println(Cmd),
      http_serve_GET(Socket,Ds,Fs)
    ;
      % handles CGI script style requests to run Prolog code
      Method=='POST '
      ->
      www_root(WR),name(WR,Ws),det_append(Ws,PathFile,PF),
      http_serve_POST(Socket,PF,Css)
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
  socket_try(Socket,sock_readln(Socket,L)),L=[_|_],!,
  http_get_client_header(Socket,Ls).
http_get_client_header(_,[]).

/*
  Writes a line on open socket
*/
http_send_line(Socket,Line):-
  %det_append(Line0,[13],Line), %DOES NOT WORK
  socket_try(Socket,sock_writeln(Socket,Line)).
  
% handles GET request for a file
http_serve_GET(Socket,Ds,Fs0):-
  % quiet(0),
  trim_query_hints(Fs0,Fs),
  % synchronize((println("trimmed"),write_chars(Fs),nl)),
  name(Path,Ds),name(File,Fs),
  println('GET_sends:'(Path,File)),
  namecat(Path,'',File,PF),
  fopen(PF,'rb',Handle),fsize(Handle,Len),
  (socket_try(Socket,http_send_bytes(Socket,Handle,Len))->true;true),
  fclose(Handle),
  fail
; true.

trim_query_hints(Fs0,Fs):-
  % println(here=Fs0),
  [Q]="?",once(member(Q,Fs0)),
  append(Fs1,"?embed",Fs0),
  !,
  Fs=Fs1.
trim_query_hints(Fs,Fs).  

http_send_bytes(Socket,Handle,Len):-
  send_header(Socket,'text/html'), % type is actually ignored
  make_cmd0(["Content-Length: ",Len],CLen),
  http_send_line(Socket,CLen),
  http_send_line(Socket,""),
  file_to_sock(Len,Handle,Socket).
  
file_to_sock(Len,Handle,Socket):-
   Max is 1<<14,
   Times is Len // Max,
   Extra is Len mod Max,
   sock_write_all(Extra,Handle,Socket),
   for(_I,1,Times),
     % println(here=I/Len),
     sock_write_all(Max,Handle,Socket),
   fail.
file_to_sock(_Len,_Handle,_Socket).

sock_write_all(N,F,S):-
  findall(C,nfgetc(N,F,C),Cs),
  sock_write(S,Cs,N).
  
nfgetc(N,F,C):-
  for(_,1,N),
  fgetc(F,C).
    
% handles POST query from CGI forms
http_serve_POST(Socket,PathFile,Css):-
  quiet(Q), Q<2,
  println('READING_SOCKET'(Socket)),
  write('POST QUERY ARG: '),write_chars(PathFile),nl,
  member(Cs,Css),
  write_chars(Cs),nl,
  fail
; 
  get_content_length(Css,L),
  debugmes('!!!content-length'=L),
  get_user_agent(Css,Agent),
  debugmes('!!!user-agent'=Agent),
  send_header(Socket,"text/html"),
  http_send_line(Socket,""),
  run_ssi(Socket,L,Agent,PathFile).

% sends back header to client
send_header(Socket,_Type):-
  http_send_line(Socket,"HTTP/1.0 200 Ok").
  % http_send_line(Socket,"Content Type: x-world/x-vrml").
  % http_send_line(Socket,"Content Type: model/vrml").
 
% extracts content-length info from header
get_content_length(Css,L):-
  get_header_field("content-length: ",Css,Ls),
  name(L,Ls).

% extracts content-length info from header
get_user_agent(Css,Agent):-
  get_header_field("user-agent: ",Css,Cs),
  match_before(" ",As,_Stop,Cs,_EndCs),
  !,
  name(Agent,As).

get_header_field(Name,Css,Ls):-
  nonvar(Css),
  append(Name,Ls,Ys),
  member(Xs,Css),
  to_lower_chars(Xs,Ys),
  !.

read_socket_input(UserAgent,L,Socket,Cs):-
  debugmes(user_agent(L)=UserAgent),
  socket_try(Socket,read_socket_input0(UserAgent,L,Socket,Cs)).

read_socket_input0('mozilla/4.0',L,Socket,Cs):-!, % 'mozilla/4.0' explorer
  sock_read(Socket,L,Cs),
  % makes Explorer 6.0 work but blocks Mozilla 1.x
  % by reading the extra CrLf wrongly put after the POST input
  debugmes(starting_eol_read(L)),
  timed_call(eol_read,sock_readln(Socket,_discardEmptyEOL),3,R),
  debugmes(ending_eol_read(R)).
read_socket_input0('mozilla/5.0',L,Socket,Cs):-!,
  % makes Mozilla 1.x happy - this seems the correct thing
  sock_read(Socket,L,Cs).
read_socket_input0(_OtherUserAgent,L,Socket,Cs):-!,
  % this seems o be the correct thing - let's make it default action
  sock_read(Socket,L,Cs).  
