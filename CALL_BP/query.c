#include <stdio.h>
#include <WINDOWS.h>

/* BinProlog DLL export types */

/* basic: runs BinProlog toplevel directly: see hello.c, hello.pro */
typedef int (* BP_MAIN_TYPE)(int argc, char **argv);

/* advanced: starts BinProlog, then quieries it repeatedly */
typedef void* (* INIT_BP_TYPE)(int argc, char **argv, FILE* bp_stdin, FILE* bp_stdout);
typedef char* (* RUN_BP_TYPE)(void *wam, char *query);

/* MAIN FILE: change this if you want to call BinProlog as a DLL */
/* or some other form of dynamically linked library              */

int main(int argc,char *argv[]) {

  HINSTANCE dll;
  INIT_BP_TYPE ptr_init_bp;
  RUN_BP_TYPE ptr_run_bp;

  dll=LoadLibrary("bp_lib");
  if(NULL==dll) {
    perror("bp_lib.dll not found");
    return 91;
  }

  ptr_init_bp=(INIT_BP_TYPE)GetProcAddress(dll,"init_bp");
  if(NULL==ptr_init_bp) {
    perror("init_bp not found in bp_lib");
    FreeLibrary(dll);
    return 92;
  }

  ptr_run_bp=(RUN_BP_TYPE)GetProcAddress(dll,"run_bp");
  if(NULL==ptr_run_bp) {
    perror("run_bp not found in bp_lib");
    FreeLibrary(dll);
    return 93;
  }

  { void *wam;
    char *query;
    char *answer;
    
    /* 
       creates and initializes BinProlog wam engine,
       passes to it command line args and I/O streams 
    */
    wam=(*ptr_init_bp)(argc,argv,NULL,NULL);
    if(NULL==wam) return 94;

    /* do some query/answer interactions then stop */
     
    query="X:-for(X,1,5),>(X,2)";
    answer=(*ptr_run_bp)(wam,query);
    if(NULL==answer) answer="no";
    printf("query=>%s\nanswer=>%s\n",query,answer);

    query="*(I,for(I,1,10))";
    answer=(*ptr_run_bp)(wam,query);
    if(NULL==answer) answer="no";
    printf("query=>%s\nanswer=>%s\n",query,answer);

    query="*(:(2,X),member(X,[a,b,c,d]))";
    answer=(*ptr_run_bp)(wam,query);
    if(NULL==answer) answer="no";
    printf("query=>%s\nanswer=>%s\n",query,answer);

    /*
      free DLL reseources
    */
    FreeLibrary(dll);

    return 0;
  }
}

