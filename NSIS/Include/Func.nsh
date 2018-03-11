!include "WordFunc.nsh"
!include "nsWindows.nsh"
!ifndef HWNDAboutWindow
var HWNDAboutWindow
!define HWNDAboutWindow
!endif

!macro Func un
Function ${un}GUIInit
;�����ö�
System::Call "user32::SetWindowPos(i $HWNDPARENT, i -1, i0, i0, i0, i0, i 3)"

;����͸����(�����GUIInit)
StrCpy $R2 220  ;͸���ȣ�0-255��
System::Call 'User32::GetWindowLong(i $HWNDPARENT, i -20) .iR0'
IntOp $R0 $R0 + 0x80000
System::Call 'User32::SetWindowLong(i $HWNDPARENT, i -20, i R0) .iR1'
System::Call 'User32::SetLayeredWindowAttributes(i $HWNDPARENT, i 0, i R2, i 2) .i R0'
;�����°�ť
GetFunctionAddress $R0 ${un}CheckUpdate
ButtonEvent::AddEventHandler /NOUNLOAD 10 $R0
FunctionEnd


Function ${un}CheckUpdate
${NSW_CreateWindow} $HWNDAboutWindow "���� $(^NameDA) v${VERSION}" 1018
SetCtlColors $HWNDAboutWindow ""   0xFFFFFF
${NSW_SetWindowSize} $HWNDAboutWindow 250 250
${NSW_CenterWindow} $HWNDAboutWindow $hwndparent
${NSW_SetTransparent} $HWNDAboutWindow 95
${NSW_OnBack} ${un}AboutClose

${NSW_CreateLabel} 5% 5% 90% 25% "NSIS�����������Դ�ϼ�$\r$\n�����д��Ansifa$\r$\n�������ڣ�${__TIMESTAMP__}$\r$\n�汾��${VersionS}(${Version})"
Pop $R0
SetCtlColors $R0 0x000000 0xFFFFFF

${NSW_CreateLabel} 5% 31% 90% 35% "����չ�������˴󲿷�NSIS�ٷ���վ�ϵĲ�����Ұ��ձ�׼��ʽ����á����һ���ÿ�������������һ���ٷ����Լ���д�����ӣ���������ѧϰ��ͬʱҲ������һЩ�ϳ��û���м�ֵ�Ĵ������ӣ���ҿ��Բο��¡�"
Pop $R0
SetCtlColors $R0 0x00468C 0xFFFFFF

${NSW_CreateLabel} 5% 68% 90% 12% "����Դ�ϼ����°汾�����ڴ������SVN��ַ���ҵ�����ϸ��ַ�ǣ�"
Pop $R0
SetCtlColors $R0 0x3399FF 0xFFFFFF

${NSW_CreateLink} 5% 82% 90% 12% "NSIS Extend Pack Project"
Pop $R0
SetCtlColors $R0 0xFF0080 0xFFFFFF
${NSW_OnClick} $R0 ${un}UpdateLink

StrCpy $0 100
StrCpy $1 12

${NSW_Show}

ShowWindow $HWNDAboutWindow ${SW_SHOW}
EnableWindow $HWNDPARENT 0
FunctionEnd

Function ${un}AboutClose
${NSW_CloseWindow} $HWNDAboutWindow
EnableWindow $HWNDPARENT 1
BringToFront
FunctionEnd

Function ${un}UpdateLink
ExecShell open "http://nsisfans.googlecode.com/svn/trunk/NSISExtendPack/Build" SW_SHOWMAXIMIZED
FunctionEnd
!macroend

!insertmacro Func ""
!insertmacro Func "Un."


Function PRE
;��ҳ��Ԥ����ʱ����flash
System::Call 'user32::LoadImage(i,t,i,i,i,i,) i (0,"$PLUGINSDIR\modern-wizard.bmp",0,0,0,0x2010) .s'
Pop $R0
System::Call '$PLUGINSDIR\FlashLib::FlashLibInit(i,i,i,i,i,i,i) i (0,0,164,291,$HWNDPARENT,$R0,true) .s'
Pop $hBitmap
System::Call '$PLUGINSDIR\FlashLib::FlashLoadMovie(i,t) i ($hBitmap,"$PLUGINSDIR\1.swf")'
FunctionEnd

Function LEAVE
;ҳ�����ʱж�ز��
System::Call '$PLUGINSDIR\FlashLib::FlashLibFree(i $hBitmap)'
FunctionEnd

Function INSTFILE_SHOW
w7tbp::Start
titprog::Start
FunctionEnd

