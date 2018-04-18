% Lab.3
% Ex.1
%
/*
Identificator: ex_liste_in_liste_descomp
Sa se scrie un predicat care primeste ca prim parametru o lista ce poate avea ca elemente inclusiv liste, si calculeaza in al doilea parametru lista cuprinzand toate elementele simple, extrase din toate listele (in ordinea in care apar), asa cum se poate vedea in exemple:
| ?- descomp_list([],L).
L = [] ?
yes
| ?- descomp_list([[1]],L).
L = [1] ?
yes
| ?- descomp_list([[1],[2]],L).
L = [1,2] ? 
yes
| ?- descomp_list([[1],[2,3,[4,5]]],L).
L = [1,2,3,4,5] ? 
yes
| ?- descomp_list([1,[[2,3,[4,[5,[]],6,7],8],9],[[[[]]]],[3],1,[],[[2,[3,[4,[5,[[[]]],0],0]]]],10],L),write('Lista descompusa: '),write(L).
Lista descompusa: [1,2,3,4,5,6,7,8,9,3,1,2,3,4,5,0,0,10]
L = [1,2,3,4,5,6,7,8,9,3|...] ?
*/
% mult([H|T],M):- mult(T,MT),(member(H,MT),!,M=MT;M=[H|MT]).
% mult([],[]).

% descomp_list([H|T],L):- descomp_list(T,MT),(member(H,MT),!,M=MT;M=[H|MT]).
/*
listing(is_list/1, list_functor/1).
*/
is_list(X) :-
    functor(X, F, _),
    list_functor(F).

list_functor('.').
list_functor('[]').
/**/
% count atoms in list
% %% elem([H|T],R):-atomic(H),elem(T,R1),R1 is R+1. %bug, must be: R is R1+1. 
% elem([H|T],R):-atomic(H),!,elem(T,R1),R is R1+1.
% elem([H|T],R):-elem(H,R1),elem(T,R2),R is R1+R2.
% elem([H|T], R) :- elem(T, R).
% elem([],0).
/* not work
descomp_list([H|T],L):- descomp_list(T,MT),(atomic(H),!,L=MT;L=[H|MT]).
descomp_list([H|T],L):- descomp_list(H,MT),descomp_list(T,NT).
descomp_list([H|T],L) :- descomp_list(T,L).
descomp_list([],[]).
*/
/*
%use_module(library(sets)). %not work
divideList([], []):-!.
divideList([Head|Tail], [H|HTail]):-
    list_to_set(Head,H),%H is a List 
    divideList(Tail, HTail).
	*/
/*
divideList([[a,b,c],[1,2],[d]],L)
*/
% descomp_list
descomp_list([[H|T]|U],L):- descomp_list([H|[T|U]],L).
descomp_list([[]|T],L) :- descomp_list(T,L).
descomp_list([H|T],[H|U]):- \+(H=[]),\+(H=[_|_]),descomp_list(T,U).
descomp_list([],[]).
% sau flatten2, identic ca rezultat ca descomp_list.
flatten2([], []) :- !.
flatten2([L|Ls], FlatL) :-
    !,
    flatten2(L, NewL),
    flatten2(Ls, NewLs),
    append(NewL, NewLs, FlatL).
flatten2(L, [L]).

/*
interogare

| ?- descomp_list([],L).
L = [] ? 
yes
| ?- flatten2([[1]],L).                          
L = [1] ? 
yes
| ?- descomp_list([[1]],L).                       
L = [1] ? 
yes
| ?- descomp_list([[1],[2]],L).
L = [1,2] ? 
yes

| ?- descomp_list([[1],[2,3,[4,5]]],L).
L = [1,2,3,4,5] ? 
yes
| ?- descomp_list([1,[[2,3,[4,[5,[]],6,7],8],9],[[[[]]]],[3],1,[],[[2,[3,[4,[5,[[[]]],0],0]]]],10],L),write('Lista descompusa: '),write(L).
Lista descompusa: [1,2,3,4,5,6,7,8,9,3,1,2,3,4,5,0,0,10]
L = [1,2,3,4,5,6,7,8,9,3|...] ? < 20
L = [1,2,3,4,5,6,7,8,9,3,1,2,3,4,5,0,0,10] ? 
yes

*/
count_lists(E,R):-
    is_list(E),!,count_elems(E,N),
    R is N+1.
count_lists(_,0).

count_elems([H|T],R):-
    count_lists(H,Hc),
    count_elems(T,Tc),
    R is Hc+Tc.
count_elems([],0).

/*
| ?- nr_liste([[]],N).
N = 2 ?
yes
| ?- nr_liste(10,N).
N = 0 ?
yes
| ?- nr_liste([],N).
N = 1 ?
yes
| ?- nr_liste([[]],N).
N = 2 ? 
yes
| ?- nr_liste([[],[1]],N).
N = 3 ? 
yes
| ?- 
| ?- nr_liste([1,[[],[1]]],N).
N = 4 ? 
yes
| ?- 
| ?- nr_liste([1,[[2,3,[4,[5,[]],6,7],8],9],[[[[]]]],[3],1,[],[[2,[3,[4,[5,[[[]]],0],0]]]],10],N).
N = 20 ? 
yes
| ?-
*/
% Ex.2
nr_liste(E,R):-
    is_list(E),!,count_elems(E,N),
    R is N+1.
