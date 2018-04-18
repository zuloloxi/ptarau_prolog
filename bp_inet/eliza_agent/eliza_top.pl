ego:-eliza.

/***************************************************************************
*/
% eliza
%    main routine of ELIZA

eliza_server(Port):-
  init_eliza,
  http_server(Port).

eliza :-
  init_eliza,
  run_eliza.

% init_eliza:-val(initialized,yes),!.
init_eliza:-
   % let(initialized,yes),
   abolish(rules,1),
   abolish(mem,1),
   consult(eliza_rules).
   
run_eliza:-
      codes_words("Hello. I am ELIZA. How can I help you?",Ws),
      println_words(Ws),nl,
      repeat,
         readln_words(Input),
         eliza_step(Input,Output),
         println_words(Output),
      quittime(Input),
      !.

eliza_chat_step(QCs,ACs):-
  codes_words(QCs,QWs),
  eliza_step(QWs,AWs),
  codes_words(ACs,AWs).
  
eliza_step(Input,Output):-
         process_input(Input,[],Input2),
         simplify(Input2,Input3),
         findkeywords(Input3,KeyWords),
         sortkeywords(KeyWords,KeyWords2),
         makecomment(KeyWords2,Input3,Comment),
         flatten(Comment,Output).
   
prompt:-write_words(['> ']),flush.

println_words(Ws):-write_words(Ws),nl.

readln_words(Ws):-prompt,read_atomics(Ws).

sprintln_words(Socket,Ws):-codes_words(Cs,Ws),sprint_cs(Socket,Cs).

/***************************************************************************
**/
% simplification rules

sr([do,not|X],[dont|Y],X,Y).
sr([can,not|X],[cant|Y],X,Y).
sr([cannot|X],[cant|Y],X,Y).
sr([will,not|X],[wont|Y],X,Y).
sr([dreamed|X],[dreamt|Y],X,Y).
sr([dreams|X],[dream|Y],X,Y).
sr([how|X],[what|Y],X,Y).
sr([when|X],[what|Y],X,Y).
sr([alike|X],[dit|Y],X,Y).
sr([same|X],[dit|Y],X,Y).
sr([certainly|X],[yes|Y],X,Y).
sr([maybe|X],[perhaps|Y],X,Y).
sr([deutsch|X],[xfremd|Y],X,Y).
sr([francais|X],[xfremd|Y],X,Y).
sr([espanol|X],[xfremd|Y],X,Y).
sr([machine|X],[computer|Y],X,Y).
sr([machines|X],[computer|Y],X,Y).
sr([computers|X],[computer|Y],X,Y).
sr([am|X],[are|Y],X,Y).
sr([your|X],[my|Y],X,Y).
sr([were|X],[was|Y],X,Y).
sr([me|X],[you|Y],X,Y).
sr([you,are|X],[im|Y],X,Y).      % im = i'm = i am
sr([i,am|X],[youre|Y],X,Y).      % youre = you're = you are =\= your
sr([myself|X],[yourself|Y],X,Y).
sr([yourself|X],[myself|Y],X,Y).
sr([mom|X],[mother|Y],X,Y).
sr([dad|X],[father|Y],X,Y).
sr([i|X],[you|Y],X,Y).
sr([you|X],[i|Y],X,Y).
sr([my|X],[your|Y],X,Y).
sr([everybody|X],[everyone|Y],X,Y).
sr([nobody|X],[everyone|Y],X,Y).


/***************************************************************************
**/
% read_atomics(-ListOfAtomics)
%  Reads a line of input, removes all punctuation characters, and converts
%  it into a list of atomic terms, e.g., [this,is,an,example].

read_atomics(Ws):-read_words(Ws).

% char_type(+Char,?Type)
%    Char is an ASCII code.
%    Type is whitespace, punctuation, numeric, alphabetic, or special.

char_type(46,period) :- !.
char_type(X,alphanumeric) :- X >= 65, X =< 90, !.
char_type(X,alphanumeric) :- X >= 97, X =< 123, !.
char_type(X,alphanumeric) :- X >= 48, X =< 57, !.
char_type(X,whitespace) :- X =< 32, !.
char_type(X,punctuation) :- X >= 33, X =< 47, !.
char_type(X,punctuation) :- X >= 58, X =< 64, !.
char_type(X,punctuation) :- X >= 91, X =< 96, !.
char_type(X,punctuation) :- X >= 123, X =< 126, !.
char_type(_,special).

