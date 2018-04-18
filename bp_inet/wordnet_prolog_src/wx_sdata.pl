% STORY FIELD DATA AND FIELD DEFINITIONS
  
sf(
  [title],[
    def="This element refers to the complete title of story.",
    qs=[
      "What is the story called?",
      "What is the title?",
      "What is the name of the work?",
      "Does this story have a label?",
      "Does this work have a label?",
      "Does this story have a title?",
      "Does this work have a title?"
    ]
  ]
).


sf([creator],
    [
      def="The creator is the name and other identifying information of the storyteller.", 
      wh(who)=[[author],[teller],[storyteller],[artist],[performer],[story,teller]],
      qs=[
         "Who told the story?",
         "Who was telling the story?",
         "Who performed?"
      ]
    ]
).

sf([subject],[
   def="The subject of the story contains a brief description of what the story is about. It should not be a full description of the story, but rather serves to indicate the purpose behind the tale.",
    wh(what)=[[event],[purpose],[theme],[topic],[object],[story,about]]
  ]
).

sf([description],
  [
    def="This element should contain a brief synopsis of the story.  It should not describe every action in the story, but should rather give a brief overview of the major characters, conflicts, and resolutions.",
    qs=[
"What is the category?",
"What is the classification?",
"What is the summary?",
"What is the explanation?",
"What is the conflict?",
"How does it end?",
"How does it resolve?",
"What is the overview?"
]]).

sf([publisher],[
  def="The publisher refers to the entity or person(s) that are ultimately responsible for the housing and display of the story.  In the case of the Digital Story Project, the publisher would be the University of North Texas.", 
  wh(who)=[[promoter],[organizer],[administrator]],
  qs=[
   "What is the publishing house?",
   "What is the publishing firm?",
   "What is the publishing company?",
   "Who is the publicist?"
  ]
]).


sf([contributor],[
  def="The contributor element lists those entities or persons who helped to make the development, display, or housing of the story possible.  For example, the Digital Story Project gives credit to the University of North Texas Center for Distributed Learning Video Department for its contributions to the development of the electronic versions of the storytelling performances.",
  wh(who)=[[participant],[helper],[player],[partner],[assistant]],
  qs=[
    "who contributed to this?",
    "Who made it?",
    "Who helped make it?"
  ]
]).

sf([language],[
 def="This element refers to the primary language used in the storytelling performance (ex. English, German, Spanish).",
  qs=["What is the dialect?",
      "What is the lingo?",
      "What is the language?"
  ]
]).  

sf([coverage],[
  def="Coverage relates to the temporal span or setting of the story, if such is relevant.  For example, the Middle Ages or the 18th century.",
  qs=[
"What is the time period?",
"What is the time span?",
"What is the interval?",
"What is the duration?",
"What is the length of the time?",
"What is the timeline?"
]]).


