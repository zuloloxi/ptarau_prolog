Minimal Self Contained Prolog Server Agent Example

(Runs as a BinProlog or Jinni application on for Windows
and Linux and it can be adapted easily to other systems).

=====================================================================
Extend/adapt this prototype to develop your own Prolog Server Agents!
=====================================================================

Launch a BinProlog server with

  run.bat

or

  run_windows.bat 
 
(the latest uses precompiled http_server.wam).
 
or a Jinni server with 

jrun.bat

You will have to adapt the *.bat files on Linux/Unix/MacOS
to similar shell scripts (the scrip "run" for Linux). Please
ensure you use a port which is not blocked - as some Linux
systems are fairly paranoid about that. Make sure that the
following are executable with:

chmod a+x run_linux jrun_linux bp

then try

run_linux

or, for the Jinni version

jrun_linux

To try out the server from your browser type:

http://localhost:8181/index.html

or, if your machine is connected to the Internet and
port 8181 is not blocked or not hidden by a firewall:

http://<your machine>:8181/index.html

If you are behind a firewall or NAT, you can borrow a port
from the Jinni Virtual Server Registry at

http://logic.csci.unt.edu:9090/

and, after chosing a port, type

java -jar jinni.jar

followed by

tunnel_from(8181,<your virtual port>).

This will make you local server visible as

http://logic.csci.unt.edu:<virtual port>

by using Jinni's built-in TCP-IP tunneling capabilities.

Enjoy,

Paul Tarau
