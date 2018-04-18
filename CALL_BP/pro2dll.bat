..\bin\bp qmake(%1),halt
cl.exe -Fe%1 -D"VCCDLL=1" -LD -Gd -D_USRDLL -I..\lib %1.c ..\lib\c.c -DTHREADS=1 -DVCC=1 -MT -GF -TC -W2 -O2x -DWIN32 -DNDEBUG -D_CONSOLE -D_WINDOWS -DMBCS -nologo -link /NODEFAULTLIB:LIBC /DEFAULTLIB:advapi32 /DEFAULTLIB:..\lib\bp.lib /DEFAULTLIB:wsock32

