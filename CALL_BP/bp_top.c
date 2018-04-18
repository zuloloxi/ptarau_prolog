#include "bp_lib.h"

/* MAIN FILE: change this if you want to call BinProlog as a DLL */
/* or some other form of dynamically linked library              */

/** 
   creates and initializes BinProlog wam engine,
   passes to it command line args and I/O streams 
*/
void *new_bp(int argc,char *argv[]) {
  return (*ptr_init_bp)(argc,argv,NULL,NULL);
}

char *new_bp_engine(void *wam) {
  return strdup((*ptr_run_bp)(wam,"Handle:-create_engine(2000,1000,1000,Handle)"));
}

#define MAX_QLEN 2048
#define MAX_ANSWERS 256

int main(int argc,char *argv[]) {

  int retcode;
  void *wam;
  char query[MAX_QLEN],line[MAX_QLEN];
  char *answer;
  char *engine;

  retcode=load_bp_lib();
  if(retcode>0) return retcode;
 
    /* 
       creates and initializes BinProlog's abstract machine
       passes to it command line args and I/O streams 
    */
    wam=new_bp(argc,argv);
    if(NULL==wam) return 94;

    printf("%s\n","CREATING BinProlog");

    /* creates new BinProlog engine */
    engine=new_bp_engine(wam);
    if(NULL==engine) return 95;

    printf("%s%s\n","STARTING engine: ",engine);
    for(;;) {
      /* do some query/answer interactions then stop */
 
      printf("%s","?-- ");fflush(stdout);
      fflush(stdin); if(!gets(line) || 0==strlen(line)) break;

      sprintf(query,
        "__Vs:-eq(__S,%s%s%s),sread(__S,__G,__Vs),load_engine(%s,metacall(__G),__Vs)",
        "'",line,"'",engine); /* $$ bug - the parser does not handle quoted strings */
  
      printf("%s%s=>%s\n","ASKING engine: ",engine,query);

      answer=(*ptr_run_bp)(wam,query);
      if(NULL==answer) return 96;

      { int i;
        for(i=0;i<MAX_ANSWERS;i++) {
          sprintf(query,"__Xs:-ask_engine(%s,__Xs)",engine);
          answer=(*ptr_run_bp)(wam,query);
          if(NULL==answer) break;
          if(0==strcmp(answer,"no")) break;
          printf("answer(%d)=> %s\n",i,answer);
        }
      }
      printf("No (more) answers\n");
    }

    sprintf(query,"destroy_engine(%s)",engine);
    answer=(*ptr_run_bp)(wam,query);
    if(NULL==answer) return 97;

    /*
      free DLL resources
    */

    FreeLibrary(dll);

    retcode=0;

  return retcode;
}

