CALL setpath.bat
bp -b0 -h50000 -t2000 -s1000 -a19 -d17 bpco.wam qcompile(wx_jcomp) call(go) call(halt)
ren wx_run.bp wx_run.keep
del /Q wx_*.bp
del /Q x?.bp
del /Q %PROLOG_PATH%\*.bp
del /Q %BP_PATH%\*.bp
ren wx_run.keep wx_run.bp
move /Y wx_run.bp
CALL jser.bat %BP_PATH%
move /Y wx_run.jc %BP_PATH%
rem CALL clean.bat
