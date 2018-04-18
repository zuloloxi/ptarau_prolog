CALL setpath.bat
copy %BP_PATH%\wx_run.wam wx_stub.wam
touch wx_stub.wam
dir wx_stub.*
bp -b0 -h40000 -t2000 -s1000 -a19 -d17 fcompile(wx_all) call(halt)
ren wx_all.wam wx_all.keep
del /Q wx_*.wam
ren wx_all.keep wx_all.wam
