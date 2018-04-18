/*
This will get compiled to C and then made into a DLL.
Use include declarations to add files to the project,
like the following:

:-[myfile1].
....
:-[myfileN].

*/

:-dynamic(a/1).

a(1).
a(2).

b(X):-a(X).

go:-
  println(calling(b/1)),
  foreach(b(X),println(X)),
  nl,listing,
  println(done).

main:-go.
