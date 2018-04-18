function_word_phrase([V]):-function_word(V).

function_word(V):-function_word1(V,_T,_N).
    
function_word([V],[V],V,T,N):-
  function_word1(V,T,N).

function_word1(V,T,N):-
  var(V),
  !,
  lfunction_word(V0,T,N),
  ( V=V0
  ; to_upper_word(V0,V)
  ).
function_word1(V0,T,N):-
  atom(V0),
  to_lower_word(V0,V),
  lfunction_word(V,T,N).
 
lfunction_word(V0,T,N):-
  function_word0(V0,T,N).
lfunction_word(V0,Kind,0):-
  kw0(V0,Kind).
lfunction_word(i,T,N):-
  function_word0('I',T,N).

% original lexical ref. lost - to recover e/2 should be: e(variant,word,synset) !!!  
exception_word([V|Vs],I,T,N):-
  e(V,Es),
  member(Vs/I,Es),
  i2t(I,T),
  N=1.
  
lex_variant(T,V,W):-
  name(V,Cs),
  fix_word(T,EndVs,EndWs),
  append(Xs,EndVs,Cs),
  det_append(Xs,EndWs,Ds),
  name(W,Ds).
  
maybe_word(V,W,I,T,N):-  
  lex_variant(T,V,W),
  w2itn([W],I,T,N).

% exception_word(V):-exception_word([V|_],_,_,_,_).
exception_word(V):-e(V,_).

new_word([V],[V],new):-new_meta_word(V).

new_meta_word(V,K,L):-findonce(V,new_meta_word(V),K,L).

known_meta_word(V,K,L):-findonce(V,known_meta_word(V),K,L).

new_meta_word(V):-meta_word(V),is_new_word(V).

known_meta_word(V):-meta_word(V),once(is_known_word(V)).

is_known_word(V):-function_word(V).
is_known_word(V):-w(V,_).
% is_known_word(V):-exception_word(V).

is_new_word(V):- \+(is_known_word(V)).

word2cases(U,W):-
  atom(U),
  !,
  name(U,Us),
  codes2cases(Us,Cs),
  name(W,Cs).
word2cases(U,U).

codes2cases([U|Ls],Cs):-
  to_lower_char(U,L),
  U=\=L,
  !,
  (Cs=[L|Ls];Cs=[U|Ls]).
codes2cases(Cs,Cs).

/* 
  extracts words not in the dictionary from
  WordNet examples and definitions.
*/

meta_word(W,K,L):-findonce(W,meta_word(W),K,L).

meta_word(W):-
  meta_words_in(Ws),
  member(W,Ws),
  atom(W).

meta_words_in(Ws):-w2i([_|Ws],_).
meta_words_in(Ws):-g(_,S),context_of(S,Ws).

context_of(S,Def):-member(def(Def),S).
context_of(S,Ex):-member(ex(Ex),S).

/*
  returns each synset of a file while
  counting their frequency
*/
synset_count_of(File,Id-Times):-
  findonce(Id,synset_count_of0(File,Id),Times).

synset_count_of0(File,Id):-
  file2synsets(File,Xss,_),
  member(Xs,Xss),
  member(Id,Xs).

/*
 parses a file and returns its synsets
 one sentence at a time
*/    

file2synsets(File,Ws,Is):-
  file2synsets(4,File,Ws,Is).
  
file2synsets(N,File,Ws,Is):-
  sentence_of(File,Ts),
  tokens2synsets(N,Ts,Ws,Is).

tokens2synsets(Ts,Is,Wss):-
  tokens2synsets(4,Ts,Is,Wss).

tokens2synsets(FirstN,Ts,Is,Wss):-
  tokens2info(FirstN,Ts,Xss),
  info2synsets(Xss,Is,Wss).

/* not used
% add pattern to use most freq noun word in the sentence
    
match_info([W|_Ws]-Is/K,T,W,Is):-arg(1,K,T).

head_word_of([W|_]-_Is/_K,W).

head_word(InfoE,EWs):-head_word(InfoE,EWs,_).

head_word([W|_]-_Is/_K,EWs, W):-member(W,EWs).
*/

