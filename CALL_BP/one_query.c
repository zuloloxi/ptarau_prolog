#include "bp_lib.h"

int main(int argc,char *argv[]) {
  void *wam;
  char *query;
  char *answer;
  
  if(load_lib("bp_lib")>0) return 1;
  wam=(*ptr_init_bp)(argc,argv,NULL,NULL);
  if(NULL==wam) return 1;
  query="__X:-member(__X,[10,20])";
  answer=(*ptr_run_bp)(wam,query);
  if(NULL==answer) answer="no";
  printf("query=>%s\nanswer=>%s\n",query,answer);
  free_bp_lib();
  return 0;
}

/* 
OUTPUT when running one_query.exe:

query=>__X^member(__X,[10,20])
answer=>10
*/