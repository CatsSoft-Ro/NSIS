!include "nsDialogs.nsh"

!AddPluginDir .
OutFile sample.exe

Page custom page1
Page custom page2
Page custom page3

Var hLabel
Function OnProgressCallback
    Pop $R0
    
    ${NSD_SetText} $hLabel "安装进度：$R0"
FunctionEnd

Function page1
    nsDialogs::Create 1018
    nsDialogs::Show
FunctionEnd

Function page2
    nsDialogs::Create 1018
    ${NSD_CreateLabel} 10 10 200 20 ""
    Pop $hLabel

    GetFunctionAddress $0 OnProgressCallback
    section::call $0
    nsDialogs::Show
FunctionEnd

Function page3
    nsDialogs::Create 1018
    nsDialogs::Show
FunctionEnd

Section
    MessageBox MB_OK "section call..."
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
    
    MessageBox MB_OK "section call end..."
SectionEnd