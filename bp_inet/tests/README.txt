Please take a look at the specification of client predicates
in file http_client.pl, http_spider, http_server.pl etc.

Type 

bp 

?-[http_test].

If you have a server on your local machine
try this query to display all lines of a file.

?-t17.

If you have the BinNet HTTP server running on port 8080
try this to have it send you a HTML page (hello.html).

?-t18.

If you are connected to the Internet,
try out something like:

?-http2link('http://www.yahoo.com',L).

To get a set of links extracted from a Web site.

Enjoy,

The BinNet Team
