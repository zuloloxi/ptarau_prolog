CALL setpath.bat
bp -b0 -h40000 -t2000 -s1000 -a19 -d17 fcompile(wx_run) call(halt)
ren wx_run.wam wx_run.keep
del /Q wx_*.wam
del /Q x?.wam
del /Q %BP_PATH%\*.wam
ren wx_run.keep wx_run.wam
move /Y wx_run.wam \paul\wordnet\wruntime
