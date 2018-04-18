CALL jwn_compile.bat
java -Xmx1024M -classpath ".;jinni.jar;jwn/TGGraphLayout.jar" jinni.kernel.Main /paul/wordnet/runtime/wx_run.jc "mcompile(wx_jtop)" "set_param(sview,yes)" "bg(jinni_server)" %1 %2 %3 %4 %5 %6 %7 %8
