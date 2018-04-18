/***************************************************************************
**/
% Make the rule base modifiable
%    this is specific to Quintus Prolog

% :- dynamic(rules/1).


/***************************************************************************
**/
% The rule base
%    The format of the rules is:
%
% rules([[keyword, importance of keyword],[
%         [pattern #, [the pattern], last response used,
%             [response 1],
%             [response 2],
%             ...
%             [response n]]]]).

rules([[sorry,0],[
      [1,[_],0,
            [please,do,not,apologize,'.'],
            [apologies,are,not,necessary,'.'],
            [what,feelings,do,you,have,when,you,apologize,'?'],
            ['I',have,told,you,that,apologies,are,not,required,'.']]]]).

rules([[remember,5],[
      [1,[_,you,remember,Y],0,
            [do,you,often,think,of,Y,'?'],
            [does,thinking,of,Y,bring,anything,else,to,mind,'?'],
            [what,else,do,you,remember,'?'],
            [why,do,you,remember,Y,just,now,'?'],
            [what,in,the,present,situation,reminds,you,of,Y,'?'],
            [what,is,the,connection,between,me,and,Y,'?']],
      [2,[_,do,i,remember,Y],0,
            [did,you,think,'I',would,forget,Y,'?'],
            [why,do,you,think,i,should,recall,Y,now,'?'],
            [what,about,Y,'?'],
            [equal,[what,0]],
            [you,mentioned,Y,'.']],
      [3,[_],0,
            [newkey]]]]).

rules([[if,3],[
      [1,[_,if,Y],0,
            [do,you,think,it,is,likely,that,Y,'?'],
            [do,you,wish,that,Y,'?'],
            [what,do,you,think,about,Y,'?'],
            [really,',',if,Y,'?']]]]).

rules([[dreamt,4],[
      [1,[_,you,dreamt,Y],0,
            [really,',',Y,'?'],
            [have,you,ever,fantasied,Y,while,you,were,awake,'?'],
            [have,you,dreamt,Y,before,'?'],
                [equal,[dream,3]],
            [newkey]]]]).

rules([[dream,3],[
      [1,[_],0,
            [what,does,that,dream,suggest,to,you,'?'],
            [do,you,dream,often,'?'],
            [what,persons,appear,in,your,dreams,'?'],

[do,you,believe,that,dreaming,has,something,to,do,with,your,problem,'?'],
            [newkey]]]]).

rules([[none,0],[
      [1,[_],0,
            ['I',am,not,sure,'I',understand,you,fully,'.'],
            [please,go,on,'.'],
            [what,does,that,suggest,to,you,'?'],
            [do,you,feel,strongly,about,discussing,such,things,'?']]]]).

rules([[perhaps,0],[
      [1,[_],0,
            [you,do,not,seem,quite,certain,'.'],
            [why,the,uncertain,tone,'?'],
            [can,you,not,be,more,positive,'?'],
            [you,are,not,sure,'?'],
            [do,you,not,know,'?']]]]).

rules([[name,15],[
      [1,[_],0,
            ['I',am,not,interested,in,names,'.'],
            ['I',have,told,you,before,',','I',do,not,care,about,names,'.'],
            [please,continue,'.']]]]).

rules([[xfremd,75],[
      [1,[_],0,
            ['I',am,sorry,',','I',only,speak,'English','.']]]]).

rules([[hello,0],[
      [1,[_],0,
            [how,do,you,do,'.','Please',state,your,problem,'.']]]]).

rules([[computer,50],[
      [1,[_],0,
            [do,computers,worry,you,'?'],
            [why,do,you,mention,computers,'?'],
            [what,do,you,think,machines,have,to,do,with,your,problem,'?'],
            [do,you,not,think,computers,can,help,people,'?'],
            [what,about,machines,worries,you,'?'],
            [what,do,you,think,about,machines,'?']]]]).

