:-['../library/cgi_lib'].

main:-run_cgi(body).

body:-
  get_cgi_input([ 
    name=Ns,
    email=Es,
    help=Hs
  ]),
  name(N,Ns),
  name(E,Es),
  name(H,Hs),
  abstime(T),
  chars_words(Hs,Ws),
  show_solutions(Ws),
  log_to('helplog.txt',help(T,N,E,H)).

show_solutions([]):-!,
  F='help.html',
  ( exists_file(F)->true
  ; help
  ),
  show_file(F).
show_solutions(Ws):-
  forall(member(W,Ws),show_solution(W)).

show_solution(Word):-
  write('<b>'),
  write('HELP on <i>'),write(Word),write(':</i>'),nl,nl,
  info(Word),
  help(Word),
  write('</b>').

