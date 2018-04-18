Copyright (C) 1999-2005 BinNet Corp.
This component requires VCC 6.0 or .NET cl - it shows how to access services
provided by BinProlog in DLL form from C/C++ files compiled with the
VCC 6.0 compiler cl.exe (it might also work with VCC 5.0). 

BinProlog DLL examples for W95/98/NT/2000/XP

The BinProlog runtime emulator combined with the the C-ified Prolog runtime 
libraries are packaged dynamic libraries

bp_lib.dll (compiler enabled, runs *.pl *.pro files) 

and

bpr_lib.dll (compiler disabled runs precompiled *.wam files)

Type "winmake.bat" to create all sample applications, or something like

makeproj bp_top

to create the *.exe file for a particular project

To create a DLL from your own Prolog project that is first converted to C,
modify cproject.pro to include your own code, then type

makecproject.bat

followed by

runcproject.exe

to test a call to the resulting cproject.dll file that
embeds your code and the Prolog engine.

---------------------------------------------------------------------
Related information for owners of full BinProlog source license:

You can add various DLL_EXPORT declarations similar to those
in ../src/main.c and c.c or build custumized *.def files in directory ../src.

Related information, for owners of Jinni full source license:
See TwinProlog for a 3-tier, bidirectional Prolog-Java-C/C++
interface, also using a BinProlog DLL - actually implementing
a native BinProlog accelerator for Jinni.
