The components of of the BinNet Natural Language toolkit are
packaged together in the following directories:

wordnet_agent: contains a Prolog Server Agent supporting running a
               conversational agent from the Web. We use Microsoft Agent
               components to provide text-to-speech and animated characters
               which run under Internet Explorer from the Web. Please take
               a look at our prototype application at

                 http://logic.csci.unt.edu:8080/wordnet_agent/frame.html

               and feel free to adapt/modify it and launch it on as a Web
               application.
               

and 

wordnet_prolog_src:
               a fairly large set of tools, in source form, putting WordNet
               relations at heavy use in a variety of algorithms. Take a
               look at the file wx_natlang.pl and wx_graph.pl for a number of
               syntactic/semantic processing components and WordNet graph
               processing predicates.

               You can also try out, from a user's perspective, by typing
               brun.bat (or jrun.bat for a jinni based version) after uncompressing
               fetching the following 2 files containing precompiled binaries from:

http://www.binnetcorp.com/priv/wordnet/runtime.zip

and then expand them to the current default location, c:\paul\wordnet\ directory.
The toolkit allows you to regenerate, from the original WordNet 2.0 the
refactored high-performance WordNet databases wx_run.wam (BinProlog binary
version) and wx_run.jc (Jinni binary version) but that is a fairly lengthy
process, see the file makeall.bat for all the steps involved. 

You might want to look in the sources of wnet.pl which also
contains a number of extensions to the original WordNet 2.0 like like,
for instance, reverse relations and O(1) mappings form words and word
phrases to synsets.


eliza_agent:
             minimal application, a good starting point to build something
             frrom scratch

psa:
             minimal BinProlog or Jinni based Prolog Server Agent - a good starting
             point for your very first attempt to put a Prolog application on the Web

jinstant.zip: contains a Yahoo Instant Messenger adaptor to use for chat applications
             please reconfigure its main file to attach it to your own Yahoo instant
             Messanger agent. As part of the maintenance process please download the new
             Hamsam adaptors which enable the activation of the chat agents, from:


             http://sourceforge.net/projects/hamsam


             which is licensed as an LGPL component.

jgoogle.zip:

             contains a google API adaptor for Jinni. If you plan to use it, please obtain
             a key of your own from Google supporting 1000 free queries/day through the Google
             Java API and replace the temporary key in the code that we use in our demos.