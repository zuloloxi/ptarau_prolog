:-[wx_gbuild].
% :-[wx_r].
:-[wx_dis].

base_dir('.'):-exists_file('disamb.jc'),!.
base_dir('/paul/wordnet/rada').

view:-
  run_prog(view).

sview:-
  run_prog(sview).

noview:-
  % set_param(first_only,no),
  dis,
  endlog.
        
run_prog(Param):-
  ttyprint('starting'(Param)),
  set_param(Param,yes),
  dis,
  endlog.

def_params:-
  def_param(logfile,'log.txt'),    % name of the log file
  def_param(pr2pl,'no'),    % runs program to convert pr_files to pl_files
  def_param(first_only,no), % limits action to first file only - good for testing
  def_param(sview,'no'),    % visualise the synset graph at the end
  def_param(strace,'yes'),  % if no - then only visualise the synset graph at the end
  def_param(view,'no'),     % visualise the sentence/word graph at the end
  def_param(shuffle,no),    % removes order bias coming from decreasing WNet Freq order
  def_param(freq_rank,no),  % combines PR rank with WNet Freq info
  def_param(bias,no),      % adds Freq based bias to PR computations
  def_param(rank,yes),      % activates PageRank
  def_param(giant_only,no), % considers only links in the largest connected component
  def_param(maxsyn,64),     % only takes first maxsyn synsets in decr. WNet Freq order
  def_param(links,yes),     % adds to the PR graph links based on Rel-related synsets
  def_param(rel,xlinked),   % specifies Rel - xlinked means any sense discriminating Rel
  def_param(lesk,no),       % activates Lesk ordering - after shuffle
  def_param(freq_lesk,no),  % if Lesk of a synset=0 than take most freq WNet sense
  def_param(glinks,yes),     % adds to the PR graph links from glosses
  def_param(freq_links,no), % adds links from less freq to more freq synsets
  def_param(sem_links,no),  % adds links based on various sem. Rels between synsets in the text
  def_param(co_occ,no),     % adds links for words co-occuring in a small window in a sentence
  def_param(from,verb),      % sets origin of a co-occ link as noun, verb etc.
  def_param(to,verb),        % sets target of a co-occ link as noun, verb etc.
  def_param(rank_order,no), % orders synsets by their Global WordNet Rank - not very useful
  def_param(random_seed,99),% sets random seed: use 'no' for sys. provided seed
  show_params.
   
/*      
def_params:-
  def_param(logfile,'log.txt'),    % name of the log file
  def_param(pr2pl,'no'),    % runs program to convert pr_files to pl_files
  def_param(first_only,no), % limits action to first file only - good for testing
  def_param(sview,'no'),    % visualise the synset graph at the end
  def_param(strace,'no'),  % if no - then only visualise the synset graph at the end
  def_param(view,'no'),     % visualise the sentence/word graph at the end
  def_param(shuffle,no),    % removes order bias coming from decreasing WNet Freq order
  def_param(freq_rank,no),  % combines PR rank with WNet Freq info
  def_param(bias,no),      % adds Freq based bias to PR computations
  def_param(rank,yes),      % activates PageRank
  def_param(giant_only,no), % considers only links in the largest connected component
  def_param(maxsyn,64),     % only takes first maxsyn synsets in decr. WNet Freq order
  def_param(links,yes),     % adds to the PR graph links based on Rel-related synsets
  def_param(rel,xlinked),   % specifies Rel - xlinked means any sense discriminating Rel
  def_param(lesk,no),       % activates Lesk ordering - after shuffle
  def_param(freq_lesk,no),  % if Lesk of a synset=0 than take most freq WNet sense
  def_param(glinks,no),     % adds to the PR graph links from glosses
  def_param(freq_links,no), % adds links from less freq to more freq synsets
  def_param(sem_links,no),  % adds links based on various sem. Rels between synsets in the text
  def_param(co_occ,no),     % adds links for words co-occuring in a small window in a sentence
  def_param(from,verb),      % sets origin of a co-occ link as noun, verb etc.
  def_param(to,verb),        % sets target of a co-occ link as noun, verb etc.
  def_param(rank_order,no), % orders synsets by their Global WordNet Rank - not very useful
  def_param(random_seed,99),% sets random seed: use 'no' for sys. provided seed
  show_params.
*/
  
