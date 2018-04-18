wn_orig(FN):-
  member(FN,
    [hyp/2,fr/3,cs/2,ent/2,at/2,per/4,
     ppl/4,sa/4,sim/2,vgp/4,mm/2,mp/2,ms/2,ant/4,der/4,cls/3]
  ).

wn_reverse(FN):-
  member(FN,
    [hyp/2,cs/2,ent/2,mm/2,mp/2,ms/2,cls/3]
  ).

wn_spec(FN):-member(FN,[s/6,g/2]).

wn_basic(F/2):-
  member(F,[
  
    /* xw.pl */
    
    w, % words to synsets
       %      I                       WN       WS         T         IN         C
    i, % synset_id to word frames f(w_num,[word phrase],ss_type,sense_number,tag_count)
    l, % sysnset to links
    g, % synset to definitions and examples
  
    /* xd.pl*/
    
    r, % reversed links
 
    e, % exception variant word to synset
       
    t, % toplevel noun or verb
    
    k, % known words in definitions with occurence counts
    n  % new words in definitions with occurence counts
]).

/*
sense_number  specifies the sense number of the word,
within the part of speech encoded in the synset_id, 
in  the WordNet database.

w_num , if present, indicates which word in the synset is being referred to.
Word numbers are assigned to the word  fields in a synset, from left to right,
beginning with 1. When used to represent lexical WordNet relations w_num  may be 0,
indicating that the relation holds for all words in the synset indicated
by the preceding synset_id.
*/

% Functional dependencies
% <Ws,T,IN>-->I
% <Ws,T,IN>-->WN
% <I,WN>--><Ws,T,IN>

% vertex: [Ws]->(T,IN)->[I,WN]->(lex)->[I]

xs(I,WN,Ws,T,IN,C):-var(Ws),!,i(I,Fs),member(f(WN,Ws,T,IN,C),Fs).
xs(I,WN,[W|Ws],T,IN,C):-wi(W,I),i(I,Fs),member(f(WN,[W|Ws],T,IN,C),Fs).

wn_rel(xeq).
wn_rel(F):-wn_orig(F/2).
wn_rel(F):-wn_reverse(F0/2),namecat(r,'',F0,F).
wn_rel(ant).

ant(Id,AntId):-ant(Id,_,AntId,_).
per(Id,NewId):-per(Id,_,NewId,_).
ppl(Id,NewId):-ppl(Id,_,NewId,_).
vgp(Id,NewId):-vgp(Id,_,NewId,_).
sa(Id,NewId):-sa(Id,_,NewId,_).
cls(Id,NewId):-cls(Id,NewId,_).
der(Id,NewId):-der(Id,_,NewId,_).

w_ant(Ws,Us):-w2itn(Ws,I,T,IN),ant(I,IN,J,JN),i2wtn(J,Us,T,JN).
w_antx(Ws,Us):-w2itn(Ws,I,T,_),ant(I,_,J,_),i2wtn(J,Us,T,_).
w_per(Ws,Us):-w2itn(Ws,I,_,IN),per(I,IN,J,JN),i2wtn(J,Us,_,JN).
w_ppl(Ws,Us):-w2itn(Ws,I,_,IN),ppl(I,IN,J,JN),i2wtn(J,Us,_,JN).
w_vgp(Ws,Us):-w2itn(Ws,I,_,IN),vgp(I,IN,J,JN),i2wtn(J,Us,_,JN).
w_sa(Ws,Us):-w2itn(Ws,I,_,IN),sa(I,IN,J,JN),i2wtn(J,Us,_,JN).
w_der(Ws,Us):-w2itn(Ws,I,_,IN),der(I,IN,J,JN),i2wtn(J,Us,_,JN).
w_cls(Ws,Us,D):-w2itn(Ws,I,T,_),cls(I,J,D),i2wtn(J,Us,T,_).

mero(From,To):-mm(From,To).
mero(From,To):-ms(From,To).
mero(From,To):-mp(From,To).

rmero(From,To):-rmm(From,To).
rmero(From,To):-rms(From,To).
rmero(From,To):-rmp(From,To).

xeq(Id,Id):-i(Id,_).
xdif(I,J):-I=\=J.
xfail(_,_):-fail.
xtrue(_,_).
xnone(_):-fail.
any(_).


related(I,S):-hyp(I,S).
related(I,M):-der(I,M).
related(I,M):-cls(I,M).

