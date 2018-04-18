:-[world_server].

%main:-sandbox,trust.

sim(Word):-explore(sim,Word).

ant(Word):-explore(ant,Word).

hyp(Word):-explore(hyp,Word).

ent(Word):-explore(ent,Word).

cs(Word):-explore(cs,Word).

mero(Word):-explore(mero,Word).

% binary realtions

sim_(Word,R):-explore(sim,Word,R).

wan_(Word,R):-explore(ant,Word,R).

hyp_(Word,R):-explore(hyp,Word,R).

ent_(Word,R):-explore(ent,Word,R).

cs_(Word,R):-explore(cs,Word,R).

mero_(Word,R):-explore(mero,Word,R).


% kernel

explore(Rel,Word,NewWord-Sense):-explore(Rel,Word,NewWord,Sense).

explore(Rel,Word,NewWord,Sense):-explore(2,Rel,Word,NewWord,Sense).

explore(K,Rel,Word,NewWord,Sense):-
  w2id(Word,Id),
  for(I,0,K),
  tc(I,Rel,Id),
  assumed(on_path(Rel,NewId)),
  id2w(NewId,NewWord),
  id2s(NewId,Sense).

explore(Rel,Word):-
  forall(
    explore(Rel,Word,NewWord,Sense),
    println(NewWord-Sense)
  ).

tc(0,Rel,Last):- add_to_path(Rel,Last).
tc(N,Rel,From):-
  N>0,N1 is N-1,
  add_to_path(Rel,From),
  call(Rel,From,To),
  tc(N1,Rel,To).

add_to_path(Rel,This):- \+ assumed(on_path(Rel,This)), assumei(on_path(Rel,This)).

w2id(Word,Id):-
  w(Word,Ids),
  member(Id,Ids).

id2w(Id,Word):-
  s(Id,_w_num,Word,_ss_type,_sense_number,_tag_state).

id2s(Id,Sense):-gp(Id,Sense).

ant(Id,AntId):-ant(Id,W_num,AntId,W_num).

means(Word,Sense):-
  w(Word,Ids),
  member(Synset_id,Ids),
  gp(Synset_id,Sense).

mero(From,To):-mm(From,To);ms(From,To);mp(From,To).

% unused

slow_means(Word,Sense):-
  s(Synset_id,_w_num,Word,_ss_type,_sense_number,_tag_state),
  g(Synset_id,Sense).

% builds a database attaching to each word a list of Sysset_ids related to each
% this allows building programs which react to words in O(1) time

% begin w.pl -> w/2 builder

gen_senses:-
  tell('w.pl'),
  by_word(X,Xs),
  (integer(X)->to_string(X,W);X=W),
  writeq(w(W,Xs)),write('.'),nl,
  fail
; told.

by_word(Word,Synset_ids):-
  setof(Synset_id,word_sense(Word,Synset_id),Synset_ids).
  
word_sense(Word,Synset_id):-
  s(Synset_id,_w_num,Word,_ss_type,_sense_number,_tag_state).


% builds optimized gp.pl file with preparsed NL glosses

gen_parsed:-
  println(assumes_read('g.pl')),
  tell('gp.pl'),
  g(X,UnParsed),
  split_sense(UnParsed,Parsed),
  writeq(gp(X,Parsed)),write('.'),nl,
  fail
; told.

split_sense(Const,Ms):-
  [L,R]="()",
  atom_codes(Const,LCsR),
  once(append([L|Cs],[R],LCsR)),
  codes_words(Cs,Ws),
  split_words(Ws,Ms),
  !.
split_sense(Const,[unsplit(Const)]).

split_words(Ws,Ms):-
  #<Ws,
  splitter(Ms),
  #>[].

splitter(Ns):-split_more(Ms),map(def_or_ex,Ms,Ns).

split_more([M|Ms]):-
  match_before([(;)],M,_),
  !,
  split_more(Ms).
split_more([Ms]):-
  #>Ms,
  #<[].

def_or_ex(Ms,ex(Ns)):- #<Ms,#'"',match_before(['"'],Ns,_),#>[],!.
def_or_ex(Ms,def(Ms)).

% end builder

/*
--------------------------- begin NEW; added by BinNet --------------------------
% preparsed variant of g/2
The gp operator specifies the gloss for a synset as a list of examples (ex([...])) or definitions def([...])
each split in individual words, ready for NL processing.

gp(synset_id,[def([...]),...ex([..]),...])).

w(word,synset_id).

--------------------------- end NEW; added by BinNet --------------------------

s(synset_id,w_num,'word',ss_type,sense_number,tag_state).

    A s operator is present for every word sense in WordNet. In wn_s.pl , w_num specifies the word number for
    word in the synset. 

% might be repalced with gp/2 - containing pre-parsed glosses
g(synset_id,'(gloss)').

    The g operator specifies the gloss for a synset. 

hyp(synset_id,synset_id). 

    The hyp operator specifies that the second synset is a hypernym of the first synset. This relation holds for nouns
    and verbs. The reflexive operator, hyponym, implies that the first synset is a hyponym of the second synset. 

ent(synset_id,synset_id).

    The ent operator specifies that the second synset is an entailment of first synset. This relation only holds for
    verbs. 

sim(synset_id,synset_id).

    The sim operator specifies that the second synset is similar in meaning to the first synset. This means that the
    second synset is a satellite the first synset, which is the cluster head. This relation only holds for adjective
    synsets contained in adjective clusters. 

mm(synset_id,synset_id).

    The mm operator specifies that the second synset is a member meronym of the first synset. This relation only
    holds for nouns. The reflexive operator, member holonym, can be implied. 

ms(synset_id,synset_id). 

    The ms operator specifies that the second synset is a substance meronym of the first synset. This relation only
    holds for nouns. The reflexive operator, substance holonym, can be implied. 

mp(synset_id,synset_id). 

    The mp operator specifies that the second synset is a part meronym of the first synset. This relation only holds for
    nouns. The reflexive operator, part holonym, can be implied. 

cs(synset_id,synset_id). 

    The cs operator specifies that the second synset is a cause of the first synset. This relation only holds for verbs. 

vgp(synset_id,synset_id). 

    The vgp operator specifies verb synsets that are similar in meaning and should be grouped together when
    displayed in response to a grouped synset search. 

at(synset_id,synset_id). 

    The at operator defines the attribute relation between noun and adjective synset pairs in which the adjective is a
    value of the noun. For each pair, both relations are listed (ie. each synset_id is both a source and target). 

ant(synset_id,w_num,synset_id,w_num).

    The ant operator specifies antonymous word s. This is a lexical relation that holds for all syntactic categories.
    For each antonymous pair, both relations are listed (ie. each synset_id,w_num pair is both a source and target
    word.) 

sa(synset_id,w_num,synset_id,w_num).

    The sa operator specifies that additional information about the first word can be obtained by seeing the second
    word. This operator is only defined for verbs and adjectives. There is no reflexive relation (ie. it cannot be
    inferred that the additional information about the second word can be obtained from the first word). 

ppl(synset_id,w_num,synset_id,w_num).

    The ppl operator specifies that the adjective first word is a participle of the verb second word. The reflexive
    operator can be implied. 

per(synset_id,w_num,synset_id,w_num). 

    The per operator specifies two different relations based on the parts of speech involved. If the first word is in an
    adjective synset, that word pertains to either the noun or adjective second word. If the first word is in an adverb
    synset, that word is derived from the adjective second word. 

fr(synset_id,f_num,w_num).

    The fr operator specifies a generic sentence frame for one or all words in a synset. The operator is defined only
    for verbs. 

*/
