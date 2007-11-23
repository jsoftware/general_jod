NB. System: jodtools  Author: John D. Baker  Email: bakerjd99@gmail.com
NB. Version: 0.2.3  Build Number: 72  Date: 23 Nov 2007 11:28:52

NB.*jodtools c-- JOD tools class - extends JOD utility class.
NB.
NB. Interface words:
NB.  addgrp   add words/tests to group/suite                                          
NB.  allnames combines names from (refnames) and (obnames)                            
NB.  allrefs  all names referenced by objects on name list                            
NB.  delgrp   remove words/tests from groups/suites                                   
NB.  getrx    get required to execute                                                 
NB.  hlpnl    displays short descriptions of objects on (y.)                          
NB.  jodage   days since last change and creation of JOD objects
NB.  jodhelp   display online JOD help                     
NB.  lg       make and load JOD group                                                 
NB.  mls      make load script                                                        
NB.  mt       get macro text from edit window                                         
NB.  noexp    returns a list of objects with no explanations                          
NB.  notgrp   words or tests from (y) that are not in groups or suites               
NB.  nt       gets name and text from edit windows                                    
NB.  nw       edit a new explicit word using JOD conventions                          
NB.  obnames  unique sorted object and locale names from (uses) result                
NB.  pr       put and cross reference a word - very handy as an editor DOCUMENTCOMMAND
NB.  refnames unique sorted reference names from (uses) result                        
NB.  revonex  returns a list of put dictionary objects with no explanations           
NB.  swex     set short word explaination from (doc) header                           
NB.  usedby   returns a list of words from (y) that DIRECTLY call words on (x)      
NB.
NB. Notes:
NB.   Error messages (jodtools range {unassigned})

coclass 'ajodtools'
coinsert  'ajodutil'
NB.*end-header

