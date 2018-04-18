#include "global.h"
#include <string.h>
#include <ctype.h>

				/* ru */
stack create_engine(register stack oldwam, long h, long s, long t);
no destroy_engine(register stack wam);
extern struct specsyms g;
extern struct limit max;
				/* engine */
extern term bp_prolog_call(register term goal, register term regs, register term H,
			   register instr P, register term *A, register stack wam);
extern term bp(register term regs, register term H, register instr P,
	       register term *A, register stack wam);
#ifdef NO_VALUE_TRAIL
extern term *unwind_trail(new0,old)
#else
extern term *unwind_trail(register term *new0, register term *old);
#endif
extern term load_engine(register stack wam, cell goal, cell answer);
extern term ask_engine(register stack wam);
				/* builtins */
extern term local_error(cell xval, string Msg, register stack wam);
extern cell bp_cons(term hd, term tl);
extern term bp_heap_top;
extern term copy_to_engine(register stack wam, register term t);
				/* float */
term make_float(term H, double f);
				/* io */
extern term sread0(term H, string s);
extern string swrite(cell xval, stack wam);
				/* sym */
extern string *atomtable,lextable,newlex;
extern no newatom;
				/* dict */
extern no hcount;
extern no hget(register no pred, register no fun);
extern no hset(register no pred, register no fun, register no val);
extern no hdef(register no pred, register no fun, register no val, byte stamp);

typedef unsigned int half; /* from float.c */
double ints_to_double(half i1, half i2, half i3);

#define BP_op OUTPUT_INT(X(1))
#define BP_input X(2)
#define BP_result X(3)

#define BP_fail() return NULL

#define BP_is_integer(Cell) INTEGER(Cell)
#define BP_is_var(Cell) VAR(Cell)
#define BP_is_atom(Cell) SYMCONST(Cell)
#define BP_is_nonvar(Cell) NONVAR(Cell)
#define BP_is_compound(Cell) COMPOUND(Cell)
#define BP_is_float(Cell) BP_FLOAT(Cell)
#define BP_is_number(Cell) NUMERIC(Cell)
#define BP_is_number(Cell) NUMERIC(Cell)
#define BP_is_list(Cell) IS_LIST(Cell)

#define BP_atom(Name) input_fun((Name),0)
#define BP_functor(Name,Arity) input_fun((Name),Arity)
#define BP_integer(Int) INPUT_INT((Int))
#define BP_funptr(Ptr) PTR2INT((Ptr))
#define BP_make_float(Var,FVal) {(Var)=(cell)H; H=make_float(H,(FVal));}
#define BP_string(Name) BP_atom((Name))

#define BP_begin_cons() bp_heap_top=H
#define BP_cons(Car,Cdr) bp_cons((term)Car,(term)Cdr)
#define BP_nil g.NIL
#define BP_end_cons() H=bp_heap_top;

#define BP_put_new_var(Var) (Var)=(cell)(SETREF(H,H),H++)
#define BP_put_old_var(Var) {SETREF(H,Var);H++;}

#define BP_begin_put_list(Result) (Result)=(cell)H
#define BP_put_list(Element) PUSH_LIST((cell)(Element))
#define BP_end_put_list() PUSH_NIL()

#define BP_put_functor(Result,Name,Arity) \
  {(Result)=(cell)H; SETREF(H,BP_functor((Name),(Arity))); H++;}

#define BP_put_arg(Element) {SETREF(H,(Element)); H++;}

#define BP_get_args(ARGV,ARGC) {ARGV=BP_input; ARGC=GETARITY(BP_input);}

#define BP_get_integer(From,IVar) IVar=OUTPUT_INT(From)
#define BP_get_string(From,SVar) SVar=NAME(From)
#define BP_get_float(From,FVar,Ok) {\
  term ref=(term)(From); cell val=GETREF(ref);\
  Ok=1;\
  if(BP_is_float(val))\
    FVar=ints_to_double((half)(ref[1]),(half)(ref[2]),(half)(ref[3]));\
  else\
    Ok=0;\
}
#define BP_sread(String,Cell)  \
{ cell xval; \
  string s=(string)XALLOC(1+strlen(String),char); \
  strcpy(s,(String)); \
  xval=(cell)sread0(H,s); \
  free(s); \
  if(!xval) return NULL;    \
  Cell=xval; H=(term)xval+1; \
 }

