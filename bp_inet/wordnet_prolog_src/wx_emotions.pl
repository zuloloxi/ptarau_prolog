/* 
based on Andrew Ortony's dimensional analysis of emotions:
*/

% emotion(focus,emotion)
emotion(entity,[like,dislike]).
emotion(person,[approve,disaprove]).
emotion(self,[pride,shame]).
emotion(event(pacient=self),[please,displease]).
emotion(event(pacient=other),[gloat,pity,resent,happy]).
emotion(event(future),[hope,fear]).
emotion(event(realized=positive),[satisfaction,relief]).
emotion(event(realized=negative),[disappointment, fear_confirmed]).
emotion(role(owner=self),[gratification,remorse]).
emotion(role(owner=other),[gratitude,anger]).

prise_word(Ws,T,R):-w2itn(Ws,I,T,N),prise(x(I,N),R).
belittle_word(Ws,T,R):-w2itn(Ws,I,T,N),belittle(x(I,N),R).

% prise(X,R):-prise_this(X,R).

prise(X,R):-opposite(X,Y),belittle_this(Y,R).
prise(X,R):-similar(X,Y),prise_this(Y,R).

% belittle(X,R):-belittle_this(X,R).

belittle(X,R):-opposite(X,Y),prise_this(Y,R).
belittle(X,R):-similar(X,Y),belittle_this(Y,R).

prise_this(x(I,N),value(yes,T,Ws)):-i2wtn(I,Ws,T,N).

belittle_this(x(I,N),value(no,T,Ws)):-i2wtn(I,Ws,T,N).

similar(x(I,N),x(I,N)).
similar(x(I,_),x(J,_)):-sim(I,J).

opposite(x(I,NI),x(J,NJ)):-ant(I,NI,J,NJ).

% metaphor(Adj,Noun,MetAdj,MetNoun):-
