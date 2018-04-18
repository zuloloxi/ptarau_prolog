/* is www_root is '.' data_dir becomes the same ! */

www_default_file(F):-bb_val(www,default_file,F0),!,F=F0.
www_default_file('index.html').

www_get_df(Fs):-www_default_file(F),atom_codes(F,Fs).

www_root(R):-bb_val(www,root,X),!,R=X.
www_root('..').

data_dir(This):-This='.',www_root(This),!.
data_dir('../data').

cgi_dir('../cgi').
ssi_dir('../ssi').

to_data_dir:-data_dir(D),cd(D).
to_ssi_dir:-ssi_dir(D),cd(D).
to_cgi_dir:-cgi_dir(D),cd(D).


/*
 BinNet Internet Programming Toolkit
 Copyright (C) BinNet Corp. 1999

 Parsing/String processing tools
*/

split_pf(PsFs,Ps,Fs):-
  PsFs=['/'|Xs],
  \+member('/',Xs),
  !,
  det_append(PsFs,['/'],Ps),
  Fs=[].
  
split_pf(PsFs,Ps,Fs):-
  reverse(PsFs,Rs),
  match_before('/',RFs,Rs,RPs),
  !,
  reverse(['/'|RPs],Ps),
  reverse(RFs,Fs).
split_pf(Fs,['/'],Fs).

split_path_file(DsFs0,NewDs,Fs):-
  % name(DF,DsFs0),println(here=DF),
  ( DsFs0="/"->
    DsFs0=[Slash],www_get_df(Is),DsFs=[Slash|Is]
  ; DsFs=DsFs0
  ),
  split_path_file2(DsFs,NewDs,Fs).

split_path_file1(PsFs0,Ps,Fs):-
  codes_words(PsFs0,Ws),
  split_pf(Ws,Ps0,Fs0),
  codes_words(Ps,Ps0),
  codes_words(Fs,Fs0).
  

/* BAD? */

split_path_file2(DsFs,NewDs,Fs):-
  [Slash,Dot]="/.",
  reverse(DsFs,Rs),
  !,
  ( match_before([Slash],RFs0,_,Rs,End1),member(Dot,RFs0)->true
  ; RFs0=""
  ),
  RDs0=End1,
  !,
  ( % swap dir and file if dir looks like *.*
    RFs0="",member(Dot,RDs0)->RDs="",RFs=RDs0
  ; RDs=RDs0,RFs=RFs0
  ),
  (RDs=[Slash,Slash|As]->NewRDs=[Slash|As]
  ; \+(RDs=[Slash|_]), [QM]="?", \+(member(QM,RDs)) ->NewRDs=[Slash|RDs]
  ; NewRDs=RDs
  ),
  reverse(NewRDs,Ds),
  (Ds=[Slash,Slash|Xs]->Ds=[Slash|Xs]
  ; \+(Ds=[Slash|_])->NewDs=[Slash|Ds]
  ; NewDs=Ds
  ),
  reverse(RFs,Fs).
  
% recognizes obvious text/html/VRML etc. files which may contain links
is_text_file(''):-!. % might be dir or cgi-bin
is_text_file(File):-
  name(File,Fs),
  has_text_file_sufix(Fs,_).

% detects files likely to be text files containing http:// links
has_text_file_sufix(Fs,Suf):-
  reverse(Fs,Rs),
  % known as text files
  member(Suf,
      [".html",".htm",".shtml",".asp",".txt",".wrl",".pro",".pl",".java",".c",
       ".xml","xsl",
       ".HTML",".HTM",".SHTML",".ASP",".TXT",".WRL",".PRO",".PL",".JAVA",".C",
       ".XML","XSL"
      ]),
  reverse(Suf,RSuf),
  append(RSuf,_,Rs),
  !.

has_known_file_sufix(Fs,Suf):-has_text_file_sufix(Fs,Suf),!.
has_known_file_sufix(Fs,Suf):-
  reverse(Fs,Rs),
  % known as text files
  member(Suf,
      [".jpg",".gif"
      ,".JPG",".jpg"
      ]),
  reverse(Suf,RSuf),
  append(RSuf,_,Rs),
  !.
  
% conversion tools

% replaces some chars with their hex-escaped %XY versions

hex_escape(Cs,Hs):-hex_escape(Cs,Hs,[]).

hex_escape([],Cs,Cs).
hex_escape([C|Cs],HHs,Hs):-hex_convert(C,HHs,Xs),hex_escape(Cs,Xs,Hs).

hex_convert(C,Cs):-hex_convert(C,Cs,[]).

hex_convert(C,Cs,Bs):-ok_as_is(C),!,Cs=[C|Bs].
hex_convert(C,Cs,Bs):-special_to_hex(C,Cs,Bs).

ok_as_is(X):-member(X,"%/|.-+?&"),!.
ok_as_is(C):-is_an(C).

special_to_hex(Spec,Cs):-special_to_hex(Spec,Cs,[]).

special_to_hex(Spec,[37,A,B|Cs],Cs):-
  DA is Spec // 16,
  DB is Spec mod 16,
  to_hex_char(DA,A),
  to_hex_char(DB,B).

to_hex_char(DA,A):-DA>=10,!,[B]="A", A is B+DA-10.
to_hex_char(DA,A):-[B]="0",A is B+DA.

debug_print(Css):-
    quiet(Q),Q<2,member(Cs,Css),write_chars(Cs),nl,
  fail.
debug_print(_).


% reads a file line by line, backtracks until end, then fails

file2line(Path,File0,Cs):-
  namecat(Path,'',File0,File),
  exists_file(File),
  seeing(F),see(File),
    repeat,
    (read_chars(Cs)->true
    ; !,seen,see(F),fail
    ).

/* PORTING to 9x */

socket_try(S,G):-synchronize(socket_try0(S,G)).

socket_try0(_,Goal):-Goal,!.
socket_try0(Socket,Goal):-
  close_socket(Socket),
  debugmes(warning_socket_io_failed_for(Goal)),
  fail.

/*
reverse(List, Reversed) :-
	reverse(List, [], Reversed).

reverse([], Reversed, Reversed).
reverse([Head|Tail], SoFar, Reversed) :-
	reverse(Tail, [Head|SoFar], Reversed).
*/

/* end of PORTING */
