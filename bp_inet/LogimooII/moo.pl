% PROGRAM:	LogiMOO kernel + Netscape interface
% AUTHOR:	Paul Tarau, tarau@info.umoncton.ca
% TIMESTAP:	Mon Oct  6 04:16:50 ADT 1997


/*************** configure here **********************************/

logimoo_version(800). % matches BinProlog x.xx, warns if wrong version

/*************** end configure **********************************/

:-[gram].

/***************** LogiMOO kernel *******************************/


logimoo_client:-
  check_version(V),
  writeln(V),
  spawn_listener,
  login,
  interact.

check_version(V):-
   vread(version,BP),logimoo_version(LM),
   (BP=:=LM->true
   ;  \+ errmes('detected version mismatch, use at your own risk',
                 versions(binprolog=BP,logimoo=LM)
               )
   ),
   LM1 is LM/100, BP1 is BP/100,
   V=['LogiMOO',LM1, ' running under BinProlog ',BP1].


% client/server user interface

background_logimoo_server:-
  fork_server(Pid),        % creation of the blackboard server
  Pid>0,
  show_logimoo(Pid),
  default_port(Port),
  this_out(my_child(Port,Pid)).

show_logimoo(Pid):-
  check_version(V),
  writeln(V),
  writeln([logimoo_server,process_id,Pid]).

logimoo_server:-default_port(Port),logimoo_server(Port).

logimoo_server(Port):- % runs locally
  unix_pid(Pid),
  show_logimoo(Pid),
  % comment out next line if you want other users to connect
  detect_ip_addr(H),this_host(H)=>>
  password(none)=>>run_server(Port).

bye:- % vanish,
 logout->true
; halt(1).


