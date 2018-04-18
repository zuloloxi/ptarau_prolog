/*
 BinNet Internet Programming Toolkit
 Copyright (C) BinNet Corp. 1999,2000

 BinNet Internet Client Library version 1.0
 Author: Paul Tarau
 Last Update: Aug 20,2000

 This module implements basic client side HTTP 1.x processing.
 It allows a BinProlog program to get HTML or ASCII text pages
 from a Web server and "datamine" for links found in the page. 
 It also allows consulting BinProlog files directly from Web pages.
 
 Easy to extend and reuse, provided in source form.

 Related products: 
   BinNet HTTP server
   BinNet HTTP Internet Search Engine (spider)
*/

:-['../library/http_tools'].

% INTERFACE: use these predicates, whenever possible, instead of those
% in the IMPLEMENTATION section

/*
  reconsults a Prolog file from a Web server i.e. replaces each
  predicate with a new definition found there, asserted to the current
  database
*/

reconsult_url(AtomicURL):-
  synchronize(http2db_replace(AtomicURL)).

/*
  consults a Prolog file from a Web server i.e. asserts each
  to the current database
*/
consult_url(AtomicURL):-
  synchronize(http2db(AtomicURL)).

/*
  Opens a URL, provided as 'http://....', then gets a stream of lines
  of chars from the WWW server. It will backtrack over them. At the end,
  it fails. A query, for a URL=http://www.binnecorp.com/test.txt pointing
  to the a file contaning the lines:

  This
  is
  a test.

  will work as follow:

?-http2line('http://www.binnecorp.com/test.txt',Line).
....
....  % some header lines
....
Line=[84,104,105,115];

Line=[105,115];

Line=[97,32,116,101,115,116,46];
no


This acts like if you used 

 ?-File=[   "This","is","a test."],member(Line,File).

Use name/2 to convert each list of characters returned by Line
to an atom. Type help(read), help(write), help(chars) for
hints on various operations you can perform on each line.
*/

http2line(AtomicURL,Cs):-http2line(AtomicURL,_,Cs).

/*
 Same as http2line, but skips header lines
*/

http2content_line(AtomicURL,Cs):-http2content_line(AtomicURL,_,Cs).

/*
  Extracts links to other URLs, found in a HTML page,
  given through its URL as 'http://...' 

  Try:

  ?-http2link('http://www.binnetcorp.com',Link).

*/
http2link(AtomicURL,Link):-
  parse_url(AtomicURL,ParsedURL),
  http2line(AtomicURL,ParsedURL,Cs),
  url_in(Cs,Us),
  name(Link,Us).

/*
  extracts content of html or ascii text page, Prolog code in particular,
  one character at at time, header excluded.
  Backtracks over each character, fails at end of the stream.

  Try:

  ?-http2char('http://www.binnetcorp.com/test.txt',C),put_code(C),fail;nl.
*/

http2char(AtomicURL,C):-
  http2content_line(AtomicURL,Cs),
  (member(C,Cs)
  ;C=10
  ).



/*
extracts the content of html or ascii text page, Prolog code in particular,
to a list of charaters, headers excluded.
*/

http2chars(AtomicURL,Cs):-findall(C,http2char(AtomicURL,C),Cs).

/*
  Extract on clause at a time, from a URL pointing to a Prolog file.
  Backtracks over them, fails at the end. 
*/

http2clause(AtomicURL,Clause):-
  http2chars(AtomicURL,Cs),
  read_terms_from_chars(Cs,UnExpanded),
  expand_term(UnExpanded,Clause).

/*
  consults a URL containing Prolog code to current database
*/ 
http2db(AtomicURL):-current_db(Db),http2db(AtomicURL,Db).

/*
  consults a URL containing Prolog code to a given database
*/
http2db(AtomicURL,Db):-
  forall(http2clause(AtomicURL,Clause),db_assert(Db,Clause)).

/*
  reconsults a URL containing Prolog code to current database,
  while replacing existing predicates having the same signature
*/
http2db_replace(AtomicURL):-
  http2db(AtomicURL,AtomicURL),
  current_db(Db),
  db_move(AtomicURL,Db).

/*
  % assumes with assumei/1, all Prolog clauses at URL
*/

%assume_url(AtomicURL):-
%  findall(Clause,http2clause(AtomicURL,Clause),Cs),
%  map(assumei,Cs).

%-------------------------------------------------------------------------------%

% IMPLEMENTATION: probably no need to directly call or to change
% Try to use services provided through INTERFACE predicates, whenever possible.

% like http2line/2, but also returns the parsed URL, headers included

http2line(AtomicURL,url(Protocol,Server,Port,Path,File),Cs):-
  http2line(AtomicURL,include_header,url(Protocol,Server,Port,Path,File),Cs).

% like http2line/2, but also returns the parsed URL, headers excluded

