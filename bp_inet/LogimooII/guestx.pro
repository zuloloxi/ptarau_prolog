:-[moo].
:-[multi]. % refers to a master server
:-[english].

login(paul).
password(none).
home('http://localhost').

go:-logimoo_client.

% comment this out for debugging
main:-go.
