an_agent(Ws):-codes_words(
  "I am a happy, blind, paralized and sensorially deprived mind.",Ws).

a_greeting(Hi,L,[Hi,L,'.','I',am,a,conversational,agent,who,
   knows,about,things,(','),words,and,people,'.','Chat',with,me,'!']).

try_short_match(L,_P,[],Ws,_Stage,short(greeting)):-a_greeting('Hello',L,Ws).
try_short_match(L,_P,[Hi|_],Ws,_Stage,short(greeting)):-hello_word(Hi),!,a_greeting(Hi,L,Ws).
try_short_match(_L,_P,[Wh,are,you|_],Ws,_Stage,short(agent_who)):-wh_word(Wh),!,an_agent(Ws).
try_short_match(L,_P,[Wh,am,'I'|_],['You',are,L,'.'],_Stage,short(user_who)):-wh_word(Wh),!.
try_short_match(L,_P,[Wh,am,'i'|_],['You',are,L,'.'],_Stage,short(user_who)):-wh_word(Wh),!.
try_short_match(L,_P,[Wh,'I',am|_],['You',are,L,'.'],_Stage,short(user_who)):-wh_word(Wh),!.  
try_short_match(_L,_P,[search|Is],Os,_Stage,search):-search_step(Is,Os).  