% uses PageRank for disambiguation and focus discovery

% source_file('/paul/wordnet/stories/grimm/145').
% source_file('/paul/wordnet/stories/hgwells').
% source_file('/paul/wordnet/stories/dilbert').
% source_file('/paul/wordnet/stories/tao').
% source_file('/paul/wordnet/stories/bible').

source_file('/paul/wordnet/stories/fed98sep').
source_file('/paul/wordnet/stories/fed99may').
source_file('/paul/wordnet/stories/fed00jan').
source_file('/paul/wordnet/stories/fed01jan').
source_file('/paul/wordnet/stories/fed02jan').
source_file('/paul/wordnet/stories/fed03jan').

source_file('/paul/wordnet/stories/fed04jan').
source_file('/paul/wordnet/stories/theonion_printer').
source_file('/paul/wordnet/stories/onion_saddam').

data_file(Suf,F0,F):-
  base_dir(B0),namecat(B0,'/','',B),
  namecat(B,Suf,'_files',D),
  dir2files(D,Fs),
  member(F0,Fs),
    namecat(D,'/',F0,F).

target_file(Suf,F0,F):-
  base_dir(B0),namecat(B0,'/','',B),
  namecat(B,Suf,'_files',D),
  namecat(D,'/',F0,F).
    
pl_file(F0,F):-data_file(pl,F0,F).
pr_file(F0,F):-data_file(pr,F0,F).

suf2suf(FromCs,ToCs,PF0,TF0):-
  atom_codes(PF0,Ps),
  append(Fs,FromCs,Ps),
  !,
  det_append(Fs,ToCs,Ts),
  atom_codes(TF0,Ts).

suf_pr2pl(PF,TF):-suf2suf(".pr",".pl",PF,TF).
suf_pl2txt(PF,TF):-suf2suf(".pl",".txt",PF,TF).

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

jsave:-serialize('/paul/wordnet/rada/disamb').

% sets def params used in file
trgo:-
  clear_params,
  dis.
 
% uses params defined on command line

dis:-
  def_params,
  (get_param(pr2pl,yes)->pr2pl;true),
  ( get_param(random_seed,S),integer(S)->random_seed(S)
  ; true
  ),  
  get_param(rel,Rel),
  get_param(from,From),
  get_param(to,To),
  get_param(maxsyn,MaxSyn),
  init_gensym(file_count),bb_let(perc,0.0),
  forsome(
    pl_file(F0,F),
    rank_and_eval_tfile(F0,F,MaxSyn,Rel,From,To)
  ),
  % ttyprint('!!there'),
  gensym_no(file_count,FC0),FC is FC0-1,
  ( bb_val(perc,TP),FC>0->
    AvgPerc is TP/FC,
    get_param(logfile,LF),
    dprint([file=LF,avg_perc=AvgPerc]),dnl
  ; dprint('unable to comput avg. perc')
  ).

forsome(Cond,Action):-get_param(first_only,yes),!,(once(Cond),once(Action)->true;true).
forsome(Cond,Action):-foreach(Cond,Action).

sgo(TheWss):-sgo(TheWss,Goal),Goal.

sgo(no,true).  
sgo(the(Wss),Todo):-get_param(sview,yes),!,Todo=sum_sentences(Wss).
sgo(the(Wss),visualize(VGs)):-
  ttyprint(wss=Wss),
  show_sum(Wss,[],_Rss),
  % set_param(sview,yes),
  set_param(strace,no),
  def_params,
  get_param(rel,Rel),
  get_param(from,From),
  get_param(to,To),
  get_param(maxsyn,MaxSyn),
  init_gensym(file_count),bb_let(perc,0.0),
  rank_sentence(Wss,MaxSyn,Rel,From,To,VGs).
  
rgo:-
  def_params,
  get_param(rel,Rel),
  get_param(from,From),
  get_param(to,To),
  get_param(maxsyn,MaxSyn),
  init_gensym(file_count),bb_let(perc,0.0),
  foreach(
    source_file(F0),
    rank_and_eval_file(F0,MaxSyn,Rel,From,To)
  ).

