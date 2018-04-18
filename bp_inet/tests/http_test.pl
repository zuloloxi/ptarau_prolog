/*
 BinNet Internet Programming Toolkit
 Copyright (C) BinNet Corp. 1999

 Tests/examples of use 
*/

ispider(URL):-
  internal_spider(2,URL,Link),
  println(Link),fail;println(end).

:-['../spider/http_spider_script'].
:-['../library/http_client'].

b1:-
  http2char('http://localhost:8080/images/index.html',C),
  write(C),
  fail.

b2:-
  http2char('http://localhost:8080/images/agent.jpg',C),
  write(C),
  fail.

go1:-http2line('http://www.cs.unt.edu/~tarau',Line),
    name(L,Line),
    println(L),
    fail.

go:-http2char('http://www.cs.unt.edu/~tarau',C),
    put(C),
    fail.

/*    
t0:-spider(3,
  'http://www.google.com/search?q=Prolog',
  L),
  println(L),fail;println(end).
*/

t0:-spider(2,
  'http://www.google.com/search?hl=en&ie=UTF-8&oe=UTF-8&q=Prolog&btnG=Google+Search',
  L),
  println(L),fail;println(end).

t1:-spider(3,
  'http://www.cs.unt.edu/~tarau',
  L),
  println(L),fail;println(end).

t2:-
  internal_spider(2,'http://www.sics.se',L),
  println(L),fail;println(end).

t3:-
  internal_spider(4,
    'http://www.binnetcorp.com',
  L),
  println(L),fail;println(end).

t4:-
  internal_spider(3,'http://www.visual-prolog.com',L),
  println(L),fail;println(end).

t4a:-
  internal_spider(4,'http://www.trinc-prolog.com',L),
  println(L),fail;println(end).

t4b:-
  internal_spider(4,'http://www.dobrev.com',L),
  println(L),fail;println(end).


t5:-spider(2,
  'http://www.altavista.com/cgi-bin/query?pg=q&kl=XX&q=binprolog',
  L),
  println(L),fail;println(end).

t6:-spider(2,
  'http://ad.doubleclick.net',
  L),
  println(L),fail;println(end).

t7:-spider(2,'http://matchmaker.com/',L),println(L),fail;println(end).

t8:-spider(2,'http://www.lycos.com',L),println(L),fail;println(end).

t8a:-spider(3,'http://www.lycos.com/fashion/',L),println(L),fail;println(end).

t9:-spider(2,'http://www.amazon.com',L),println(L),fail;println(end). % NOT GETTING IN

t10:-spider(2,'http://www.yahoo.com',L),println(L),fail;println(end). % NOT GETTING IN

t11:-spider(2,'http://www.infoseek.com',L),println(L),fail;println(end). % NOT GETTING IN

t12:-spider(2,'http://www.aol.com',L),println(L),fail;println(end). 

t13:-spider(2,'http://www.microsoft.com',L),println(L),fail;println(end). 

t14:-spider(2,'http://www.netscape.com',L),println(L),fail;println(end).

t15:-spider('http://www.ibm.com').

t16:-spider('http://www.suretrade.com').

t17:-
   http2line('http://localhost:80/bp_inet/cgi/hello.pro',Cs),
   write_chars(Cs),nl,
   fail
;  println(end).

t18:-
   http2line('http://localhost:8080/bp_inet/cgi/hello.html',Cs),
   write_chars(Cs),nl,
   fail
;  println(end).

t19:-
   http2line('http://localhost:8080/bp_inet/cgitest.txt',Cs),
   write_chars(Cs),nl,
   fail
;  println(end).

t20:-
   http2line('http://www.alta-vista.net/cgi-bin/query?pg=q&kl=XX&q=binprolog',Cs),
   write_chars(Cs),nl,
   fail
;  println(end).

t21:-
   http2line('http://localhost/BinNet/index.html',Cs),
   write_chars(Cs),nl,
   fail
;  println(end).

t22:-
   http2line('http://www.onlineinc.com:80/oluser/',Cs),
   write_chars(Cs),nl,
   fail
