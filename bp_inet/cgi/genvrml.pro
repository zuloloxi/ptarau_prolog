% BinProlog based VRML 2.0 Generator
% Author: Paul Tarau
%
% Free to distribute, adapt, free to make money with it,
% free to pretend you have wrote it:-)
%
% Tested with BinProlog 9.x
%
% Updated: Feb 2003

:-['../library/deprecated'].

main:-mime,generate.

% used in CGIs to tell the browser we send back VRML 2.0
mime:-
  % write('220 ok'),nl,
  write('content-type: x-world/x-vrml'),nl,
  nl.

% change suffix to *.wrl to see output with
% Netscape or Explorer + CosmoPlayer or WorldView

generate:-
  toVrml, % shows trace on stdout
  % toFile('/bp_inet/cgi/genvrml.txt'),
  true.

% TOPLEVEL VRML 2.0 FILE GENERATOR

toFile(File):-
  tell(File),
    toVrml, % sends output to a file
  told.

% opertors helping to mimic VRML 2.0 syntax

:-op(10,fx,($)).
:-op(10,fx,(`)).
:-op(20,fx,(@)).
:-op(90,xfy,(@)).

:-op(730,fx,(def)).
:-op(730,fx,(use)).

:-op(670,fx,(route)). :-discontiguous (route)/1.
:-op(660,xfx,(to)).
%:-op(650,xfy,(.)).

toVrml:-
  call_ifdef(header(X),fail),vrml_phrase(X),fail
; call_ifdef(proto(X),fail),vrml_phrase('PROTO'(X)),fail
; call_ifdef(group(X),fail),(X= @Y->true;Y=X),vrml_phrase('Group'@Y),fail
; call_ifdef(route(X),fail),vrml_phrase(route(X)),fail
; nl.

% BASIC Prolog to VRML 2.0 SYNTAX MAPPING
%
% -- uses no semantic VRML knowledge
% -- covers the lexical + context-free approximation of target syntax 

header('#VRML V2.0 utf8').

vrml_phrase(Goal):-
  vrml_phrase(Goal,Code),
  show_vrml(Code),nl,
  fail
; true.

vrml_phrase(Goal,Code):-
  lval(indent,ctr,int(0)), % updatable counter, reset on backtracking
  dcg_phrase(toVrml(Goal),Code). % starts Assumption Grammar processing

/* syntax mapping of some key idioms
Prolog         VRML
-------------------------
  @{  } ===>   {  }
  @[  ] ===>   [  ]
  f(a,b,c) ==> f a b c
  a is b   ==> a 'IS' b
  a=b      ==> a b
 ------------------------
 #X ==> pastes object directly into
        Assumption Grammar output stream,
        similar to [X] in classic DCGs
*/

@X:-toVrml(X).

toVrml(X):-number(X),!,#X.
toVrml(X):-atomic(X),!,#X.
toVrml(A@B):-!,#indent(=),toVrml(A),toVrml(B).
toVrml(A=B):-!,%#indent(=),
  toVrml(A),toVrml(B).
toVrml(A is B):-!,#indent(=),toVrml(A),#'IS',toVrml(B).
toVrml(def A=B):-!,#indent(=),#'DEF',toVrml(A),toVrml(B).
toVrml(use A):-!,#indent(=),#'USE', toVrml(A).
toVrml(route A.X to B.Y):-!,#indent(=),
  namecat(A,'.',X,AX),namecat(B,'.',Y,BY),
  #'ROUTE',#AX,#'TO',#BY.
toVrml($A):-!,listify(A,Cs),[Q]="""",append(Cs,[Q],Xs),name(X,[Q|Xs]),#X.
toVrml({X}):-!,#'{',#indent(+),toVrml(X),#indent(-),#'}'.
toVrml(`X):-!,X.
toVrml(X):-is_list(X),!,#'[',#indent(+),vrml_list(X),#indent(-),#']'.
toVrml(X):-is_conj(X),!,vrml_conj(X).
toVrml(T):-compound(T),#indent(=),vrml_compound(T).

vrml_compound(T):- T=..[F|Xs], #F, vrml_args(Xs).

vrml_list([X|Xs]):-toVrml(X),vrml_list1(Xs).

vrml_list1([X|Xs]):-!,#',',toVrml(X),vrml_list1(Xs).
vrml_list1([]).

vrml_args([X|Xs]):-!,toVrml(X),vrml_args(Xs).
vrml_args([]).

vrml_conj((X,Xs)):-!,toVrml(X),vrml_conj(Xs).
vrml_conj(X):-toVrml(X).

is_list(Xs):-nonvar(Xs),Xs=[_|_].
is_conj(Xs):-nonvar(Xs),Xs=(_,_).

% POSTPROCESSING: writes out VRML 2.0 
% while performing indentation and inserting spaces

% print out
show_vrml([]).
show_vrml([X|Xs]):-
  show_vrml1(X),
  show_vrml(Xs).

show_vrml1(indent(+)):-!,incTab.
show_vrml1(indent(-)):-!,decTab.
show_vrml1(indent(=)):-!,showTab.
show_vrml1(X):-write(X),write(' ').

% compute indentation hints
incTab:-
  val(indent,ctr,Val),
  arg(1,Val,N),
  N1 is N+2,setarg(1,Val,N1)
  % ,nl ,tab(N1)
  .

showTab:-
  val(indent,ctr,Val),
  arg(1,Val,N),
  nl,tab(N).

decTab:-
  val(indent,ctr,Val),
  arg(1,Val,N),
  N1 is N-2,setarg(1,Val,N1),
  nl,tab(N).


% MACRO SYNTAX LAYER

% -- adds some actual VRML knowledge
% -- allows defining top-level proto,group,route clauses

:-op(100,fx,(proto)). :-discontiguous proto/1.
:-op(100,fx,(group)). :-discontiguous group/1.

% to be extended
 
/*********** PROTOTYPE LIBRARY ******************/

proto aShape @[ 
  exposedField('SFColor')=color(1,0,0),
  exposedField('MFString')=texture@[],
  exposedField('SFNode')=geometry('Sphere'@{})
]
@{
   'Shape' @{
       geometry is geometry,
       appearance='Appearance' @{
         material='Material' @{
           diffuseColor is color
         },
         texture='ImageTexture' @{
           url is texture
         }
       }
   }
}.

% to be extended

% PROTOTYPE BASED Prolog VRML definition library

shape(Geometry):-
  default_color(Color),
  toVrml(
     aShape @{
       geometry(Geometry@{}),
       Color
     }
  ).

% basic colors - add more

aColor(red,    color(1.0, 0.0, 0.0)).
aColor(blue,   color(0.0, 0.0, 1.0)).
aColor(green,  color(0.0, 1.0, 0.0)).
aColor(random, color(R,G,B)):- rancolor(R), rancolor(G), rancolor(B).
  
ranfraction(F):-random(X), F is abs(X mod 256)/256.

rancolor(C):-ranfraction(C0),(C0<0.2->C=0.2;C=C0).

default_color(C):- assumed(color(Name)),!, aColor(Name,C).
default_color(color(R,G,B)):- assumed(color(R,G,B)),!.
default_color(C):- aColor(random,C).

% simple objects - add more

sphere:- shape('Sphere').
cone:- shape('Cone').
cylinder:- shape('Cylinder').
box:- shape('Box').

ranshape(S):-
  random(X),R is X mod 4,
  ( R=:=0->S=cylinder
  ; R=:=1->S=cone
  ; R=:=2->S=box
  ; S=sphere
  ).

transform(T,S,R,Children):-
  functor(T,translation,3),
  functor(S,scale,3),
  functor(R,rotation,4),!,
  toVrml(
     'Transform' @{
         T,
         S,
         R,
         children @Children  
      }
  ).
transform(T3,S3,R4,_):-
  errmes(bad_transform,transform(T3,S3,R4,'...')).

% USER LEVEL TEST DATA

group @{
  children @[
    def saucer = `transform(
       translation(0,1,1),scale(0.6,0.2,0.6),rotation(0.5,0.5,0,1.5),
       [
         `sphere,
         % this can used to propagate a color over a region
         `(color(blue)=>>cone)
       ]
     ),
    `transform(
       translation(1,-2,0),scale(0.2,0.6,0.9),rotation(0,1,0,2.0),
       [
         `box
       ]
     ),
    `transform(
       translation(-1,-2,0),scale(0.8,0.4,0.4),rotation(0,1,0,1.5),
       [
         % just to show how one can play with variables
        `ranshape(S), `S,  
         use saucer
       ]
     ),
     def t = 'TimeSensor' @{
       loop='TRUE',cycleInterval=8
     },
     def p = 'PositionInterpolator' @{
        key @[0, 0.25, 0.5, 0.75, 1],
        keyValue @[
           0, 2, 1,
           -1, 1, 0,
           2, 2.5, 1,
           -2, 0, -1,
           0, 2, 1
        ]
     },
     def r = 'OrientationInterpolator' @{
        key @[0.0, 0.5, 1.0],
        keyValue @[
          0.5,0.5,0.0,1.5,
          0.0,1,0.0,-1.0,
          0.5,0.5,0.0,1.5
        ]
     }
   ],
   route t.fraction_changed to p.set_fraction,
   route t.fraction_changed to r.set_fraction
}.

route p.value_changed to saucer.set_translation .
route r.value_changed to saucer.set_rotation .