info2synsets([],[],[]).
info2synsets([(Ws-I/K)|Xss],[I|Is],[Ws/K|Wss]):-
  info2synsets(Xss,Is,Wss).
    
tokens2info(FirstN,Ts,Xss):-
  fix_first_token(Ts,LTs),
  map_tokens(Xss,FirstN,LTs,[]).

fix_first_token(['I'|Ts],['I'|Ts]):-!.
fix_first_token([T|Ts],[L|Ts]):-
  % cut - will loose the possible uppercase word, unless it is in WN
  ( word2cases(T,L),w(L,[_|_])->true
  ; L=T
  ).

% map_tokens(_,FirstN,Xs,YS):-println(here=FirstN+Xs),fail.
map_tokens([Xs|Xss],FirstN)-->map_best_token(FirstN,Xs),!,map_tokens(Xss,FirstN).
map_tokens([[T]-none/other|Xss],FirstN)-->[T],!,map_tokens(Xss,FirstN).
map_tokens([],_) --> [].

% possibly optimize for longest sequence !!!
map_best_token(FirstN,Vs-[I|Is]/Ks,S1,S2):-
  %println(here_again=FirstN+S1),
  find_at_most(FirstN,x(VsKs,S1,S2),map_token(VsKs,S1,S2),Xs),
  %println(there_again=FirstN+S1),
  Xs=[x(Vs-I/Ks,S1,S2)|Ys],
  map(get_is,Ys,Is).
  
get_is(X,Is):-
  arg(1,X,Y),
  arg(2,Y,Z),
  arg(1,Z,Is).

map_token([Variant|Vs]-Ks)-->
  [Variant],
  {process_token([Variant|Vs],Ks)},
  consume_tokens(Vs).
  
consume_tokens([T|Ts])-->[T],!,consume_tokens(Ts).
consume_tokens([])-->[].

process_token([V|Vs],I/TNX):-variant2word([V|Vs],_WWs,I,TNX).

variant2word(VVs,WWs,I,k(T,N,fun)):-function_word(VVs,WWs,I,T,N).
variant2word(VVs,VVs,I,k(T,N,exc)):-exception_word(VVs,I,T,N). % was generating too much - like w2w
variant2word(VVs,VVs,I,k(T,N,wnet)):-w2itn(VVs,I,T,N).
variant2word([V],[W],I,k(T,N,new)):-n(V,_K),maybe_word(V,W,I,T,N).

wvariant_of(T,Vs,Ws):-variant2word(Vs,Ws,_,k(T,_,_)).

good_word_phrase(VVs):-variant2word(VVs,_WWs,_I,_K).
  
qvariant(Qs,Qs).
qvariant(Qs,NewQs):-map(wvariant,Qs,NewQs),Qs\==NewQs.

wvariant(W,NewW):-
  find_at_most(2,NewW,nvariant(W,NewW),Ws),
  sort([W|Ws],SWs),
  member(NewW,SWs).

nvariant(W,NewW):-var(W),!,NewW=W.
nvariant(W,NewW):-nonvar(W),
  w2wx([W],[NewW],_,noun),
  \+(function_word(W)),
  \+(exception_word(W)),
  \+(member(W,[do,why])).


wdefines(Type,Words,Def):-
  wdata(Words,_I,_S,Type,SWords,Ds),
  appendN([Words,[is,a,kind,of],SWords,[','],Ds],Def).

wq(Words,intended_meaning(Words,I,S),Query,Final):-
  wdata(Words,I,S,Type,SWords,Ds),
  once(appendN([
     ['When',you,say,the,Type,'"'],Words,['"',','],
     [do,you,mean,a,kind,of],SWords,[','],
     Ds,['?']
  ],Qs)),
  once(appendN([
     ['"'],Words,['"',','],
     [means,a,kind,of],SWords,[','],
     Ds,['.']
  ],Fs)),
  Query=Qs,
  Final=Fs.
  
