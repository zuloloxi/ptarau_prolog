del /Q jnet\*.class
javac -classpath ".;jinni.jar;jinni3d.jar" jnet/*.java
java -Xmx512M -classpath ".;jinni.jar;jinni3d.jar" jinni.kernel.Main %1 %2 %3 %4 %5

