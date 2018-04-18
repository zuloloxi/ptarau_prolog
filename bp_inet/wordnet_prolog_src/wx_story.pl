:-[wx_sdata].

story_dir('\InetPub\wwwroot\vista\stories\').
story_file("what_he_might_have_been").

story_step(File,Is,Os):-
  get_story_fields(File),
  match_story_data(File,Is,Xs),
  ensure_last(Xs,'.',Os).

match_story_data(File,Is,Xs):-
  match_pattern([Wh:wh_word(Wh),is,the,Fs,of,_,story,_],Is),
  ( Field=Fs
  ; qsf([Wh,is,the|Fs],Field)
  ),
  story_field_of(File,Field,Xs),
  !.
match_story_data(File,Is,Xs):-
  match_pattern([tell,_,the,Field,of,the,story,_],Is),
  !,
  story_field_of(File,Field,Xs).
match_story_data(File,Is,Xs):-
  match_pattern([tell,_,story,_],Is),
  !,
  story_field_of(File,[text],Xs).
match_story_data(File,Is,Xs):-
  qsf(Is,FieldPhrase),
  !,
  story_field_of(File,FieldPhrase,Xs).
match_story_data(_File,Is0,Xs):-
  ensure_last(Is0,'.',Is),
  qsd(Is,Xs),
  !.
match_story_data(File,Is,Xs):-  
  once(member(story,Is)),
  story_field_of(File,Names,Xs),
  qvariant(Names,QNames),
  append(QNames,[_,'?'],Pattern),
  match_pattern(
     Pattern,
     Is).

get_story_fields(F):-val(story_loaded,F,yes),!.
get_story_fields(F):-
  story_dir(D),
  namecat(D,F,'.xml',File),
  exists_file(File),
  parse_xml(File,Tree),
  get_story_fields(Tree,F),
  let(story_loaded,F,yes).

story_field_of(Tree,Field):-
  arg(2,Tree,Content),
  arg(3,Content,Items),
  member(Field,Items).
  
get_story_fields(Tree,Story):-
  (abolish(Story,3)->true;true),
  foreach(story_field_of(Tree,Field),add_story_field(Story,Field)).

add_story_field(Story,Field):-nonvar(Field),Field=..[node|Xs],!,
  SField=..[Story|Xs],
  assert(SField).
add_story_field(Story,Field):-
  println(error_unexpected_xml_field(Field,in(Story))).
  
story_field_of(File,Names,Value):-
  functor(Node,File,3),
  asserted(Node),
  Node=..[File,[_,'.'|Names],_,Ds],
  Ds=[data(Value)|_].

qsf:-
  qsf(I,O),
  println((I->O)),nl,
  fail.
qsf.

qsd:-
  qsf(I,O),
  println((I=>O)),nl,
  fail.
qsd.

qsf(Is0,Fs):-
  (nonvar(Is0)->ensure_last(Is0,'?',Is);Is=Is0),
  qsf0(Is,Fs).
    
% wh.. is the ... -> filed
qsf0([W,Is,the|XFs],F):-
  aux_is_word(Is),
  sf(F,Xsss),  
  member(wh(W)=XFss,Xsss),
  member(XFs0,XFss),
  append(XFs0,['?'],XFs).
  
% question -> field  
qsf0(Qs,F):-
  sf(F,Xs),  
  member(qs=Css,Xs),
  member(Cs,Css),
  codes_words(Cs,Qs0),
  to_lower_first(Qs0,Qs1),
  ensure_last(Qs1,'?',Qs).
  
% what does the  ... of the story mean  -> answer
qsd([Def,the,F,of,the,story,'.'],Ws):-
  member(Def,[define]),
  qsd1([F],Ws).
qsd([what,do,you,mean,by,F,'.'],Ws):-
  qsd1([F],Ws).

qsd1(Fs,Ws):-
  qsd0(Fs,Ws).
          
qsd0(Fs,Ws):-  
  sf(Fs,Xss),
  member(def=Cs,Xss),
  codes_words(Cs,Ws).