rules([[are,0],[
      [1,[_,are,you,Y],0,
            [do,you,believe,you,are,Y,'?'],
            [would,you,want,to,be,Y,'?'],
            [you,wish,'I',would,tell,you,you,are,Y,'?'],
                [what,would,it,mean,if,you,were,Y,'?'],
            [equal,[what,0]]],
      [2,[_,are,i,Y],0,
            [why,are,you,interested,in,whether,'I',am,Y,or,not,'?'],
            [would,you,prefer,if,'I',were,not,Y,'?'],
            [perhaps,'I',am,Y,in,your,fantasies,'.'],
                [do,you,sometimes,think,'I',am,Y,'?'],
            [equal,[what,0]]],
      [3,[_,are,Y],0,
            [did,you,think,they,might,not,be,Y,'?'],
            [would,you,like,it,if,they,were,not,Y,'?'],
            [what,if,they,were,not,Y,'?'],
            [possibly,they,are,Y,'.']],
      [4,[_],0,
            [why,do,you,say,am,'?'],
            ['I',do,not,understand,that,'.']]]]).


rules([[my,0],[
      [1,[_,my,Y],0,
            [why,are,you,concerned,over,my,Y,'?'],
            [what,about,your,own,Y,'?'],
            [are,you,worried,about,someone,elses,Y,'?'],
            [really,',',my,Y,'?']]]]).

rules([[was,2],[
      [1,[_,was,you,Y],0,
            [what,if,you,were,Y,'?'],
            [do,you,think,you,were,Y,'?'],
            [were,you,Y,'?'],
            [what,would,it,mean,if,you,were,Y,'?'],
                [what,does,Y,suggest,to,you,'?'],
            [equal,[what,0]]],
      [2,[_,you,was,Y],0,
            [were,you,really,'?'],
            [why,do,you,tell,me,you,were,Y,just,now,'?'],
            [perhaps,'I',already,knew,you,were,Y,'.']],
      [3,[_,was,i,Y],0,
            [would,you,like,to,believe,'I',was,Y,'?'],
            [what,suggests,that,'I',was,Y,'?'],
            [what,do,you,think,'?'],
            [perhaps,'I',was,Y,'.'],
            [what,if,'I',had,been,Y,'?']],
      [4,[_],0,
            [newkey]]]]).

rules([[im,0],[
        [1,[_,im,_],0,
            [equal,[i,0]]]]]).

rules([[youre,0],[
        [1,[_,youre,_],0,
            [equal,[you,0]]]]]).

