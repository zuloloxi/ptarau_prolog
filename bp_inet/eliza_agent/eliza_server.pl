:-['../library/http_server'].
:-['../eliza_agent/psa_handler'].
:-['../eliza_agent/eliza_top'].

chat_step(I,O):-eliza_chat_step(I,O).

eliza_server:-eliza_server(8081).