pr2pl:-
  ttyprint(reading_sysnset_map),
  load_oi,
  ttyprint(starting_pr_to_pl_conversion),
  forsome(
    pr_file(F0,F),
    run_pr2pl(F0,F)
  ).
  
load_oi:-
  ( term_of('oi.pl',oi(O,I)),
    % (def(O,'oi',I)->true;println(repeated_map(O,I))),
    (def(O,'oi',I)->true;true),
    fail
  ; true
  ).
  
oi0(O,I):-val(O,'oi',I).
  
run_pr2pl(PR0,PR):-
  suf_pr2pl(PR0,PL0),target_file(pl,PL0,PL),
  ttyprint(converting(from=PR,to=PL)), 
  tell(PL),
  ( tline_of(PR,T0),
    (T0=';'->T=',';T=T0),
    pp_fact(T),
    fail
  ; told
  ).
  
tagged2info(N,TLs,Ts,Xss):-
  findall(TL,get_tagged(TLs,TL),Tss),
  appendN(Tss,Ts),
  findall(Xs,(member(TL,TLs),taged2info1(N,TL,Xs)),Xss),
  !.
tagged2info(_,TLs,_,_):-ttyprint(dropped=TLs),fail.

get_tagged(Ds,T):-member(D,Ds),arg(1,D,T).

taged2info1(N,tl(Vs,Ws,Cat,GoodI),Ws-Ks/k(Cat,0,GoodI)):-
  cw2is(Ws,Is0),
  % println(before_shuffle=Is0),
  (get_param(shuffle,yes)->shuffle(Is0,Is1);Is1=Is0),
  (get_param(rank_order,yes)->rank_order(Is1,Is);Is=Is1),
  % println(after_shuffle=Is),
  findall(I,first_nth(N,filter_type(Is,Ws,Cat,I),I),Js),
  ( Js=[]->Ks=Vs
  ; Ks=Js
  ).

filter_type(Is,Ws,T,I):-
  member(I,Is),
  once(i2wtn(I,Ws,T,_)).
  
tsentence_of(F,TLs):-
  new_engine(TL,term_of(F,TL),E),
  repeat,
    ( tcollect(E,Ts)->TLs=Ts
    ; !,fail
    ).

tcollect(E,Ts):-
  get(E,the(X)),
  tcollect1(X,E,Ts).

% tcollect1(no,_,_):-!,fail.
tcollect1('.',_,[]):-!.
tcollect1(T,E,[T|Ts]):-get(E,the(T1)),tcollect1(T1,E,Ts).
     
tline_of(F,T):-
  name(NL,[10]),name(NL1,[10,13]),name(NL2,[13,10]),
  NLS=[NL,NL1,NL2],
  line_of(F,Cs),
  % \+member(Cs,[[],[10,_|_],[13,10,_|_],[10,13,_,_]]),
  codes_words(Cs,Xs),
  findall(W,(member(W,Xs),\+member(W,NLS)),Ws),
  % ttyprint(here_word=Ws),
  words2tl(Ws,T).

words2tl([],T):-!,T='.'.
words2tl(['.'],_T):-!,fail.
words2tl([Punct],T):-!,T=Punct.
words2tl(Xs,TL):-  
  get_tag(Xs,T,N),
  get_phrase(Xs,V),word2list(V,Vs),
  get_lemma(Xs,N,V,W),word2list(W,Ws),
  get_synset(Xs,O),
  do_oi(O,I),
  TL=tl(Vs,Ws,T,I).

do_oi(O,I):-integer(O),for(K,1,4), XO is (K*100000000)+O, oi0(XO,I),!.
do_oi(O,I):-integer(O),XO is 110000000+O,oi0(XO,I),!.
do_oi(_,none).

get_phrase([X|_Xs],X).

get_lemma(Xs,TagPos,_V,W):-
  TagPos>1,
  N is TagPos+1,
  nth_member(Lemma,Xs,N),
  !,
  W=Lemma.
get_lemma(_Xs,_TagPos,V,V).
 
