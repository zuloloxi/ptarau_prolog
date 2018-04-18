me2you([you,are],['I',am]).
me2you([are,you],['I',am]).
me2you([you,'''',re],['I',am]).
me2you([you,were],['I',was]).
me2you([were,you],['I',was]).
me2you(['I',am],[you,are]).
me2you(['i',am],[you,are]).
me2you([am,'I'],[you,are]).
me2you([am,'i'],[you,are]).
me2you(['I','''',m],[you,are]).
me2you(['i','''',m],[you,are]).
me2you(['I','''',ve],[you,have]).
me2you(['i','''',ve],[you,have]).

me2you(['I',was],[you,were]).
me2you(['i',was],[you,were]).
me2you([was,'I'],[you,were]).
me2you([was,'i'],[you,were]).

me2you([am],[are]).
me2you([your],[my]).
me2you([were],[was]).
me2you([was],[were]).
me2you([me],[you]).
me2you([myself],[yourself]).
me2you([yourself],[myself]).
me2you(['I'],[you]).
me2you(['i'],[you]).
me2you([you],['I']).
me2you([u],['I']).
me2you([my],[your]).
me2you([mine],[yours]).
me2you([our],[your]).

me2you([DO,'you'],['I',DO]):-aux_verb(DO).
me2you([V,'you'],[V,me]).

monkey_words(Qs,As):-
 codes_words("Why do you think about",Ws),
 det_append(Ws,Qs,NewQs),
 ensure_last(NewQs,'?',As).

me2yous(Ms,Ys):-xme2yous(Yss,Ms,[]),appendN(Yss,Ys).
  
xme2yous([Y|Ys])-->me2you(Y),!,xme2yous(Ys).
xme2yous([[W]|Ms])-->[W],!,xme2yous(Ms).
xme2yous([])-->[].

me2you(Y)-->{me2you(M,Y)},phrase(M).


fix_idioms(Ms,Ys):-xidioms(Yss,Ms,[]),appendN(Yss,Ys).
  
xidioms([Y|Ys])-->xidiom(Y),!,xidioms(Ys).
xidioms([[W]|Ms])-->[W],!,xidioms(Ms).
xidioms([])-->[].

xidiom(Y)-->{xidiom(M,Y)},phrase(M).

xidiom([don,'''',t],[do,not]).
xidiom([isn,'''',t],[is,not]).
xidiom([aren,'''',t],[are,not]).
xidiom(['I',ain,'''',t],['I',am,not]).
xidiom([i,ain,'''',t],['I',am,not]).
xidiom([ain,'''',t],[are,not]).
xidiom([haven,'''',t],[have,not]).
xidiom([hasn,'''',t],[has,not]).
xidiom([it,'''',s],[it,is]).
xidiom([can,'''',t],[can,not]).
xidiom([won,'''',t],[will,not]).
xidiom([should,'''',t],[should,not]).
xidiom([could,'''',t],[could,not]).
