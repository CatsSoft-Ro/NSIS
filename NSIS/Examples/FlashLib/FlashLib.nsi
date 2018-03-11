/*
<NSISͼƬFlash��Ч�ű�>
�ű���д��zhfi
�ر��л������ҹ˼�꣬Restools��X-Star
*/
;����ϸ��ע��˵��, ��鿴ˮ�Ʋ���Ľű�����: WaterCtrl.nsi

Var hFlash ;����Flash�������

!include MUI.nsh
; --------------------------------------------------
; General settings.
Name "FlashLib_Test Example"
OutFile "FlashLib_Test.exe"
SetCompressor /SOLID lzma     

ReserveFile "${NSISDIR}\Plugins\System.dll"
ReserveFile "${NSISDIR}\Plugins\FlashLib.dll"
ReserveFile "${NSISDIR}\Examples\FlashLib\1.swf"
; --------------------------------------------------
; MUI interface settings.
!define MUI_FINISHPAGE_NOAUTOCLOSE

; --------------------------------------------------
; Installer pages
!define MUI_PAGE_CUSTOMFUNCTION_PRE Pre
!define MUI_PAGE_CUSTOMFUNCTION_SHOW Show
!define MUI_PAGE_CUSTOMFUNCTION_LEAVE Leave
!insertmacro MUI_PAGE_WELCOME

!insertmacro MUI_PAGE_INSTFILES

!define MUI_PAGE_CUSTOMFUNCTION_Pre Pre
!define MUI_PAGE_CUSTOMFUNCTION_SHOW Show
!define MUI_PAGE_CUSTOMFUNCTION_LEAVE Leave
!insertmacro MUI_PAGE_FINISH
; --------------------------------------------------
; Languages.
!insertmacro MUI_LANGUAGE "SimpChinese"
; --------------------------------------------------
Section ""
SectionEnd

Function .onInit
  InitPluginsDir
!define MySWF "$PLUGINSDIR\1.swf"
  File "/oname=${MySWF}" "${NSISDIR}\Examples\FlashLib\1.swf"
  File "/oname=$PLUGINSDIR\FlashLib.dll" "${NSISDIR}\Plugins\FlashLib.dll"
FunctionEnd

Function Pre
FunctionEnd

Function Show
  System::Call 'user32::LoadImage(i,t,i,i,i,i,) i (0,"$PLUGINSDIR\modern-wizard.bmp",0,0,0,0x2010) .s'
  Pop $R0
  !insertmacro INSTALLOPTIONS_READ $R1 "ioSpecial.ini" "Field 1" "HWND"  ;��ȡͼƬ�����ľ��
  System::Call '$PLUGINSDIR\FlashLib::FlashLibInit(i,i,i,i,i,i,i) i (0,0,164,291,$R1,$R0,true) .s'
  Pop $hFlash
  System::Call '$PLUGINSDIR\FlashLib::FlashLoadMovie(i,t) i ($hFlash, "${MySWF}")'
FunctionEnd

Function Leave
  System::Call '$PLUGINSDIR\FlashLib::FlashLibFree(i $hFlash)'
FunctionEnd

Function .onGUIEnd
  System::Call '$PLUGINSDIR\FlashLib::FlashLibFree(i $hFlash)'
  System::Free
  ;����FlashLib���������ԭ����NSIS���, ��������ͷź������ܲ�������
  ;��Ҫ���ļ�����Ϊ����ɾ��, ������ʱ�������
  Delete /REBOOTOK "$PLUGINSDIR\FlashLib.dll"
  RMDIR /REBOOTOK "$PLUGINSDIR"
FunctionEnd
