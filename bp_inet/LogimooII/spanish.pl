construya@craft.
% dese@give:- member(W,[la,los,las]),lookahead(W),  !.
% dese lo al presidente
% give it to_the president
puerta@port.

dese@give.
dele@give.

esta@is.
estoy@am.
soy@am.
tiene@has.
cave@dig. 
diga@dig. 
abra@open.
vaya@go.
venga@come.
mire@look.
construi@crafted.
construya@craft.
              
                      un@a.
                      una@a.
                                  perro@dog.
                                  perra@dog.
                                  gato@cat.
                                  gata@cat.
                                  brujo@wizard.
                                  bruja@wizard.
                                  yo@i.
                                  dormitorio@bedroom.
                                  vestibulo@lobby.

					    
                                   habitacion@room.   
                                                 lo@it.
                                                 %la@it.
                                                 el@the.
                                                 del@the.
                                                 la@the.

                                                           a@to.
                                                           al@to.
                                                           de@to.

donde@where.
quien@who.
que@that.
                      alsur@south.
                      alnorte@north.
                      alli@there.

porfavor@please.
                   
X@X.

test_data("Yo soy Paul.").   
test_data("Construya un gato. Donde esta el gato? Quien tiene lo?").   
                                                          % lo tiene
test_data("Cave una habitacion_huespedes. Vaya alli. Cave una cocina.").
test_data("Construya un gnu. Quien tiene lo?").   % lo tiene
test_data("Cave una oficina, vaya alli.").   
test_data("Vaya al vestibulo. Mire.").
 
test_data("Yo soy el brujo. Donde estoy yo?").

test_data("Construya un perro-gif. Dese lo al brujo.").
test_data("Construya un gato. Donde esta el gato? Quien tiene lo?").
test_data("Cave el dormitorio. Vaya alli. Cave una cocina, abra una puerta alsur de la cocina, vaya alli, abra una puerta alnorte del dormitorio. Vaya alli. Construya una cancion-au. Dese lo al brujo. Mire."). %dele
test_data("Yo soy Diana. Construya un automovil. Donde esta el automovil?").
test_data("Construya un Gnu. Quien tiene lo? Donde esta el Gnu? Donde estoy yo?").
test_data("Dele al brujo el Gnu que yo construi. Quien tiene lo?").

test_data("Yo soy Maria.").
test_data("Diga hola!").
test_data("Yo soy la Diana.").
%test_data("Diga hola!").
test_data("Construya una gramatica.").
test_data("Mire. Dese la gramatica que yo construi a Maria.").

test_data("Yo soy Maria. Mire.").
test_data("Quien tiene la gramatica?").

test_data("Yo soy Diana.").
test_data("Yo soy Guillermo.").
test_data("Mire.").
test_data("Construya un libro. Dele el libro a Diana.").
test_data("Mire.").
test_data("Quien tiene el libro?").

% test_data("come wizard! please wizard look.").

