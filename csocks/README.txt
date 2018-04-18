This mimicks BinProlog client/server interaction
Useful for debugging socket stuff

DO:

make

TYPE:

server

OUTPUT:

New server on port: 7001
Ready to accept on socket: 3
......

TYPE:

client

host:: .....
ip_addr:: ......
....

TYPE at the client's prompt:

?- out(a(1)).
sock_write0: trying to write, sock, count: 4, 4
sock_write0: written, sock, count: 4, 4
sock_write0: trying to write, sock, count: 4, 10
sock_write0: written, sock, count: 4, 10
sock_write: written: out(a(1)).
sock_read0, sock, this!!: 4, 4
sock_read0, sock, this!!: 4, 3
sock_read: Reading: yes
closing socket: 4
?- in(a(X)).
sock_write0: trying to write, sock, count: 4, 4
sock_write0: written, sock, count: 4, 4
sock_write0: trying to write, sock, count: 4, 9
sock_write0: written, sock, count: 4, 9
sock_write: written: in(a(X)).
sock_read0, sock, this!!: 4, 4
sock_read0, sock, this!!: 4, 3
sock_read: Reading: yes
closing socket: 4
^D

DO:

bp 'call(trust)'

in one window

rtop

in another

enter commands in the "rtop" window to drive the remote BinProlog 
server (both "rtop" and "bp 'call(trust)'" using password "none").

Enjoy,

The BinNet Team

