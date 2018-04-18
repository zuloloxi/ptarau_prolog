:-['../library/match_lib'].
:-[wx_chat].
:-[wx_lib].
:-[wx_basic].
:-[wx_graph].
:-[wx_natlang].
:-[wx_data].
:-[wx_meta].
:-[wx_keywords].
:-[wx_gram].
:-[wx_reactive].
:-[wx_erules].
:-[wx_goals].
:-[wx_xml].
:-[wx_learn].
:-[wx_alpha].
:-[wx_state].
:-[wx_idioms].
:-[wx_personal].
:-[wx_short].
:-[wx_emotions].
:-[wx_games].
:-[wx_rank].
:-[wx_sum].
:-[wx_view].
% :-[wx_r].

/* optional components: 
   if commented out, their functionality is turned off 
*/

:-[wx_story].
:-[wx_past].
:-[wx_search].
%:-[wx_om].


/* generator/transformer/builder files - they are not included in top.pl
   but someteimes include it as well as verious ;arge files in paul/wordnet/wruntime

wx_build.pl
wx_transform.pl
wx_refact.pl
wx_convert.pl
wx_jreg.pl
wx_gbuild.pl
*/

/* server mode */

search_agent(localhost,5001,none,10). % Host,Port,Password,Timeout

bp_server:-is_prolog(binprolog),run_server(7002,none,8000,4000,4000,0).
prolog_server:-is_prolog(jinni_compiled),jservers,run_server(7002,none).
