The process described here is C-compiler/OS dependent and
it might require adatptation to your environment.

On Windows, this requires that Visual C/C++ cl.exe
compiler is in your PATH, properly configured with its required
environment variables. To regenerate your application including
the C-interface components defined in file c.c, just type: 

  winmake.bat

Binary BinProlog Professional distributions contain in directory
../lib files like global.h and c_defs.c and - needed in the compilation
process, as well as the JNI libraries and java properly installed.

The

init.bat script sets the path on an NT machine - you might have to
do similar things on other architectures.

The resulting jbp.exe standalone application contains
your own builtins/C-interface code as part of a
customized version of BinProlog.

To redistribute a resulting application you will have
to start it by defining your own main/0 predicate instead of
BinProlog's toplevel and make sure it cannot be used as 
a Prolog system as such by your end users.

On Unix with gcc and on Windows using Cygnus gcc, edit the makefile if
needed but it usually works fine as is.
