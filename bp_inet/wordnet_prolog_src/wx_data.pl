/*
POS   Suffix   Ending
*/

function_word0('I',pronoun,1).
function_word0('you',pronoun,1).
function_word0('u',pronoun,1).
function_word0('he',pronoun,1).
function_word0('she',pronoun,1).
function_word0('her',pronoun,1).
function_word0('it',pronoun,1).
function_word0('we',pronoun,1).
function_word0('they',pronoun,1).

function_word0('me',pronoun,2).
function_word0('him',pronoun,2).
function_word0('us',pronoun,2).
function_word0('them',pronoun,2).

function_word0('my',pronoun,3).
function_word0('your',pronoun,3).
function_word0('his',pronoun,3).
function_word0('its',pronoun,3).
function_word0('our',pronoun,3).
function_word0('their',pronoun,3).

function_word0('who',pronoun,4).
function_word0('whose',pronoun,4).
function_word0('whom',pronoun,4).
function_word0('which',pronoun,4).
function_word0('when',pronoun,4).
function_word0('what',pronoun,4).
function_word0('where',pronoun,4).
function_word0('why',pronoun,4).

function_word0('this',pronoun,5).
function_word0('that',pronoun,5).
function_word0('these',pronoun,5).
function_word0('those',pronoun,5).

function_word0('a',article,1).
function_word0('an',article,1).
function_word0('the',article,2).

function_word0('at',preposition,1).
function_word0('in',preposition,1).
function_word0('on',preposition,1).
function_word0('than',preposition,1).
function_word0('as',preposition,1).
function_word0('of',preposition,1).
function_word0('with',preposition,1).
function_word0('without',preposition,1).

function_word0('and',conjunction,1).
function_word0('or',conjunction,1).
function_word0('either',conjunction,1).
function_word0('nor',conjunction,1).

function_word0('if',truthvalue,1).
function_word0('then',truthvalue,1).
function_word0('else',truthvalue,1).
function_word0('otherwise',truthvalue,1).

function_word0('yes',truthvalue,1).
function_word0('no',truthvalue,1).

function_word0('nor',conjunction,1).
fix_word(noun,  "ses",  "s").    
fix_word(noun,  "xes",  "x").   
fix_word(noun,  "zes" , "z").    
fix_word(noun,  "ches" , "ch").    
fix_word(noun,  "shes",  "sh").  
fix_word(noun,  "men",  "man").  
fix_word(noun,  "ies",  "y").
fix_word(noun,  "s","").    

fix_word(verb,  "ies",  "y").    
fix_word(verb,  "es" , "e"). 
fix_word(verb,  "es",  "").
fix_word(verb,  "s",  "").  
fix_word(verb,  "ed",  "e").   
fix_word(verb,  "ed",  "").  
fix_word(verb,  "ing",  "e").    
fix_word(verb,  "ing",  ""). 

fix_word(adjective,  "er",  "").
fix_word(adjective,  "est",  "").   
fix_word(adjective,  "er",  "e").  
fix_word(adjective,  "est",  "e").

adj(X):-fr_type(X,adjective).

noun(X):-fr_type(X,noun).

verb(X):-fr_type(X,verb).

adv(X):-fr_type(X,adverb).

sat(X):-fr_type(X,adjective_satellite).

fr_type(Id,Type):-i2t(Id,Type).

fr_type(Id,Type,Num):-i2wtn(Id,_ws,Type,Num).

