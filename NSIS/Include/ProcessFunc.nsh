;Автор: kotkovets aka Котковец Вячеслав
;http://forum.oszone.net/member.php?userid=133945

!ifndef PROCESSFUNC_INCLUDED
!define PROCESSFUNC_INCLUDED

!include Util.nsh
!include LogicLib.nsh

!verbose push
!verbose 3
!ifndef _PROCESSFUNC_VERBOSE
    !define _PROCESSFUNC_VERBOSE 3
!endif
!verbose ${_PROCESSFUNC_VERBOSE}
!define PROCESSFUNC_VERBOSE `!insertmacro PROCESSFUNC_VERBOSE`
!verbose pop

!macro PROCESSFUNC_VERBOSE _VERBOSE
	!verbose push
	!verbose 3
	!undef _PROCESSFUNC_VERBOSE
	!define _PROCESSFUNC_VERBOSE ${_VERBOSE}
	!verbose pop
!macroend

!define SYNCHRON                  0x00100000
!define DETACHED_PROCESS          0x00000008
!define PROCESS_TERMINATE         0x0001
!define PROCESS_QUERY_INFORMATION 0x0400
!define PROCESS_VM_READ           0x0010
!define INFINITE                  -1

!define SE_DEBUG_NAME           "SeDebugPrivilege"

!define TOKEN_QUERY             0x0008
!define TOKEN_ADJUST_PRIVILEGES 0x0020
!define SE_PRIVILEGE_ENABLED    0x00000002

!define FindProcessName   "!insertmacro _FindProcessNameCall"
!define FindProcessPath   "!insertmacro _FindProcessPathCall"
!define KillProcess       "!insertmacro _KillProcessCall"
!define EnumProcess       "!insertmacro _EnumProcessCall"
!define FindProcessPID    "!insertmacro _FindProcessPIDCall"
!define ProcessWait       "!insertmacro _ProcessWaitCall"
!define ExecWait          "!insertmacro _ExecWaitCall"
!define ProcessExists     `"" ProcessExists`

!ifdef NSIS_UNICODE
    !define WSTR  w
    !define Process32First          "kernel32::Process32FirstW"
    !define GetProcessImageFileName "psapi::GetProcessImageFileNameW"
    !define Process32Next           "kernel32::Process32NextW"
    !define CreateProcess           "kernel32::CreateProcessW"
    !define GetModuleFileNameEx     "psapi::GetModuleFileNameExW"
!else
    !define WSTR  t
    !define Process32First          "kernel32::Process32First"
    !define GetProcessImageFileName "psapi::GetProcessImageFileNameA"
    !define Process32Next           "kernel32::Process32Next"
    !define CreateProcess           "kernel32::CreateProcessA"
    !define GetModuleFileNameEx     "psapi::GetModuleFileNameExA"
!endif

!macro _FindProcessNameCall PROCESS OUTVAR
	!verbose push
	!verbose ${_PROCFUNC_VERBOSE}
	Push 0
	Push "${PROCESS}"
	${CallArtificialFunction} _GetProcess
	Pop ${OUTVAR}
	!verbose pop
!macroend

!macro _FindProcessPathCall PROCESS OUTVAR
	!verbose push
	!verbose ${_PROCFUNC_VERBOSE}
        ${CallArtificialFunction} _SetPrivilegeDebugMode
	Push 1
	Push "${PROCESS}"
	${CallArtificialFunction} _GetProcess
	Pop ${OUTVAR}
	!verbose pop
!macroend

!macro _KillProcessCall PROCESS OUTVAR
	!verbose push
	!verbose ${_PROCFUNC_VERBOSE}
        ${CallArtificialFunction} _SetPrivilegeDebugMode
	Push 2
	Push "${PROCESS}"
	${CallArtificialFunction} _GetProcess
	Pop ${OUTVAR}
	!verbose pop
!macroend

!macro _EnumProcessCall USER_FUNC
	!verbose push
	!verbose ${_PROCFUNC_VERBOSE}
        ${CallArtificialFunction} _SetPrivilegeDebugMode
	System::Store S
	GetFunctionAddress $9 "${USER_FUNC}"
	${CallArtificialFunction} _EnumProcess
	System::Store L
	!verbose pop
!macroend

!macro _FindProcessPIDCall PROCESS OUTVAR
	!verbose push
	!verbose ${_PROCFUNC_VERBOSE}
        ${CallArtificialFunction} _SetPrivilegeDebugMode
	Push 3
	Push "${PROCESS}"
	${CallArtificialFunction} _GetProcess
	Pop ${OUTVAR}
	!verbose pop
