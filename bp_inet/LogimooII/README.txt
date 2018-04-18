LogiMOO requires a BinProlog based Internet Server. To start it on a 
computer called "my_machine.my_domain.com" do the following: 

If you have the source distribution type: 

logimoo.bat 

or

bp world_server

otherwise (binary distribution - you can redistribute this to your customers as
well) type 

bpr world_server.wam 

The  server will listen on port 8888. Start your local LogiMOO client by 
opening with Internet Explorer the link: 

http://localhost:8888/<absolute path where the file is>/world_guest.html 

To make your version of LogiMOO available on the Internet please edit in the file
world_guest.html the line containing action="http://localhost:8888/nofile.pro" to 
reflect the location of your server's location i.e something like: 

action="http://my_machine.my_domain.com:8888/nofile.pro" 

The server will handle LogiMOO queries directly, WITHOUT requiring  another 
Web Server. This is a completely self contained Web program as far as the server 
has a static, well known Web address. 

If you wish, enter clauses to be assumed before the query is run in the
lower window. For instance, if you choose language french and add "cuisine@kitchen." 
the query processor will understand something like "Batis une cuisine, va la,
ou suis je?" 

Language files (english.pl, spanish.pl, french.pl) are for now very basic, 
suggestions on improvements and files for other languages are welcome, please 
send them to tarau@cs.unt.edu.For now, output is english only - we plan to have
multi-lingual output in the near future. Please read  the LogiMOO Online User Guide 
for more information. 
  

---------------------------- FRENCH VERSION -----------------------------
Version NT/W85/W98 de LogiMOO. Il a maintenant
une bonne documentation ainsi qu'un serveur Web integre - il
devrait donc etre tres facile a l'installer.

Je deposerai le logiciel a l'addresse:

http://www.cs.unt.edu/~tarau/priv/e-com_lm

d'ou vous pouvez le downloder. J'y pose aussi
un executable unzip.exe. Apres le download,
faites simplement unzip *.zip, et par la suite:

cd logimooII

go.bat (pour lancer le serveur)

et ensuite, entrez dans la fenetre de de Netscape ou Explorer

http://localhost:8888/<le repertoire de LogiMOO>world_guest.html

Le guide d'utilisation est dans le fichier UserGuide.html,
il explique aussi les applications potentielle du logiciel.
