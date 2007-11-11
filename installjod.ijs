NB.*installjod s-- JOD setup script for J 6.0x
NB.
NB. NOTE: This setup  script  will only work for J 6.0x and later
NB. systems. This script will not work for J  versions prior to J
NB. 6.01.
NB.
NB. The JOD  (J-Object-Database)  system is a pure J system  that
NB. supports linked J code and data databases. JOD can be used in
NB. many ways.  As a  fine grained word  oriented version control
NB. system, as a code and data repositry,  as a  project manager.
NB. JOD  is  currrently  a  Windows  only system.  See  installed
NB. documentation
NB.
NB. ~addons\general\jod\joddoc\pdfdoc\jod.pdf
NB.
NB. for  detailed   information  about  JOD.  (Note  "~"  denotes
NB. relative paths)
NB.
NB. JOD  is installed  in an a J addons directory. A  typical JOD
NB. location is:
NB.
NB. c:\jsoftware\j602\addons\general\jod
NB.
NB. This  script performs the tasks required to insure JOD can be
NB. run from
NB.
NB. ~addons\general\jod
NB.
NB. John D. Baker bakerjd99@gmail.com

NB. WARNING: this install script ASSUMES the standard J
NB. startup profile has been loaded.  If you are running a
NB. nonstandard startup this script might not work.

(0 0 $ 1!:2&2) 'Installing JOD ...'

NB. work in a trash locale
18!:4<'base'
18!:4<'ajodinstall9999'

NB. JOD addon install directory - \ terminated
JODRELATIVE=: '~addons\general\jod\'
JODPATH=: jpath JODRELATIVE

NB. direct load of jod
((0!:0) :: _1:) <JODPATH,'jodbak\jodbak.ijs'

NB. JOD load resets locale to base
18!:4<'ajodinstall9999'

NB. temporary string test verb
ifnostrwrite=:4 : 0
'str original'=. x
'changed file'=. y
if. +./str E. original do.
  NB. string present do nothing
  0
else.
  try.
    NB. string missing write changed
    changed 1!:2 <file
    NB. run scripts.ijs to make changes active
    0!:0 <jpath '~system\extras\config\scripts.ijs'
  catch.
    smoutput 'JOD setup errors'
  end.
  1
end.
)

NB. append JOD entries to scripts.ijs
dat=: 1!:1 <jpath '~system\extras\config\scripts.ijs'
jl=:'  ',CRLF,'  ',CRLF
jl=:jl,'NB.<JOD_system_packages>',CRLF
jl=:jl,'buildpublic 0 : 0',CRLF
jl=:jl,'jod       ',JODRELATIVE,'jodnws',CRLF
jl=:jl,'jodtools  ',JODRELATIVE,'jodexts\jodtools',CRLF
jl=:jl,')',CRLF
jl=:jl,'NB.</JOD_system_packages>',CRLF

NB. modify scripts.ijs only if jod items are missing
((JODPATH,'jodnws');dat) ifnostrwrite (dat,jl);jpath '~system\extras\config\scripts.ijs'

NB. after installation use the JOD script
dat=. 1!:1 <JODPATH,'installjod.ijs'
dat   1!:2 <JODPATH,'install.ed'
dat=. 1!:1 <JODPATH,'jodbak\jodbak.ijs'
dat   1!:2 <JODPATH,'jodnws.ijs'
dat=. 1!:1 <JODPATH,'jodbak\jodprofilebak.ijs'
dat   1!:2 <JODPATH,'jodprofile.ijs'
dat=. 1!:1 <JODPATH,'jodexts\jodtoolsbak.ijs'
dat   1!:2 <JODPATH,'jodexts\jodtools.ijs'

NB. clean up
18!:4<'base'
18!:55<'ajodinstall9999'

NB. turn off jod
(jodoff :: _1:) 0

(0 0 $ 1!:2&2) 'JOD is installed'

NB. if (jconsole.exe) is running this script quit
".(+./'jconsole' E. ,>0{ARGV)#'(2!:55 '''')'

(0 0 $ 1!:2&2) 'to run JOD type:',LF,LF,'  load ''jod'''