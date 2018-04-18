/*
 BinNet Internet Programming Toolkit
 Copyright (C) BinNet Corp. 1999

 Scripts for BinNet Internet Search Engine
*/

% also use WWW client programs

:-['../spider/http_spider'].

/********************
% Web spider scripts
********************/


/* 
% Internal Spider: moves only inside the domain of TopURL
*/
internal_spider(Depth,TopURL,HarvestedLink):-
  spider1(Depth,TopURL,HarvestedLink,internal_only).

% spider plugin component
internal_only(url(HTTP,H,P,_,_),url(HTTP,H,P,_,_)).

/*
Extracts (potential) bad links from a site
*/

internal_bad_link(Depth,TopURL,HarvestedLink,Kind):-
  internal_spider(Depth,TopURL,HarvestedLink),
  is_good_link(HarvestedLink,Kind),
  write_chars("."),
  \+ Kind=yes(_).

/*
  examples of use
*/
htest1:-
  println('this may take some time'),
  internal_bad_link(3,'http://www.binnetcorp.com',Link,Kind),
  println(Kind+Link),fail;println(end).

htest2:-
  println('this may take some time'),
  internal_bad_link(2,'http://www.cs.unt.edu',Link,Kind),
  println(Kind+Link),fail;println(end).

htest3:-
  println('this may take some time'),
  internal_bad_link(2,'http://www.binnetcorp.com',Link,Kind),
  println(Kind+Link),fail;println(end).

htest4:-
  println('this may take some time'),
  harvest_email(3,'http://www.cs.unt.edu',Email),
  println(Email),fail;println(end).
  
htest5:-
  println('this may take some time'),
  harvest_email(3,'http://www.cs.unt.edu',Email,internal_only),
  println(Email),fail;println(end).

htest6:-
  println('this may take some time'),
  harvest_email(2,'http://www.cs.unt.edu/studentweb/index.html',Email),
  println(Email),fail;println(end).

% E-mail address collecting script
harvest_email(Depth,InitialURL,EMailAddress):-
  spider(Depth,InitialURL,Link),
  name(Link,Ls),
  append("mailto:",Ms,Ls),
  name(EMailAddress,Ms).

/*
 Matching words search spiders matching script
*/

and_word_spider(Depth,InitialURL,Words,Link,LineOfWords):-
  spider(Depth,InitialURL,Link),
  http2words(Link,LineOfWords),
  forall(
    member(W,Words),
    member(W,LineOfWords)
  ).

or_word_spider(Depth,InitialURL,Words,Link,LineOfWords):-
  spider(Depth,InitialURL,Link),
  http2words(Link,LineOfWords),
  once((
    member(W,Words),
    member(W,LineOfWords)
  )).

/*
  examples of use
*/
wtest1:-
  and_word_spider(1,'http://localhost/bp_inet/cgi/http_query.html',[likes,'Mary'],Link,LineOfWords),
  println(Link),
  println(LineOfWords),
  fail
; println(end).

wtest2:-
  or_word_spider(1,'http://localhost/bp_inet/cgi/http_query.html',[likes,'Mary'],Link,LineOfWords),
  println(Link),
  println(LineOfWords),
  fail
; println(end).

/*
controlling the spider:

 - movement/direction filtering: 
     for example internal_only, deep_random

 - post url generation url attribute filtering
   - by url-type
   - e-mail harvesting
   - keywords in url

 - keyword
*/


/*
% todo: path reduction: '/_/..'=> ''
%                        'X/./=>X
*/