get_synset(Xs,I):-last_of(Xs,I),integer(I),!.
get_synset(_Xs,none).
   
get_tag(Xs,Tag,N):-nth_member(X,Xs,K),tag2wn(X,T),!,Tag=T,N=K.
get_tag(_,other,0).

tag2wn('NN',noun).
tag2wn('NNS',noun).
tag2wn('NNP',noun).

tag2wn('VB',verb).
tag2wn('VBD',verb).
tag2wn('VBG',verb).
% tag2wn('VBP',verb).
% tag2wn('VBZ',verb).

tag2wn('JJ',adjective).

tag2wn('RB',adverb).

rank_and_eval_file(F0,N,Rel,From,To):-  
  namecat(F0,'.txt',F),namecat(F0,'_rank','.txt',RF),
  tell(RF),
    rank_file(F,file2info,N,Rel,From,To,G,SDb,WDb),
    process_ranked(N,Rel,From,To,G,SDb,WDb,VGs),
    visualize(VGs),
  told.

rank_and_eval_tfile(F0,F,N,Rel,From,To):-
  suf_pl2txt(F0,RF0),target_file(txt,RF0,RF),
  tell(RF),
    rank_file(F,tfile2info,N,Rel,From,To,G,SDb,WDb),
    process_ranked(N,Rel,From,To,G,SDb,WDb,VGs),
    visualize(VGs),
  told.

rank_sentence(Wss,N,Rel,From,To,VGs):-
  rank_file(Wss,sent2info,N,Rel,From,To,G,SDb,WDb),
  process_ranked(N,Rel,From,To,G,SDb,WDb,VGs).

any2var(any,_):-!.
any2var(X,X).

rank_file(File,Op,MaxSyn,Rel,From0,To0,G,SDb,WDb):-
  dprint(ranking_file(File,op=Op,maxsyns=MaxSyn,rel=Rel)),
  show_params,
  any2var(From0,From),
  any2var(To0,To),
  new_ranked_graph(G),
  % default: new_ranked_graph(G,0.85,0.001,50),
  new_ranked_graph(SDb),
  new_ranked_graph(WDb),
  ( rank_file1(File,Op,MaxSyn,G,SDb,WDb,Rel,From,To),
    fail
  ; true
  ),
  ( get_param(rank,yes)->
    dprint(starting_page_rank),
    run_page_rank(G,Times),
    rank_sort(G),
    mark_components(G),
    comp_stats(G,[Size,Comps,Giant,GSize]),
    % show_graph(G), %%$$
    dprint(finished_page_rank([size=Size,pr_steps=Times,comps=Comps,giant=Giant,gsize=GSize])),dnl
    % ,view3d(G)
  ; dprint(graph_not_ranked),dnl
  ).

good_vertex_of(G,V):-
  get_param(giant_only,yes),
  !,
  % comp_stats(G,[_Size,_Comps,Giant,_GSize]),
  giant_component(G,Giant),
  vertex_of(G,V),
  get_component(G,V,Giant).
good_vertex_of(G,V):-
  vertex_of(G,V).
  
comp_stats(G,[Size,Comps,Giant,GSize]):-
  count_components(G,Comps),
  giant_component(G,Giant),
  component_size(G,Giant,GSize),
  invoke_java_method(G,size,Size).
                 
rank_file1(F,Op,N,G, SDb,WDb, Rel,From,To):-
  bb_let(edge,0),
  bb_let(wcount,0),
  Proc=..[Op,F,N,Ts,Xss],
  call(Proc),
    to_content(Ts,Cs),
    findall(Ws-Desc/Is,
      linkable_in(From,To,Xss,Ws,Desc,Cs,Is),
    WsIs),
    length(WsIs,L),
    bb_val(wcount,L0),L1 is L0+L,bb_set(wcount,L1),
    process_vertices(G,SDb,WDb,Ts,WsIs,Rel),
    (get_param(co_occ,yes)->process_co_occurences(G,From,To,WsIs);true),
  fail.  
