% Prolog Server Agent Library

:-['../library/http_client'].
:-['../library/alist_lib'].

url_char_of(URL,C):-
  exists_file(URL),!,
  char_of(URL,C).
url_char_of(URL,C):-
  http2char(URL,C).

url2codes(URL,Cs):-findall(C,url_char_of(URL,C),Cs).

