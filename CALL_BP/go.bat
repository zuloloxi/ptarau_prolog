rm -r -f tmp
mkdir tmp
cp ../src/*.c tmp
cp ../src/*.h tmp
rm -f tmp/stub.c
echo cp one_query.c
pushd .
cd tmp
gcc -DTHREADS=1 -fomit-frame-pointer  -s -O3 -o callbp.exe *.c -lm -lpthread
popd
cp tmp/*.exe .

