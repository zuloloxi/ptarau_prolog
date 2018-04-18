CALL setpath.bat
REM java -Xmx1024M -classpath ".;prolog.jar" prolog.kernel.Main /paul/wordnet/wruntime/wx_orig.jc qcompile(wx_jreg) %1 %2 %3 %4 %5
REM CALL breg.bat
java -Xmx1024M -classpath ".;prolog.jar" prolog.kernel.Main "qcompile(wx_jreg)" "and(process_file,halt)" %1 %2 %3 %4 %5