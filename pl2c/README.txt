This directory is for creating your own C-ified standalone executables. 

On Windows NT with VCC 6.0 just type winmake.bat.

Look at *.pro examples, showing how to C-ify a given project.

Something like:

make PROJ=brev

will create a standalone executable from brev.pro and its included
files.

Use (one or more) directives

   :-set_c_threshold(Min,Max).

or

   :-set_c_threshold(Min).

in your *.pro file to fine-tune your C-ified code for speed or size.

Good results are obtained for Min in 6..15 on most architectures.

P.S. Min and Max are the minimum and maximum length of a sequence 
of WAM-instructions which gets translated to a C leaf-routine.

To clean up files generated for a project do something like:

make clean PROJ=brev

You might want to copy some other files from directory ../progs here
to try out the speed-up through generation of C.
