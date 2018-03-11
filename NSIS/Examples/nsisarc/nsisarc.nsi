XPStyle on

Name "unarc"
OutFile "unarc.exe"
ShowInstDetails nevershow

SetCompress off

Function .onInit
  InitPluginsDir
  File /oname=$PLUGINSDIR\unarc.dll "unarc.dll"
FunctionEnd

Section -default
  nsisarc::ArcExtract "$EXEDIR\16_nsisarc.arc" "$EXEDIR\ARC" "" "" ""
SectionEnd