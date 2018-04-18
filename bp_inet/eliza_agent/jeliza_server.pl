:-['../library/alist_lib'].
:-['../eliza_agent/psa_handler'].
:-['../eliza_agent/eliza_top'].

chat_step(I,O):-eliza_chat_step(I,O).

go:-
  init_eliza,
  run_http_server(8081,'..').
  