wdata(Words,I,S,Type,SWords,Ds):-
  w2itn(Words,I,Type,_), 
  g(I,Sense),
  gen(I,S),
  i2wtn(S,SWords,Type,_),
  sense2def(Sense,Ds).
  
wmeans(Type,Words,Def):-
  w2itn(Words,I,Type,_),
  g(I,Sense),
  sense2def(Sense,Def).
  
wexhibits(Type,[W|Ws],Ex):-
  w2itn([W|Ws],I,Type,_),
  g(I,Sense),
  sense2ex(Sense,Ex),
  member(W,Ex).

wextends(Type,Words,Def):-
  w2itn(Words,I,Type,_), 
  gen(I,S),
  g(S,Sense),
  i2wtn(S,SWords,Type,_),
  SWords\==Words,
  sense2def(Sense,Ds),
  appendN([Words,[is,a,kind,of],SWords,[',',are,you,thinking,about],Ds],Def).

wrelateds(Type,Words,Def):-
  w2itn(Words,I,Type,_), 
  g(I,Sense),
  related(I,S),
  g(S,Sense),
  i2wtn(S,SWords,Type,_),
  SWords\==Words,
  sense2words(_defex,Sense,Ds),
  appendN([Words,[brings,me,to],SWords,['.'],Ds],Def).
    
words_def(Ws,Ds):-means(Ws-Sense,_),member(def(Ds),Sense).
words_ex(Ws,Es):-means(Ws-Sense,_),member(ex(Es),Sense).
  
means(Words0):-
  if(Words0=[_|_],Words=Words0,Words=[Words0]),
  means(Word,Words-Sense,IK),
  writeq(Word=>Words),write(':'),write(IK),nl,
  foreach(
    member(S,Sense),
    (writeq(S),nl)
  ),
  nl,
  fail
; nl.
means([V|Vs]-Sense,I-K):-
  means(V,[V|Vs]-Sense,I-K).
  
means(V,[V|Vs]-Sense,I-K):-
  variant2word([V|Vs],_WWs,I,K),
  g(I,Sense).

def2noun(I,GI):-def2i(noun,I,GI).

def2i(T,I,GI):-gloss2i(def,T,I,GI).

ex2noun(I,GI):-ex2i(noun,I,GI).

ex2i(T,I,GI):-gloss2i(ex,T,I,GI).

gloss2i(Op,T,I,GI):-gloss2is(Op,T,I,GIs),member(GI,GIs).

gloss2is(Op,T,I,GIs):-
  findall(GI,gloss2i0(Op,T,I,GI),Is),
  sort(Is,GIs).
  
gloss2i0(Op,T,I,GI):-
  gloss2ws0(Op,I,Ts),
  member(W,Ts),
  Ws=[W],
  w2itn(Ws,GI,T,_).

gloss2ws(Op,I,Ws):-
  findall(Ws,gloss2ws0(Op,I,Ws),Wss),
  appendN(Wss,Us),
  sort(Us,Ws).
  
gloss2wss(Op,I,Wss):-
  findall(Ws,gloss2ws0(Op,I,Ws),Wss).
  
gloss2ws0(Op,I,Ws):-
  g(I,Sense),
  member(X,Sense),
  functor(X,Op,_),
  arg(1,X,Ts),
  to_content(Ts,Ws).
    
relate_words(Ws1,Ws2,Ws):-
  relate(Ws1,Ws2,3,_-Ws).
relate_words(Ws1,Ws2,R):-
  relate_from(Ws1,Ws2,R).
relate_words(Ws1,Ws2,R):-  
  relate_from(Ws2,Ws1,R).
  
relate_from(Ws1,Ws2,R):-
  words_def(Ws1,R),
  member(W,R),
  member(W,Ws2),
  \+(function_word(W)).
