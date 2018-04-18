del /Q c_binpro.exe
..\bin\bp.exe cmake(c_binpro),halt
cl.exe -Fec_binpro.exe c_binpro.c c.c -I..\lib -DTHREADS=1 -DVCC=1 -MT -GF -TC -W2 -O2x -DWIN32 -DNDEBUG -D_CONSOLE -D_WINDOWS -DMBCS -nologo -link /NODEFAULTLIB:LIBC /DEFAULTLIB:wsock32 /DEFAULTLIB:advapi32 /DEFAULTLIB:..\lib\bpr.lib
c_binpro call(go),halt
