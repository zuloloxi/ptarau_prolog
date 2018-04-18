#include "bp_lib.h"

int main(int argc,char *argv[]) {
  void *wam;
  char *query;
  char *answer;
  
  if(load_bp_lib()>0) return 1;
  wam=(*ptr_init_bp)(argc,argv,NULL,NULL);
  if(NULL==wam) return 1;
  query="done:-call_ifdef(main,toplevel)";
  answer=(*ptr_run_bp)(wam,query);
  if(NULL==answer) answer="no";
  printf("=%s\n",answer);
  free_bp_lib();
  return 0;
}
