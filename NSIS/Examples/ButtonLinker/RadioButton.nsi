/*
#�ű�����<RadioButton.nsi>#
��д��X-Star, zhfi
���������ò����ͷ�ļ�������ѡ��ť�������޸�UI����ʵ��
��Դ����� "Buttonlinker.dll"��"System.dll" ��ͷ�ļ� "UseFulLib.nsh"
*/

!AddPluginDir ".\"
!AddIncludeDir ".\"

!include MUI2.nsh
!include UseFulLib.nsh

; --------------------------------------------------
; General settings.

Name "RadioButton Example"
OutFile "RadioButtonMUI.exe"
SetCompressor /SOLID lzma

ReserveFile "${NSISDIR}\Plugins\ButtonLinker.dll"

InstallDir $ExeDir

; --------------------------------------------------
; MUI interface settings.

 # We want to use our own UI with custom buttons!
 # The event handler for our parent button is added in MyGUIInit.
 !define MUI_CUSTOMFUNCTION_GUIINIT .MyGUIInit
# Don't skip to the finish page.
 !define MUI_FINISHPAGE_NOAUTOCLOSE

; --------------------------------------------------
; Insert MUI pages.

; Installer pages
 !insertmacro MUI_PAGE_WELCOME
!define MUI_PAGE_WELCOME_SHOW InstFilesShow

 !insertmacro MUI_PAGE_LICENSE RadioButton.nsi

 !insertmacro MUI_PAGE_Directory

 ;!define MUI_PAGE_CUSTOMFUNCTION_SHOW InstFilesShow
 !insertmacro MUI_PAGE_INSTFILES

; UnInstaller pages
!define MUI_CUSTOMFUNCTION_UnGUIINIT Un.MyGUIInit
 !insertmacro MUI_UnPAGE_INSTFILES

; --------------------------------------------------
; Languages.

 !insertmacro MUI_LANGUAGE "SimpChinese"

; --------------------------------------------------

/*����Ҫ�����Ŀؼ�ID*/
;ע�⣺ID�����ظ�����������δ֪����
;������ڰ�ť
!ifndef IDC_RadioButton1
!define IDC_RadioButton1 			1231
!endif
!ifndef IDC_RadioButton2
!define IDC_RadioButton2 			1232
!endif
!ifndef IDC_RadioButton3
!define IDC_RadioButton3 			1233
!endif

; ������������
!macro MYMACRO un

Function ${un}.RadioButton3
MessageBox MB_OK RadioButton3
FunctionEnd


Function ${un}.MyGUIInit
InitPluginsDir

Pop $0
Pop $1
Pop $2
Pop $3

/*������ѡ��ť��*/
	;��ȡ��ȡ������ť��λ��
    ${GetDlgItemRect} $0 $1 $2 $3 $HWNDPARENT ${IDC_CANCEL}
	IntOp $2 $3 - $1
	;������ѡ��ť�飺${CreateRadioButtonGroup} ��ʾ�ı� X��λ�� Y��λ�� ��� �߶� �����ڴ��ھ�� �ؼ�ID �ؼ�״̬(0/1)
	;������ѡ��ť�飺${CreateRadioButtonGroup2} ��ʾ�ı� X��λ�� Y��λ�� ��� �߶� �����ڴ��ھ�� �ؼ�ID �ؼ�״̬(0/1) Ŀ�꺯��
	;������ѡ��ť��(������CreateRadioButtonGroup������Բť)��${CreateRadioButton} ��ʾ�ı� X��λ�� Y��λ�� ��� �߶� �����ڴ��ھ�� �ؼ�ID �ؼ�״̬(0/1)
	;������ѡ��ť��(������CreateRadioButtonGroup������Բť)��${CreateRadioButton2} ��ʾ�ı� X��λ�� Y��λ�� ��� �߶� �����ڴ��ھ�� �ؼ�ID �ؼ�״̬(0/1) Ŀ�꺯��
	;�ο���ȡ������λ����������ѡ��ť
	${CreateRadioButtonGroup} "RadioButton1" 20 $1 100 $2 $HWNDPARENT ${IDC_RadioButton1} 0
	${CreateRadioButton} "RadioButton2" 120 $1 100 $2 $HWNDPARENT ${IDC_RadioButton2} 0
	${CreateRadioButton2} "RadioButton3" 220 $1 100 $2 $HWNDPARENT ${IDC_RadioButton3} 0 ${un}.RadioButton3

	;�÷���${CheckRadioButton} �����ڴ��ھ�� ���е�һ����ѡ��ťID  �������һ����ѡ��ťID Ҫ��ѡ�ĵ�ѡ��ťID
	${CheckRadioButton} $HWNDPARENT ${IDC_RadioButton1} ${IDC_RadioButton3} ${IDC_RadioButton2}
 
FunctionEnd

Function ${un}.onGUIEnd
ButtonLinker::unload
FunctionEnd

; --------------------------------------
!macroend

; ���밲װ/ж�غ���
!insertmacro MYMACRO ""
!insertmacro MYMACRO "un"

 Section "Dummy" SecDummy
/*��ȡ�ؼ�״̬*/
	;�÷���${GetButtonState} �������(0/1/error) �����ڴ��ھ�� �ؼ�ID
	${GetButtonState} $0 $HWNDPARENT ${IDC_RadioButton2}
StrCmp $0 1 0 +2
	Messagebox MB_OK "������"
  Sleep 1000
WriteUninstaller "$Exedir\uninst.exe"
 SectionEnd

Section Uninstall
Delete "$Instdir\Uninst.exe"
SectionEnd

