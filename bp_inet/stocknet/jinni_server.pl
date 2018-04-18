:-['psa_handler'].
:-['feed'].
:-[analyze].
:-[queries].
:-[csv_parser].
:-[cal].

jinni_server(Port):-
  bg(run_http_server(Port,'.')).
