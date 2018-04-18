set JAVA_HOME=\Program Files\Java\jdk1.6.0\
set PATH=%JAVA_HOME%jre\bin\client;%PATH%
@echo DO init.bat once
javac bpj.java
javap -s -p bpj
cl.exe -F2000000 -Febpj.exe bpj.c -I..\lib -I"%JAVA_HOME%include" -I"%JAVA_HOME%include\win32" -DTHREADS=1 -DVCC=1 -MT -GF -TC -W2 -O2x -DWIN32 -DNDEBUG -D_CONSOLE -D_WINDOWS -DMBCS -nologo -link /NODEFAULTLIB:LIBC /DEFAULTLIB:wsock32 /DEFAULTLIB:advapi32 /DEFAULTLIB:"%JAVA_HOME%lib\jvm.lib" /DEFAULTLIB:..\lib\bp.lib
CALL run.bat