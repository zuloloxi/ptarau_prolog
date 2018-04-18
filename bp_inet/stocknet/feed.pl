feed:-s2f(spy).

dates([1990,1,1],[2010,1,1]).

mfile('/paul/stocknet_data/markets/all_stocks').

mdir('/paul/stocknet_data/markets/').

sdir('stocknet_data/stocks/').

t2f(Ticker,F):-sdir(D),namecat(D,Ticker,'.pl',F).
 
portofolio([
  qqq,spy,mdy,ibm,msft,aapl,amr,amzn,bbh,driv,ebay,
  et,hhh,bbh,luv,mdy,msft,sbux,sunw,xle,xlk,xlu,
  tmta,lexr,luv,jblu,ewj,ryjpx
]).
  
s2f:-
  portofolio(Ts),
  member(T,Ts),
    println(generating_file_for=T),
    s2f(T),
  fail
; true.
  
s2f(Ticker):-stock2file(Ticker,_).

pp_fact(T):-term_codes(T,Cs),member(C,Cs),put(C),fail.
pp_fact(_):-[D]=".",put(D),nl.


get_stock_token(Stock,T):-
  dates(From,To),
  get_stock_token(Stock,From,To,T).

get_stock_token(Stock,From,To,T):-
  to_query(Stock,From,To,Query),
  token_of(Query,T).

to_query(Stock,[FY,FM,FD],[TY,TM,TD],Query):-
  FM0 is FM-1,TM0 is TM-1,
  make_cmd(['http://chart.yahoo.com/table.csv?a=',FM0,'&b=',FD,'&c=',FY,'&d=',
      TM0,'&e=',TD,'&f=',TY,'&s=',Stock,'&y=0&g=d&ignore=.csv'],Query).

get_stock_line(N,E,Ws):-
  findall(W,get_stock_element(N,E,W),Ws).

get_stock_element(N,E,W):-
  name(NL,[10]),
  for(_,1,N),
  get(E,R),
  % println(R),
  R=the(W),
  W\==',',
  W\=='-',
  W\=='.',
  W\=='*',
  W\==NL.

% collecting stocks

gen_stocks:-
  mfile(F0),namecat(F0,'.','pl',F),
  tell(F),
  forall(member(M,[nasdaq,nyse,amex]),(csv2rec(M,Rec),pp_fact(Rec),fail)),
  told.

bco:-
  mfile(F0),namecat(F0,'.','pl',F),  
  call(fcompile(F)).

jco:-
  mfile(F),
  ucompile(F).
  
csv2rec(M,Rec):-
  mdir(D),namecat(D,M,'.csv',F),
  ctr_new(M,0),
  csv2wss(F,Wss),
  wss2rec(M,Wss,Rec).

wss2rec(M,Wss,stock(LT,M,Ctr,Cap,Ns,Ds)):-
   Wss=[Ns,[T|_],['$'|Cs],Ds],
   ctr_inc(M,Ctr),
   parse_cap(Cs,FCap),
   Cap is round(FCap*1000),
   to_lower_word(T,LT).
   
to_lower_word(W,L):-name(W,Ws),to_lower_chars(Ws,Ls),name(L,Ls).

parse_cap([X,',',A,',',B,',',C,'.',D],Cap):-make_cmd0([X,A,B,C,'.',D],Cs),number_codes(Cap,Cs).
parse_cap([A,',',B,',',C,'.',D],Cap):-make_cmd0([A,B,C,'.',D],Cs),number_codes(Cap,Cs).
parse_cap([B,',',C,'.',D],Cap):-make_cmd0([B,C,'.',D],Cs),number_codes(Cap,Cs).
parse_cap([C,'.',D],Cap):-make_cmd0([C,'.',D],Cs),number_codes(Cap,Cs).
parse_cap([D],Cap):-Cap is D*1.0.


% get stoc data from Web

stock2file(Stock):-
 stock2file(Stock,_PF).

stock2file(Stock,PF):-
  println(processing(stock=Stock)),  
  sdir(D),namecat(D,Stock,'.csv',F),
  sdir(D),namecat(D,Stock,'.pl',PF),
  ( exists_file(F)->true
  ; stock2csv(Stock)
  ),
  exists_file(F),
  csv2pl(Stock).


stock2csv(Stock):-
 dates(From,To),
 stock2csv(From,To,Stock).
 
stock2csv(From,To,Stock):-
  sdir(D),namecat(D,Stock,'.csv',F),
  println([stock=Stock,file=F]),
  to_query(Stock,From,To,Query),
  has_stock_data(Query),
  query2csv(Query,F).

query2csv(Query,F):-  
  tell(F),
  url2char(Query,C),
    put(C),
  fail.
query2csv(_Query,_F):-  
  told.

url2char(URL,C):-call_ifdef(http2char(URL,C),char_of(URL,C)).
  
has_stock_data(F):-
  Min=512,find_at_most(Min,C,url2char(F,C),Cs),length(Cs,L),
  !,
  L=Min.

csv2pl(Stock):-
   sdir(D),
   namecat(D,Stock,'.csv',CF),
   namecat(D,Stock,'.pl',PF),
   ( exists_file(PF)->true
   ; do_csv2pl(Stock,CF,PF)
   ).

do_csv2pl(Stock,CF,PF):-
   println([from=CF,to=PF]),  
   tell(PF),
   nth_line_of(CF,Cs,N),
   parse_csv(Cs,Wss),
     ( N =:=1 ->
       to_schema(Wss,Ws),
       Schema =.. [Stock,'No','Date','Day'|Ws],
       "/*/ "=[B,X,E,S],
       put(B),put(X),put(S),
       pp_fact(Schema),
       put(X),put(E),nl
     ; N>1,N2 is N-2,to_record(Wss,Ws),
       Record =.. [Stock,N2|Ws],
       pp_fact(Record)
     ),
   fail.
do_csv2pl(_Stock,_CF,_PF):-
   told.   

to_atoms(Cs,A):-
  [A0,A9]="09",
  Cs=[D|_],
  D>=A0,D=<A9,
  !,
  number_codes(A,Cs).
to_atoms(Cs,A):-
  name(A,Cs).

to_schema(Wss0,Ws):-
  map(clean_nl,Wss0,Wss),
  map(to_atoms,Wss,Ws).

clean_nl(Cs0,Cs):-
  findall(C,(member(C,Cs0),C=\=10,C=\=13),Cs).

to_record([Cs|Wss],NewWs):-
  map(to_atoms,Wss,Ws),
  codes_words(Cs,[D,'-',M,'-',Y]),
  date2int(Y,M,D,Date,WDay),
  NewWs=[Date,WDay|Ws].
       
nth_line_of(F,Cs,N):-new_engine(C,line_of(F,C),E),nth_element_of(E,Cs,N).
   
nth_element_of(I,X,N):-nth_element_of(I,X,0,N).
   
nth_element_of(I,X,N1,N2):-pick_nth_element_of(I,X,N1,N2).
pick_nth_element_of(I,X,N1,N3):-N2 is N1+1,get(I,the(A)),select_nth_from(I,A,X,N2,N3).

select_nth_from(_,A,A,N,N).
select_nth_from(I,_,X,N1,N2):-pick_nth_element_of(I,X,N1,N2).