rank_file1(_File,_Op,_NTokens,G, SDb,WDb, Rel,From,To):-
  invoke_java_method(SDb,size,SS),dprint(total_sentences=SS),
  bb_val(usent,U),dprint(total_words_in_unprocessed_sentences_count=U),
  bb_val(wcount,L),dprint(total_words_in_processed_sentences_count=L),
  invoke_java_method(WDb,size,SW),dprint(total_tagged_unique_words=SW),
  invoke_java_method(G,size,SG),dprint(total_synset_vertices=SG),
  bb_val(edge,ENO),dprint('edges after processing_co_occurences'=ENO),
  (get_param(rank,yes)->process_links(_DefEx,From,To,G,WDb,Rel);true),
  bb_val(edge,EN),dprint(total_edges=EN).

linkable_in(From,To,Xss,Ws,Desc,Cs,NewIs):-
  member(Ws-Is0/Desc,Xss),
  check_from_to(From,To,Desc),
  ( Is0==none->Is=[]
  ; arg(3,Desc,fun),member(W,Is0)->Is=[W]
  ; Is=Is0
  ),
  (get_param(lesk,yes)->process_lesk(Cs,Is,NewIs);NewIs=Is).

check_from_to(any,any,_):-!.
check_from_to(any,_,_):-!.
check_from_to(_,any,_):-!.
check_from_to(From,_,Desc):-arg(1,Desc,From),!.
check_from_to(_,To,Desc):-arg(1,Desc,To).
   
process_vertices(G,SDb,WDb, Ts,WsIs,Rel):-
  add_vertex(SDb,Ts,WsIs),
  member(Ws-Desc/Is,WsIs),
  arg(3,Desc,HI),
  (integer(HI),
  % WE DISCARD VERTICES WHICH HAVE NO CHANCE TO MATCH AS IHuman is not among the int Is0
  i2wtn(HI,Ws,_,_)
  % WE DISCARD SPURIOUS REPLACEMENTS IN ANNOTATED CORPUS AND FUNCTION WORDS
  ,\+(function_word_phrase(Ws)),\+(member(Ws,[[group],[location],[person]]))
  ->true
  ; member(HI,[wnet,exc])
  ->true
  ; % [Z]=".",put(Z),
    fail, HI\==none,println(unexpected_tag=HI+Ws),fail
  ),
  add_vertex(WDb,Ws,Desc/Is),
    member(I,Is),
      add_vertex(G,I,Rel),
      % set_bias ...
      get_param(bias,yes),
      once(i2wtf(I,Ws,_,Freq)),
      Bias is 0.0+Freq,
      set_bias(G,I,Bias),
      % ttyprint(Ws:I=>Bias),
  fail.
process_vertices(_G,_SDb,_WDb, _,_,_).
  
process_links(DefEx,From,To,G,WDb,Rel):-
  findall(J,good_vertex_of(G,J),Js),
  (get_param(links,yes)->rel_connect(G,Rel,Js);true),
  (get_param(freq_links,yes)->add_freq_links(G,WDb);true),
  (get_param(glinks,yes)->add_glinks(Rel,DefEx,From,To,G,WDb,Js);true),
  (get_param(sem_links,yes)->add_sem_links(G,WDb,Js);true).

rel_connect(G,Rel,Js):-
  Rel=..[F|Xs],
  det_append(Xs,[I,J],Ys),
  Proc=..[F|Ys],
  dprint(proc=Proc),
  member(I,Js),
    Proc,
      is_vertex(G,J),
      xadd_edge(G,I,J,Rel),
  fail.
rel_connect(_G,_Rel,_Js).

add_freq_links(G,WDb):-
  bb_val(edge,EN),
  dprint('before extending with incoming freq links'=EN),
  vertex_of(WDb,Ws),
  vertex_data(WDb,Ws,Data),
  (Data=_Desc/Is->true;dprint(unexpected=Data),fail),
  follows_in(Is,This,Next),
     xadd_edge(G,Next,This,freq),
  fail.  
add_freq_links(_G,_WDb).

add_glinks(Rel,Op,From,To,G,WDb,Is):-
  bb_val(edge,EN),
  dprint('before extending with incoming gloss links to nouns in the text'=EN),
  % Op=ex,def
  member(I,Is),
     i2wtn(I,Ws,To,_),
     is_vertex(WDb,Ws),
     gloss2i(Op,From,I,H), 
     is_vertex(G,H),
     call(Rel,H,I),
     xadd_edge(G,H,I,Op),
  fail.  
