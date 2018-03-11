!include "MUI2.nsh"
!addplugindir ././

!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_LANGUAGE "Russian"

OutFile "_nsRestart.exe"

Section "ListProcess" ListProcess
  nsRestart::ListProcess "$EXEDIR\process.ini"
  Pop $1
  StrCmp $1 0 0 +2
  MessageBox MB_ICONINFORMATION|MB_OK "$$1 = $1 $\nСписок создан успешно" IDOK
  StrCmp $1 error 0 +2
  MessageBox MB_ICONINFORMATION|MB_OK "$$1 = $1 $\nСписок не создан" IDOK
SectionEnd

Section  /o "FindProcess" FindProcess
  nsRestart::FindProcess "totalcmd.exe"
  Pop "$1"
  StrCmp $1 0 0 +2
  MessageBox MB_ICONINFORMATION|MB_OK "$$1 = $1 $\nПроцесс запущен" IDOK
  StrCmp $1 1 0 +2
  MessageBox MB_ICONINFORMATION|MB_OK "$$1 = $1 $\nПроцесс не запущен" IDOK
SectionEnd
  
Section  /o "PathProcess" PathProcess
  nsRestart::PathProcess "totalcmd.exe"
  Pop "$1"
  MessageBox MB_ICONINFORMATION|MB_OK "$1" IDOK
  StrCmp $1 1 0 +2
  MessageBox MB_ICONINFORMATION|MB_OK "$$1 = $1 $\nПроцесс не запущен" IDOK
SectionEnd

Section  /o "CmdPathProcess" CmdPathProcess
  nsRestart::CmdPathProcess "csrss.exe"
  Pop "$1"
  MessageBox MB_ICONINFORMATION|MB_OK "$1" IDOK
  StrCmp $1 1 0 +2
  MessageBox MB_ICONINFORMATION|MB_OK "$$1 = $1 $\nПроцесс не запущен" IDOK
SectionEnd

Section  /o "RestartProcess" RestartProcess
  nsRestart::RestartProcess "nisedit.exe"
  Pop $1
  StrCmp $1 0 0 +2
  MessageBox MB_ICONINFORMATION|MB_OK "$$1 = $1 $\nПроцесс перезапущен" IDOK
  StrCmp $1 1 0 +2
  MessageBox MB_ICONINFORMATION|MB_OK "$$1 = $1 $\nПроцесс не найден" IDOK
  StrCmp $1 2 0 +2
  MessageBox MB_ICONINFORMATION|MB_OK "$$1 = $1 $\nПроцесс невозможно завершить" IDOK
  StrCmp $1 3 0 +2
  MessageBox MB_ICONINFORMATION|MB_OK "$$1 = $1 $\nПроцесс завершен, но невозможно запустить" IDOK
SectionEnd

Section  /o "KillProcess" KillProcess
  nsRestart::KillProcess "nisedit.exe"
  Pop $1
  StrCmp $1 0 0 +2
  MessageBox MB_ICONINFORMATION|MB_OK "$$1 = $1 $\nПроцесс завершен" IDOK
  StrCmp $1 1 0 +2
  MessageBox MB_ICONINFORMATION|MB_OK "$$1 = $1 $\nПроцесс не завершен" IDOK
SectionEnd

Function .onInit
  StrCpy $0 ${ListProcess}
FunctionEnd

Function .onSelChange
  !insertmacro StartRadioButtons $0
     !insertmacro RadioButton ${ListProcess}
     !insertmacro RadioButton ${FindProcess}
     !insertmacro RadioButton ${PathProcess}
     !insertmacro RadioButton ${CmdPathProcess}
     !insertmacro RadioButton ${RestartProcess}
     !insertmacro RadioButton ${KillProcess}
  !insertmacro EndRadioButtons
FunctionEnd