http2content_line(AtomicURL,url(Protocol,Server,Port,Path,File),Cs):-
  http2line(AtomicURL,exclude_header,url(Protocol,Server,Port,Path,File),Cs).

http2line(AtomicURL,HeaderFlag,url(Protocol,Server,Port,Path,File),Cs):-
  parse_url(AtomicURL,Protocol,Server,Port,Path,File),
  ( Protocol='http://',
    http2header(Server,Port,Socket,Path,File,Css),
    (is_text_file(File);is_text_html(Css))
  ->
    ( HeaderFlag==include_header,member(Cs,Css) % from header
    ; get_http_line(Socket,Cs) % from upcoming body
    )
  ; Protocol='file://',is_text_file(File)->
    file2line(Path,File,Cs)
  ; debugmes(unimplemented_in(http2line(AtomicURL=>[Path,File]))),
    fail
  ).


% HTTP basics

get_http_header(Socket,Path,File,Code,Css):- 
  get_http_header("GET",Socket,Path,File,Code,Css).

% get the http header on an already open socket connection
get_http_header(Method,Socket,Path,File,Code,Css):-
  Ret=[_,_,_],
  make_cmd0([Method," ",Path,File," HTTP/1.0"],Question),
  once(appendN(["HTTP/1.",[_]," ",Ret," "],P1)),
  det_append(P1,_,Ok),
  socket_try(Socket,(
    sock_writeln(Socket,Question),
    sock_writeln(Socket,"")
  )),
  socket_try(Socket,sock_readln(Socket,Confirm)),
  !,
  (quiet(Q),Q<2->
    write('HTTP_QUERY:'),nl,
    write('<= '),write_chars(Question),nl,
    write('=> '),\+ \+ write_chars(Confirm),nl
  ; true
  ),
  Confirm=Ok,
  name(Code,Ret),
  socket_try(Socket,get_server_header(Socket,Css)),
  debug_print(Css).

get_server_header(Socket,[L|Ls]):-
  sock_readln(Socket,L),L=[_|_],!,
  get_server_header(Socket,Ls).
get_server_header(_,[]).

make_absolute(ParsedRootURL,L,Ls,NextRoot,Continuable):-
  [Pound]="#",
  ParsedRootURL=url(Protocol,Server,Port,Path,File),
  ( append("mailto:",_,Ls)->
    NextRoot=L,
    Continuable=no
  ; append("ftp://",_,Ls)->
    NextRoot=L,
    Continuable=no,
    debugmes(unimplemented_protocol(ftp))
  ; Protocol='http://',Ls=[Pound|_]->namecat(File,'',L,FileAndTag),
    unparse_url(url(Protocol,Server,Port,Path,FileAndTag),NextRoot),
    Continuable=no
  ; Protocol='http://'->
    % looks like a continuable relative link
    ([Slash]="/",Ls=[Slash|NewLs]->true
    ;NewLs=Ls
    ),
    unparse_url(url(Protocol,Server,Port,Path,NewLs),NextRoot),
    ( member(Pound,NewLs)->Continuable=no
    ; Continuable=yes
    )
  ; Protocol='file://'->
    % looks like a continuable local relative link
    unparse_url(url(Protocol,Server,Port,Path,Ls),NextRoot),
    ( is_text_file(Ls),\+ member(Pound,NewLs)->Continuable=yes
    ; Continuable=no
    )
  ; debugmes(unknown_link_not_handled_from(ParsedRootURL)+L),
    NextRoot=L,Continuable=no
  ).

http2header(Server,Port,Socket,Path,File,Css):-
  http2header("GET",Server,Port,Socket,Path,File,Css).

http2header(Method,Server,Port,Socket,Path,File,Css):-
  new_client(Server,Port,Socket),
  ( get_http_header(Method,Socket,Path,File,Code,Css),
    member(Code,[200,302])
  ->true
  ; close_socket(Socket),
    debugmes(http_request_failure(code(Code),server(Server),Port,Path,File)),
    fail
  ).

link_from_header(Xs,Cs):-append("Location: ",Cs,Xs),!.

is_text_html(Css):-member(Cs,Css),to_lower_chars(Cs,Ls),append("content-type: text/html",_,Ls),!.

get_http_line(Socket,Cs):- 
    sock_readln(Socket,Line)
  ->Cs=Line
  ; !,
    debugmes('socket read failed'),
    close_socket(Socket),
    fail.
get_http_line(Socket,Cs):-
  get_http_line(Socket,Cs).


% get URL from a line  of chars

url_in(Line,Ls):-
  findall(Us,extract_url(Line,Us),Uss),
  sort(Uss,Links),
  member(Ls,Links).