nr_liste(_,0).
count_elems_l([H|T],R):-
    nr_liste(H,Hc),
    count_elems_l(T,Tc),
    R is Hc+Tc.
count_elems_l([],0).
/*
| ?- nr_liste([[]],N).
N = 2 ? 
yes
| ?-  nr_liste(10,N).
N = 0 ? 
yes
| ?- nr_liste([],N).
N = 1 
yes
| ?- nr_liste([[],[1]],N).
N = 3 ? 
yes
| ?- nr_liste([1,[[],[1]]],N).
N = 4 ? 
yes
| ?- nr_liste([1,[[2,3,[4,[5,[]],6,7],8],9],[[[[]]]],[3],1,[],[[2,[3,[4,[5,[[[]]],0],0]]]],10],N).
N = 20 ? 
yes
| ?- nr_liste([[1,5,2,4],[1,[4,2],[5]],[4,[7]],8,[11]],R).
R = 8 ? 
yes
| ?- 
*/
% Ex.3
ras_malefic(vrajitoare, ['mua-ha-ha', 'ba-hah-ha', 'wuahahaha']).
ras_malefic(fantoma, ['buhuhuhu-uuuu','wuhuhu', 'haaaaaaaa']).
ras_malefic(vampir, ['chiri-chiri-chiri-chiri', 'hir-hir']).
ras_malefic(monstrulet_timid, ['hi-hi-hi-uhm-hi?','heh']).
ras_malefic(capcaun, ['u-hu-hu-huh','groh-hroh-hoo','wuhuhu']).
ras_malefic(balaur, ['groh-hroh-hoo','wuahahaha','wuhuhu','heh']).
%ras_malefic(timid, []).
% intersectie 2 multimi de tip list
% Lista_ras(Y):-ras_malefic(X,Y).
%intersectie
inter([], _, []).

inter([H1|T1], L2, [H1|Res]) :-
    member(H1, L2),
    inter(T1, L2, Res).

inter([_|T1], L2, Res) :-
    inter(T1, L2, Res).
/*
test(X):-
        inter([1,3,5,2,4], [6,1,2], X), !.

test(X).
X = [1, 2].
*/
/*
location(euston, [northernLine]).
location(warrenStreet, [victoriaLine, northernLine]).
location(warwickAvenue, [bakerlooLine]).
location(paddington, [bakerlooLine]).

hasCommonLine(Location1,Location2, CommonLines):-
    location(Location1,Line1),
    location(Location2,Line2),
    intersection(Line1,Line2,CommonLines).
*/

%interS(M1,M2,Ras):- xxx
areRasInComun(M1,M2,RasComun):- 
	ras_malefic(M1,R1),
	ras_malefic(M2,R2),
	inter(R1,R2,RasComun).
/*areRasInter(M1,M2):- 
	ras_malefic(M1,R1),
	ras_malefic(M2,R2),
	interS(R1,R2)*/
%evaluat(_,_,[]).
evaluat(M1,M2,RasComun):- areRasInComun(M1,M2,RasComun),M1\==M2, RasComun\==[].
%             format('Ras comun: ~q pentru ~s si ~s \n',[RasComun,M1,M2]).
%:- !.	
pereche_monstruleti(M1,M2,RasComun):- evaluat(M1,M2,RasComun). %,fail;true.
%pereche_monstruleti(_,_,[]).%:- !.