/*
% TODO MORE LIKE THIS

dc:date – The "date" refers to the month, day, and year on which the digital version of the storytelling performance was placed online.  The appropriate format is MM/DD/YY (all numeric with no leading zeros).
When was it published?
When was it entered?
When did it originate?
When was it made?
When did it get done?

dc:type - The Dublin Core "type" for most story performances used in the Digital Story Project is "image.moving.film".  This is derived from the DCMI Type Vocabulary List (http://www.dublincore.org/documents/dcmi-type-vocabulary/), and is used to describe a video or film of a performance that has been rendered in a digital format (such as RealOne).
What is the substance?

dc:format –  This element stores the Internet Media Type (http://www.isi.edu/in-notes/iana/assignments/media-types/media-types) of the encoding format used for the file.  In the case of the Digital Storytelling Project, this will generally be the RealOne format (application.rm).
What kind of video is it?
What is the structure?
What is the form?
What is the formation?

dc:identifier – This "identifier" element stores a unique underscore-delimited title for each story.  This identifier is used in the title of each individual story's XML and multimedia files (ex. the_ride.xml corresponds to the_ride.rm).

What is the exact code name?
What is the the mark-up language?

dc:source – "Source" refers to the project or other entity of which the story is a part.  For most Digital Storytelling Project files, the University of North Texas Digital Storytelling Project would be the appropriate source.
Who is the supplier?

What is the project?
Who did this project?



dc:relation - "Relation" refers to any existing tale cycles or groupings which are logically related to the story.  Examples would be the "Jack Tales" or the "Uncle Remus" stories.
What is the relationship?
What is the affiliation?
What is the connection?
What is the association?
What is another story like this one?


dc:rights - The data in this element indicates who holds the legal rights to the management of the story.  For most Digital Storytelling Project files, this element would contain the phrase "University of North Texas Digital Storytelling Project."
Who owns the copyright?
Who has ownership?
Who is the owner?
Who has possession?
Who has the legal rights?

  Story Core Elements
sc:project - This element refers to the name of the project (if any) to which the story belongs (ex. "UNT Digital Storytelling Project").
What is the name of the project?
Who is the group undertaking this?
What enterprise did this?
What venture did this?


sc:recording-created - The "date" refers to the month, day, and year on which the digital version of the storytelling performance was recorded.  The appropriate format is MM/DD/YY (all numeric with no leading zeros).
What is the creation date?
When did the recording happen?
When was the inception?
When was the origination?

sc:duration - The "duration" is the running time of the digital recording in hours, minutes, and seconds.  The appropriate format is HH:MM:SS with no leading zeros.
What is the length of the story/recording?
What is the span…?
What is the extent…?
How long is the story?
How long will the story last?

sc:dimensions - This element refers to the display dimensions (in pixels) of the digital recording, using the format "width x height" (ex. 200 x 150).
What is the magnitude?
What is the measure/measurement?
What is the length?
What size is the format?


sc:filesize - The "filesize" relates to the size in megabytes of the digital recording, expressed to three decimal places with no leading zeros, followed by a space and a capital "M."  For example: "14.813 M."
How big is the file?
How large is the file?
What is the size of the file?
*/


sf([event],[
  def="The event is the gathering or recording situation that places the performance in context.  For example, an event may be the name of a storytelling festival, storytime at an elementary school, or an in-studio recording.",
  qs=[  
"What was the venue?",
"Where did the recording happen?",
"Where did the recording take place?",
"What was the occasion?",
"What was the situation?",
"What were the circumstances?",
"What was the function?"
]]).


sf([intended,-,audience],[
def="The intended-audience element is used to indicate the ideal age range of those who listen to the story.  There are only three age delineations: children, general, and mature.  The mature indicator is used to tag stories which may be inappropriate for children.  More than one indicator can be used in this element, separated by the word <and> (ex. children and general).",
qs=[
"Who should listen to this story?",
"What audience is this for?",
"What is the story rated?",
"Who should hear this story?",
"Is this for general audiences?"
]]).


sf([emotion],[
 def="This element is reserved for data which represent the emotional impact (or other emotional factors) of the story.",
qs=[ 
"What feelings come out?",
"What is the mental state of the character?",
"What is the emotional impact?",
"Is it a happy story?",
"Is it a sad story?",
"Is it an angry story?",
"It is an emotional story?",
"Does it make you cry?"
]]).



sf([story,-,author],[
  def="This element is used to list the name of the author of the story, who may or may not be the storyteller.",
  qs=[
"Who wrote the story?",
"Who is the writer?",
"Who is the creator?",
"Who is the scribe?",
"Who wrote the original story?",
"What is the source of the story?"
]]).

sf([gender],[
  def="The gender element is used to indicate the gender of the storyteller, male or female.",
qs=[
  "What is the sex of the storyteller?",
  "What is the gender of the storyteller?",
  "Is the storyteller male or female?",
  "Is this story told by a man?",
  "Is this story told by a woman?"
]]).

sf([ethnicity],[
  def="This element indicates the self-defined ethnicity of the storyteller.",
  qs=[
"What is the cultural background of the storyteller?",
"What is the race of the storyteller?",
"What is the community of the storyteller?",
"What is the nationality of the storyteller?",
"What is the native land of of the storyteller?"
]]).

sf([age],[
  def="The age of the storyteller relates to the stage of life of the performer - child or adult.",
  qs=[
"How old is the performer?",
"What is the maturity level?",
"What is the age of the storyteller?"
]]).


sf([performance,-,style],[
  def="The performance style is the vocal means by which the performer delivers the story. Acceptable descriptive terms include talk, oral narration and singing.",
  qs=[
"How is the story presented?",
"How is the story expressed?",
"How is the story executed?",
"How is the story carried out?",
"How is the story conducted?",
"How is the story realized?",
"Does it have singing?",
"Does it have poetry?"
]]).

