!include nsDialogs.nsh
!include LogicLib.nsh

Name "OnTop nsDialogs Example"
OutFile "nsDialogs Example.exe"

LoadLanguageFile "${NSISDIR}\Contrib\Language files\SimpChinese.nlf"
LangString Name 2052 "Simplified Chinese"

XPStyle on

Page custom nsDialogsPage

Var BUTTON
Var CHECKBOX

Function nsDialogsPage

	nsDialogs::Create /NOUNLOAD 1018
	Pop $0

	${NSD_CreateButton} 0 10 100% 15u 'ȡ�������ö�'
	Pop $BUTTON
	GetFunctionAddress $0 OnClick
	nsDialogs::OnClick /NOUNLOAD $BUTTON $0

	${NSD_CreateCheckbox} 0 -50 100% 10u '�����ö�'
	Pop $CHECKBOX
	GetFunctionAddress $0 OnCheckbox
	nsDialogs::OnClick /NOUNLOAD $CHECKBOX $0

	${NSD_CreateLabel} 0 40u 75% 40u "* Demo����Ĭ�ϴ����ö�$\n$\n* ����Checkboxѡȡ״̬���д����ö��л�"
	Pop $0

	nsDialogs::Show

FunctionEnd

Function OnClick

  ;ȡ�������ö�
   OnTop::OffTop
  ;ȡ��checkbox��ѡ��״̬
   ${NSD_SetState} $CHECKBOX ${BST_UNCHECKED}
   
FunctionEnd




Function OnCheckbox

  ${NSD_GetState} $CHECKBOX $0
  ${If} $0 == ${BST_CHECKED}
   	OnTop::OnTop
  ${Else}
    OnTop::OffTop
  ${EndIf}

FunctionEnd

Function .onGUIInit

  ;�����ö�
  OnTop::OnTop
  
FunctionEnd

Section '-��ʽ��Ҫ'
SectionEnd