% eval1(H1|T):-eval1_aux(H1,T).
% eval1([]).
% eval1_aux(X,[H|T]:- X 

del(X,[X|L1],L1).
del(X,[Y|L1],[Y|L2]):-
del(X,L1,L2).
permute([],[]).
permute(L,[X|P]):-
del(X,L,L1),
permute(L1,P).

%pereche_monstruleti
/*Sa se scrie un predicat care primeste ca prim parametru fie un element simplu, fie o lista ce poate avea ca elemente inclusiv liste, 
si calculeaza in al doilea parametru adancimea listei. Prin adancime se intelege numarul maxim de liste in liste care exista in expresie. 
Practic pentru un element simplu adancimea e 0. Daca expresia data e o lista de elemente simple, adancimea e 1. 
Daca lista contine la randul ei alte liste, pentru orice element dintr-o lista adancimea e egala cu adancimea listei din care face parte 
la care se aduna propria adancime.

| ?- adancime([],A).
A = 1 ? 
yes
| ?- adancime(10,A).
A = 0 ? 
yes
| ?- adancime([[]],A).
A = 2 ? 
yes
| ?- adancime([[],[1]],A).
A = 2 ?
yes
| ?- 
| ?- adancime([[[],[1]]],A).
A = 3 ? 
yes
| ?- 
| ?- adancime([1,[[],[1]]],A).
A = 3 ? 
yes
| ?- 
| ?- adancime([1,[[2,3,[4,[5,[]],6,7],8],9],[[[[]]]],[3],1,[],[[2,[3,[4,[5,[[[]]],0],0]]]],10],A).
A = 9 ? 
yes
| ?-


*/
/*
max(A,B,A):- A > B, !.
max(_,B,B).
adancime([],1):- !.
adancime(E,0):- atomic(E).
adancime([H|T],A):- adancime(H,AH),AH1 is AH + 1,adancime(T,AT), max(AH1,AT,A).
*/
/* multimi

% Element X is in list?
*/
pert(X, [ X | _ ]).
pert(X, [ _ | L ]):- pert(X, L).
% Union of two list

union([ ], L, L).
union([ X | L1 ], L2, [ X | L3 ]):- \+pert(X, L2), union(L1, L2, L3).
union([ _ | L1 ], L2, L3):- union(L1, L2, L3).
% Intersection of two list
/*
inter([ ], _, [ ]).
inter([ X | L1 ], L2, [ X | L3 ]):- pert(X, L2), inter(L1, L2, L3).
inter([ _ | L1 ], L2, L3):- inter(L1, L2, L3).
*/
transpose([], []).
transpose([F|Fs], Ts) :-
    transpose(F, [F|Fs], Ts).

transpose([], _, []).
transpose([_|Rs], Ms, [Ts|Tss]) :-
        lists_firsts_rests(Ms, Ts, Ms1),
        transpose(Rs, Ms1, Tss).

lists_firsts_rests([], [], []).
lists_firsts_rests([[F|Os]|Rest], [F|Fs], [Os|Oss]) :-
        lists_firsts_rests(Rest, Fs, Oss).
/*		
exterm(T, M, E) :-
    T =.. [F|As],
    select(E, As, Bs),
    M =.. [F|Bs].		
	*/
/*	
map(1,[[2,0,0,0,0,0,0,0,0,0],
   [3,2,0,0,2,2,0,0,0,0],
   [0,2,0,0,2,0,0,0,0,0],
   [0,0,0,0,0,0,0,0,0,0],
   [0,0,2,0,0,0,1,0,0,0],
   [0,2,2,0,0,0,0,0,0,0],
   [0,0,0,0,0,0,0,1,1,0],
   [0,0,0,0,0,0,0,0,0,0],
   [0,0,0,0,0,0,0,0,0,0],
   [0,0,0,0,0,0,0,0,0,0]]).	
*/   
%:- initialization(main).
%:- dynamic(visited).

matrix([
  [2,0,0,0,0,0,0,0,0,0],
  [3,2,0,0,2,2,0,0,0,0],
  [0,2,0,0,2,0,0,0,0,0],
  [0,0,0,0,0,0,0,0,0,0],
  [0,0,2,0,0,0,1,0,0,0],
  [0,2,2,0,0,0,0,0,0,0],
  [0,0,0,0,0,0,0,1,1,0],
  [0,0,0,0,0,0,0,0,0,0],
  [0,0,0,0,0,0,0,0,0,0],
  [0,0,0,0,0,0,0,0,0,0]
]).

m11([
[a(1), x(2)],
[b(3), t(4)],
[a(5), b(6)]
]).

visited(0, 0).
visited(1, 0).
visited(1, 1).
visited(4, 6).
visited(5, 6).

printMatrix(M) :- printRows(M, 0).
printRows([], _).
printRows([H|T], R) :- 
  printRow(H, R, 0), 
  Rpp is R + 1, 
  printRows(T, Rpp).
printRow([], _, _) :- nl.
printRow([H|T], R, C) :- 
%  (visited(R,C), format('~q',[H]);write('~')),
   (visited(R,C), write([H]);write('~')),
  write(' '),
  Cpp is C + 1, 
  printRow(T, R, Cpp).

%main :- matrix(M), printMatrix(M). % , halt quit prolog,exit to OS


%ma11:- m11(M),printMatrix(M).

%transpusa_sturcturi(+Matrix, -Transpusa)
transpusa_structuri(StructMatrix, Transpusa):- gen_matrix(StructMatrix, Matrix), transpose(Matrix, Transpusa).

%gen_matrix(+StructMatrix, Matrix)
gen_matrix([], []).
gen_matrix([H|T], [Lout|MT]):- get_line(H, Lout), gen_matrix(T, MT).

%Transforma fiecare linie compusa in una simpla
get_line([], []).
get_line([H|T], [Numar|Lout]):- H=..[_, Numar],get_line(T, Lout).

matrice(m_struct, 
 [[a(1), x(2)],
 [b(3), t(4)],
 [a(5), b(6)]
 ]).
 
% | ?- matrice(m_struct, M), transpusa_structuri(M, T).
%main

take([H|T],H,T).
take([H|T],R,[H|S]):- take(T,R,S).
%m1x:-take([1,2,3],E,Rest).
