:-[wx_orig].
:-[wx_meta].
:-[wx_lib].

wordnet_file('xw.pl').

/*
   uses a prebuilt wruntime sytem to generate
   one file per synset
*/

build_all:-build_file.

/*
  builds xw.pl
*/   
build_file:-
  wordnet_file(File),
  println(starting_building(File)),
  ctime(T1),
  tell(File), 
  foreach(
    synset2line(GPGoal),  
    pp_fact(GPGoal)
  ),
  ctime(T2),
  foreach(
    word2line(WGoal),
    pp_fact(WGoal)
  ),
  told,
  ctime(T3),
  T12 is T2-T1,
  T23 is T3-T2,
  T is T12+T23,
  println(finished_building(File)),
  println(time(x=T12,w=T23,total=T)).
  
  
/*
  builds i/2,g/2,l/2 - associating a frame of information for each synset
*/ 

synset2line(GPGoal):-
  get_i(Id,Terms),
  GPGoal=..['i',Id,Terms].
synset2line(GPGoal):-
  get_gp(Id,Terms),
  GPGoal=..['g',Id,Terms].
synset2line(GPGoal):-
  get_frame(Id,Terms),
  GPGoal=..['l',Id,Terms].

get_i(Id,Fs):-
  G=ss(Id,W_num,Words,Ss_type,Sense_number,Tag_state),
  F=f(W_num,Words,Ss_type,Sense_number,Tag_state),
  findall(Id-F,G,IdFs),
  keygroup(IdFs,Id,Fs).

get_gp(SynsetID,DefAndExs):-
  gp(SynsetID,DefAndExs).

get_frame(Id,Fs):-
  findall(Id-Xs,get_frame_element(Id,Xs),IdXs),
  keygroup(IdXs,Id,Fs).
   
get_frame_element(SynsetID,FXs):-
  wn_orig(F/N),
  functor(Pred,F,N),arg(1,Pred,SynsetID),
  Pred,
  Pred=..[F,SynsetID|Xs],
  FXs=..[F|Xs].

ss(Id,W_num,Words,Ss_type,Sense_number,Tag_state):-
  s(Id,W_num,OneWord,Ss_type,Sense_number,Tag_state),
  word2list(OneWord,Words).

/*
  builds w/2: a database attaching to each word a list of Sysset_ids related to each
  this allows building programs which react to words in O(1) time
*/

word2line(w(Word,WsIs)):-
  findall(Word-(Pri/WNum-Synset_id),word_sense([Word|_Words],Synset_id,WNum,Pri),Unsorted),
  keygroup(Unsorted,Word,Us),
  sort(Us,NWIs),
  trim_keys(NWIs,WsIs).

% trim_keys(X,X).
  
trim_keys([],[]).
trim_keys([_-I|Xs],[I|Is]):- \+(member(_-I,Xs)),!,trim_keys(Xs,Is).  
trim_keys([_|Xs],Is):-trim_keys(Xs,Is).
  
word_sense(Words,Synset_id,WNum,Pri):-
  basic_word_sense(Word,Synset_id,WNum,Tag),
  word2list(Word,Words),
  Pri is 0-Tag.
 
basic_word_sense(Word,Synset_id,WNum,FreqTag):-
  s(Synset_id,WNum,Word,_ss_type,_sense_number,FreqTag).
 
% builds optimized gp/2 with preparsed NL glosses

gp(X,Parsed):-
  g(X,UnParsed),
  split_sense(UnParsed,Parsed).

% end builder