% high level MOO primitives: basic `verbs'

add_user(Name,Passwd,_):-
  that_rd(user(Name,OldPasswd,_)),!,
  ( Passwd==OldPasswd->enter_avatar(Name)
  ; writeln(['Sorry, avatar in use with other password']),fail 
  ).
add_user(Name,Passwd,Home):-  
  that_out(user(Name,Passwd,Home)),
  enter_avatar(Name).

enter_avatar(Name):-
  set_login(Name), % on local blackbord
  that_cout(online(Name)).

default_home(Home):-
   default(home(Home),(
         default_host(H),
         detect_user(U),
         make_cmd(["http://",H,"/~",U],Home)
      )
   ).


login:-
  default_login(Name),
  default_password(Pwd),
  default_home(Home),
  writeln([login,'as:',Name,with,'password:',Pwd]),
  writeln([your,home,is,at,Home]),wnl,
  add_user(Name,Pwd,Home),
  sit.

% materialize in a place
sit:-Place=lobby,dig(Place),sit(Place).

sit(Place):-
  whoami(Me),
  ( that_rd(contains(_,Me))->true
  ; that_out(contains(Place,Me))
  ).

vanish:-
  whoami(Me),
  that_cin(contains(_,Me)),
  for_all(has(Me,O),gives(Me,wizard,O)).

relogin:-
  default_login(Name),
  ( that_cin(user(Name,_,_)),fail
  ; that_cin(online(Name)),fail
  ; that_cin(contains(_,Name))
  ),
  fail.
relogin:-
  login.

logout:-
  that_mes('Bye'),
  whoami(Name),
  (that_cin(online(Name))->halt(0);halt(3)).


whisper(Name,Mes):-namecat(Name,':',Mes,R),that_mes(R).

users:-for_all(user(Name,_,Home),show_user(Name,Home)),wnl.

online:-for_all(online(Name),writeln([Name])).

whoami:-whoami(I),writeln(['You are:',I]).

whoami(X):-default_login(X).

iam(X):-set_login(X),login.


list:-that_target(single),!,listing.
list:-for_all(X, (X \=user(_,_,_), writeln([X]))).

list0:-for_all(X, writeln([X])).



% MOO primitives: specialized verbs

% creates a place
dig(Place):-that_cout(place(Place)).

% creates/closes a port
open_port(Dir,P2):-whereami(P1),open_port(P1,Dir,P2).
close_port(Dir):-whereami(P1),close_port(P1,Dir).

open_port(P1,Dir,P2):-that_rd(place(P1)),that_rd(place(P2)),that_cout(port(P1,Dir,P2)).

close_port(P1,Dir):-that_rd(place(P1)),that_cin(port(P1,Dir,_)).

% telporting
move(O,P1,P2):-that_cin(contains(P1,O)),that_out(contains(P2,O)).

whereami(Where):-whoami(Me),where(Me,Where).

whereami:-whereami(Place), writeln(['you are in the ',Place]).

where0(X,Where):-that_rd(contains(Where,X)).

where(X,Where):-where0(X,Place),!,Where=Place.
where(X,Where):-is_a_fact(user(X,_,_)),!,relogin,where0(X,Where).
where(_,nowhere).

where(X):-where(X,Where),writeln([X,is,in,Where]).

what(Verb,Who,What):-T=..[Verb,Who,What],that_rd_all(T).

who(Verb,What,Who):-what(Verb,Who,What).

what(Verb,Who):-forall(what(Verb,Who,What),writeln([Who,Verb,What])).
who(Verb,What):-forall(who(Verb,What,Who),writeln([Who,Verb,What])).

come(Who):-whereami(Here),please(Who,go(Here)).

lobby:-go(lobby).

% some well known sites

cnn:-auto_show('http://www.cnn.com','').
lycos:-auto_show('http://www.lycos.com','').
yahoo:-auto_show('http://www.yahoo.com','').
amazon:-auto_show('http://www.amazon.com','').

look:-that_target(multi_cgi),
  whereami(Place),
  wnl,writeln(['Ports ',from,Place,':']),
     for_all(port(Place,Direction,To),
             show_port(Direction,To)
     ),
  wnl,writeln(['Users at this place, ',Place,':']),
     for_all(online(X), 
       (that_rd(contains(Place,X)),that_rd(user(X,_,H)),show_user(X,H)
       )
     ),
/*
  wnl,writeln(['Past users at this place, ',Place,':']),
     for_all(user(X,_,H), 
       ( that_rd(contains(Place,X)) , 
         \+ that_rd(online(X)), show_user(X,H)
       )
     ),
*/
  wnl,writeln(['Objects at this place, ',Place]),
     for_all(contains(Place,X),
       ( % \+ that_rd(user(X,_,_)),
         show_object(X)
       )
     ).
look:-that_all(_,Xs),forall(member(A,Xs),writeln([A])).


show(Ob):-
  that_rd(crafted(Who,Ob)),
  that_rd(user(Who,_,URL)),
  auto_show(URL,Ob).

show_port(Dir,To):-writeln([Dir,to,To]).

show_user(Name,Home):-
  make_cmd(['<a href="',Home,'">',Name,'</a>'],Cmd),
  writeln([Cmd]).

show_object(Name):-compound(Name),!,writeln([Name]).
show_object(Name):-
  that_rd(crafted(Owner,Name)),
  that_rd(user(Owner,_,Home)),
  make_cmd(['<a href="',Home,'/',Name,'">',Name,'</a>'],Cmd),
  writeln([Cmd]).

auto_show(URL,File):-show_document(URL,File,'_self'). % see ssi_lib.pl

% creating things
craft(O):-whoami(Me),
  that_rd(contains(Place,Me)),
  that_cout(contains(Place,O)),
  that_cout(has(Me,O)),
  that_cout(crafted(Me,O)).

% good for craft(dog,gif) or craft(cat,wrl) etc.
craft(Pref,Suf):-namecat(Pref,'.',Suf,O),craft(O).

go(DirOrPlace):-
  whoami(Me),
  whereami(Place), 
  (
    that_rd(place(DirOrPlace))->NewPlace=DirOrPlace
  ; that_rd(port(Place,DirOrPlace,NewPlace))
  ),
  move(Me,Place,NewPlace),
  for_all(has(Me,O),move(O,Place,NewPlace))->whereami
; writeln([unable,to,go,to,DirOrPlace]).

fly(Host):-set_host(Host).

fly(Host,Port):-fly(Host),set_port(Port).

gives(From,To,O):-
  that_cin(has(From,O)),
  that_cout(has(To,O)).

give(Who,What):-
   whoami(Me),
   gives(Me,Who,What),
   namecat('I give you',' ',What,Mes),
   whisper(Who,Mes).

for_all(X,G):-that_all(X,Xs),member(X,Xs),G,fail.
for_all(_,_).

take(O):-whereami(Place),that_cin(contains(Place,O)).

drag(O):-
  take(O),
  whoami(I),
  that_out(contains(I,O)).

drop(O):-
  whoami(I),
  whereami(Place),
  that_cin(contains(I,O)),
  that_out(contains(Place,O)).
  

% NL tokenizer - converts NL strings of chars to lists of words

% moved to ../server/ssi_lib.pl

% chars_words(Cs,Ws):-chars_to_words(Cs,Ws).

/*
% chars_words(Cs,Ws):-dcg_def([32|Cs]),words(Ws),!,dcg_val([]).

words(Ws):-star(word,Ws),space.

word(W):-space,(plus(is_letter,Xs);one(is_punct,Xs)),!,name(W,Xs).

space:-star(is_space,_).

is_space(X):- #X, member(X,[32,7,9,10,13]).

is_letter(X):- #X, is_an(X).

is_punct(X):- #X, (is_spec(X);member(X,"!,;`""'()[]{}*")).


