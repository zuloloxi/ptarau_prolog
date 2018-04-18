Prolog Server Agents (PSAs) - known to work with Internet Explorer -

To try this out with BinProlog (included in bin/bp.exe), type

brun.bat

If you have a have prolog.jar in this directory try also:

jrun.bat

Each of the commands starts Web services on port 9090.

These scripts use BinProlog 9.7x and Jinni 2003's embedded Web servers
which now allow direct deployment of Web services written in Prolog.

To run the prototye Eliza chat agent from a Web page type

http://localhost:9090/wordnet_agent/frame.html

You can adapt them easily to demo any Prolog application from the Web or
as a self-contained laptop demo requiring not other Web server installation.
