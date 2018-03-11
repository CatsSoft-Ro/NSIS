/*
#�ű�����<ButtonLinker.nsi>#
��д��X-Star, zhfi
���������ò����ͷ�ļ�����������ť&����&�˵��������޸�UI����ʵ��
��Դ����� "ButtonLinker.dll"��"System.dll" ��ͷ�ļ� "UseFulLib.nsh"
*/

!AddPluginDir ".\"
!AddIncludeDir ".\"

!include MUI2.nsh
;!include ButtonLinkerLib.nsh
!include UsefulLib.nsh

; --------------------------------------------------
; General settings.

Name "ButtonLinker Example"
OutFile "ButtonLinkerMUI.exe"
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

 !insertmacro MUI_PAGE_LICENSE ButtonLinker.nsi

 !insertmacro MUI_PAGE_Directory

 !insertmacro MUI_PAGE_INSTFILES      

!define MUI_PAGE_CUSTOMFUNCTION_PRE Finish
 !insertmacro MUI_PAGE_Finish
; UnInstaller pages
!define MUI_CUSTOMFUNCTION_UnGUIINIT Un.MyGUIInit
 !insertmacro MUI_UnPAGE_WELCOME
 !insertmacro MUI_UnPAGE_INSTFILES

; --------------------------------------------------
; Languages.

 !insertmacro MUI_LANGUAGE "SimpChinese"

/*����Ҫ�����Ŀؼ�ID*/
;ע�⣺ID�����ظ�����������δ֪����
;������ڰ�ť
!ifndef IDC_BUTTON
!define IDC_BUTTON 			1190
!endif
;��������
!ifndef IDC_LINKER
!define IDC_LINKER 			1200
!endif
;���帴ѡ��CheckBox2
!ifndef IDC_CheckBox2
!define IDC_CheckBox2 		1210
!endif
;���帴ѡ��CheckBox3
!ifndef IDC_CheckBox3
!define IDC_CheckBox3 		1220
!endif
;������ڲ˵�1       
!ifndef IDM_SEPARATOR
!define IDM_SEPARATOR 			1300
!endif
!ifndef IDM_ABOUT1
!define IDM_ABOUT1 			1301
!endif
;������ڲ˵�2
!ifndef IDM_ABOUT2
!define IDM_ABOUT2 			1302
!endif

; --------------------------------------------------
; ������������
!macro MYMACRO un

Function ${un}.AboutButton
	MessageBox MB_OK|MB_ICONINFORMATION "���ڰ�ť!"
FunctionEnd

Function ${un}.AboutMenu1
  MessageBox MB_OK|MB_ICONINFORMATION "���ڲ˵�1!"
FunctionEnd
Function ${un}.AboutMenu2
  MessageBox MB_OK|MB_ICONINFORMATION "���ڲ˵�2!"
FunctionEnd

Function ${un}.CheckBox3
/*��ȡ�ؼ�״̬*/
	;�÷���${GetButtonState} �������(0/1/error) �����ڴ��ھ�� �ؼ�ID
	${GetButtonState} $0 $HWNDPARENT ${IDC_CheckBox3}
;  MessageBox MB_OK|MB_ICONINFORMATION "$0"
${if} $0 == 0
  MessageBox MB_yesno|MB_ICONINFORMATION "ȡ��ѡ��" idyes true idno false
true:
	${SetButtonState} 0 $HWNDPARENT ${IDC_CheckBox3}
goto End
false:
	${SetButtonState} 1 $HWNDPARENT ${IDC_CheckBox3}
goto End
${elseif} $0 == 1
  MessageBox MB_yesno|MB_ICONINFORMATION "ѡ��" idyes true2 idno false2
true2:
	${SetButtonState} 1 $HWNDPARENT ${IDC_CheckBox3}
goto End
false2:
	${SetButtonState} 0 $HWNDPARENT ${IDC_CheckBox3}
goto End
${else}
  MessageBox MB_OK|MB_ICONINFORMATION "$0!"
${endif}
End:
FunctionEnd

Function ${un}.MyGUIInit
InitPluginsDir

Pop $0
Pop $1
Pop $2
Pop $3

/*����������ť*/
	;��ȡ��ȡ������ť��λ��
    ${GetDlgItemRect} $0 $1 $2 $3 $HWNDPARENT ${IDC_CANCEL}
	IntOp $2 $3 - $1
	;�÷���${CreateButton2} ��ʾ�ı� X��λ�� Y��λ�� ��� �߶� �����ڴ��ھ�� �ؼ�ID Ŀ�꺯��
	;�ο���ȡ������λ��������������ť
	${CreateButton2} "����(&A)" 20 $1 80 $2 $HWNDPARENT ${IDC_BUTTON} ${un}.AboutButton

