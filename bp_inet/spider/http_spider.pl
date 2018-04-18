/*
 BinNet Internet Programming Toolkit
 Copyright (C) BinNet Corp. 1999

 BinNet Internet Search Engine (spider)
*/


:-['../library/http_client'].


% main Web spider entry point

% To controll the spider: use spider_script.pl

/*
  Try:
  ?-spider('http://www.lycos.com').
*/

spider(Root):-spider1(Root,_).

spider1(Root,Closure):-
  spider(2,Root,Link,Path,Closure),
  nl,println(Link),
  forall(member(L,Path),(write('  ! '),println(L))),
  fail
; nl,
  count_links.

spider(Root,Link):-spider1(Root,Link,_Closure).

spider1(Root,Link,Closure):-spider1(3,Root,Link,Closure).


% enumerates through backtracking links up to depth K 
% starting from AtomicRoot
 
spider(K,AtomicRoot,Link):-spider1(K,AtomicRoot,Link,_Closure).
 
spider1(K,AtomicRoot,Link,Closure):-spider1(K,AtomicRoot,Link,_,Closure).

% walks through links up to depth K
% starting fro AtomicRoot of the form 'http://...'
% returns Link and Path (a list of canonic links) used to get there

spider(K,AtomicRoot,Link,Path):-
  spider1(K,AtomicRoot,Link,Path,_Closure).

spider1(K,AtomicRoot,Link,Path,Closure):-
  clean_up_links,
  parse_url(AtomicRoot,URL),
  unparse_url(URL,Root),
  spider0(0,K,yes,Root,Link,Path,Closure).

spider0(K1,Max,More,Root,Link,[Root|Path],Closure):-
  mark_link(Root,K1),
  ( Link=Root,Path=[]
  ; More=yes,K2 is K1+1,K2=<Max,
    http2url(Root,NextRoot,Continuable,Closure),
    spider0(K2,Max,Continuable,NextRoot,Link,Path,Closure)
  ).

mark_link(X,K):-bb_def(marked,X,K).

marked_link(Link):-marked_link(Link,_).
marked_link(Link,Mark):-bb_list(Xs),marked_link(Link,Mark,Xs).
marked_link(Link,Mark,Xs):-bb_element(marked/0+Link/0=Mark,Xs).

% removes memorized links
clean_up_links:-
  forall(marked_link(URL),bb_rm(marked,URL)).

% show links lef over after a walk
show_links:-
  marked_link(U,K),
  println([K]:U),
  fail
; nl.

% returns links left over as a sorted list
sort_links(Sorted):-
  findall(K-U,marked_link(U,K),Ls),
  sort(Ls,Sorted).

% prints out sorted links 
sort_links:-
  sort_links(Ls),
  member(K-U,Ls),
  println([K]:U),
  fail
; nl.

% counts links up to default depth
count_links:-count_links(10).

% counts links up to given depth
count_links(Depth):-
  bb_list(Xs),
  for(K,1,Depth),
  findall(L,marked_link(L,K,Xs),Ls),
  length(Ls,LK),
  LK>0,
  println(depth(K)-LK),
  fail
; nl.


% used in spider: tries to find NextURL to follow if Continuable=yes
http2url(AtomicURL,NextURL,Continuable,Closure):-
  % generates a line at a time from a text url
  http2line(AtomicURL,ParsedURL,Cs),
  %write('???'),write_chars(Cs),write('<<<'),nl,
  url_in(Cs,Us),
  %write('!!!'),write_chars(Us),write('<<<'),nl,
  next_url(ParsedURL,Us,NextURL,Continuable,Closure).


% checks if a URL is continuable, i.e. if it can be followed further
next_url(ParsedRootURL,Ls,NextRoot,Continuable,Closure):-
    name(L,Ls),
    ( parse_url(L,ParsedURL),
      unparse_url(ParsedURL,UnParsed)->
      NextRoot=UnParsed,
      Continuable=yes
    ; make_absolute(ParsedRootURL,L,Ls,NextRoot,Continuable)
    ),
    ( nonvar(Closure)->
      ( var(ParsedURL)->parse_url(NextRoot,ParsedURL)
      ; true
      ),
      call(Closure,ParsedRootURL,ParsedURL)
    ; true
    ).

/*
  extracts lines as list of words
  from a link representining a text file
*/
http2words(Link,Ws):-
  http2content_line(Link,Cs),
  nonvar(Cs),
  findall(W,line2good_word(Cs,W),Ws).

http2word(Link,Xs):-
  http2content_line(Link,Cs),
  nonvar(Cs),
  line2word_chars(Cs,Xs).

line2good_word(Cs,W):-
  line2word_chars(Cs,Xs),
  name(W,Xs),
  \+ nonword(W).

line2word_chars(Cs,Ws):-
  det_append(Cs," ",NewCs),
  extract_word(Ws,NewCs,_LeftOver).

extract_word(Ws)-->
  extract_word1(Ws0,_),
  ( {Ws=Ws0,Ws=[_|_]}
  ; extract_word(Ws)
  ).

extract_word1(Cs,C)-->
  @(C0), 
  ( {minmaj(C0),Cs=[C0|More]}->extract_word1(More,C)
  ; {Cs=[],C=C0}
  ).

minmaj(X):-is_min(X).
minmaj(X):-is_maj(X).
minmaj(C):-member(C,"-_").

nonword(html).
nonword(font).
nonword(href).
nonword(nbsp).
nonword(textarea).
nonword(align).
nonword(input).
nonword(br).
nonword(b).
nonword(i).
nonword(color).
nonword(value).
nonword((type)).

/*
  classifies link given as 'http://...'
*/

is_good_link(AtomicURL,YesNoMaybe):-
  parse_url(AtomicURL,Protocol,Server,Port,Path,File),
  ( Protocol='http://'->
    ( http2code(Server,Port,Path,File,Code)->
      YesNoMaybe=yes(Code)
    ; YesNoMaybe=no
    )
  ; Protocol='file://'->
    ( appendN(Path,"/",File),F,exists_file(F)->YesNoMaybe=yes
    ; YesNoMaybe=no
    )
  ; YesNoMaybe=maybe
  ),
  !.
is_good_link(_,no).

% interactes with server and tries out URL
http2code(Server,Port,Path,File,Code):-
  new_client(Server,Port,Socket),
  get_http_header(Socket,Path,File,Code,_),
  close_socket(Socket).

% ---- end ---