rules([[you,0],[
      [1,[_,you,cant,Y],0,
            [how,do,you,know,you,can,not,Y,'?'],
            [have,you,tried,'?'],
            [perhaps,you,could,Y,now,'?'],
            [do,you,really,want,to,be,able,to,Y,'?']],
      [2,[_,you,dont,Y],0,
            [do,you,not,really,Y,'?'],
            [why,do,you,not,Y,'?'],
            [do,you,wish,to,be,able,to,Y,'?'],
            [does,that,trouble,you,'?']],
      [3,[_,you,feel,Y],0,
            [tell,me,more,about,such,feelings,'.'],
            [do,you,often,feel,Y,'?'],
            [do,you,enjoy,feeling,Y,'?'],
            [of,what,does,feeling,Y,remind,you,'?']],
        [4,[_,you,was,_],0,
            [equal,[was,2]]],
      [5,[_,you,Y,i,_],0,
            [perhaps,in,your,fantasy,we,Y,each,other,'?'],
            [do,you,wish,to,Y,me,'?'],
            [you,seem,to,need,to,Y,me,'.'],
            [do,you,Y,anyone,else,'?']],
      [6,[_,you,[(*),want,need,_],Y],0,
            [what,would,it,mean,to,you,if,you,got,Y,'?'],
            [why,do,you,want,Y,'?'],
            [suppose,you,got,Y,soon,'?'],
            [what,if,you,never,got,Y,'?'],
            [what,would,getting,Y,mean,to,you,'?'],
            [what,does,wanting,Y,have,to,do,with,this,discussion,'?']],
      [7,[_,you,[(*),feel,think,believe,wish,_],you,Y],0,
            [do,you,really,think,so,'?'],
            [but,you,are,not,sure,you,Y,'?'],
            [do,you,really,doubt,you,Y,'?']],
        [8,[_,you,_,[(*),feel,think,believe,wish,_],_,i,_],0,
            [equal,[you,0]]],
      [9,[_,youre,_,[(*),sad,unhappy,depressed,sick,M],_],0,
            ['I',am,sorry,to,hear,you,are,M,'.'],
            [do,you,think,coming,here,will,help,you,not,to,be,M,'?'],
            ['I',am,sure,it,is,not,pleasant,to,be,M,'.'],
            [can,you,explain,what,made,you,M,'?']],
      [10,[_,youre,_,[(*),happy,elated,glad,better,M],_],0,
            [how,have,'I',helped,you,to,be,M,'?'],
            [has,your,treatment,made,you,M,'?'],
            [what,makes,you,M,just,now,'?'],
            [can,you,explain,why,you,are,suddenly,M,'?']],
      [11,[_,youre,Y],0,
            [is,it,because,you,are,Y,that,you,came,to,me,'?'],
            [how,long,have,you,been,Y,'?'],
            [do,you,believe,it,normal,to,be,Y,'?'],
            [do,you,enjoy,being,Y,'?']],
      [12,[X],0,
            [you,say,X],
            [can,you,elaborate,on,that,'?'],
            [do,you,say,X,for,some,special,reason,'?'],
            [that,is,quite,interesting,'.']]]]).

rules([[i,0],[
        [1,[_,i,remind,you,of,_],0,
            [equal,[dit,10]]],
      [2,[_,im,Y],0,
            [what,makes,you,think,'I',am,Y,'?'],
            [does,it,please,you,to,believe,'I',am,Y,'?'],
            [do,you,sometimes,wish,you,were,Y,'?'],
            [perhaps,you,would,like,to,be,Y,'?']],
      [3,[_,i,Y,you],0,
            [why,do,you,think,'I',Y,you,'?'],
            [you,like,to,think,'I',Y,you,',',do,you,not,'?'],
            [what,makes,you,think,'I',Y,you,'?'],
            [really,',','I',Y,you,'.'],
            [do,you,wish,to,believe,'I',Y,you,'?'],
            [suppose,'I',did,Y,you,',',what,would,that,mean,to,you,'?'],
            [does,someone,else,believe,'I',Y,you,'?']],
      [4,[_,i,Y],0,
            [we,were,discussing,you,',',not,me,'.'],
            [oh,',',i,Y,'.'],
            [you,are,not,really,talking,about,me,',',are,you,'?'],
            [what,are,your,feelings,now,'?']]]]).

rules([[yes,0],[
      [1,[_],0,
            [you,seem,quite,positive,'.'],
            [you,are,sure,'?'],
            [i,see,'.'],
            [i,understand,'.']]]]).

rules([[no,0],[
      [1,[_],0,
            [are,you,saying,no,just,to,be,negative,'?'],
            [you,are,being,a,bit,negative,'.'],
            [why,not,'?'],
            [why,no,'?']]]]).

rules([[your,2],[
      [1,[_,your,_,[(*),mother,father,brother,sister,children,wife,M],Z],0,
            [tell,me,more,about,your,family,'.'],
            [who,else,in,your,family,Z,'?'],
            [your,M,'?'],
            [what,else,comes,to,mind,when,you,think,of,your,M,'?']],
      [2,[_,your,Y],0,
            [your,Y,'?'],
            [why,do,you,say,your,Y,'?'],
            [does,that,suggest,anything,else,which,belongs,to,you,'?'],
            [is,it,important,to,you,that,your,Y,'?']]]]).

