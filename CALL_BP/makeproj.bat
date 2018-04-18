cl.exe -Fe%1.exe %1.c -MT -DTHREADS=1 -DVCC=1 -DVCCDLL=1 -DWIN32 -DNDEBUG -D_WINDOWS -O2x -Ob1 -W2 -nologo
