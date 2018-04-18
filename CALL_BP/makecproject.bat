CALL clean.bat
CALL LIB2OBJ.BAT
CALL PRO2DLL.BAT cproject
link.exe -DLL /NODEFAULTLIB:LIBC /DEFAULTLIB:wsock32 /DEFAULTLIB:advapi32 *.obj -out:cproject.dll
CALL MAKEPROJ.BAT runcproject
del /Q *.obj
runcproject.exe