add_glinks(_Rel,_Op,_From,_To,_G,_WDb,_Is).

add_sem_links(G,_,Is):-
  fail, %$
  bb_val(edge,EN),
  dprint('before extending with outgoing superclass links, edges'=EN),
  member(I,Is),
    hyp(I,H),  
      xadd_edge(G,I,H,superclass),   
  fail.
add_sem_links(G,_,Is):-
  bb_val(edge,EN),
  dprint('before extending with incoming domain links'=EN),
  member(I,Is),
     rcls(I,H),  
       xadd_edge(G,I,H,domain),   
  fail.
add_sem_links(G,Is):-
  % fail,%$
  bb_val(edge,EN),
  dprint('before extending with incoming subclass links'=EN),
  member(I,Is),
    rhyp(I,S),
      xadd_edge(G,S,I,subclass),   
  fail.      
add_sem_links(_,_).


process_lesk(Ts,Is,NewIs):-
   % ttyprint('!!input'=Ts+Is), 
   sort(Ts,STs),
   findall(K-I,lesk_val(Is,STs,K,I),KIs),
   keysort(KIs,Sorted),
   map(arg(2),Sorted,NewIs).

lesk_val(Is,STs,K,V):-   
    nth_member(V,Is,N),
      integer(V),
      gloss2ws(_,V,SWs),
      intersect(STs,SWs,Cs),
      length(Cs,L),
      (get_param(freq_lesk,yes)->FreqN=N;FreqN=0),
      K is FreqN-L.

  
process_co_occurences(G,FromType,ToType,WsIs):-
  %$ fail, %$
  % ttyprint('!!'=WsIs), 
  nth_member(VWs-_/Vs,WsIs,VK),
    once(member(V,Vs)),
      integer(V),
      once(i2wtn(V,_,FromType,_)),
      once(hyp(V,_)), % not too abstract
      nth_member(NWs-_/Ns,WsIs,NK),
      VWs\==NWs,
        once(member(N,Ns)),
          integer(N),
          V=\=N,
          Dist is abs(VK-NK),
          Dist<4,
          % ttyprint('!!'=V=>N), 
          once(i2wtn(N,_,ToType,_)),
          once(hyp(N,_)), % not top
          xadd_edge(G,V,N,FromType-ToType),
          % [Z]="*",put(Z),
          % println(cooc_edge(NWs:N,VWs:V)),
  fail.  
process_co_occurences(_,_,_,_).  

xadd_edge(G,I,J,D):-
  bb_val(edge,N0),
  N is N0+1,
  bb_set(edge,N),
  add_edge(G,I,J,D).

compute_rank0(G,Is,I,R,N):-nth_member(I,Is,N),get_rank(G,I,R).

compute_rank(yes,G,Is,Ws,I,R):-!,compute_rank0(G,Is,I,PR,N),once(w2itf(Ws,I,_,FR)),rank_formula(FR,PR,N,R).
compute_rank(_,G,Is,_Ws,I,R):-compute_rank0(G,Is,I,R,_).

% rank_formula(FR,PR,N,R):-R is pow(FR,PR)/N.
% rank_formula(FR,PR,N,R):-R is log(16,1+FR)*PR/N.
% rank_formula(FR,PR,N,R):-if(0=:=FR,R=0,R is PR/N).

rank_formula(FR,PR,1,R):-!,R is 4*FR*PR.
rank_formula(FR,PR,_N,R):-R is FR*PR.
      
