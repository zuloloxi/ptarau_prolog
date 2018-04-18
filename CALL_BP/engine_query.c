#include "bp_lib.h"

/* MAIN FILE: change this if you want to call BinProlog as a DLL */
/* or some other form of dynamically linked library              */

int main(int argc,char *argv[]) {

  int retcode=load_bp_lib();
  if(retcode>0) return retcode;
 
  { void *wam;
    char query[255];
    char *answer;
    char *engine;
    /* 
       creates and initializes BinProlog wam engine,
       passes to it command line args and I/O streams 
    */
    wam=(*ptr_init_bp)(argc,argv,NULL,NULL);
    if(NULL==wam) return 94;

    /* do some query/answer interactions then stop */

    sprintf(query,"Handle:-create_engine(2000,1000,1000,Handle)");

    engine=(*ptr_run_bp)(wam,query);
    if(NULL==engine) return 95;

    sprintf(query,"X:-load_engine(%s,member(X,[1,2,3]),X)",engine);
    answer=(*ptr_run_bp)(wam,query);
    if(NULL==answer) return 96;
    printf("query=>%s\nanswer=>%s\n",query,answer);

    { int i;
      for(i=0;i<10;i++) {
        sprintf(query,"X:-ask_engine(%s,X)",engine);
        answer=(*ptr_run_bp)(wam,query);
        if(NULL==answer) break;
        printf("query=>%s\nanswer=>%s\n",query,answer);
      }
    }

    sprintf(query,"destroy_engine(%s)",engine);
    answer=(*ptr_run_bp)(wam,query);
    if(NULL==answer) return 97;
    printf("query=>%s\nanswer=>%s\n",query,answer);

    /*
      free DLL resources
    */

    FreeLibrary(dll);

    retcode=0;
  }

  return retcode;
}