partwise(I,M):-mp(I,M).
partwise(I,M):-rmp(I,M).

% related(I,S):-coord(I,S).
% related(I,S):-ccoord(I,S).
% related(I,S):-rhyp(I,S).
% related(I,M):-rcls(I,M).
 
gen(Id,Super):-fr_type(Id,Type),best_super(Type,Id,Super).

best_super(noun,I,S):-nsuper(I,S).
best_super(verb,I,S):-vsuper(I,S).
% best_super(adverb,I,S):-perathyp(I,S). % too costly
% best_super(adjective,I,S):-asuper(I,S). % problems with opposites
% best_super(adjective_satellite,I,S):-simathyp(I,S).

nsuper(I,S):-hyp(I,S).
%nsuper(I,S):-mp(I,S).

vsuper(I,S):-hyp(I,S).
vsuper(I,S):-enthyp(I,S).
vsuper(I,S):-cshyp(I,S).
vsuper(I,S):-vgphyp(I,S).
vsuper(I,S):-derhyp(I,S).
% vsuper(I,S):-sahyp(I,S). % lexical

asuper(I,S):-athyp(I,S),\+(opposite_covering_super(I,S)).
% asuper(I,S):-sahyp(I,S). % lexical

athyp(A,AH):-at(A,N),hyp(N,NH),at(NH,AH).
simathyp(A,AH):-sim(A,N),athyp(N,AH).
vgphyp(A,AH):-vgp(A,N),hyp(N,NH),vgp(NH,AH),A\==AH.
enthyp(A,AH):-ent(A,N),hyp(N,AH),A\==AH.
cshyp(A,AH):-cs(A,N),hyp(N,AH).
derhyp(A,AH):-der(A,N),hyp(N,NH),der(NH,AH),A\==AH.

% perathyp(A,NA):-per(A,N),athyp(N,NH),per(NA,NH),A\==NA. % lexical
% sahyp(A,AH):-sa(A,N),hyp(N,AH). % lexical

opposite_covering_super(A,H):-ant(A,O),athyp(O,H).

word2list(W,Ws):-word2words(W,Wss),appendN(Wss,Xs),!,Ws=Xs.

word2words(W,Wss):-
  name(W,Cs),[U]="_",
  split_more(U,Xs,Cs,[]),
  map(codes_words,Xs,Wss).

split_more(Splitter,[M|Ms])-->
  match_before(Splitter,M),
  !,
  split_more(Splitter,Ms).
split_more(_splitter,[Ms],Ms,[]).
    
split_sense(Const,Ms):-
  atom_codes(Const,Cs),
  codes_words(Cs,Ws),
  trim_pars(Ws,Ps),
  split_words(Ps,Ms),
  !.
split_sense(Const,[unsplit(Const)]).

split_words(Ws,Ys):-
  split_more((';'),Mss,Ws,[]),
  findall(Y,split_def_or_ex(Mss,Y),Ys).

split_def_or_ex(Mss,Ts):-
 member(Ms,Mss),
 def_or_ex(Ts,Ms,[]).

trim_pars(Ms,Ls):-
 trim_first_par(Ms,Fs),
 trim_last_par(Fs,Ls).
 
trim_first_par(['('|Xs],Xs):-!.
trim_first_par(Xs,Xs).

trim_last_par(Xs,Ys):-append(Zs,[')'],Xs),!,Ys=Zs.
trim_last_par(Xs,Xs).

def_or_ex(ex(N))-->['"'],match_before('"',N),!.
def_or_ex(def(Ms),Ms,[]).

ss_type(n,noun,noun).
ss_type(v,verb,verb).
ss_type(a,adjective,adj).
ss_type(s,adjective_satellite,adj).
ss_type(r,adverb,adv).

ss_type(N,Long):-ss_type(N,Long,_).


/* dynamic relation combiner */

combine((F,G),X,Y):-!,combine(F,X,Y),combine(G,X,Y).
combine((F;G),X,Y):-!,combine(F,X,Y);combine(G,X,Y).
combine(not(F),X,Y):-!,\+combine(F,X,Y).
combine((F:G),X,Z):-!,combine(F,X,Y),combine(G,Y,Z).
combine(F,X,Y):-call(F,X,Y).

/* advanced combined relations */

xlinked(I,J):-linked(I,J),\+colex(I,J).

