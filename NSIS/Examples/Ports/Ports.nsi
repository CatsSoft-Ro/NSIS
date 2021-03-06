!include MUI2.nsh
!include WordFunc.nsh
!include "Locate.nsh"
!include "Sections.nsh"
!include "Ports.nsh"

!insertmacro WordFind

Name "Ports"
OutFile "Ports.exe"
InstallDir C:\temp

;ChangeUI all nsisui.exe

XPStyle on
Var PortNumber

!insertmacro MUI_PAGE_INSTFILES 
!insertmacro MUI_LANGUAGE "Romanian" 

Section "!Install" inst1

SectionIn RO
SetOutPath "$INSTDIR"

${Unless} ${TCPPortOpen} 80
  MessageBox MB_OK "httpd running"
${EndUnless}

${If} ${UDPPortOpen} 1337
  MessageBox MB_OK "leet port open :)"
${EndIf}

strcpy $PortNumber 80

${If} ${TCPPortOpen} $PortNumber
  MessageBox MB_OK|MB_ICONSTOP "$PortNumber is already using by another program..."
Abort
${Else}
MessageBox MB_OK"$PortNumber is open to use"

WriteUninstaller "$INSTDIR\uninst.exe"
SectionEnd