!macroend

!macro _ProcessWaitCall PROCESS TIMEOUT OUTVAR
	!verbose push
	!verbose ${_PROCFUNC_VERBOSE}
	${CallArtificialFunction} _SetPrivilegeDebugMode
	Push "${TIMEOUT}"
	System::Store S
	${FindProcessPID} ${PROCESS} $0
	Push $0
	System::Store L
	${CallArtificialFunction} _ProcessWait
	Pop ${OUTVAR}
	!verbose pop
!macroend

!macro _ExecWaitCall CmdLine ExitCode
	!verbose push
	!verbose ${_PROCFUNC_VERBOSE}
	Push "${CmdLine}"
	${CallArtificialFunction} _CallExecWait
	Pop ${ExitCode}
	!verbose pop
!macroend

!macro _ProcessExists _a _b _t _f
	!insertmacro _LOGICLIB_TEMP
	!verbose push
	!verbose ${_PROCFUNC_VERBOSE}
	System::Store S
	StrCpy `$0` `${_b}`
	${CallArtificialFunction} _CallProcessExists
	IntCmp $_LOGICLIB_TEMP 0 `${_f}`
	Goto `${_t}`
	System::Store L
	!verbose pop
!macroend

;getting user process
!macro _GetAccountProcess hProcess
  System::Store S
  System::Call "advapi32::OpenProcessToken(i${hProcess}, i${TOKEN_QUERY}, *i.R1)i.R9"
  ${Unless} $R9 = 0
      System::Call "advapi32::GetTokenInformation(iR1, i1, *i.R2, i0, *i.R3)"
      System::Alloc $R3
      Pop $R2
      System::Call "advapi32::GetTokenInformation(iR1, i1, iR2, iR3, *i.R3)"
      System::Call "*$R2(i.R5)"
      System::Call "advapi32::LookupAccountSid(i0,iR5, t.s,*i${NSIS_MAX_STRLEN},tn,*i${NSIS_MAX_STRLEN},*i.R9)"
      System::Call "kernel32::CloseHandle(iR1)"
      System::Call "kernel32::CloseHandle(iR3)"
      System::Free $R2
  ${Else}
      Push "<unknown>"
  ${EndUnless}
  System::Store L
!macroend

;privilege to open processes
!macro _SetPrivilegeDebugMode
  System::Store S
  StrCpy $R1 0
  System::Call "kernel32::GetCurrentProcess(v)i.R0"
  System::Call "advapi32::OpenProcessToken(iR0, i${TOKEN_QUERY}|${TOKEN_ADJUST_PRIVILEGES}, *i.R1)i.R0"
  ${Unless} $R0 = 0
     System::Call 'advapi32::LookupPrivilegeValue(i0, t"${SE_DEBUG_NAME}", *l.R2) i .R0'
     ${Unless} $R0 = 0
        System::Call "*(i1, lR2, i${SE_PRIVILEGE_ENABLED})i.R0"
        System::Call "advapi32::AdjustTokenPrivileges(iR1, i0, iR0, i0, i0, i0)"
        System::Free $R0
     ${EndUnless}
     System::Call "kernel32::CloseHandle(iR1)"
  ${EndUnless}
  System::Store L
!macroend

;Convert DeviceDrive to LogicalDrive
!macro _ReplaceDeviceNameToLogicalDrive DEVICEPATH
    System::Store S
    System::Call "kernel32::GetCurrentProcess()i.r0"
    System::Call "kernel32::IsWow64Process(ir0,*i.r0)"
    IntCmp $0 1 0 +2 +2
    System::Call "kernel32::Wow64EnableWow64FsRedirection(i0)"
    System::Alloc 1024
    Pop $R7
    System::Call "kernel32::GetLogicalDriveStrings(i1024,iR7)"
    ${Do}
       System::Call "*$R7(&t2.R9)"
       System::Call "kernel32::QueryDosDevice(tR9, t.R5, i${NSIS_MAX_STRLEN})"
       StrLen $R4 `$R5`
       StrCpy `$R6` `${DEVICEPATH}` `$R4`
       ${If} "$R6" == "$R5"
           StrCpy `$R6` `${DEVICEPATH}` `` `$R4`
           Push `$R9$R6`
       ${EndIf}
       !ifdef NSIS_UNICODE
           IntOp $R7 $R7 + 8
       !else
          IntOp $R7 $R7 + 4
       !endif
       System::Call "kernel32::lstrlen(iR7)i.R8"
    ${LoopUntil} $R8 = 0
    ${IfThen} ${DEVICEPATH} == `` ${|}Push none${|}
    System::Free $R7
    System::Store L
