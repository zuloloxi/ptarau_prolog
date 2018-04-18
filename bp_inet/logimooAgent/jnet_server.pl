:-['../library/alist_lib'].
:-['../logimoo3/psa_handler'].

lm_server:-run_http_server(8888,'..').

go:-lm_server.
