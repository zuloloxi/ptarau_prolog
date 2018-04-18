:-['psa_handler'].
% :-[wx_top].
:-['../library/http_server'].

lm_server(Port):-
  bb_let(www,root,'..'), % still not working from '.'
  bb_let(fallback,server,"http://logic.csci.unt.edu/"),
  http_bg(4000,1000,1000,http_server(Port)).

lm_server:- lm_server(8888).