extract_url(Line,Us):-link_from_header(Line,Us),!.
extract_url(Line,Us):- 
  [Q]="""",HTTP="http://",
  extract_url([" href="""," HREF="""," url="," URL=", " src=""", " SRC="""],Q,HTTP,Us,
  Line,_LeftOver).

extract_url(Tags,Q,HTTP,Us) -->
  ( {member(Tag,Tags)},
    match_word(Tag),
    match_before([Q],Us,_) -> {true}
  ; @Q,match_word(HTTP),match_before([Q],Xs,_)->{det_append(HTTP,Xs,Us)}
  ; {fail}  
  ).
extract_url(Tags,Q,HTTP,Us)-->
  @(_),
  extract_url(Tags,Q,HTTP,Us).

% builds a URL in ascii form from its structured representation

unparse_url(Parsed,URL):-
  Parsed=url(Protocol,Server,Port,Path,File),
  ( Protocol='http://'->
    make_cmd([Protocol,Server,":",Port,Path,File],URL)
  ; Protocol='file://'->
    name(Path,Ds),unparse_drive(Ds,NewDs),
    make_cmd([Protocol,NewDs,File],URL)
  ; debugmes(unexpected_url(Parsed)),
    fail
  ).

unparse_drive([C,D |Xs],[C,B |Xs]):- [D,B]=":|",!.
unparse_drive(Xs,Xs).

% parses a URL in ascii form to ready to connect server info

parse_url(HTTP_SERVER_PATH_PORT,url(Protocol,Server,Port,Path,File)):-
  parse_url(HTTP_SERVER_PATH_PORT,Protocol,Server,Port,Path,File).

parse_url(HTTP_SERVER_PATH_PORT_FILE,Protocol,Server,Port,Path,File):-
  atom_codes(HTTP_SERVER_PATH_PORT_FILE,Cs),
  codes_words(Cs,Ws),
  xurl(Protocol,Server,Port,Ws,PsFs),
  split_pf(PsFs,Ps,Fs),
  % println(here(PsFs=Ps+Fs)),
  make_cmd(Ps,Path),
  make_cmd(Fs,File).

xurl(Hs,Ss,Ps)-->xhead(Hs),xserv(Ss),xport(Ps).
  
xhead('http://')-->[http,':','/','/'].

xserv(S)-->xserv0(Ws),{make_cmd(Ws,S)}.

xserv0([])-->ahead(':'),!.
xserv0([])-->ahead('/'),!.
xserv0([X|Xs])-->[X],!,xserv0(Xs).
xserv0([])-->[].

xport(N)-->[':',N],{integer(N)},!.
xport(80)-->[]. % ahead('/').

ahead(X,[X|Xs],[X|Xs]).

not_ahead(X,Xs,Xs):- \+(member(X,Xs)).

/* BAD
parse_url(HTTP_SERVER_PATH_PORT,Protocol,Server,Port,Path,File):-
  name(HTTP_SERVER_PATH_PORT,Us),
  parse_url0(Us,Hs,Ss,Ps,Ds,Fs),
  name(Protocol,Hs),
  name(Server,Ss),
  term_codes(Port,Ps),
  name(Path,Ds),
  name(File,Fs).
  
parse_url0(Us,Hs,Ss,Ps,Ds,Fs):-
  (nonvar(Us),var(Hs),(Us=[_|_];Us=[])->true
  ;errmes(list_of_chars_expected,Us)
  ),
  ( Hs="http://",match_word(Hs,Us,S1)->
      parse_http(Ss,Ps,Ds,Fs,S1,_)
  ; (Hs0="file://";Hs0="file:/"),match_word(Hs0,Us,S1)->Hs="file://",
      S1=DsFs,
      split_path_file(DsFs,Ds0,Fs),     
      adjust_drive_name(Ds0,Ds),
      Ss="none",Ps="none"
  ; Hs="ftp://",match_word(Hs,S1,_)-> 
      debugmes(unimplemented_protocol(ftp)),fail
  ; fail %name(Bad,Us),errmes(unexpected_http_parsing_error_in,Bad)
  ),
  !.

% args: Server,Port,Path,File, as char lists
parse_http(Ss,Ps,HexDs,HexFs,S1,S3):-
  [Slash]="/",
  ( match_before(":/",Ss,Stop,S1,S2)->
      ( [Stop]=":"->match_before([Slash],Ps,_,S2,S3)
      ; Ps="80"
      )
  ; match_word(Ss,S1,S3),Ps="80"
  ),
  S3=DsFs,
  !,
  split_path_file(DsFs,NewDs,Fs),
  !,
  eq(NewDs,HexDs),
  eq(Fs,HexFs).
 
adjust_drive_name([S,C,B |Xs],[C,D |Xs]):-[S,B,D]="/|:",!.
adjust_drive_name([C,B |Xs],[C,D |Xs]):-[B,D]="|:",!.
adjust_drive_name(Xs,Xs).
*/