#define BP_swrite(Term) swrite((Term),wam)

#define BP_get_simple(From,VoidVar) {\
if(BP_is_integer(From)) {\
  int iii; \
  BP_get_integer(From,iii);\
  *(int *)(VoidVar)=iii;\
  }\
else if(BP_is_atom(From)) {\
  string sss=NULL;\
  BP_get_string(From,sss);\
  *(string *)(VoidVar)=sss;\
  }\
else if(BP_is_var(From)) {\
  int okkk;double ddd;\
  BP_get_float(From,ddd,okkk);\
   *(double *)(VoidVar)=ddd;\
  }\
else {/*do nothing*/}\
}

static void **BP_get_list(cell from, int argc, void *argv[]) {
        if(!BP_is_var(from)) BP_fail();
        { term ref=(term)from;
          cell val=GETREF(ref);
          int i; void *p;
          for(i=0;i<argc;i++) {
            term xref; cell xval;
      
            if(BP_nil==val) break;
            if(!BP_is_list(val)) BP_fail();
            FDEREF(ref+1);
            p=argv[i];
            if(BP_is_compound(xval)) val=(cell)xref; else val=xval;
            BP_get_simple(val,p);

            FDEREF(ref+2);
            ref=xref;
            val=xval;
          }
          
          if(i!=argc) BP_fail(); /* number of args mismatch! */
        }
        return argv;
}

#define BP_check_call() \
if(!BP_is_integer(X(1))) \
    return LOCAL_ERR(X(1), \
      "op-code of C-function must be an integer");\
BP_result=BP_input;

#define BP_prolog_call(Goal) \
{ cell RegBuffer[TEMPARGS+MAXREG]; \
  register term newregs=RegBuffer+TEMPARGS; \
  if(!(H=bp_prolog_call((term)(Goal),newregs,H,P,A,wam))) BP_fail(); \
}

/* NEW: Abstract engine manipulation macros */

#define BP_create_engine(ParentWam,HeapSize,StackSize,TrailSize)\
    create_engine(ParentWam,HeapSize,StackSize,TrailSize)

#define BP_destroy_engine(Wam) {if(!destroy_engine(Wam)) return NULL;}

#define BP_load_engine(Wam,Goal,Answer) \
if(!load_engine(Wam,Goal,Answer)) return NULL;

#define BP_ask_engine(Wam) ask_engine(Wam)


#define BP_copy_answer(Cell) \
{ \
  (Cell)=(cell)copy_to_engine(wam,(term)(Cell)); \
  if(!(Cell)) return NULL; \
  H=(term)wam[HeapStk].top; \
}

/*****  simple BinProlog reader in C: Lexer + Perser *******/

#define MAXARGS MAXARITY

static string cursor;
extern term bp_heap_top;

extern cell input_fun (string name, no arity);
extern cell bp_cons (term hd, term tl);
extern void warnmes (string mes);
extern cell new_func (string name, no argctr);
extern term make_float(term H, double f);

int match_term (term t);

static cell make_funcell(string from, string to, int arity)
{ cell t; 
  char c= *to; *to='\0';
  t=input_fun(from,arity);
  *to=c;
  return t;
}

static term make_term(string from, string to, int arity)
{ term oldtop=bp_heap_top;
  SETCELL(bp_heap_top++,make_funcell(from,to,arity));
  bp_heap_top+=arity;
  return oldtop;
}

static cell make_float_term(string from, string to)
{ 
  double f; char c; int ok;
  term t=bp_heap_top;
  c=*to; *to='\0';
  ok=sscanf(from,"%lg",&f);
  *to=c;
  if(!ok) return 0;
  bp_heap_top=make_float(t,f);
  return T2C(t);
}


/*********************** LEXICAL ANALYSER *********************/

#define SKIP_SPACE() while(isspace(*cursor)) ++cursor

#define IF(Test) (Test)? ++cursor : 0

#define ALNUM()  IF(isalnum(*cursor) || '_'==*cursor)

