:-['../library/cgi_lib'].

main:-run_cgi(body).

body:-
  get_cgi_input([ 
    name=Ns,
    email=Es,
    comment=Qs
  ]),
  name(N,Ns),
  name(E,Es),
  name(Q,Qs),
  tell_at_end('jokes.txt'),
    pp_clause(joke(N,E,Q)),
  told,
  write('Thanks!'),nl,
  write('<a href="http://www.binnetcorp.com/index.html" target=_parent>Back to the BinNet''s HomePage</a>'),nl.

