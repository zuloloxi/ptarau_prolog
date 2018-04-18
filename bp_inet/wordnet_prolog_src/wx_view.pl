:-['jwn/tg'].
%:-['jwn/prolog3d'].

clear_params:-
   findall(P,asserted(param(P)),Ps),
   foreach(member(P,Ps),bb_rm(param,P)),
   abolish(param,1).
  
def_param(Name,_):-get_param(Name,_),!.
def_param(Name,Val):-set_param(Name,Val).

set_param(Name,Val):-
  bb_let(param,Name,Val),
  (asserted(param(Name))->true;assert(param(Name))).  

get_param(Name,Val):-bb_val(param,Name,Val).

show_params:-
  get_param(strace,yes),
  asserted(param(P)),
  get_param(P,V),
  println(param(P)=V),
  fail
; true.

view3d(G):-
  (get_param(view,yes)->invoke_java_method(G,toString,GS),ttyprint(GS);true),
  (get_param(view,yes)->draw_graph(G);true).
  
visualize(gs(SDb,WDb,G)):-  
  (get_param(sview,yes)->sview_graph(SDb,WDb,G);true),
  (get_param(view,yes)->view_graph(G);true),
  foreach(
    member(O,[SDb,WDb,G]),
    delete_java_object(O)
  ).
  
sview_graph(SDb,WDb,G):-
  ttyprint('starting sview'),
  new_tg(TG),new_graph(Map),Root='ROOT',
  foreach(sview_vs(SDb,WDb,G,Map,TG,Root),true),
  ttyprint('showing sview'),
  tg_show(TG),
  tg_clear(TG),
  delete_java_object(Map).
 
sview_vs(SDb,WDb,G,Map,TG,Root):-
  tg_put_vertex(Map,TG,Root,2),
  vertex_of(SDb,Ts),
    % (get_param(first_only,yes)->!;true),    
    vertex_data(SDb,Ts,WsIs),
    findall(Us,
      ( 
        member(Us-_/_,WsIs),
        is_vertex(WDb,Us)
      ),
    Uss),
    appendN(Uss,Us),
    sview_sent(Map,TG,Us,Root,Sent),
      member(Ws-_Desc/Is,WsIs),
        % ttyprint(here=Ws-Desc),   
        is_vertex(WDb,Ws),
        to_text(Ws,Word),         
        tg_put_vertex(Map,TG,Word,1),
        tg_put_edge(Map,TG,Sent,Word),
        sview_best(G,Map,TG,WDb,Ws,Word),       
        foreach(
          member(I,Is),
          sview_es(G,Map,TG,Word,I)
        ).

sview_best(G,Map,TG,WDb,Ws,Word):-
  edge_data(WDb,Ws,best_syn,_Desc/I),
  xname(I,Name),
  tg_put_vertex(Map,TG,Name,2),
  tg_put_edge(Map,TG,Name,Word),
  % i2ws(I,Vss),swrite(Vss,S),
  edge_data(G,I,sense,S),
  tg_put_vertex(Map,TG,S,1),
  tg_put_edge(Map,TG,S,Name),
  !.
sview_best(_G,_Map,_TG,_WDb,_Ws,_Word).
   
sview_sent(Map,TG,Ws,Root,Sent):-
    to_text(Ws,Sent),
    tg_put_vertex(Map,TG,Sent,0),
    tg_put_edge(Map,TG,Root,Sent).

sview_es(G,Map,TG,Word,I):-
  Shape=3,
  linked_vertex(G,I,From),
  tg_put_vertex(Map,TG,From,Shape),
  tg_put_edge(Map,TG,Word,From),
  outgoing_of(G,I,O),
    linked_vertex(G,O,To),
    tg_put_vertex(Map,TG,To,Shape),
    tg_put_edge(Map,TG,From,To).
 
linked_vertex(G,I,Name):-
  integer(I),
  out_degree(G,I,OD),
  in_degree(G,I,ID),
  D is ID+OD,
  D>0,
  xname(I,Name).

xname(I,Name):-namecat('x',I,'',Name).
    
tg_put_vertex(Map,_TG,V,_Style):-is_vertex(Map,V),!.
tg_put_vertex(Map,TG,V,Style):-
   tg_add_vertex(TG,V,Style,TgV),
   add_vertex(Map,V,TgV).
   
