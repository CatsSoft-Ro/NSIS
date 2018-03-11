;Var MSG     ;MSG变量必须定义，而且在最前面，否则WndProc::onCallback不工作，插件中需要这个消息变量,用于记录消息信息
Var BGImage2  ;背景大图
Var ImageHandle2
Var WarningForm

!include "nsWindows.nsh"

;弹出对话框移动
Function onWarningGUICallback
  ${If} $MSG = ${WM_LBUTTONDOWN}
    SendMessage $WarningForm ${WM_NCLBUTTONDOWN} ${HTCAPTION} $0
  ${EndIf}
FunctionEnd

Function MessgesboxPage
IsWindow $WarningForm Create_End
    ;!define Style ${WS_VISIBLE}|${WS_OVERLAPPEDWINDOW}
    ;${NSW_CreateWindowEx} $WarningForm $hwndparent ${ExStyle} ${Style} "" 1018
    
    ${NSW_CreateWindow} $WarningForm "" 1044   ;创建窗口
    ${NSW_CenterWindow} $WarningForm $hwndparent  ;将窗口$WarningForm居中于$hwndparent

    ;${NSW_SetWindowSize} $WarningForm 374 153
    System::Call `user32::SetWindowLong(i$WarningForm,i${GWL_STYLE},0x9480084C)i.R0`
    EnableWindow $hwndparent 0
  
	${NSW_CreateButton} 145u 79u 70 22 '确定'
	Pop $1
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_messanniu.bmp $1
  GetFunctionAddress $3 onClickclos
  SkinBtn::onClick $1 $3

	${NSW_CreateButton} 195u 79u 70 22 '取消'
	Pop $0
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_messanniu.bmp $0
  GetFunctionAddress $3 onClickCancel
  SkinBtn::onClick $0 $3

  ;关闭按钮
  ${NSW_CreateButton} 233u 2u 22 22 ""
	Pop $0
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_messclose.bmp $0
  GetFunctionAddress $3 onClickCancel
  SkinBtn::onClick $0 $3

 	;退出提示
  ${NSW_CreateLabel} 52u 40u 170u 9u "您确定要退出${PRODUCT_NAME}安装过程？"
  Pop $R3
  ;SetCtlColors $R2 "" 0xFFFFFF ;蓝色
  SetCtlColors $R3 ""  transparent ;背景设成透明

 	;左上角文字
  ${NSW_CreateLabel} 6u 6u 150u 9u "提示"
  Pop $R2
  ;SetCtlColors $R2 "" 0xFFFFFF ;蓝色
  SetCtlColors $R2 ""  transparent ;背景设成透明

	;背景图
	${NSW_CreateBitmap} 0 0 380u 202u ""
  Pop $BGImage2
  ${NSW_SetImage} $BGImage2 $PLUGINSDIR\MessageDlgBkg.bmp $ImageHandle2

	GetFunctionAddress $0 onWarningGUICallback
	WndProc::onCallback $BGImage2 $0 ;处理无边框窗体移动
	WndProc::onCallback $R2 $0
	WndProc::onCallback $R3 $0

  ${NSW_CenterWindow} $WarningForm $hwndparent
	${NSW_Show}
	Create_End:
  ShowWindow $WarningForm ${SW_SHOW}

FunctionEnd

Function onClickCancel ;取消
  ;ShowWindow $WarningForm ${SW_HIDE}
  ${NSW_DestroyWindow} $WarningForm  ;销毁窗口, 当然你也可以换成让窗口1隐藏
  BringToFront                    ;将主窗口激活
  ${NSW_RestoreWindow} $hwndparent  ;恢复主窗口大小
  EnableWindow $hwndparent 1     ;启用主窗口
FunctionEnd


#------------------------------------------
#关闭代码
#------------------------------------------
Function onClickclos
 ${NSW_DestroyWindow} $WarningForm  ;销毁窗口, 当然你也可以换成让窗口1隐藏
;SendMessage $hwndparent ${WM_CLOSE} 0 0  ;关闭
;Abort
  BringToFront                    ;将主窗口激活
  ${NSW_RestoreWindow} $hwndparent  ;恢复主窗口大小
  EnableWindow $hwndparent 1       ;启用主窗口
  
  ;IntOp $STATE 1 - 1
  ;SendMessage $hwndparent ${WM_CLOSE} 0 0  ;关闭
  ;StrCpy $STATE 0
  ;MessageBox MB_OK "${chushihua}"
  ;${NSD_SetText} ${chushihua} 0
  ;StrCpy ${chushihua} 0
  ;StrCpy ${chushihua} $5
  ;MessageBox MB_OK "${chushihua}"
  ;IntOp $STATE ${chushihua} !
  ;Call Messgesbox
  SendMessage $hwndparent ${WM_CLOSE} 0 0  ;关闭
FunctionEnd


