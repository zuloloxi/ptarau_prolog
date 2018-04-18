rem make bpr.lib with command  makelib bpr.lib
rem del /Q *.dll
rem del /Q *.exp
rem del /Q *.lib
link.exe -lib *.obj -out:..\lib\%1
rem traces build
rem C:\A17\prolog\ptarau_prolog\src>link.exe -lib *.obj -out:..\lib\bpr.lib
rem Microsoft (R) Library Manager Version 10.00.40219.01
rem Copyright (C) Microsoft Corporation.  All rights reserved.
rem 
rem stub.obj : warning LNK4006: _wam_bp already defined in wam.obj; second definition ignored
rem stub.obj : warning LNK4006: _wam_bp_size already defined in wam.obj; second definition ignored
rem binpro.obj : warning LNK4006: _user_bp already defined in stub.obj; second definition ignored
rem 
rem C:\A17\prolog\ptarau_prolog\src>
