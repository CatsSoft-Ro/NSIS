  !include "MUI2.nsh"
  ;!AddPlugindir .
  
  Name "Examples"
  OutFile "Examples.exe"
  RequestExecutionLevel admin
  ShowInstDetails nevershow
  
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_LANGUAGE "SimpChinese"
  
Section "Examples"
  DetailPrint "正在安装，请稍后..."
  SetDetailsPrint none
  XZBHelper::XZB_SlideShow /NOUNLOAD /auto=$PLUGINSDIR\Slides.dat
  Sleep 100
  Sleep 100
  Sleep 100
  Sleep 100
  Sleep 100
  Sleep 100
  Sleep 100
  Sleep 100
  Sleep 100
  Sleep 100
  Sleep 100
  Sleep 100
  Sleep 100
  Sleep 100
  Sleep 100
  Sleep 1000
  Sleep 100
  Sleep 100
  Sleep 100
  Sleep 100
  Sleep 100
  Sleep 100
  Sleep 100
  Sleep 100
  Sleep 100
  Sleep 100
  Sleep 100
  Sleep 100
  Sleep 100
  Sleep 100
  Sleep 100
SectionEnd

Function .oninit
  InitPluginsDir
  File /oname=$PLUGINSDIR\Slides.dat "Resource\Slides.dat"
  File /oname=$PLUGINSDIR\install0.bmp "Resource\install0.bmp"
  File /oname=$PLUGINSDIR\install1.bmp "Resource\install1.bmp"
FunctionEnd

Function .onGUIEnd
    XZBHelper::XZB_SlideStop
FunctionEnd