process_ranked(N,Rel,From,To,G,SDb,WDb,VisualGs):-
  init_gensym(match),
  init_gensym(mismatch),
  (get_param(freq_rank,FRK)->true;FRK=no),
  dprint(processing(syns=N,rel=Rel,co_occ(From,To))),
  ( vertex_of(WDb,Ws),
    vertex_data(WDb,Ws,Data),
    (Data=Desc/Is->true;dprint(unexpected=Data),fail),
    % balanced: WEIGHTING RANKS TO TAKE INTO ACCOUNT WordNet Probabilities
    % findall(R-I,(nth_member(I,Is,K),get_rank(G,I,R0),R is R0/K),RIs),
    % ORIGINAL PR WEIGHTS
    findall(R-I,compute_rank(FRK,G,Is,Ws,I,R),RIs),
    maxn(RIs,R-I),
    % ttyprint(here(RIs)=>R-I), %$$
    update_rank(WDb,Ws,R),
    add_edge(WDb,Ws,best_syn,Desc/I),
    % ttyprint(here(Desc/I)), %$$
    fail
  ; 
    vertex_of(SDb,Ts),vertex_data(SDb,Ts,WsIs),
    findall(Ws-I/R,(
      member(Ws-_/Is,WsIs),
        vertex_of(WDb,Ws),
          get_rank(WDb,Ws,R),
          edge_data(WDb,Ws,best_syn,I)
    ),
    RIs),
    add_edge(SDb,Ts,best_syn,RIs),
    map(s2rank,RIs,Rs),
    (Rs=[]->
       AvgR is 0
    ;  avg(Rs,AvgR)
    ),
    update_rank(SDb,Ts,AvgR),
    fail
  ; first_nth(8,good_vertex_of(G,I),I),
    get_rank(G,I,R),
    i2ws(I,Wss),
    fprintln(top_ranked_synset(I/R,Wss)),
    fail
  ;   
    vertex_of(SDb,Ts),edge_data(SDb,Ts,best_syn,WRs),
    fprintln(disambiguated_sentence=Ts),
    vertex_data(SDb,Ts,Data),
    fprintln(rank_based_word_db_edge_data),
    member(Ws-(Desc/I)/R,WRs),
      arg(3,Desc,HumanI),
      ( integer(HumanI),count_match(I,HumanI),vertex_data(G,HumanI,D),D=Rel->
        get_rank(G,HumanI,HR)
      ; HR=unranked
      ),
      i2ws(I,Vss),
      member(Ws-(_/Js),Data),
      ftab(4),fprintln(Ws/Desc=HR=>I/R:Js/Vss),
      g(I,Ds),functor(D,def,1),once(member(D,Ds)),
         ftab(8),fprintln(D),
    fail
  ; rank_sort(SDb),
    fprintln(ranked_sentences),
    vertex_of(SDb,Ts),get_rank(SDb,Ts,R),
    fprintln(R:Ts),
    fail
  ; extract_keyords(WDb,G),  
    fail
  ; true
  ),
  gensym_no(mismatch,MM1),MisMatch is MM1-1,
  gensym_no(match,M1),Match is M1-1,
  Total is Match+MisMatch,
  ( Total>0->Perc is (Match*100/Total)
  ; Perc=undefined
  ),
  dprint(result(Rel,match_perc=Perc,total=Total,match=Match,mismatch=MisMatch)),
  dprint('---------------------------------------------------------------------'),
  ( Perc=undefined->true
  ; gensym_no(file_count,_),bb_val(perc,TP0),TP is TP0+Perc,bb_set(perc,TP)
  ),
  enrich(G),
  VisualGs=gs(SDb,WDb,G).

enrich(G):-
  good_vertex_of(G,V),
  i2ws(V,Vss),swrite(Vss,S),
  add_edge(G,V,sense,S),
  % ttyprint(here(V,S)),
  fail.
enrich(_).  
    
extract_keyords(WDb,_G):-
  rank_sort(WDb),
  dnl,dprint('highest ranked words:'),
  first_nth(8,vertex_of(WDb,Ws),Ws),
  dprint(Ws),
  fail.
extract_keyords(_WDb,G):-
  % G already sorted
  dnl,dprint('highest ranked concepts:'),
  first_nth(8,good_key_sysnset(G,noun,I,Ws),I-Ws),
  dprint(I:Ws),
  fail.  
extract_keyords(_WDb,G):-
  % G already sorted
  dnl,dprint('highest ranked verbs:'),
  first_nth(8,good_key_sysnset(G,verb,I,Ws),I-Ws),
  dprint(I:Ws),
  fail.  
extract_keyords(_,_).

