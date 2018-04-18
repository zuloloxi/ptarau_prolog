% keyword sets implemented as unary predicates for O(1) match

wh_word(W):-function_word0(W,pronoun,4).

hello_word(W):-kw(W,hello_word).

link_word(W):-kw(W,link_word).
compare_word(W):-kw(W,compare_word).

aux_is_word(W):-kw(W,aux_is_word).
aux_verb(W):-kw(W,aux_verb).

target_prep(W):-kw(W,target_prep).

together_word(W):-target_prep(W).
together_word(W):-kw(W,conj).
together_word(W):-kw(W,with_prep).

tell_word(W):-kw(W,tell_word).
maybe_word(W):-kw(W,maybe_word).

yes_word(W):-kw(W,yes_word).
no_word(W):-kw(W,no_word).

happy_word(W):-kw(W,happy_word).

sad_word(W):-kw(W,sad_word).
every_word(W):-kw(W,every_word).

% keywords: function and meaningful

kw(X,T):-kw0(X,T).
kw(X,T):-kw1(X,T).

% function words

kw0(hi,hello_word).
kw0(hello,hello_word).

kw0(s,aux_is_word_or_pron).

kw0(is,aux_is_word).
kw0(am,aux_is_word).
kw0(are,aux_is_word).
kw0(were,aux_is_word).
kw0(was,aux_is_word).
kw0(be,aux_is_word).
kw0(been,aux_is_word).
kw0(being,aux_is_word).
kw0(going,aux_verb).

kw0(do,aux_verb).
kw0(done,aux_verb).
kw0(doing,aux_verb).

kw0(will,aux_verb).
kw0(shell,aux_verb).
kw0(would,aux_verb).
kw0(can,aux_verb).
kw0(should,aux_verb).
kw0(could,aux_verb).
kw0(may,aux_verb).
kw0(might,aux_verb).

kw0(have,aux_verb).
kw0(had,aux_verb).
kw0(having,aux_verb).
kw0(and,conj).
kw0(and,disj).
kw0(not,neg).
kw0(to,target_prep).
kw0(with,with_prep).
kw0(for,prep).
kw0(from,prep).
kw0(on,prep).
kw0(under,prep).
kw0(at,prep).
kw0(off,prep).
kw0(of,prep).
kw0(as,prep).
kw0(in,prep).

kw0('''',empty_word).
kw0('`',empty_word).

kw0(the,art).
kw0(a,art).
kw0(an,art).

kw0(yes,yes_word).
kw0(sure,yes_word).
kw0(yeah,yes_word).
kw0(duh,yes_word).
kw0(yes,yes_word).
kw0(sure,yes_word).
kw0(yeah,yes_word).
kw0(ok,yes_word).

kw0(maybe,maybe_word).
kw0(perhaps,maybe_word).
kw0(so,maybe_word).
kw0(well,maybe_word).
kw0(hmm,maybe_word).

kw0(no,no_word).
kw0(never,no_word).
kw0(nope,no_word).

kw0(everyone,every_word).
kw0(everybody,every_word).
kw0(nobody,every_word).
kw0(none,every_word).
kw0(somebody,every_word).
kw0(everybody,every_word).
kw0(anybody,every_word).
kw0(whoever,every_word).

kw0(b,html).
kw0(br,html).
kw0(p,html).
kw0(amp,html).
kw0(lt,html).
kw0(gt,html).

% WordNet words with meaningful sysnets

kw1(tell,tell_word).
kw1(say,tell_word).
kw1(teach,tell_word).
kw1(speak,tell_word).
kw1(report,tell_word).
kw1(inform,tell_word).
kw1(state,tell_word).
kw1(state,tell_word).

kw1(link,link_word).
kw1(connect,link_word).
kw1(relate,link_word).

kw1(compare,compare_word).
kw1(associate,compare_word).

kw1(sad,sad_word).
kw1(unhappy,sad_word).
kw1(depressed,sad_word).
kw1(sick,sad_word).
kw1(tired,sad_word).
kw1(old,sad_word).
kw1(ugly,sad_word).
kw1(poor,sad_word).
kw1(negative,sad_word).

kw1(happy,happy_word).
kw1(elated,happy_word).
kw1(glad,happy_word).
kw1(better,happy_word).
kw1(rich,every_word).
kw1(young,every_word).
kw1(positive,every_word).

% end