relate_from(Ws1,Ws2,R):-
  words_ex(Ws1,R),
  member(W,R),
  member(W,Ws2),
  \+(function_word(W)).
  
relate(Ws1,Ws2,K-Ws):-relate(related,Ws1,Ws2,4,K-Ws).
relate(Ws1,Ws2,K-Ws):-relate(partwise,Ws1,Ws2,1,K-Ws).
relate(Ws1,Ws2,K-Ws):-relate(rhyp,Ws1,Ws2,1,K-Ws).
relate(Ws1,Ws2,K-Ws):-relate(coord,Ws1,Ws2,1,K-Ws).

relate(Ws1,Ws2,Depth,K-Ws):-
  relate(related,Ws1,Ws2,Depth,K-Ws).
    
relate(Rel,Ws1,Ws2,Depth,K-Ws):-
  cw2is(Ws1,Is),cw2is(Ws2,Js),
  rjoin(Rel,any,Depth,Is,Js,K,Ys),
  is2wss(Ys,Wss),
  member(Ws,Wss),
  Ws\==Ws1,
  Ws\==Ws2.

close_to(This,That):-close_to0(This,That).
close_to(This,That):-close_to0(That,This).

close_to0(This,That):-
  w2itn([This|More],_I,_T,_N),
  member(That,More),
  \+(function_word(That)).
  
sense2def(Sense,Ds):-sense2words(def,Sense,Ds).

sense2ex(Sense,Es):-sense2words(ex,Sense,Es).

sense2words(DefEx,Sense,Ls):-
  member(S,Sense),
  functor(S,DefEx,1),arg(1,S,Xs),
  to_lower_first(Xs,Ls).
    
freq_words(F,Types):-
  nonvar(Types),
  member(Type,Types),
  foreach(
    occurence_of(F,Type,W,Times),
    (
      write(W-Times),write(',')
    )
  ),
  nl.

occurence_of(File,Type,W,Times):-
  findonce(W,word_of(File,Type,W,_OW),Times).

word_of(File,Type,T,W):-stoken_of(File,T),w2t(T,Type),W=T.
%word_of(File,Type,T,W):-stoken_of(File,T),wplus(T,Type,W,_).

stoken_of(File,T):-sentence_of(File,Ts),member(T,Ts).

top_noun(I,Wss):-top_id_words(noun,I,Wss).

top_adj(I,Wss):-top_id_words(adjective,I,Wss).

top_verb(I,Wss):-top_id_words(verb,I,Wss).
    
top_id_words(Type,Id,Wss):-
  i(Id,Fs),
  \+(hyp(Id,_)),
  f2ws(Fs,Type,_,Wss).

% cw2i(noun:[female],R).
cw2i(C:Ws,Id):- !,
  w2i(Ws,Id),
  ocall(C,Id).
cw2i(Ws,Id):-    
  w2i(Ws,Id).

cw2is(CW,Is):-findall(I,cw2i(CW,I),Is).

cws2iss(CWs,Iss):-map(cw2is,CWs,Iss).

/* BUGS: 
   - past tense verbs are shadowed by adjectives ??
   - irregular forms are not handled ??
   - anaphoric constructs like pronoums are ignored or sometime confused
*/

defaultHBDR(all,8,3,gen). % Quantifier, Breath, Depth, Relation

% TODO: reverse cover relation: compute total coverage
% of ontology - using sets

covered_def(CWs,Ks-Xs):-
  defaultHBDR(H,B,D,R),
  o2issts(CWs,Iss,Ts),
  defs(Ks,Dss),member(Xs,Dss),
  rcovers(H,B,D,R,Iss,Ts,Xs).

covered_exs(CWs,Ks-Xs):-
  defaultHBDR(H,B,D,R),
  o2issts(CWs,Iss,Ts),
  exs(Ks,Ess),member(Xs,Ess),
  rcovers(H,B,D,R,Iss,Ts,Xs).