tg_put_edge(Map,TG,From,To):-
  vertex_data(Map,From,TgFrom),
  vertex_data(Map,To,TgTo),
  tg_add_edge(TG,TgFrom,TgTo,_).

to_text(Ts,W):-nonvar(Ts),codes_words(Cs,Ts),atom_codes(W,Cs).
        
view_graph(G):-
  new_tg(TG),
  view_vs(G,TG,VTs),
  foreach(
    member(V-T,VTs),
    view_es(G,TG,VTs,V,T)
  ),
  tg_show(TG),
  tg_clear(TG).

view_vs(G,TG,VTs):-
  findall(VT,view_vs1(G,TG,VT),VTs).
  
view_vs1(G,TG,V-TV):-
  tg_add_vertex(TG,'ROOT',3,Root),
  findall(Type-TGType,(ss_type(_,Type,_),tg_add_vertex(TG,Type,2,TGType)),TTs),
  foreach(member(_-TGType,TTs),tg_add_edge(TG,Root,TGType,_)),
  good_vertex_of(G,V),
  in_degree(G,V,ID),
  out_degree(G,V,OD),
  IOD is OD+ID,
  IOD>0,
  once(i2wtn(V,Ws,Type,_)),
  findall(SW,(member(SW0,Ws),(SW=SW0;SW=' ')),SWs),
  make_cmd(SWs,W),
  namecat(W,':',V,SV),
  tg_add_vertex(TG,SV,TV),
  once(member(Type-TGType,TTs)),
  tg_add_edge(TG,TGType,TV,_),
  tg_add_edge(TG,TV,Root,_).

view_es(G,TG,VTs,V,T):-
  outgoing_of(G,V,O),
    once(member(O-X,VTs)),
      tg_add_edge(TG,T,X,_).

% supports thin prolog Vconsole

shell_call(chat(ICs),[],yes):-!,call(chat_step(ICs,_)).
shell_call(G,VsEs,A):-default_shell_action(G,VsEs,A).

% end

jservers:-
  bg(run_http_server(6002)),
  bg(run_object_server).

/*
start_object_server:-new(P),P:object_server.

object_server:-object_mode,run_server(6666,none).

% makes sure terms are not converted to Strings when sent over sockets

object_mode:-encode,decode,enact.

string_mode:-
  retractall(term_decoder(_,_)),
  retractall(term_encoder(_,_)),
  retractall(rpc_action_handler(_,_,_)).
  
decode:-clause(term_decoder(_,_),_),!.
decode:-asserta(term_decoder(T,T)).

encode:-clause(term_encoder(_,_),_),!.
encode:-asserta(term_encoder(T,T)).

enact:-clause(rpc_action_handler(_,_,_),_),!.
enact:-asserta((rpc_action_handler(T,_P,R):-do_rpc(T,R))).

do_rpc(G,_Pwd,R):-ask_query(no,G,R,_).
*/
 
ask_query(SV,I,O,R):-
  atom_codes(I,ICs),
  (get_param(sview,SV0)->true;SV0=no),set_param(sview,SV),
  vchat_step(ICs,OCs,VGoal),set_param(sview,SV0),
  atom_codes(O,OCs),
  % new_graph(G),add_vertex(G,boo,_),R=invoke_java_method(G,toString,S),
  R=VGoal,
  !.
ask_query(_,_,'Sorry, I did not understand that.',true).

remote_query(H,P,SV,I,O):-
  new(Prolog),
  Prolog:remote_run_object(H,P,O-VGoal,ask_query(SV,I,O,VGoal),R),
  R=the(O-VG),
  % ttyprint(here=VG),
  (get_param(sview,SV0)->true;SV0=no),set_param(sview,SV),
  call(VG).

chat_console:-chat_console(localhost).

chat_console(Host):-
  new_frame(F),
  chat_console(Host,F),
  show(F).

applet_chat_console:-
  get_applet(F),
  call_gui_method('get_applet_host',H),
  chat_console(H,F),
  show(F).
     
chat_console(Host,F):-
  ServerP=6001,
  C=(simple_console_action(I,O):-remote_query(Host,ServerP,yes,I,O)),C=(H:-B),
  % C=(simple_console_action(I,O):-I=O),C=(H:-B),
  (clause(H,B)->true;asserta(C)),
  new_console(F,'').

  
