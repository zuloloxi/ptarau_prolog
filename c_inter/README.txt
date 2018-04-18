Applications generated with the C-interface are NOW freely
distributable - they contain a free BinProlog runtime system.

The process described here is C-compiler/OS dependednt and
it might require adatptation to your environment.

On Windows, this requires that Visual C/C++ 6.0's cl.exe
compiler is in your PATH, properly configured with its required
environment variables. To regenerate your application including
the C-interface components defined in file c.c, just type: 

  winmake.bat

This will compile c.c and c.pl to a standalone executable using
compilation to C ->  the file you can change and adapt for your 
C-interface needs.

Binary BinProlog Professional distributions contain in directory
../lib files like global.h and c_defs.c and - needed in the compilation
process.

The resulting c_binpro.c standalone application contains
your own builtins/C-interface code as part of a
customized version of BinProlog.

To redistribute a resulting application you will have
to start it by defining your own main/0 predicate instead of
BinProlog's toplevel and make sure it cannot be used as 
a Prolog system as such by your end users.

On Unix with gcc and on NT using Cygnus gcc, edit the makefile if
needed but it usually works fine as is.
