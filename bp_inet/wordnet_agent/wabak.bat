rem CALL clean.bat
del /Q \bak\wabak%1.zip
zip.exe \bak\wabak%1.zip -9 -v *.*
dir \bak\wabak%1.zip

