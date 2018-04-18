wordnet_file('/paul/wordnet/wruntime/rve.pl').
jwordnet_file('/paul/wordnet/wruntime/rve.jc').
  
to_graph:-
  wordnet_file(IF),
  term_of(IF,T),
  % println(T),
  ( T=v(V,D)->hash_put(V,v(D))
  ; T=e(V1,V2,D)->hash_put(V1,e(V2,D))   
  ),
  fail.
to_graph.
  

/*
time(9657938,graph_created)
time(25728145,graph_saved)
327M PeekMemory
*/

to_cgraph:-jwordnet_file(F),to_cgraph(F).

to_cgraph(F):-
  ctime(T0),
  wordnet_file(IF),
  new_small_cat(G),
  put_cat_data(IF,G),
  ctime(T1),show_time('graph_created',T1,T0),
  object2file(G,F),
  ctime(T2),show_time('graph_saved',T2,T1),
  cshow(F,G).

cshow:-
  jwordnet_file(F),
  file2object(F,G),
  cshow(G).
  
cshow(F,G):-  
  println(showing(F)),
  tell('show.txt'),
  show_graph(G),
  told,
  println(end).
  
to_jgraph:-to_jgraph('wg.jc').
  
to_jgraph(F):-
  ctime(T0),
  wordnet_file(IF),
  new_ranked_graph(G),
  put_all_data(IF,G),
  ctime(T1),show_time('graph_created',T1,T0),
  object2file(G,F),
  ctime(T2),show_time('graph_saved',T2,T1),
  run_page_rank(G),rank_sort(G),
  ctime(T3),show_time('page_rank_sorted',T3,T2),
  % show_graph(G),
  object2file(G,F),
  ctime(T4),show_time('ranked_graph_saved',T4,T3),
  stat.
  /*
  tell('show.txt'),
  show_jgraph(G),
  told.
  */
  
jshow:-
  file2object('wg.jc',G),
  F='show.txt',
  println(show_file=F),
  tell(F),
  show_jgraph(G),
  told.

jstat:-
  F='wg.jc',
  println(starting_jstat(F)),
  jstat('wg.jc',VN,EN,V,R,Sum,AvgRank,Time),
  println(jstat(vn=VN,en=EN,maxV=V,maxR=R,sumRanks=Sum,avgRank=AvgRank,time=Time)).
  
jstat(F,VN,EN,V,R,S,Avg,T):-
  ctime(T1),
  file2object(F,G),
  show_jgraph(G,50),
  init_gensym(v),
  foreach(vertex_of(G,V),vertex_stat(G,V)),
  gensym_no(v,VN0),
  VN is VN0-2,
  delete_java_object(G),
  ( bb_val(max_rank,r(V,R,S,EN))->bb_rm(max_rank),Avg is S/VN
  ; V=none,R=none,S=none,Avg=none,EN=none
  ),
  ctime(T2),
  T is T2-T1.
  
vertex_stat(G,V):- 
  gensym_no(v,_), 
  get_rank(G,V,R),
  out_degree(G,V,D),
  update_maxk(V,R,D).
  
update_maxk(V,R,D):-bb_val(max_rank,r(V0,R0,S0,D0)),!,
  NewS is S0+R,NewD is D0+D,
  ( R0>=R->NewR=R0,NewV=V0
  ; NewR=R,NewV=V
  ),
  bb_let(max_rank,r(NewV,NewR,NewS,NewD)).
update_maxk(V,R,D):-
  bb_def(max_rank,r(V,R,0.0,D)).

show_jgraph(G):-show_jgraph(G,0).
    
show_jgraph(G,K):-
  % invoke_java_method(G,toString,S),println(S),
  init_gensym(show_step),
  vertex_iterator(G,Vs),
  repeat,
    ( K>0,gensym_no(show_step,K0),K0>K->true
      ; has_next(Vs)->
      next(Vs,V),
      get_rank(G,V,R),
      println(V=>get_rank(R)),
      vertex_data(G,V,D),
      ( D\=='$null',
        handle2object(DH,D),
        queue_list(DH,Os),
        member(O,Os),
        tab(2),println(vertex_data=O),
        fail
      ; true
      ),
      out_iterator(G,V,Es),
      ( has_next(Es)->
        next(Es,E),
        tab(4),println(edge=E),
        edge_data(G,V,E,ED),
        ED\=='$null',
        handle2object(EDH,ED),
        queue_list(EDH,EDs),
        member(X,EDs),
        tab(6),println(edge_data=X),
        fail
      ; true  
      ),
      fail
    ; true
    ),
  !,
  println(end(K)).

to_ranked:-
  to_ranked(0,'wg.jc','wx_r.pl').
  
to_ranked(K,GF,RF):-
  file2object(GF,G),
  println(graph_loaded(GF=>RF:K)),
  init_gensym(show_step),
  vertex_iterator(G,Vs),
  tell(RF),
  [Dot]=".",
  repeat,
    ( K>0,gensym_no(show_step,K0),K0>K->true
    ; has_next(Vs)->
      next(Vs,V),
      integer(V), % only keep main sysnsets, drop X/N nodes
      get_rank(G,V,R),
      floor(R,N),
      N>2, % drop low ranked nodes
      writeq(rk(V,N)),put(Dot),nl,
      fail
    ; nl
    ),
  !,
  told.
  
show_time(Mes,T2,T1):-T is T2-T1,println(time(T,Mes)).

put_all_data(IF,G):-term_of(IF,T),put_data(T,G),show_trace(T),fail.
put_all_data(_,_).

show_trace(T):-statistics(wruntime,[_,DT]),gensym_no(zzz,N),Z is N mod 1000,Z=:=0,println(N/DT:T),sleep(1).

ranskip.
% ranskip:-random(M),X is M mod 103,X=:=0.

put_data(D,G):-ranskip,put_data0(D,G).

put_data0(v(V,D),G):-vput(G,V,D),vimplict(G,V).
put_data0(e(V1,V2,D),G):-eput(G,V1,V2,D).

vimplict(G,Synset/N):-!,eput(G,Synset/N,Synset,lex).
vimplict(_,_).

vput(G,V,D):-vertex_data(G,V,Q0),vqueue(Q0,G,V,Q),handle2object(QH,Q),queue_add(QH,D).

vqueue('$null',G,V,NewDs):-!,queue_create(Q),handle2object(Q,NewDs),add_vertex(G,V,NewDs).
vqueue(Ds,_G,_V,Ds).

eput(G,V1,V2,D):-edge_data(G,V1,V2,Q0),equeue(Q0,G,V1,V2,Q),handle2object(QH,Q),queue_add(QH,D).

equeue('$null',G,V1,V2,NewDs):-!,queue_create(Q),handle2object(Q,NewDs),add_edge(G,V1,V2,NewDs).
equeue(Ds,_G,_V,Ds).

%%%

put_cat_data(IF,G):-term_of(IF,T),put_data1(T,G),show_trace(T),fail.
put_cat_data(_,_).

put_data1(D,G):-ranskip,put_data2(D,G).

put_data2(v(V,D),G):-set_prop(G,V,D,p).
put_data2(e(V1,V2,D),G):-add_morphism(G,V1,V2,D).
