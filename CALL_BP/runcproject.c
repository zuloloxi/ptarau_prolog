#include "bp_lib.h"

int main(int argc,char *argv[]) {
  void *wam;
  char *query;
  char *answer;

  if(load_lib("cproject")>0) return 1;

  /* instead of argc, argv command line args - we set up ours here */
  {
    int my_argc=3; 
    char *my_argv[]={
      argv[0],                          /* passes arg[0] as such */
      "call((println(hello)))",         /* goal to be pased to BinProlog */
      "-q2",                            /* level of 'quietness'; more/less output' */
      NULL
    };
    wam=(*ptr_init_bp)(my_argc,my_argv,NULL,NULL);
    if(NULL==wam) return 1;
  }

  query="__X:-member(__X,[10,20])";
  answer=(*ptr_run_bp)(wam,query);
  if(NULL==answer) answer="no";
  printf("query=>%s\nanswer=>%s\n",query,answer);
 
  query="assert(a(newly_asserted(3)))";
  answer=(*ptr_run_bp)(wam,query);

  query="Xs:-findall(X,a(X),Xs)";
  answer=(*ptr_run_bp)(wam,query);
  if(NULL==answer) answer="no";
  printf("query=>%s\nanswer=>%s\n",query,answer);
 
  //query="main";
  //answer=(*ptr_run_bp)(wam,query);

  free_bp_lib();
  return 0;
}