% regexp tools with  AGs + high order

one(F,[X]):- call(F,X).

star(F,[X|Xs]):- call(F,X),!,star(F,Xs).
star(_,[]).

plus(F,[X|Xs]):- call(F,X),star(F,Xs).
*/

% simple chat toplevel

interact:-
  quietmes(5,'^D on Unix or ^Z on PCs to end'),
  repeat,    
    ( write('>: '),read_chars(Cs),Cs\==[]->
      % that_mes(Cs),
      eval_nat(Cs),
      fail
    ; true
    ),
  !.

% starts/stops server

sstart:-db_clean,background_logimoo_server,sleep(3).

sstop:-stop_server.

spawn_listener:-call_ifdef(that_target(multi),fail),
   spawn(listen),
   writeln(['waiting 15 sec for listener to come up']),sleep(15),
   !.
spawn_listener:-call_ifdef(that_target(dual),fail),
   spawn(run_server),
   writeln(['waiting 10 sec for listener will to come up']),sleep(10),
   !.
spawn_listener:-
   default_login(I),
   writeln(['listener will echo locally for user: ',I]).

% REMOTE FACT CACHING ALGORITHM
%
% if assumed then true
% if older that Max secs get it from the network
% if fresh, use chached compy
%
% should be used with a ! after, to avoid useless nondeterminism
% note that caching times should be kept low
% their main mission is to avoid network trafic during the parsing process
% freshness should be a close approximation of parsing step
% during batch testing, it is mandadatory to have it at 0!

%max_freshness(Mode,Value).

max_freshness(single,0).
max_freshness(multi_cgi,0).
max_freshness(dual,1).
max_freshness(multi,2).

is_a_fact(R):-
  that_target(Mode),
  max_freshness(Mode,Max),
  is_a_fact(Max,R). % memoing, but not for more than Max secs

is_a_fact(Freshness,R):-
  Cached='$cached',
  functor(R,F,N),functor(P,F,N),
  rtime(T),
  ( 
    bb_val(Cached,P,OldT-Ps),OldT+Freshness>T->true
  ; that_all(P,Ps),bb_let(Cached,P,T-Ps)
  ),
  member(R,Ps).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% primitive Linda operations

% local


this_out(X):-db_assert(here,X).
this_cin(X):-db_retract1(here,X),!.
this_rd(X):-db_asserted(here,X),!.
this_all(X,Xs):-findall(X,db_asserted(here,X),Xs).

this_cout(X):-this_rd(X),!.
this_cout(X):-this_out(X).

% derived remote operation

that_all(XT,Xs):-nonvar(XT),XT=X^T,!,that_all(X,T,Xs).
that_all(X,Xs):- that_all(X,X,Xs).

that_rd_all(X):-that_all(X,Xs),member(X,Xs).

% tools

is_ascii_code(X):-integer(X),X>=0,X<256.

is_ascii_list(Cs):-forall(member(X,Cs),is_ascii_code(X)).

fix_mes([C|Cs],Mes):-is_ascii_code(C),is_ascii_list(Cs),!,
   Mes=[C|Cs].
fix_mes(X,Mes):-
   term_chars(X,Xs),
   Mes=Xs.

show_mes(Mes):-
   default_login(I),name(I,Is),
   fix_mes(Mes,Cs),
   appendN([Is,":>",Cs],Xs),
   name(M,Xs),
   writeln(M).

% tools

