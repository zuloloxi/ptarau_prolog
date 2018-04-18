#include <stdio.h>
#include <WINDOWS.h>

/* BinProlog DLL export types */

/* basic: runs BinProlog toplevel directly: see hello.c, hello.pro */
typedef int (* BP_MAIN_TYPE)(int argc, char **argv);

/* advanced: used to start BinProlog, then query it repeatedly */
typedef void* (* INIT_BP_TYPE)(int argc, char **argv, FILE* bp_stdin, FILE* bp_stdout);
typedef char* (* RUN_BP_TYPE)(void *wam, char *query);

static INIT_BP_TYPE ptr_init_bp;
static RUN_BP_TYPE ptr_run_bp;
static   HINSTANCE dll;

static void free_bp_lib() {
  FreeLibrary(dll);
}

static int load_lib(char *libname) {

  dll=LoadLibrary(libname);
  if(NULL==dll) {
    perror("BinProlog library not found");
    return 91;
  }

  ptr_init_bp=(INIT_BP_TYPE)GetProcAddress(dll,"init_bp");
  if(NULL==ptr_init_bp) {
    perror("init_bp not found in library");
    free_bp_lib(dll);
    return 92;
  }

  ptr_run_bp=(RUN_BP_TYPE)GetProcAddress(dll,"run_bp");
  if(NULL==ptr_run_bp) {
    perror("run_bp not found in library");
    free_bp_lib(dll);
    return 93;
  }

  return 0; /* means ok */
}

static int load_bp_lib() {
   return load_lib("bp_lib");
}
