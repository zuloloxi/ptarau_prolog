Installing the BinNet Internet Toolkit:

The default assumptions hold for a Windows machine, but adapting to Unix 
is mostly changing some path information. 

Just uncompress the file bp_inet.zip, containing the toolkit components you
have ordered to a directory bp_inet. The resulting directories are as follows: 

+---bin : BinProlog and Jinni binaries
+---cgi: BinProlog based CGI scripts
+---data: various data files used by some of the applications
+---doc: documentation
+---eliza_agent: simple Prolog Server Agent running with BinProlog and Jinni
+---images: images used by various applications
+---jsa: Jinni Prolog Server Agent showing a simple Web based TCP-IP tunnel allocator
+---library: BinProlog client and server libraries
+---psa: Minimal Prolog Server Agent - good starting point for your first applications
+---spider: BinProlog based Web spider
+---ssi: Server Side Prolog Query Evaluator
+---stocknet: Jinni based stock market infromation extractor and Prolog database generator
+---tests
+---wordnet_agent: Web interface to WordNet based conversational agent
+---wordnet_prolog_src: sources of WordNet processor - for Web based natural language
    applications - requires BinNet Prolog Natural Language KIT and refactored WordNet database

This is needed for running the CGI scripts. Configure your web
server for exec access on bp_intet/bin and read access on bp_inet/cgi.

Most Prolog Server Agent components are self-contained and start with 
default values by simply typing run.bat in their directories, after
putting bp_inet/bin in your search PATH.

PLEASE READ the summaries provided in README.txt
files in each directory, to get a glimpse on the functionality
provided by various components. 

Enjoy,

Paul Tarau
BinNet Corp.
