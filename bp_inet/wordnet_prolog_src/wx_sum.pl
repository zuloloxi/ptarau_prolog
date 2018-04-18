% PR based summarizing / focus extraction

stx:-
  set_param(giant_only,yes),
  sum_url('cnn.txt').

st0:-
  set_param(giant_only,yes),
  sum_url('google.txt').

st1:-
  set_param(giant_only,yes),
  sum_url('http://cnn.com').
    
st2:-
  set_param(giant_only,yes),
  sum_url('http://money.cnn.com').

st3:-
  set_param(giant_only,yes),
  sum_url('http://www.yahoo.com/').

st4:-
  set_param(giant_only,yes),
  sum_url('http://www.cnn.com/2004/ALLPOLITICS/04/28/google.effect/index.html').

st5:-
  set_param(giant_only,yes),
  sum_url('http://www.eetimes.com/article/showArticle.jhtml?articleId=18400898').
  
sumtest:-
  set_param(giant_only,yes),
  foreach(
    (source_file(F),namecat(F,'.txt','',URL)),
    sum_url(URL)
  ).

sum_url(URL):-
  sum_url(URL,[],Rss),
  println('SUMMARY'),
  foreach(member(Rs,Rss),println(Rs)).
   
sum_url(URL,Qs,Rss):-
  url2wss(URL,Wss),
  show_sum(Wss,Qs,Rss).

sum_sentences(Wss):-
  show_sum(Wss,[],Rss),
  println('SUMMARY'),
  foreach(member(Rs,Rss),println(Rs)).
  
show_sum(UWs,Qs,Rss):-
   nonvar(Qs),
   Sentences=[Qs|UWs],
   new_igraph([_],Sentences,G),
   run_page_rank(G,Times),rank_sort(G),
   mark_components(G),
   comp_stats(G,[Size,Comps,Giant,GSize]),
   ttyprint(graph_ranked(steps=Times,
     [size=Size,comps=Comps,giant=Giant,giant_size=GSize])),
   trim_ranked_graph(G,0,40,TG),
   find_at_most(8,Ws,(good_vertex_of(TG,I),vertex_data(TG,I,Ws)),Rss),
   comp_stats(TG,Stats),
   println(stats=Stats),
   visualize_sum(TG).
   
visualize_sum(TG):-     
   new_java_class('jwn.TGAdaptor',C),
   invoke_java_method(C,show(TG,1,10,15),_), 
   % 1=giant only 0=with root
   % 10 - only first 10
   % 15 - chop lines 
   draw_graph(TG,100,800,800,800).
   
summarize(UWs,Qs,As):-
  nonvar(UWs),
  findall(W,wmember(W,Qs,UWs),Ws),
  As=Ws.
  
new_igraph(Ts,Wss,G):-
  new_ranked_graph(G),
  foreach(nth_member(Ws,Wss,N),add_and_name_vertex(G,N,Ws)),
  add_iedges(Ts,G,Wss).

add_and_name_vertex(G,N,Ws):-
  codes_words(Cs,Ws),name(S,Cs),
  add_vertex(G,N,S),
  foreach(good_nth_member(W,Ws,K),(add_vertex(G,W,N),add_edge(G,W,S,K))).

good_nth_member(W,Ws,N):-
  nth_member(W,Ws,N),
  ifilter_word([_],W).
     
add_iedges(Ts,G,Wss):- 
  nth_member(Ws,Wss,I),
    nth_member(Us,Wss,J),
      findall(W,ifilter(Ts,Ws,Us,W),Xs),
      length(Xs,LX),
      LX>0,
      I>J, % only backward
      add_edge(G,I,J,LX),
  fail.
add_iedges(_Ts,_G,_Wss).    

ifilter(Ts,Ws,Us,W):-
  member(W,Ws),
  member(W,Us),
  ifilter_word(Ts,[W]).
  
ifilter_word(Ts,Ws):-
  content_only(Ws),
  w2t(Ws,T),
  member(T,Ts),
  !.

