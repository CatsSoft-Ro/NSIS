;handle to window 2
var hwindow2
;handle to controls
Var hBUTTON2
Var hEDIT2
Var hCHECKBOX2

Function nsWindowsPage2
  IsWindow $hwindow2 Create_End
	${NSW_CreateWindow} $hwindow2 "WND 2" 1018   ;��������

  ;set the child window's pos to the center of parent window
  ${NSW_CenterWindow} $hwindow2 $hwndparent  ;������$hwindow2������$hwndparent
  ;set the distransparent percentage
  ${NSW_SetTransparent} $hwindow2 80  ;���ô��ڵĲ�͸����

  EnableWindow $hwndparent 0   ;����������
  ;call back function of window 2
	${NSW_OnBack} OnBack2    ;���ڵĻص�����, �ڵ��Xϵͳ��ť�رմ���ʱִ��

	${NSW_CreateButton} 0 0 100% 12u Test
	Pop $hBUTTON2
	${NSW_OnClick} $hBUTTON2 OnClick2

	${NSW_CreateButton} 100 -30 50 18u 'WND 1'
	Pop $R0
	${NSW_OnClick} $R0 nsWindowsPage1

	${NSW_CreateButton} 50 -30 50 18u 'Close '
	Pop $R0
	${NSW_OnClick} $R0 OnBack2

	${NSW_CreateText} 0 35 100% 12u "hello (please drop one file to here)"
	Pop $hEDIT2
	${NSW_OnChange} $hEDIT2 OnChange2   ;��������ʱִ��
	;DropFiles ;single file only
	${NSW_onDropFiles} $hEDIT2 onDropSingleFile  ;����ļ�ק��֧��

	${NSW_CreateCheckbox} 0 -40 100% 8u Test
	Pop $hCHECKBOX2
	${NSW_OnClick} $hCHECKBOX2 OnCheckbox

	${NSW_CreateLabel} 0 40u 75% 40u "* Type `hello there` above.$\n* Click the button.$\n* Check the checkbox.$\n* Hit the Back button."
	Pop $0

	${NSW_Show}
Create_End:
  ShowWindow $hwindow2 ${SW_SHOW}
FunctionEnd

Function OnClick2

	Pop $0 # HWND

	MessageBox MB_OK clicky

FunctionEnd


Function OnChange2

	Pop $0 # HWND

	${NSW_GetText} $hEDIT2 $0

	${If} $0 == "hello there"
		MessageBox MB_OK "right back at ya"
	${EndIf}

FunctionEnd

Function OnBack2
  EnableWindow $hwindow2 0
  MessageBox MB_YESNO "are you sure? $$hwindow2:$hwindow2" IDYES +3
  EnableWindow $hwindow2 1
	Abort
  ${NSW_DestroyWindow} $hwindow2
  EnableWindow $hwndparent 1
  BringToFront

FunctionEnd

; ק�뵥���ļ��Ĵ�����
Function onDropSingleFile ;drop single file  ;ק�뵥���ļ�
	Pop $iDropFiles ;numbers of files   ;��ק���ļ��ĸ���
	Pop $sDropFiles ;full path of this (the first one) file  ;ק����ļ�·��, ����ļ�������ֹһ��, ����˳���Ⱥ󵯳�
  ${For} $R0 2 $iDropFiles  ; ���ļ���������1��ʱ, ���뽫��ջ�ж���Ĳ���Ҫ���ļ�·���ͷŵ�, ��ֹ����
    Pop $R1   ;pop up the rest strings from static memory (if you droped more than one) ;�ͷŵ���ջ�е������ļ�·��
  ${Next}
  ;your code:
	;MessageBox MB_OK "onDropFiles $$sDropFiles:$sDropFiles"
  ${GetFileAttributes} "$sDropFiles" "ARCHIVE" $R0  ;��ȡ�ļ�����, ��������� "ARCHIVE" , ���Է��� $R0 ����1, ��������0
  StrCmp $R0 1 0 +2  ;����� "ARCHIVE" (1), �͸���edit���ı�Ϊ ��ק����ļ�
	  ${NSW_SetText} $hEDIT2 "$sDropFiles"

FunctionEnd