covers_file(File,CWs,Xs):-
  defaultHBDR(H,B,D,R),
  covers_file(File,H,B,D,R,CWs,Xs).

covers_file(File,H,B,D,R,CWs,Xs):-
  o2issts(CWs,Iss,Ts),
  ( Iss=[]->println(empty_ontology_for(CWs)),fail
  ; map(length,Iss,Ls),println(size_of_ontology(Ls))
  ),
  sentence_of(File,Xs),
  rcovers(H,B,D,R,Iss,Ts,Xs).

o2issts(CWs,Iss,Ts):-
  cws2iss(CWs,Iss),
  findall(T,get_otype(Iss,T),UTs),
  sort(UTs,Ts),
  println(Iss=>Ts).
  
% Ex: Ontology=[noun:[man],verb:[tell]]

ocovers(How,Breadth,Depth,Rel,Ontology,Sentence):-
  o2issts(Ontology,ToIss,Ts),
  rcovers(How,Breadth,Depth,Rel,ToIss,Ts,Sentence).
       
rcovers(How,Breadth,Depth,Rel,ToIss,Ts,Xs):-
  tokens2synsets(Breadth,Xs,FromIss0,_Wss),
  map(ofilter(Ts),FromIss0,FromIss),
  rcovers_how(How,Depth,Rel,FromIss,ToIss).

get_otype(ToIss,T):-
  member(Is,ToIss),
  member(I,Is),
  i2wtn(I,_,T,_).

ofilter(Ts,FromIs0,FromIs):-
  findall(I,ofilter_one(Ts,FromIs0,I),FromIs).

ofilter_one(Ts,FromIs0,J):-
  member(J,FromIs0),
  i2wtn(J,_,T,_),
  member(T,Ts).
  
rcovers_how(all,Depth,Rel,FromIss,ToIss):- !,
  rcovers_all(Depth,Rel,FromIss,ToIss).
rcovers_how(some,Depth,Rel,FromIss,ToIss):-
  rcovers_some(Depth,Rel,FromIss,ToIss).

rcovers_some(Depth,Rel,FromIss,ToIss):-  
  member(FromIs,FromIss),
  tc(Rel,any,Depth,FromIs,=<(0),To),
  member(ToIs,ToIss),
  member(To,ToIs),
  !.
  
rcovers_all(Depth,Rel,FromIss,ToIss):-
  forAll(
    member(ToIs,ToIss),
    rcovers_one(Depth,Rel,FromIss,ToIs)
  ).

rcovers_one(Depth,Rel,FromIss,ToIs):-  
  member(FromIs,FromIss),
  tc(Rel,any,Depth,FromIs,<(0),To),
  member(To,ToIs),
  !.
  
ltrace(N,Line):-
  name(S,Line),println(input=S),
  for(K,0,N),
    lift_line(Line,K,IsWs,NIsNWs),
    show_line_at(K,IsWs,NIsNWs),
  fail
; nl.  

show_line_at(K,IsWs,NIsNWs):-
    ( K=:=0->show_first_line(IsWs)
    ; true
    ),
    nl,
    println(level=K),
    show_line(NIsNWs).

show_first_line(Iss-Wss):-
  foreach(member(Is,Iss),println(Is)),
  member(Ws,Wss),
    tab(2),
    println(Ws),
  fail
; nl.

show_line(Iss-Wss):-
  foreach(member(Is,Iss),println(Is)),
  member(Ws,Wss),
    tab(2),
    trim_phrases(Ws,NewWs),
    println(NewWs),
  fail
; nl.
  
trim_phrases([],[]).
trim_phrases([P|Ps],[P|Trimmed]):-
  findall(T,(member(T,Ps),P\==T),Ts),
  trim_phrases(Ts,Trimmed).
  
         
explore(File,Min,Max,Rel,Cond):-
  explore_file(File,Rel,Cond,Max,<(Min),Sentence,A,B),
  println(Sentence),
  show_line(A),
  % B=[_|_]-_,
  println(level=Max),show_line(B),
  fail