fr_code(1,    'Something ----s').
fr_code(2,    'Somebody ----s').
fr_code(3,    'It is ----ing').
fr_code(4,    'Something is ----ing PP').
fr_code(5,    'Something ----s something Adjective/Noun').
fr_code(6,    'Something ----s Adjective/Noun').
fr_code(7,    'Somebody ----s Adjective').
fr_code(8,    'Somebody ----s something').
fr_code(9,    'Somebody ----s somebody').
fr_code(10,    'Something ----s somebody').
fr_code(11,    'Something ----s something').
fr_code(12,    'Something ----s to somebody').
fr_code(13,    'Somebody ----s on something').
fr_code(14,    'Somebody ----s somebody something').
fr_code(15,    'Somebody ----s something to somebody').
fr_code(16,    'Somebody ----s something from somebody').
fr_code(17,    'Somebody ----s somebody with something').
fr_code(18,    'Somebody ----s somebody of something').
fr_code(19,    'Somebody ----s something on somebody').
fr_code(20,    'Somebody ----s somebody PP').
fr_code(21,    'Somebody ----s something PP').
fr_code(22,    'Somebody ----s PP').
fr_code(23,    'Somebody''s (body part) ----s').
fr_code(24,    'Somebody ----s somebody to INFINITIVE').
fr_code(25,    'Somebody ----s somebody INFINITIVE').
fr_code(26,    'Somebody ----s that CLAUSE').
fr_code(27,    'Somebody ----s to somebody').
fr_code(28,    'Somebody ----s to INFINITIVE').
fr_code(29,    'Somebody ----s whether INFINITIVE').
fr_code(30,    'Somebody ----s somebody into V-ing something').
fr_code(31,    'Somebody ----s something with something').
fr_code(32,    'Somebody ----s INFINITIVE').
fr_code(33,    'Somebody ----s VERB-ing').
fr_code(34,    'It ----s that CLAUSE').
fr_code(35,    'Something ----s INFINITIVE').

/*
--------------------------- end NEW; added by BinNet ---------
% preparsed variant of g/2
The gp operator specifies the gloss for a synset as a list of
examples (ex([...])) or definitions def([...])
each split in individual words, ready for NL processing.

gp(synset_id,[def([...]),...ex([..]),...])).

w(word,synset_id).

--------------------------- end NEW; added by BinNet ---------

 s(synset_id,w_num,'word',ss_type,sense_number,tag_count).

    A s operator is present for every word sense in WordNet. In wn_s.pl , w_num specifies the word number for word in the synset. 

g(synset_id,'(gloss)').

    The g operator specifies the gloss for a synset. 

hyp(synset_id,synset_id).

    The hyp operator specifies that the second synset is a hypernym of the first synset. This relation holds for nouns and verbs. The reflexive operator, hyponym, implies that the first synset is a hyponym of the second synset. 

ent(synset_id,synset_id).

    The ent operator specifies that the second synset is an entailment of first synset. This relation only holds for verbs. 

sim(synset_id,synset_id).

    The sim operator specifies that the second synset is similar in meaning to the first synset. This means that the second synset is a satellite the first synset, which is the cluster head. This relation only holds for adjective synsets contained in adjective clusters. 

mm(synset_id,synset_id).

    The mm operator specifies that the second synset is a member meronym of the first synset. This relation only holds for nouns. The reflexive operator, member holonym, can be implied. 

ms(synset_id,synset_id).

    The ms operator specifies that the second synset is a substance meronym of the first synset. This relation only holds for nouns. The reflexive operator, substance holonym, can be implied. 

mp(synset_id,synset_id).

    The mp operator specifies that the second synset is a part meronym of the first synset. This relation only holds for nouns. The reflexive operator, part holonym, can be implied. 

cs(synset_id,synset_id).

    The cs operator specifies that the second synset is a cause of the first synset. This relation only holds for verbs. 

vgp(synset_id,synset_id).

    The vgp operator specifies verb synsets that are similar in meaning and should be grouped together when displayed in response to a grouped synset search. 

at(synset_id,synset_id).

    The at operator defines the attribute relation between noun and adjective synset pairs in which the adjective is a value of the noun. For each pair, both relations are listed (ie. each synset_id is both a source and target). 

ant(synset_id,w_num,synset_id,w_num).

    The ant operator specifies antonymous word s. This is a lexical relation that holds for all syntactic categories. For each antonymous pair, both relations are listed (ie. each synset_id,w_num pair is both a source and target word.) 

sa(synset_id,w_num,synset_id,w_num).

    The sa operator specifies that additional information about the first word can be obtained by seeing the second word. This operator is only defined for verbs and adjectives. There is no reflexive relation (ie. it cannot be inferred that the additional information about the second word can be obtained from the first word). 

ppl(synset_id,w_num,synset_id,w_num).

    The ppl operator specifies that the adjective first word is a participle of the verb second word. The reflexive operator can be implied. 

per(synset_id,w_num,synset_id,w_num).

    The per operator specifies two different relations based on the parts of speech involved. If the first word is in an adjective synset, that word pertains to either the noun or adjective second word. If the first word is in an adverb synset, that word is derived from the adjective second word. 

fr(synset_id,f_num,w_num).

    The fr operator specifies a generic sentence frame for one or all words in a synset. The operator is defined only for verbs. 
*/

