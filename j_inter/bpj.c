/************MANDATORY CODE: DO NOT DELETE ******************************/
/* 
   tested with Java 1.2.2 - will not work with later versions
   Sun broke the JNI starting with 1.3 - a Stack Overflow bug 
   see http://developer.java.sun.com/developer/bugParade/bugs/4362291.html
   and they seem reluctant to fix it
*/

#if defined VCCDLL
#define DllImport __declspec(dllimport)
DllImport int bp_main(int argc, char **argv);
#else
extern int bp_main(int argc, char **argv);

/* MAIN FILE: change this if you want to call BinProlog as a DLL */
/* or some other form of dynamically linked library              */

int main(int argc, char **argv) 
{
  return bp_main(argc,argv);
}
#endif

/* code BinProlog will call before after its own initalization process */

#include <jni.h>

#define CLASSPATH_SIZE (1<<14)
#define CLASSNAME_SIZE 1024
#define METHODNAME_SIZE 1024
static JNIEnv *jenv = NULL;
static JavaVM *jvm = NULL;
static char classpath[CLASSPATH_SIZE];
static char classname[CLASSNAME_SIZE];
static char methodname[METHODNAME_SIZE];

int initJVM(char *user_classpath,char *user_classname,char *user_methodname) {
    jint res;
    JavaVMInitArgs vm_args;
    JavaVMOption options[1];
    char *optkey="-Djava.class.path=";
    int optlen=strlen(optkey);
    
    strcpy(classpath,optkey);
    strncat(classpath+optlen,user_classpath,CLASSPATH_SIZE-optlen);
    strncpy(classname,user_classname,CLASSNAME_SIZE);
    strncpy(methodname,user_methodname,METHODNAME_SIZE);
    
    printf("!!! path:class:method=\n%s\n%s\n%s\n",classpath,classname,methodname);
    
    vm_args.version=JNI_VERSION_1_2;
    vm_args.nOptions = 1;
    options[0].optionString = classpath;
    vm_args.options = options;

    /* Create the Java VM */
    res = JNI_CreateJavaVM(&jvm,(void **)&jenv,&vm_args);
    if (res < 0) {
        fprintf(stderr, "Can't create Java VM: %d\n",res);
        return 0;;
    }
    

    return 3;
  }

/**
  releases the Java Machine - not used currently
*/
void killJVM() {
    (*jvm)->DestroyJavaVM(jvm);
}

int call_class_method(char *buf,char *classname,char *methodname) {
  jstring janswer;
  jstring jquery;   
  jclass cls;
  jmethodID jmethod_id;
  const char* cquery=buf;
  const char* canswer;
  /*
	  create Java class handle
  */
  cls = (*jenv)->FindClass(jenv, classname);
  if (cls == 0) {
        fprintf(stderr, "Can't find class <%s>\n",classname);
        return 0;;
  }
  jmethod_id = (*jenv)->GetStaticMethodID(jenv, cls,methodname, 
	  "(Ljava/lang/String;)Ljava/lang/String;"
  );

  /* printf("ENTER: bp_callback_handler: %s\n",buf); */
  
  if (jmethod_id == 0) {
    fprintf(stderr,"method not found in bp_callback_handler: %s\n",methodname);
    return 0;
  }

  jquery=(*jenv)->NewStringUTF(jenv, cquery);
  janswer=(*jenv)->CallStaticObjectMethod(jenv, cls, jmethod_id, jquery);

  /*printf("EXIT janswer: bp_callback_handler: %d\n",janswer);*/
  
  if(NULL==janswer) return 0;
  canswer=(*jenv)->GetStringUTFChars(jenv, janswer, 0);

  /* printf("EXIT canswer: bp_callback_handler: %d\n",canswer); */
 
  if(NULL==canswer) return 0;

  strcpy(buf,canswer);

  /* printf("EXIT: bp_callback_handler: %s\n",buf); */

  return 1;
}

int ask_c_to_ask_java(char *buf) {
  /*printf("GOT: %s\n",buf);*/
  return call_class_method(buf,classname,methodname);	
}

/* YOU SHOULD PROVIDE HERE BOTH init() and main() */

/**************************END OF MANDATORY CODE*************************/


/* USER CODE FOR BinProlog's C-iterface */

/****************************************************************
          STUB in CASE THE C_INTERFACE IS NOT USED

(Real) files using new C-interface (c.pl c.h c.c have been moved to 
directory ../c_inter
*****************************************************************/

#include "global.h"

extern struct specsyms g;

string c_interface="\nCalls Java with ask_jinni(Query,Answer).";

static string c_errmess="c.c (STUB ONLY) : undefined behaviour\n";

/* dummy stubs for C-based builtins */

term if0(register term regs, register term H, register instr P, register term *A, register stack wam)
{
  fprintf(STD_err,"*** %s\n",c_errmess);
  return NULL;
}

term new_builtin(register term H, register term regs, register term *A, register instr P, register stack wam)
{
  fprintf(STD_err,"*** %s\n",c_errmess);
  return NULL;
}

int init_c() {
  /*fprintf(STD_err,"calling init_c ...\n");*/
  g.callback=PTR2INT(ask_c_to_ask_java);
  /* sets default -classpath, class, method */
  return initJVM(".;/bin/prolog.jar","bpj","callj");
}
