del /Q jnet\*.class
javac -classpath ".;jinni.jar;jinni3d.jar" jnet/*.java
java -classpath ".;jinni.jar;jinni3d.jar" jnet.WordGraph