/*
sc:instrument– This element is used to list any musical instruments used by the storyteller in the performance.
Is there music?
Is there a piano?
IS there an orchestra?
Is there an instrument?
Are there instruments?


sc:props– This element is used to list any physical props used by the storyteller in the performance (ex. puppets, masks, hats).
Are there props?
Are there objects used?
Are there puppets?
Are there masks?
Are there hats?

% same as ethnicity ... - discarded
sc:cultural-origin - The "cultural origin" element refers to the culture from which the story originates.  This may range from the specific subculture (ex. Mennonite) to the cultural region (ex. Yoruba, Appalachian) or even country-wide grouping (ex. Irish, Russian).
What is the race?
What is the community/clan/tribe?
What is the nationality?
Who are the kin?
Who are the people?
What is the lineage?
What is native land?

sc:geographic-origin– The "geographic origin" element refers to the specific geographic area from which the story originated.  This may be a state, commonwealth, country, or other geographic area (which may contain many cultures and ethnicities).  
What is the territory?
What is the province?
What is the locale?
What is the location?
What is the domain?
What is the region?
What is the country?
What geographic place does it come from?
*/

sf([genre],[
def="Genre refers to a general description of the type of story to which the one under consideration belongs.  Multiple applicable genres may be indicated.  Specific, formal tale types should not be listed here - the element should be used to indicate categories of story that are not used in formal tale-typing systems.  Examples of genres would be mysteries, westerns, horror, animal stories, and inspirational tales.",
qs=[
"What is the literary form?",
"What is the genre?",
"What is the literary style?",
"What kind of story it is?"
]]).


sf([theme],[
  def="The theme of the story is the goal of the story - the lesson to be learned or the moral to be illustrated, for example.  Examples of this concept include self-reliance, determination, and perseverance.",
  qs=[
"What is the subject matter?",
"What is the topic?",
"What is the motif?",
"What is the thought?"
]]).



sf([tale,-,type],[
def="The tale-type refers to the broad, formal category of the story, such as legend, fable, or myth.",
qs=[
"What is the classification of the story?",
"What is the story group?",
"What is the nature of the story?",
"Is it a fairytale?",
"Is it a folktale?",
"Is it a humorous tale?",
"Is it an animal tale?",
"Is it a legend?",
"Is it an oral history?"
]]).

sf([motif],[
  def="The motif element refers to the major elements of the story, as defined by the Stith-Thompson index or the works of other folklorists.",
qs=[
"What is the theme?",
"What is the concept?",
"What is the pattern?",
"What are the elements of the story?",
"What are the motifs?"
]]).

sf([setting], [
def="The setting of the story is the physical location (not geographic area) in which the story takes place.  This may indicate a structure (ex. house, castle, sailing ship), an aspect of landscape (ex. element, ocean, river bottoms), or any other applicable location.",
qs=[
"What is the environment?",
"What are the surroundings?",
"What is the locale?",
"What is the scenery?",
"What is the scene?",
"What is the atmosphere?",
"What is the habitat?",
"What is the setting?"
]]).

sf([characters], [
def="This element contains a list of the names (or descriptions) of the characters in the story (ex. the King, the baker, Mr. Johnson).",
qs=[
"Who are the people in the story?",
"Who is the cast?",
"Who are the characters?",
"Who is in the story?",
"Who is the story about?"
]]).

sf([archetypes],[
def="Archetypes refer to the major types of characters used in the story.  These types are very general, referring to general (often stereotypical) characters that can be found in a number of stories worldwide.  Examples of entries for this element include the brave knight, the wise old woman and the trickster animal.",
qs=[
"What is the typical character?",
"What is the model character?",
"What is the character pattern?",
"What is the character prototype?",
"What is the character paradigm?",
"What is the ideal character?",
"What is the standard character?"
]]).

sf([coda],[
def="The coda is the ending expression of the story, stated or implied.  A common coda is: they lived happily ever after. A coda may also be used to summarize the essential point of the story (ex. Stop crying and keep trying.",
qs=[
"What is the conclusion?",
"What is the finale?",
"What is the closing?"
]]).

sf([text],[
def="This element contains the actual text of the story, as transcribed from the digital recording.",
qs=["What are the words of the story?",
"What is the wording of the story?",
"What is the text of the story?",
"What is the content of the story?",
"What is the transcript of the story?"
]]).