; true.  
  
explore_file(F,Rel,Cond,K,N,Words,WsIs,NewIdNewWs):-
  sentence_of(F,Words),
  explore_sentence(Words,Rel,Cond,K,N,WsIs,NewIdNewWs).

sub_of(W,Ws):-sub_of(W,1,Ws).

sub_of(W,K,Ws):-subs_of([W],K,Wss),member(Ws,Wss).

subs_of(Ws,K,Wss):-
  lift_sentence(Ws,rhyp,any,K,_,_-Wsss),
  member(Wss,Wsss).

coord_of(W,Wss):-
  lift_word(W,xcoord,any,1,Wsss),
  member(Wss,Wsss).
  
super_of(W,Wss):-
  lift_word(W,1,[Wss|_]).

lift_word(W,K,Wsss):-
  lift_word(W,gen,any,K,Wsss).

lift_word(W,Rel,K,Wsss):-
  lift_word(W,Rel,any,K,Wsss).

% Wsss because it lifts sentences - each word gives[[..]..]  
lift_word(W,Rel,Cond,K,Wsss):-
  lift_sentence([W],Rel,Cond,K,_,_-Wsss).    

lift_line(Line,Level,IsWs,IssWsss):-
  codes_words(Line,Ws),
  lift_sentence(Ws,Level,IsWs,IssWsss).


lift_words(Ws,Rel,K,Wss):-
  lift_sentence(Ws,Rel,any,K,_,_-Wsss),
  member(Wss,Wsss).    

lift_sentence(Ws,Level,Iss-Wsss):-
  lift_sentence(Ws,Level,_,Iss-Wsss).

lift_sentence(Ws,Level,IsWs,Iss-Wsss):-
  lift_sentence(Ws,gen,any,Level,IsWs,Iss-Wsss).
  
lift_sentence(Ws,Rel,Cond,Level,IsWs,IssWss):-
  explore_sentence(Ws,Rel,Cond,Level,=(Level),IsWs,IssWss).
  

% only adjs seem to have synonyms in Wordnet

adjsyn(W,S):-adjsyn(W,1,S).

adjsyn(W,Level,Wsss):-lift_word(W,sim,adj,Level,Wsss).

best_for(Ws,Bs):-
  is_about(_,T,Ws,T,Bs,I,I),
  \+(is_about(_,T,Bs,_,_,_,I)).

is_about(Ws,Es):-
  is_about(_DefEx,_TW,Ws,_TE,Es,_I,_J).

is_about(DefEx,TW,Ws,TE,Es,I,J):-
  w2itn(Ws,I,TW,_),
  expl_of(I,Xs,DefEx),
  proper_sublist_of(Xs,Es),
  content_only(Es),
  Es\==Ws,
  w2itn(Es,J,TE,_).

to_content(Ws,Cs):-nonvar(Ws),findall(C,filter_content(Ws,C),Cs).

filter_content(Ws,W):-
  member(W,Ws),
  content_only([W]).
  
content_only([W|_]):-function_word(W),!,fail.
content_only([W|_]):-exception_word(W),!,fail.
content_only([W|_]):-kw(W,_),!,fail.
content_only([_|_]).  

anagram_of(W,A):-anagrams_of(W,As),member(A,As).

anagrams_of(W,As):-findall(A,anagram_of0(W,A),Bs),sort(Bs,As).

anagram_of0(W,A):-
  atom(W),
  name(W,Ws0),
  (Ws=Ws0;to_upper_first_char(Ws0,Ws)),
  perm(Ws,As),
  As\==Ws,As\==Ws0,
  name(A,As),
  variant2word([A],_,_,_).

perm([],[]).
perm([X|Xs],Ps):-
  perm(Xs,Ys),
  ins(X,Ys,Ps).
  
ins(X,Xs,[X|Xs]).
ins(X,[Y|Xs],[Y|Ys]):-ins(X,Xs,Ys).
