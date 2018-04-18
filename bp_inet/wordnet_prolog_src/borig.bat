CALL setpath.bat
bp -b0 -h40000 -t2000 -s1000 -a21 -d21 fcompile(wx_orig) call(halt)
ren wx_orig.wam wx_orig.keep
del /Q wx_*.wam
del /Q x?.wam
del /Q %PROLOG_PATH%\*.wam
ren wx_orig.keep wx_orig.wam
move /Y wx_orig.wam \paul\wordnet\wruntime
