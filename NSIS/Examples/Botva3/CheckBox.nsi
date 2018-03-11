!include MUI2.nsh
!include "botva3.nsh"
Page custom custom.Create
!insertmacro MUI_LANGUAGE "Russian"

Name "CheckBox"
OutFile "CheckBox.exe"

Var BUTTON
Var CHECKBOX

Function custom.Create
	InitPluginsDir
	File /oname=$PLUGINSDIR\CheckBox.png CheckBox.png
	File /oname=$PLUGINSDIR\button.png button.png
	    
	nsDialogs::Create 1018
	Pop $0
	
	${CheckBoxCreate} $0  "$PLUGINSDIR\CheckBox.png" 10 10 160 20 0 0
	Pop $CHECKBOX
	${CheckBoxSetText} $CHECKBOX "12345"
	;----------------------------------------------------------------------	
	${BtnCreate} $0 "$PLUGINSDIR\button.png" 10 100 99 55 0 0
	Pop $BUTTON
	
	${BtnSetText} $BUTTON "123"
	
	GetFunctionAddress $0 OnClick
	${BtnSetEvent} $BUTTON 1 $0
	
    nsDialogs::Show
FunctionEnd

Function OnClick
	${CheckBoxGetChecked} $CHECKBOX
	Pop $R0
	
	${If} $R0 == 0
		MessageBox MB_OK "CheckBox not checked"
	${Else}
		MessageBox MB_OK "CheckBox checked"
	${EndIf}
FunctionEnd

Function un.onGUIEnd
	${gdipShutdown}
FunctionEnd

Section
SectionEnd