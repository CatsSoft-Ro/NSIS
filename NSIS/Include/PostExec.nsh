; ---------------------
;       PostExec.nsh
; ---------------------
;
; Windows NT only
; Macros for running programs after makensis has completed
;
; Created by Jeff Doozan
;
 
!ifndef POSTEXEC_NSH
!define POSTEXEC_NSH
 
!verbose push
!verbose 3
 
!define PostExec1  `!insertmacro _PostExec1`
!define PostExec2  `!insertmacro _PostExec2`
!define PostExec3  `!insertmacro _PostExec3`
!define PostExec4  `!insertmacro _PostExec4`
!define PostExec5  `!insertmacro _PostExec5`
!define PostExec6  `!insertmacro _PostExec6`
!define PostExec7  `!insertmacro _PostExec7`
!define PostExec8  `!insertmacro _PostExec8`
!define PostExec9  `!insertmacro _PostExec9`
 
!macro _PostExec1 pe1
  !tempfile FILE
  !delfile "${FILE}"
  !insertmacro _PostExecWriteBatFile "${FILE}.bat"
 
  # execute the batch file
  !system "${FILE} ${pe1}"
!macroend
 
!macro _PostExec2 pe1 pe2
  !tempfile FILE
  !delfile "${FILE}"
  !insertmacro _PostExecWriteBatFile "${FILE}.bat"
 
  # execute the batch file
  !system "${FILE} ${pe1} ${pe2}"
!macroend
 
!macro _PostExec3 pe1 pe2 pe3
  !tempfile FILE
  !delfile "${FILE}"
  !insertmacro _PostExecWriteBatFile "${FILE}.bat"
 
  # execute the batch file
  !system "${FILE} ${pe1} ${pe2} ${pe3}"
!macroend
 
!macro _PostExec4 pe1 pe2 pe3 pe4
  !tempfile FILE
  !delfile "${FILE}"
  !insertmacro _PostExecWriteBatFile "${FILE}.bat"
 
  # execute the batch file
  !system "${FILE} ${pe1} ${pe2} ${pe3} ${pe4}"
!macroend
 
!macro _PostExec5 pe1 pe2 pe3 pe4 pe5
  !tempfile FILE
  !delfile "${FILE}"
  !insertmacro _PostExecWriteBatFile "${FILE}.bat"
 
  # execute the batch file
  !system "${FILE} ${pe1} ${pe2} ${pe3} ${pe4} ${pe5}"
!macroend
 
!macro _PostExec6 pe1 pe2 pe3 pe4 pe5 pe6
  !tempfile FILE
  !delfile "${FILE}"
  !insertmacro _PostExecWriteBatFile "${FILE}.bat"
 
  # execute the batch file
  !system "${FILE} ${pe1} ${pe2} ${pe3} ${pe4} ${pe5} ${pe6}"
!macroend
 
!macro _PostExec7 pe1 pe2 pe3 pe4 pe5 pe6 pe7
  !tempfile FILE
  !delfile "${FILE}"
  !insertmacro _PostExecWriteBatFile "${FILE}.bat"
 
  # execute the batch file
  !system "${FILE} ${pe1} ${pe2} ${pe3} ${pe4} ${pe5} ${pe6} ${pe7}"
!macroend
 
!macro _PostExec8 pe1 pe2 pe3 pe4 pe5 pe6 pe7 pe8
  !tempfile FILE
  !delfile "${FILE}"
  !insertmacro _PostExecWriteBatFile "${FILE}.bat"
 
  # execute the batch file
  !system "${FILE} ${pe1} ${pe2} ${pe3} ${pe4} ${pe5} ${pe6} ${pe7} ${pe8}"
!macroend
 
!macro _PostExec9 pe1 pe2 pe3 pe4 pe5 pe6 pe7 pe8 pe9
  !tempfile FILE
  !delfile "${FILE}"
  !insertmacro _PostExecWriteBatFile "${FILE}.bat"
 
  # execute the batch file
  !system "${FILE} ${pe1} ${pe2} ${pe3} ${pe4} ${pe5} ${pe6} ${pe7} ${pe8} ${pe9}"
!macroend
 
 
 
!macro _PostExecWriteBatFile FILE
 
  !appendfile "${FILE}" '@ECHO OFF$\n'
  !appendfile "${FILE}" 'SETLOCAL$\n'
  !appendfile "${FILE}" '$\n'
  !appendfile "${FILE}" 'SET Command=%~1$\n'
  !appendfile "${FILE}" 'IF NOT "%1"=="DELAYED_LOAD" ($\n'
  !appendfile "${FILE}" '  :: Run this script again with "DELAYED_LOAD" as the first parameter$\n'
  !appendfile "${FILE}" '  :: this lets use break out of the original shell so that makensis will not wait for$\n'
  !appendfile "${FILE}" '  :: this script to finish$\n'
  !appendfile "${FILE}" '  start "" /D "%~dp0" "%COMSPEC%" /c "%~dpf0" DELAYED_LOAD %1 %2 %3 %4 %5 %6 %7 %8 %9$\n'
  !appendfile "${FILE}" '  EXIT /B$\n'
  !appendfile "${FILE}" ') $\n'
  !appendfile "${FILE}" '$\n'
  !appendfile "${FILE}" 'SHIFT$\n'
  !appendfile "${FILE}" 'SET PROCESS=makensis.exe$\n'
  !appendfile "${FILE}" 'echo Waiting for %PROCESS% to exit$\n'
  !appendfile "${FILE}" 'echo %1 %2 %3 %4 %5 %6 %7 %8 %9$\n'
  !appendfile "${FILE}" '$\n'
  !appendfile "${FILE}" ':: Get the PID of makensis.exe$\n'
  !appendfile "${FILE}" 'FOR /F "tokens=2 skip=3" %%i IN ($\n'
  !appendfile "${FILE}" '  $\'tasklist.exe /FI "USERNAME eq %USERDOMAIN%\%USERNAME%" /FI "IMAGENAME eq %Process%"$\'$\n'
  !appendfile "${FILE}" ') DO ($\n'
  !appendfile "${FILE}" '  CALL :TASKWAIT %PROCESS% %%~i$\n'
  !appendfile "${FILE}" ')$\n'
  !appendfile "${FILE}" '$\n'
  !appendfile "${FILE}" '%1 %2 %3 %4 %5 %6 %7 %8 %9$\n'
  !appendfile "${FILE}" 'ENDLOCAL$\n'
  !appendfile "${FILE}" 'DEL %0.bat$\n'
  !appendfile "${FILE}" 'EXIT$\n'
  !appendfile "${FILE}" '$\n'
  !appendfile "${FILE}" '$\n'
  !appendfile "${FILE}" ':TASKWAIT$\n'
  !appendfile "${FILE}" '  ping.exe -n 2 -w 1000 127.0.0.1 >NUL$\n'
  !appendfile "${FILE}" '  tasklist.exe /FI "USERNAME eq %USERDOMAIN%\%USERNAME%" /FI "IMAGENAME eq %1" /FI "PID eq %2" 2>NUL | find.exe "%1" >NUL && GOTO %0$\n'
  !appendfile "${FILE}" '  EXIT /B$\n'
 
!macroend
 
!verbose pop
!endif