rules([[memory,0],[
      [1,[_,your,Y],0,
            [lets,discuss,further,why,your,Y,'.'],
            [earlier,you,said,your,Y,'.'],
            [but,your,Y,'?'],
            [does,that,have,anything,to,do,with,the,fact,that,your,Y,'?']]]]).

rules([[can,0],[
      [1,[_,can,i,Y],0,
            [you,believe,'I',can,Y,',',do,you,not,'?'],
            [equal,[what,0]],
            [you,want,me,to,be,able,to,Y,'?'],
            [perhaps,you,would,like,to,be,able,to,Y,yourself,'?']],
      [2,[_,can,you,Y],0,
            [whether,or,not,you,can,Y,depends,on,you,more,than,on,me,'.'],
            [do,you,want,to,be,able,to,Y,'?'],
                [perhaps,you,do,not,want,to,Y,'.'],
            [equal,[what,0]]]]]).

rules([[what,0],[
      [1,[_],0,
            [why,do,you,ask,'?'],
            [does,that,question,interest,you,'?'],
            [what,is,it,you,really,want,to,know,'?'],
            [are,such,questions,much,on,your,mind,'?'],
            [what,answer,would,please,you,most,'?'],
            [what,do,you,think,'?'],
            [what,comes,to,your,mind,when,you,ask,that,'?'],
            [have,you,asked,such,questions,before,'?'],
            [have,you,asked,anyone,else,'?']]]]).

rules([[because,0],[
      [1,[_],0,
            [is,that,the,real,reason,'?'],
            [do,any,other,reasons,not,come,to,mind,'?'],
            [does,that,reason,seem,to,explain,anything,else,'?'],
            [what,other,reasons,might,there,be,'?']]]]).

rules([[why,0],[
      [1,[_,why,dont,i,Y],0,
            [do,you,believe,'I',do,not,Y,'?'],
            [perhaps,'I',will,Y,in,good,time,'.'],
            [should,you,Y,yourself,'?'],
                [you,want,me,to,Y,'?'],
            [equal,[what,0]]],
      [2,[_,why,cant,you,Y],0,
            [do,you,think,you,should,be,able,to,Y,'?'],
            [do,you,want,to,be,able,to,Y,'?'],
            [do,you,believe,this,will,help,you,to,Y,'?'],
                [have,you,any,idea,why,you,can,not,Y,'?'],
            [equal,[what,0]]]]]).

rules([[everyone,2],[
      [1,[_,[(*),everyone,everybody,nobody,noone,M],_],0,
            [really,',',M,'?'],
            [surely,not,M,'?'],
            [can,you,think,of,anyone,in,particular,'?'],
            [who,',',for,example,'?'],
            [you,are,thinking,of,a,very,special,person,'?'],
            [who,',',may,i,ask,'?'],
            [someone,special,perhaps,'?'],
            [you,have,a,paticular,person,in,mind,',',do,you,not,'?'],
            [who,do,you,think,you,are,talking,about,'?']]]]).

rules([[always,1],[
      [1,[_],0,
            [can,you,think,of,a,specific,example,'?'],
            [when,'?'],
            [what,incident,are,you,thinking,of,'?'],
            [really,',',always,'?']]]]).

rules([[like,10],[
        [1,[_,[(*),im,youre,am,is,are,was,_],_,like,_],0,
            [equal,[dit,10]]],
      [2,[_],0,
            [newkey]]]]).

rules([[dit,10],[
      [1,[_],0,
            [in,what,way,'?'],
            [what,resemblance,do,you,see,'?'],
            [what,does,that,similarity,suggest,to,you,'?'],
            [what,other,connections,do,you,see,'?'],
            [what,so,you,suppose,that,resemblance,means,'?'],
            [what,is,the,connection,',',do,you,suppose,'?'],
            [could,there,really,be,some,connection,'?'],
            [how,'?']]]]).

rules([[quit,100],[
      [1,[_],0,
            ['goodbye','.','My',secretary,will,send,you,a,bill,'.']]]]).