NB. carriage return character
CR=:13{a.


DOCUMENTMARK=:123 126 78 126 125 61 58 32 123 126 67 126 125 32 58 32 48 10 10 78 66 46 42 123 126 78 126 125 32 123 126 84 126 125 45 45 32 119 111 114 100 116 101 120 116 10 78 66 46 10 78 66 46 32 109 111 110 97 100 58 32 32 123 126 78 126 125 32 63 63 10 78 66 46 32 100 121 97 100 58 32 32 63 63 32 123 126 78 126 125 32 63 63 10 10 39 78 73 77 80 32 123 126 78 126 125 39 10 41{a.

NB. jodtools z interface words
IzJODtools=:<;._1 ' addgrp allnames allrefs delgrp fsen getrx hlpnl jodage lg locgrp ltx mg mls mt noexp notgrp nt nw obnames pr refnames revonex swex tt usedby'

NB. comment tag marking end of scripts.ijs entries that are JOD (mls) generated
JODLOADEND=:'NB.</JODLoadScripts>'

NB. comment tag marking start of scripts.ijs entries that are JOD (mls) generated
JODLOADSTART=:'NB.<JODLoadScripts>'

NB. line feed character
LF=:10{a.


POSTAMBLEPFX=:'POST_'

NB. name of test used as a template
TESTSTUB=:'teststub'


addgrp=:4 : 0

NB.*addgrp v-- add words/tests to group/suite.
NB.
NB. monad:  clGroup addgrp blclNames
NB.         (clGroupSuite;iaObject) addgrp blclNames
NB.
NB.   'jodhlp' addgrp  ;:'addgrp delgrp'
NB.   ('testsuite';3) addgrp ;:'test and moretests'

'group code'=. 2{.(boxopen x),<2
uv0=. code grp group
if. 0=>{.uv0 do. uv0
elseif. 1=>{.uv0=.code grp (group;}.uv0),y=.boxopen y do.
  gtyp=.,>(code=2 3)#;:'words tests'
  1;((":#y),' ',gtyp,' added to ->');group
elseif.do. uv0
end.
)


addloadscript=:4 : 0

NB.*addloadscript v-- inserts (mls) generated scripts into scripts.ijs.
NB.
NB. dyad:  baPublic addloadscript (clGroup ; clPathGroup)

if. 1=x do.
  NB. get scripts.ijs (J 5.02 or later)
  NB. J path utility !(*)=. jpath
  scripts=. read cfg=. jpath'~system\extras\config\scripts.ijs'
  tags=. JODLOADSTART;JODLOADEND
  'p c'=. tags betweenidx scripts
  if. 1=#p do.
    if. badrc ld=. (;p{c) addloadscript1 y do. ld return. else. ld=.>1{ld end.
    (toHOST ;(<ld) p} c) write cfg
  elseif. 0=#p do.
    NB. no JOD load scripts append current
    ld=. (0{tags),(<LF,'buildpublic 0 : 0',LF),(0{y),(<'  '),(1{y),(<LF,')',LF),1{tags
    (toHOST scripts , (2#LF), ;ld) write cfg
  elseif.do.
    (jderr 'tag error in scripts.ijs file ->'),<cfg return.
  end.
  NB. run scripts.ijs to make changes active
  curr=. 18!:5''
  try. 0!:0 <cfg 
  catchd.
    18!:4 curr
    jderr 'failure executing scripts.ijs' return.
  end.
  18!:4 curr
  ok 'load script saved ->';(1{y) ,&.> <IJS
elseif. 0=x do.
  ok 'file saved ->';(1{y) ,&.> <IJS
elseif.do.
  jderr 'invalid make load script option (0 or 1)'
end.
)


addloadscript1=:4 : 0

NB.*addloadscript1 v-- appends or replaces a script in the load script section of scripts.ijs
NB.
NB. dyad:  clJODLoadScripts addloadscript1 (clGroup ; clPath)

NB. insure we have text
if. 0=#x do. ok x return. end.

NB. cut into lines
ldl=. <;._1 ((LF={.x)}.LF),x -. CR

NB. search for group name - can occur at most once
NB. searches only group names ignoring path file text
msk=. (' '&beforestr &.> ldl) e. 0{y
if. 1 >: +/msk do.

  NB. load script name and path
  scr=. <;(<'  ') (1)} 1 0 1 #^:_1 y

  NB. if name exists replace it else add it at end
  if. +./msk do.
    ldl=. scr (I. msk)} ldl
  else.
    NB. find ) and insert before 
    msk=. 1 ,~ -. (ldl -.&.> ' ') e. <,')'
    ldl=. scr (I. -.msk)} msk #^:_1 ldl
  end.

  NB. return modified 
  ok }. ; LF ,&.> ldl
else.
  (jderr 'load script is not unique - edit scripts.ijs ->'),0{y
end.
)


allnames=:~.@('__'&beforestr&.>@obnames , refnames)
allrefs=:[: /:~ [: ~. ] , [: refnames 31&uses


betweenidx=:4 : 0

NB.*betweenidx v-- indexed sublists between nonnested delimiters.
NB.
NB. Cuts  up  lists   containing   balanced  nonnested  start/end
NB. delimiters into boxed lists of indexed sublists.
NB.
NB. Note:  this  verb does a simple count for  delimiter balance.
NB. This  is  a   necessary  but  not  sufficient  condition  for
NB. delimiter balance.
NB.
NB. dyad:  (ilIdx ;< blcl) =. (clStart;clEnd) betweenidx cl
NB.        (ilIds ;< blnl) =. (nlStart;nlEnd) betweenidx nl
NB.
NB.   ('start';'end') betweenidx 'start yada yada end boo hoo start ahh end'
NB.
NB.   '{}' betweenidx 'go{ahead}{}cut{me}{up}{}'
NB.
NB.   NB. also applies to numeric delimiters
NB.   (1 1;2 2) betweenidx 1 1 66 666 2 2 7 87 1 1 0 2 2

if. #y do.
  's e'=. x                      NB. start/end delimiters
  assert. -. s -: e              NB. they must differ
  em=. e E. y                    NB. end mask
  sm=. (-#s) |.!.0 s E. y        NB. start mask
  mc=. +/sm                      NB. middle count
  assert. mc=+/em                NB. delimiter balance
  c=. (1 (0)} sm +. em) <;.1 y   NB. cut list

  NB. insert any missing middles to insure all indexed
  NB. sublists correspond to a location in the cut list
  ex=. 1 #~ >: +: mc
  ex=. (-. sm {.;.1 em) (>: +: i. mc)} ex
  c=. ex #^:_1 c

  ((# i.@#) (#c)$0 1);<c         NB. prefix indexes
else.
  (i.0);<y                       NB. empty arg result
end.
)


createjodtools=:3 : 0

NB.*createjodtools v-- initializes new jod tools object
NB.
NB. monad:  createjodtools blclObjects
NB.
NB.   JODtools_z_=: conew 'ajodtools'           NB. new tools object
NB.   createjodtools__JODtools JODtools,JODobj  NB. pass self and tools

NB. use JOD object reference to locate extant subobjects
NB. Note: currently these object references are not used
NB. but are defined so that native JOD words can be accessed
NB. by words in JODtools instances in future additions to this class
NB. !(*)=. ST MK UT SO
self=.0{y [ jod=.1{y
ST=:ST__jod
MK=:MK__jod
UT=:UT__jod
SO=:SO__jod

NB. append object reference to list of JOD extensions
NB. adding to this list allows (destroyjod) to destroy
NB. all JOD extension objects with JOD core objects
JODEXT__jod=: JODEXT__jod,self

NB. add tool words to overall JOD (z) locale interface
NB. (*)=. IZJODALL JODEXT
IZJODALL__jod=: IZJODALL__jod,IzJODtools,<'JODtools'

zwords=. IzJODtools ,&.> locsfx 'z'
if. 1 e. uv=.0 <: nc zwords do.
  msg=. '(ajodtools) z interface clashes with current z locale names.'
  msg=. msg,LF,'Current z names retained - (ajodtools) interface not defined.'
  msg=. msg,LF,LF,'Access JOD tools via JODtools object, e.g.  swex__JODtools'
  msg=. msg,LF,'Warning: JODtools_z_ now points to this object.'
  msg,LF,LF,'z clashes:',LF,ctl list >uv#zwords
else.
  NB. define direct (z) locale interface for tools - if the (z)
  NB. trap word (jodsf) exists define an error trapping interface
  NB. (i.0 0)"_ ".&.> (IzJODtools,&.><'_z_=: '),&.> IzJODtools ,&.> locsfx self
  (i.0 0)"_ ".&.> self defzface IzJODtools
end.
)


dayage=:3 : 0

NB.*dayage v-- age in days.
NB.
NB. monad:  dayage ilYYYYMMDD
NB.
NB.   dayage 1953 7 2
NB.
NB. dyad:  pa dayage iaYYYYMMDD | iuYYYYMMDD
NB.
NB.   1 dayage 4 4$20000101 19500202 19000303
NB.   0 dayage 1986 8 14

0 dayage y
:
if. x do. n=. today~ 0 else. n=. today 0 end.
(x todayno n) - x todayno y
)


delgrp=:4 : 0

NB.*delgrp v-- remove words/tests from groups/suites.
NB.
NB. monad:  clGroup delgrp blclNames
NB.         (clGroupSuite;iaObject) delgrp blclNames
NB.
NB.   'jodhlp' delgrp  ;:'addgrp delgrp'
NB.   ('testsuite';3) delgrp ;:'test and moretests'

'group code'=. 2{.(boxopen x),<2
uv0=. code grp group
if. 0=>{.uv0 do. uv0
elseif. 1=>{.uv0=.code grp group;}.uv0-.y=.boxopen y do.
  gtype=.,>(code=2 3)#;:'words tests'
  1;((":#y),' ',gtype,' deleted from ->');group
elseif.do. uv0
end.
)


firstcomment=:3 : 0

NB.*firstcomment v-- extracts the first comment sentence from J words.
NB.
NB. monad:  firstcomment clLinear
NB.
NB.   firstcomment 5!:5 <'firstcomment'
NB.   firstcomment disp 'jodword'
NB.
NB.   NB. first comments from many JOD non-nouns
NB.   n=. (}. grp 'JOD') -. 0 1 0 dnl''
NB.   t=. 1 pick 0 8 get n
NB.   n=. ({."1 t) #~  0= #&> {:"1 t
NB.   d=. 1 pick 0 10 get n
NB.   c=. n ,. firstcomment&.> 2{"1 d

NB. char table of just comment text
comtext=. 3 }."1 ljust onlycomments ];._2 (y-.CR),LF

NB. drop text below any monad and dyad marks
mask=. +./"1 ((,:MONADMARK) E. comtext) +. (,:DYADMARK) E. comtext
comtext=. ,' ' ,. comtext #~  -. +./\ mask

NB. take the first comment to end with a '.'
NB. excluding any J argument strings, eg. x. y.
NB. NIMP may not hold in j 6.01
comtext=. reb comtext {.~ firstperiod comtext
if. #comtext do.

  NB. trim scriptdoc style headers if any
  if. '*'={.,comtext do.
    alltrim '--' afterstr comtext
  end.

end.
)


firstperiod=:3 : 0

NB.*firstperiod v-- returns the index of first sentence period.
NB. J arguments m. n. x. y. u. v. are excluded.
NB.
NB. monad:  firstperiod cl
NB.
NB.   firstperiod 'not here {m. or here [u. or here (x.) or here u. but here. Got that'

NB. mask out J arguments in at most first 500 chars
y=. (500<.#y){.y
args=. ;&.> , { (<<"0' ([{'),<;:'m. n. x. y. u. v. *.'
y=.' ' (bx _2  (|. !. 0) +./ args E.&> <y)} y

NB. first period after masking
y i. '.'
)


fsen=:] ; [: firstcomment disp


getrx=:3 : 0

NB.*getrx v-- get required to execute. (getrx) gets all the words
NB. required to execute words on (y).
NB.
NB. Warning:  if  the words listed on  (y)  refer to  object  or
NB. locale references  this verb  returns  an  error because such
NB. words generally cannot be run out of context.
NB.
NB. monad:  getrx clName | blclNames
NB.
NB.   NB. loads words into base locale
NB.   getrx 'stuffineed'
NB.   getrx ;:'stuff we words need to run'
NB.
NB. dyad:  clLocale getrx clName | blclNames
NB.
NB.   'targetlocale' getrx ;:'load the stuff we need into locale'

'base' getrx y
:
if. badrc uv0=. 31 uses y do. uv0
elseif. #uv1=. obnames uv0 do. (jderr 'words refer to objects/locales ->'),uv1
elseif. uv0=.~.({."1 >{:uv0),refnames uv0
        badrc uv1=. x get uv0 do. uv1
elseif.do.
  ok '(',(":#uv0),') words loaded into -> ',x
end.
)


hlpnl=:3 : 0

NB.*hlpnl v-- displays short descriptions of objects on (y)
NB.
NB. monad:  hlpnl clName|blclNames
NB.
NB.   hlpnl refnames uses 'explainmycalls'
NB.
NB. dyad:  iaObject hlpnl clName|blclNames
NB.
NB.   2 hlpnl }.grp''

0 hlpnl y
:
if. 0=>{.uv0=. (x,8) get y do. uv0
else.
  uv0=.>{:uv0
  (>{."1 uv0) ; >{:"1 uv0
end.
)


jodage=:3 : 0

NB.*jodage  v--  days  since  last  change  and creation  of  JOD
NB. objects.
NB.
NB. monad:  jodage zl | cl | blcl
NB.
NB.   age }. dnl 'ageus'
NB.
NB. dyad:  iaCode jodage zl|cl|blcl

0 jodage y
:
if. badil x do. jderr 'invalid option(s)'
elseif. y=. boxopen y
        badrc changed=. (({.x),14) get y do. changed
elseif. badrc created=. (({.x),13) get y do. created
elseif.do.
  g=. /:daychanged=. <.,.1 dayage <.changed=. rv changed
  daycreated=. ,.<.1 dayage <.created=. rv created
  NB. header=. ;:'name changed created datechanged datecreated'
  header=. <;._1 '/Name/Date First put/Days from First put/Date Last put/Days from Last put'
  NB. header ,: (<g) {&.> (>y);daychanged;daycreated;(,.changed);<,.created
  ok<header ,: (<g) {&.> (>y);(,.created);daycreated;(,.changed);<daychanged
end.
)


lg=:3 : 0

NB.*lg v-- make and load JOD group.
NB.
NB. (lg) assembles and loads  JOD group  scripts. The monad loads
NB. without  the  postprocessor  and  the  dyad  loads  with  the
NB. postprocessor.
NB.
NB. monad:  lg clGroup
NB.
NB.   lg 'groupname'  NB. no postprocessor
NB.
NB. dyad:  uu lg clGroup
NB.
NB.   2 lg 'group'    NB. no postprocessor
NB.   lg~  'group'    NB. postprocessor

2 lg y
:
if. x-:2 do.
  NB. 2 _2 make assembles entire group script
  NB. with preamble regardless of where the
  NB. group appears on the JOD path
  msg=.' group loaded'
  t=. 2 _2 make y
else.
  msg=.' group loaded with postprocessor'
  t=. 2 mls y
end.
'r s'=. 2{.t
if. r do.
  curr=. 18!:5 ''   NB. current locale
  18!:4 <'base'     NB. run script from base
  try. 0!:0 s
  catchd.
    18!:4 curr      NB. restore locale
    (jderr 'J script error in group ->'),y;13!:12 ''
    return.
  end.
  18!:4 curr        NB. restore locale
  ok (y),msg
else.
  t
end.
)


locgrp=:3 : 0

NB.*locgrp v-- list groups and suites with name.
NB.
NB. monad:  locgrp clName
NB.
NB.   locgrp 'dd'

NB. get group and suite names
gs=. 2 3 dnl&.> <''
if. *./ m=. ; {.&> gs do.
  gs=. }.&.> gs
  gnl=. 2 3 }.@:grp &.> &.> gs
  m=. gnl (+./@:e.)&>&.> <<<,y
  ok <('Groups';'Suites') ,. m#&.> gs
else.
  >{. (-.m) # &.> gs
end.
)


ltx=:] ; 22"_ ; gt
mg=:2 _1&make


mls=:3 : 0

NB.*mls v-- make load script.
NB.
NB. Generates a J (load) script from a JOD group and  an optional
NB. POST_ process macro script.
NB.
NB. monad:  mls clGroupName
NB.
NB.   NB. generate script and add to public scripts
NB.   mls 'JODaddon'
NB.
NB.   scripts 'e'       NB. JODaddon is now on scripts
NB.   load 'JODaddon'   NB. load's like any J load script
NB.
NB. dyad:  baPublic mls clGroupName
NB.
NB.   NB. make script but do not add to public scripts
NB.   0 mls 'JODaddon'
NB. 
NB.   NB. make script and return text
NB.   2 mls 'JODaddon'

1 mls y
:

NB. HARDCODE: option qualifier codes
NB. 2 _2 make assembles entire group script
NB. with preamble regardless of where the
NB. group appears on the JOD path
v=. 2 _2 make gn=. y -. ' '
'r s'=. 2{.v
if. r do.
  NB. group make succeeded - append any POST_ script
  postpfx=. POSTAMBLEPFX
  if. badrc sp=. 4 dnl postpfx do. sp return. end.
  if. (<ps=. postpfx , gn) e. }.sp do.
	v=. 4 get ps
    'r p'=. 2{.v
    if. r do. s=. s , (2#LF) , (<0;2) {:: p else. v return. end.
  end.
  if. 2-:x do. ok s
  else.
    pdo=. {:0{DPATH__ST__JODobj      NB. put dictionary directory object
    lsn=. (SCR__pdo),gn,IJS__JODobj  NB. load script full path name
    (toHOST s) write lsn
    NB. update scripts.ijs
    x addloadscript gn;(SCR__pdo),gn
  end.
else.
  v
end.
)

NB. get macro text from edit window
mt=:] ; 21"_ ; gt


noexp=:3 : 0

NB.*noexp v-- returns a list of objects with no explanations.
NB.
NB. monad:  noexp zl|clPattern
NB.
NB.   noexp ''  NB. words without short explanations
NB.
NB. dyad:  iaCode noexp zl | clPattern
NB.
NB.   2 noexp 'jod'       NB. groups without explanations
NB.   (i.5) noexp"0 1 ''  NB. all objects without explanations

0 noexp y
:
if. badrc uv=.x dnl y do. uv
elseif. a: e. uv       do. ok ''
elseif. badrc uv=. (({.x),EXPLAIN) get }.uv do. uv 
elseif. 0=#uv=. rv uv  do. ok''
elseif.do.
 ok (0 = #&> {:"1 uv) # {."1 uv
end.
)


notgrp=:3 : 0

NB.*notgrp v-- words or tests from (y) that are not in groups or
NB. suites. Useful for finding loose ends and dead code.
NB.
NB. monad:  notgrp blcl
NB.
NB.   notgrp }. revo ''     NB. recent ungrouped words
NB.
NB. dyad:  iaObject notgrp blcl
NB.
NB.   2 notgrp }. dnl ''    NB. ungrouped words
NB.   3 notgrp }. 1 dnl ''  NB. tests that are not in suites

GROUP notgrp y
:
if. badrc y=. checknames y do. y return. end.
y=. }. y
select. x
  case. GROUP do. ok y -. ; grp&.> }. GROUP dnl ''
  case. SUITE do. ok y -. ; SUITE grp&.> }. SUITE dnl ''
  case.do. jderr 'invalid options'
end.
)


nt=:3 : 0

NB.*nt v-- edit a new test script using JOD conventions.
NB.
NB. This  verb  looks   for  (TESTSTUB)  on  the  path   of  open
NB. dictionaries allowing easy user defined test script formats.
NB.
NB. monad:  nt clTest
NB.
NB.   nt 'scriptname'

name=. y -. ' '

NB. get teststub document from open dictionaries
'r s'=.2{.t=. 1 get TESTSTUB
if. r do.
  stamp=.tstamp''
  test=. ('/{~T~}/',name,'/{~created~}/',stamp,'/{~errortime~}/',stamp) changestr >1{,s
  name et test
else.
  t
end.
)


nw=:3 : 0

NB.*nw v-- edit a new explicit word using JOD conventions.
NB. 
NB.
NB. monad:  nw clWord
NB.   
NB.   nw 'verb'
NB.
NB. dyad:  iaClass nw clWord 
NB.
NB.   1 nw 'adverb'

3 nw y  
:
name=. y -. ' '
if. -.x e. i. 5 do. x=.3 end.
class=. x{'nacvv'

NB. user defined post proc !(*)=. DOCUMENTCOMMAND
if. 0= (4!:0) <'DOCUMENTCOMMAND' do.
  word=.DOCUMENTMARK,LF,LF,DOCUMENTCOMMAND
else.
  word=.DOCUMENTMARK
end.

reps=. '/{~N~}/',(y-.' '),'/{~C~}/',(":x),'/{~T~}/',class 
word=. reps changestr word
name et word
)


obnames=:[: /:~ [: ~. [: ; 2: {"1 [: > {:


onlycomments=:3 : 0

NB.*onlycomments v-- removes all J code leaving comments.
NB.
NB. monad:	ct =. onlycomments ctJcode
NB.
NB.   onlycomments jcr 'onlycomments'  NB. self comments

NB. mask of unquoted comment starts
c =. ($y)$'NB.' E. ,y
c =. -. +./\"1 c > ~:/\"1 y e. ''''
y =. ,y

NB. blank out code
y =. ' ' ((,c)# i. # y)} y
y =. y $~ $c
y #~ y +./ . ~: ' '  NB. remove blank rows
)


pathexp=:3 : 0

NB.*pathexp  v--  returns a bt (name,text) table of short non-put
NB. dictionary   explanations.   Useful   for    copying    short
NB. explanations into the put dictionary.
NB.
NB. monad:  pathexp blclNames
NB.
NB.   pathexp 0 1 3 noexp ''
NB.
NB. dyad:  iaCode pathexp blclNames
NB.
NB.   2 pathexp 2 noexp 'JOD'

0 pathexp y
:

badrc=:[: -. 1: -: [: > {.
null=. 0 0$''

NB. path order object list
if.     badrc path=. did 0  do. path
elseif. 2>#path=. }.path    do. 0;'requires at least two dictionaries on path'
elseif. badrc uv=. (x,_1) dnl'' do. uv
elseif. a: e. uv            do. null
elseif.
        uv=.; }.}.uv
        common=. uv -. uv -. y
        0=#common           do. null

elseif. badrc uv=. 3 od >{.path  do. uv
elseif. badrc uv=. (({.x),8) get common do. uv  NB. HARDCODE 8
elseif. 0=#uv=. rv_ajod_ uv  do. null
elseif.do.
 od path [ 3 od ''
 (0 < #&> {:"1 uv) # uv
end.
)


pr=:0&globs ,:~ put
pt=:] ; 25"_ ; gt
putfc=:0 8"_ put fsen
refnames=:[: /:~ [: ~. [: ; 1: {"1 [: > {:


revonex=:3 : 0

NB.*revonex v-- returns a  list of put dictionary objects with no
NB. explanations.
NB.
NB. This verb is  similiar to (noexp) except it only searches put
NB. dictionary objects and (noexp) searches the entire path.
NB.
NB. monad:  revonex zl | clPattern
NB.
NB.   revonex ''  NB. put dictionary words without short explanations
NB.
NB. dyad:  iaCode revonex zl|clPattern
NB.
NB.   2 revonex 'jod'       NB. put dictionary groups without explanations
NB.   (i.5) revonex"0 1 ''  NB. all put dictionary objects without explanations

/:~ 0 revonex y
:
if. badrc uv=./:~ x revo y do. uv
elseif. a: e. uv  do. ok ''
elseif. badrc uv=. (({.x),EXPLAIN) get }.uv do. uv 
elseif. 0=#uv=. rv uv  do. ok ''
elseif.do.
 ok (0 = #&> {:"1 uv) # {."1 uv
end.
)


strexp=:3 : 0

NB.*strexp v-- returns a boxed list of words containing string
NB. (y.) in short description.
NB.
NB. monad:  blcl =. strexp clStr
NB.
NB.   strexp 'REFERENCE'

'rc short'=.0 8 get }. dnl''
if. rc do.
  ({."1 short) #~ (<y) (+./@:E.)&> {:"1 short
else.
  rc;short
end.
)


swex=:0 8&put@:fsen


today=:3 : 0

NB.*today v-- returns todays date.
NB.
NB. monad:  ilYYYYMMDD =. today uu
NB.
NB.   today 0    NB. ignores argument
NB.
NB. dyad:  iaYYYYMMDD =. uu today uu
NB.
NB.   0 today 0

3&{.@(6!:0) ''
:
0 100 100 #. <. 3&{.@(6!:0) ''
)


todayno=:3 : 0

NB.*todayno v-- convert dates to day numbers, converse  (todate).
NB.
NB. WARNING: valid only for  Gregorian dates after  and including
NB. 1800 1 1.
NB.
NB. monad:  todayno ilYYYYMMDD
NB.
NB.   dates=. 19530702 19520820 20000101 20000229
NB.   todayno 0 100 100 #: dates
NB.
NB. dyad:  pa todayno itYYYYMMDD
NB.
NB.   1 todayno dates

0 todayno y
:
a=. y
if. x do. a=. 0 100 100 #: a end.
a=. ((*/r=. }: $a) , {:$a) $,a
'y m d'=. <"_1 |: a
y=. 0 100 #: y - m <: 2
n=. +/ |: <. 36524.25 365.25 *"1 y
n=. n + <. 0.41 + 0 30.6 #. (12 | m-3),"0 d
0 >. r $ n - 657378
)

NB. get test text from edit window
tt=:] ; gt


usedby=:4 : 0

NB.*usedby  v--  returns  a list of words from (y)  that DIRECTLY
NB. call  words  on  (x). The  result of this verb depends on JOD
NB. dictionary references being up-to-date.
NB.
NB. dyad:  cl|blcl usedby blcl
NB.
NB.   'wordname' usedby }. dnl ''
NB.   ('word';'names') usedby }. revo ''
NB.
NB.   'putgs__ST' usedby }. dnl ''

NB. (uses) is expensive for large word lists.
if. badrc uv=.uses y do. uv
else.
  uv=. >{: uv
  names=. boxopen x
  NB. search object and locale references if _ occurs in any name
  col=. >: +./ '_'&e.&> names
  ok /:~ ({."1 uv) #~  ; (col {"1 uv) +./@e.&.> < names
end.
)

NB.*jodtools s-- jodtools postprocessor.

NB. create/initialize a JOD tools object
JODtools_z_=: conew 'ajodtools'            NB. new tools object
(1!:2&2) createjodtools__JODtools JODtools,JODobj  NB. pass self and JOD
