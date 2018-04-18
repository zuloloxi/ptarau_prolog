rem build BP(exe win32) with Vc++ 2003 toolkit
rem del /Q wam.c
rem del /Q wam.h
rem del /Q binpro.c
rem del /Q binpro.h
rem del /Q *.obj
rem del /Q *.exe
rem del /Q *.dll
rem del /Q *.exp
rem del /Q *.lib
rem build ru (old bp)
cl.exe -Feru.exe -DTHREADS=1 -DVCC=1 -MT -GF -TC -W2 -O2x -DWIN32 -DNDEBUG -D_CONSOLE -D_WINDOWS -DMBCS -nologo ru.c sym.c load.c engine.c builtins.c dict.c io.c socket.c float.c debug.c gc.c term.c termStore.c main.c stub.c c.c /FAcs /Fa./ru_cod/ -link /DEFAULTLIB:wsock32 /DEFAULTLIB:advapi32 /DYNAMICBASE:NO /FIXED /NXCOMPAT /MACHINE:X86 /MAP /MAPINFO:EXPORTS
copy full.pro wam.pro
ru remake
ru "and(cboot,halt)"
makebp
rem bp [remake]
rem CALL cboot.bat
REM copy bp.exe \bin
REM CALL MAKEBPX pbp.exe "-DPROF=3" "-DTRACE=1" "-DTRACE_EXEC=1"
rem del /Q ru.exe
rem del /Q *.obj
