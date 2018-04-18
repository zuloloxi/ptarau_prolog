:-['../library/alist_lib'].
:-['../wordnet_agent/psa_handler'].

wnet_server:-run_http_server(9090,'..').

go:-wnet_server.
