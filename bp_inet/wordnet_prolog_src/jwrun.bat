@echo EXPECT around 10 minutes loading time!!!
@echo type ?-means(life).
java -Xms256M -Xmx512M -classpath ".;prolog.jar" prolog.kernel.Main /paul/wordnet/wruntime/wx_run.bp mcompile(wx_jtop) bg(prolog_server) %1 %2 %3 %4 %5 %6 %7 %8