linked(I,J):-llinked(I,J).
linked(I,J):-rlinked(I,J).

llinked(I,J):-l(I,Cs),member(T,Cs),functor(T,_,N),llinked1(N,T,J).
rlinked(I,J):-r(I,Cs),member(T,Cs),arg(1,T,Xs),member(X,Xs),
  rlinked1(X,J).

rlinked1(X,J):-integer(X),!,J=X.
rlinked1([X,_],X).

llinked1(1,T,J):-arg(1,T,J).
llinked1(3,T,J):-arg(2,T,J).

colex(I,J):-i2wtn(I,Ws,T,N),w2itn(Ws,J,T,N),I=\=J.

xcoord(I,J):-coord(I,J),ccoord_check(I,J), \+(colex(I,J)).

coord(I,S):-hyp(I,H),rhyp(H,S),S=\=I.

ccoord_check(I,_):- \+cls(I,_,_),!.
ccoord_check(I,S):-ccoord(I,S). 

ccoord(I,S):-cls(I,H,D),rcls(H,S,D),S=\=I.

% given a Functor Fun (which can be the identity xtrue/2
% and a list of source words SWs and target words TWs
% generate a "metaphor" consisting ina comparison between
% MWs and NWs
metaphor(Fun,SWs,TWs,MWs,NWs):-
   % picks several WordNet relations
   % and their reverses to be used as
   % morphisms in the metaphor generator
   member(Rel-RevRel,
   [hyp-rhyp,
    mm-rmm,
    ms-rms,
    mp-rmp,
    cs-rcs,
    ent-rent %,cls-rcls
   ]),
   metaphor(Fun,Rel,RevRel,SWs,TWs,MWs,NWs).

% mapps metaphor generation from word phrases to synsets lists  
metaphor(Fun,Rel,RevRel,SWs,TWs,MWs,NWs):-
  w2itn(SWs,S,Cat,_),
  imetaphor(Fun,Rel,RevRel,S,T,M,N),
  i2wtn(T,TWs,Cat,_),
  i2wtn(M,MWs,MCat,_),
  i2wtn(N,NWs,MCat,_),
  all_distinct([SWs,TWs,MWs,NWs]).

% default metaphore using identity Functor
metaphor(SWs,TWs,Ws):-
  metaphor(xtrue,SWs,TWs,Ws).

% generates a metaphor as a list of "human readable" output words
metaphor(Fun,SWs,TWs,Ws):-
  metaphor(Fun,SWs,TWs,MWs,NWs),
  m2ws(SWs,TWs,MWs,NWs,Ws).

% generates a metaphor by trying direct and reverse morphisms
% (WordNet relations)
imetaphor(Functor,Rel,RevRel,Source,Target,SourceMeta,TargetMeta):-
  imetaphor0(Functor,Rel,RevRel,Source,Target,SourceMeta,TargetMeta).
imetaphor(Functor,Rel,RevRel,Source,Target,SourceMeta,TargetMeta):-
  imetaphor0(Functor,RevRel,Rel,Source,Target,SourceMeta,TargetMeta).

% generates a metaphor as a commutative diagram of synsets and morphisms
imetaphor0(Functor,Rel,RevRel,Source,Target,SourceMeta,TargetMeta):-
   call(Functor,Source,Target),
   call(Rel,Source,SourceMeta),
   call(Functor,SourceMeta,TargetMeta),
   call(RevRel,TargetMeta,Target),
   all_different([Source,Target,SourceMeta,TargetMeta]).

% ensures synsets are not repeated
all_different(Is):-sort(Is,Js),length(Is,L1),length(Js,L2),L1=:=L2.

% insures no common words are used in left and right side of a metaphor
% that avoids some trivial comparisons
all_distinct(Iss):-
  appendN(Iss,Is),sort(Is,Js),
  length(Is,L1),length(Js,L2),L1=:=L2.

% converts a metaphore to a human readable form
% ready to be part of a conversation  
m2ws(SWs,TWs,MWs,NWs,Ws):-
  appendN([SWs,[is,to],MWs,[as],TWs,[is,to],NWs],Ws).

mtest:-
  mtest(flower,girl).
  
mtest(W,V):-
   SWs=[W],
   TWs=[V],
   metaphor(xtrue,SWs,TWs,Ws),
   println(Ws),
   fail.
mtest(_,_).
   
     
