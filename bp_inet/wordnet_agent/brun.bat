SET PROLOG_PATH=C:\tarau\wordnet_prolog_src
rem SET BP_PATH=C:\paul\vista\wordnet_agent
..\bin\bp.exe -b0 -r1000000 -a18 -d21 qcompile(wnet_server) call(wnet_server) %1 %2 %3 %4 %5
