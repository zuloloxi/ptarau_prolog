% meta search component
search_step(Qs,As):- 
  debug_match(mx_entering_search_step,Qs,[]),
  transform_before(Qs,QBs),
  transform_after(QBs,Rs),
  to_upper_first(Rs,As),
  debug_match(mx_existing_search_step,Qs,[]).

do_search(Qs,Frames):-
 search_agent(Host,Port,Pwd,_Timeout), % timout not used for now
 % timed_call(Frames,
 remote_run(Host,Port,Frames,search_all_of(Qs,Frames),Pwd,the(R)),
 % Timeout,the(Frames))
 Frames=R. 
 
transform_before(Ls,QBs):-QBs=Ls,println(Ls).

transform_after(Qs,Best):-pick_best(Qs,Best),!.  
transform_after(Qs,Best):-
  \+asserted(smemo(Qs,_)),
  do_search(Qs,Frames),
  findall(XAs,good_in_frames(Frames,Qs,XAs),ToSort),
  % println(tosort=ToSort),
  sort(ToSort,Sorted),
  % println(sorted=Sorted),
  foreach(member(_-X,Sorted),assertz(smemo(Qs,X))),
  % listing(smemo),
  pick_best(Qs,Best).
  
pick_best(Qs,Best):-  
  retract1(smemo(Qs,Best)),
  assertz(smemo(Qs,Best)).
  
good_in_frames(Frames,Qs,Sortable):-
    nth_member(Frame,Frames,N),
    once(member(snippet=SCs,Frame)), % codes
    codes_words(SCs,Ws),
    % url=UCs not handled for now
    good_words_in(Ws,Qs,Us),
    Us=[_,_,_|_],
    % good_snippet(Us),
    % println(good=Us),
    ( Ws=Us->KAs=1/Us
    ; once(member(cat=Cs,Frame)),Cs=[_|_]->
      good_words_in(Cs,Qs,As),
      det_append(As,[';'|Us],Bs),
      KAs=2/Bs    
    ; is_prolog(prolog_compiled),
      good_snippet(Us),
      once(member(url=Cs,Frame)),Cs=[_|_]
      ->
      atom_codes(URL,Cs),
      detag(URL,UString),
      ttyprint(detagging=URL),
      atom_codes(UString,UXs),
      codes_words(UXs,UWs),
      summarize(UWs,Qs,As),
      det_append(As,[';'|Us],Bs),
      KAs=3/Bs
    ; once(member(sum=Ss,Frame)),Ss=[_|_]->
      good_words_in(Ss,Qs,As),
      det_append(As,[';'|Us],Bs),
      KAs=4/Bs
    ; once(member(title=CTs,Frame)),codes_words(CTs,Ts),Ts=[_|_]->
      good_words_in(Ts,Qs,As),  % codes
      det_append(As,[';'|Us],Bs),
      KAs=5/Bs
    ; KAs=6/Us
    ),
    KAs=K/Content,
    % println(valid=KAs),
    length(Content,L),
    intersect(Content,Qs,Common),
    length(Common,CL),
    % NL is 0-L,Val=good(CL,N,NL,K)
    Val is 0-(20*CL+2*N+L-K),
    % println(content_val=Val-Content),
    Sortable=Val-Content.

url2wss(URL,Wss):-
  detag(URL,S),
  atom_codes(S,Cs),
  findall(Ws,chars_sentence_of(Cs,Ws),Wss).
  
show_url(URL):-
  url2wss(URL,Wss),
  set_param(sview,yes),sgo(the(Wss)).
  
%http://www.google.com/search?hl=en&ie=UTF-8&oe=UTF-8&q=war&btnG=Google+Search
% does not work!
show_google(Query):-
  namecat('http://www.google.com/search?q=',Query,'',URL),
  detag(URL,S),
  println(S).
  
wmember(W,Qs,UWs):-
  nth_member(W,UWs,N),
  ( N>20,!,fail;true),
  ( w(W,_)->true
  ; member(W,Qs)
  ).
  
good_snippet(Us):-
  nonvar(Us),
  % println(here=Us),
  length(Us,L),L>4,
  % L<16,
  nth_member(Verb,Us,_V),
  once(w2itn([Verb],_,verb,_)),
  % nth_member(Noun,L,N),N<V,w2itn([Noun],_,noun,_),
  !.
  
good_words_in(Ws,_Qs,_Us):-var(Ws),!,errmes(unexpected_var,good_words_in/2),fail.
good_words_in(Ws,Qs,Us):-findall(W,is_good_word_in(Ws,Qs,W),Us).
  
is_good_word_in(Ws,Qs,W):-
  member(W,Ws),
  W\==amp,
  W\==br,
  is_good_word(W,Qs).

is_good_word(W,Qs):-member(W,Qs),!.  
is_good_word(W,_):-
  atom(W),
  atom_codes(W,Cs),
  forAll(member(C,Cs),is_alpha_code(C)),
  ( Cs=[First|More],is_upper_char(First),More=[_|_]
  ; Cs="a"
  ; Cs=[_,_|_]
  ),
  content_only([W]),
  w(W,_),
  !.

is_upper_char(X):-"AZ"=[A,Z],X>=A,X=<Z.

is_alpha_code(X):-
  [A,Z,LA,LZ,N0,N9]="AZaz09",
  ( X>=A,X=<Z
  ; X>=LA,X=<LZ
  ; X>=N0,X=<N9
  ; member(X,",.?!:;-'")
  ),
  !.
