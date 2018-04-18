call_tg(TG,FunArgs,R):-
  invoke_java_method(TG,FunArgs,R).

new_tg(TG):-
  new_java_class('jwn.TGAdaptor',C),
  new_java_object(C,void,TG).
  
tg_add_vertex(TG,Label,Shape,R):-
  call_tg(TG,addNode(Label,Shape),R).
    
tg_add_vertex(TG,Label,R):-
  tg_add_vertex(TG,Label,0,R).

tg_add_edge(TG,From,To,R):-
  call_tg(TG,addEdge(From,To),R).

tg_show(TG):-
  call_tg(TG,showAll,_).

tg_clear(TG):-
  % call_tg(TG,clearAll,_),
  delete_java_object(TG).
   
tg_test:-
  new_tg(TG),
  tg_add_vertex(TG,root,1,R),
  ( for(I,0,5),
      namecat(v,'',I,S),
      tg_add_vertex(TG,S,V),
      tg_add_edge(TG,R,V,_),
      fail
  ; tg_show(TG)
  ),
  tg_clear(TG).
  
  