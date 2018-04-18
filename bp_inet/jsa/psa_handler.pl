% Jinni server
post_method_handler(Alist,TemplateFile,Output):-
  % show_alist(Alist),
  process_query(TemplateFile,Alist,Css),
  appendN(Css,Codes),name(Output,Codes).

/*  
% BinProlog server  - requires bp_inet.wam adaptor
process_alist(Socket,FileCs,Alist):-
  name(TemplateFile,FileCs),
  process_query(TemplateFile,Alist,Css),
  sprint_css(Socket,Css).
*/
  
% common stuff
process_query(File,Alist,Css):-
  catch(process_query1(File,Alist,Css),_any,fail),
  !.
process_query(_File,_Alist,Css):-
  Css=["<b>Tunnel taken or bad data entry, please try another tunnel number!</b>"].
   
process_query1(_File,Alist,Css):-
  header(Hs),
  footer(Fs),
  [D0,D9]="09",
  member(tunnel=Ts,Alist),
  \+( (member(X,Ts),(X<D0;X>D9))),
  number_codes(T,Ts),
  integer(T),T>0,T<10000,
  member(passwd=Ps,Alist),
  member(desc=Ds,Alist),
  reserve_tunnel(T,Ps,Ds,Ok),
  Ok=yes,
  no2ports(T,PortNo,_),show_link(PortNo,Ds,YourTs),
  show_tunnels(Links),
  Css=[Hs,
    "You have succesfully reserved tunnel: <b>",Ts,"</b>"," for your Web site at:",[10,10],
    YourTs,[10,10],
    "type <b>jinni.bat ""jinni_http_tunnel(",Ts,
        ")""</b> to virtualize a Jinni Web server",[10,10],
    "type <b>jinni.bat ""tunnel_from(80,",Ts,
        ")""</b> to virtualize another server running on local port 80",[10,10],
    "<b>Links to Jinni Virtual Servers:</b>",[10,10],
    Links,
    Fs],
  !.

show_alist(Alist):-
  nonvar(Alist),
  member((K=Cs),Alist),
  write(K),write_chars("="),write_chars(Cs),nl,
  fail
; true.

show_tunnels(Ls):-findall(Ts,show_tunnel(Ts),Tss),appendN(Tss,Ls).
  
show_tunnel(Ts):-
  db_asserted(tunnels,tunnel(TunnelNo,_Ps,Ds)),
  no2ports(TunnelNo,PortNo,_),
  show_link(PortNo,Ds,Ts).

show_link(PortNo,Ds,Ts):-
  tunnel_server(SN),
  make_cmd0(["http://",SN,":",PortNo % ,"/","index.html"
            ],Ls),
  make_cmd0(['<A href="',Ls,'">',Ls,'</A>&nbsp;<b>',Ds,'</b>',[10]],Ts).

virtualize(Host,Port,Tunnel,Pwd,Desc):-
  reserve_tunnel(Tunnel,Pwd,Desc),
  tunnel_from(Host,Port,Tunnel).
  
reserve_tunnel(No,Pwd,Desc):-
  atom_codes(Pwd,Ps),
  atom_codes(Desc,Ds),
  reserve_tunnel(No,Ps,Ds,_).

reserve_tunnel(TunnelNo,Password,D,Ok):-
  bb_val(tunnel,TunnelNo,Data),
  ( Data=tunnel(Password,_)->bb_set(tunnel,TunnelNo,tunnel(Password,D)),R=yes
  ; R=no
  ),
  !,
  Ok=R.
reserve_tunnel(TunnelNo,Password,D,Ok):-
  bb_def(tunnel,TunnelNo,tunnel(Password,D)),
  activate_server_tunnel(TunnelNo),
  db_asserta(tunnels,tunnel(TunnelNo,Password,D)),
  Ok=yes.

new_tunnel(No):-
  gensym_no(tunnel_no,N),
  No is N+30000,
  activate_server_tunnel(No).

header(H):-
  make_cmd0(
   [
     "<html><title>Jinni Server Agent Script Output</title>",
     [10],
     "<body bgcolor=ffffff>",
     [10],
     "<pre>",
     [10]
   ],
   H
  ).

footer(F):-
  make_cmd0([
   "</pre>",
   [10],
   "</body>",
   [10],
   "</html>",
   [10]
  ],
  F
).
    
rpc_handler(new_tunnel(No)):- !,new_tunnel(No).
rpc_handler(reserve_tunnel(No,Pwd,Desc)):- !,reserve_tunnel(No,Pwd,Desc).
rpc_handler(G):-println(rpc_handler_filtering_out_goal(G)),fail.
    