CALL realclean.bat
CALL setpath.bat
CALL bbuild.bat
CALL bconvert.bat
CALL btransform.bat
CALL brefact.bat
move /Y xw.pl \paul\wordnet\wruntime
move /Y xd.pl \paul\wordnet\wruntime
CALL bbcomp.bat
CALL bjcomp.bat
