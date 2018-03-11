/*
<NSISͼƬˮ����Ч�ű�>
�ű���д��zhfi
�ر��л��Restools��X-Star

��ʾ:ˮ�Ƶ�ͼ�����Ƿ�ת��ͼƬ����ʾ��ʱ��ᷭתͼƬ����ʾ��
*/

!include MUI.nsh ;������Ҫʹ�õ�ͷ�ļ�
; --------------------------------------------------
; General settings.

Name "WaterCtrl_Test Example"
OutFile "WaterCtrl_Test.exe"
SetCompressor /SOLID lzma
    
;��ӱ����ļ�, һ���ǰ�װ����������Ҫʹ�õĻ�������ǰ�ͷŵ���Դ/������ļ�
ReserveFile "${NSISDIR}\Plugins\System.dll"
ReserveFile "${NSISDIR}\Plugins\WaterCtrl.dll"

; --------------------------------------------------
; MUI interface settings.
!define MUI_FINISHPAGE_NOAUTOCLOSE  ;���Զ��������ҳ��
; --------------------------------------------------
; Insert MUI pages.
!define MUI_WELCOMEFINISHPAGE_BITMAP  "${NSISDIR}\Contrib\Graphics\Wizard\win.bmp"

; Installer pages  ;���ҳ���Զ��庯��
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

Section ""
SectionEnd

Function .onInit  ;�����ʼ������, һ�����ͷ���Ҫ�õ��Ĳ������Դ
  InitPluginsDir  ;��ʼ����ʱ���Ŀ¼
  File "/oname=$PLUGINSDIR\WaterCtrl.dll" "${NSISDIR}\Plugins\WaterCtrl.dll" ;�ͷ�ˮ�Ʋ������ʱ���Ŀ¼
FunctionEnd

Function .onGUIEnd  ;����رպ���, һ�����ͷ����õĲ��, �Ա��ڰ�װ�������˳�ʱ����Լ�����ʱĿ¼
  WaterCtrl::disablewater
  System::Free
FunctionEnd

Function Pre   ;�����ҳ��Ԥ������. ������, �����������Ҫʹ��
  ;�����Ҫ������ҳ��, �ڴ˺��������Abort��ֹ����
FunctionEnd

Function Show   ;�Զ����ҳ����ʾ����, һ�������ڶ��Ƶ�ǰҳ�������
  System::Call 'user32::LoadImage(i,t,i,i,i,i,) i (0,"$PLUGINSDIR\modern-wizard.bmp",0,0,0,0x2010) .s' ;��λͼ�����ڴ���
  Pop $R0  ;�������ɹ�, ���ﵯ�������ڴ���λͼ�ľ��
  !insertmacro INSTALLOPTIONS_READ $R1 "ioSpecial.ini" "Field 1" "HWND"  ;��ȡͼƬ�����ľ��
  System::Call '$PLUGINSDIR\WaterCtrl::enablewater(i,i,i,i,i,i) i ($R1,0,0,$R0,3,50)'  ;��ʼˮ����Ч
  System::Call '$PLUGINSDIR\WaterCtrl::setwaterparent(i $R1)'  ;����ͼƬ�ľ��ΪͼƬ����
  System::Call '$PLUGINSDIR\WaterCtrl::flattenwater()'
  System::Call '$PLUGINSDIR\WaterCtrl::waterblob(i,i,i,i) i (70,198,10,1000)'
FunctionEnd

Function Leave   ;�Զ����ҳ���뿪����, һ�����ڵ�ǰҳ�����β����
  System::Call '$PLUGINSDIR\WaterCtrl::disablewater()' ;ֹͣˮ�Ʋ���
FunctionEnd