/*������������*/
	;��ȡ��ȡ������ť��λ��
    ${GetDlgItemRect} $0 $1 $2 $3 $HWNDPARENT ${IDC_CANCEL}
	IntOp $2 $3 - $1
	IntOp $1 $1 + 4
	IntOp $2 $2 - 1
	;�÷���${CreateLinker2} ��ʾ�ı� X��λ�� Y��λ�� ��� �߶� �����ڴ��ھ�� �ؼ�ID ���ӵ�ַ
	;�ο���ȡ������λ����������������
	${CreateLinker2} "�����ҵ���ҳ" 120 $1 80 $2 $HWNDPARENT ${IDC_LINKER} "http://hi.baidu.com/xstar2008"

/*����������ѡ��*/
	;��ȡ��ȡ������ť��λ��
    ${GetDlgItemRect} $0 $1 $2 $3 $HWNDPARENT ${IDC_CANCEL}
	IntOp $2 $3 - $1
	IntOp $1 $1 + 4
	IntOp $2 $2 - 1
	;�÷���${CreateCheckBox2} ��ʾ�ı� X��λ�� Y��λ�� ��� �߶� �����ڴ��ھ�� �ؼ�ID �ؼ�״̬(0/1)
	;�ο���ȡ������λ��������������ѡ��
	${CreateCheckBox2} "CheckBox2" 200 $1 50 $2 $HWNDPARENT ${IDC_CheckBox2} 1

	;�÷���${CreateCheckBox3} ��ʾ�ı� X��λ�� Y��λ�� ��� �߶� �����ڴ��ھ�� �ؼ�ID �ؼ�״̬(0/1) Ŀ�꺯��
	;�ο���ȡ������λ��������������ѡ��
	${CreateCheckBox3} "CheckBox3" 250 $1 50 $2 $HWNDPARENT ${IDC_CheckBox3} 0 ${un}.CheckBox3


/*���������˵�*/
	;�÷���${CreateMenu2} ��ʾ�ı� �˵����� �����ڴ��ھ�� �˵�ID
	${CreateMenu} 0 ${MF_SEPARATOR} $HWNDPARENT ${IDM_SEPARATOR}
	;�÷���${CreateMenu2} ��ʾ�ı� �˵����� �����ڴ��ھ�� �˵�ID Ŀ�꺯��
	${CreateMenu2} "���ڲ˵�1(&A)" ${MF_STRING} $HWNDPARENT ${IDM_ABOUT1} ${un}.AboutMenu1
	${CreateMenu2} "���ڲ˵�2(&A)" ${MF_STRING} $HWNDPARENT ${IDM_ABOUT2} ${un}.AboutMenu2

FunctionEnd

Function ${un}.onGUIEnd
ButtonLinker::unload
FunctionEnd

; --------------------------------------
!macroend

; ���밲װ/ж�غ���
!insertmacro MYMACRO ""
!insertmacro MYMACRO "un"

Function ${un}.Love
  MessageBox MB_OK|MB_ICONINFORMATION "����һ����!"
FunctionEnd

 Section "Dummy" SecDummy
${DeleteMenu2} $HWNDPARENT ${IDM_ABOUT1}
  Sleep 1000
/*��ȡ�ؼ�״̬*/
	;�÷���${GetButtonState} �������(0/1/error) �����ڴ��ھ�� �ؼ�ID
	${GetButtonState} $0 $HWNDPARENT ${IDC_CheckBox2}
StrCmp $0 1 0 +2
	Messagebox MB_OK "������"
  Sleep 1000
WriteUninstaller "$Exedir\uninst.exe"

${ModifyMenu2} $HWNDPARENT ${IDM_ABOUT2} "�Ұ���" ${un}.Love
 SectionEnd

Section Uninstall
Delete "$Instdir\Uninst.exe"
SectionEnd

Function Finish
${DeleteMenu2} $HWNDPARENT ${IDM_ABOUT2}
${DeleteMenu} $HWNDPARENT ${IDM_SEPARATOR}
${DestroyWindow} $HWNDPARENT ${IDC_BACK}
${DestroyWindow} $HWNDPARENT ${IDC_CANCEL}
FunctionEnd

