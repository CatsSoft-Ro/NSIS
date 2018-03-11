!include MUI2.nsh
!include "botva3.nsh"
Page custom custom.Create
!insertmacro MUI_LANGUAGE "Russian"

Name "Button"
OutFile "Button.exe"

Var BUTTON

Function custom.Create
	InitPluginsDir
	File /oname=$PLUGINSDIR\button.png button.png
	    
	nsDialogs::Create 1018
	Pop $0
	
	${BtnCreate} $0 "$PLUGINSDIR\button.png" 10 10 99 55 0 0
	Pop $BUTTON
	
	${BtnSetText} $BUTTON "123"
	
	GetFunctionAddress $0 OnClick
	${BtnSetEvent} $BUTTON 1 $0
	
    nsDialogs::Show
FunctionEnd

Function OnClick
	Pop $0 # HWND
	MessageBox MB_OK clicky
FunctionEnd

Function un.onGUIEnd
	${gdipShutdown}
FunctionEnd

Section
SectionEnd