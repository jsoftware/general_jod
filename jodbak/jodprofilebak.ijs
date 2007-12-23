NB.*jodprofile s-- JOD dictionary profile.
NB.
NB. An example JOD profile script. Save this script in
NB.
NB. ~addons\general\jod\
NB.
NB. with the name jodprofile.ijs
NB.
NB. This script  is  executed  after all dictionary  objects have
NB. been created. It  can  be used  to  set up  your default  JOD
NB. working environment.
NB.
NB. WARNING: Do not dpset 'RESETME' if more than one  JOD task is
NB. active. If only one task is active RESETME's prevent annoying
NB. already open  messages that frequently result from forgetting
NB. to close dictionaries upon exiting J.
NB.
NB. Note to  J developers. A shutdown sentence (a line  of J  the
NB. interpretor  executes  before   terminating)  would  be  very
NB. useful.
NB.
NB. author: John D. Baker
NB. email:  bakerjd99@gmail.com

NB. set white space preservation on
9!:41 [ 1

NB. do not reset if you are running more than one JOD instance
dpset 'RESETME'

NB. make JOD tools available
load 'jodtools'

NB. \joddictionaries directory drives - varies from machine to machine
NB. NIMP support \\unic directories
JODDICDRV_z_=: 'c:'
JODSECDRV_z_=: 'e:'

NB. following are handy (z) locale shortcuts:

NB. project shortcuts - use explicit 
NB. defintions so it's easy to reset the group/suite
ag_z_=: 3 : 'JODGRP addgrp y'
as_z_=: 3 : '(JODSUI;3) addgrp y'
dg_z_=: 3 : 'JODGRP delgrp y'
ds_z_=: 3 : '(JODSUI;3) delgrp y'
   
NB. referenced group words not in group
nx_z_=: 3 : '(allrefs  }. gn) -. gn=. grp JODGRP'
   
NB. words in group using a word
ug_z_=: 3 : 'y usedby }. grp JODGRP'
   
NB. generate & save load script
sg_z_=: 3 : 'mls JODGRP [ y'

NB. top (put dictionary) words, groups in revision order
tw_z_=: revo
tg_z_=: 2&revo

NB. run tautology as plaintest - does not stop on nonzero results
rt_z_=: 2&rtt

NB. run macro silently - will show explict smoutput
rs_z_=: 1&rm

NB. short help for group words
hg_z_=: [: hlpnl [: }. grp

NB. short help on put objects in revised order from code:
NB.   hr 4  NB. macro
NB.   hr 2  NB. groups
hr_z_=: 13 : 'y hlpnl }. y revo '''' [ y'

NB. single line explanation for nonwords
NB.  4 slex 'jodregister'  NB. macro
NB.  1 slex 'thistest'     NB. test
slex_z_=: 4 : '(x,8) put y;firstcomment__JODtools x disp y'

NB. regenerate put dictionary word cross references
reref_z_=: 3 : '(n,.s) #~ -.;0{"1 s=.0 globs&>n=.}.revo'''' [ y'

NB. handy cl doc helpers
NB. NIMP extend (doc) to handle these cases
docscr_z_=: 3 : 'ctl_ajod_ (61;0;0;''NB.'') docct2__UT__JODobj ];._1 LF,y-.CR'
doctxt_z_=: 3 : 'ctl_ajod_ (61;0;0;'''') docct2__UT__JODobj ];._1 LF,y-.CR'

NB. document group and suite headers
docgh_z_=: 4 : 'x put y;docscr (x,1) disp y'
docg_z_=: 2&docgh

NB. display noun on screen and return noun value
showpass_z_=:] [ 1!:2&2

NB. open working dictionaries and run project macros
NB. set up current project (1 suppress IO, 0 or elided display)
NB. 1 rm 'prjThumbutilsSetup' [ smoutput od ;: 'imagedev image utils'
NB. 1 rm 'prjflickr' [ smoutput od ;:'flickrutdev flickrut utils'
NB. 1 rm 'prjcbh' [ smoutput od ;:'cbh utils'
NB. 1 rm 'prjjod' [ smoutput od ;:'joddev jod utils'