#define UPPER() IF(isupper(*cursor) || '_' == *cursor)

#define LOWER() IF(islower(*cursor) || '$'== *cursor)

#define PUNCT() IF(ispunct(*cursor)&& \
'$'!= *cursor && ','!= *cursor && '('!=*cursor && ')'!=*cursor)

#define DIGIT() IF(isdigit(*cursor))

/****************************** PARSER ****************************/
/* (actually a way to translate DCGs to C, for lazy programmers)  */

static int match_sym(string *from, string *to)
{
  *from=cursor;
  SKIP_SPACE();
  if(LOWER())
    { while(ALNUM());
      *to=cursor;
      return TRUE;
    }
  else if(PUNCT())
    { 
      *to=cursor;
      return TRUE;
    }
  else
    { cursor= *from;
      return FALSE;
    }
}

static int match_var(string *from, string *to)
{
  *from=cursor;
  SKIP_SPACE();
  if(UPPER())
    { while(ALNUM());
      *to=cursor;
      return TRUE;
    }
  else
    { cursor= *from;
      return FALSE;
    }
}

static int match_int(string *from, string *to)
{
  *from=cursor;
  SKIP_SPACE();
  if(DIGIT())
    { while(DIGIT());
      *to=cursor;
      return TRUE;
    }
  else
    { cursor= *from;
      return FALSE;
    }
}

static int match_char(char c)
{
  SKIP_SPACE();
  if(c!=*cursor) return FALSE;
  ++cursor;
  return TRUE;
}

static int match_args(int *pctr, cell *argvect)
{ int ok=TRUE;
  if(match_char(')'));
  else if(match_char(','))
    {
      ok=match_term(argvect++);
      if(ok)
        { ++(*pctr);
          ok=match_args(pctr,argvect);
        }
    }
  else
    ok=FALSE;
  return ok;
}

static int match_list_elements(term t)
{ int ok=TRUE;
  cell hd,tl;
  SETCELL(t,g.NIL);
  if(match_char(']')) ;
  else if(match_char('|'))
    {
      ok=match_term(&hd) && match_char(']');
      if(ok) SETREF(t,hd);
    }
  else if(match_char(','))
    { ok=match_term(&hd) && match_list_elements(&tl);
      if(ok) SETREF(t,bp_cons(C2T(hd),C2T(tl)));
    }
  else
    ok=FALSE;
  return ok;
}

int match_term(term t)
{ int ok=TRUE;
  string from,to;

  if(match_char('['))
    if(match_char(']'))
      SETCELL(t,g.NIL);
    else
      { cell hd,tl;
        ok=match_term(&hd) && match_list_elements(&tl);
        if(ok) SETREF(t,bp_cons(C2T(hd),C2T(tl)));
      }
  else if(match_var(&from,&to))
     {  SETCELL(t,make_funcell(from,to,0));
     }
  else if(match_int(&from,&to))
     {  string from1,to1;
        if(match_char('.') && match_int(&from1,&to1))
          {
            SETCELL(t,make_float_term(from,to1));
          }
        else
         SETCELL(t,make_funcell(from,to,0));
     }
  else if(match_sym(&from,&to))
      if(match_char('('))
        { cell first;
          ok=match_term(&first);
          if(ok)
            { int argctr=1; cell argvect[MAXARGS];
              argvect[0]=first;
              ok=match_args(&argctr,argvect+1);
              if(ok)
                { int i; term v=make_term(from,to,argctr);
                  SETREF(t,v);
                  for(i=1; i<=argctr; i++)
                    SETREF(v+i,argvect[i-1]);
                }
            }
        }
      else
        SETCELL(t,make_funcell(from,to,0));
  else
    ok=FALSE;
  return ok;
}

term sread0(term H, string s)
         
            /* the source string comes from here */
{ cell v;
  cursor=s; 
  bp_heap_top=H;
  if(!match_term(&v)) return 0;
  SETCELL(bp_heap_top,v);
  return bp_heap_top;
}

cell sread(term H, cell xval)
         
             /* the source string comes from here */
{ 
  if(!SYMCONST(xval)) return 0L;
  return (cell)sread0(H,NAME(xval));
}

