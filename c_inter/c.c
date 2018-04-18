/************MANDATORY CODE: DO NOT DELETE ******************************/

/* YOU SHOULD PROVIDE HERE BOTH init() and main() */

/* code BinProlog will call before after its own initalization process */

int init_c() {
  return 1;
}

/* MAIN FILE: change this if you want to call BinProlog as a DLL */
/* or some other form of dynamically linked library              */

int main(int argc, char **argv) {
  extern int bp_main(int argc, char **argv);
  return bp_main(argc,argv);
}

/**************************END OF MANDATORY CODE*************************/


/* USER CODE FOR BinProlog's C-interface */

#include "c.h"

char *c_interface="(with C-interface)\n";

/* ADD YOUR INITIALISATION CODE HERE */

/* CALLING BinProlog from C ******************************************/

/* simple example of prolog call */
term if0(regs,H,P,A,wam)
  register term regs,H,*A;
  register instr P;
  register stack wam;
{ term OldH,bp();
  cell goal=regs[1];
  cell then_cont=regs[2];
  cell else_cont=regs[3];
  cell cont=regs[4]; /* save continuation */


  /* In this example the input GOAL is in regs[1].
     Of course, you can build it yourself directly in C.
     If you are NOT SAVING (as a caller) your useful registers here,
     use the more expensive but safe BP_prolog_call(goal)
     which allocates a new set of them. This is OK if you return
     from BP_prolog_call but is a cummulative expense if you
     have mutually recursive Prolog and C calls. In this case,
     it is better to use the "caller saves registers" protocol, as the
     cost of embedded calls is reduced to their actual heap consumption.
  */

  H=bp_prolog_call((term)goal,regs,(OldH=H),P,A,wam); 

#if TRACE>1
  fprintf(stderr,"returning from New WAM\n");
#endif

  if(H) 
     { 
#if TRACE>1
       fprintf(STD_err,"success:\n");
#endif
       regs[1]=then_cont;
     }
  else 
     {

#if TRACE>1
    fprintf(STD_err,"failing:\n");
#endif
       regs[1]=else_cont;
       H=OldH;
     };

  /* do not forget this !!! */

  regs[2]=cont; /* restore continuation */

  return H; /* return NULL to signal failure */
}


/* ADD YOUR NEW BUILTINS HERE

   they can be called from Prolog as:
   new_builtin(0,<INPUT_ARG>,<OUTPUT_ARG>)
   
   X(1) contains the integer `opcode' of your builtin
   X(2) contains your input arg
   regs[I] contains somthing that will be unified with what you return
      (the precise value of I depends on the register allocator).

   You are expected to `return' either 
    - a non-null object that will be unified with <OUTPUT_ARG>, or
    - NULL to signal FAILURE

   As the returned object will be in a register this
   can be used for instance to add a garbage collector
   that moves every data area around...

*/

/**
  simple function to be called from BinProlog
*/
int sfun(char *s) {
   char buf[100];
   sprintf(buf,"=> CALLED sfun(char *) at %ld!",(unsigned long)sfun);
   strcat(s,buf);
   return 1;
}

/**
  simple float function to be called from BinProlog
*/
double ffun(double d) {
   char buf[100];
   sprintf(buf,"=> CALLED double<-ffun(double d) at %ld!",(unsigned long)ffun);
   return d*2.5;
}