/***************************************************************************
*/
% isalist(+List)
%    checks if List is actually a list

isalist([_|_]).


/***************************************************************************
*/
% flatten(+List,-FlatList)
%    flattens List with sublists into FlatList

flatten([],[]).
flatten([H|T],[H|T2]) :- \+(isalist(H)),
                         flatten(T,T2).
flatten([H|T],L) :- isalist(H),
                    flatten(H,A),
                    flatten(T,B),
                    append(A,B,L).


/***************************************************************************
*/
% last_member(-Last,+List)
%    returns the last element of List in Last

last_member(End,List) :- append(_,[End],List).


/***************************************************************************
*/
% findnth(+List,+Number,-Element)
%    returns the Nth member of List in Element

findnth([E|_],1,E).
findnth([_|T],N,T1) :- V is N - 1,
                       findnth(T,V,T1).


/***************************************************************************
*/
% replace(+Element1,+List1,+Element2,-List2)
%    replaces all instances of Element1 in List1 with Element2 and returns
%       the new list as List2
%    does not replace variables in List1 with Element1

replace(_,[],_,[]).
replace(X,[H|T],A,[A|T2]) :- nonvar(H), H = X, !, replace(X,T,A,T2).
replace(X,[H|T],A,[H|T2]) :- replace(X,T,A,T2).


/***************************************************************************
*/
% simplify(+List,-Result)
%   implements non-overlapping simplification
%   simplifies List into Result

simplify(List,Result) :- sr(List,Result,X,Y), !,
                   simplify(X,Y).
simplify([W|Words],[W|NewWords]) :- simplify(Words,NewWords).
simplify([],[]).


/***************************************************************************
*/
% match(+MatchRule,+InputList)
%    matches the MatchRule with the InputList. If they match, the variables
%    in the MatchRule are instantiated to one of three things:
%       an empty list
%       a single word
%       a list of words

match(A,C) :- match_aux1(A,C),!.
match(A,C) :- match_aux2(A,C).

match_aux1(A,C) :-
      member([(*)|T],A),
      nonvar(T),
      member(Tm,T),
      nonvar(Tm),
      replace([(*)|T],A,Tm,B),
      match_aux2(B,C),
      !, last_member(L,T), L = Tm.

match_aux2([],[]).
match_aux2([Item|Items],[Word|Words]) :-
      match_aux3(Item,Items,Word,Words),!.
match_aux2([Item1,Item2|Items],[Word|Words]) :-
      var(Item1),
      nonvar(Item2),
      Item2 == Word,!,
      match_aux2([Item1,Item2|Items],[[],Word|Words]).
match_aux2([Item1,Item2|Items],[Word|Words]) :-
      var(Item1),
      var(Item2),!,
      match_aux2([Item1,Item2|Items],[[],Word|Words]).
match_aux2([[]],[]).

match_aux3(Word,Items,Word,Words) :-
      match_aux2(Items,Words), !.
match_aux3([Word|Seg],Items,Word,Words0) :-
      append(Seg,Words1,Words0),
      match_aux2(Items,Words1).


/***************************************************************************
*/
% makecomment(+KeyWordList,+InputList,-Comment)
%    returns ELIZA's Comment to the InputList based on the KeyWordList
%    takes care of special keywords 'your', and 'memory', which require
%       additional processing before a comment can be generated

makecomment([[your,2]|T],InputList,Comment) :-
      assertz(mem(InputList)),
      asserted(rules([[your,2],Reassembly])),
      mc_aux([[your,2]|T],Reassembly,InputList,Comment),!.
makecomment([[memory,0]|T],_,Comment) :-
      retract(mem(I2)),
      retractall(mem(I2)),
      asserted(rules([[memory,0],Reassembly])),
      mc_aux([[memory,0]|T],Reassembly,I2,Comment),!.
makecomment([[memory,0]|T],InputList,Comment) :-
      \+(retract(mem(_))),!,
      makecomment(T,InputList,Comment).
makecomment([Keyword|T],InputList,Comment) :-
      asserted(rules([Keyword,Reassembly])),
      mc_aux([Keyword|T],Reassembly,InputList,Comment),!.