;  println(end).

t23:-
   http2link('http://www.suretrade.com',L), % BAD
   write('>'),write(L),nl,
   fail
;  println(end).


t24:-
   http2link('http://www.yahoo.com',L),
   write(L),nl,
   fail
;  println(end).



t25:-
  http2line('http://www.sandbox.net/finalbell/pub-doc/home.html',L),
  write_chars(L),nl,
  fail
;  println(end).

t26:- % password protected, should fail
 http2line('http://www.sandbox.net/finalbell/prot-bin/frame?fb_portfolio+111+portfolio',L),
   write_chars(L),nl,
  fail
;  println(end).

t27:-parse_url('http://cnnfn.com:80/digitaljam/techstocks/internet.html',URL),
  println(URL).

t28:-parse_url('http://cnnfn.com/digitaljam/techstocks',URL),
  println(URL).

t28:-parse_url('http://cnnfn.com/digitaljam/',URL),
  println(URL).

t29:-parse_url('http://www.cs.unt.edu/~tarau/art/art.html',URL),
  println(URL),
  unparse_url(URL,L),
  println(L),
  parse_url(L,URL1),
  println(URL1).

t30:-parse_url(
  'http://www.altavista.com/cgi-bin/query?pg=q&text=yes&kl=XX&q=%2BBinNet+%2BBinProlog&act=search',URL),
  println(URL),
  unparse_url(URL,L),
  println(L),
  parse_url(L,URL1),
  println(URL1).



t31:-parse_url('file:///C|/bp_dist/bugs/web.pl',URL),
  println(URL).


t32:-
   spider('file:///C|/paul/tarau.html'),
   show_links.

t33:-
   spider(3,'file:///C|/paul/tarau.html',L),
   println(L),
   fail
; println(end).

t34:-
   spider(2,'file:///C|/paul/teaching/resources.html',L),
   println(L),
   fail
; println(end).

t35:-
   spider('http://localhost/tarau.html'),
   show_links.

t36:-
   spider('http://libra/BinNet/utest.txt'),
   show_links.

t37:-
   spider('http://localhost/BinNet/index.html'),
   show_links.
         
t38:-
   spider('http://cnnfn.com:80/digitaljam/techstocks/internet.html'),
   show_links.

t39:-
   spider('http://www.cs.unt.edu/~tarau'),
   show_links.
   
t40:-
   spider('http://www.w3.org/Protocols/rfc1945/rfc1945'),
   show_links.


t41:-
  spider('http://localhost/tarau.html',L),
  println(L),fail;println(end).

t42:-spider(2,'http://www.infind.com/',L),println(L),fail;println(end).

t43:-spider(2,'http://www.cs.unt.edu/~tarau',L),println(L),fail;println(end).

t44:-
  spider('http://cnnfn.com:80/digitaljam/techstocks/internet.html',L),
  println(L),fail
; println(end).

% General idea behind spider algorithm - specification
/*
g(a,[b,c]).
g(b,[a,c]).
g(c,[d,e]).
g(d,[f]).
g(e,[f]).
*/

g(1,[2,3]).
g(2,[1,4]).
g(3,[1,5]).
g(4,[1,5]).

tg(X,Z,[X|Xs]):-
  g(X,Ys),
  mark(X),
  ( X=Z,Xs=[]
  ; Xs=Zs,
    member(Y,Ys),
    tg(Y,Z,Zs)
  ).

mark(X):-bb_def(marked,X,yes). % persistent marking

t46:-
  println('lycos metasearch'),
  spider(2,'http://lycospro.lycos.com/cgi-bin/pursuit?mtemp=nojava&etemp=error_nojava&rt=1&qs=gt%7Cdate&npl=matchmode%3Dand%26adv%3D1&query=BinProlog&maxhits=500&cat=lycos&npl1=ignore%3Dfq&fq=&lang=&rtwm=45000&rtpy=2500&rttf=5000&rtfd=2500&rtpn=2500&rtor=2500&goto=http%3A%2F%2Fbestbuysonthenet.com',L),
  println(L),fail;println(end).

