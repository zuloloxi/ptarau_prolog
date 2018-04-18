:-[moo].
:-[single].
%:-[dual].
%:-[multi].
:-[english].

%login(my_name).  % to override detected user id
password(none).
%home('http://localhost'). % home page

go:-logimoo_client.

% comment out if you want to see state of database in Prolog
main:-go.

