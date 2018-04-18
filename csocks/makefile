GCC=gcc $(MYFLAGS) -DSTANDALONE_SOCKET_STUFF -fomit-frame-pointer -s -O2
#LIBS = -lsocket -lnsl
# for SOLARIS ^
#GCC=gcc -g

it: socks

socks: server client rtop

server:	server.o socket.o makefile
	$(GCC) -o server server.o socket.o $(LIBS)

client:	client.o socket.o makefile
	$(GCC) -o client client.o socket.o $(LIBS)

rtop:	rtop.o socket.o makefile
	$(GCC) -o rtop rtop.o socket.o $(LIBS)

server.o:	server.c makefile
	$(GCC) -c  server.c

client.o:	client.c makefile
	$(GCC) -c client.c


rtop.o:	rtop.c makefile
	$(GCC) -c rtop.c

socket.o:	../src/socket.c makefile
	$(GCC) -o socket.o -c ../src/socket.c

clean realclean:
	rm -f rtop rtop.exe server.exe client.exe *.obj server client rtop.o client.o server.o socket.o a.out

save:
	rm -r -f bak
	mkdir bak
	cp rtop.c server.c client.c socket.c makefile README.txt bak

