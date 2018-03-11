Name "System Restore Example"
OutFile "Example.exe"
InstallDir "$PROGRAMFILES\$(^Name)\"

Page Directory
Page InstFiles
UninstPage UninstConfirm
UninstPage InstFiles

Section "install"
  SetOverWrite try
  ClearErrors

  DetailPrint "Setting System Restore point..."
  SysRestore::StartRestorePoint "Installed $(^Name)"
  Pop $0
  StrCmp $0 0 next
  MessageBox MB_OK "$0"
  SetErrors
next:
  SetOutPath "$INSTDIR"
  File "${NSISDIR}\docs\makensisw\license.txt"
  WriteUninstaller "$INSTDIR\uninst.exe"
  
  ExecShell open "$INSTDIR"
  
  IfErrors 0 +2
  SysRestore::FinishRestorePoint
  SetAutoClose True
SectionEnd

Section "un.install"
  SetOverWrite try
  ClearErrors
  DetailPrint "Setting System Restore point..."
  SysRestore::StartUnRestorePoint "Uninstalled $(^Name)"
  Pop $0
  StrCmp $0 0 next
  MessageBox MB_OK "$0"
  SetErrors
next:
  Delete "$INSTDIR\license.txt"
  Delete "$INSTDIR\uninst.exe"
  RMDir "$INSTDIR"
  
  IfErrors 0 +2
  SysRestore::FinishRestorePoint
  SetAutoClose False
SectionEnd