/* TRACE:

>: test.
WORDS: [test,.]
SENTENCES: [test]

==BEGIN COMMAND RESULTS==
TEST: Yo soy Paul.
WORDS: [yo,soy,paul,.]
SENTENCES: [yo,soy,paul]

==BEGIN COMMAND RESULTS==
login as: paul with password: none
your home is at http://142.58.28.116/~guest

SUCCEEDING(iam(paul))

==END COMMAND RESULTS==


TEST: Construya un gato. Donde esta el gato? Quien tiene lo?
WORDS: [construya,un,gato,.,donde,esta,el,gato,?,quien,tiene,lo,?]
SENTENCES: [construya,un,gato] [donde,esta,el,gato] [quien,tiene,lo]

==BEGIN COMMAND RESULTS==
SUCCEEDING(craft(cat))
cat is in lobby
SUCCEEDING(where(cat))
paul has cat
SUCCEEDING(who(has,cat))

==END COMMAND RESULTS==


TEST: Cave una habitacion_huespedes. Vaya alli. Cave una cocina.
WORDS: [cave,una,habitacion_huespedes,.,vaya,alli,.,cave,una,cocina,.]
SENTENCES: [cave,una,habitacion_huespedes] [vaya,alli] [cave,una,cocina]

==BEGIN COMMAND RESULTS==
SUCCEEDING(dig(habitacion_huespedes))
you are in the  habitacion_huespedes
SUCCEEDING(go(habitacion_huespedes))
SUCCEEDING(dig(cocina))

==END COMMAND RESULTS==


TEST: Construya un gnu. Quien tiene lo?
WORDS: [construya,un,gnu,.,quien,tiene,lo,?]
SENTENCES: [construya,un,gnu] [quien,tiene,lo]

==BEGIN COMMAND RESULTS==
SUCCEEDING(craft(gnu))
paul has gnu
SUCCEEDING(who(has,gnu))

==END COMMAND RESULTS==


TEST: Cave una oficina, vaya alli.
WORDS: [cave,una,oficina,(,),vaya,alli,.]
SENTENCES: [cave,una,oficina] [vaya,alli]

==BEGIN COMMAND RESULTS==
SUCCEEDING(dig(oficina))
you are in the  oficina
SUCCEEDING(go(oficina))

==END COMMAND RESULTS==


TEST: Vaya al vestibulo. Mire.
WORDS: [vaya,al,vestibulo,.,mire,.]
SENTENCES: [vaya,al,vestibulo] [mire]

==BEGIN COMMAND RESULTS==
you are in the  lobby
SUCCEEDING(go(lobby))
user(guest,none,'http://142.58.28.116/~guest').
user(paul,none,'http://142.58.28.116/~guest').
login(paul).
online(guest).
online(paul).
place(lobby).
place(habitacion_huespedes).
place(cocina).
place(oficina).
contains(lobby,guest).
contains(lobby,paul).
contains(lobby,cat).
contains(lobby,gnu).
has(paul,cat).
has(paul,gnu).
crafted(paul,cat).
crafted(paul,gnu).
SUCCEEDING(look)

==END COMMAND RESULTS==


TEST: Yo soy el brujo. Donde estoy yo?
WORDS: [yo,soy,el,brujo,.,donde,estoy,yo,?]
SENTENCES: [yo,soy,el,brujo] [donde,estoy,yo]

==BEGIN COMMAND RESULTS==
login as: wizard with password: none
your home is at http://142.58.28.116/~guest

SUCCEEDING(iam(wizard))
you are in the  lobby
SUCCEEDING(whereami)

==END COMMAND RESULTS==


TEST: Construya un perro-gif. Dese lo al brujo.
WORDS: [construya,un,perro,-,gif,.,dese,lo,al,brujo,.]
SENTENCES: [construya,un,perro,-,gif] [dese,lo,al,brujo]

==BEGIN COMMAND RESULTS==
SUCCEEDING(craft(dog.gif))
logimoo:<wizard># 'wizard:I give you dog.gif'
SUCCEEDING(give(wizard,dog.gif))

==END COMMAND RESULTS==


TEST: Construya un gato. Donde esta el gato? Quien tiene lo?
WORDS: [construya,un,gato,.,donde,esta,el,gato,?,quien,tiene,lo,?]
SENTENCES: [construya,un,gato] [donde,esta,el,gato] [quien,tiene,lo]

==BEGIN COMMAND RESULTS==
SUCCEEDING(craft(cat))
cat is in lobby
SUCCEEDING(where(cat))
paul has cat
wizard has cat
SUCCEEDING(who(has,cat))

==END COMMAND RESULTS==


TEST: Cave el dormitorio. Vaya alli. Cave una cocina, abra una puerta alsur de l
a cocina, vaya alli, abra una puerta alnorte del dormitorio. Vaya alli. Construy
a una cancion-au. Dese lo al brujo. Mire.
WORDS: [cave,el,dormitorio,.,vaya,alli,.,cave,una,cocina,(,),abra,una,puerta,als
ur,de,la,cocina,(,),vaya,alli,(,),abra,una,puerta,alnorte,del,dormitorio,.,vaya,
alli,.,construya,una,cancion,-,au,.,dese,lo,al,brujo,.,mire,.]
SENTENCES: [cave,el,dormitorio] [vaya,alli] [cave,una,cocina] [abra,una,puerta,a
lsur,de,la,cocina] [vaya,alli] [abra,una,puerta,alnorte,del,dormitorio] [vaya,al
li] [construya,una,cancion,-,au] [dese,lo,al,brujo] [mire]

==BEGIN COMMAND RESULTS==
SUCCEEDING(dig(bedroom))
you are in the  bedroom
SUCCEEDING(go(bedroom))
SUCCEEDING(dig(cocina))
SUCCEEDING(open_port(south,cocina))
you are in the  cocina
SUCCEEDING(go(cocina))
SUCCEEDING(open_port(north,bedroom))
you are in the  bedroom
SUCCEEDING(go(bedroom))
SUCCEEDING(craft(cancion.au))
logimoo:<wizard># 'wizard:I give you cancion.au'
SUCCEEDING(give(wizard,cancion.au))
user(guest,none,'http://142.58.28.116/~guest').
user(paul,none,'http://142.58.28.116/~guest').
user(wizard,none,'http://142.58.28.116/~guest').
login(wizard).
online(guest).
online(paul).
online(wizard).
place(lobby).
place(habitacion_huespedes).
place(cocina).
place(oficina).
place(bedroom).
contains(lobby,guest).
contains(lobby,paul).
contains(lobby,gnu).
contains(bedroom,wizard).
contains(bedroom,'dog.gif').
contains(bedroom,cat).
contains(bedroom,'cancion.au').
has(paul,cat).
has(paul,gnu).
has(wizard,'dog.gif').
has(wizard,cat).
has(wizard,'cancion.au').
crafted(paul,cat).
crafted(paul,gnu).
crafted(wizard,'dog.gif').
crafted(wizard,cat).
crafted(wizard,'cancion.au').
port(bedroom,south,cocina).
port(cocina,north,bedroom).
SUCCEEDING(look)

==END COMMAND RESULTS==


TEST: Yo soy Diana. Construya un automovil. Donde esta el automovil?
WORDS: [yo,soy,diana,.,construya,un,automovil,.,donde,esta,el,automovil,?]
SENTENCES: [yo,soy,diana] [construya,un,automovil] [donde,esta,el,automovil]

==BEGIN COMMAND RESULTS==
login as: diana with password: none
your home is at http://142.58.28.116/~guest

SUCCEEDING(iam(diana))
SUCCEEDING(craft(automovil))
automovil is in lobby
SUCCEEDING(where(automovil))

==END COMMAND RESULTS==


TEST: Construya un Gnu. Quien tiene lo? Donde esta el Gnu? Donde estoy yo?
WORDS: [construya,un,gnu,.,quien,tiene,lo,?,donde,esta,el,gnu,?,donde,estoy,yo,?
]
SENTENCES: [construya,un,gnu] [quien,tiene,lo] [donde,esta,el,gnu] [donde,estoy,
yo]

==BEGIN COMMAND RESULTS==
SUCCEEDING(craft(gnu))
paul has gnu
diana has gnu
SUCCEEDING(who(has,gnu))
gnu is in lobby
SUCCEEDING(where(gnu))
you are in the  lobby
SUCCEEDING(whereami)

==END COMMAND RESULTS==


TEST: Dele al brujo el Gnu que yo construi. Quien tiene lo?
WORDS: [dele,al,brujo,el,gnu,que,yo,construi,.,quien,tiene,lo,?]
SENTENCES: [dele,al,brujo,el,gnu,que,yo,construi] [quien,tiene,lo]

==BEGIN COMMAND RESULTS==
logimoo:<diana># 'wizard:I give you gnu'
SUCCEEDING(give(wizard,gnu))
paul has gnu
wizard has gnu
SUCCEEDING(who(has,gnu))

==END COMMAND RESULTS==


TEST: Yo soy Maria.
WORDS: [yo,soy,maria,.]
SENTENCES: [yo,soy,maria]

==BEGIN COMMAND RESULTS==
login as: maria with password: none
your home is at http://142.58.28.116/~guest

SUCCEEDING(iam(maria))

==END COMMAND RESULTS==


TEST: Diga hola!
WORDS: [diga,hola,!]
SENTENCES: [diga,hola]

==BEGIN COMMAND RESULTS==
SUCCEEDING(dig(hola))

==END COMMAND RESULTS==


TEST: Yo soy la Diana.
WORDS: [yo,soy,la,diana,.]
SENTENCES: [yo,soy,la,diana]

==BEGIN COMMAND RESULTS==
login as: diana with password: none
your home is at http://142.58.28.116/~guest

SUCCEEDING(iam(diana))

==END COMMAND RESULTS==


TEST: Construya una gramatica.
WORDS: [construya,una,gramatica,.]
SENTENCES: [construya,una,gramatica]

==BEGIN COMMAND RESULTS==
SUCCEEDING(craft(gramatica))

==END COMMAND RESULTS==


TEST: Mire. Dese la gramatica que yo construi a Maria.
WORDS: [mire,.,dese,la,gramatica,que,yo,construi,a,maria,.]
SENTENCES: [mire] [dese,la,gramatica,que,yo,construi,a,maria]

==BEGIN COMMAND RESULTS==
user(guest,none,'http://142.58.28.116/~guest').
user(paul,none,'http://142.58.28.116/~guest').
user(wizard,none,'http://142.58.28.116/~guest').
user(diana,none,'http://142.58.28.116/~guest').
user(maria,none,'http://142.58.28.116/~guest').
login(diana).
online(guest).
online(paul).
online(wizard).
online(diana).
online(maria).
place(lobby).
place(habitacion_huespedes).
place(cocina).
place(oficina).
place(bedroom).
place(hola).
contains(lobby,guest).
contains(lobby,paul).
contains(lobby,gnu).
contains(bedroom,wizard).
contains(bedroom,'dog.gif').
contains(bedroom,cat).
contains(bedroom,'cancion.au').
contains(lobby,diana).
contains(lobby,automovil).
contains(lobby,maria).
contains(lobby,gramatica).
has(paul,cat).
has(paul,gnu).
has(wizard,'dog.gif').
has(wizard,cat).
has(wizard,'cancion.au').
has(diana,automovil).
has(wizard,gnu).
has(diana,gramatica).
crafted(paul,cat).
crafted(paul,gnu).
crafted(wizard,'dog.gif').
crafted(wizard,cat).
crafted(wizard,'cancion.au').
crafted(diana,automovil).
crafted(diana,gnu).
crafted(diana,gramatica).
port(bedroom,south,cocina).
port(cocina,north,bedroom).
SUCCEEDING(look)
logimoo:<diana># 'maria:I give you gramatica'
SUCCEEDING(give(maria,gramatica))

==END COMMAND RESULTS==


TEST: Yo soy Maria. Mire.
WORDS: [yo,soy,maria,.,mire,.]
SENTENCES: [yo,soy,maria] [mire]

==BEGIN COMMAND RESULTS==
login as: maria with password: none
your home is at http://142.58.28.116/~guest

SUCCEEDING(iam(maria))
user(guest,none,'http://142.58.28.116/~guest').
user(paul,none,'http://142.58.28.116/~guest').
user(wizard,none,'http://142.58.28.116/~guest').
user(diana,none,'http://142.58.28.116/~guest').
user(maria,none,'http://142.58.28.116/~guest').
login(maria).
online(guest).
online(paul).
online(wizard).
online(diana).
online(maria).
place(lobby).
place(habitacion_huespedes).
place(cocina).
place(oficina).
place(bedroom).
place(hola).
contains(lobby,guest).
contains(lobby,paul).
contains(lobby,gnu).
contains(bedroom,wizard).
contains(bedroom,'dog.gif').
contains(bedroom,cat).
contains(bedroom,'cancion.au').
contains(lobby,diana).
contains(lobby,automovil).
contains(lobby,maria).
contains(lobby,gramatica).
has(paul,cat).
has(paul,gnu).
has(wizard,'dog.gif').
has(wizard,cat).
has(wizard,'cancion.au').
has(diana,automovil).
has(wizard,gnu).
has(maria,gramatica).
crafted(paul,cat).
crafted(paul,gnu).
crafted(wizard,'dog.gif').
crafted(wizard,cat).
crafted(wizard,'cancion.au').
crafted(diana,automovil).
crafted(diana,gnu).
crafted(diana,gramatica).
port(bedroom,south,cocina).
port(cocina,north,bedroom).
SUCCEEDING(look)

==END COMMAND RESULTS==


TEST: Quien tiene la gramatica?
WORDS: [quien,tiene,la,gramatica,?]
SENTENCES: [quien,tiene,la,gramatica]

==BEGIN COMMAND RESULTS==
maria has gramatica
SUCCEEDING(who(has,gramatica))

==END COMMAND RESULTS==


TEST: Yo soy Diana.
WORDS: [yo,soy,diana,.]
SENTENCES: [yo,soy,diana]

==BEGIN COMMAND RESULTS==
login as: diana with password: none
your home is at http://142.58.28.116/~guest

SUCCEEDING(iam(diana))

==END COMMAND RESULTS==


TEST: Yo soy Guillermo.
WORDS: [yo,soy,guillermo,.]
SENTENCES: [yo,soy,guillermo]

==BEGIN COMMAND RESULTS==
login as: guillermo with password: none
your home is at http://142.58.28.116/~guest

SUCCEEDING(iam(guillermo))

==END COMMAND RESULTS==


TEST: Mire.
WORDS: [mire,.]
SENTENCES: [mire]

==BEGIN COMMAND RESULTS==
user(guest,none,'http://142.58.28.116/~guest').
user(paul,none,'http://142.58.28.116/~guest').
user(wizard,none,'http://142.58.28.116/~guest').
user(diana,none,'http://142.58.28.116/~guest').
user(maria,none,'http://142.58.28.116/~guest').
user(guillermo,none,'http://142.58.28.116/~guest').
login(guillermo).
online(guest).
online(paul).
online(wizard).
online(diana).
online(maria).
online(guillermo).
place(lobby).
place(habitacion_huespedes).
place(cocina).
place(oficina).
place(bedroom).
place(hola).
contains(lobby,guest).
contains(lobby,paul).
contains(lobby,gnu).
contains(bedroom,wizard).
contains(bedroom,'dog.gif').
contains(bedroom,cat).
contains(bedroom,'cancion.au').
contains(lobby,diana).
contains(lobby,automovil).
contains(lobby,maria).
contains(lobby,gramatica).
contains(lobby,guillermo).
has(paul,cat).
has(paul,gnu).
has(wizard,'dog.gif').
has(wizard,cat).
has(wizard,'cancion.au').
has(diana,automovil).
has(wizard,gnu).
has(maria,gramatica).
crafted(paul,cat).
crafted(paul,gnu).
crafted(wizard,'dog.gif').
crafted(wizard,cat).
crafted(wizard,'cancion.au').
crafted(diana,automovil).
crafted(diana,gnu).
crafted(diana,gramatica).
port(bedroom,south,cocina).
port(cocina,north,bedroom).
SUCCEEDING(look)

==END COMMAND RESULTS==


TEST: Construya un libro. Dele el libro a Diana.
WORDS: [construya,un,libro,.,dele,el,libro,a,diana,.]
SENTENCES: [construya,un,libro] [dele,el,libro,a,diana]

==BEGIN COMMAND RESULTS==
SUCCEEDING(craft(libro))
logimoo:<guillermo># 'diana:I give you libro'
SUCCEEDING(give(diana,libro))

==END COMMAND RESULTS==


TEST: Mire.
WORDS: [mire,.]
SENTENCES: [mire]

==BEGIN COMMAND RESULTS==
user(guest,none,'http://142.58.28.116/~guest').
user(paul,none,'http://142.58.28.116/~guest').
user(wizard,none,'http://142.58.28.116/~guest').
user(diana,none,'http://142.58.28.116/~guest').
user(maria,none,'http://142.58.28.116/~guest').
user(guillermo,none,'http://142.58.28.116/~guest').
login(guillermo).
online(guest).
online(paul).
online(wizard).
online(diana).
online(maria).
online(guillermo).
place(lobby).
place(habitacion_huespedes).
place(cocina).
place(oficina).
place(bedroom).
place(hola).
contains(lobby,guest).
contains(lobby,paul).
contains(lobby,gnu).
contains(bedroom,wizard).
contains(bedroom,'dog.gif').
contains(bedroom,cat).
contains(bedroom,'cancion.au').
contains(lobby,diana).
contains(lobby,automovil).
contains(lobby,maria).
contains(lobby,gramatica).
contains(lobby,guillermo).
contains(lobby,libro).
has(paul,cat).
has(paul,gnu).
has(wizard,'dog.gif').
has(wizard,cat).
has(wizard,'cancion.au').
has(diana,automovil).
has(wizard,gnu).
has(maria,gramatica).
has(diana,libro).
crafted(paul,cat).
crafted(paul,gnu).
crafted(wizard,'dog.gif').
crafted(wizard,cat).
crafted(wizard,'cancion.au').
crafted(diana,automovil).
crafted(diana,gnu).
crafted(diana,gramatica).
crafted(guillermo,libro).
port(bedroom,south,cocina).
port(cocina,north,bedroom).
SUCCEEDING(look)

==END COMMAND RESULTS==


TEST: Quien tiene el libro?
WORDS: [quien,tiene,el,libro,?]
SENTENCES: [quien,tiene,el,libro]

==BEGIN COMMAND RESULTS==
diana has libro
SUCCEEDING(who(has,libro))

==END COMMAND RESULTS==



SUCCEEDING(test)

==END COMMAND RESULTS==

>:


*/
