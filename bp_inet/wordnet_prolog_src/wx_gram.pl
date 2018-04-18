% grammar elements

to_ngroup(Vs,Ns):-wvariant_of(noun,Vs,Ws),!,Ns=Ws.
to_ngroup([Art|Vs],Ns):-is_article(Art),wvariant_of(noun,Vs,Ws),!,Ns=Ws.
to_ngroup(Ws,Ns):-ngroup(Ns,Ws,[]),!.


ngroup(Ns)-->qualifiers(Ns).
ngroup(Ns)-->art(_),qualifiers(Ns).

angroup(Ns)-->qualifiers(Ns).
angroup([A|Ns])-->art(A),qualifiers(Ns).

qualifiers([N,of|Ns])-->qualifier(N),[of],angroup(Ns).
qualifiers([N|Ns])-->qualifier(N),ngroup(Ns).
qualifiers([N])-->last_noun(N).

last_noun(N)-->[N],{is_noun(N)},no_more_nouns.

qualifier(N)-->[N],{is_qualifier(N)}.

no_more_nouns-->[X],{is_noun(X)},!,{fail}.
no_more_nouns-->[].

art(A)-->[A],{function_word0(A,article,_)}.

prep(P)-->[P],{is_preposition(P)}.

is_qualifier(W):-w2t([W],T),member(T,[noun,adjective,adjective_satelite]).

is_noun(W):-w2t([W],noun).

is_verb(W):-w2t([W],verb).

is_verb_phrase(Ws):-w2t(Ws,verb).

is_article(A):-function_word0(A,article,_).
is_preposition(P):-function_word0(P,preposition,_).

% end

chars_sentence_of(Cs,Ws):-
  new_engine(C,member(C,Cs),E),
  Ends=".!?",
  pick_code_of(E,Ends,Xs),
  codes_words(Xs,Ws),
  Ws=[_|_].

  