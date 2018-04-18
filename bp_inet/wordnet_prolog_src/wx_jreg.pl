% :-[wx_orig]. % included as wx_orig.jc
:-[wx_meta].
:-[wx_lib].
%:-[wx_r].

/**
  !!! flawed: attributes need multiple values - loses
  info upon generation of jve.jc
*/

wordnet_file('/paul/wordnet/wruntime/jve.pl').
wordnet_jfile('/paul/wordnet/wruntime/jve.jc').

exc_dir('/paul/wordnet/exc/').

/*
   uses a prebuilt wruntime sytem to generate
   one file per synset
*/

go:-build_all.

build_all:-build_file.

/*
  builds ve.pl
*/   
build_file:-
  wordnet_file(File),
  ttyprint(building(File)),
  ctime(T1),
  tell(File),
  foreach(
    run_synset2line(GPGoal), 
    process_fact(GPGoal)
  ),
  told,
  ctime(T2),
  ctime(T3),
  T12 is T2-T1,
  T23 is T3-T2,
  T is T12+T23,
  println(finished_building(File)),
  println(time(x=T12,w=T23,total=T)).

% very slow
load_cat(G):-
  wordnet_jfile(JFile),
  file2object(JFile,G),
  invoke_java_method(G,size,Size),
  println(Size).
  
process_file:-
  wordnet_file(File),
  wordnet_jfile(JFile),
  ttyprint(processing(File,JFile)),
  ctime(T1),
  Size is 1<<20,new_cat(Size,G),
  jprocess_fact(G,v(0,'ROOT',true)),
  foreach(
    term_of(File,GPGoal), 
    jprocess_fact(G,GPGoal)
  ),
  ctime(T2),
  T12 is T2-T1,
  println(time_creating_memory_image(T12)),
  println(creating_java_graph(JFile)),
  object2file(G,JFile),
  delete_java_object(G),
  ctime(T3),
  T23 is T3-T2,
  T is T12+T23,
  println(finished_processing(File)),
  println(time(x=T12,w=T23,total=T)).
  
process_fact(F):-bp_sleep(10000),pp_fact(F),fail.

jprocess_fact(G,F):-jprocess_fact0(G,F),jtrace(20000,G,F).

jprocess_fact0(G,v(V,X,A)):-!,
  set_prop(G,V,X,A).
jprocess_fact0(G,e(F,T,X,A)):-!,
  set_morphism(G,F,T,X,A).
jprocess_fact0(_G,Other):-
  ttyprint(unexpected_fact=Other).

bp_sleep(_):-is_prolog(X),X\==binprolog,!.
bp_sleep(Tick):-gensym_no(sleep_time,N),N mod Tick=\=0,!.
bp_sleep(_):-sleep(1).

jtrace(Tick,G,F):-gensym_no(jtrace,N),N mod Tick=:=0,!,
  % stat,
  arg(1,F,X),
  get_ordinal(G,X,O),
  size_of(G,S),
  ttyprint([ordinal_of(X)=O,step=N,size=S]:F),
  sleep(1).
jtrace(_,_,_).
      
            
/*
  builds v/2 - associating vertex information for each synset
*/ 

run_synset2line(G):-synset2line(G). %,ranskip(G).

ranskip(v(I,_X,_A)):-high_rk(I).
ranskip(e(I,J,_X,_A)):-high_rk(I),high_rk(J).

high_rk(I):-integer(I),!,good_rk(I).
high_rk(I/_):-integer(I),!,good_rk(I).
high_rk(FWs):-functor(FWs,ws,_),!.
high_rk(_):-fail. %ttyprint(unexpected_data_in_high_rk(X)),fail. 

good_rk(I):-rk(I,R),R>5.

% BEGIN building v/3 and e/4

synset2line(V):-  
  init_ss(V).
synset2line(GPGoal):-
  get_ss(GPGoal).
synset2line(e(N,M,xlink,Terms)):-
  get_frame_element(I,J,Terms),
  newx(I,N),newx(J,M).
synset2line(e(Vx,Wx,exc,T)):-
  exc_edge(Vx,Wx,T).
synset2line(e(NI,FAB,fr,F)):-
  get_fr(I,FAB,F),
  newx(I,NI). 
synset2line(v(NI,F,Wx)):-
  get_gp(I,Terms,F),
  newx(I,NI),
  add_ws(Terms,F,Wx).
synset2line(G):-
  get_ws(FWs,D,Wx),
  process_ws(D,FWs,Wx,G).

process_ws(wn,FWs,Wx,v(Wx,wn,FWs)).
process_ws(exc,FWs,Wx,v(Wx,exc,FWs)).
process_ws(xn,X/N,XN,v(XN,xn,X/N)).
process_ws(def,FWs,Wx,v(Wx,def,FWs)).
process_ws(ex,FWs,Wx,v(Wx,ex,FWs)).
            
