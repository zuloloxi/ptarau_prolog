% <ticker>('No','Date','DayOfWeek','Open','High','Low','Close','Volume',AdjClose).
%            1     2       3         4       5      6      7       8       9

filter(Field,Val,Rec):-atomic(Field),!,sel(Field,Rec,Val).

sel(no,Rec,X):-arg(1,Rec,X).
sel(date,Rec,X):-arg(2,Rec,X).
sel(wday,Rec,X):-arg(3,Rec,X).
sel(open,Rec,X):-arg(4,Rec,X).
sel(hi,Rec,X):-arg(5,Rec,X).
sel(low,Rec,X):-arg(6,Rec,X).
sel(close,Rec,X):-arg(7,Rec,X).
sel(vol,Rec,X):-arg(8,Rec,X).
sel(adj_close,Rec,X):-arg(9,Rec,X).
sel(month,Rec,X):-arg(2,Rec,Date),X is (Date mod 10000) // 100.
sel(year,Rec,X):-arg(2,Rec,Date),X is Date// 10000.
sel(day,Rec,X):-arg(2,Rec,Date),X is Date mod 100.
sel(any,_Rec,_X).

load_stock(T):-load_stock(T,_).

load_stock(T,N):-ctr_get(T,R),!,N=R.
load_stock(T,_):-
  ctr_new(T,-1),
  t2f(T,F),
    term_of(F,X),
    arg(1,X,K),
    bb_def(K,T,X),
    ctr_inc(T,_),
  fail.
load_stock(T,N):-
  ctr_get(T,N).


last_of(Stock,Val):-
  last_of(Stock,Val,_Date).

last_of(Stock,Val,date(WD,Y,M,D)):-
  load_stock(Stock),
  bb_val(0,Stock,Rec),
  sel(adj_close,Rec,Val),
  sel(wday,Rec,WD),
  sel(year,Rec,Y),
  sel(month,Rec,M),
  sel(day,Rec,D).

wday_of(Stock,Day,Avg):-
  for(I,1,5),
  dow(I,Day),
  avg_up(Stock,filter(wday,Day),adj_close,Avg).
   
month_of(Stock,Month,Avg):-
  for(I,1,12),
  m2n(Month,I),
  avg_up(Stock,filter(month,I),adj_close,Avg).
   
avg_of(Stock,NoOfDays,Avg):-
  avg_up(Stock,NoOfDays,filter(any,_),adj_close,Avg).
  
avg_up(Stock,Filter,Col,Avg):-
  avg_up(Stock,_Max,Filter,Col,Avg).
  
avg_up(Stock,Max,Filter,Col,_):-
  load_stock(Stock,Max0),
  (var(Max)->Max=Max0;true),
  ctr_new(sum_ctr,0),
  ctr_new(occ_ctr,0),
  for(I,0,Max),
    bb_val(I,Stock,Record),
    call(Filter,Record),
    filter(Col,Val,Record),
    ctr_inc(sum_ctr,Val,_),
    ctr_inc(occ_ctr,1,_),
  fail.
avg_up(_,_,_,_,Avg):-
  ctr_get(sum_ctr,S),
  ctr_get(occ_ctr,N),
  Avg is S/N.

ctr_new(Ctr,InitVal):-bb_let('$ctr',Ctr,InitVal).
ctr_inc(Ctr,X1):-ctr_inc(Ctr,1,X1).
ctr_inc(Ctr,Inc,X1):-bb_val('$ctr',Ctr,X),X1 is X+Inc,bb_set('$ctr',Ctr,X1).
ctr_get(Ctr,X):-bb_val('$ctr',Ctr,X).

