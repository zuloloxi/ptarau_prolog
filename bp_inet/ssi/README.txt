To try out the server, together with a server side include
script handling facility, type

bp http_query

Assuming that the BinProlog Internet tools have been
uncompressed in something like c:\bp_inet,
just open with Netscape the following link:

http://localhost:8080/bp_inet/cgi/http_query.html

Click on the submit button to see the server interacting
with the Netscape client, both for fetching a file and
running a CGI script-like "server side include" program
(based on code in ssi_lib.pl and http_query.pl).

This demo form can be easily adapted to remotely
administer the server, with appropriate password
protected queries.

To launch the server only, on default port 8080,
without the ssi facilities, type in a command window:

bp http_server

then, type at the prompt:

?- http_server.

To create distributable bytecode application type:

bp

?-fcompile(http_query).

Then, run the bytcode application with

bp http_query.wam

Enjoy,

The BinNet Team.

