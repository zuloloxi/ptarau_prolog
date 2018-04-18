% past

answer_past_topic(Login,Pwd,Ys,Os):-
  find_at_most(4,Qs,relevant_queries(Login,Pwd,Qs),Qss),
  find_at_most(4,W-T,findonce(W-T,in_short_context([noun,verb],Ys,[Ys|Qss],W,T),_K),WTs),
  member(W-T,WTs),
  rotate_answer(Login,[Pwd,T,W],(pick_up_past_topic(T,[W],Ps),to_upper_first(Ps,Us)),Us),
  ensure_last(Us,'?',NewUs),
  rotate_answer(Login,[Pwd,W],member(Back,
    [
      ['About',W],
      ['Back',to,W],
      ['We',were,talking,about,W],
      ['Something',about,W],
      ['You',seem,interested,to,talk,about,W],
      ['By',the,way,W,is,still,on,my,mind]
    ]),
  Back),  
  appendN([Back,['.'],NewUs],Os).

relevant_queries(Login,Pwd,Qs):-
  asserted(memqa(Login,Pwd,Qs,_As,_Stage1,Stage2)),
  \+member(Stage2,[past,thinking]).

pick_up_past_topic(T,Ws,Ss):-wextends(T,Ws,Ss).
pick_up_past_topic(T,Ws,Ss):-wrelateds(T,Ws,Ss).

new_answer(L,P,Os):- \+(asserted(memqa(L,P,_,Os,_Stage1,_Stage2))).



  
