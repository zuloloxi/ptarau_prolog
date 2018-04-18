% derivad from some Eliza-like rules

match_erules(Is,As):-
  debug_match(mx_erules_entering,Is,[]),   
  erules(Ps,Oss),
  % println(here=match_pattern(Ps,Is)),
  match_pattern(Ps,Is),
  member(Os,Oss),
  % println(there=Os),
  flatten(Os,Fs),
  trim_last_punct(Fs,As),
  debug_match(mx_erules_exiting,Is,As).

flatten(X,Y):-var(X),!,X=Y.
flatten([],[]).
flatten([H|T],[H|T2]):- \+(H=[_|_]),!,flatten(T,T2).
flatten([H|T],L) :- 
   H=[_|_],
   flatten(H,A),
   flatten(T,B),
   det_append(A,B,L).

erules([i,am,sorry,_],[
            [please,do,not,apologize,'.'],
            [apologies,are,not,necessary,'.'],
            [what,feelings,do,you,have,when,you,apologize,'?'],
            ['I',have,told,you,that,apologies,are,not,required,'.']
        ]).

erules([_,remember,Y,End:member(End,['?','.'])],[
            [do,you,often,think,of,Y,'?'],
            [does,thinking,of,Y,bring,anything,else,to,mind,'?'],
            [what,else,do,you,remember,'?'],
            [why,do,you,remember,Y,just,now,'?'],
            [what,in,the,present,situation,reminds,you,of,Y,'?'],
            [what,is,the,connection,between,me,and,Y,'?'],
            [did,you,think,'I',would,forget,Y,'?'],
            [why,do,you,think,'I',should,recall,Y,now,'?']
        ]).

erules([maybe,_], [
            [you,do,not,seem,quite,certain,'.'],
            [why,the,uncertain,tone,'?'],
            [can,you,not,be,more,positive,'?'],
            [you,are,not,sure,'?'],
            [do,you,not,know,'?']
           ]).

erules([am,'I',Y,'?'],[
            [do,you,believe,you,are,Y,'?'],
            [would,you,want,to,be,Y,'?'],
            [you,wish,'I',would,tell,you,you,are,Y,'?'],
            [what,would,it,mean,if,you,were,Y,'?'],
            [why,are,you,interested,in,whether,'I',am,Y,or,not,'?'],
            [would,you,prefer,if,'I',were,not,Y,'?'],
            [perhaps,'I',am,Y,in,your,fantasies,'.'],
            [do,you,sometimes,think,'I',am,Y,'?']
        ]).
erules([are,they,Y],[            
            [did,you,think,they,might,not,be,Y,'?'],
            [would,you,like,it,if,they,were,not,Y,'?'],
            [what,if,they,were,not,Y,'?'],
            [possibly,they,are,Y,'.']
       ]).
erules([_,your,Y:true,_],[  
            [why,are,you,concerned,over,my,Y,'?'],
            [what,about,your,own,Y,'?'],
            [are,you,worried,about,someone,elses,Y,'?'],
            [really,',',my,Y,'?']
       ]).

erules(['i',was,Y],[
            [what,if,you,were,not,Y,'?'],
            [do,you,think,you,were,Y,'?'],
            [were,you,Y,'?'],
            [what,would,it,mean,if,you,were,Y,'?'],
            [what,does,Y,suggest,to,you,'?'],
            [were,you,really,'?'],
            [why,do,you,tell,me,you,were,Y,just,now,'?'],
            [perhaps,'I',already,knew,you,were,Y,'.'],
            [would,you,like,to,believe,'I',was,Y,'?'],
            [what,suggests,that,'I',was,Y,'?'],
            [what,do,you,think,'?'],
            [perhaps,'I',was,Y,'.'],
            [what,if,'I',had,been,Y,'?']
         ]).
   

erules(['i',can,not,Y],[
            [how,do,you,know,you,can,not,Y,'?'],
            [have,you,tried,'?'],
            [perhaps,you,could,Y,now,'?'],
            [do,you,really,want,to,be,able,to,Y,'?']
        ]).
        
erules(['i',do,not,Y],[
            [do,you,not,really,Y,'?'],
            [why,do,you,not,Y,'?'],
            [do,you,wish,to,be,able,to,Y,'?'],
            [does,that,trouble,you,'?']
     ]).
     
erules(['i',feel,Y],[
            [tell,me,more,about,such,feelings,'.'],
            [do,you,often,feel,Y,'?'],
            [do,you,enjoy,feeling,Y,'?'],
            [of,what,does,feeling,Y,remind,you,'?']
        ]).

erules(['i',Y,you,_],[
            [perhaps,in,your,fantasy,we,Y,each,other,'?'],
            [do,you,wish,to,Y,me,'?'],
            [you,seem,to,need,to,Y,me,'.'],
            [do,you,Y,anyone,else,'?']
       ]).
       
