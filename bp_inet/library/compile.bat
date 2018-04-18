bp fcompile(http_server) call(halt)
ren http_server.wam temp.boo
del /Q *.wam
ren temp.boo http_server.wam

