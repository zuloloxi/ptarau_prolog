Type run.bat then point your browser to:

http://localhost:8181/index.html

Type go.bat to start a server on a machine on the net with
a PrologServer Agent ready to allocate tunnels on machines behind a firewallor any third party servers on the Web.

If you want to build tunnels directly using the included Jinni plugin, jinni.jar,
please refer to the included JinniUserGuide.html (the sections on TCP/IP Tunelling
and remote predicate calls, which combined allow you to control a remote 
tunnel server). We have included them here for convenience:

Exporting local services with Jinni's TCP-IP tunelling

Jinni supports a simple TCP-IP tunelling API to export services provided by 
servers behind a firewall (in particular Jinni's own Prolog remote predicate
call server, or its HTTP server usable to deploy Jinni applets or server side
Prolog agents). The API consists of server and client side tunelling components:

server_tunnel(ServerPort,LinkServerPort,ServerTunnel): Creates a server
side TCP-IP tunnel which maps ServerPort to LinkServerPort. When a client
connects to LinkServerPort, it will be able to map all the services of a
server it has access to (usually behind a firewall or NAT) as if they were
provided on ServerPort. This component is meant to be used on a machine
visible on the net to which services behind firewalls can connect
and become visible. The returned ServerTunnel can be used to stop
the (background) threads created to support the tunnel.

client_tunnel(LinkHost,LinkPort,LocalServer,LocalPort,ClientTunnel): Creates
a client side TCP-IP tunnel which maps LinkHost, LinkPort, to LocalServer, LocalPort
where a server (usually behind a firewall or NAT) listens. This client connects
to LinkHost, LinkPort, and remaps the services at LocalServer, LocalPort as if
they were provided on ServerPort on the LinkHost machine. This component is meant
to be used on a machine invisible on the net (behind firewalls or NAT). The
returned ServerTunnel can be used to stop the (background) threads created 
to support the tunnel.

stop_tunnel(Tunnel): Stops the threads supporting a server or client side tunnel.

Client-Server Programming with Remote Predicate Calls

Jinni 2004 supports a simple client-server Remote Predicate Call mechanism given by the following API:

    * run_server(Port,Password): runs a server on a given Port and with given
      Password (to be matched by connecting client queries)
    * run_server(Port): runs a default server on given Port
    * run_server: runs server on default port
    * remote_run(Query): asks the default server to run Query and bind variables
      with returned result
    * remote_run(Host,Port,Answer,Goal,Passwd,Result): asks a server waiting on
      Host, Port to execute Goal and return a Result of the form the(AnswerInstance)
      if the query succeds or no if it fails. The returned Term answer instance
      contains a copy of Answer with bindings resulting of the execution of Goal.
      Note that an implicit once/1 operation is used on Goal as only the first solution\
      is returned.

For instance, you can start on your real "server" machine with fixed
IP address and domain name ( let's say: server.example.com) with something like:

jinni.bat
?-server_tunnel(5555,4444,R).
?-server_tunnel(8888,7777,R).

Let's assume that on the client machine (let's say "localhost"), you run an Apache server on port 80 and a Jinni Web server on port 81, which you have started in its own window with:

jinni.bat
?-run_http_server(81).

Then if you run on the client machine (localhost) in a separate window, something like

?-client_tunnel('server.example.com',4444,localhost,80,R).
?-client_tunnel('server.example.com',7777,localhost,81,R).

you will be able to tunnel the services form localhost to
server.example.com (visible on the net) where you will see the
tunnelled Apache server as:

http://server.example.com:8888/

and the tunelled Jinni server as:

http://server.example.com:5555/

You can start by modifying the sources provided in jinni_server.pl and 
psa_handler.pl to customize them for your application. They put together a Web
server and a remote predicate call server ready to allocate tunnels for client
applications behind a firewall or NAT.

Enjoy,

Paul Tarau
BinNet Corp.
