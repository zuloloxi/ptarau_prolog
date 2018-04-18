:-[wx_top]. % generator

% FrameNet interface

fnet_dir('\paul\wordnet\FrameNet\xml\').
pfnet_dir('\paul\wordnet\PrologFrameNet\').
wnet_dir('\tarau\wordnet_prolog_src\').

all:-
  clean_memos,
  lu2prolog,
  frames2prolog,
  make_wfs,
  f2bp.
  
f2bp:-
  pfnet_dir(Dir),
  cd(Dir),
  save_memos('paths.pl'),
  println(memos_generated),
  % clean_memos,
  make_framenet_proj,
  fcompile('framenet.pl'),
  wnet_dir(Curr),
  cd(Curr).
  
make_framenet_proj:-
  pfnet_dir(Dir),
  PF='framenet.pl',
  namecat(Dir,'',PF,ProjFile),
  dir2includes(Dir,ProjFile,[PF,'clean.bat','run.bat','trim.bat','framenet.wam']).
  
dir2includes(D,ProjFile,Excludes):-
   dir2files(D,Fs),
   tell(ProjFile),
   foreach(member(F,Fs),add_include(F,[ProjFile|Excludes])),
   told.

add_include(F,Es):-member(F,Es),!,fail.
add_include(FS,_):-trim_suffix(".pl",FS,F),pp_fact(':-'([F])).

lu2prolog:-
  fnet_dir(D),
  dir2files(D,Fs),
  nth_member(XF,Fs,I),
  XF\=='frames.xml',
  % I<5,
  trim_suffix(".xml",XF,F),
  ttyprint(entering(I,F)),
  if(lu2prolog(F),true,ttyprint(failing_on(F))),
  % println(exiting(F))
  fail.
lu2prolog:-
  println(conversion_completed).

lu2prologTrees:-
  fnet_dir(D),
  dir2files(D,Fs),
  nth_member(XF,Fs,I),
  % I>5909,
  XF\=='frames.xml',
  trim_suffix(".xml",XF,F),
  ttyprint(entering(I,F)),
  if(lu2prologTree(F),true,ttyprint(failing_on(F))),
  tell('trace.txt'),println(processed(I,F)),statistics,nl,told,
  ttyprint(exiting(I,F)),
  fail.
lu2prologTrees:-
  println(conversion_completed).

trim_suffix(Ss,XF,F):-
  name(XF,Xs),
  append(Fs,Ss,Xs),
  !,
  name(F,Fs).

lu2prolog(F):-
  fnet_dir(XDir), 
  namecat(XDir,F,'.xml',XFile),
  pfnet_dir(PDir),
  namecat(PDir,F,'.pl',PFile),
  parse_xml(XFile,Tree),
  tell(PFile),
  foreach(lu2path(F,Tree,Clause),pp_fact(Clause)),
  told,
  tell_at_end('trace.txt'),println(processed(F)),statistics,nl,told,
  ttyprint(exiting(F)).

lu2path(F,Tree,H):-
  H=..[F,Ps,Leaf],
  xml_path(Tree,Ps,Leaf).
  
lu2prologTree(F):-
  fnet_dir(XDir), 
  namecat(XDir,F,'.xml',XFile),
  pfnet_dir(PDir),
  namecat(PDir,F,'.pl',PFile),
  parse_xml(XFile,Term),
  lu_transform(F,Term,Ts),
  tell(PFile),
  foreach(member(T,Ts),pp_fact(T)),
  told.

lu_transform(F,xml_doc(_Hs,node(_N,As,Ns)),Ts):-
  T=..[F,As,Ns],
  Ts=[T].
  
frames2prolog:-
  F='frames',
  fnet_dir(XDir), 
  namecat(XDir,F,'.xml',XFile),
  pfnet_dir(PDir),
  namecat(PDir,F,'.pl',PFile),
  parse_xml(XFile,Tree),
  tell(PFile),
   foreach(lu2path(F,Tree,Clause),pp_fact(Clause)),
  told,
  ttyprint(frames_converted).
  
frames2prologTree:-
  F='frames',
  fnet_dir(XDir), 
  namecat(XDir,F,'.xml',XFile),
  pfnet_dir(PDir),
  namecat(PDir,F,'.pl',PFile),
  parse_xml(XFile,Term),
  tell(PFile),
  pp_fact(Term),
  told.
      
fnet2tree0(F,Term):- 
  fnet_dir(D), 
  namecat(D,'\',F,File),
  parse_xml(File,Term).
  
%xml_ignore(R):-println(node_here=R),fail.
xml_ignore(notes).

%xml_ignore_att(R):-println(att_here=R),fail.
xml_ignore_att(cDate).
xml_ignore_att(cBy).
xml_ignore_att(start).
xml_ignore_att(end).
xml_ignore_att(fgColorS).
xml_ignore_att(bgColorS).
xml_ignore_att(fgColorP).
xml_ignore_att(bgColorP).

xml_transform(Ds,Ts):-member('&',Ds),!,Ts=ignored.
xml_transform(Ds,Ts):-clean_html(Ts,Ds,[]).

% clean_html(Xs) --> ['&',_,(';')],!,clean_html(Xs).
clean_html(['.'|Xs]) --> [(';')],!,clean_html(Xs).
clean_html([X|Xs]) --> [X],!,clean_html(Xs).
clean_html([]) --> [].

make_wfs:-
  pfnet_dir(D),
  namecat(D,'frames.pl','',IF),
  namecat(D,'wfs.pl','',OF),
  tell(OF),
  foreach(
    frame_terms(IF,W,Fs),
    pp_fact(wfs(W,Fs))
  ),
  told.
  
frame_terms(F,W,Fs):-
  findall(W-f(Ws,I),frame_term(F,W,Ws,I),WsFs),
  keygroup(WsFs,W,Fs).  

frame_term(F,N,Ns,IdF):-
  %pfnet_dir(D),
  %namecat(D,'frames.pl','',F),
  term_of(F,T),
  T=frames(_P,a(As)),
  member(name=NNs,As),
  map(to_word_list,NNs,Wss),
  appendN(Wss,Us),
  to_lower_first(Us,[N|Ns]),
  member('ID'=[Id],As),
  to_string(Id,S),
  namecat('lu','',S,IdF).

to_word_list(W,Ws):-atomic(W),!,word2list(W,Ws).
to_word_list(Ws,Us):-
  map(word2list,Ws,Wss),
  appendN(Wss,Us).


   
/*
test1:-lu2prolog.

test2:-
  lu2prolog(lu10),
  lu2prolog(lu4994).
  
test3:-
  fnet2tree0('lu4994.xml',Term),
  show_xml(Term).

test4:-
  fnet2tree0('lu319.xml',Term),
  foreach(
    xml_path(Term,Ps,Leaf),
    println(Ps+Leaf)
  ).
    
verybig:-
  % quiet(0),
  statistics,
  frames2prolog,
  statistics.
 
big:-
  fnet2tree0('lu1245.xml',Term),
  show_xml(Term).
   
toks:-
  F='frames.xml',
  fnet_dir(D),
  namecat(D,'\',F,File),
  xml_token_of(File,_),
  fail.
*/
  