!macroend

!macro _GetProcess
    System::Store S
    Pop $R1
    Pop $R0
    Push none
    System::Call "kernel32::CreateToolhelp32Snapshot(i2,i0)i.r0" ;snapshot of the processes
    ${Unless} $0 = -1
       System::Call "*(&l4,i,i,i,i,i,i,i,i,&${WSTR}260)i.r1" ;the structure of processes
       System::Call "${Process32First}(ir0, ir1)i.r2" ;the primary process
       ${DoUntil} $2 = 0
          ${Select} $R0
             ${Case} 0 ;search for a running process
                 System::Call "*$1(i,i,i,i,i,i,i,i,i,&${WSTR}260.r3)"
                 ${If} "$R1" == "$3"
                     Pop $3
                     Push 1
                     ${Break}
                 ${EndIf}
             ${Case3} 1 2 3
                 System::Call "*$1(i,i,i.r4,i,i,i,i,i,i,&${WSTR}260.r3)"
                 ${If} $R0 = 1 ;finding a running process
                    ${If} "$R1" == "$3"
                       Pop $3
		       System::Call 'kernel32::OpenProcess(i${PROCESS_QUERY_INFORMATION}|${PROCESS_VM_READ}, i0, ir4)i.r5'
		       System::Call "${GetProcessImageFileName}(ir5, ${WSTR}.r6, i260)i.r2"
		       ${If} $2 == error
                           System::Call "${GetModuleFileNameEx}(ir5, i0, ${WSTR}.r6, i260)"
                           StrCpy `$2` `$6` 4
                           ${If} `$2` == `\??\`
                               Strlen $2 `$6`
                               IntOp $2 $2 - 4
                               StrCpy `$6` `$6` `` -$2
                           ${EndIf}
                           StrCpy `$2` `$6` 11
                           ${If} `$2` == `\SystemRoot`
                               Strlen $2 `$6`
                               IntOp $2 $2 - 11
                               StrCpy `$6` `$6` `` -$2
                               StrCpy `$6` `$WINDIR$6`
                           ${EndIf}
                           Push `$6`
		       ${Else}
                           !insertmacro _ReplaceDeviceNameToLogicalDrive "$6"
                       ${EndIf}
		       System::Call "kernel32::CloseHandle(ir5)"
                       ${Break}
                    ${EndIf}
                 ${ElseIf} $R0 = 2 ;finally found a running process
                    ${If} "$R1" == "$3"
                       System::Call "kernel32::OpenProcess(i${PROCESS_TERMINATE}, i0, ir4)i.r5"
                       System::Call "kernel32::TerminateProcess(ir5, i1)i.r6"
                       ${If} $6 = 1
                          Pop $3
                          Push 1
                        ${Else}
                          Pop $3
                          Push 2
                       ${EndIf}
                       System::Call "kernel32::CloseHandle(i.r5)"
                       ${Break}
                    ${EndIf}
                 ${ElseIf} $R0 = 3 ;search PID for a running process
                    ${If} "$R1" == "$3"
                       Pop $3
                       Push $4
                       ${Break}
                    ${EndIf}
                 ${EndIf}
             ${CaseElse}
          ${EndSelect}
          System::Call "${Process32Next}(ir0, ir1)i.r2" ;the following process
       ${Loop}
       System::Free $1
    ${Else}
       Pop $3
       Push error
    ${EndUnless}
    System::Call "Kernel32::CloseToolhelp32Snapshot(ir0)"
    System::Store L
!macroend

!macro _EnumProcess
    System::Call "kernel32::CreateToolhelp32Snapshot(i2,i0)i.r0"
    ${Unless} $0 = -1
       System::Call "*(&l4,i,i,i,i,i,i,i,i,&${WSTR}260)i.r1"
       System::Call "${Process32First}(ir0, ir1)i.r2"
       ClearErrors
       ${DoUntil} $2 = 0
          System::Call "*$1(i,i,i.r3,i,i,i,i,i.r4,i,&${WSTR}260.r5)"
	  System::Call 'kernel32::OpenProcess(i${PROCESS_QUERY_INFORMATION}|${PROCESS_VM_READ}, i0, ir3)i.r8'
	  System::Call "${GetProcessImageFileName}(ir8, ${WSTR}.r6, i260)i.r2"
	  ${If} $2 == error
              System::Call "${GetModuleFileNameEx}(ir8, i0, ${WSTR}.r6, i260)"
              StrCpy `$2` `$6` 4
              ${If} `$2` == `\??\`
                  Strlen $2 `$6`
                  IntOp $2 $2 - 4
                  StrCpy `$6` `$6` `` -$2
              ${EndIf}
              StrCpy `$2` `$6` 11
              ${If} `$2` == `\SystemRoot`
                 Strlen $2 `$6`
                 IntOp $2 $2 - 11
                 StrCpy `$6` `$6` `` -$2
                 StrCpy `$6` `$WINDIR$6`
              ${EndIf}
	  ${Else}
              !insertmacro _ReplaceDeviceNameToLogicalDrive `$6`
              Pop `$6`
          ${EndIf}
          !insertmacro _GetAccountProcess `$8`
	  Pop `$7`
	  System::Call "kernel32::CloseHandle(ir8)"
	  ${If} $4 >= 0
	  ${AndIf} $4 < 6
             StrCpy $4 "Idle"
          ${ElseIf} $4 >= 6
          ${AndIf} $4 < 8
             StrCpy $4 "Below Normal"
          ${ElseIf} $4 >= 8
          ${AndIf} $4 < 10
             StrCpy $4 "Normal"
          ${ElseIf} $4 >= 10
          ${AndIf} $4 < 13
             StrCpy $4 "Above Normal"
          ${ElseIf} $4 >= 13
          ${AndIf} $4 < 24
             StrCpy $4 "High"
          ${ElseIf} $4 >= 24
          ${AndIf} $4 <= 31
             StrCpy $4 "Real Time"
          ${EndIf}
          Call $9
          System::Call "${Process32Next}(ir0, ir1)i.r2"
       ${Loop}
       System::Free $1
       System::Call "Kernel32::CloseToolhelp32Snapshot(ir0)"
    ${Else}
       SetErrors
    ${EndUnless}
!macroend

!macro _CallExecWait
    System::Store S
    Push error
    System::Alloc 72
    Pop $2
    System::Call "*$2(i72)"
    System::Call "*(i,i,i,i)i.r3"
    Exch
    System::Call '${CreateProcess}(i0, ${WSTR}s, i0, i0, i0, i${DETACHED_PROCESS}, i0, i0, ir2, ir3)i.r4'
    ${Unless} $4 = 0
        Pop $6
        System::Call "*$3(i.r4)"
        System::Call "kernel32::WaitForSingleObject(ir4, i${INFINITE})"
        System::Call "kernel32::GetExitCodeProcess(ir4, *i.s)"
        System::Call "kernel32::CloseHandle(ir4)"
    ${EndUnless}
    System::Free $2
    System::Free $3
    System::Store L
!macroend

!macro _ProcessWait
    System::Store S
    Pop $0
    Pop $1
    ${Select} $0
        ${Case2} none error
            Push $0
        ${CaseElse}
	    System::Call "kernel32::OpenProcess(i${SYNCHRON}, i0, ir0)i.r2"
	    ${Unless} $2 = 0
	        System::Call "kernel32::WaitForSingleObject(ir2, ir1)i.r1"
		System::Call "kernel32::CloseHandle(ir2)"
		Push 1
	    ${Else}
		Push $0
	    ${EndUnless}
    ${EndSelect}
    System::Store L
!macroend

!macro _CallProcessExists
	StrCpy $_LOGICLIB_TEMP 0
	System::Call "*(&l4,i,i,i,i,i,i,i,i,&${WSTR}260)i.r2"
	System::Call "kernel32::CreateToolhelp32Snapshot(i2,i0)i.r3"
	IntCmp $3 -1 PROCESSFUNC_End 0 0
	System::Call "${Process32First}(ir3, ir2)i.r4"
	PROCESSFUNC_Loop:
	     IntCmp $4 0 PROCESSFUNC_EndLoop
	     System::Call "*$2(i,i,i,i,i,i,i,i,i,&${WSTR}260.r5)"
	     StrCmp `$5` `$0` 0 PROCESSFUNC_NextProcess
	     StrCpy $_LOGICLIB_TEMP 1
	     Goto PROCESSFUNC_EndLoop
	     PROCESSFUNC_NextProcess:
	     System::Call "${Process32Next}(ir3,ir2)i.r4"
	     Goto PROCESSFUNC_Loop
	PROCESSFUNC_EndLoop:
	System::Call "kernel32::CloseHandle(ir3)"
	PROCESSFUNC_End:
	System::Free $2
!macroend

!endif