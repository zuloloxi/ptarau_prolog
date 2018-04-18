:-['../library/cgi_lib.pro'].

main:-run_cgi(body).

body:-
  File='visitors.txt',
  get_cgi_input([ 
    name=Ns,
    email=Es,
    comment=Qs
  ]),
  name(N,Ns), % convert char list Ns to constant N
  name(E,Es),
  name(Q,Qs),
  tell_at_end(File), % open guest file
    pp_clause(guest(N,E,Q)), % write record for this guest
  told, % close guest file
  write('<b>Thanks </b>'),write(N),write('!'),nl,nl,
  forall(term_of(File,guest(N,_,Q)),show_guest(N,Q)).

show_guest(Name,Quote):-
   map(write,['<b>',Name,'</b> said :']),nl,
   write(Quote),nl,nl.
 