;Var MSG     ;MSG�������붨�壬��������ǰ�棬����WndProc::onCallback���������������Ҫ�����Ϣ����,���ڼ�¼��Ϣ��Ϣ
Var BGImage2  ;������ͼ
Var ImageHandle2
Var WarningForm

!include "nsWindows.nsh"

;�����Ի����ƶ�
Function onWarningGUICallback
  ${If} $MSG = ${WM_LBUTTONDOWN}
    SendMessage $WarningForm ${WM_NCLBUTTONDOWN} ${HTCAPTION} $0
  ${EndIf}
FunctionEnd

Function MessgesboxPage
IsWindow $WarningForm Create_End
    ;!define Style ${WS_VISIBLE}|${WS_OVERLAPPEDWINDOW}
    ;${NSW_CreateWindowEx} $WarningForm $hwndparent ${ExStyle} ${Style} "" 1018
    
    ${NSW_CreateWindow} $WarningForm "" 1044   ;��������
    ${NSW_CenterWindow} $WarningForm $hwndparent  ;������$WarningForm������$hwndparent

    ;${NSW_SetWindowSize} $WarningForm 374 153
    System::Call `user32::SetWindowLong(i$WarningForm,i${GWL_STYLE},0x9480084C)i.R0`
    EnableWindow $hwndparent 0
  
	${NSW_CreateButton} 145u 79u 70 22 'ȷ��'
	Pop $1
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_messanniu.bmp $1
  GetFunctionAddress $3 onClickclos
  SkinBtn::onClick $1 $3

	${NSW_CreateButton} 195u 79u 70 22 'ȡ��'
	Pop $0
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_messanniu.bmp $0
  GetFunctionAddress $3 onClickCancel
  SkinBtn::onClick $0 $3

  ;�رհ�ť
  ${NSW_CreateButton} 233u 2u 22 22 ""
	Pop $0
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_messclose.bmp $0
  GetFunctionAddress $3 onClickCancel
  SkinBtn::onClick $0 $3

 	;�˳���ʾ
  ${NSW_CreateLabel} 52u 40u 170u 9u "��ȷ��Ҫ�˳�${PRODUCT_NAME}��װ���̣�"
  Pop $R3
  ;SetCtlColors $R2 "" 0xFFFFFF ;��ɫ
  SetCtlColors $R3 ""  transparent ;�������͸��

 	;���Ͻ�����
  ${NSW_CreateLabel} 6u 6u 150u 9u "��ʾ"
  Pop $R2
  ;SetCtlColors $R2 "" 0xFFFFFF ;��ɫ
  SetCtlColors $R2 ""  transparent ;�������͸��

	;����ͼ
	${NSW_CreateBitmap} 0 0 380u 202u ""
  Pop $BGImage2
  ${NSW_SetImage} $BGImage2 $PLUGINSDIR\MessageDlgBkg.bmp $ImageHandle2

	GetFunctionAddress $0 onWarningGUICallback
	WndProc::onCallback $BGImage2 $0 ;�����ޱ߿����ƶ�
	WndProc::onCallback $R2 $0
	WndProc::onCallback $R3 $0

  ${NSW_CenterWindow} $WarningForm $hwndparent
	${NSW_Show}
	Create_End:
  ShowWindow $WarningForm ${SW_SHOW}

FunctionEnd

Function onClickCancel ;ȡ��
  ;ShowWindow $WarningForm ${SW_HIDE}
  ${NSW_DestroyWindow} $WarningForm  ;���ٴ���, ��Ȼ��Ҳ���Ի����ô���1����
  BringToFront                    ;�������ڼ���
  ${NSW_RestoreWindow} $hwndparent  ;�ָ������ڴ�С
  EnableWindow $hwndparent 1     ;����������
FunctionEnd


#------------------------------------------
#�رմ���
#------------------------------------------
Function onClickclos
 ${NSW_DestroyWindow} $WarningForm  ;���ٴ���, ��Ȼ��Ҳ���Ի����ô���1����
;SendMessage $hwndparent ${WM_CLOSE} 0 0  ;�ر�
;Abort
  BringToFront                    ;�������ڼ���
  ${NSW_RestoreWindow} $hwndparent  ;�ָ������ڴ�С
  EnableWindow $hwndparent 1       ;����������
  
  ;IntOp $STATE 1 - 1
  ;SendMessage $hwndparent ${WM_CLOSE} 0 0  ;�ر�
  ;StrCpy $STATE 0
  ;MessageBox MB_OK "${chushihua}"
  ;${NSD_SetText} ${chushihua} 0
  ;StrCpy ${chushihua} 0
  ;StrCpy ${chushihua} $5
  ;MessageBox MB_OK "${chushihua}"
  ;IntOp $STATE ${chushihua} !
  ;Call Messgesbox
  SendMessage $hwndparent ${WM_CLOSE} 0 0  ;�ر�
FunctionEnd


