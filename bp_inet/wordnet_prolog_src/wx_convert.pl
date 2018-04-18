:-[xw].
:-[wx_top]. % generator

derive:-
  dynbbgc,
  bb_gc,
  dynbbgc,
  statistics,
  derive_to('xd.pl').
  
derive_to(O):-
  tell(O),
    foreach(
      make_reversed(R),
      pp_fact(R)
    ),
    foreach(
      uexc(VVsWs),
      pp_fact(VVsWs)
    ),
    foreach(
      % ss_type(_,T),
      member(T,[noun,verb]),
      foreach(
        top_id_words(T,Id,_),
        pp_fact(t(Id,T))
      )
    ),
    foreach(
      (known_meta_word(W,K,_),K>1),
      pp_fact(k(W,K)) 
    ),
    foreach(
      (new_meta_word(W,K,_),K>1),
      pp_fact(n(W,K))
    ),
  told.

make_reversed(GPGoal):-
  get_frame(Id,Terms),
  GPGoal=..['r',Id,Terms].
  
get_frame(Id,Rs):-
  findall(Id-R,get_frame_element(Id,R),IdRs),
  keygroup(IdRs,Id,FXs),
  findall(R,keybuild(FXs,R),Rs).

keybuild(FXs,R):-keygroup(FXs,F,Xs),functor(R,F,1),arg(1,R,Xs).
  
get_frame_element(Y,FX):-
  wn_reverse(F/2),
  Pred=..[F,X,Y],
  FX=F-X,
  Pred.
get_frame_element(Y,FX):-
  wn_reverse(F/3),
  Pred=..[F,X,Y,D],
  FX=F-[X,D],
  % FX=F-X,
  Pred.
    
exc_dir('/paul/wordnet/exc/').

uexc(VVsWs):-
  findall(V-(Vs/I),
    exc_of([V|Vs],I),
  Us),
  keygroup(Us,V,VsIs),
  VVsWs=e(V,VsIs).

exc_of(Vs,I):-
  member(Type,[adj,adv,noun,verb]),
  exc_dir(Dir),
  namecat(Dir,Type,'.exc',File),
  token_pair_of(File,Vs,Ws),
  w2itn(Ws,I,Type,_).
 
token_pair_of(File,Ws1,Ws2):-
  sentence_of(File,[10,13],Cs),
  \+(member(Cs,[[10],[13]])),
  once(split_to_pair(Ts1,Ts2,Cs,[])),
  atom_codes(T1,Ts1),atom_codes(T2,Ts2),
  word2list(T1,Ws1),word2list(T2,Ws2).

split_to_pair(T1,T2)-->before(32,T1),{member(C,[10,13])},before(C,T2).

before(C0,[])-->[C0],!.
before(C0,[T|Ts])-->[T],before(C0,Ts).  

last_predicate.
 