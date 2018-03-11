;�ڽű���ǰ����������
Var MSG
Var WPARAM
Var LPARAM

!ifdef NSIS_UNICODE
	!AddPluginDir ..\binU
!else
	!AddPluginDir ..\bin
!endif

!include "MUI2.nsh"
!include "WinCore.nsh"

!define MUI_CUSTOMFUNCTION_GUIINIT onGUIInit
!insertmacro MUI_PAGE_LICENSE "${__FILE__}"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_LANGUAGE "SimpChinese"

Name "WndProc Example"
OutFile "Test.exe"

Section Test
SectionEnd

!define WndProc_Ret "!insertmacro _WndProc_Ret"
!macro _WndProc_Ret _retval
	SetErrorLevel ${_retval}
	Abort
!macroend

Var MainWndSubProc
Function onGUIInit
  System::Call User32::GetWindowLong(i$HWNDPARENT,i-4)i.s
	Pop $MainWndSubProc
	GetFunctionAddress $0 onGUICallback
	WndProc::onCallback $HWNDPARENT $0
FunctionEnd

Function onGUICallback
  ${If} $MSG = ${WM_COMMAND}
		${If} $WPARAM = 3
      MessageBox MB_ICONQUESTION|MB_YESNO "��ȷʵҪ������һ����" IDYES +2
      Abort
    ${EndIf}
	${ElseIf} $MSG = ${WM_SYSCOMMAND}
	  ${If} $WPARAM = ${SC_MINIMIZE}
      MessageBox MB_ICONQUESTION|MB_YESNO "��ȷʵҪ��С��������" IDYES +2
      Abort
	  ${EndIf}
  ; ���¸����ڵ���Ϣ������NSIS�ű���ʵ���ǲ���ȫ�ģ���Ϊռ���˶�ջ�����
	${ElseIf} $MSG = ${WM_SETCURSOR}
		System::Call User32::LoadCursor(i,i32649)i.s
		System::Call User32::SetCursor(is)
	  ${WndProc_Ret} 0
	${ElseIf} $MSG = ${WM_NCHITTEST}
	  System::Call User32::CallWindowProc(i$MainWndSubProc,i$HWNDPARENT,i$MSG,i$WPARAM,i$LPARAM)i.R0
	  ${IfThen} $R0 = ${HTCLIENT} ${|} ${WndProc_Ret} ${HTCAPTION} ${|}
  ${EndIf}
FunctionEnd
