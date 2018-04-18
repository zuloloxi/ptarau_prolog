CALL setpath.bat
bp -b0 -h50000 -t2000 -s1000 -a21 -d17 bpco.wam  "and(ucompile('wx_orig.pl','wam.bp','wx_orig.bp'),halt)"
ren wx_orig.bp wx_orig.keep
del /Q wx_*.bp
del /Q x?.bp
del /Q %PROLOG_PATH%\*.bp
del /Q %BP_PATH%\*.bp
ren wx_orig.keep wx_orig.bp
java -Xms256M -Xmx512M -classpath ".;prolog.jar" prolog.kernel.Main wx_orig.bp serialize(wx_orig) call(halt) %1
move /Y wx_orig.jc %BP_PATH%
move /Y wx_orig.bp %BP_PATH%
rem CALL clean.bat