good_key_sysnset(G,T,I,Ws):-
  good_vertex_of(G,I),
  once(hyp(I,_)), % not too abstract
  once(i2wtn(I,Ws,T,_)).
  
count_match(I,HumanI):-I=\=HumanI,!,gensym_no(mismatch,_).
count_match(I,I):-gensym_no(match,_).

s2rank(_Ws-_I/R,R).

avg(Xs,A):-sum(Xs,S),length(Xs,L),A is S/L.

maxn([X|Xs],M):-foldl(kmax,X,Xs,M).

kmax(K1-_,K2-V2,K-V):-K1<K2,!,K=K2,V=V2.
kmax(KV,_,KV).

update_rank(G,V,R):-
  invoke_java_method(G,setRank(V,R),_).
  
first_nth(N,G,X):-
  new_engine(X,G,Engine),
  for(I,1,N),
    get(Engine,Answer),
    ( I=:=N -> !,Answer\==no,stop(Engine)
    ; true
    ),
  Answer=the(X).  


tftest:-
  init_gensym(scount),
  once(pl_file(_,F)),
  % println(here=F),nl,
  tfile2info(F,64,Ts,_Xss),
  length(Ts,L),
  println(L=Ts),nl,
  for(_,1,L),
  gensym_no(scount,_),
  fail
; gensym_no(scount,N),
  println(scount=N).  

tfile2info(F,N,Ts,Xss):-
  bb_let(usent,0),
  tsentence_of(F,Tss),
  length(Tss,L),bb_val(usent,L0),L1 is L0+L,bb_set(usent,L1),
  tagged2info(N,Tss,Ts,Xss).

file2info(F,N,Ts,Xss):-
  bb_let(usent,0),
  sentence_of(F,Ts0),
  length(Ts0,L),bb_val(usent,L0),L1 is L0+L,bb_set(usent,L1),
  to_lower_first(Ts0,Ts),
  tokens2info(N,Ts,Xss).

sent2info(Wss,N,Ts,Xss):-
  member(Sent,Wss),
  Ts0=Sent,
  bb_let(usent,0),
  length(Ts0,L),bb_val(usent,L0),L1 is L0+L,bb_set(usent,L1),
  to_lower_first(Ts0,Ts),
  tokens2info(N,Ts,Xss).

fprintln(T):-
  get_param(strace,yes),
  !,
  println(T).
fprintln(_).
  
ftab(N):-
  get_param(strace,yes),
  !,
  tab(N).
ftab(_).

dprint(T):-
  get_param(strace,yes),
  !,
  get_param(logfile,LF),
  telling(F),
  tell(LF),
  println(T),
  tell(F),
  ttyprint(T),
  println(T).
dprint(_).
  
dnl:-
  get_param(strace,yes),
  !,
  get_param(logfile,LF),
  telling(F),
  tell(LF),
  nl,
  tell(F),
  ttynl,
  nl.
dnl.

endlog:-
  get_param(strace,yes),
  !,
  get_param(logfile,LF),
  telling(F),
  tell(LF),
  println('END LOG'),
  told,
  tell(F).
endlog.
        
% end
/* 
SHUFFLED STATS:

window of 64 - unsupervised
-------------------------

MIN: shuffled baseline: avg 34
MAX: pick first sense (supervised,global): 62

PR + first => 66 on 13 files
    
unshuffled 3 pageRank 55
shuffled 64 xlinked pageRank 43, 44 with d0-2 data
shuffled 64 xlinked pageRank co_occ+sem_links 43
shufled + global WordNet pagerank order + text pageRank 42
shuffled 64 xcoord pageRank 37

shuffled sem_links 36
shuffled co_occ 35
global WordNet PageRAnk only: 30p

glinked=37


if entries when HumanI is absent from possible synsets are removed
-----------------------------------------------------------------
*xfail=68 *=4,1 etc. : invariant
2xlinked:balanced=67
4hyp:few edges!! =66
3xlinked:balanced=64
3xlinked=63
4xlinked=64
4xlinked:balanced=64
5xlinked=63
8xlinked:balanced=63
4:xlinked:verb->verb=62
8xlinked=61
32xlinked=58

*/
