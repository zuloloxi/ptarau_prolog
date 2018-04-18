xml_test:-
  story_dir(SD),
  dir2files(SD,Fs),
  member(F,Fs),
  namecat(SD,'',F,Fname),
  println(entering=Fname),
  parse_xml(Fname,_),
  println(exiting=Fname),
  fail.

% has errors - not really xml
semcore:-
  D='\paul\wordnet\semcor2.0\brown1\tagfiles',
  F='xbr-a01.txt',
  namecat(D,'\',F,DF),
  % foreach(char_of(DF,C),put(C)),
  parse_xml(DF,T),
  show_xml(T).
    
parse_xml(File):-
  parse_xml(File,Tree),
  show_xml(Tree).

parse_xml(File,Tree):-
  findall(T,xml_token_of(File,T),Ts),
  % println(parsing_xml_tokens_list_from(File)),
  doc(Tree,Ts,[]).

xml_token_of(File,T):-name(NL,[10]),token_of(File,T),T\==NL.
   
doc(xml_doc(H,E))-->headers(H),element(E).

headers([header(Is)|Hs])-->['<','?'],!,header_items(Is),headers(Hs).
headers([comment(Is)|Hs])-->['<','!'],!,comment_items(Is),headers(Hs).
headers([])-->[].

header_items([])-->['?','>'],!.
header_items([X|Xs])-->[X],header_items(Xs).

comment_items([])-->['>'],!.
comment_items([X|Xs])-->[X],comment_items(Xs).

atomize([Name|_],Name):-!.
atomize(Name,Name).

xml_filter(Ns,_Node,NewNode):-
  atomize(Ns,Name),
  call_ifdef(xml_ignore(Name),fail),
  !,
  NewNode=ignored(Name).
xml_filter(_Name,Node,Node).

element(Node)-->
  % start_tag(Name,Atts,End),
  ['<'],
  !,
  xml_name(Name),
  atts(Atts,End),
  maybe_items(End,Is,Name),
  {xml_filter(Name,node(Name,Atts,Is),Node)}.
element(data(Ds))-->
  data_bloc(As),
  {xml_filter_data(As,Ds)}.

xml_filter_data(Ds,Ts):-
  call_ifdef(xml_transform(Ds,Ts),fail),
  !.
xml_filter_data(Ds,Ds).

data_bloc([D|Ds])-->data_element(D),!,data_bloc(Ds).
data_bloc([])-->[].

data_element(X)-->[X],{ \+(member(X,['<','>'])) }.

maybe_items(end,[],_)-->[].
maybe_items(more,Is,Name)-->items(Is,Name).

end_tag(_)-->['/','>'].
end_tag(Name)-->['<','/'],xml_name(Name),['>'].

items([],Name)-->end_tag(Name),!.
items(NewIs,Name)-->element(I),items(Is,Name),{add_element(I,Is,NewIs)}.

add_element(I,Is,[I|Is]).

atts([],end)-->['/','>'],!.
atts([],more)-->['>'],!.
atts(NewXs,End)-->
  xml_name(A,['=']),
  ['='],
  one_att(B),
  atts(Xs,End),
  {xml_filter_att(A=B,Xs,NewXs)}.

xml_filter_att(Ns=_,As,As):-
  atomize(Ns,Name),
  call_ifdef(xml_ignore_att(Name),fail),
  !.
xml_filter_att(A,As,[A|As]).

one_att(B)-->['"'],!,xml_names(B,['"']),['"'].
one_att(B)-->xml_name(B,['/','>']).

xml_names([B|Bs],End)-->xml_name(B,End),!,xml_names(Bs,End).
xml_names([],_)-->[].

xml_name(Xs)-->xml_name(Xs,['/','>']).

xml_name(Xs,End)-->xml_name0(Ns,End),{unlistify(Ns,Xs)}.

% unlistify([[N]],Xs):-!,Xs=N.
unlistify([N],Xs):-!,Xs=N.
unlistify(Ns,Ns).

xml_name0([X,Op|Xs],End)-->
   name_element(X,End),
   [Op],
   {member(Op,[':','-','.'])},
   !,
   xml_name0(Xs,End).
xml_name0([X],End)-->
  name_element(X,End).

name_element(X,End)-->[X],{ \+(member(X,End)) }.

% display an XML tree

show_xml(xml_doc(Hs,E)):-
  println('xml_doc:'),
  nl,
  foreach(
    member(H,Hs),
    show_header(H)
  ),
  nl,
  show_xml(E,2).

show_header(H):-tab(1),println(H).

show_xml(node(Name,As,Is),Level):-
  Next is Level+1,
  show_name(Level,Name,As),
  show_items(Is,Next).
show_xml(data(D),Level):-
  tab(Level),println(D).

show_name(Level,Name,As):-
  L is Level+1,
  tab(Level),write(Name),write(':'),nl,
  foreach(
    member(A,As),
    show_att(L,A)
  ),
  nl.
  
show_att(L,Ks=Vs):-!,
  tab(L),
  write(Ks),write('='),nl,
  L1 is L+1,
  member(V,Vs),
    tab(L1),write(V),nl,
  fail
;true.
show_att(L,A):-
  tab(L),
  println(A).
    
show_items([],_).
show_items([I|Is],Level):-
  show_xml(I,Level),
  show_items(Is,Level).


%%%%%%%%%%%%%

xml_path(Tree,E-N,Leaf):-
  xml_path(Tree,Leaf,Path,[]),
  separate_path(Path,Es,Ns),
  memo_path(tags,Es,E),
  memo_path(pos,Ns,N).

xml_path(xml_doc(Hs,E),Leaf)-->
  add_leaf(Hs,Leaf) 
; add_node(E,Leaf,1).

add_leaf(T,T)-->{arg(1,T,[_|_])},[].
  
add_node(node(Name,As,Is),Leaf,N)-->
  [N-Name],
  ( add_leaf(a(As),Leaf)
  ; add_items(Is,Leaf,0)
  ).
add_node(data(D),Leaf,_)-->
  add_leaf(d(D),Leaf).

add_items([I|_],Leaf,N)-->add_node(I,Leaf,N).
add_items([_|Is],Leaf,N)-->{NewN is N+1},add_items(Is,Leaf,NewN).

separate_path([],[],[]).
separate_path([N-E|Ps],[N|Ns],[E|Es]):-
  separate_path(Ps,Ns,Es).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
init_memo:-init_gensym(path_no).
  
memo_path(F,Path,No):-
  functor(Pred,F,2),arg(1,Pred,Path),arg(2,Pred,No),
  term_hash(Path,Db),
  ( db_asserted(Db,Pred)->true
  ; gensym_no(path_no,No),
    ( db_head(Db,Pred)->true
    ; assert(path_db(Db,F))
    ),
    db_assert(Db,Pred)
  ).

get_memos(n2p(No,Path,F)):-
  asserted(path_db(Db,F)),
  functor(Pred,F,2),arg(1,Pred,Path),arg(2,Pred,No),
  db_asserted(Db,Pred).

clean_memos:-
  foreach(
    asserted(path_db(Db,_)),
    db_clean(Db)
  ),
 (abolish(path_db,2)->true;true),
 init_memo.

save_memos(File):-
  tell(File),
  foreach(
    get_memos(M),
    pp_fact(M)
  ),
  told.
    
%%%%%%%%%%%%%
% debug predicates

x-->[X],{println('!!!'(X)),fail}.
x-->[].

x(X)-->[R],{println(X),println(next=R),fail}.
x(_)-->[].