makecomment([_|T],InputList,Comment) :-
      makecomment(T,InputList,Comment),!.


mc_aux(KeyWordList,[[DRuleNum,MatchRule,N|T]|_],InputList,Comment) :-
      match(MatchRule,InputList),
      mc_aux2(KeyWordList,DRuleNum,N,T,InputList,Comment),!.
mc_aux(KeyWordList,[_|T],InputList,Comment) :-
      mc_aux(KeyWordList,T,InputList,Comment).
mc_aux(_,[],_,_) :- !,fail.

mc_aux2(KeyWordList,DRuleNum,N,T,InputList,Comment) :-
      length(T,TLen),
      N < TLen, !,
      NewN is N + 1,
      findnth(T,NewN,Mn),
      mc_aux3(KeyWordList,DRuleNum,N,NewN,Mn,InputList,Comment).
mc_aux2(KeyWordList,DRuleNum,N,T,InputList,Comment) :-
      member(Mn,T),
      mc_aux3(KeyWordList,DRuleNum,N,0,Mn,InputList,Comment).


mc_aux3([Keyword|T],DRuleNum,N,NewN,[equal,MnT],InputList,Comment) :-
      !,
      updaterule(Keyword,DRuleNum,N,NewN),
      makecomment([MnT|T],InputList,Comment).
mc_aux3([Keyword|T],DRuleNum,N,NewN,[newkey],InputList,Comment) :-
      !,
      updaterule(Keyword,DRuleNum,N,NewN),
      makecomment(T,InputList,Comment).
mc_aux3([Keyword|_],DRuleNum,N,NewN,Mn,_,Mn) :-
      updaterule(Keyword,DRuleNum,N,NewN).


/***************************************************************************
*/
% process_input(+Input_List,+[],?Output)
%     returns part of input after a comma, or
%             part of input before a period

process_input([],L,L).
process_input(['.'|_],L,L) :- findkeywords(L,K), length(K,Kl), Kl >= 3,!.
process_input(['.'|T],_,L) :- !, process_input(T,[],L).
process_input([','|_],L,L) :- findkeywords(L,K), length(K,Kl), Kl >= 3,!.
process_input([','|T],_,L) :- !, process_input(T,[],L).
process_input([H|T],S,L) :- append(S,[H],S2), process_input(T,S2,L).


/***************************************************************************
*/
% findkeywords(+InputList,?KeyWordList)
%    returns a list with the keywords in the input list
%    if no keywords are found returns a list with keywords 'memory and 'none'

findkeywords([],[[memory,0],[none,0]]).
findkeywords([H|T],[[H,I]|T1]) :- asserted(rules([[H,I]|_])), !, findkeywords(T,T1).
findkeywords([_|T],T1) :- findkeywords(T,T1).


/***************************************************************************
*/
% sortkeywords(+KeyWordList,?SortedList)
%    returns a list with the keywords sorted according to their importance
%    this routine implements a simple bubble sort, customized for this
%    application

sortkeywords(X,Y) :- sort_aux(X,A,1), !, sortkeywords(A,Y).
sortkeywords(X,Y) :- sort_aux(X,Y,_).

sort_aux([],[],0).
sort_aux([X],[X],0).
sort_aux([[A,X],[B,Y]|T],[[B,Y],[A,X]|T],1) :- X < Y.
sort_aux([X,Y|T],[X|T2],S) :- sort_aux([Y|T],T2,S).


/***************************************************************************
*/
% updaterule(+KeyList,+DRuleNum,+N,+NewN)
%    updates a rule by changing the number of the reassembly rule associated
%       with a decomposition rule. The main rule to modify is indicated by
%       KeyList. The decomposition rule within the main rule is indicated by
%       DRuleNum. N is the previous reassembly rule used. NewN is the new
%       one used. N is updated to NewN so that next time a different reassembly
%       (actually the next in sequence) in used.

updaterule(KeyList,DRuleNum,N,NewN) :-
      retract(rules([KeyList,Rt])),
      replace([DRuleNum,A,N|T],Rt,[DRuleNum,A,NewN|T],Rt2),
      assertz(rules([KeyList,Rt2])).

/***************************************************************************
*/
% quittime(+InputList)
%    checks if the atom 'quit' is in the InputList

quittime(X) :- member('quit',X).


