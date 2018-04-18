% NL interface to LogiMOO
% Authors: Veronica Dahl, Paul Tarau
% Last change: Mon Oct  6 04:17:20 ADT 1997 Paul
% we are moving towards a server side NL processor
% talking through an applet with users

:-op(400,xfx,(@)).
:-op(400,fx,(?)).
:-op(400,fx,(++)).


% Dictionary expresed as OtherLanguage@English in file
% english.pl --> trivial def: X@X

@EnglishW:- #OtherW,OtherW@EnglishW.

look_ahead(W):- \+ \+ (@ _,#W).
look_ahead(W1,W2):- \+ \+ (@ _, #W1, #W2). 

% optional `glue' words: skip if present, do not mind if not

{W} :- nonvar(W),!,(@W->true;true).
{W} :- logimoo_err(should_be_nonvar(W)).

?X :- is_assumed(future(X)).

% this is just heuristics: occasionally we get it wrong
% anaphora requires more: for instance, feature matching

++X:- assumeal(X),assumel(X). % at most 2 uses for an anphora
                              % we assume both in asserta and assertz order

is_avatar(X):-is_a_fact(user(X,_,_)); ?avatar(X).
is_crafted(A,C):-is_a_fact(crafted(A,C)); ?crafted(A,C).
is_place(P):-is_a_fact(place(P)); ?place(P).
is_port(P):- is_a_fact(port(_,P,_)); ?port(P).
is_in(C,X):- is_a_fact(contains(C,X)); ?contains(C,X).
does_have(Who,What):-is_a_fact(has(Who,What)); ?has(Who,What).

% EVALUATES A LIST OF CHARS

eval_nat(Chars):-
  translate_nat(Chars).

translate_nat([S,A,Y|Cs]):-
     member([S,A,Y],["say","Say"]),!,
     that_mes(Cs).
translate_nat(Chars):-
     % ignore case
     !,toLowerChars(Chars,Cs),
     % split in words 
     chars_words(Cs,Ws),patch_words(Ws,Words),
     % generate and execute commands
     translate(Words).

% split in senteces, then parse each
translate(Words) :- 
     !,traceln('WORDS:'(Words)),
     split_nat(Words,Sentences), 
     !,traceln('SENTENCES:'(Sentences)),
     !,traceln('==BEGIN COMMAND RESULTS=='),
     ( text(Sentences)->true
     ; true
     ),
     !,traceln('==END COMMAND RESULTS==').

% parse each sentence
text([]).
text([S|Ss]):-
   parse_sent(S,C),
   !,
   evaluate(C),
   !,
   text(Ss).

evaluate(T):-metacall(T),!,writeln(['=> The',query,succeeded,'!']),traceln('SUCCEEDING'(T)).
evaluate(T):-writeln(logimoo_err(unexpected_evaluation_failure_in(T))).

% parse a sentence
parse_sent(S,Cs):-
   dcg_def(S),  % open dcg stream
   sent(Cs),    % Cs contains a list of commands
   dcg_val([]), % close dec stream
   !.
parse_sent(S,_):-  % send errors to `wizard' over the net
   logimoo_err(unable_understand_sentence(S)).

sent(R) :-                       % look for a verb phrase
     vp(R).

% recognizes an avatar, using world knowledge
avatar(X) :- art, @X, is_avatar(X), !, ++future(avatar(X)).
avatar(X) :- anaphora(avatar,X).

% recognizes objects using world knowledge
crafted(What):- @the,@What, 
   is_crafted(Who,What),
   relative(What),!,
   ++future(crafted(Who,What)).
crafted(What):- 
   anaphora(crafted,What).


% uses relative sentences as filters
relative(What) :- @that,!,avatar(Who),@Verb,do_relative(Verb,Who,What).
relative(What) :- nonvar(What).

% handles relatives, based on world knowledge
do_relative(crafted,Who,What):- is_crafted(Who,What).
do_relative(has,Who,What):- does_have(Who,What).
do_relative(have,Who,What):- does_have(Who,What).
% to add: others, based on: is_avatar,is_place,is_in

% generates a command to craft an object
def_crafted(X):-do_craft(X), whoami(I), ++future(crafted(I,X)).

% recognizes a place using domain knowledge
place(X) :- @X, is_place(X).

% generates a command to build a new place
def_place(X) :- @X, ++future(place(X)).

% recognizes a port
direction(X) :- @X, is_port(X),++future(direction(X)).

% handles him,her,it
anaphora(avatar,X):- @P, get_avatar(P,X).
anaphora(crafted,X):- @it, -future(crafted(_,X)).

get_avatar(i,X):-!, whoami(X).
get_avatar(P,X):-member(P,[him,her]),!, -future(avatar(X)).


% VERBS 

vp(go(Where)) :- @go,!,do_go(Where).
vp(come(Who)) :- @come,!,avatar(Who).
vp(craft(What)) :- @craft,!,art,def_crafted(What).
vp(dig(Place)) :- @dig,!,art,def_place(Place).
vp(open_port(Port,Place)) :- @open,!,
  art,@port,@Port,{to},art,def_place(Place).
vp(close_port(Port)) :- @close,!,{the},@port,{to},art,@Port.
vp(take(What)) :- @take,!,art,crafted(What).
vp(drop(What)) :- @drop,!,art,crafted(What).
vp(show(What)) :- @show,!,art,crafted(What).
vp(give(Whom,What)) :- @give,!,obp(Whom,What).
vp(iam(Who)) :- @i,@am,!,art,@Who,++future(avatar(Who)).
vp(Cmd) :- @who,!,do_who(Cmd).
vp(what(Verb,Object)) :- @what,!,do_what(Verb,Object).
vp(Cmd) :- @where,!,do_where(Cmd).
vp(please(Who,What)) :- @please,!,avatar(Who),vp(What).
vp(X) :- @X,nonvar(X),
  member(X,
     [ look,list,list0,users,online,whoami,whereami,
       test,ttest,listing,save,help,lobby,vanish,messages,
       sstop,
       sstart
     ]).

art:- @a;@an;@the;true.

obp(Whom,What):- @to,avatar(Whom),crafted(What).
obp(Whom,What) :- crafted(What),@to,avatar(Whom).

do_where(whereami):- @am,@i;@i,@am.
do_where(where(X)):- @(is),art,(avatar(X);crafted(X)).

do_craft(X) :- @Pref, {-}, @Suf,!, % Suf is gif, jpg etc.
  namecat(Pref,'.',Suf,X).
do_craft(X) :- @X.

do_go(Where):- {to},{the},(place(Where);direction(Where)).
do_go(Where):- @there, -future(place(Where)).

do_who(whoami):- @am,@i,!.
do_who(whoami):- @i,@am,!.
do_who(who(Verb,Object)):- @Verb,crafted(Object).

do_what(Verb,X):- @Verb,avatar(X).

% LOW LEVEL TOOLS

% can be used as message sender
logimoo_err(Mes):- writeln(['LogiMOO error: ',Mes]),fail.

patch_words(Ws,Words):-append(_,[Last],Ws),is_dot(Last),!,Words=Ws.
patch_words(Ws,Words):-is_dot(X),!,append(Ws,[X],Words).

is_dot(X):-member(X,['.', ',' ,'?', '!']),!.

dot :- #X,is_dot(X).

nl_word(_):-dot,!,fail.
nl_word(X) :- #X.
 
split_nat(Ws,Ss):-
  dcg_def(Ws),
    plus(a_sent,Ss),
  dcg_val([]),!.

a_sent(S):-plus(nl_word,S),dot.


toLowerChar(X,Y) :-
   [A]="A", [LA]="a",
   [Z]="Z", 
    X >= A,
    X =< Z,
    !,
    Y is LA+X-A.
toLowerChar(X,X).

toLowerChars(Cs,Ls):-
  map(toLowerChar,Cs,Ls).
        

toLower(X,LX):-term_chars(X,Cs),toLowerChars(Cs,Ls),term_chars(Ls,LX).


/*
getString(S) :- #W,getMore(W,Ws),make_cmd(Ws,S).

getMore(W0,[W0,' '|Ws]):- #W,!,getMore(W,Ws).
getMore(W0,[W0]).

sent(whisper(To,Mesg)) :-  @whisper,!,
     {to},avatar(To),
     getString(Mesg).
sent(that_mes(Words))      :- @say,!, % special cases for chat
     getString(Words).
sent(that_mes(Words)):- @yell,!,
     getString(Words).
*/


% TEST SUITE: 
% please check they pass after each change
% please add new ones @Paul

test:-
   test_data(Cs),name(C,Cs),
   writeln(['TEST: ',C]),wnl,
   eval_nat(Cs),wnl,
   fail
;  wnl.

ttest:-
  tell('test.txt'),
   test,
  told.
