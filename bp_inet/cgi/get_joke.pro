:-['../library/cgi_lib'].

main:-go.
% main:-test.

go:-run_cgi(body).

test:-test([]).

jfile('jokes.txt').

test(Ws):-
  jfile(JF),
  [JF]=>tell_jokes(Ws).

body:-
  get_cgi_input([
   words=Cs
  ]),
  chars_words(Cs,Ws),
  jfile(JF),[JF]=>tell_jokes(Ws),
  write('<a href="http://www.binnetcorp.com/BinProlog/demos.html">Back to the demos</a>'),nl.

tell_jokes(Ws):-
  bb_let(joke,ctr,0),
  bb_let(joke,match,0),
    forall(
      (  assumed(joke(_name,_email,Joke)),
         bb_val(joke,ctr,M),M1 is M+1,
         bb_set(joke,ctr,M1),
         related(Joke,Ws),
         bb_val(joke,match,N),N1 is N+1,
         bb_set(joke,match,N1)
      ),
      (write(Joke),nl)
    ),
  bb_val(joke,match,Found),
  (Found>0->true
  ; bb_val(joke,ctr,Max),
    show_random_joke(Max)
  ).

related(Joke,Ws):-
  ( name(Joke,Cs),%println('name ok'),
    chars_words(Cs,Js)->true
  ; true %println(error_in_parsing(Joke)),get0(_)
  ),
  member(W,Ws),
  member(W,Js),
 !.

show_random_joke(Max):-
  random(R),N is 1+R mod Max,
  write('<b>Selecting joke '),write(N),write('</b> from total of '),write(Max),nl,
  nth_answer(N,assumed(joke(_,_,Joke))),
  write('Match not found, here is a randomly selected joke:'),nl,nl,
  write(Joke),nl,
  fail
; nl.

