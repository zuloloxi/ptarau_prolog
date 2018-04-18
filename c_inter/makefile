# name of executable
PROJ = c_binpro
EPROJ = ./c_ru

# ---------------------  EDIT HERE -----------------------------------------
# to chose between emulated (quick) or C-ified (standalone) project type
# note that EPROJ is deprected and requires source license of BinProlog

it: $(PROJ)

mt:
	make it 'LIBS=-lm -lpthread'

#it: $(EPROJ)

# key components

CINTERF = c
LIBDIR =../lib
BINPROLOG = ../bin/bp
BPLIB = bpr_lib.a
#CC = gcc -I$(LIBDIR) -g 
CC = gcc -I$(LIBDIR) -fomit-frame-pointer -s -O2

# ---- platform dependencies ----------------------------

# on Solaris 5.5++
# TLIBS=-lpthread
# LIBS = -lm -lnsl -lsocket $(TLIBS)

# --- cygwin for NT, Linux and most Unix systems
TLIBS=
LIBS = -lm $(TLIBS)

# ------------------- Standalone C-ified project -------------------------#
# This generates a C-file from the Prolog file in PROJ file and links it to
# the BinProlog `library' (a relocatable object file usually ../lib/bp_lib.a) and
# own C-code in files c.c + c.h and your Prolog code using the interface
# in file c.pl 

# order matters here, library $(BPLIB) should be last !!!
# this allows overriding some parts by providing similar *.o files before the library

COMPARTS= $(CINTERF).o $(LIBDIR)/$(BPLIB)
PPARTS=$(PROJ).o $(COMPARTS)

$(PROJ):	$(PPARTS) makefile
	$(CC) -o $(PROJ) $(PPARTS)  $(LIBS)
	@echo "!!! TYPE ./$(PROJ) and then ?-go. at the Prolog prompt !!!"

$(PROJ).o:	$(PROJ).h $(PROJ).c $(LIBDIR)/c_defs.h $(LIBDIR)/global.h
	$(CC) -c $(PROJ).c

$(PROJ).h $(PROJ).c:	$(PROJ).pro $(CINTERF).pl
	rm -f $(PROJ).c
	$(BINPROLOG) "cmake($(PROJ)),halt"

$(CINTERF).o:	$(CINTERF).c $(CINTERF).h $(LIBDIR)/global.h
	$(CC) -c $(CINTERF).c

#------------------- Emulator based project - deprecated -----------------#
# needs BinProlog source license - in fact this type of project is deprected -
# the packaging of all BinProlog into libraires bp_lib.a and bpr_lib.a does a better job
# This compiles your C-code in files c.c c.h and links it to the BinProlog 
# library usually ../lib/bp_lib.a to to obtain a new emulator (usually c_ru)
# TYPE c_ru ../lib/wam.bp to start the new emulator
# TYPE ?-[c]. to load your Prolog code from c.pl
# TYPE ?-go. to test it

# -------------- editables---------------------------------------#
EPARTS=$(SRC)/$(EMUSTUB) $(COMPARTS)
EMUSTUB = stub.o
EMUWAM = stub.o
SRC = ../src
#--------------------------------------------------------------- #
$(EPROJ):	$(EPARTS) makefile
	$(CC) -o $(EPROJ) $(EPARTS)  $(LIBS)
	@echo "TYPE $(EPROJ) $(SRC)/wam.bp and then ?-[c]. and ?-go. at the Prolog prompt"

# --------------------- maintenance operations ---------------------------- #
save:
	rm -f -r bak
	mkdir bak
	cp $(PROJ).pro c.c c.h c.pl makefile bak

clean realclean:	oclean
	rm -f *.o *.ccp *.s $(PROJ) $(EPROJ) *.exe *.obj *.dll

oclean:
	rm -f $(PROJ).o $(PROJ).s $(PROJ).c $(PROJ).h
