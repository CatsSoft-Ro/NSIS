#Ƥ����ʾ����  ����� www.flighty.cn

!define PRODUCT_NAME "My application"
SetCompressor lzma
!include "MUI.nsh"

!define MUI_CUSTOMFUNCTION_GUIINIT onGUIInit

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_LANGUAGE "SimpChinese"

Name "Ƥ����ʾ����"
OutFile "Ƥ����ʾ.exe"
InstallDir "$PROGRAMFILES\My application"

Section
SectionEnd

Function onGUIInit
  InitPluginsDir
  SetOutPath $PLUGINSDIR
  File "${NSISDIR}\Plugins\SkinH.dll"
  File skinh.she
  System::Call SkinH::SkinH_Attach()

################ SkinSharp����, ��С�·�����ʾ ################
  System::Call Kernel32::GetModuleHandle(t"SkinH.dll")i.r0
  IntOp $0 $0 + 0x0002CA98
  System::Call Kernel32::GetCurrentProcess()i.s
  System::Call Kernel32::VirtualProtectEx(is,ir0,i4,i0x40,*i)
  System::Call "*$0(&i1 0)"
###############################################################
FunctionEnd

Function .onGUIEnd
; �ò��Ŀ¼��˳��ɾ��
  System::Call Kernel32::GetModuleHandle(t"SkinH.dll")i.s
  System::Call Kernel32::FreeLibrary(is)
  System::Call Kernel32::SetCurrentDirectory(t"$EXEDIR\")
FunctionEnd