erules(['i',want,Y],[
            [what,would,it,mean,to,you,if,you,got,Y,'?'],
            [why,do,you,want,Y,'?'],
            [suppose,you,got,Y,soon,'?'],
            [what,if,you,never,got,Y,'?'],
            [what,would,getting,Y,mean,to,you,'?'],
            [what,does,wanting,Y,have,to,do,with,this,discussion,'?']
       ]).

erules(['i',am,M:sad_word(M),_],[
            ['I',am,sorry,to,hear,you,are,M,'.'],
            [do,you,think,coming,here,will,help,you,not,to,be,M,'?'],
            ['I',am,sure,it,is,not,pleasant,to,be,M,'.'],
            [can,you,explain,what,made,you,M,'?']
       ]).
erules(['i',am,M:happy_word(M),_],[       
            [how,have,'I',helped,you,to,be,M,'?'],
            [what,makes,you,M,just,now,'?'],
            [can,you,explain,why,you,are,suddenly,M,'?']]).
erules(['i',am,Y],[
            [is,it,because,you,are,Y,that,you,came,to,me,'?'],
            [how,long,have,you,been,Y,'?'],
            [do,you,believe,it,normal,to,be,Y,'?'],
            [do,you,enjoy,being,Y,'?']
        ]).
   
erules([you,are,Y],[
            [what,makes,you,think,'I',am,Y,'?'],
            [does,it,please,you,to,believe,'I',am,Y,'?'],
            [do,you,sometimes,wish,you,were,Y,'?'],
            [perhaps,you,would,like,to,be,Y,'?']
       ]).

erules([can,you,Y],[
            [you,believe,'I',can,Y,',',do,you,not,'?'],
            [you,want,me,to,be,able,to,Y,'?'],
            [perhaps,you,would,like,to,be,able,to,Y,yourself,'?'],    
            [whether,or,not,you,can,Y,depends,on,you,more,than,on,me,'.'],
            [do,you,want,to,be,able,to,Y,'?'],
            [perhaps,you,do,not,want,to,Y,'.']
       ]).

erules([because,_],[
            [is,that,the,real,reason,'?'],
            [do,any,other,reasons,not,come,to,mind,'?'],
            [does,that,reason,seem,to,explain,anything,else,'?'],
            [what,other,reasons,might,there,be,'?']
      ]).

erules([why,dont,you,Y,'?'],[
            [perhaps,'I',will,Y,in,good,time,'.'],
            [should,you,Y,yourself,'?'],
            [you,want,me,to,Y,'?']
      ]).

erules([why,cant,'I',Y,'?'],[
            [do,you,think,you,should,be,able,to,Y,'?'],
            [do,you,want,to,be,able,to,Y,'?'],
            [do,you,believe,this,will,help,you,to,Y,'?'],
            [have,you,any,idea,why,you,can,not,Y,'?']
        ]).
 
erules([M:every_word(M)],[
            [really,',',M,'?'],
            [surely,not,M,'?'],
            [can,you,think,of,anyone,in,particular,'?'],
            [who,',',for,example,'?'],
            [you,are,thinking,of,a,very,special,person,'?'],
            [who,',',may,i,ask,'?'],
            [someone,special,perhaps,'?'],
            [you,have,a,paticular,person,in,mind,',',do,you,not,'?'],
            [who,do,you,think,you,are,talking,about,'?']
       ]).

erules([_,always,_],[
            [can,you,think,of,a,specific,example,'?'],
            [when,'?'],
            [what,incident,are,you,thinking,of,'?'],
            [really,',',always,'?']
       ]).

erules([_,similar,to,_],[
            [what,resemblance,do,you,see,'?'],
            [what,does,that,similarity,suggest,to,you,'?'],
            [what,other,connections,do,you,see,'?'],
            [what,so,you,suppose,that,resemblance,means,'?'],
            [what,is,the,connection,',',do,you,suppose,'?'],
            [could,there,really,be,some,connection,'?'],
            [how,'?']
]).

edefaults([
            ['Why',not,asking,me,what,things,are,or,who,famous,people,are,'?'],
            ['I',am,not,sure,'I',understand,you,fully,'.'],
            [please,go,on,'.'],
            [what,does,that,suggest,to,you,'?'],
            [do,you,feel,strongly,about,discussing,such,things,'?'],
            [can,you,elaborate,on,that,'?'],       
            [that,is,quite,interesting,'.'],            
            [why,do,you,ask,'?'],
            [does,that,question,interest,you,'?'],
            [what,is,it,you,really,want,to,know,'?'],
            [are,such,questions,much,on,your,mind,'?'],
            [what,answer,would,please,you,most,'?'],
            [what,do,you,think,'?'],
            [what,comes,to,your,mind,when,you,ask,that,'?'],
            [have,you,asked,such,questions,before,'?'],
            [have,you,asked,anyone,else,'?']
         ]).
           