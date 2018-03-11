/*
		NSIS ������ť&����&�˵�ʾ��

		��д: gfm688
*/

!addplugindir ..\..\Plugins
!addIncludedir ..\..\Include

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

Section Test
	DetailPrint "$$_CLICK �����ָ�Ϊ: $_CLICK"
SectionEnd

!define IDM_ABOUT	1000
!define IDC_ABOUT	1300
!define IDC_LINK	1301

Function onGUIInit
	nsLink::Init  					;��ʼ�������ע��"nsLink"������
	StrCpy $0 $HWNDPARENT		;����Ҫ�����ϴ����ؼ��ĶԻ�����Ϊ$HWNDPARENT
	${CreateButton} 10u 201u 50u 14u "����(&A)" ${IDC_ABOUT}
	${CreateLink} 65u 204u 50u 9u "����ɼ�����̳" ${IDC_LINK}
; ��ѡ�Ƿ���ƽ���, ����ؼ�û��WS_TABSTOP��ʽ�򲻻��ƽ���
	;${CreateControl} "nsLink" ${DEFAULT_STYLES} 0 65u 204u 50u 9u  ${IDC_LINK}
; ÿ�δ����ؼ���, �ؼ������������$1

; LM_SETHOVERPARAM Ϊ�Զ�����Ϣ, ����������꾭��ʱ����ɫ���Ƿ����»��߱仯Ч��
; wParamΪCOLORREF��ɫֵ; lParamΪ1�����»��߱仯Ч��, Ϊ0��û��
	SendMessage $1 ${LM_SETHOVERPARAM} 0xFF8000 1

; ֧����SetCtlColors�ı���ɫ, ��Ҫ���ƽ�����»��߱仯Ч��, ���ܽ�������Ϊ͸��
;	SetCtlColors $1 /BRANDING 0x000080
;	Call FixBkColor

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
	  ;GetDlgItem $1 $HWNDPARENT ${IDC_LINK}
	  SendMessage $1 ${WM_SETTEXT} 0 "STR:���ѷ����������̳"
	  ;SendMessage $1 ${LM_SETHOVERPARAM} 0x800080 0
	  SetCtlColors $1 /BRANDING 0x800080
	  Call FixBkColor
	${EndIf}
FunctionEnd

Function FixBkColor
; SetCtlColors��/BRANDING����, �ؼ���������͸����, ����SetWindowLong������
	System::Call User32::GetWindowLong(ir1,i-21)i.r2
	System::Call *$2(i,i,i0,i,i2,i16|8|4|1)
	System::Call User32::SetWindowLong(ir1,i-21,ir2)
FunctionEnd
