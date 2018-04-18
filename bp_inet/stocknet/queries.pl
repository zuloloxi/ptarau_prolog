% queries

q1:-q1(qqq).

q1(S):-
  for(I,1,12),
  avg_up(S,filter(month,I),adj_close,R),
  ctr_get(occ_ctr,O),
  m2n(M,I),
  println(M=(R:O)),
  fail;true.

q2(S):-
  for(I,1,5),
  dow(I,D),
  avg_up(S,filter(wday,D),adj_close,R),
  ctr_get(occ_ctr,O),
  println(D=(R:O)),
  fail;true.  
  
q3(S):-
  for(I,1,31),
  avg_up(S,filter(day,I),adj_close,R),
  ctr_get(occ_ctr,O),
  println(I=(R:O)),
  fail;true.  

q4:-q4(amzn).

q4(S):-
  for(I,1990,2003),
  avg_up(S,filter(year,I),adj_close,R),
  ctr_get(occ_ctr,O),
  println(I=(R:O)),
  fail;true.  
       
ctest:-
  csv2rec(nasdaq,Recs),
  println(Recs),
  fail.
  
  