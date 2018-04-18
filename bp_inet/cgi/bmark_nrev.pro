:-['../library/cgi_lib'].

main:-start.

%main:-test.

start:-run_cgi(body).

body:-
  get_cgi_input([
   iterations=Is,
   length=Ls,
   threads=Ts,
   comment=Cs
  ]),
  get_in_range('Iterations',Is,200,400,I),
  get_in_range('List length',Ls,100,500,L),
  get_in_range('Threads',Ts,1,5,T),
  name(Comment,Cs),
  run_bm(I,L,T,Comment,'bmarks.txt'), 
  toBinNet.

test:-
  I=300,
  L=300,
  T=3,
  run_bm(I,L,T,'testing','bmarks.txt').

  
run_bm(I,L,T,Comment,File):-
  abstime(Abs),
  println('BinProlog running NREV on a Pentium III 933MHz'),
  Log=bmark(nrev,Abs,iterations(I),length(L),threads(T),comment(Comment)),
  println(Log),
  % tell_at_end(File),pp_clause(Log),told,
  findall(Tid,launch_one(I,L,T,Tid),Tids),
  forall(member(Tid,Tids),thread_join(Tid)),
  local_all(result(_,_,_,_),Rs),
  local_all(KL,result(_,_,_,klips(KL)),KLs),
  foldl(+,0,KLs,KLips),
  htest(L,H,Tr,S),
  write('<b>'),nl,
   forall(member(R,Rs),println(R)),
   forall(
    member(Line,
    [
     iterations=I,length=L,
     heap=H,trail=Tr,stack=S,
     kLIPS=KLips
    ]),
    println(Line)
   ),
  write('</b>'),nl.


launch_one(I,L,HowMany,Thread):-
  for(J,1,HowMany),
      bg((
         bm(I,L,ETime,KLips),
         current_engine_thread(Th),
         local_out(result(J,thread(Th),time(ETime),klips(KLips)))
         ),
         Thread
      ).

go(Mes,It, Len):-
	bm(It,Len,T,L),
	htest(Len,H,Tr,S),
      write('<b>'),
	nl,write(Mes=[klips=L,time=T,iterations=It,length=Len,
                      heap=H,trail=Tr,stack=S]),
      write('<b>'),nl.

% NREV benchmark
% -----------------------------------------------------------------

app([],Ys,Ys).
app([A|Xs],Ys,[A|Zs]):-
  app(Xs,Ys,Zs).

nrev([],[]).
nrev([X|Xs],R):-
  nrev(Xs,T),
  app(T,[X],R).

full_range(It,L):- range(_,1,It),nrev(L,_), fail.
full_range(_,_).

dummy(_,_).

empty_range(It,L):-range(_,1,It),dummy(L,_),fail.
empty_range(_,_).

range(Min,Min,Max):-Min=<Max.
range(I,Min,Max):-
        Min<Max,
        Min1 is Min+1,
        range(I,Min1,Max).

integers([],I,I):-!.
integers([I0|L],I0,I):-I0<I,I1 is I0+1,integers(L,I1,I).

bm(It,Len,Time,Lips):-
	integers(L,0,Len),
	timer(T0),
	empty_range(It,L),
	timer(T1),
	full_range(It,L),
	timer(T2),
	Time is (T2-T1)-(T1-T0),
	L1 is Len+1,
	L2 is Len+2,
	LI is (L1*L2)/2,
	LIs is It*LI,
	Lips is (LIs/Time)/1000.0.

htest(N,H,T,S):-
        integers(Is,0,N),
        statistics(global_stack,[H1,_]),
        statistics(trail,[T1,_]),
        statistics(local_stack,[S1,_]),
        nrev(Is,_),
        statistics(global_stack,[H2,_]),
        statistics(trail,[T2,_]),
        statistics(local_stack,[S2,_]),
        H is H2-H1,T is T2-T1,S is S2-S1.

timer(T):-statistics(runtime,[T0,_]),T is T0/1000.0.


