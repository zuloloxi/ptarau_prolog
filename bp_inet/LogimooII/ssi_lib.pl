% BinProlog SSI library
% Copyright (C) BinNet Corp. 1998-1999
% Author: Paul Tarau
% version 7.00

/*
library supporting SSI scripts for querying BinProlog over the net
using persistent state of BinProlog HTTP server http_server.pl

see example: http_query.pl
*/

% runs a script using POST method to read input over a socket
% end to return output to the browser

run_ssi(Socket,ContentLength):-run_cgi(5,body,ContentLength,Socket).

run_cgi(Goal):-run_cgi_goal(Goal,0). % no timeout

run_cgi(Timeout,Goal):-run_cgi(Timeout,Goal,0).

run_cgi(Timeout,Goal,ContentLength,Socket):-
  tcall(Timeout,run_cgi_goal(Goal,ContentLength,Socket)).


run_cgi_goal(Goal,L,Socket):-
  interactive(no),
  socket(Socket)=>>content_length(L)=>>
    (header,Goal,footer).

/*
  writes a term T to current service socket
*/
sprintln(T):-
  assumed(socket(S)),!,
  term_chars(T,Cs),
  sock_writeln(S,Cs).

sprint_cs(Cs):-
  assumed(socket(S)),!,
  sock_writeln(S,Cs).

/*
  writes a list of char lists like ["hello ","world"] 
  to current service socket
*/
sprint_css(Css):-
   assumed(socket(S)),
   sprint_css(S,Css).

sprint_css(S,Css):-
   appendN(Css,Cs),
   sock_writeln(S,Cs).
  
% writes back HTTP answer header to client
header:-
  header(H),
  sprint_cs(H).

header(H):-
  make_cmd0(
   [
     %"content-type: text/html",
     %[10,10],
     "<html><title>BinProlog SSI output</title>",
     [10],
     "<body bgcolor=ffffff>",
     [10],
     "<pre>",
     [10]
   ],
   H
  ).

% last thing written back on service socket
footer:-
  footer(F),
  sprint_cs(F).

footer(
"</pre>
</body>
</html>
").

% extracts records of data from input
extract_cgi_fields(Input,Pred,Schema,Record):-
  map(eq1,Input,FieldNames),
  map(eq2,Input,CharListVals),
  map(name1,CharListVals,Vals),
  Schema=..[Pred,transaction_number|FieldNames],
  abstime(Time),
  Record=..[Pred,Time|Vals],
  !.
extract_cgi_fields(Input,_,_,_):-
  \+ errmes(bad_input,Input).

eq1(A=_,A).
eq2(_=B,B).

name1(Cs,N):-name(N,Cs).

% gets integer in range, arith. mean if Min,Max if out
get_in_range(Mes,Cs,Min,Max,Val):-
  term_chars(N,Cs),
  ( integer(N),N>=Min,N=<Max->Val is N
  ; Val is (Min+Max)//2,
    write(Mes),write(': value from '),write(Min),write(' to '),
    write(Max),write(' expected, assumed '),
    write(Val),nl
  ).

parse_input([],[]).
parse_input([X|Xs],YYs):-
  ( [X]="%",Xs=[A,B|NewXs],compute_code(A,B,Y)-> (Y=:=13->YYs=Ys;YYs=[Y|Ys])
  ; [X]="+"->NewXs=Xs,YYs=[32|Ys]
  ; NewXs=Xs,YYs=[X|Ys]
  ),
  parse_input(NewXs,Ys).

% hex to decimal

compute_code(A,B,Y):-
  to_digit(A,DA),to_digit(B,DB),
  Y is 16*DA+DB.
	
%digits
to_digit(48,0).
to_digit(49,1).
to_digit(50,2).
to_digit(51,3).
to_digit(52,4).
to_digit(53,5).
to_digit(54,6).
to_digit(55,7).
to_digit(56,8).
to_digit(57,9).

% A..F
to_digit(65,10).
to_digit(66,11).
to_digit(67,12).
to_digit(68,13).
to_digit(69,14).
to_digit(70,15).

% a..f
to_digit(97,10).
to_digit(98,11).
to_digit(99,12).
to_digit(100,13).
to_digit(101,14).
to_digit(102,15).

% POST method parser

split_post(Cs,Ws):-dcg_def(Cs),post(Ws),!,dcg_val([]).
   
post([W|Ws]):-assoc(W),star(dassoc,Ws).

assoc(Key=NewYs) :- 
  plus(nodelim,Xs),delim("="),star(nodelim,Ys),
  parse_input(Xs,NewXs),
  parse_input(Ys,NewYs),
  name(Key,NewXs).

dassoc(Xs):- delim("&"),assoc(Xs).

delim([X]):- #X.

nodelim(X):- #X, \+ member(X,"&=").

% NL tokenizer - converts NL strings of chars to lists of words

chars_words(Cs,Ws):-dcg_def([32|Cs]),words(Ws),!,dcg_val([]).

words(Ws):-star(word,Ws),space.

word(W):-space,(plus(is_letter,Xs);one(is_punct,Xs)),!,name(W,Xs).

space:-star(is_space,_).

is_space(X):- #X, member(X,[32,7,9,10,13]).

is_letter(X):- #X, is_an(X).

is_punct(X):- #X. %, (is_spec(X);member(X,"!,;`""'()[]{}*")).


% regexp tools with  AGs + high order

one(F,[X]):- call(F,X).

star(F,[X|Xs]):- call(F,X),!,star(F,Xs).
star(_,[]).

plus(F,[X|Xs]):- call(F,X),star(F,Xs).

% environment variables handling tools

/*
get_content_length(L):-
  ( unix_getenv('CONTENT_LENGTH',CLS)->name(CLS,CL),name(L,CL)
  ; assumed(content_length(L0))->println(got_content_length(L0)),L=L0
  ; errmes('cgi error: maybe_not_in script mode','undefined: CONTENT_LENGTH')
  ).
*/

show_file(F):-
  file2chars(F,Xs),
  forall(
    member(X,Xs),
    put(X)
  ).

log_to(File,Term):-
  abstime(T),functor(Term,F,_),
  Head=..[F,T],
  term_append(Head,Term,Record),
  tell_at_end(File),
    pp_clause(Record),
  told.

toBinNet:-
   println('<a href="http://www.binnetcorp.com/index.html" target=_parent>Back to BinNet''s HomePage</a>').


% call with a timout mechanism: avoids locking buggy HTTP servers:-)

tcall(T,Goal):-timed_call(_,Goal,T,R),
  ( R=the(_)->true
  ; println(cgi_execution_error(timeout(T),goal(Goal),result(R)))
  ).

/*
  Generates Java script which, if used in a CGI script
  instructs the browser to show a document (HTML, VRML)
  at a given URL
*/

show_document(URL):-show_document(URL,'_self').

show_document(URL,Frame):-
  make_cmd0(['<body onLoad="window.open(''',URL, "','", Frame, ''')">'],Cmd),
  sprint_cs(Cmd).

show_document(BaseURL,File,Frame):-
  namecat(BaseURL,'/',File,URL),
  show_document(URL,Frame).

