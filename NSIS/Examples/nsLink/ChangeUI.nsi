/*
		�޸�UI�ļ�ʹ��nsLinkʾ��

		��д: gfm688
*/

;!addplugindir ..\..\Plugins
;!addIncludedir ..\..\Include

!include MUI.nsh
!include nsCtrl.nsh

!define MUI_CUSTOMFUNCTION_GUIINIT onGUIInit

;!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_COMPONENTS
;!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
;!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_LANGUAGE "SimpChinese"

Name "NSIS ������ť&����&�˵�"
OutFile "nsLink.exe"
ShowInstDetails show
ChangeUI IDD_INST "UI.exe"

/*
  ��ResHacker�޸�${NSISDIR}\Contrib\UIs\modern.exe
  ��105�Ի���������´���, ��������ΪUI.exe
	CONTROL "����(&A)", 1300, BUTTON, BS_PUSHBUTTON | WS_CHILD | WS_VISIBLE | WS_TABSTOP, 10, 201, 50, 14
	CONTROL "����ɼ�����̳", 1301, "nsLink", 0x5001000B, 65, 204, 59, 9
*/

Section Test
	DetailPrint "$$_CLICK �����ָ�Ϊ: $_CLICK"
SectionEnd

!define IDM_ABOUT	1000
!define IDC_ABOUT	1300
!define IDC_LINK	1301

Function .onInit
	nsLink::Init  	
FunctionEnd

Function onGUIInit
; �޸�UI��ӵĿؼ�, ϵͳ���Զ�����, �������ڵ���.onGUIInit֮ǰ������, ���Ա�����.onInitע��nsLink��

; ��ӹ��ڲ˵���
	System::Call User32::GetSystemMenu(i$HWNDPARENT,i0)i.r2
	System::Call User32::AppendMenu(ir2,i${MF_SEPARATOR},i0,i0)
	System::Call User32::AppendMenu(ir2,i${MF_STRING},i${IDM_ABOUT},t"���ڰ�װ����(&A)")

; �����������õ����ť��˵���ʱ�Ļص�����
	GetFunctionAddress $2 onGUIClick
	System::Call nsLink::OnClick(i$HWNDPARENT,ir2)
FunctionEnd

Function onGUIClick
	${If} $_CLICK = ${IDM_ABOUT}
		MessageBox MB_ICONINFORMATION|MB_OK "���ڲ˵� by gfm688"
	${ElseIf} $_CLICK = ${IDC_ABOUT}
		MessageBox MB_ICONINFORMATION|MB_OK "���ڰ�ť by gfm688"
	${ElseIf} $_CLICK = ${IDC_LINK}
	  ExecShell open www.dreams8.com
	${EndIf}
FunctionEnd
