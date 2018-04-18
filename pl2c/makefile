# This is a template to generate a C file and finally a
# self contained executable file from a BinProlog program 
# *.pro => top project file + included files

# ------ !!!!! to edit for each new project/new platform !!!! ---------

# PROJ.pl is the top file of a project
# PROJ or PROJ.exe is the name of the resulting binary executable file

# Solaris
#TLIBS = -lpthread
#LIBS = -lm -lsocket -lnsl $(TLIBS)

TLIBS=
LIBS= -lm $(TLIBS)

PROJ = brev

# !!!!! to edit for each new architecture/environment
# CC is the name of your C compiler (gcc prefered)

#------------------ set up compiler ---------------------------------#
# BINPROLOG is the name of the installed executable BinProlog file
# it will do the translation from Prolog to C
BINDIR=../bin
BINPROLOG = $(BINDIR)/bp

#------------------ set up library -----------------------------------#
# BPLIB is the name of the BinProlog (runtime or full) library
# it will be linked in your application
LIBDIR=../lib
# link with redistributable runtime library
BPLIB = $(LIBDIR)/bpr_lib.a
# link with non-redistributable library including full compiler 
BPLIB = $(LIBDIR)/bp_lib.a

CC =  gcc -I$(LIBDIR) -fomit-frame-pointer -s -O2 

# --------------------- do not edit below this line--------------------#

# This generates a C-file the Prolog files in PROJ file and links it to
# the BinProlog `library' (a relocatable object file usually ../src/ru.a)

it:	$(PROJ)

mt:
	make it 'LIBS=-lm -lpthread'

$(PROJ):	$(PROJ).o $(BPLIB)
	$(CC) -o $(PROJ) $(PROJ).o $(BPLIB)  $(LIBS)

$(PROJ).o:	$(PROJ).h $(PROJ).c $(LIBDIR)/c_defs.h $(LIBDIR)/global.h
	$(CC) -c $(PROJ).c

$(PROJ).h $(PROJ).c:	$(PROJ).pro
	rm -f $(PROJ).c
	$(BINPROLOG) "qmake($(PROJ)),halt"

clean realclean:	oclean
	rm -f *.o *.h *.c *.s *.obj *.exe $(PROJ)

oclean:
	rm -f $(PROJ).o $(PROJ).s $(PROJ).c $(PROJ).h

