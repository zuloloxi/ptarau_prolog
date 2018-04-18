:-['psa_handler'].

go:-
  HTTP_PORT=9090,
  % set_tunnel_server('localhost'),
  default_port(P),
  bg(run_server(P)),
  println('started RPC server on port'(P)),
  sleep(1),
  bg(run_http_server(HTTP_PORT,'.')),
  println('started HTTP server on port'(HTTP_PORT)),
  sleep(1),
  virtualize('www.yahoo.com',80,5001,'hoo','Virtual Yahoo'),
  virtualize('www.google.com',80,5002,'Glass','Virtual Google'),
  % virtualize('www.arpatp.com',80,5003,'october','Virtual ARP/ATP'),
  true.
 
