NB.*resetjod s-- JOD reset script for J 6.0x
NB.
NB. NOTE: This reset script will  only work for J 6.0x and  later
NB. systems. This script will not work  for J versions prior to J
NB. 6.01.
NB.
NB. This script resets the JOD system. It erases files created by
NB. (installjod.ijs) and deletes the  current  master file. After
NB. running  this script rerun  (installjod.ijs) to complete  the
NB. reset.
NB.
NB. verbatim:
NB.
NB. WARNING:******************************************************
NB. **************************************************************
NB.      This reset erases files and removes directories!!!
NB.
NB.   1) The master file is erased. 
NB.   2) All dictionaries created under the (~user\joddicts) branch
NB.      are deleted.
NB.   3) The (jodprofile.ijs) is erased - you lose your customizations.
NB.
NB. John D. Baker bakerjd99@gmail.com

NB. WARNING: this install script ASSUMES the standard J
NB. startup profile has been loaded.  If you are running a
NB. nonstandard startup this script might not work.

18!:4 <'base'
(0 0 $ 1!:2&2) 'Resetting JOD ...'

require 'task'
(require :: _1:) 'jod'

NB. close any open dictionaries
3 (od :: _1:) '' 

NB. work in a trash locale
18!:4 <'base'
18!:4 <'ajodreset9999'

NB. record any current dictionaries 
JODPATH=: jpath '~addons\general\jod\'
REGISTERED=: ,> 1{((5&od) ::((1;'NB. no registrations recorded')"_))''
JODREGDIJS=: 'jodregd.ijs'
REGISTERED (1!:2) <JODPATH,JODREGDIJS

NB. erase installed files
ef=: ((1!:55) :: _1:)
ef < JODPATH,'install.ed'
ef < JODPATH,'jodnws.ijs'
ef < JODPATH,'jodprofile.ijs'
ef < JODPATH,'jod.ijn'
ef < JODPATH,'jmaster.ijf'
ef < JODPATH,'jodexts\jodtools.ijs'

NB. remove JOD entries from scripts.ijs

splitstrs=:4 : 0

NB.*splitstrs v-- splits character lists into sublists that start
NB. with (s) and end with (e).
NB.
NB. dyad:  (cl ; cl) splitstrs cl
NB.
NB.   ('cut';'up') splitstrs 'O.J. cut his wife up'
NB.   ';' splitstrs ';useful;edge;condition'

's e'=. x
(1 (0)} (s E. y) +. (-#e) |. e E. y) <;.1 y
)
   
NB. load script
dat=: (1!:1) <SF=: jpath '~system\extras\config\scripts.ijs'

NB. remove between JOD delimiters
bj=:  'NB.<JOD_system_packages>'
ej=:  'NB.</JOD_system_packages>'
bls=: 'NB.<JODLoadScripts>'
els=: 'NB.</JODLoadScripts>'
dat=: (bj;ej) splitstrs dat
dat=: ; dat #~ -. +./@:(bj&E.)&> dat

NB. to remove JOD generated load scripts uncomment the next two lines
NB. dat=: (bls;els) splitstrs dat
NB. dat=: ; dat #~ -. +./@:(bls&E.)&> dat

NB. trims all leading and trailing white space
allwhitetrim=:] #~ [: -. [: (*./\. +. *./\) ] e. (9 10 13 32{a.)"_

(allwhitetrim dat) (1!:2) <SF
NB. run scripts.ijs to make changes active
((0!:0) :: _1:) <SF
18!:4 <'base'

NB. turn off JOD kills any loaded jod classes
(jodoff :: _1: ) 0

NB. remove (~user\joddicts) and ALL DICTIONARIES!!!!
NB.
NB. It is a VERY BAD IDEA to store any important dictionaries
NB. in the J system directory tree.  Create your important
NB. dictionaries in their own separate locations.  I put all 
NB. mine under (joddictionaries).  For example:
NB.
NB.   newd 'important';'c:\joddictionaries\602\important'
NB.
shell 'rd "',(jpath '~user\joddicts\'),'" /s /q'

(0 0 $ 1!:2&2) 'To complete resetting JOD rerun (installjod.bat)'

NB. clean up
18!:4 <'base'
18!:55 <'ajodreset9999'

NB. if jconsole is running this script quit
".(+./'jconsole' E. ,>0{ARGV)#'(2!:55 '''')'
