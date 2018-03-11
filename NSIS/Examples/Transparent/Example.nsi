XPStyle on
!include "MUI.nsh"

!define MUI_CUSTOMFUNCTION_GUIINIT myGuiInit

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_LANGUAGE "Russian"
 
!addplugindir "."

Name "transparent plugin example"
OutFile "transparent.exe" 
ShowInstDetails show

Function myGuiInit
transparent::SetTransparentWindowStyle "200"
FunctionEnd


Section -transparentTEST
StrCpy $0 255
fadeout:
Sleep 25
transparent::SetTransparentWindowStyle "$0"
DetailPrint "Уровень прозрачности: $0"
IntOp $0 $0 - 1
StrCmp $0 "0" 0 fadeout

fadein:
Sleep 25
transparent::SetTransparentWindowStyle "$0"
DetailPrint "Уровень прозрачности: $0"
IntOp $0 $0 + 1
StrCmp $0 "255" 0 fadein
SectionEnd












Section
transparent::SetTransparentWindowStyle "200"
SectionEnd 