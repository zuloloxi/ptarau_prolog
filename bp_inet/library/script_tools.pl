sandbox.

header(H):-
  make_cmd0(
   [
     "<html><title>BinProlog Script Output</title>",
     [10],
     "<body bgcolor=ffffff>",
     [10],
     "<pre>",
     [10]
   ],
   H
  ).

footer(F):-
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
  \+(errmes(bad_input,Input)).

eq1(A=_,A).
eq2(_=B,B).

name1(Cs,N):-name(N,Cs).

% gets integer in range, arith. mean if Min,Max if out
get_in_range(Mes,Cs,Min,Max,Val):-
  term_codes(N,Cs),
  ( integer(N),N>=Min,N=<Max->Val is N
  ; Val is (Min+Max)//2,
    write(Mes),write(': value from '),write(Min),write(' to '),
    write(Max),write(' expected '),
    write(Val),nl
  ).

parse_input([],[]).
parse_input([X|Xs],YYs):-
  ( [X]="%",Xs=[A,B|NewXs],compute_code(A,B,Y)-> 
    (Y=:=13->YYs=Ys;YYs=[Y|Ys])
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

split_post(Cs,Ws):-
  post(Ws,Cs,End),
  !,
  End=[].
   
post([W|Ws])-->assoc(W),star(dassoc,Ws).

assoc(Key=NewYs) --> 
  plus(nodelim,Xs),delim("="),star(nodelim,Ys),
  { 
    parse_input(Xs,NewXs),
    parse_input(Ys,NewYs),
    name(Key,NewXs)
  }.

dassoc(Xs) --> delim("&"),assoc(Xs).

delim([X]) --> @X.

nodelim(X) --> @X, {\+(member(X,"&="))}.

% NL tokenizer - converts NL strings of chars to lists of words

chars_words(Cs,Ws):-to_words(Cs,Ws).

% environment variables handling tools

/*
get_content_length(L):-
  ( unix_getenv('CONTENT_LENGTH',CLS)->name(CLS,CL),name(L,CL)
  ; val(content_length,L0)->println(got_content_length(L0)),L=L0
  ; errmes('cgi error: maybe_not_in script mode','undefined: CONTENT_LENGTH')
  ).
*/

show_file(F):-file2chars(F,Xs),
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

% tcall(_T,Goal):-Goal->true;true.

tcall(T,Goal):-timed_call(_,Goal,T,R),
  ( R=the(_)->true
  ; println(cgi_execution_error(timeout(T),goal(Goal),result(R)))
  ).

/*
  Generates Java script which, if used in a CGI script
  instructs the browser to show a document (HTML, VRML)
  at a given URL
*/

make_document(BaseURL,File,Frame,Cmd):-
  namecat(BaseURL,'/',File,URL),
  make_cmd0(['<body onLoad="window.open(''',URL, "','", Frame, ''')">'],Cmd).