init_ss(v(I,synset,Id)):- 
  s(Id,_W_num,_FWs,_Ss_type,_Sense_number,_TagCount),
  newi(Id,I).
  
get_ss(G):-
  lasti(LI),
  ttyprint(lasti=LI), 
  ss(Id,W_num,FWs,Ss_type,Sense_number,TagCount),
  newi(Id,I),  
  add_ws(FWs,wn,Wx),
  add_ws(I/W_num,xn,XN),
  ( G=e(Wx,XN,Sense_number,Ss_type)
  ; G=e(XN,I,lex,true)
  ; G=e(XN,Wx,ws,true)
  ; G=v(XN,cat,Ss_type)
  ; G=v(XN,sn,Sense_number)
  ; G=v(XN,freq,TagCount)
  ).

% END building v/3 and e/4

add_ws(FWs,D,N):-ws2num(FWs,D,_,N).

get_ws(FWs,D,N):-get_ws0(FWs,D,N).

get_ws0(Ws,D,N):-var(Ws),!,gen_k(K),ws2num1(K,Ws,D,old,N).
get_ws0(Ws,D,N):-ws2num(Ws,D,old,N).

ws2num(Ws,D,IsNew,WN):-term_hash(Ws,K),ws2num1(K,Ws,D,IsNew,WN).

ws2num1(K,Ws,D,old,N):-db_asserted(K,entry(Ws,D,N)),!.
ws2num1(K,Ws,D,new,N):-add_k(K),gensym_no(wx,N0),lasti(L),N is L+N0,db_assert(K,entry(Ws,D,N)).

add_k(K):-def(k,K,yes),!,assert(db_k(K)).
add_k(_).

gen_k(K):-asserted(db_k(K)).

exc_edge(Vx,Wx,T):-
  member(Type,[adj,adv,noun,verb]),
  ss_type(T,_Long,Type),
  exc_dir(Dir),
  namecat(Dir,Type,'.exc',File),
  token_pair_of(File,Vs,Ws),
  FWs=..[ws|Ws],
  get_ws0(FWs,wn,Wx),
  FVs=..[ws|Vs],
  add_ws(FVs,exc,Vx).
      
get_gp(I,FWs,F):-
  gp(I,DefAndExs),
  member(DE,DefAndExs),
  DE=..[F,Ws],
  FWs=..[ws|Ws].
  
get_fr(I,fr(A,B),fr):-
  fr(I,A,B).
  
get_frame_element(I,J,F):-
  wn_orig(F/2),
  functor(Pred,F,2),arg(1,Pred,I),arg(2,Pred,J),
  Pred.
get_frame_element(IN,JM,F):-
  wn_orig(F/4),
  Pred=..[F,I,N,J,M],
  Pred,
  get_ws(I/N,_,IN),
  get_ws(J/M,_,JM).
get_frame_element(I,J,cls(D)):-
  cls(I,J,D).
    
ss(Id,W_num,FWs,Ss_type,Sense_number,Tag_state):-
  s(Id,W_num,OneWord,Ss_type,Sense_number,Tag_state),
  word2list(OneWord,Words),
  FWs=..[ws|Words].
 
% builds optimized gp/2 with preparsed NL glosses

gp(X,Parsed):-
  g(X,UnParsed),
  split_sense(UnParsed,Parsed).

newx(I/A,NI/A):-!,newi(I,NI).
newx(I,NI):-newi(I,NI).

newi(I,_):- badi(I),!,ttyprint(unexpected_data_in_newi(I)),fail. 
newi(I,N):-val(I,'$map',R),!,N is R.
newi(I,N):-get_newi(R),def(I,'$map',R),N is R.

has_newi(I,N):-val(I,'$map',R),!,N is R.

lasti(N):-val('$ctr','$map',N).

get_newi(N1):-val('$ctr','$map',N),!,N1 is N+1,set('$ctr','$map',N1).
get_newi(N):-N=1,def('$ctr','$map',N).

badi(I):- \+integer(I),!.
badi(I):- I<10000.

% end builder


 
token_pair_of(File,Ws1,Ws2):-
  sentence_of(File,[10,13],Cs),
  \+(member(Cs,[[10],[13]])),
  once(split_to_pair(Ts1,Ts2,Cs,[])),
  atom_codes(T1,Ts1),atom_codes(T2,Ts2),
  word2list(T1,Ws1),word2list(T2,Ws2).

split_to_pair(T1,T2)-->before(32,T1),{member(C,[10,13])},before(C,T2).

before(C0,[])-->[C0],!.
before(C0,[T|Ts])-->[T],before(C0,Ts).  


% builds old/new sysnset map

tmap:-
  consult(wx_ops_no),
  tell('/paul/wordnet/wruntime/oi.pl'),
  term_of('wn_s.pl',S),
  arg(1,S,O),
  \+(has_newi(O,_)),
  newi(O,I),
  pp_fact(oi(O,I)),
  fail.
tmap:-
  told,
  consult(wx_ops_yes).
  
