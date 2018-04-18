typedef int (* BP_MAIN_TYPE)(int argc, char **argv);

#include <stdio.h>
#include <WINDOWS.h>

/*
#define F_CALL(Fun,Args)  ( (int (*)())(Fun))Args
*/

/* MAIN FILE: change this if you want to call BinProlog as a DLL */
/* or some other form of dynamically linked library              */

int main(int argc,char *argv[]) {
  /* begin editable: adapt this */
  int my_argc=3; 
  char *my_argv[]={
    argv[0],                          /* passes arg[0] as such */
    "call((consult(hello),go,halt))", /* goal to be pased to BinProlog */
    "-q6",                            /* high level of 'quietness'; minimal output' */
    NULL
  }; 
  /* end editable */

  HINSTANCE dll;
  BP_MAIN_TYPE ptr_bp_main;
  int code;

  dll=LoadLibrary("bpr_lib");
  if(NULL==dll) {
    perror("bp_lib.dll not found");
    return 91;
  }
  
  /* ptr_bp_main=(BP_MAIN_TYPE)GetProcAddress(dll,"_bp_main@8");*/

  ptr_bp_main=(BP_MAIN_TYPE)GetProcAddress(dll,"bp_main");

  if(NULL==ptr_bp_main) {
    perror("bp_main not found in bp_lib");
    FreeLibrary(dll);
    return 92;
  }
  code=(*ptr_bp_main)(my_argc,my_argv);
  FreeLibrary(dll);
  return code;
}