term new_builtin(register term H,register term regs,register term *A,register instr P,register stack wam) {
   BP_check_call(); 
   switch(BP_op)
  { 
    /* for beginners ... */

    case 0: 
       /* this just returns your input argument (default behavior) */
    break;

    case 1: 
      BP_result=BP_integer(13); /* this example returns 13 */
    break;

    case 2: 
      BP_result=BP_atom("hello"); /* this example returns 'hello' */
    break;

    /* for experts ... */

    case 3: /* iterative list construction */
    { cell middle,last,F1,F2; int i;
      BP_make_float(F1, 77.0/2);
      BP_make_float(F2, 3.14);

      BP_begin_put_list(middle);
         BP_put_list(BP_integer(33));
         BP_put_list(F1);
         BP_put_list(BP_string("hello"));
         BP_put_list(F2);
      BP_end_put_list();
 
      BP_begin_put_list(last);
        for(i=0; i<5; i++) {
          BP_put_list(BP_integer(i));
        }
      BP_end_put_list();
      
      BP_begin_put_list(BP_result);
        BP_put_list(BP_string("first"));
        BP_put_list(middle);
        BP_put_list(last);
        BP_put_list(F1);
        BP_put_list(F2);
      BP_end_put_list(); 
    } break;

    case 4: /* cons style list construction */
      BP_begin_cons();
      BP_result=
       BP_cons(
          BP_integer(1),
          BP_cons(
               BP_integer(2),
               BP_nil
          )
       );
      BP_end_cons();
    break;

    case 5: /* for hackers only ... */ ;
      BP_result=(cell)H;

      H[0]=g.DOT;
      H[1]=X(2);

      H[2]=g.DOT;
      H[3]=BP_integer(99);

      H[4]=g.DOT;
      H[5]=(cell)(H+5); /* new var */

      H[6]=g.DOT;
      H[7]=(cell)(H+5); /* same var as previously created */

      H[8]=g.DOT;
      H[9]=BP_atom("that's it");

      H[10]=g.NIL;
      H+=11;
    break;

    case 6:
      BP_fail();
    break;

    case 7: 
      {  cell T=BP_input;
         if(BP_is_integer(T))
            {int i;
             BP_get_integer(T,i);
             fprintf(g.tellfile,"integer: %ld\n",i);
             BP_result=BP_integer(-1);
            }
         else
            BP_fail();         
      } 
    break;

   case 8: /* for experts: calling BinProlog from C */
      { cell L,R,Goal;
        
        BP_begin_put_list(L);
          BP_put_list(BP_string("one"));
          BP_put_list(BP_integer(2));
          BP_put_list(BP_string("three"));
          BP_put_list(BP_input); /* whatever comes as input */
        BP_end_put_list();
  
        BP_put_functor(Goal,"append",3);
        BP_put_old_var(L);
        BP_put_old_var(L);
        BP_put_new_var(R);        

        BP_prolog_call(Goal); /* this will return NULL on failure !!!*/

        BP_put_functor(Goal,"write",1);
        BP_put_old_var(R);    

        BP_prolog_call(Goal); /* calls write/1 */

        BP_put_functor(Goal,"nl",0);

        BP_prolog_call(Goal); /* calls nl/0 */

        BP_result=R; /* returns the appended list to Prolog */

      }
      break;

    case 10: /* for experts: calling BinProlog from C */
      { cell L,R,Goal;
        
        BP_begin_put_list(L);
          BP_put_list(BP_string("one"));
          BP_put_list(BP_integer(2));
          BP_put_list(BP_string("three"));
          BP_put_list(BP_input); /* whatever comes as input */
        BP_end_put_list();
  
        BP_put_functor(Goal,"cut_test",3); /* see c.pl */
        BP_put_old_var(L);
        BP_put_old_var(L);
        BP_put_new_var(R);        

        BP_prolog_call(Goal); /* this will return NULL on failure !!!*/

        BP_put_functor(Goal,"write",1);
        BP_put_old_var(R);    

        BP_prolog_call(Goal); /* calls write/1 */

        BP_put_functor(Goal,"nl",0);

        BP_prolog_call(Goal); /* calls nl/0 */

        BP_result=R; /* returns the appended list to Prolog */

      }
      break;

   case 11: /* CALLING BinProlog on a NEW ENGINE */
      { stack Engine;
        cell Goal,Answer;
        cell Xs,X;
        
        BP_begin_put_list(Xs);
          BP_put_list(BP_string("new_engine_test"));
          BP_put_list(BP_input); /* whatever comes as input */
          BP_put_list(BP_integer(100));
          BP_put_list(BP_integer(200));
          BP_put_list(BP_integer(300));
        BP_end_put_list();
  
        BP_put_functor(Goal,"member",2);
        BP_put_new_var(X);        
        BP_put_old_var(Xs);

        Engine=BP_create_engine(wam,100,50,50);

        BP_load_engine(Engine,Goal,X);

        while((Answer=(cell)ask_engine(Engine)))
          { cell Goal1;

            BP_put_functor(Goal1,"write",1);
            BP_put_old_var(Answer);    

            BP_prolog_call(Goal1); /* calls write/1 */

            BP_put_functor(Goal1,"nl",0);

            BP_prolog_call(Goal1); /* calls nl/0 */

          }
        BP_destroy_engine(Engine);
        BP_result=Goal; /* returns the goal - just for tracing */
      }
      break;

  case 12: /* CALLING BinProlog on a NEW ENGINE. The friendliest way... */
      { stack Engine;
        cell Goal,Answer;
        cell Xs,X;
 
        BP_sread("[0,s(0),s(s(0)),[a,b,c]]",Xs);
         
        BP_put_functor(Goal,"member",2);
        BP_put_new_var(X);        
        BP_put_old_var(Xs);

        Engine=BP_create_engine(wam,100,50,50);

        BP_load_engine(Engine,Goal,X);

        printf("BP_input: = %s\n",BP_swrite(BP_input));  

        while((Answer=(cell)ask_engine(Engine)))
          { 
             printf("Answer = %s\n",BP_swrite(Answer));
          }
        BP_destroy_engine(Engine);
        BP_result=Goal; /* returns the goal - just for tracing */
      }
      break;


  case 13: /* CALLING BinProlog on a NEW ENGINE. The friendliest way... */
      { stack Engine; int i;
        cell Goal,Answer,Answers[4],Ys;
        cell Xs,X;
 
        BP_sread("[0,s(0),s(s(0)),[a,b,c]]",Xs);
         
        BP_put_functor(Goal,"member",2);
        BP_put_new_var(X);        
        BP_put_old_var(Xs);

        Engine=BP_create_engine(wam,100,50,50);

        BP_load_engine(Engine,Goal,X);

        /* accumulates the answers */

        for(i=0; Answer=(cell)ask_engine(Engine); i++)
            { 
              /* To survive failure in Engine !!!! 
                 After copying, Answer will point to a valid object on 
                 the calling engine's heap whose H is also updated (see
                 BP_copy_answer in c.h). 
              */
              BP_copy_answer(Answer);
              Answers[i]=Answer; 
            }
        BP_destroy_engine(Engine);

        /* prints out the accumulated answers */

        printf("BP_input: = %s\n",BP_swrite(BP_input));
        BP_begin_put_list(Ys);
        for(i=0; i<4; i++)
            { 
               printf("Answers[%d] = %s\n",i,BP_swrite(Answers[i]));
               BP_put_list(Answers[i]); /* to return them to Prolog */
            }
        BP_end_put_list();       
        BP_result=Ys; /* returns the list of answers, Ys,
                         after constructing it on the heap */
      }
      break;

      /**
        Calls a string transformer function from BinProlog:
        sfun gets a char * argument which it modifies at will.
        Signals succes with 1, failure with 0
      */
      case 14:
        BP_result=BP_funptr(sfun);
      break;
      
      /**
        Calls a C function with an int or float argument
        and returns a float result
      */
      case 15: {  
         double d;
         if(BP_is_integer(BP_input)) {
            int i;
            BP_get_integer(BP_input,i);
            d=(double)i;
         }
         else if(BP_is_atom(BP_input)) { // it means ref to a BP_FLOAT
            char *s=NULL;
            BP_get_string(BP_input,s);
            d=atof(s);
         }
         else if(BP_is_var(BP_input)) { // it means ref to a BP_FLOAT
            int ok;
            BP_get_float(BP_input,d,ok);
            if(!ok) {
              printf("not a float: = %s\n",BP_swrite(BP_input));  
              BP_fail();
            }
         }
         else  /* this returns with failure */ {
            printf("BAD BP_input: = %s\n",BP_swrite(BP_input));
            BP_fail();
         }
            
         /* compute results */   
         {  double r=ffun(d);
            BP_make_float(BP_result,r);
         }
      } 
      break;

      /*
        getting any simple (int,double,string) data from
        prolog - the C side trusts that Prolog sends
        the right data - which isconverted
        automatically based on its dynamic Prolog type
      */
      case 16: {
       if(0)
        { string s=NULL;
          void *p=(void*)&s; 
          BP_get_simple(BP_input,p);
          if(NULL==s) BP_fail();
          printf("got string = %s\n",s);
          BP_result=BP_atom(s);
        }
        else { 
          double d;
          void *p=(void*)&d; 
          BP_get_simple(BP_input,p);
          printf("got double = %f\n",d);
          BP_make_float(BP_result,d+1);
        }        
      } 
      break;
      
      /*
        getts a list of known length, applies
        to the a function of type int f(void **) 
        of simple args and returns an int
        a list like [hello,3.14,2003] will
        need argc=0 and argv should have the address
        of variable of APPROPRIATE types. Conversion
        of data is automatic but we trust YOU to provide
        the right containers in C !!!
      */
      case 17: {
        string s;
        double d;
        int i,n;
        int argc=3;
        void *argv[3] ={(void*)&s,(void*)&d,(void*)&i};
        if(NULL==BP_get_list(BP_input,argc,argv)) BP_fail();
        printf("got from prolog list: %s, %f, %d\n",s,d,i);
        BP_result=BP_integer(i);
      } 
      break;
      
     /* EDIT AND ADD YOUR CODE HERE....*/

    default:
     return LOCAL_ERR(X(1),"call to unknown user_defined C function");
  }
  return H; 
}



