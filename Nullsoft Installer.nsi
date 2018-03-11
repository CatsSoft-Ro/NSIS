; Copyright (C) catsSoft 
; https://catssoft.blogspot.com/

Name "Nullsoft Install System"
Caption "Nullsoft Install System"
OutFile "nsis-2.51-setup_ansi.exe"
InstallDir "$PROGRAMFILES\NSIS"

!define /date date "%H:%M %d %b, %Y"
!define APPVERSION "2.51.0.0"
!define RUNASADMIN
!define CUSTOMUI
!define INIT
!define APPSIZE

VIProductVersion "2.51.0.0"
VIAddVersionKey /LANG=1048 "ProductName" "Nullsoft Install System"
VIAddVersionKey /LANG=1048 "CompanyName" "Nullsoft"
VIAddVersionKey /LANG=1048 "LegalCopyright" "Nullsoft"
VIAddVersionKey /LANG=1048 "LegalTrademarks" "Nullsoft"
VIAddVersionKey /LANG=1048 "FileDescription" "Nullsoft Install System"
VIAddVersionKey /LANG=1048 "FileVersion" "2.51"
VIAddVersionKey /LANG=1048 "ProductVersion" "2.51"
VIAddVersionKey /LANG=1048 "InternalName" "Nullsoft Install System"
VIAddVersionKey /LANG=1048 "OriginalFilename" "nsis-2.51-setup_ansi.exe"
VIAddVersionKey /LANG=1048 "File Name" "nsis-2.51-setup_ansi.exe"
VIAddVersionKey /LANG=1048 "Comments" "Install Nullsoft Install System"
VIAddVersionKey /LANG=1048 "Last Compile" "${date}"
VIAddVersionKey /LANG=1048 "Language" "English"

# COMPRESS #

SetCompressor /SOLID /FINAL lzma
SetCompress force
SetCompressorDictSize 32
SetDatablockOptimize on
SetDateSave on

# INCLUDE #

!include "MUI2.nsh"
!include "WinCore.nsh"
!include "nsWindows.nsh"
!include "LogicLib.nsh"
!include "WinMessages.nsh"
!include "FileFunc.nsh"
!include "TBProgress.nsh"
!include "x64.nsh"
!include "TickCount.nsh"
!include "StrFunc.nsh"
!insertmacro GetFileName
!insertmacro GetParameters
!insertmacro DriveSpace
!insertmacro GetParent
!insertmacro GetOptions
!insertmacro GetDrives
!insertmacro GetRoot
!insertmacro GetSize

# RUN #

!ifndef RUNASADMIN
  RequestExecutionLevel User
!else
  RequestExecutionLevel Admin
!endif

# UI #

!ifndef CUSTOMUI
  !define MUI_UI "UI\UI.exe"
  ChangeUI all "UI\UI.exe"
!else
  !define MUI_UI "UI\UI.exe"
  ChangeUI all "UI\UI.exe"
!endif

# HIDE # SHOW #

ShowInstDetails hide
ShowInstDetails nevershow
ShowUnInstDetails nevershow
XPStyle on

# BRANDING #

BrandingText /TRIMRIGHT " "

# ASSOC #

!define SHCNE_ASSOCCHANGED 0x8000000
!define SHCNF_IDLIST 0

# Icon & Stye #

Icon "Icons\appicon.ico"
!define MUI_ICON "Icons\appicon.ico"
!define MUI_UNICON "Icons\Uninstall.ico"
UninstallIcon "Icons\Uninstall.ico"

# PAGE #

!define MUI_CUSTOMFUNCTION_GUIINIT "onGuiInit"
Page custom "Page.Welcome" "Page.Welcome.Leave"
Page custom "Page.Offer" ""
!define MUI_PAGE_CUSTOMFUNCTION_SHOW "InstFilesPageShow"
!insertmacro MUI_PAGE_INSTFILES
Page custom "Page.Complete" "Page.Complete.Leave" 

# UNINSTALL

!define MUI_CUSTOMFUNCTION_UNGUIINIT "un.GUIInit"
!define MUI_PAGE_CUSTOMFUNCTION_SHOW "un.ModifyUnConfirm" 
!insertmacro MUI_UNPAGE_CONFIRM
!define MUI_PAGE_CUSTOMFUNCTION_SHOW "Un.InstFilesPageShow"
!insertmacro MUI_UNPAGE_INSTFILES
UninstPage custom "un.NSIS.Finish.Page" ""

# ENGLISH #

!insertmacro MUI_LANGUAGE "English"
!Include "Languages\English.nsh"

# ROMANIAN #

!insertmacro MUI_LANGUAGE "Romanian"
!Include "Languages\Romanian.nsh"

# onInit #

!define LOCALE_SCOUNTRY 6
!define LOCALE_SENGCOUNTRY 4098
!define LOCALE_SENGLANGUAGE 0x00001001
!define GEOCLASS_NATION 16
!define GEOID_NOT_AVAILABLE -1
!define GEO_ISO2 4
!define GEO_ISO3 5
!define GEO_OFFICIALNAME 9
!define GEO_LATITUDE 2
!define GEO_LONGITUDE 3
!define WM_IN_UPDATEMSG 0x40f

!define /math PBM_SETRANGE32 ${WM_USER} + 6
!define PBS_MARQUEE 0x08.
!define EM_SETBKGNDCOLOR 1091
;!define /math EM_SETBKGNDCOLOR ${WM_USER} + 67
!define /math EM_GETTEXTRANGE ${WM_USER} + 75
!define /math EM_AUTOURLDETECT ${WM_USER} + 91
!define /math EM_SETTEXTEX ${WM_USER} + 97
!define EM_SETEVENTMASK 0x0445
!define ES_NOOLEDRAGDROP 8
!define ENM_LINK 0x4000000
!define EN_LINK 0x70B
!define NM_CLICK -2
!define NM_RETURN -4

!define WFT_SEC 10000000
!define WFT_DAY 864000000000

!define DM_SETDEFID 0x0401
;!define WM_KEYDOWN 0x0100
;!define VK_F5      0x74

/*
!define TTM_INFOICON 0x80
!define AW_HOR_POSITIVE 0x00000001 
!define AW_HOR_NEGATIVE 0x00000002 
!define AW_VER_POSITIVE 0x00000004 
!define AW_VER_NEGATIVE 0x00000008
!define AW_CENTER 0x00000010 
!define AW_HIDE  0x00010000 
!define AW_ACTIVATE 0x00020000 
!define AW_SLIDE 0x00040000 
!define AW_BLEND 0x00080000 
*/

!define ASSOCSTR_COMMAND 1
!define ASSOCSTR_EXECUTABLE 2
!define ASSOCF_NOTRUNCATE 0x00000020
!define ASSOCF_REMAPRUNDLL 0x00000080
!define ASSOCF_NOFIXUPS 0x00000100
!define ASSOCF_ISPROTOCOL 0x00001000
!define ASSOCSTR_FRIENDLYAPPNAME 4

!define RDW_INVALIDATE 0x0001
!define RDW_INTERNALPAINT 0x0002
!define RDW_ERASE 0x0004

!define RDW_VALIDATE 0x0008
!define RDW_NOINTERNALPAINT 0x0010
!define RDW_NOERASE 0x0020

!define RDW_NOCHILDREN 0x0040
!define RDW_ALLCHILDREN 0x0080

!define RDW_UPDATENOW 0x0100
!define RDW_ERASENOW 0x0200

!define RDW_FRAME 0x0400
!define RDW_NOFRAME 0x0800

!macro RequireAdmin
  UserInfo::GetAccountType
  pop $8
  ${If} $8 != "admin"
    MessageBox MB_ICONSTOP "$(NSIS.Admin.Rights)"
    setErrorLevel 740 ;ERROR_ELEVATION_REQUIRED
    quit
  ${EndIf}
!macroend

Function RequireAdmin
  setShellVarContext all
  !insertmacro RequireAdmin
FunctionEnd

!define MAINPATH "$EXEDIR"
!define DEFAULTNORMALDESTINATON "$PROGRAMFILES\NSIS"
!define DEFAULTPORTABLEDESTINATON "${MAINPATH}\NSIS Portable"

Var /GLOBAL locale_language_code
Var /GLOBAL locale_language_name
Var /GLOBAL locale_language_id

Var /GLOBAL SOFTWARELANGUAGE
Var /GLOBAL SOFTWAREISOLANGUAGE
Var /GLOBAL SOFTWAREIDLANGUAGE
Var /GLOBAL SETTINGSDIR
Var /GLOBAL LANGUAGEDIR
Var /GLOBAL DEFAULT_LANGUAGE

!define InitGlobals  "!insertmacro _InitGlobals"
!macro _InitGlobals
    StrCpy $SETTINGSDIR "$EXEDIR\NSIS_TempDir\Settings"
    ReadINIStr $SOFTWARELANGUAGE "$SETTINGSDIR\Settings.ini" "Language" "Language"
    ReadINIStr $SOFTWAREISOLANGUAGE "$SETTINGSDIR\Settings.ini" "Language" "GeoCode"
    ReadINIStr $SOFTWAREIDLANGUAGE "$SETTINGSDIR\Settings.ini" "Language" "GeoID"
    StrCpy $locale_language_code    "$SOFTWAREISOLANGUAGE"
    StrCpy $locale_language_name    "$SOFTWARELANGUAGE"
    StrCpy $locale_language_id      "$SOFTWAREIDLANGUAGE"
!macroend

Function .onInit
  Strcpy $insWindows 0
  Strcpy $hnsWindows 0
  Var /GLOBAL LANG
  Var /GLOBAL MAINPATH
  Var /GLOBAL NormalDestDir
  Var /GLOBAL PortableDestDir
  Var /GLOBAL PortableMode
  Call RequireAdmin
  System::Call 'kernel32::CreateMutexA(i 0, i 0, t "$(^Name)") i .r1 ?e'
  System::Call 'kernel32::GetLastError() i() .r0'
  Pop $R0
  StrCmp $R0 0 done
  ${IfNot} $R0 == 0
     MessageBox MB_OK|MB_ICONEXCLAMATION "$(NSIS.Run.Warning)"
    Abort
  ${EndIf}
    MessageBox MB_OK|MB_ICONEXCLAMATION "$0"
  done:

  # Language

  System::Call 'KERNEL32::GetUserDefaultLangID()i.r0'
  System::Call "kernel32::GetSystemDefaultLCID()i.R0"
  System::Call `kernel32::GetUserDefaultUILanguage() i.s`
  System::Call 'KERNEL32::GetUserDefaultLangID()i.r0'
  Pop $R0
  strcpy $LANGUAGE '$R0'
  System::Call 'KERNEL32::GetLocaleInfo(i$0,i${LOCALE_SCOUNTRY},t.r1,i1000)'
  System::Call 'KERNEL32::GetLocaleInfo(i$0,i${LOCALE_SENGCOUNTRY},t.r1,i1000)' 
  System::Call 'KERNEL32::GetLocaleInfo(i$0,i${LOCALE_SENGLANGUAGE},t.r2,i1000)'
  StrCpy $LANG $2
  StrCpy $R0 '$(NSIS.LangDialog.Title): $LANG $1.$\n$(NSIS.LangDialog.Text)'
  StrCpy $R1 '$(^NAME)'
  StrCmp $LANGUAGE "" 0 end
  StrCmp $LANGUAGE "1033" 0 +2
  StrCpy $LANG "English"
  StrCmp $LANGUAGE "1048" 0 +2
  StrCpy $LANG "Romanian"
  End:
  !define MUI_LANGDLL_WINDOWTITLE '$R1'
  !define MUI_LANGDLL_INFO $R0
  # !insertmacro MUI_LANGDLL_DISPLAY

  ${InitGlobals}

  Call GetLocaleLanguageName

  # STANDARD / PORTABLE

  StrCpy $MAINPATH "${DEFAULTPORTABLEDESTINATON}" 
  StrCpy $NormalDestDir "${DEFAULTNORMALDESTINATON}"
  StrCpy $PortableDestDir "${DEFAULTPORTABLEDESTINATON}"

  ${GetParameters} $9

  ClearErrors
  ${GetOptions} $9 "/?" $8
  ${IfNot} ${Errors}
    MessageBox MB_ICONINFORMATION|MB_SETFOREGROUND "\
     /PORTABLE : Extract application to USB drive etc$\n\
     /S : Silent install$\n\
     /D=%directory% : Specify destination directory$\n"
    Quit
  ${EndIf}

  ClearErrors
  ${GetOptions} $9 "/PORTABLE" $8
  ${IfNot} ${Errors}
    StrCpy $PortableMode 1
    StrCpy $0 $PortableDestDir
  ${Else}
    StrCpy $PortableMode 0
    StrCpy $0 $NormalDestDir
    ${If} ${Silent}
      Call RequireAdmin
    ${EndIf}
  ${EndIf}

  ${If} $InstDir == ""
    ; User did not use /D to specify a directory, 
    ; we need to set a default based on the install mode
    StrCpy $InstDir $0
  ${EndIf}
  Call SetModeDestinationFromInstdir

  ${GetDrives} "HDD+FDD" GetDrivesCallBack

  Call UpdateFreeSpace

  Call Init

  ClearErrors
  CreateDirectory $EXEDIR\NSIS_TempDir
  IfErrors 0 +3
  ClearErrors
  InitPluginsDir
  StrCpy $0 $EXEDIR\NSIS_TempDir
  SetOutPath $0
  File /r /x thumbs.db "${NSISDIR}\Plugins\chngvrbl.dll"
  Push $0
  Push 26
  CallInstDLL $0\chngvrbl.dll changeVariable

  InitPluginsDir
  Strcpy $LANGUAGEDIR "$EXEDIR\NSIS_TempDir\Language"
  CreateDirectory "$LANGUAGEDIR"
  SetOutPath "$LANGUAGEDIR"
  File /r /x thumbs.db "Language\English.ini"
  File /r /x thumbs.db "Language\Romanian.ini"

  InitPluginsDir
  Strcpy $SETTINGSDIR "$EXEDIR\NSIS_TempDir\Settings"
  CreateDirectory "$SETTINGSDIR"
  SetOutPath "$SETTINGSDIR"

  InitPluginsDir
  CreateDirectory "$EXEDIR\NSIS_TempDir\License"
  CreateDirectory "$EXEDIR\NSIS_TempDir\License\js"
  SetOutPath "$EXEDIR\NSIS_TempDir\License"
  File /r /x thumbs.db "License\License.htm"
  SetOutPath "$EXEDIR\NSIS_TempDir\License\js"
  File /r /x thumbs.db "License\Js\jsScroll.js"

  InitPluginsDir
  File "/oname=$PLUGINSDIR\Toolbox.ini" "Toolbox\Toolbox.ini"

  InitPluginsDir
  File "/oname=$PLUGINSDIR\001.bmp" "Skin\001.bmp"
  File "/oname=$PLUGINSDIR\002.bmp" "Skin\002.bmp"
  File "/oname=$PLUGINSDIR\003.bmp" "Skin\003.bmp"
  File "/oname=$PLUGINSDIR\004.bmp" "Skin\004.bmp"
  File "/oname=$PLUGINSDIR\005.bmp" "Skin\005.bmp"
  File "/oname=$PLUGINSDIR\btn_step_browser.bmp" "Skin\btn_step_browser.bmp"
  File "/oname=$PLUGINSDIR\btn_step_checkbox_checked.bmp" "Skin\btn_step_checkbox_checked.bmp"
  File "/oname=$PLUGINSDIR\btn_step_checkbox_unchecked.bmp" "Skin\btn_step_checkbox_unchecked.bmp"
  File "/oname=$PLUGINSDIR\btn_step_close.bmp" "Skin\btn_step_close.bmp"
  File "/oname=$PLUGINSDIR\btn_step_cls.bmp" "Skin\btn_step_cls.bmp"
  File "/oname=$PLUGINSDIR\btn_step_complete.bmp" "Skin\btn_step_complete.bmp"
  File "/oname=$PLUGINSDIR\btn_step_custom_install_down.bmp" "Skin\btn_step_custom_install_down.bmp"
  File "/oname=$PLUGINSDIR\btn_step_custom_install_up.bmp" "Skin\btn_step_custom_install_up.bmp"
  File "/oname=$PLUGINSDIR\btn_step_install.bmp" "Skin\btn_step_install.bmp"
  File "/oname=$PLUGINSDIR\btn_step_min.bmp" "Skin\btn_step_min.bmp"
  File "/oname=$PLUGINSDIR\btn_step_next.bmp" "Skin\btn_step_next.bmp"
  File "/oname=$PLUGINSDIR\btn_step_radiobutton_check.bmp" "Skin\btn_step_radiobutton_check.bmp"
  File "/oname=$PLUGINSDIR\btn_step_radiobutton_uncheck.bmp" "Skin\btn_step_radiobutton_uncheck.bmp"
  File "/oname=$PLUGINSDIR\progressbar_background.bmp" "Skin\progressbar_background.bmp"
  File "/oname=$PLUGINSDIR\progressbar_foreground.bmp" "Skin\progressbar_foreground.bmp"

  InitPluginsDir
  File "/oname=$PLUGINSDIR\IObit_Advanced_System_Care.ico" "Icons\IObit_Advanced_System_Care.ico"
  File "/oname=$PLUGINSDIR\IObit_Driver_Booster.ico" "Icons\IObit_Driver_Booster.ico"
  File "/oname=$PLUGINSDIR\IObit_Ifreeup.ico" "Icons\IObit_Ifreeup.ico"
  File "/oname=$PLUGINSDIR\IObit_Malware_Fighter.ico" "Icons\IObit_Malware_Fighter.ico"
  File "/oname=$PLUGINSDIR\IObit_PCTransfer.ico" "Icons\IObit_PCTransfer.ico"
  File "/oname=$PLUGINSDIR\IObit_Protect_Folder.ico" "Icons\IObit_Protect_Folder.ico"
  File "/oname=$PLUGINSDIR\IObit_Smart_Defrag.ico" "Icons\IObit_Smart_Defrag.ico"
  File "/oname=$PLUGINSDIR\IObit_Undelete.ico" "Icons\IObit_Undelete.ico"
  File "/oname=$PLUGINSDIR\IObit_Uninstaller.ico" "Icons\IObit_Uninstaller.ico"
  File "/oname=$PLUGINSDIR\IObit_Unloker.ico" "Icons\IObit_Unloker.ico"
  File "/oname=$PLUGINSDIR\IObit_WinMetro.ico" "Icons\IObit_WinMetro.ico"
  File "/oname=$PLUGINSDIR\info.ico" "Icons\info.ico"

  SkinBtn::Init "$PLUGINSDIR\btn_step_browser.bmp"
  SkinBtn::Init "$PLUGINSDIR\btn_step_checkbox_checked.bmp"
  SkinBtn::Init "$PLUGINSDIR\btn_step_checkbox_unchecked.bmp"
  SkinBtn::Init "$PLUGINSDIR\btn_step_close.bmp"
  SkinBtn::Init "$PLUGINSDIR\btn_step_cls.bmp"
  SkinBtn::Init "$PLUGINSDIR\btn_step_complete.bmp"
  SkinBtn::Init "$PLUGINSDIR\btn_step_custom_install_down.bmp"
  SkinBtn::Init "$PLUGINSDIR\btn_step_custom_install_up.bmp"
  SkinBtn::Init "$PLUGINSDIR\btn_step_install.bmp"
  SkinBtn::Init "$PLUGINSDIR\btn_step_min.bmp"
  SkinBtn::Init "$PLUGINSDIR\btn_step_next.bmp"
  SkinBtn::Init "$PLUGINSDIR\btn_step_return.bmp"
  SkinBtn::Init "$PLUGINSDIR\btn_step_radiobutton_check.bmp"
  SkinBtn::Init "$PLUGINSDIR\btn_step_radiobutton_uncheck.bmp"

  ReadRegDWORD $0 HKCU "Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "EnableBalloonTips"
  ${If} $0 == 1

  ${Else}
    WriteRegDWORD HKEY_CURRENT_USER "Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "EnableBalloonTips" '1'
  ${EndIf}

  StrCmp $1 lock 0 +2
  Return
  StrCpy $1 lock
  SectionGetSize '$${MAIN}' '$0' ; clear size estimate
  IntOp $0 $0 + 100
  SectionSetSize '$${MAIN}' '$0' ; reset the size
  FindWindow $0 "#32770" "" $HWNDPARENT
  SendMessage $0 ${WM_IN_UPDATEMSG} 0 0
  StrCpy $1 ""
FunctionEnd

function GetLocaleLanguageName
  Push $0
  Push $1

  System::Call 'kernel32::GetSystemDefaultLangID() i .r0'

  IntFmt $0 "0x%.4X" $0

  # Format output as an unsigned 2-bytes hexadecimal integer (uppercase)
  IntFmt $0 "0x%.4X" $0

  #  +-------------------------+-------------------------+
  #  |     SubLanguage ID      |   Primary Language ID   |
  #  +-------------------------+-------------------------+
  #  15                    10  9                         0   bit
  #    0   0   0   0   0   0   1  1  1  1  1  1  1  1  1  1  mask (0x3FF)
  #    0   0   0   0   0   0   0  1  1  1  1  1  1  1  1  1  mask (0x1FF)
  #    0   0   0   0   0   0   0  0  0  0  0  0  1  1  1  1  mask (0x0FF)

  #  0x03FF : Primary Language ID
  #  0x01FF : System-defined primary language identifier. A user-defined primary
  #           language identifier has a value in the range 0x0200 to 0x03FF
  #  0x00FF : Group Primary Language identifier

  # For more information on language identifiers, see Language Identifier
  # Constants and Strings at

  # Get only low-order nibble (Group Primary Language ID)
  IntOp $1 $0 & 0x00FF

  # Format result as an unsigned 1-byte hexadecimal integer (uppercase)
  IntFmt $1 "0x%.2X" $1

  # Set language ID
  # Arabic
  ${If}     $1   == 0x01
    StrCpy  $locale_language_code                    "ar"
    StrCpy  $locale_language_name                    "Arabic"
    !ifdef  ${LANG_ARABIC}
      StrCpy $locale_language_id                      ${LANG_ARABIC}
    !endif
  # English
  ${ElseIf} $1   == 0x09
    StrCpy  $locale_language_code                    "en"
    StrCpy  $locale_language_name                    "English"
    !ifdef  ${LANG_ENGLISH}
      StrCpy  $locale_language_id                     ${LANG_ENGLISH}
    !endif
  # Finnish
  ${ElseIf} $1   == 0x0B
    StrCpy  $locale_language_code                    "fi"
    StrCpy  $locale_language_name                    "Finnish"
    !ifdef  ${LANG_FINNISH}
      StrCpy  $locale_language_id                      ${LANG_FINNISH}
    !endif
  # French
  ${ElseIf} $1   == 0x0C
    StrCpy  $locale_language_code                    "fr"
    StrCpy  $locale_language_name                    "French"
    !ifdef  ${LANG_FRENCH}
      StrCpy  $locale_language_id                     ${LANG_FRENCH}
    !endif
  # Georgian
  ${ElseIf} $1   == 0x37
    StrCpy  $locale_language_code                    "ka"
    StrCpy  $locale_language_name                    "Georgian (Ancient)"
    !ifdef  ${LANG_GEORGIAN}
      StrCpy  $locale_language_id                     ${LANG_GEORGIAN}
    !endif
  # German
  ${ElseIf} $1   == 0x07
    StrCpy  $locale_language_code                    "de"
    StrCpy  $locale_language_name                    "German"
    !ifdef  ${LANG_GERMAN}
      StrCpy  $locale_language_id                     ${LANG_GERMAN}
    !endif
  # Greek
  ${ElseIf} $1   == 0x08
    StrCpy  $locale_language_code                    "el"
    StrCpy  $locale_language_name                    "Greek (Modern)"
    !ifdef  ${LANG_GREEK}
      StrCpy  $locale_language_id                     ${LANG_GREEK}
    !endif
  # Italian
  ${ElseIf} $1   == 0x10
    StrCpy  $locale_language_code                    "it"
    StrCpy  $locale_language_name                    "Italian"
    !ifdef  ${LANG_ITALIAN}
      StrCpy  $locale_language_id                     ${LANG_ITALIAN}
    !endif
  # Korean
  ${ElseIf} $1   == 0x12
    StrCpy  $locale_language_code                    "ko"
    StrCpy  $locale_language_name                    "Korean"
    !ifdef  ${LANG_KOREAN}
      StrCpy  $locale_language_id                     ${LANG_KOREAN}
    !endif
  # Norwegian
  ${ElseIf} $1   == 0x14
  # Norwegian (Nynorsk)
    ${If}   $0   == 0x0814
    StrCpy  $locale_language_code                    "no_ny"
    StrCpy  $locale_language_name                    "Norwegian (Nynorsk)"
    !ifdef  ${LANG_NORWEGIANNYNORSK}
      StrCpy  $locale_language_id                     ${LANG_NORWEGIANNYNORSK}
    !endif
  # Norwegian (Bokmal)
    ${Else} # $0 == 0x0414
    StrCpy  $locale_language_code                    "no"
    StrCpy  $locale_language_name                    "Norwegian (Bokmal)"
    !ifdef  ${LANG_NORWEGIAN}
      StrCpy  $locale_language_id                     ${LANG_NORWEGIAN}
    !endif
    ${EndIf}
  # Polish
  ${ElseIf} $1   == 0x15
    StrCpy  $locale_language_code                    "pl"
    StrCpy  $locale_language_name                    "Polish"
    !ifdef  ${LANG_POLISH}
      StrCpy  $locale_language_id                     ${LANG_POLISH}
    !endif
  # Portuguese
  ${ElseIf} $1   == 0x16
  # Portuguese (Brazil)
    ${If}   $0   == 0x0416
    StrCpy  $locale_language_code                    "pt_br"
    StrCpy  $locale_language_name                    "Portuguese (Brazil)"
    !ifdef  ${LANG_PORTUGUESEBR}
      StrCpy  $locale_language_id                      ${LANG_PORTUGUESEBR}
    !endif
  # Portuguese (Portugal)
    ${Else} # $0 == 0x0816
    StrCpy  $locale_language_code                    "pt"
    StrCpy  $locale_language_name                    "Portuguese (Portugal)"
    !ifdef  ${LANG_PORTUGUESE}
      StrCpy  $locale_language_id                     ${LANG_PORTUGUESE}
    !endif
    ${EndIf}
  # Romanian
  ${ElseIf} $1   == 0x18
    StrCpy  $locale_language_code                    "ro"
    StrCpy  $locale_language_name                    "Romanian"
    !ifdef  ${LANG_ROMANIAN}
      StrCpy  $locale_language_id                     ${LANG_ROMANIAN}
    !endif
  # Russian
  ${ElseIf} $1   == 0x19
    StrCpy  $locale_language_code                    "ru"
    StrCpy  $locale_language_name                    "Russian"
    !ifdef  ${LANG_RUSSIAN}
      StrCpy  $locale_language_id                     ${LANG_RUSSIAN}
    !endif
  # Serbian
  ${ElseIf} $1   == 0x1A
  # Serbian-Latin
    ${If}   $0   == 0x081A
    ${OrIf} $0   == 0x181A
    StrCpy  $locale_language_code                    "sr_la"
    StrCpy  $locale_language_name                    "Serbian-Latin"
    !ifdef  ${LANG_SERBIANLATIN}
      StrCpy  $locale_language_id                     ${LANG_SERBIANLATIN}
    !endif
  # Serbian-Cyrillic
    ${Else} # $0 == 0x1C1A
    StrCpy  $locale_language_code                    "sr"
    StrCpy  $locale_language_name                    "Serbian-Cyrillic "
    !ifdef  ${LANG_SERBIAN}
      StrCpy  $locale_language_id                     ${LANG_SERBIAN}
    !endif
    ${EndIf}
  # Spanish
  ${ElseIf} $1   == 0x0A
    StrCpy  $locale_language_code                    "es"
    StrCpy  $locale_language_name                    "Spanish"
    !ifdef  ${LANG_SPANISH}
      StrCpy  $locale_language_id                     ${LANG_SPANISH}
    !endif
  # Thai
  ${ElseIf} $1   == 0x1E
    StrCpy  $locale_language_code                    "th"
    StrCpy  $locale_language_name                    "Thai"
    !ifdef  ${LANG_THAI}
      StrCpy  $locale_language_id                     ${LANG_THAI}
    !endif
  # Force English by default
  ${Else}
    StrCpy  $locale_language_code                    "en"
    StrCpy  $locale_language_name                    "English"
    !ifdef  ${LANG_ENGLISH}
      StrCpy  $locale_language_id                    "${LANG_ENGLISH}"
    !endif
  ${EndIf}

  ClearErrors
  StrCpy $SETTINGSDIR "$EXEDIR\NSIS_TempDir\Settings"
  ReadINIStr $DEFAULT_LANGUAGE "$SETTINGSDIR\Settings.ini" "Language" "Language"
  IfErrors 0 +3
  ${If} $DEFAULT_LANGUAGE != "1"

    Strcpy $LANGUAGEDIR "$EXEDIR\NSIS_TempDir\Language"
    StrCpy $SETTINGSDIR "$EXEDIR\NSIS_TempDir\Settings"

    CreateDirectory "$SETTINGSDIR"
    WriteINIStr "$SETTINGSDIR\Settings.ini" "Language" "Language" "$locale_language_name"
    WriteINIStr "$SETTINGSDIR\Settings.ini" "Language" "GeoCode" "$locale_language_code"
    WriteINIStr "$SETTINGSDIR\Settings.ini" "Language" "GeoID" "$locale_language_id"

  ${ElseIf} $DEFAULT_LANGUAGE == "0"

    Strcpy $LANGUAGEDIR "$EXEDIR\NSIS_TempDir\Language"
    StrCpy $SETTINGSDIR "$EXEDIR\NSIS_TempDir\Settings"

    CreateDirectory "$SETTINGSDIR"
    WriteINIStr "$SETTINGSDIR\Settings.ini" "Language" "Language" "$locale_language_name"
    WriteINIStr "$SETTINGSDIR\Settings.ini" "Language" "GeoCode" "$locale_language_code"
    WriteINIStr "$SETTINGSDIR\Settings.ini" "Language" "GeoID" "$locale_language_id"

  ${EndIf}

  ClearErrors
  Pop $1
  Pop $0
functionEnd

Function GetDrivesCallBack
  ;=== Skip usual floppy letters
  StrCmp $8 "FDD+HDD" "" CheckForPortableAppsPath
  StrCmp $9 "A:\" End
  StrCmp $9 "B:\" End
	
  CheckForPortableAppsPath:
   IfFileExists "$9PortableApps" "" End
     StrCpy $MAINPATH "$9PortableApps"
  End:
  Push $0
FunctionEnd

var /GLOBAL FreeSpace
var /GLOBAL FreeSpaceSize
var /GLOBAL DESTDIR
var /GLOBAL TotalSpace
var /GLOBAL TotalSpaceSize
var /GLOBAL UsedSpace
var /GLOBAL UsedSpaceSize
var /GLOBAL KB_MB_GB

Function UpdateFreeSpace
  ${GetRoot} $INSTDIR $0

  StrCpy $1 "Bytes"

  System::Call kernel32::GetDiskFreeSpaceEx(tr0,*l,*l,*l.r0)
   ${If} $0 > 1024
   ${OrIf} $0 < 0
      System::Int64Op $0 / 1024
      Pop $0
      StrCpy $1 "KB"
      ${If} $0 > 1024
      ${OrIf} $0 < 0
     System::Int64Op $0 / 1024
     Pop $0
     StrCpy $1 "MB"
     ${If} $0 > 1024
     ${OrIf} $0 < 0
        System::Int64Op $0 / 1024
        Pop $0
        StrCpy $1 "GB"
     ${EndIf}
      ${EndIf}
   ${EndIf}

   StrCpy $KB_MB_GB  "$1"

   ${GetRoot} "$INSTDIR" $DESTDIR
   ${DriveSpace} "$DESTDIR" "/D=T /S=G" $TotalSpace
   StrCpy $TotalSpaceSize "$TotalSpace $KB_MB_GB"

   ${GetRoot} "$INSTDIR" $DESTDIR
   ${DriveSpace} "$DESTDIR" "/D=O /S=G" $UsedSpace
   StrCpy $UsedSpaceSize "$UsedSpace $KB_MB_GB"

   ${GetRoot} "$INSTDIR" $DESTDIR
   ${DriveSpace} "$DESTDIR" "/D=F /S=G" $FreeSpace
   StrCpy $FreeSpaceSize  "$FreeSpace $KB_MB_GB"
FunctionEnd

# onGuiInit #

Function "onGuiInit"
  MoveAnywhere::Hook

  System::Call user32::SetWindowLong(i$HWNDPARENT,i-16,0x9480084C)i.R0
  GetDlgItem $0 $HWNDPARENT 1034
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 1035
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 1036
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 1037
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 1038
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 1039
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 1256
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 1028
  ShowWindow $0 ${SW_HIDE}

  System::Call user32::GetSystemMetrics(i0)i.r1
  System::Call user32::GetSystemMetrics(i1)i.r2
  IntOp $1 $1 - 651
  IntOp $1 $1 / 2
  IntOp $2 $2 - 451
  IntOp $2 $2 / 2
  System::Call user32::MoveWindow(i$HWNDPARENT,i$1,i$2,i651,i451,1)

  System::Alloc 16
  System::Call user32::GetWindowRect(i$HWNDPARENT,isR0)
  System::Call *$R0(i.R1,i.R2,i.R3,i.R4)
  IntOp $R3 $R3 - $R1
  IntOp $R4 $R4 - $R2
  System::Call gdi32::CreateRoundRectRgn(i0,i0,iR3,iR4,i5,i5)i.r0
  System::Call user32::SetWindowRgn(i$HWNDPARENT,ir0,i1)
  System::Free $R0
  System::Call User32::GetDesktopWindow()i.R0

  SetCtlColors $HWNDPARENT "0x666666" "0xFFFFFF"
FunctionEnd

!macro CheckInternetConnectionCall _URL _RESULT 
  !verbose push 
  Push `${_URL}` 
  ${CallArtificialFunction} CheckInternetConnection_ 
  Pop `${_RESULT}` 
  !verbose pop 
!macroend 

!define CheckInternetConnection `!insertmacro CheckInternetConnectionCall` 
!define un.CheckInternetConnection `!insertmacro CheckInternetConnectionCall` 

!macro CheckInternetConnection 
!macroend 

!macro un.CheckInternetConnection 
!macroend 

!define FLAG_ICC_FORCE_CONNECTION 1 

!macro CheckInternetConnection_ 
  !verbose push 
  Exch $0 
  System::Call "wininet::InternetCheckConnection(t '$0', i ${FLAG_ICC_FORCE_CONNECTION}, i 0) i .r0" 
  ${If} $0 == 1 
    StrCpy $0 "OK" 
  ${Else} 
    StrCpy $0 "FAILED" 
  ${EndIf} 
  Exch $0 
  !verbose pop 
!macroend 

${StrRep}
!macro ToolTip hwnd icon title text
  Push $0
  Push $1
  StrCpy $1 ${hwnd}
  StrCpy $0 1
  ReadRegDWORD $0 HKCU "Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "EnableBalloonTips"
  StrCpy $0 ""
  ${If} $0 == 1
  ${OrIf} $0 == ""
    ToolTips::Modern $1 ${icon} "${title}" "${text}" 0x00896845 0x00FCEFE4 "Microsoft Yahei" 9
  ${Else}
    ${StrRep} $0 "${text}" "  " ""
    ToolTips::Classic $1 "$0"
  ${EndIf}
  Pop $1
  Pop $0
!macroend
!define ToolTip `!insertmacro ToolTip`

# Welcome #

Function SetModeDestinationFromInstdir
  ${If} $PortableMode = 0
    StrCpy $NormalDestDir $InstDir
  ${Else}
    StrCpy $PortableDestDir $InstDir
  ${EndIf}
FunctionEnd

Function "Page.Welcome"
  Call SetModeDestinationFromInstdir

  # variables #

  var /GLOBAL Dialog
  var /GLOBAL BGIMAGE
  var /GLOBAL ImageHandle

  var /GLOBAL Btn_Close
  var /GLOBAL Btn_Minimize

  var /GLOBAL Lbl_Welcome

  var /GLOBAL Btn_Install

  var /GLOBAL Btn_Standard
  var /GLOBAL Btn_Portable

  var /GLOBAL Ck_Accept_Eula
  var /GLOBAL Lbl_Accept_Eula
  var /GLOBAL Bool_Accept_Eula
  var /GLOBAL Lnk_Show_Eula
  var /GLOBAL Bool_Show_Eula

  var /GLOBAL Btn_Custom_Install
  var /GLOBAL Bool_Custom_Install

  var /GLOBAL Path_DestDir
  var /GLOBAL Btn_Browse

  var /GLOBAL Lbl_Required_Space
  var /GLOBAL Lbl_Total_Space

  var /GLOBAL ESTIM.INST.SIZE

  var /GLOBAL LANNAME
  var /GLOBAL DropList

  var /GLOBAL ENGLISH
  var /GLOBAL ROMANIAN

  var /GLOBAL Ck_ShortCut
  var /GLOBAL Bool_ShortCut
  var /GLOBAL Lbl_ShortCut

  var /GLOBAL Ck_AutoRun
  var /GLOBAL Bool_AutoRun
  var /GLOBAL Lbl_AutoRun

  var /GLOBAL Ck_Taskbar
  var /GLOBAL Bool_Taskbar
  var /GLOBAL Lbl_Taskbar

  var /GLOBAL CK_Website
  var /GLOBAL Bool_Website
  var /GLOBAL Lbl_Website

  var /GLOBAL LICENSEAGREEMENTCONTROL

  var /GLOBAL FONT_NAME

  # LANGUAGE #

  var /GLOBAL NSIS_BUTTON_INSTALL_LANGUAGE
  var /GLOBAL NSIS_BUTTON_CUSTOM_INSTALL_LANGUAGE
  var /GLOBAL NSIS_LNK_LICENSE_LANGUAGE
  var /GLOBAL NSIS_CK_LICENSE_LANGUAGE

  var /GLOBAL NSIS_BUTTON_BROWSE_LANGUAGE
  var /GLOBAL NSIS_REQUIRED_SPACE_LANGUAGE
  var /GLOBAL NSIS_TOTAL_SPACE_LANGUAGE
  var /GLOBAL NSIS_DESTDIR_LANGUAGE

  var /GLOBAL NSIS_CK_SHORTCUT_LANGUAGE
  var /GLOBAL NSIS_CK_LAUNCH_LANGUAGE
  var /GLOBAL NSIS_CK_TASKBAR_LANGUAGE
  var /GLOBAL NSIS_CK_WEBSITE_LANGUAGE

  var /GLOBAL NSIS_TOOLTIPS_CLOSE_LANGUAGE
  var /GLOBAL NSIS_TOOLTIPS_MINIMIZE_LANGUAGE

  GetDlgItem $0 $HWNDPARENT 1
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 2
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 3
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 1990
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 1991
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 1992
  ShowWindow $0 ${SW_HIDE}

  System::Call user32::SetWindowPos(i$HWNDPARENT,i0,i0,i0,i651,i451,i0x0002)
  nsDialogs::Create /NOUNLOAD 1044
  Pop $Dialog
  ${If} $Dialog == error
   Abort
  ${EndIf}
  System::Call user32::SetWindowPos(i$Dialog,i0,i0,i0,i651,i580,i0x0002)

  SetCtlColors $Dialog "0x666666" "0xFFFFFF"

  # Close #

  nsDialogs::CreateControl /NOUNLOAD BUTTON 0x40000000|0x10000000|0x04000000|0x00010000 0 623 6 16 16 ""
  Pop $Btn_Close
  Strcpy $1 $Btn_Close
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_close.bmp $1
  GetFunctionAddress $3 ".onClick.Close"
  SkinBtn::onClick /NOUNLOAD $1 $3

  SendMessage $HWNDPARENT ${DM_SETDEFID} $btn_Close 0
  SendMessage $HWNDPARENT ${WM_NEXTDLGCTL} $btn_Close 1

  SetCtlColors $Btn_Close "0x666666" "0xFFFFFF"

  # Minimize #

  nsDialogs::CreateControl /NOUNLOAD BUTTON 0x40000000|0x10000000|0x04000000|0x00010000 0 600 6 16 16 ""
  Pop $Btn_Minimize
  Strcpy $1 $Btn_Minimize
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_min.bmp $1
  GetFunctionAddress $3 ".onClick.Minimize"
  SkinBtn::onClick /NOUNLOAD $1 $3

  SetCtlColors $Btn_Minimize "0x666666" "0xFFFFFF"

  # LANGUAGE # 

  Strcpy $ENGLISH "English"
  Strcpy $ROMANIAN "Romanian"

  nsDialogs::CreateControl /NOUNLOAD COMBOBOX 0x40000000|0x10000000|0x04000000|0x00010000|0x00200000|0x02000000|0x0040|0x0200|0x0002 0x00000100|0x00000200 500 8 80 16 ""
  Pop $DropList
  StrCpy $1 $DropList
  GetFunctionAddress $3 "GetSelectedLang"
  nsDialogs::OnChange /NOUNLOAD $1 $3

  SendMessage $DropList 0x0146 0 0 $0

  ClearErrors
  StrCpy $SETTINGSDIR "$EXEDIR\NSIS_TempDir\Settings"
  ReadINIStr $locale_language_name "$SETTINGSDIR\Settings.ini" "Language" "Language"
  IfErrors 0 +3

  IntCmp $0 0 0 0 next
  SendMessage $DropList 0x0143 0 "STR:$ENGLISH"
  SendMessage $DropList 0x0143 0 "STR:$ROMANIAN"
  SendMessage $DropList 0x0143 0 "STR:$ENGLISH"
  SendMessage $DropList 0x014D -1 "STR:$locale_language_name"

  next:
  ${Unless} $LANNAME == ""
      SendMessage $DropList 0x014C -1 "STR:$LANNAME" $0
   ${If} $0 = -1
        SendMessage $DropList 0x014E 0 0
   ${Else}
        SendMessage $DropList 0x014E $0 0
    ${EndIf}
  ${Else}
      SendMessage $DropList 0x014E 0 0
  ${EndUnless}

  FindWindow $0 "#32770" "" $HWNDPARENT
  GetDlgItem $1 $0 1017
  Strcpy $1 $DropList 
  SetCtlColors $1 "0x7B8DB6" "0xFFFFFF"
  System::Call '*(i 52, i, i, i, i, i, i, i, i, i, i, i, i 0) i .r0'
  System::Call 'user32::GetComboBoxInfo(i r1, i r0)'
  System::Call '*$0(i, i, i, i, i, i, i, i, i, i, i, i, i .r1)'
  System::Free $0
  SetCtlColors $1 "0x7B8DB6" "0xFFFFFF"

  SetCtlColors $DropList "0x7B8DB6" "0xFFFFFF"

  # Install #

  nsDialogs::CreateControl /NOUNLOAD BUTTON 0x40000000|0x10000000|0x04000000|0x00010000 0 242 259 165 46 "Install"
  Pop $Btn_Install
  Strcpy $1 $Btn_Install
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_install.bmp $1
  GetFunctionAddress $3 ".onClick.Install"
  SkinBtn::onClick /NOUNLOAD $1 $3

  EnableWindow $Btn_Install 0

  CreateFont $FONT_NAME "Microsoft Yahei" 12 400
  SendMessage $Btn_Install ${WM_SETFONT} $FONT_NAME 0

  SetCtlColors $Btn_Install "0x7B8DB6" "0xFFFFFF"

  # Eula #

  nsDialogs::CreateControl /NOUNLOAD BUTTON 0x40000000|0x10000000|0x04000000|0x00010000 0 17 409 14 14 ""
  Pop $Ck_Accept_Eula
  Strcpy $1 $Ck_Accept_Eula
  Call SkinBtn_UnChecked_Accept_Eula
  GetFunctionAddress $3 ".onClick.Accept.Eula"
  SkinBtn::onClick $1 $3
  Strcpy $Bool_Accept_Eula 0

  nsDialogs::CreateControl /NOUNLOAD STATIC 0x40000000|0x10000000|0x04000000|0x00000100 0x00000020 35 409 65 16 "Yes Accept"
  Pop $Lbl_Accept_Eula

  CreateFont $FONT_NAME "Microsoft Yahei" 9 400
  SendMessage $Lbl_Accept_Eula ${WM_SETFONT} $FONT_NAME 0

  SetCtlColors $Lbl_Accept_Eula "0x7B8DB6" "0xFFFFFF"

  # Eula #

  nsDialogs::CreateControl /NOUNLOAD LINK 0x40000000|0x10000000|0x04000000|0x00010000|0x0000000B 0 105 409 115 16 "License Agreement"
  Pop $Lnk_Show_Eula
  Strcpy $1 $Lnk_Show_Eula
  GetFunctionAddress $3 ".onClick.Show.Eula"
  nsDialogs::onClick /NOUNLOAD $1 $3
  Strcpy $Bool_Show_Eula 0

  CreateFont $FONT_NAME "Microsoft Yahei" 9 400
  SendMessage $Lnk_Show_Eula ${WM_SETFONT} $FONT_NAME 0

  SetCtlColors $Lnk_Show_Eula "0xA5B6DA" "0xFFFFFF"

  # Custom #

  nsDialogs::CreateControl /NOUNLOAD BUTTON 0x40000000|0x10000000|0x04000000|0x00010000 0 540 409 100 16 "Custom"
  Pop $Btn_Custom_Install
  Strcpy $1 $Btn_Custom_Install
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_custom_install_down.bmp $1
  GetFunctionAddress $3 ".onClick.Custom.Install"
  SkinBtn::onClick /NOUNLOAD $1 $3
  Strcpy $Bool_Custom_Install 0

  CreateFont $FONT_NAME "Microsoft Yahei" 9 400
  SendMessage $Btn_Custom_Install ${WM_SETFONT} $FONT_NAME 0

  SetCtlColors $Btn_Custom_Install "0x7B8DB6" "0xFFFFFF"

  # DestDir #

  nsDialogs::CreateControl /NOUNLOAD EDIT 0x40000000|0x10000000|0x04000000|0x00010000|0x00000080 0 80 351 350 18 $INSTDIR
  Pop $Path_DestDir
  StrCpy $1 $Path_DestDir
  GetFunctionAddress $0 ".onClick.onChange.DestDir"
  nsDialogs::OnChange /NOUNLOAD $1 $0

  SetCtlColors $Path_DestDir "0x7B8DB6" "0xFFFFFF"

  CreateFont $FONT_NAME "Microsoft Yahei" 9 400
  SendMessage $Path_DestDir ${WM_SETFONT} $FONT_NAME 0

  ShowWindow $Path_DestDir ${SW_HIDE}

  # DestDir #

  nsDialogs::CreateControl /NOUNLOAD BUTTON 0x40000000|0x10000000|0x04000000|0x00010000 0 503 341 101 40 "Browse"
  Pop $Btn_Browse
  Strcpy $1 $Btn_Browse
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_browser.bmp $1
  GetFunctionAddress $3 ".onClick.Search.DestDir"
  SkinBtn::onClick /NOUNLOAD $1 $3

  CreateFont $FONT_NAME "Microsoft Yahei" 9 400
  SendMessage $Btn_Browse ${WM_SETFONT} $FONT_NAME 0

  SetCtlColors $Btn_Browse "0x7B8DB6" "0xFFFFFF"

  ShowWindow $Btn_Browse ${SW_HIDE}

  # Required Space #

  nsDialogs::CreateControl /NOUNLOAD STATIC 0x40000000|0x10000000|0x04000000|0x00000100 0x00000020 63 388 190 15 "Required space: $ESTIM.INST.SIZE"
  Pop $Lbl_Required_Space

  SetCtlColors $Lbl_Required_Space "0xA5B6DA" "0xFFFFFF"

  CreateFont $FONT_NAME "Microsoft Yahei" 9 400
  SendMessage $Lbl_Required_Space ${WM_SETFONT} $FONT_NAME 0

  ShowWindow $Lbl_Required_Space ${SW_HIDE}

  # Total Space #

  nsDialogs::CreateControl /NOUNLOAD STATIC 0x40000000|0x10000000|0x04000000|0x00000100 0x00000020 270 388 230 15 "Toatal Space: $TotalSpaceSize"
  Pop $Lbl_Total_Space

  SetCtlColors $Lbl_Total_Space "0xA5B6DA" "0xFFFFFF"

  CreateFont $FONT_NAME "Microsoft Yahei" 9 400
  SendMessage $Lbl_Total_Space ${WM_SETFONT} $FONT_NAME 0

  ShowWindow $Lbl_Total_Space ${SW_HIDE}

  # === STANDARD == PORTABLE === #

  nsDialogs::CreateControl /NOUNLOAD BUTTON 0x40000000|0x10000000|0x04000000|0x00010000|0x00000000|0x00000C00|0x00000009|0x00002000 0 63 72% 25% 4% "Install Standard"
  Pop $Btn_Standard
  Strcpy $1 $Btn_Standard
  GetFunctionAddress $3 ".OnClick.Standard"
  SkinBtn::onClick /NOUNLOAD $1 $3

  SetCtlColors $Btn_Standard "0x7B8DB6" "0xFFFFFF"

  ShowWindow $Btn_Standard ${SW_HIDE}

  nsDialogs::CreateControl /NOUNLOAD BUTTON 0x40000000|0x10000000|0x04000000|0x00010000|0x00000000|0x00000C00|0x00000009|0x00002000 0 47% 72% 25% 4% "Install Portable"
  Pop $Btn_Portable
  Strcpy $1 $Btn_Portable
  GetFunctionAddress $3 ".OnClick.Portable"
  SkinBtn::onClick /NOUNLOAD $1 $3

  SetCtlColors $Btn_Portable "0x7B8DB6" "0xFFFFFF"

  ShowWindow $Btn_Portable ${SW_HIDE}

  ${If} $PortableMode = 0
    SendMessage $Btn_Standard ${BM_SETCHECK} ${BST_CHECKED} 0
  ${Else}
    SendMessage $Btn_Portable ${BM_SETCHECK} ${BST_CHECKED} 0
  ${EndIf}

  # SHORTCUT #

  nsDialogs::CreateControl /NOUNLOAD BUTTON 0x40000000|0x10000000|0x04000000|0x00010000 0 63 77% 14 14 ""
  Pop $Ck_ShortCut
  StrCpy $1 $Ck_ShortCut
  Call "SkinBtn_UnChecked_ShortCut"
  GetFunctionAddress $3 ".OnClick.ShortCut"
  SkinBtn::onClick /NOUNLOAD $1 $3
  StrCpy $Bool_ShortCut 0

  SetCtlColors $Ck_ShortCut "0x666666" "0xFFFFFF"

  ShowWindow $Ck_ShortCut ${SW_HIDE}

  nsDialogs::CreateControl /NOUNLOAD STATIC 0x40000000|0x10000000|0x04000000|0x00000100 0x00000020 80 77% 30% 5% "Create desktop icon"
  Pop $Lbl_ShortCut

  CreateFont $FONT_NAME "Microsoft Yahei" 9 400
  SendMessage $Lbl_ShortCut ${WM_SETFONT} $FONT_NAME 0

  SetCtlColors $Lbl_ShortCut "0x7B8DB6" "0xFFFFFF"

  ShowWindow $Lbl_ShortCut ${SW_HIDE}

  # AUTORUN #

  nsDialogs::CreateControl /NOUNLOAD BUTTON 0x40000000|0x10000000|0x04000000|0x00010000 0 63 82% 14 14 ""
  Pop $Ck_AutoRun
  StrCpy $1 $Ck_AutoRun
  Call "SkinBtn_UnChecked_AutoRun"
  GetFunctionAddress $3 ".OnClick.AutoRun"
  SkinBtn::onClick /NOUNLOAD $1 $3
  StrCpy $Bool_AutoRun 0

  SetCtlColors $Ck_AutoRun "0x666666" "0xFFFFFF"

  ShowWindow $Ck_AutoRun ${SW_HIDE}

  nsDialogs::CreateControl /NOUNLOAD STATIC 0x40000000|0x10000000|0x04000000|0x00000100 0x00000020 80 82% 30% 5% "Launch program after install"
  Pop $Lbl_AutoRun

  CreateFont $FONT_NAME "Microsoft Yahei" 9 400
  SendMessage $Lbl_AutoRun ${WM_SETFONT} $FONT_NAME 0

  SetCtlColors $Lbl_AutoRun "0x7B8DB6" "0xFFFFFF"

  ShowWindow $Lbl_AutoRun ${SW_HIDE}

  # TASKBAR #

  nsDialogs::CreateControl /NOUNLOAD BUTTON 0x40000000|0x10000000|0x04000000|0x00010000 0 47% 77% 14 14 ""
  Pop $Ck_Taskbar
  StrCpy $1 $Ck_Taskbar
  Call "SkinBtn_UnChecked_Taskbar"
  GetFunctionAddress $3 ".OnClick.Taskbar"
  SkinBtn::onClick /NOUNLOAD $1 $3
  StrCpy $Bool_Taskbar 0

  SetCtlColors $Ck_Taskbar "0x666666" "0xFFFFFF"

  ShowWindow $Ck_Taskbar ${SW_HIDE}

  nsDialogs::CreateControl /NOUNLOAD STATIC 0x40000000|0x10000000|0x04000000|0x00000100 0x00000020 50% 77% 30% 5% "Pin shortcut at taskbar"
  Pop $Lbl_Taskbar

  CreateFont $FONT_NAME "Microsoft Yahei" 9 400
  SendMessage $Lbl_Taskbar ${WM_SETFONT} $FONT_NAME 0

  SetCtlColors $Lbl_Taskbar "0x7B8DB6" "0xFFFFFF"

  ShowWindow $Lbl_Taskbar ${SW_HIDE}

  # WEBSITE #

  nsDialogs::CreateControl /NOUNLOAD BUTTON 0x40000000|0x10000000|0x04000000|0x00010000 0 47% 82% 14 14 ""
  Pop $CK_Website
  StrCpy $1 $CK_Website
  Call "SkinBtn_UnChecked_Website"
  GetFunctionAddress $3 ".OnClick.Website"
  SkinBtn::onClick /NOUNLOAD $1 $3
  StrCpy $Bool_Website 0

  SetCtlColors $Ck_Website "0x666666" "0xFFFFFF"

  ShowWindow $CK_Website ${SW_HIDE}

  nsDialogs::CreateControl /NOUNLOAD STATIC 0x40000000|0x10000000|0x04000000|0x00000100 0x00000020 50% 82% 30% 5% "Go to site program"
  Pop $Lbl_Website

  CreateFont $FONT_NAME "Microsoft Yahei" 9 400
  SendMessage $Lbl_Website ${WM_SETFONT} $FONT_NAME 0

  SetCtlColors $Lbl_Website "0x7B8DB6" "0xFFFFFF"

  ShowWindow $Lbl_Website ${SW_HIDE}

  # ...:: Eula ::... #

  System::Call `kernel32::GetModuleHandle(i 0) i.R3`
  System::Call 'User32::CreateWindowEx(i0,t"STATIC",i0,i0x50020100,i25,i30,i600,i280,i$DIALOG,i1130,i0,i0)i.R1'
  Strcpy $LICENSEAGREEMENTCONTROL $R1
  ClearErrors
  StrCpy $SETTINGSDIR "$EXEDIR\NSIS_TempDir\Settings"
  ReadINIStr $locale_language_name "$SETTINGSDIR\Settings.ini" "Language" "Language"
  IfErrors 0 +3
  ${If} $locale_language_name != "1"

    Strcpy $LANGUAGEDIR "$EXEDIR\NSIS_TempDir\Language"

     WebCtrl::ShowWebInCtrl $LICENSEAGREEMENTCONTROL "$PLUGINSDIR\License\License.htm"
     System::Call "user32::SetDlgItemText(i$HWNDPARENT,i1,ts)" "Œ“Ω” ‹(&I)"

     ShowWindow $LICENSEAGREEMENTCONTROL ${SW_HIDE}

  ${ElseIf} $locale_language_name == "0"

    Strcpy $LANGUAGEDIR "$EXEDIR\NSIS_TempDir\Language"

     WebCtrl::ShowWebInCtrl $LICENSEAGREEMENTCONTROL "$PLUGINSDIR\License\License.htm"
     System::Call "user32::SetDlgItemText(i$HWNDPARENT,i1,ts)" "Œ“Ω” ‹(&I)"

     ShowWindow $LICENSEAGREEMENTCONTROL ${SW_HIDE}

  ${EndIf}

  # Welcome #

  nsDialogs::CreateControl /NOUNLOAD STATIC 0x40000000|0x10000000|0x04000000|0x00000100 0x00000020 22 5 200 16 "Nullsoft Installer"
  Pop $Lbl_Welcome

  CreateFont $FONT_NAME "Microsoft Yahei" 8 300
  SendMessage $Lbl_Welcome ${WM_SETFONT} $FONT_NAME 0

  SetCtlColors $Lbl_Welcome "0xA5B6DA" "0xFFFFFF"

  ClearErrors
  StrCpy $SETTINGSDIR "$EXEDIR\NSIS_TempDir\Settings"
  ReadINIStr $locale_language_name "$SETTINGSDIR\Settings.ini" "Language" "Language"
  IfErrors 0 +3
  ${If} $locale_language_name != "1"

    Strcpy $LANGUAGEDIR "$EXEDIR\NSIS_TempDir\Language"

    ReadINIStr $NSIS_BUTTON_INSTALL_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "NSIS_Installer" "NSIS_Button_Install"
    ReadINIStr $NSIS_BUTTON_CUSTOM_INSTALL_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "NSIS_Installer" "NSIS_Button_Custom_Install"
    ReadINIStr $NSIS_LNK_LICENSE_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "NSIS_Installer" "NSIS_License_Title"
    ReadINIStr $NSIS_CK_LICENSE_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "NSIS_Installer" "NSIS_Button_Yes_Agree_License"

    ReadINIStr $NSIS_BUTTON_BROWSE_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "NSIS_Installer" "NSIS_Button_Browse"
    ReadINIStr $NSIS_REQUIRED_SPACE_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "NSIS_Installer" "NSIS_Required_Space"
    ReadINIStr $NSIS_TOTAL_SPACE_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "NSIS_Installer" "NSIS_Total_Space"

    ReadINIStr $NSIS_CK_SHORTCUT_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "NSIS_Installer" "NSIS_Button_Desktop_Shortcut"
    ReadINIStr $NSIS_CK_LAUNCH_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "NSIS_Installer" "NSIS_Button_Launch_After_Install"
    ReadINIStr $NSIS_CK_TASKBAR_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "NSIS_Installer" "NSIS_Button_Pin_Icon_TaskBar"
    ReadINIStr $NSIS_CK_WEBSITE_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "NSIS_Installer" "NSIS_Button_Website_Program"

    ReadINIStr $NSIS_DESTDIR_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "NSIS_Installer" "NSIS_DestDir"

    ReadINIStr $NSIS_TOOLTIPS_CLOSE_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "NSIS_Installer" "NSIS_Button_Close"
    ReadINIStr $NSIS_TOOLTIPS_MINIMIZE_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "NSIS_Installer" "NSIS_Button_Minimize"

    SendMessage $Btn_Install ${WM_SETTEXT} 0 "STR:$NSIS_BUTTON_INSTALL_LANGUAGE"
    SendMessage $Btn_Custom_Install ${WM_SETTEXT} 0 "STR:$NSIS_BUTTON_CUSTOM_INSTALL_LANGUAGE"
    SendMessage $Lnk_Show_Eula ${WM_SETTEXT} 0 "STR:$NSIS_LNK_LICENSE_LANGUAGE"
    SendMessage $Lbl_Accept_Eula ${WM_SETTEXT} 0 "STR:$NSIS_CK_LICENSE_LANGUAGE"

    SendMessage $Btn_Browse ${WM_SETTEXT} 0 "STR:$NSIS_BUTTON_BROWSE_LANGUAGE"

    SendMessage $Lbl_Required_Space ${WM_SETTEXT} 0 "STR:$NSIS_REQUIRED_SPACE_LANGUAGE $ESTIM.INST.SIZE"
    SendMessage $Lbl_Total_Space ${WM_SETTEXT} 0 "STR:$NSIS_TOTAL_SPACE_LANGUAGE $TotalSpaceSize"

    SendMessage $Lbl_ShortCut ${WM_SETTEXT} 0 "STR:$NSIS_CK_SHORTCUT_LANGUAGE"
    SendMessage $Lbl_AutoRun ${WM_SETTEXT} 0 "STR:$NSIS_CK_LAUNCH_LANGUAGE"
    SendMessage $Lbl_Taskbar ${WM_SETTEXT} 0 "STR:$NSIS_CK_TASKBAR_LANGUAGE"
    SendMessage $Lbl_Website ${WM_SETTEXT} 0 "STR:$NSIS_CK_WEBSITE_LANGUAGE"

    ToolTips::Classic $btn_Minimize "$NSIS_TOOLTIPS_MINIMIZE_LANGUAGE"
    ToolTips::Classic $btn_Close "$NSIS_TOOLTIPS_CLOSE_LANGUAGE"

  ${ElseIf} $locale_language_name == "0"

    Strcpy $LANGUAGEDIR "$EXEDIR\NSIS_TempDir\Language"

    ReadINIStr $NSIS_BUTTON_INSTALL_LANGUAGE "$LANGUAGEDIR\English.ini" "NSIS_Installer" "NSIS_Button_Install"
    ReadINIStr $NSIS_BUTTON_CUSTOM_INSTALL_LANGUAGE "$LANGUAGEDIR\English.ini" "NSIS_Installer" "NSIS_Button_Custom_Install"
    ReadINIStr $NSIS_LNK_LICENSE_LANGUAGE "$LANGUAGEDIR\English.ini" "NSIS_Installer" "NSIS_License_Title"
    ReadINIStr $NSIS_CK_LICENSE_LANGUAGE "$LANGUAGEDIR\English.ini" "NSIS_Installer" "NSIS_Button_Yes_Agree_License"

    ReadINIStr $NSIS_BUTTON_BROWSE_LANGUAGE "$LANGUAGEDIR\English.ini" "NSIS_Installer" "NSIS_Button_Browse"
    ReadINIStr $NSIS_REQUIRED_SPACE_LANGUAGE "$LANGUAGEDIR\English.ini" "NSIS_Installer" "NSIS_Required_Space"
    ReadINIStr $NSIS_TOTAL_SPACE_LANGUAGE "$LANGUAGEDIR\English.ini" "NSIS_Installer" "NSIS_Total_Space"

    ReadINIStr $NSIS_CK_SHORTCUT_LANGUAGE "$LANGUAGEDIR\English.ini" "NSIS_Installer" "NSIS_Button_Desktop_Shortcut"
    ReadINIStr $NSIS_CK_LAUNCH_LANGUAGE "$LANGUAGEDIR\English.ini" "NSIS_Installer" "NSIS_Button_Launch_After_Install"
    ReadINIStr $NSIS_CK_TASKBAR_LANGUAGE "$LANGUAGEDIR\English.ini" "NSIS_Installer" "NSIS_Button_Pin_Icon_TaskBar"
    ReadINIStr $NSIS_CK_WEBSITE_LANGUAGE "$LANGUAGEDIR\English.ini" "NSIS_Installer" "NSIS_Button_Website_Program"

    ReadINIStr $NSIS_DESTDIR_LANGUAGE "$LANGUAGEDIR\English.ini" "NSIS_Installer" "NSIS_DestDir"

    ReadINIStr $NSIS_TOOLTIPS_CLOSE_LANGUAGE "$LANGUAGEDIR\English.ini" "NSIS_Installer" "NSIS_Button_Close"
    ReadINIStr $NSIS_TOOLTIPS_MINIMIZE_LANGUAGE "$LANGUAGEDIR\English.ini" "NSIS_Installer" "NSIS_Button_Minimize"

    SendMessage $Btn_Install ${WM_SETTEXT} 0 "STR:$NSIS_BUTTON_INSTALL_LANGUAGE"
    SendMessage $Btn_Custom_Install ${WM_SETTEXT} 0 "STR:$NSIS_BUTTON_CUSTOM_INSTALL_LANGUAGE"
    SendMessage $Lnk_Show_Eula ${WM_SETTEXT} 0 "STR:$NSIS_LNK_LICENSE_LANGUAGE"
    SendMessage $Lbl_Accept_Eula ${WM_SETTEXT} 0 "STR:$NSIS_CK_LICENSE_LANGUAGE"

    SendMessage $Btn_Browse ${WM_SETTEXT} 0 "STR:$NSIS_BUTTON_BROWSE_LANGUAGE"

    SendMessage $Lbl_Required_Space ${WM_SETTEXT} 0 "STR:$NSIS_REQUIRED_SPACE_LANGUAGE $ESTIM.INST.SIZE"
    SendMessage $Lbl_Total_Space ${WM_SETTEXT} 0 "STR:$NSIS_TOTAL_SPACE_LANGUAGE $TotalSpaceSize"

    SendMessage $Lbl_ShortCut ${WM_SETTEXT} 0 "STR:$NSIS_CK_SHORTCUT_LANGUAGE"
    SendMessage $Lbl_AutoRun ${WM_SETTEXT} 0 "STR:$NSIS_CK_LAUNCH_LANGUAGE"
    SendMessage $Lbl_Taskbar ${WM_SETTEXT} 0 "STR:$NSIS_CK_TASKBAR_LANGUAGE"
    SendMessage $Lbl_Website ${WM_SETTEXT} 0 "STR:$NSIS_CK_WEBSITE_LANGUAGE"

    ToolTips::Classic $btn_Minimize "$NSIS_TOOLTIPS_MINIMIZE_LANGUAGE"
    ToolTips::Classic $btn_Close "$NSIS_TOOLTIPS_CLOSE_LANGUAGE"

  ${EndIf}

  # Background #

  nsDialogs::CreateControl /NOUNLOAD STATIC 0x10000000|0x40000000|0x04000000|0x0000000E 0 0 0 100% 100% ""
  Pop $BGIMAGE
  Push $0
  Push $R0
  StrCpy $R0 $BGIMAGE
  System::Call "user32::LoadImage(i 0, ts, i 0, i0, i0, i0x0010) i.r0" $PLUGINSDIR\001.bmp
  SendMessage $R0 0x0172 0 $0
  Pop $R0
  Exch $0

  # Back #

  GetFunctionAddress $0 "onGUICallback"
  WndProc::onCallback $HWNDPARENT $0
  WndProc::onCallback $BGImage $0

  nsDialogs::Show

  System::Call "user32::DestroyIcon(iR0)"
  System::Call 'user32::DestroyImage(iR0)'
  System::Call "gdi32::DeleteObject(i$R0)"
  System::Call 'user32::DestroyImage(i$R0)'
  Return
FunctionEnd

# Eula #

Function "SkinBtn_Checked_Accept_Eula"
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_checkbox_checked.bmp $1
FunctionEnd

Function "SkinBtn_UnChecked_Accept_Eula"
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_checkbox_unchecked.bmp $1
FunctionEnd

Function ".onClick.Accept.Eula"
  ${If} $Bool_Accept_Eula == 1
    IntOp $Bool_Accept_Eula $Bool_Accept_Eula - 1
    Strcpy $1 $Ck_Accept_Eula
    Call "SkinBtn_UnChecked_Accept_Eula"

     EnableWindow $Btn_Install 0

  ${Else} 
    IntOp $Bool_Accept_Eula $Bool_Accept_Eula + 1
    Strcpy $1 $Ck_Accept_Eula
    Call "SkinBtn_Checked_Accept_Eula"

     EnableWindow $Btn_Install 1

  ${EndIf} 
FunctionEnd

# Eula #

Function ".onClick.Show.Eula"
  ${If} $Bool_Show_Eula == 1
    IntOp $Bool_Show_Eula $Bool_Show_Eula - 1
    Strcpy $1 $Lnk_Show_Eula

     EnableWindow $Btn_Custom_Install 1
     System::Call user32::SetWindowPos(i$Btn_Install,i0,i242,i259,i165,i46,i0x0001)

     ShowWindow $LICENSEAGREEMENTCONTROL ${SW_HIDE}

  ${Else} 
    IntOp $Bool_Show_Eula $Bool_Show_Eula + 1
    Strcpy $1 $Lnk_Show_Eula

    EnableWindow $Btn_Custom_Install 0
    System::Call user32::SetWindowPos(i$Btn_Install,i0,i242,i340,i165,i46,i0x0001)

    ShowWindow $LICENSEAGREEMENTCONTROL ${SW_SHOW}

  ${EndIf}
FunctionEnd

# Custom Install #

Function ".onClick.Custom.Install"
  ${If} $Bool_Custom_Install == 1
    IntOp $Bool_Custom_Install $Bool_Custom_Install - 1
    Strcpy $1 $Btn_Custom_Install

    EnableWindow $Lnk_Show_Eula 1
    Call ".onClick.Hide"

  ${Else} 
    IntOp $Bool_Custom_Install $Bool_Custom_Install + 1
    Strcpy $1 $Btn_Custom_Install

    EnableWindow $Lnk_Show_Eula 0
    Call ".onClic.Show"

  ${EndIf}
FunctionEnd

Function ".onClic.Show"
  System::Call user32::SetWindowPos(i$HWNDPARENT,i0,i0,i0,i651,i585,i0x0002)
  System::Call user32::SetWindowPos(i$Dialog,i0,i0,i0,i651,i585,i0x0002)

  System::Alloc 16
  System::Call user32::GetWindowRect(i$HWNDPARENT,isR0)
  System::Call *$R0(i.R1,i.R2,i.R3,i.R4)
  IntOp $R3 $R3 - $R1
  IntOp $R4 $R4 - $R2
  System::Call gdi32::CreateRoundRectRgn(i0,i0,iR3,iR4,i5,i5)i.r0
  System::Call user32::SetWindowRgn(i$HWNDPARENT,ir0,i1)
  System::Free $R0

  ShowWindow $LICENSEAGREEMENTCONTROL ${SW_HIDE}

  System::Call user32::SetWindowPos(i$Btn_Install,i0,i242,i259,i165,i46,i0x0001)

  System::Call user32::SetWindowPos(i$Ck_Accept_Eula,i0,i17,i550,i14,i14,i0x0001)

  System::Call user32::SetWindowPos(i$Lbl_Accept_Eula,i0,i35,i550,i65,i16,i0x0001)

  System::Call user32::SetWindowPos(i$Lnk_Show_Eula,i0,i105,i550,i115,i16,i0x0001)

  System::Call user32::SetWindowPos(i$Btn_Custom_Install,i0,i540,i550,i100,i16,i0x0001)

  ShowWindow $Lbl_Welcome ${SW_HIDE}
  SendMessage $Lbl_Welcome ${WM_SETTEXT} 0 "STR:Nullsoft Installer"
  ShowWindow $Lbl_Welcome ${SW_SHOW}

  ShowWindow $Path_DestDir ${SW_SHOW}
  ShowWindow $Btn_Browse ${SW_SHOW}
  ShowWindow $Lbl_Required_Space ${SW_SHOW}
  ShowWindow $Lbl_Total_Space ${SW_SHOW}

  ShowWindow $Btn_Standard ${SW_SHOW}
  ShowWindow $Btn_Portable ${SW_SHOW}

  ShowWindow $Ck_ShortCut ${SW_SHOW}
  ShowWindow $Lbl_ShortCut ${SW_SHOW}

  ShowWindow $Ck_AutoRun ${SW_SHOW}
  ShowWindow $Lbl_AutoRun ${SW_SHOW}

  ShowWindow $Ck_Taskbar ${SW_SHOW}
  ShowWindow $Lbl_Taskbar ${SW_SHOW}

  ShowWindow $CK_Website ${SW_SHOW}
  ShowWindow $Lbl_Website ${SW_SHOW}

  ${NSD_SetImage} $BGIMAGE "$PLUGINSDIR\002.bmp" $ImageHandle
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_custom_install_up.bmp $Btn_Custom_Install
FunctionEnd

Function ".onClick.Hide"
  System::Call user32::SetWindowPos(i$HWNDPARENT,i0,i0,i0,i651,i451,i0x0002)
  System::Call user32::SetWindowPos(i$Dialog,i0,i0,i0,i651,i451,i0x0002)

  System::Alloc 16
  System::Call user32::GetWindowRect(i$HWNDPARENT,isR0)
  System::Call *$R0(i.R1,i.R2,i.R3,i.R4)
  IntOp $R3 $R3 - $R1
  IntOp $R4 $R4 - $R2
  System::Call gdi32::CreateRoundRectRgn(i0,i0,iR3,iR4,i5,i5)i.r0
  System::Call user32::SetWindowRgn(i$HWNDPARENT,ir0,i1)
  System::Free $R0

  ShowWindow $Lbl_Welcome ${SW_HIDE}
  SendMessage $Lbl_Welcome ${WM_SETTEXT} 0 "STR:Nullsoft Installer"
  ShowWindow $Lbl_Welcome ${SW_SHOW}

  ShowWindow $Path_DestDir ${SW_HIDE}
  ShowWindow $Btn_Browse ${SW_HIDE}
  ShowWindow $Lbl_Required_Space ${SW_HIDE}
  ShowWindow $Lbl_Total_Space ${SW_HIDE}

  ShowWindow $Btn_Standard ${SW_HIDE}
  ShowWindow $Btn_Portable ${SW_HIDE}

  ShowWindow $Ck_ShortCut ${SW_HIDE}
  ShowWindow $Lbl_ShortCut ${SW_HIDE}

  ShowWindow $Ck_AutoRun ${SW_HIDE}
  ShowWindow $Lbl_AutoRun ${SW_HIDE}

  ShowWindow $Ck_Taskbar ${SW_HIDE}
  ShowWindow $Lbl_Taskbar ${SW_HIDE}

  ShowWindow $CK_Website ${SW_HIDE}
  ShowWindow $Lbl_Website ${SW_HIDE}

  System::Call user32::SetWindowPos(i$Ck_Accept_Eula,i0,i17,i409,i14,i14,i0x0001)

  System::Call user32::SetWindowPos(i$Lbl_Accept_Eula,i0,i35,i409,i65,i16,i0x0001)

  System::Call user32::SetWindowPos(i$Lnk_Show_Eula,i0,i105,i409,i115,i16,i0x0001)

  System::Call user32::SetWindowPos(i$Btn_Custom_Install,i0,i540,i409,i100,i16,i0x0001)

  ${NSD_SetImage} $BGIMAGE "$PLUGINSDIR\001.bmp" $ImageHandle
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_custom_install_down.bmp $Btn_Custom_Install
FunctionEnd

# DestDir #

Function ".onClick.onChange.DestDir"
  ;Pop $0
  ;System::Call `user32::GetWindowText(i$Path_Destdir, t.r0, i${NSIS_MAX_STRLEN})`
  ;StrCpy $INSTDIR $0
FunctionEnd

# Search DestDir #

var SPACE.FREE
var DESTINATION
var SPACE.TOTAL

Function ".onClick.Search.DestDir"
  Pop $0
  Push "$INSTDIR"
  Call GetParent
  Pop $R0
  Push "$INSTDIR"
  Push "\"
  Call GetLastPart
  Pop $R1
  nsDialogs::SelectFolderDialog "$NSIS_DESTDIR_LANGUAGE" $R0
  Pop $0
  ${If} $0 == "error"
   Return
  ${EndIf}
  ${If} $0 != ""
    StrCpy $INSTDIR "$0\$R1"
     system::Call `user32::SetWindowText(i $Path_Destdir, t "$INSTDIR")`
     SendMessage $Path_Destdir ${WM_SETTEXT} 0 "STR:$INSTDIR"
  ${Else}
     StrCpy $INSTDIR "$0$R1"
     system::Call `user32::SetWindowText(i $Path_Destdir, t "$INSTDIR")`
     SendMessage $Path_Destdir ${WM_SETTEXT} 0 "STR:$INSTDIR"

     ${GetRoot} $INSTDIR $0
     StrCpy $1 "Bytes"

     System::Call kernel32::GetDiskFreeSpaceEx(tr0,*l,*l,*l.r0)
     ${If} $0 > 1024
       ${OrIf} $0 < 0
          System::Int64Op $0 / 1024
          Pop $0
          StrCpy $1 "KB"
          ${If} $0 > 1024
           ${OrIf} $0 < 0
             System::Int64Op $0 / 1024
             Pop $0
             StrCpy $1 "MB"
             ${If} $0 > 1024
               ${OrIf} $0 < 0
                 System::Int64Op $0 / 1024
                 Pop $0
                 StrCpy $1 "GB"
             ${EndIf}
          ${EndIf}
     ${EndIf}
     StrCpy $SPACE.FREE "$0 $1"

     ${GetRoot} "$INSTDIR" $DESTINATION
     ${DriveSpace} '$DESTINATION' '/D=T /S=G' $SPACE.TOTAL
     SendMessage $Lbl_Total_Space '${WM_SETTEXT}' '1' "STR:$NSIS_TOTAL_SPACE_LANGUAGE $SPACE.TOTAL $1"
    Return
  ${EndIf}
FunctionEnd

Function "GetParent"
  Exch $R0
  Push $R1
  Push $R2
   Push $R3
   StrCpy $R1 0
   StrLen $R2 $R0
   loop:
    IntOp $R1 $R1 + 1
    IntCmp $R1 $R2 get 0 get
    StrCpy $R3 $R0 1 -$R1
    StrCmp $R3 "\" get
    Goto loop
  get:
  StrCpy $R0 $R0 -$R1
  Pop $R3
  Pop $R2
  Pop $R1
  Exch $R0
FunctionEnd

Function "GetLastPart"
  Exch $0
  Exch
  Exch $1
  Push $2
  Push $3
  StrCpy $2 0
  loop:
    IntOp $2 $2 - 1
    StrCpy $3 $1 1 $2
    StrCmp $3 "" 0 +3
      StrCpy $0 ""
      Goto exit2
    	StrCmp $3 $0 exit1
    	Goto loop
      exit1:
      IntOp $2 $2 + 1
      StrCpy $0 $1 "" $2
  exit2:
  Pop $3
  Pop $2
  Pop $1
  Exch $0
FunctionEnd

# Leave #

Function "Page.Welcome.Leave"
  ${NSD_GetState} $Btn_Standard $0
  ${If} $0 <> ${BST_UNCHECKED}
    StrCpy $PortableMode 0
    StrCpy $INSTDIR $NormalDestDir
    Call RequireAdmin
    SendMessage $Path_Destdir ${WM_SETTEXT} 0 "STR:$INSTDIR"
  ${Else}
    StrCpy $PortableMode 1
    ;StrCpy $INSTDIR $PortableDestDir
    StrCpy $INSTDIR '$MAINPATH\$(^Name) Portable'
    SendMessage $Path_Destdir ${WM_SETTEXT} 0 "STR:$INSTDIR"
  ${EndIf}
FunctionEnd

Function ".OnClick.Standard"
  ${NSD_GetState} $Btn_Standard $0
  ${If} $0 <> ${BST_UNCHECKED}
    StrCpy $PortableMode 0
    StrCpy $INSTDIR $NormalDestDir
    Call RequireAdmin
    SendMessage $Path_Destdir ${WM_SETTEXT} 0 "STR:$INSTDIR"

     ${GetRoot} $INSTDIR $0
     StrCpy $1 "Bytes"

     System::Call kernel32::GetDiskFreeSpaceEx(tr0,*l,*l,*l.r0)
     ${If} $0 > 1024
       ${OrIf} $0 < 0
          System::Int64Op $0 / 1024
          Pop $0
          StrCpy $1 "KB"
          ${If} $0 > 1024
           ${OrIf} $0 < 0
             System::Int64Op $0 / 1024
             Pop $0
             StrCpy $1 "MB"
             ${If} $0 > 1024
               ${OrIf} $0 < 0
                 System::Int64Op $0 / 1024
                 Pop $0
                 StrCpy $1 "GB"
             ${EndIf}
          ${EndIf}
     ${EndIf}
     StrCpy $SPACE.FREE "$0 $1"

     ${GetRoot} "$INSTDIR" $DESTINATION
     ${DriveSpace} '$DESTINATION' '/D=T /S=G' $SPACE.TOTAL
     SendMessage $Lbl_Total_Space '${WM_SETTEXT}' '1' "STR:$NSIS_TOTAL_SPACE_LANGUAGE $SPACE.TOTAL $1"

    EnableWindow $Ck_ShortCut 1
    EnableWindow $Ck_Taskbar 1
   Return
  ${EndIf}
FunctionEnd

Function ".OnClick.Portable"
  ${NSD_GetState} $Btn_Portable $0
  ${If} $0 <> ${BST_UNCHECKED}
    StrCpy $PortableMode 1
    ;StrCpy $INSTDIR $PortableDestDir
    StrCpy $INSTDIR '$MAINPATH\$(^Name) Portable'
    SendMessage $Path_Destdir ${WM_SETTEXT} 0 "STR:$INSTDIR"

     ${GetRoot} $INSTDIR $0
     StrCpy $1 "Bytes"

     System::Call kernel32::GetDiskFreeSpaceEx(tr0,*l,*l,*l.r0)
     ${If} $0 > 1024
       ${OrIf} $0 < 0
          System::Int64Op $0 / 1024
          Pop $0
          StrCpy $1 "KB"
          ${If} $0 > 1024
           ${OrIf} $0 < 0
             System::Int64Op $0 / 1024
             Pop $0
             StrCpy $1 "MB"
             ${If} $0 > 1024
               ${OrIf} $0 < 0
                 System::Int64Op $0 / 1024
                 Pop $0
                 StrCpy $1 "GB"
             ${EndIf}
          ${EndIf}
     ${EndIf}
     StrCpy $SPACE.FREE "$0 $1"

     ${GetRoot} "$INSTDIR" $DESTINATION
     ${DriveSpace} '$DESTINATION' '/D=T /S=G' $SPACE.TOTAL
     SendMessage $Lbl_Total_Space '${WM_SETTEXT}' '1' "STR:$NSIS_TOTAL_SPACE_LANGUAGE $SPACE.TOTAL $1"

    EnableWindow $Ck_ShortCut 0
    EnableWindow $Ck_Taskbar 0
   Return
  ${EndIf}
FunctionEnd

# ...:: CLOSE ::... #

Function ".onClick.Close"

  var /GLOBAL Dlg
  var /GLOBAL Lbl_Quit_Title
  var /GLOBAL Lbl_Warning_Title
  var /GLOBAL Lbl_Quit_Msg_1
  var /GLOBAL Lbl_Quit_Msg_2
  var /GLOBAL Btn_Yes_Quit
  var /GLOBAL Btn_No_Quit

  # Language #

  var /GLOBAL NSIS_QUIT_WARNING_LANGUAGE
  var /GLOBAL NSIS_QUIT_MESSAGE_1_LANGUAGE
  var /GLOBAL NSIS_QUIT_MESSAGE_2_LANGUAGE
  var /GLOBAL NSIS_QUIT_BUTTON_YES_LANGUAGE
  var /GLOBAL NSIS_QUIT_BUTTON_NO_LANGUAGE

  System::Call 'user32::SetWindowPos(i$Dlg,i,i,i,i 403,i 192,i 0x16)'
  System::Call 'user32::MoveWindow(i$Dlg,i0,i0,i 403,i 192,i0)'

  nsWindows::Create /NOUNLOAD $HWNDPARENT $${ExStyle} 0x80000000 "" 1018
  Pop $Dlg
  System::Call user32::SetWindowPos(i$Dlg,i0,i0,i0,i403,i192,i0x0002)

  SetCtlColors $Dlg "0x666666" "0xFFFFFF"

  EnableWindow $HWNDPARENT 0

  System::Call 'user32::GetSystemMetrics(i0)i.r1'
  System::Call 'user32::GetSystemMetrics(i1)i.r2'
  IntOp $1 $1 - 403
  IntOp $1 $1 / 2
  IntOp $2 $2 - 192
  IntOp $2 $2 / 2
  System::Call 'user32::MoveWindow(i$Dlg,i$1,i$2,i403,i192,1)'

  System::Alloc 16
  System::Call user32::GetWindowRect(i$Dlg,isR0)
  System::Call *$R0(i.R1,i.R2,i.R3,i.R4)
  IntOp $R3 $R3 - $R1
  IntOp $R4 $R4 - $R2
  System::Call gdi32::CreateRoundRectRgn(i0,i0,iR3,iR4,i5,i5)i.r0
  System::Call user32::SetWindowRgn(i$Dlg,ir0,i1)
  System::Free $R0

  # Close

  nsWindows::CreateControl /NOUNLOAD BUTTON 0x40000000|0x10000000|0x04000000|0x00010000 0 93% 3% 20 24 ""
  Pop $Btn_Close
  Strcpy $1 $Btn_Close
  Call SkinBtn_Close
  GetFunctionAddress $3 ".OnClick.Return"
  nsWindows::OnClick /NOUNLOAD $1 $3

  SetCtlColors $Btn_Close "0x666666" "0xF1F2F3"

  # ...:: WELCOME ::... #

  nsWindows::CreateControl /NOUNLOAD STATIC 0x40000000|0x10000000|0x04000000|0x00000100 0x00000020 35% 3% 55% 12% "Nullsoft Installer"
  Pop $Lbl_Quit_Title

  CreateFont $FONT_NAME "Microsoft Yahei" 12 400
  SendMessage $Lbl_Quit_Title ${WM_SETFONT} $FONT_NAME 0

  SetCtlColors $Lbl_Quit_Title "0x7B8DB6" "0xF1F2F3"

  # ...:: WARNING ::... #

  nsWindows::CreateControl /NOUNLOAD STATIC 0x40000000|0x10000000|0x04000000|0x00000100 0x00000020 20% 30u 65% 8% "Warning!"
  Pop $Lbl_Warning_Title

  CreateFont $FONT_NAME "Microsoft Yahei" 11 300
  SendMessage $Lbl_Warning_Title ${WM_SETFONT} $FONT_NAME 0

  SetCtlColors $Lbl_Warning_Title "0x7B8DB6" "0xFFFFFF"

  # ...:: Message ::... #

  nsWindows::CreateControl /NOUNLOAD STATIC 0x40000000|0x10000000|0x04000000|0x00000100 0x00000020 20% 45u 70% 20% "Setup is not complete. If you close now, CatsSoft PC Cleaner will not be installed."
  Pop $Lbl_Quit_Msg_1

  CreateFont $FONT_NAME "Microsoft Yahei" 8 400
  SendMessage $Lbl_Quit_Msg_1 ${WM_SETFONT} $FONT_NAME 0

  SetCtlColors $Lbl_Quit_Msg_1 "0x7B8DB6" "0xFFFFFF"

  nsWindows::CreateControl /NOUNLOAD STATIC 0x40000000|0x10000000|0x04000000|0x00000100 0x00000020 20% 65u 70% 8% "Are you sure you want to close now?"
  Pop $Lbl_Quit_Msg_2

  CreateFont $FONT_NAME "Microsoft Yahei" 8 400
  SendMessage $Lbl_Quit_Msg_2 ${WM_SETFONT} $FONT_NAME 0

  SetCtlColors $Lbl_Quit_Msg_2 "0x7B8DB6" "0xFFFFFF"

  # ...:: Yes ::... #

  nsWindows::CreateControl /NOUNLOAD BUTTON 0x40000000|0x10000000|0x04000000|0x00010000 0 25% 80% 101 30 "Yes"
  Pop $Btn_Yes_Quit
  StrCpy $1 $Btn_Yes_Quit
  Call SkinBtn_Yes_Quit
  GetFunctionAddress $3 ".onClick.Exit"
  nsWindows::OnClick /NOUNLOAD $1 $3

  SetCtlColors $Btn_Yes_Quit "0x7B8DB6" "0xFFFFFF"

  # ...:: No ::... #

  nsWindows::CreateControl /NOUNLOAD BUTTON 0x40000000|0x10000000|0x04000000|0x00010000 0 50% 80% 101 30 "No"
  Pop $Btn_No_Quit
  StrCpy $1 $Btn_No_Quit
  Call SkinBtn_No_Quit
  GetFunctionAddress $3 ".OnClick.Return"
  nsWindows::OnClick /NOUNLOAD $1 $3

  SetCtlColors $Btn_No_Quit "0x7B8DB6" "0xFFFFFF"

  ClearErrors
  StrCpy $SETTINGSDIR "$EXEDIR\NSIS_TempDir\Settings"
  ReadINIStr $locale_language_name "$SETTINGSDIR\Settings.ini" "Language" "Language"
  IfErrors 0 +3
  ${If} $locale_language_name != "1"

    Strcpy $LANGUAGEDIR "$EXEDIR\NSIS_TempDir\Language"

    ReadINIStr $NSIS_QUIT_WARNING_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "NSIS_Installer" "NSIS_Warning"
    ReadINIStr $NSIS_QUIT_MESSAGE_1_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "NSIS_Installer" "NSIS_Quit_Message_1"
    ReadINIStr $NSIS_QUIT_MESSAGE_2_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "NSIS_Installer" "NSIS_Quit_Message_3"
    ReadINIStr $NSIS_QUIT_BUTTON_YES_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "NSIS_Installer" "NSIS_Button_Yes"
    ReadINIStr $NSIS_QUIT_BUTTON_NO_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "NSIS_Installer" "NSIS_Button_No"

    ReadINIStr $NSIS_TOOLTIPS_CLOSE_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "NSIS_Installer" "NSIS_Button_Close"

    SendMessage $Lbl_Warning_Title ${WM_SETTEXT} 0 "STR:$NSIS_QUIT_WARNING_LANGUAGE"
    SendMessage $Lbl_Quit_Msg_1 ${WM_SETTEXT} 0 "STR:$NSIS_QUIT_MESSAGE_1_LANGUAGE"
    SendMessage $Lbl_Quit_Msg_2 ${WM_SETTEXT} 0 "STR:$NSIS_QUIT_MESSAGE_2_LANGUAGE"

    SendMessage $Btn_Yes_Quit ${WM_SETTEXT} 0 "STR:$NSIS_QUIT_BUTTON_YES_LANGUAGE"
    SendMessage $Btn_No_Quit ${WM_SETTEXT} 0 "STR:$NSIS_QUIT_BUTTON_NO_LANGUAGE"

  ${ElseIf} $locale_language_name == "0"

    Strcpy $LANGUAGEDIR "$EXEDIR\NSIS_TempDir\Language"

    ReadINIStr $NSIS_QUIT_WARNING_LANGUAGE "$LANGUAGEDIR\English.ini" "NSIS_Installer" "NSIS_Warning"
    ReadINIStr $NSIS_QUIT_MESSAGE_1_LANGUAGE "$LANGUAGEDIR\English.ini" "NSIS_Installer" "NSIS_Quit_Message_1"
    ReadINIStr $NSIS_QUIT_MESSAGE_2_LANGUAGE "$LANGUAGEDIR\English.ini" "NSIS_Installer" "NSIS_Quit_Message_3"
    ReadINIStr $NSIS_QUIT_BUTTON_YES_LANGUAGE "$LANGUAGEDIR\English.ini" "NSIS_Installer" "NSIS_Button_Yes"
    ReadINIStr $NSIS_QUIT_BUTTON_NO_LANGUAGE "$LANGUAGEDIR\English.ini" "NSIS_Installer" "NSIS_Button_No"

    ReadINIStr $NSIS_TOOLTIPS_CLOSE_LANGUAGE "$LANGUAGEDIR\English.ini" "NSIS_Installer" "NSIS_Button_Close"

    SendMessage $Lbl_Warning_Title ${WM_SETTEXT} 0 "STR:$NSIS_QUIT_WARNING_LANGUAGE"
    SendMessage $Lbl_Quit_Msg_1 ${WM_SETTEXT} 0 "STR:$NSIS_QUIT_MESSAGE_1_LANGUAGE"
    SendMessage $Lbl_Quit_Msg_2 ${WM_SETTEXT} 0 "STR:$NSIS_QUIT_MESSAGE_2_LANGUAGE"

    SendMessage $Btn_Yes_Quit ${WM_SETTEXT} 0 "STR:$NSIS_QUIT_BUTTON_YES_LANGUAGE"
    SendMessage $Btn_No_Quit ${WM_SETTEXT} 0 "STR:$NSIS_QUIT_BUTTON_NO_LANGUAGE"

  ${EndIf}

  # Background

  nsWindows::CreateControl /NOUNLOAD STATIC 0x10000000|0x40000000|0x04000000|0x0000000E 0 0 0 100% 100% ""
  Pop $BGImage
  Push $0
  Push $R0
  StrCpy $R0 $BGImage
  System::Call "user32::LoadImage(i 0, ts, i 0, i0, i0, i0x0010) i.r0" $PLUGINSDIR\004.bmp
  SendMessage $R0 0x0172 0 $0
  Pop $R0
  Exch $0

  # ...:: BACK ::... #

  GetFunctionAddress $0 onWarningGUICallback
  WndProc::onCallback $BGImage $0 ;

  Push $R0
  System::Call /NOUNLOAD "*(i, i, i, i) i.s"
  Pop $R0
  System::Call /NOUNLOAD "User32::GetWindowRect(i, i) i ($Dlg, R0)"
  System::Call /NOUNLOAD "*$R0(i .s, i .s, i .s, i .s)"
  Pop $0
  Pop $1
  Pop $2
  Pop $3
  IntOp $R1 $2 - $0
  IntOp $R2 $3 - $1
  System::Call /NOUNLOAD "User32::GetWindowRect(i, i) i ($HWNDPARENT, R0)"
  System::Call /NOUNLOAD "*$R0(i .s, i .s, i .s, i .s)"
  System::Free $R0
  Pop $0
  Pop $1
  Pop $2
  Pop $3
  IntOp $R3 $2 - $0
  IntOp $R4 $3 - $1
  IntOp $R3 $R3 - $R1
  IntOp $R3 $R3 / 2
  IntOp $R4 $R4 - $R2
  IntOp $R4 $R4 / 2
  IntOp $R3 $0 + $R3
  IntOp $R4 $1 + $R4
  System::Call user32::SetWindowPos(i$Dlg,i0,i$R3,i$R4,i0,i0,i0x0001)
  Pop $R0

  nsWindows::Show

  ToolTips::Classic $Btn_Close "$NSIS_TOOLTIPS_CLOSE_LANGUAGE"

  EnableWindow $HWNDPARENT 0
FunctionEnd

Function onWarningGUICallback
  ${If} $0 = ${WM_LBUTTONDOWN}
    SendMessage $HWNDPARENT ${WM_NCLBUTTONDOWN} ${HTCAPTION} $0
  ${EndIf}
FunctionEnd

# ...:: OK YES ::... #

Function SkinBtn_Close
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_cls.bmp $Btn_Close
FunctionEnd

# ...:: OK YES ::... #

Function SkinBtn_Yes_Quit
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_next.bmp $Btn_Yes_Quit
FunctionEnd

# ...:: OK NO ::... #

Function SkinBtn_No_Quit
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_next.bmp $Btn_No_Quit
FunctionEnd

# ...:: RETURN ::... #

Function ".OnClick.Return"
  EnableWindow $hwndparent 1
  ShowWindow $HWNDPARENT ${SW_SHOW}
  BringToFront
  System::Call user32::DestroyWindow(i$Dlg)
  Return
FunctionEnd

Function ".onClick.Exit"
  SendMessage $HWNDPARENT ${WM_CLOSE} 0 0
FunctionEnd

# Offer #

Function "Page.Offer"

  var /GLOBAL Lbl_Recommendation
  var /GLOBAL Btn_Back

  # IObit Uinstaller #

  var /GLOBAL ICON_IU
  var /GLOBAL Link_Info_IU
  var /GLOBAL ICON_INFO_IU

  var /GLOBAL Lbl_Offer_IObit_Uninstaller_Title
  var /GLOBAL Lbl_Offer_IObit_Uninstaller_SubTitle

  var /GLOBAL Ck_Yes_Install_IU
  var /GLOBAL Bool_Yes_Install_IU
  var /GLOBAL Lbl_Yes_Install_IU

  # IObit Driver Booster #

  var /GLOBAL ICON_DB
  var /GLOBAL Link_Info_DB
  var /GLOBAL ICON_INFO_DB

  var /GLOBAL Lbl_Offer_IObit_Driver_Booster_Title
  var /GLOBAL Lbl_Offer_IObit_Driver_Booster_SubTitle

  var /GLOBAL Ck_Yes_Install_DB
  var /GLOBAL Bool_Yes_Install_DB
  var /GLOBAL Lbl_Yes_Install_DB

  # IObit Smart Defrag #

  var /GLOBAL ICON_SM
  var /GLOBAL Link_Info_SM
  var /GLOBAL ICON_INFO_SM

  var /GLOBAL Lbl_Offer_IObit_Smart_Defrag_Title
  var /GLOBAL Lbl_Offer_IObit_Smart_Defrag_SubTitle

  var /GLOBAL Ck_Yes_Install_SM
  var /GLOBAL Bool_Yes_Install_SM
  var /GLOBAL Lbl_Yes_Install_SM

  # IObit Advanced SystemCare #

  var /GLOBAL ICON_ASC
  var /GLOBAL Link_Info_ASC
  var /GLOBAL ICON_INFO_ASC

  var /GLOBAL Lbl_Offer_IObit_Advanced_SystemCare_Title
  var /GLOBAL Lbl_Offer_IObit_Advanced_SystemCare_SubTitle

  var /GLOBAL Ck_Yes_Install_ASC
  var /GLOBAL Bool_Yes_Install_ASC
  var /GLOBAL Lbl_Yes_Install_ASC

  # IObit Malware Fighter #

  var /GLOBAL ICON_IMF
  var /GLOBAL Link_Info_IMF
  var /GLOBAL ICON_INFO_IMF

  var /GLOBAL Lbl_Offer_IObit_Malware_Fighter_Title
  var /GLOBAL Lbl_Offer_IObit_Malware_Fighter_SubTitle

  var /GLOBAL Ck_Yes_Install_IMF
  var /GLOBAL Bool_Yes_Install_IMF
  var /GLOBAL Lbl_Yes_Install_IMF

  # IObit Unlocker #

  var /GLOBAL ICON_IUK
  var /GLOBAL Link_Info_IUK
  var /GLOBAL ICON_INFO_IUK

  var /GLOBAL Lbl_Offer_IObit_Unlocker_Title
  var /GLOBAL Lbl_Offer_IObit_Unlocker_SubTitle

  var /GLOBAL Ck_Yes_Install_IUK
  var /GLOBAL Bool_Yes_Install_IUK
  var /GLOBAL Lbl_Yes_Install_IUK

  # IObit Undelete #

  var /GLOBAL ICON_IUD
  var /GLOBAL Link_Info_IUD
  var /GLOBAL ICON_INFO_IUD

  var /GLOBAL Lbl_Offer_IObit_Undelete_Title
  var /GLOBAL Lbl_Offer_IObit_Undelete_SubTitle

  var /GLOBAL Ck_Yes_Install_IUD
  var /GLOBAL Bool_Yes_Install_IUD
  var /GLOBAL Lbl_Yes_Install_IUD

  # IObit PCtransfer #

  var /GLOBAL ICON_IPC
  var /GLOBAL Link_Info_IPC
  var /GLOBAL ICON_INFO_IPC

  var /GLOBAL Lbl_Offer_IObit_PCtransfer_Title
  var /GLOBAL Lbl_Offer_IObit_PCtransfer_SubTitle

  var /GLOBAL Ck_Yes_Install_IPC
  var /GLOBAL Bool_Yes_Install_IPC
  var /GLOBAL Lbl_Yes_Install_IPC

  # IObit Protect Folder #

  var /GLOBAL ICON_IPF
  var /GLOBAL Link_Info_IPF
  var /GLOBAL ICON_INFO_IPF

  var /GLOBAL Lbl_Offer_IObit_Protect_Folder_Title
  var /GLOBAL Lbl_Offer_IObit_Protect_Folder_SubTitle

  var /GLOBAL Ck_Yes_Install_IPF
  var /GLOBAL Bool_Yes_Install_IPF
  var /GLOBAL Lbl_Yes_Install_IPF

  var /GLOBAL Lnk_Read_IObit_Eula
  var /GLOBAL Bool_Read_IObit_Eula

  var /GLOBAL Lnk_Back_IObit_Offer
  var /GLOBAL IOBITLICENSEAGREEMENTCONTROL

  var /GLOBAL Ck_IObit_Page_1
  var /GLOBAL Ck_IObit_Page_2
  var /GLOBAL Ck_IObit_Page_3

  # LANGUAGE #

  var /GLOBAL IObit_RECOMMENDATION_LANGUAGE
  var /GLOBAL IObit_RECOMMENDATION_INFO_LANGUAGE

  var /GLOBAL IObit_BUTTON_INSTALL_LANGUAGE
  var /GLOBAL IObit_BUTTON_BACK_LANGUAGE

  var /GLOBAL IObit_MORE_INFO_LANGUAGE

  var /GLOBAL IObit_AGREE_LICENSE_AGREEMENT_LANGUAGE

  var /GLOBAL IObit_IU_TITLE_LANGUAGE
  var /GLOBAL IObit_IU_SUBTITLE_LANGUAGE
  var /GLOBAL IObit_IU_INFO_LANGUAGE
  var /GLOBAL IObit_IU_INSTALL_LANGUAGE

  var /GLOBAL IObit_DB_TITLE_LANGUAGE
  var /GLOBAL IObit_DB_SUBTITLE_LANGUAGE
  var /GLOBAL IObit_DB_INFO_LANGUAGE
  var /GLOBAL IObit_DB_INSTALL_LANGUAGE

  var /GLOBAL IObit_SM_TITLE_LANGUAGE
  var /GLOBAL IObit_SM_SUBTITLE_LANGUAGE
  var /GLOBAL IObit_SM_INFO_LANGUAGE
  var /GLOBAL IObit_SM_INSTALL_LANGUAGE

  var /GLOBAL IObit_ASC_TITLE_LANGUAGE
  var /GLOBAL IObit_ASC_SUBTITLE_LANGUAGE
  var /GLOBAL IObit_ASC_INFO_LANGUAGE
  var /GLOBAL IObit_ASC_INSTALL_LANGUAGE

  var /GLOBAL IObit_IMF_TITLE_LANGUAGE
  var /GLOBAL IObit_IMF_SUBTITLE_LANGUAGE
  var /GLOBAL IObit_IMF_INFO_LANGUAGE
  var /GLOBAL IObit_IMF_INSTALL_LANGUAGE

  var /GLOBAL IObit_IUK_TITLE_LANGUAGE
  var /GLOBAL IObit_IUK_SUBTITLE_LANGUAGE
  var /GLOBAL IObit_IUK_INFO_LANGUAGE
  var /GLOBAL IObit_IUK_INSTALL_LANGUAGE

  var /GLOBAL IObit_IUD_TITLE_LANGUAGE
  var /GLOBAL IObit_IUD_SUBTITLE_LANGUAGE
  var /GLOBAL IObit_IUD_INFO_LANGUAGE
  var /GLOBAL IObit_IUD_INSTALL_LANGUAGE

  var /GLOBAL IObit_IPC_TITLE_LANGUAGE
  var /GLOBAL IObit_IPC_SUBTITLE_LANGUAGE
  var /GLOBAL IObit_IPC_INFO_LANGUAGE
  var /GLOBAL IObit_IPC_INSTALL_LANGUAGE

  var /GLOBAL IObit_IPF_TITLE_LANGUAGE
  var /GLOBAL IObit_IPF_SUBTITLE_LANGUAGE
  var /GLOBAL IObit_IPF_INFO_LANGUAGE
  var /GLOBAL IObit_IPF_INSTALL_LANGUAGE

  GetDlgItem $0 $HWNDPARENT 1
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 2
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 3
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 1990
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 1991
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 1992
  ShowWindow $0 ${SW_HIDE}

  System::Call user32::SetWindowPos(i$HWNDPARENT,i0,i0,i0,i651,i451,i0x0002)
  nsDialogs::Create /NOUNLOAD 1044
  Pop $Dialog
  ${If} $Dialog == error
   Abort
  ${EndIf}
  System::Call user32::SetWindowPos(i$Dialog,i0,i0,i0,i651,i451,i0x0002)

  SetCtlColors $Dialog "0x666666" "0xFFFFFF"

  SendMessage $HWNDPARENT ${WM_SETTEXT} 0 "STR:$(^Name)"

  # Close #

  nsDialogs::CreateControl /NOUNLOAD BUTTON 0x40000000|0x10000000|0x04000000|0x00010000 0 623 6 16 16 ""
  Pop $Btn_Close
  Strcpy $1 $Btn_Close
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_close.bmp $1
  GetFunctionAddress $3 ".onClick.Close"
  SkinBtn::onClick /NOUNLOAD $1 $3

  SendMessage $HWNDPARENT ${DM_SETDEFID} $btn_Close 0
  SendMessage $HWNDPARENT ${WM_NEXTDLGCTL} $btn_Close 1

  SetCtlColors $Btn_Close "0x666666" "0xFFFFFF"

  # Minimize #

  nsDialogs::CreateControl /NOUNLOAD BUTTON 0x40000000|0x10000000|0x04000000|0x00010000 0 600 6 16 16 ""
  Pop $Btn_Minimize
  Strcpy $1 $Btn_Minimize
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_min.bmp $1
  GetFunctionAddress $3 ".onClick.Minimize"
  SkinBtn::onClick /NOUNLOAD $1 $3

  SetCtlColors $Btn_Minimize "0x666666" "0xFFFFFF"

  # CatsSoft #

  nsDialogs::CreateControl /NOUNLOAD STATIC 0x40000000|0x10000000|0x04000000|0x00000100 0x00000020 245 8 255 25 "Recommendation"
  Pop $Lbl_Recommendation

  CreateFont $FONT_NAME "Microsoft Yahei" 15 600
  SendMessage $Lbl_Recommendation ${WM_SETFONT} $FONT_NAME 0

  SetCtlColors $Lbl_Recommendation "0x666666" "0xFFFFFF"

  nsDialogs::CreateControl /NOUNLOAD STATIC 0x40000000|0x10000000|0x04000000|0x00000100 0x00000020 170 37 365 16 "Install IObit products for better computer performance"
  Pop $Lbl_Welcome

  CreateFont $FONT_NAME "Microsoft Yahei" 8 300
  SendMessage $Lbl_Welcome ${WM_SETFONT} $FONT_NAME 0

  SetCtlColors $Lbl_Welcome "0x666666" "0xFFFFFF"

  # Install #

  nsDialogs::CreateControl /NOUNLOAD BUTTON 0x40000000|0x10000000|0x04000000|0x00010000 0 530 400 101 32 "Install"
  Pop $Btn_Install
  Strcpy $1 $Btn_Install
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_next.bmp $1
  GetFunctionAddress $3 ".onClick.Install"
  SkinBtn::onClick /NOUNLOAD $1 $3

  EnableWindow $Btn_Install 1

  CreateFont $FONT_NAME "Microsoft Yahei" 9 400
  SendMessage $Btn_Install ${WM_SETFONT} $FONT_NAME 0

  SetCtlColors $Btn_Install "0x7B8DB6" "0xFFFFFF"

  # Back #

  nsDialogs::CreateControl /NOUNLOAD BUTTON 0x40000000|0x10000000|0x04000000|0x00010000 0 426 400 101 32 "Back"
  Pop $Btn_Back
  Strcpy $1 $Btn_Back
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_next.bmp $1
  GetFunctionAddress $3 ".onClick.Back"
  SkinBtn::onClick /NOUNLOAD $1 $3

  CreateFont $FONT_NAME "Microsoft Yahei" 9 400
  SendMessage $Btn_Back ${WM_SETFONT} $FONT_NAME 0

  SetCtlColors $Btn_Back "0x7B8DB6" "0xFFFFFF"

  # ...:: IObit Uninstaller ::... #

  nsDialogs::CreateControl STATIC 0x40000000|0x10000000|0x04000000|0x00000003|0x00000100 0 100 150 32 32 "" ; icon
  Pop $ICON_IU
  System::Call 'user32::LoadImage(i 0, t "$PLUGINSDIR\IObit_Uninstaller.ico", i ${IMAGE_ICON}, i 0, i 0, i ${LR_CREATEDIBSECTION}|${LR_LOADFROMFILE}) i.s'
  Pop $R0
  SendMessage $ICON_IU ${STM_SETIMAGE} ${IMAGE_ICON} "$R0"
  ${NSD_AddStyle} $ICON_IU "${IMAGE_ICON}"

  SetCtlColors $ICON_IU "0x666666" "0xF7F7F7"

  ShowWindow $ICON_IU ${SW_SHOW}

  nsDialogs::CreateControl /NOUNLOAD STATIC 0x40000000|0x10000000|0x04000000|0x00000100 0x00000020 45 190 165 25 "IObit Uninstaller"
  Pop $Lbl_Offer_IObit_Uninstaller_Title

  CreateFont $FONT_NAME "Microsoft Yahei" 13 600
  SendMessage $Lbl_Offer_IObit_Uninstaller_Title ${WM_SETFONT} $FONT_NAME 0

  SetCtlColors $Lbl_Offer_IObit_Uninstaller_Title "0x666666" "0xF7F7F7"

  ShowWindow $Lbl_Offer_IObit_Uninstaller_Title ${SW_SHOW}

  nsDialogs::CreateControl /NOUNLOAD STATIC 0x40000000|0x10000000|0x04000000|0x00000100 0x00000020 45 220 170 35 "Uninstall unwanted programs and system utilities bars"
  Pop $Lbl_Offer_IObit_Uninstaller_SubTitle

  CreateFont $FONT_NAME "Microsoft Yahei" 8 300
  SendMessage $Lbl_Offer_IObit_Uninstaller_SubTitle ${WM_SETFONT} $FONT_NAME 0

  SetCtlColors $Lbl_Offer_IObit_Uninstaller_SubTitle "0x666666" "0xF7F7F7"

  ShowWindow $Lbl_Offer_IObit_Uninstaller_SubTitle ${SW_SHOW}

  # Info IU #

  nsDialogs::CreateControl /NOUNLOAD SysLink ${WS_CHILD}|${WS_VISIBLE}|${WS_TABSTOP} 0 45 260 140 16 "More info <A>Here</A>"
  Pop $Link_Info_IU
  StrCpy $1 $Link_Info_IU
  GetFunctionAddress $3 ".onClick.IObit.Uninstaller"
  nsDialogs::OnNotify /NOUNLOAD $1 $3

  CreateFont $FONT_NAME "Microsoft Yahei" 9 400
  SendMessage $Link_Info_IU ${WM_SETFONT} $FONT_NAME 0

  SetCtlColors $Link_Info_IU "0x666666" "0xF7F7F7"

  ShowWindow $Link_Info_IU ${SW_SHOW}

  nsDialogs::CreateControl STATIC 0x40000000|0x10000000|0x04000000|0x00000003|0x00000100 0 185 260 16 16 "" ; icon
  Pop $ICON_INFO_IU
  System::Call 'user32::LoadImage(i 0, t "$PLUGINSDIR\Info.ico", i ${IMAGE_ICON}, i 0, i 0, i ${LR_CREATEDIBSECTION}|${LR_LOADFROMFILE}) i.s'
  Pop $R0
  SendMessage $ICON_INFO_IU ${STM_SETIMAGE} ${IMAGE_ICON} "$R0"
  ${NSD_AddStyle} $ICON_INFO_IU "${IMAGE_ICON}"

  SetCtlColors $ICON_INFO_IU "0x666666" "0xF7F7F7"

  ShowWindow $ICON_INFO_IU ${SW_SHOW}

  # Install IU #

  nsDialogs::CreateControl /NOUNLOAD BUTTON 0x40000000|0x10000000|0x04000000|0x00010000 0 45 290 14 14 ""
  Pop $Ck_Yes_Install_IU
  Strcpy $1 $Ck_Yes_Install_IU
  Call SkinBtn_UnChecked_Yes_Install_IU
  GetFunctionAddress $3 ".onClick.Yes.Install.IU"
  SkinBtn::onClick $1 $3
  Strcpy $Bool_Yes_Install_IU 0

  ShowWindow $Ck_Yes_Install_IU ${SW_SHOW}

  nsDialogs::CreateControl /NOUNLOAD STATIC 0x40000000|0x10000000|0x04000000|0x00000100 0x00000020 65 290 140 25 "Yes install IObit Uninstaller"
  Pop $Lbl_Yes_Install_IU

  CreateFont $FONT_NAME "Microsoft Yahei" 7 300
  SendMessage $Lbl_Yes_Install_IU ${WM_SETFONT} $FONT_NAME 0

  SetCtlColors $Lbl_Yes_Install_IU "0x666666" "0xF7F7F7"

  ShowWindow $Lbl_Yes_Install_IU ${SW_SHOW}

  # ...:: IObit Driver Booster ::... #

  nsDialogs::CreateControl STATIC 0x40000000|0x10000000|0x04000000|0x00000003|0x00000100 0 305 150 32 32 "" ; icon
  Pop $ICON_DB
  System::Call 'user32::LoadImage(i 0, t "$PLUGINSDIR\IObit_Driver_Booster.ico", i ${IMAGE_ICON}, i 0, i 0, i ${LR_CREATEDIBSECTION}|${LR_LOADFROMFILE}) i.s'
  Pop $R0
  SendMessage $ICON_DB ${STM_SETIMAGE} ${IMAGE_ICON} "$R0"
  ${NSD_AddStyle} $ICON_DB "${IMAGE_ICON}"

  SetCtlColors $ICON_DB "0x666666" "0xF7F7F7"

  ShowWindow $ICON_DB ${SW_SHOW}

  nsDialogs::CreateControl /NOUNLOAD STATIC 0x40000000|0x10000000|0x04000000|0x00000100 0x00000020 255 190 155 25 "Driver Booster"
  Pop $Lbl_Offer_IObit_Driver_Booster_Title

  CreateFont $FONT_NAME "Microsoft Yahei" 13 600
  SendMessage $Lbl_Offer_IObit_Driver_Booster_Title ${WM_SETFONT} $FONT_NAME 0

  SetCtlColors $Lbl_Offer_IObit_Driver_Booster_Title "0x666666" "0xF7F7F7"

  ShowWindow $Lbl_Offer_IObit_Driver_Booster_Title ${SW_SHOW}

  nsDialogs::CreateControl /NOUNLOAD STATIC 0x40000000|0x10000000|0x04000000|0x00000100 0x00000020 245 220 170 35 "Update drivers in the system for a better gaming experience"
  Pop $Lbl_Offer_IObit_Driver_Booster_SubTitle

  CreateFont $FONT_NAME "Microsoft Yahei" 8 300
  SendMessage $Lbl_Offer_IObit_Driver_Booster_SubTitle ${WM_SETFONT} $FONT_NAME 0

  SetCtlColors $Lbl_Offer_IObit_Driver_Booster_SubTitle "0x666666" "0xF7F7F7"

  ShowWindow $Lbl_Offer_IObit_Driver_Booster_SubTitle ${SW_SHOW}

  # Info DB #

  nsDialogs::CreateControl /NOUNLOAD SysLink ${WS_CHILD}|${WS_VISIBLE}|${WS_TABSTOP} 0 245 260 140 16 "More info <A>Here</A>"
  Pop $Link_Info_DB
  StrCpy $1 $Link_Info_DB
  GetFunctionAddress $3 ".onClick.IObit.Driver.Booster"
  nsDialogs::OnNotify /NOUNLOAD $1 $3

  CreateFont $FONT_NAME "Microsoft Yahei" 9 400
  SendMessage $Link_Info_DB ${WM_SETFONT} $FONT_NAME 0

  SetCtlColors $Link_Info_DB "0x666666" "0xF7F7F7"

  ShowWindow $Link_Info_DB ${SW_SHOW}

  nsDialogs::CreateControl STATIC 0x40000000|0x10000000|0x04000000|0x00000003|0x00000100 0 385 260 16 16 "" ; icon
  Pop $ICON_INFO_DB
  System::Call 'user32::LoadImage(i 0, t "$PLUGINSDIR\Info.ico", i ${IMAGE_ICON}, i 0, i 0, i ${LR_CREATEDIBSECTION}|${LR_LOADFROMFILE}) i.s'
  Pop $R0
  SendMessage $ICON_INFO_DB ${STM_SETIMAGE} ${IMAGE_ICON} "$R0"
  ${NSD_AddStyle} $ICON_INFO_DB "${IMAGE_ICON}"

  SetCtlColors $ICON_INFO_DB "0x666666" "0xF7F7F7"

  ShowWindow $ICON_INFO_DB ${SW_SHOW}

  # Install DB #

  nsDialogs::CreateControl /NOUNLOAD BUTTON 0x40000000|0x10000000|0x04000000|0x00010000 0 245 290 14 14 ""
  Pop $Ck_Yes_Install_DB
  Strcpy $1 $Ck_Yes_Install_DB
  Call SkinBtn_UnChecked_Yes_Install_DB
  GetFunctionAddress $3 ".onClick.Yes.Install.DB"
  SkinBtn::onClick $1 $3
  Strcpy $Bool_Yes_Install_DB 0

  ShowWindow $Ck_Yes_Install_DB ${SW_SHOW}

  nsDialogs::CreateControl /NOUNLOAD STATIC 0x40000000|0x10000000|0x04000000|0x00000100 0x00000020 265 290 140 25 "Yes install Driver Booster"
  Pop $Lbl_Yes_Install_DB

  CreateFont $FONT_NAME "Microsoft Yahei" 7 300
  SendMessage $Lbl_Yes_Install_DB ${WM_SETFONT} $FONT_NAME 0

  SetCtlColors $Lbl_Yes_Install_DB "0x666666" "0xF7F7F7"

  ShowWindow $Lbl_Yes_Install_DB ${SW_SHOW}

  # ...:: IObit Smart Defrag ::... #

  nsDialogs::CreateControl STATIC 0x40000000|0x10000000|0x04000000|0x00000003|0x00000100 0 505 150 32 32 "" ; icon
  Pop $ICON_SM
  System::Call 'user32::LoadImage(i 0, t "$PLUGINSDIR\IObit_Smart_Defrag.ico", i ${IMAGE_ICON}, i 0, i 0, i ${LR_CREATEDIBSECTION}|${LR_LOADFROMFILE}) i.s'
  Pop $R0
  SendMessage $ICON_SM ${STM_SETIMAGE} ${IMAGE_ICON} "$R0"
  ${NSD_AddStyle} $ICON_SM "${IMAGE_ICON}"

  SetCtlColors $ICON_SM "0x666666" "0xF7F7F7"

  ShowWindow $ICON_SM ${SW_SHOW}

  nsDialogs::CreateControl /NOUNLOAD STATIC 0x40000000|0x10000000|0x04000000|0x00000100 0x00000020 455 190 155 25 "Smart Defrag"
  Pop $Lbl_Offer_IObit_Smart_Defrag_Title

  CreateFont $FONT_NAME "Microsoft Yahei" 13 600
  SendMessage $Lbl_Offer_IObit_Smart_Defrag_Title ${WM_SETFONT} $FONT_NAME 0

  SetCtlColors $Lbl_Offer_IObit_Smart_Defrag_Title "0x666666" "0xF7F7F7"

  ShowWindow $Lbl_Offer_IObit_Smart_Defrag_Title ${SW_SHOW}

  nsDialogs::CreateControl /NOUNLOAD STATIC 0x40000000|0x10000000|0x04000000|0x00000100 0x00000020 445 220 170 35 "Defragments and optimized hard drives of system"
  Pop $Lbl_Offer_IObit_Smart_Defrag_SubTitle

  CreateFont $FONT_NAME "Microsoft Yahei" 8 300
  SendMessage $Lbl_Offer_IObit_Smart_Defrag_SubTitle ${WM_SETFONT} $FONT_NAME 0

  SetCtlColors $Lbl_Offer_IObit_Smart_Defrag_SubTitle "0x666666" "0xF7F7F7"

  ShowWindow $Lbl_Offer_IObit_Smart_Defrag_SubTitle ${SW_SHOW}

  # Info SM #

  nsDialogs::CreateControl /NOUNLOAD SysLink ${WS_CHILD}|${WS_VISIBLE}|${WS_TABSTOP} 0 445 260 140 16 "More info <A>Here</A>"
  Pop $Link_Info_SM
  StrCpy $1 $Link_Info_SM
  GetFunctionAddress $3 ".onClick.IObit.Smart.Defrag"
  nsDialogs::OnNotify /NOUNLOAD $1 $3

  CreateFont $FONT_NAME "Microsoft Yahei" 9 400
  SendMessage $Link_Info_SM ${WM_SETFONT} $FONT_NAME 0

  SetCtlColors $Link_Info_SM "0x666666" "0xF7F7F7"

  ShowWindow $Link_Info_SM ${SW_SHOW}

  nsDialogs::CreateControl STATIC 0x40000000|0x10000000|0x04000000|0x00000003|0x00000100 0 585 260 16 16 "" ; icon
  Pop $ICON_INFO_SM
  System::Call 'user32::LoadImage(i 0, t "$PLUGINSDIR\Info.ico", i ${IMAGE_ICON}, i 0, i 0, i ${LR_CREATEDIBSECTION}|${LR_LOADFROMFILE}) i.s'
  Pop $R0
  SendMessage $ICON_INFO_SM ${STM_SETIMAGE} ${IMAGE_ICON} "$R0"
  ${NSD_AddStyle} $ICON_INFO_SM "${IMAGE_ICON}"

  SetCtlColors $ICON_INFO_SM "0x666666" "0xF7F7F7"

  ShowWindow $ICON_INFO_SM ${SW_SHOW}

  # Install SM #

  nsDialogs::CreateControl /NOUNLOAD BUTTON 0x40000000|0x10000000|0x04000000|0x00010000 0 445 290 14 14 ""
  Pop $Ck_Yes_Install_SM
  Strcpy $1 $Ck_Yes_Install_SM
  Call SkinBtn_UnChecked_Yes_Install_SM
  GetFunctionAddress $3 ".onClick.Yes.Install.SM"
  SkinBtn::onClick $1 $3
  Strcpy $Bool_Yes_Install_SM 0

  ShowWindow $Ck_Yes_Install_SM ${SW_SHOW}

  nsDialogs::CreateControl /NOUNLOAD STATIC 0x40000000|0x10000000|0x04000000|0x00000100 0x00000020 465 290 140 25 "Yes install Smart Defrag"
  Pop $Lbl_Yes_Install_SM

  CreateFont $FONT_NAME "Microsoft Yahei" 7 300
  SendMessage $Lbl_Yes_Install_SM ${WM_SETFONT} $FONT_NAME 0

  SetCtlColors $Lbl_Yes_Install_SM "0x666666" "0xF7F7F7"

  ShowWindow $Lbl_Yes_Install_SM ${SW_SHOW}

  # ...:: IObit Advanced SystemCare ::... #

  nsDialogs::CreateControl STATIC 0x40000000|0x10000000|0x04000000|0x00000003|0x00000100 0 100 150 32 32 "" ; icon
  Pop $ICON_ASC
  System::Call 'user32::LoadImage(i 0, t "$PLUGINSDIR\IObit_Advanced_System_Care.ico", i ${IMAGE_ICON}, i 0, i 0, i ${LR_CREATEDIBSECTION}|${LR_LOADFROMFILE}) i.s'
  Pop $R0
  SendMessage $ICON_ASC ${STM_SETIMAGE} ${IMAGE_ICON} "$R0"
  ${NSD_AddStyle} $ICON_ASC "${IMAGE_ICON}"

  SetCtlColors $ICON_ASC "0x666666" "0xF7F7F7"

  ShowWindow $ICON_ASC ${SW_HIDE}

  nsDialogs::CreateControl /NOUNLOAD STATIC 0x40000000|0x10000000|0x04000000|0x00000100 0x00000020 45 190 160 25 "IObit SystemCare"
  Pop $Lbl_Offer_IObit_Advanced_SystemCare_Title

  CreateFont $FONT_NAME "Microsoft Yahei" 13 600
  SendMessage $Lbl_Offer_IObit_Advanced_SystemCare_Title ${WM_SETFONT} $FONT_NAME 0

  SetCtlColors $Lbl_Offer_IObit_Advanced_SystemCare_Title "0x666666" "0xF7F7F7"

  ShowWindow $Lbl_Offer_IObit_Advanced_SystemCare_Title ${SW_HIDE}

  nsDialogs::CreateControl /NOUNLOAD STATIC 0x40000000|0x10000000|0x04000000|0x00000100 0x00000020 45 220 170 35 "Clean and optimize up your computer with 1-click"
  Pop $Lbl_Offer_IObit_Advanced_SystemCare_SubTitle

  CreateFont $FONT_NAME "Microsoft Yahei" 8 300
  SendMessage $Lbl_Offer_IObit_Advanced_SystemCare_SubTitle ${WM_SETFONT} $FONT_NAME 0

  SetCtlColors $Lbl_Offer_IObit_Advanced_SystemCare_SubTitle "0x666666" "0xF7F7F7"

  ShowWindow $Lbl_Offer_IObit_Advanced_SystemCare_SubTitle ${SW_HIDE}

  # Info ASC #

  nsDialogs::CreateControl /NOUNLOAD SysLink ${WS_CHILD}|${WS_VISIBLE}|${WS_TABSTOP} 0 45 260 140 16 "More info <A>Here</A>"
  Pop $Link_Info_ASC
  StrCpy $1 $Link_Info_ASC
  GetFunctionAddress $3 ".onClick.IObit.Advanced.SystemCare"
  nsDialogs::OnNotify /NOUNLOAD $1 $3

  CreateFont $FONT_NAME "Microsoft Yahei" 9 400
  SendMessage $Link_Info_ASC ${WM_SETFONT} $FONT_NAME 0

  SetCtlColors $Link_Info_ASC "0x666666" "0xF7F7F7"

  ShowWindow $Link_Info_ASC ${SW_HIDE}

  nsDialogs::CreateControl STATIC 0x40000000|0x10000000|0x04000000|0x00000003|0x00000100 0 185 260 16 16 "" ; icon
  Pop $ICON_INFO_ASC
  System::Call 'user32::LoadImage(i 0, t "$PLUGINSDIR\Info.ico", i ${IMAGE_ICON}, i 0, i 0, i ${LR_CREATEDIBSECTION}|${LR_LOADFROMFILE}) i.s'
  Pop $R0
  SendMessage $ICON_INFO_ASC ${STM_SETIMAGE} ${IMAGE_ICON} "$R0"
  ${NSD_AddStyle} $ICON_INFO_ASC "${IMAGE_ICON}"

  SetCtlColors $ICON_INFO_ASC "0x666666" "0xF7F7F7"

  ShowWindow $ICON_INFO_ASC ${SW_HIDE}

  # Install ASC #

  nsDialogs::CreateControl /NOUNLOAD BUTTON 0x40000000|0x10000000|0x04000000|0x00010000 0 45 290 14 14 ""
  Pop $Ck_Yes_Install_ASC
  Strcpy $1 $Ck_Yes_Install_ASC
  Call SkinBtn_UnChecked_Yes_Install_ASC
  GetFunctionAddress $3 ".onClick.Yes.Install.ASC"
  SkinBtn::onClick $1 $3
  Strcpy $Bool_Yes_Install_ASC 0

  ShowWindow $Ck_Yes_Install_ASC ${SW_HIDE}

  nsDialogs::CreateControl /NOUNLOAD STATIC 0x40000000|0x10000000|0x04000000|0x00000100 0x00000020 65 290 140 25 "Yes install SystemCare"
  Pop $Lbl_Yes_Install_ASC

  CreateFont $FONT_NAME "Microsoft Yahei" 7 300
  SendMessage $Lbl_Yes_Install_ASC ${WM_SETFONT} $FONT_NAME 0

  SetCtlColors $Lbl_Yes_Install_ASC "0x666666" "0xF7F7F7"

  ShowWindow $Lbl_Yes_Install_ASC ${SW_HIDE}

  # ...:: IObit Malware Fighter ::... #

  nsDialogs::CreateControl STATIC 0x40000000|0x10000000|0x04000000|0x00000003|0x00000100 0 305 150 32 32 "" ; icon
  Pop $ICON_IMF
  System::Call 'user32::LoadImage(i 0, t "$PLUGINSDIR\IObit_Malware_Fighter.ico", i ${IMAGE_ICON}, i 0, i 0, i ${LR_CREATEDIBSECTION}|${LR_LOADFROMFILE}) i.s'
  Pop $R0
  SendMessage $ICON_IMF ${STM_SETIMAGE} ${IMAGE_ICON} "$R0"
  ${NSD_AddStyle} $ICON_IMF "${IMAGE_ICON}"

  SetCtlColors $ICON_IMF "0x666666" "0xF7F7F7"

  ShowWindow $ICON_IMF ${SW_HIDE}

  nsDialogs::CreateControl /NOUNLOAD STATIC 0x40000000|0x10000000|0x04000000|0x00000100 0x00000020 253 190 155 25 "Malware Fighter"
  Pop $Lbl_Offer_IObit_Malware_Fighter_Title

  CreateFont $FONT_NAME "Microsoft Yahei" 13 600
  SendMessage $Lbl_Offer_IObit_Malware_Fighter_Title ${WM_SETFONT} $FONT_NAME 0

  SetCtlColors $Lbl_Offer_IObit_Malware_Fighter_Title "0x666666" "0xF7F7F7"

  ShowWindow $Lbl_Offer_IObit_Malware_Fighter_Title ${SW_HIDE}

  nsDialogs::CreateControl /NOUNLOAD STATIC 0x40000000|0x10000000|0x04000000|0x00000100 0x00000020 245 220 170 35 "Anti-malware software is essential for protecting your computer"
  Pop $Lbl_Offer_IObit_Malware_Fighter_SubTitle

  CreateFont $FONT_NAME "Microsoft Yahei" 8 300
  SendMessage $Lbl_Offer_IObit_Malware_Fighter_SubTitle ${WM_SETFONT} $FONT_NAME 0

  SetCtlColors $Lbl_Offer_IObit_Malware_Fighter_SubTitle "0x666666" "0xF7F7F7"

  ShowWindow $Lbl_Offer_IObit_Malware_Fighter_SubTitle ${SW_HIDE}

  # Info IMF #

  nsDialogs::CreateControl /NOUNLOAD SysLink ${WS_CHILD}|${WS_VISIBLE}|${WS_TABSTOP} 0 245 260 140 16 "More info <A>Here</A>"
  Pop $Link_Info_IMF
  StrCpy $1 $Link_Info_IMF
  GetFunctionAddress $3 ".onClick.IObit.Malware.Fighter"
  nsDialogs::OnNotify /NOUNLOAD $1 $3

  CreateFont $FONT_NAME "Microsoft Yahei" 9 400
  SendMessage $Link_Info_IMF ${WM_SETFONT} $FONT_NAME 0

  SetCtlColors $Link_Info_IMF "0x666666" "0xF7F7F7"

  ShowWindow $Link_Info_IMF ${SW_HIDE}

  nsDialogs::CreateControl STATIC 0x40000000|0x10000000|0x04000000|0x00000003|0x00000100 0 385 260 16 16 "" ; icon
  Pop $ICON_INFO_IMF
  System::Call 'user32::LoadImage(i 0, t "$PLUGINSDIR\Info.ico", i ${IMAGE_ICON}, i 0, i 0, i ${LR_CREATEDIBSECTION}|${LR_LOADFROMFILE}) i.s'
  Pop $R0
  SendMessage $ICON_INFO_IMF ${STM_SETIMAGE} ${IMAGE_ICON} "$R0"
  ${NSD_AddStyle} $ICON_INFO_IMF "${IMAGE_ICON}"

  SetCtlColors $ICON_INFO_IMF "0x666666" "0xF7F7F7"

  ShowWindow $ICON_INFO_IMF ${SW_HIDE}

  # Install IMF #

  nsDialogs::CreateControl /NOUNLOAD BUTTON 0x40000000|0x10000000|0x04000000|0x00010000 0 245 290 14 14 ""
  Pop $Ck_Yes_Install_IMF
  Strcpy $1 $Ck_Yes_Install_IMF
  Call SkinBtn_UnChecked_Yes_Install_IMF
  GetFunctionAddress $3 ".onClick.Yes.Install.IMF"
  SkinBtn::onClick $1 $3
  Strcpy $Bool_Yes_Install_IMF 0

  ShowWindow $Ck_Yes_Install_IMF ${SW_HIDE}

  nsDialogs::CreateControl /NOUNLOAD STATIC 0x40000000|0x10000000|0x04000000|0x00000100 0x00000020 265 290 140 25 "Yes install Malware Fighter"
  Pop $Lbl_Yes_Install_IMF

  CreateFont $FONT_NAME "Microsoft Yahei" 7 300
  SendMessage $Lbl_Yes_Install_IMF ${WM_SETFONT} $FONT_NAME 0

  SetCtlColors $Lbl_Yes_Install_IMF "0x666666" "0xF7F7F7"

  ShowWindow $Lbl_Yes_Install_IMF ${SW_HIDE}

  # ...:: IObit Unlocker ::... #

  nsDialogs::CreateControl STATIC 0x40000000|0x10000000|0x04000000|0x00000003|0x00000100 0 505 150 32 32 "" ; icon
  Pop $ICON_IUK
  System::Call 'user32::LoadImage(i 0, t "$PLUGINSDIR\IObit_Unloker.ico", i ${IMAGE_ICON}, i 0, i 0, i ${LR_CREATEDIBSECTION}|${LR_LOADFROMFILE}) i.s'
  Pop $R0
  SendMessage $ICON_IUK ${STM_SETIMAGE} ${IMAGE_ICON} "$R0"
  ${NSD_AddStyle} $ICON_IUK "${IMAGE_ICON}"

  SetCtlColors $ICON_IUK "0x666666" "0xF7F7F7"

  ShowWindow $ICON_IUK ${SW_HIDE}

  nsDialogs::CreateControl /NOUNLOAD STATIC 0x40000000|0x10000000|0x04000000|0x00000100 0x00000020 455 190 155 25 "IObit Unlocker"
  Pop $Lbl_Offer_IObit_Unlocker_Title

  CreateFont $FONT_NAME "Microsoft Yahei" 13 600
  SendMessage $Lbl_Offer_IObit_Unlocker_Title ${WM_SETFONT} $FONT_NAME 0

  SetCtlColors $Lbl_Offer_IObit_Unlocker_Title "0x666666" "0xF7F7F7"

  ShowWindow $Lbl_Offer_IObit_Unlocker_Title ${SW_HIDE}

  nsDialogs::CreateControl /NOUNLOAD STATIC 0x40000000|0x10000000|0x04000000|0x00000100 0x00000020 445 220 170 35 "Unlock with 1-click file or folder you want to unlock"
  Pop $Lbl_Offer_IObit_Unlocker_SubTitle

  CreateFont $FONT_NAME "Microsoft Yahei" 8 300
  SendMessage $Lbl_Offer_IObit_Unlocker_SubTitle ${WM_SETFONT} $FONT_NAME 0

  SetCtlColors $Lbl_Offer_IObit_Unlocker_SubTitle "0x666666" "0xF7F7F7"

  ShowWindow $Lbl_Offer_IObit_Unlocker_SubTitle ${SW_HIDE}

  # Info IUK #

  nsDialogs::CreateControl /NOUNLOAD SysLink ${WS_CHILD}|${WS_VISIBLE}|${WS_TABSTOP} 0 445 260 140 16 "More info <A>Here</A>"
  Pop $Link_Info_IUK
  StrCpy $1 $Link_Info_IUK
  GetFunctionAddress $3 ".onClick.IObit.Unlocker"
  nsDialogs::OnNotify /NOUNLOAD $1 $3

  CreateFont $FONT_NAME "Microsoft Yahei" 9 400
  SendMessage $Link_Info_IUK ${WM_SETFONT} $FONT_NAME 0

  SetCtlColors $Link_Info_IUK "0x666666" "0xF7F7F7"

  ShowWindow $Link_Info_IUK ${SW_HIDE}

  nsDialogs::CreateControl STATIC 0x40000000|0x10000000|0x04000000|0x00000003|0x00000100 0 585 260 16 16 "" ; icon
  Pop $ICON_INFO_IUK
  System::Call 'user32::LoadImage(i 0, t "$PLUGINSDIR\Info.ico", i ${IMAGE_ICON}, i 0, i 0, i ${LR_CREATEDIBSECTION}|${LR_LOADFROMFILE}) i.s'
  Pop $R0
  SendMessage $ICON_INFO_IUK ${STM_SETIMAGE} ${IMAGE_ICON} "$R0"
  ${NSD_AddStyle} $ICON_INFO_IUK "${IMAGE_ICON}"

  SetCtlColors $ICON_INFO_IUK "0x666666" "0xF7F7F7"

  ShowWindow $ICON_INFO_IUK ${SW_HIDE}

  # Install IUK #

  nsDialogs::CreateControl /NOUNLOAD BUTTON 0x40000000|0x10000000|0x04000000|0x00010000 0 445 290 14 14 ""
  Pop $Ck_Yes_Install_IUK
  Strcpy $1 $Ck_Yes_Install_IUK
  Call SkinBtn_UnChecked_Yes_Install_IUK
  GetFunctionAddress $3 ".onClick.Yes.Install.IUK"
  SkinBtn::onClick $1 $3
  Strcpy $Bool_Yes_Install_IUK 0

  ShowWindow $Ck_Yes_Install_IUK ${SW_HIDE}

  nsDialogs::CreateControl /NOUNLOAD STATIC 0x40000000|0x10000000|0x04000000|0x00000100 0x00000020 465 290 140 25 "Yes install IObit Unlocker"
  Pop $Lbl_Yes_Install_IUK

  CreateFont $FONT_NAME "Microsoft Yahei" 7 300
  SendMessage $Lbl_Yes_Install_IUK ${WM_SETFONT} $FONT_NAME 0

  SetCtlColors $Lbl_Yes_Install_IUK "0x666666" "0xF7F7F7"

  ShowWindow $Lbl_Yes_Install_IUK ${SW_HIDE}

  # ...:: IObit Undelete ::... #

  nsDialogs::CreateControl STATIC 0x40000000|0x10000000|0x04000000|0x00000003|0x00000100 0 100 150 32 32 "" ; icon
  Pop $ICON_IUD
  System::Call 'user32::LoadImage(i 0, t "$PLUGINSDIR\IObit_Undelete.ico", i ${IMAGE_ICON}, i 0, i 0, i ${LR_CREATEDIBSECTION}|${LR_LOADFROMFILE}) i.s'
  Pop $R0
  SendMessage $ICON_IUD ${STM_SETIMAGE} ${IMAGE_ICON} "$R0"
  ${NSD_AddStyle} $ICON_IUD "${IMAGE_ICON}"

  SetCtlColors $ICON_IUD "0x666666" "0xF7F7F7"

  ShowWindow $ICON_IUD ${SW_HIDE}

  nsDialogs::CreateControl /NOUNLOAD STATIC 0x40000000|0x10000000|0x04000000|0x00000100 0x00000020 45 190 160 25 "IObit Undelete"
  Pop $Lbl_Offer_IObit_Undelete_Title

  CreateFont $FONT_NAME "Microsoft Yahei" 13 600
  SendMessage $Lbl_Offer_IObit_Undelete_Title ${WM_SETFONT} $FONT_NAME 0

  SetCtlColors $Lbl_Offer_IObit_Undelete_Title "0x666666" "0xF7F7F7"

  ShowWindow $Lbl_Offer_IObit_Undelete_Title ${SW_HIDE}

  nsDialogs::CreateControl /NOUNLOAD STATIC 0x40000000|0x10000000|0x04000000|0x00000100 0x00000020 45 220 170 35 "Recover Deleted and Lost Files with One Click"
  Pop $Lbl_Offer_IObit_Undelete_SubTitle

  CreateFont $FONT_NAME "Microsoft Yahei" 8 300
  SendMessage $Lbl_Offer_IObit_Undelete_SubTitle ${WM_SETFONT} $FONT_NAME 0

  SetCtlColors $Lbl_Offer_IObit_Undelete_SubTitle "0x666666" "0xF7F7F7"

  ShowWindow $Lbl_Offer_IObit_Undelete_SubTitle ${SW_HIDE}

  # Info IUD #

  nsDialogs::CreateControl /NOUNLOAD SysLink ${WS_CHILD}|${WS_VISIBLE}|${WS_TABSTOP} 0 45 260 140 16 "More info <A>Here</A>"
  Pop $Link_Info_IUD
  StrCpy $1 $Link_Info_IUD
  GetFunctionAddress $3 ".onClick.IObit.Undelete"
  nsDialogs::OnNotify /NOUNLOAD $1 $3

  CreateFont $FONT_NAME "Microsoft Yahei" 9 400
  SendMessage $Link_Info_IUD ${WM_SETFONT} $FONT_NAME 0

  SetCtlColors $Link_Info_IUD "0x666666" "0xF7F7F7"

  ShowWindow $Link_Info_IUD ${SW_HIDE}

  nsDialogs::CreateControl STATIC 0x40000000|0x10000000|0x04000000|0x00000003|0x00000100 0 185 260 16 16 "" ; icon
  Pop $ICON_INFO_IUD
  System::Call 'user32::LoadImage(i 0, t "$PLUGINSDIR\Info.ico", i ${IMAGE_ICON}, i 0, i 0, i ${LR_CREATEDIBSECTION}|${LR_LOADFROMFILE}) i.s'
  Pop $R0
  SendMessage $ICON_INFO_IUD ${STM_SETIMAGE} ${IMAGE_ICON} "$R0"
  ${NSD_AddStyle} $ICON_INFO_IUD "${IMAGE_ICON}"

  SetCtlColors $ICON_INFO_IUD "0x666666" "0xF7F7F7"

  ShowWindow $ICON_INFO_IUD ${SW_HIDE}

  # Install IUD #

  nsDialogs::CreateControl /NOUNLOAD BUTTON 0x40000000|0x10000000|0x04000000|0x00010000 0 45 290 14 14 ""
  Pop $Ck_Yes_Install_IUD
  Strcpy $1 $Ck_Yes_Install_IUD
  Call SkinBtn_UnChecked_Yes_Install_IUD
  GetFunctionAddress $3 ".onClick.Yes.Install.IUD"
  SkinBtn::onClick $1 $3
  Strcpy $Bool_Yes_Install_IUD 0

  ShowWindow $Ck_Yes_Install_IUD ${SW_HIDE}

  nsDialogs::CreateControl /NOUNLOAD STATIC 0x40000000|0x10000000|0x04000000|0x00000100 0x00000020 65 290 140 25 "Yes install IObit Undelete"
  Pop $Lbl_Yes_Install_IUD

  CreateFont $FONT_NAME "Microsoft Yahei" 7 300
  SendMessage $Lbl_Yes_Install_IUD ${WM_SETFONT} $FONT_NAME 0

  SetCtlColors $Lbl_Yes_Install_IUD "0x666666" "0xF7F7F7"

  ShowWindow $Lbl_Yes_Install_IUD ${SW_HIDE}

  # ...:: IObit PCtransfer ::... #

  nsDialogs::CreateControl STATIC 0x40000000|0x10000000|0x04000000|0x00000003|0x00000100 0 305 150 32 32 "" ; icon
  Pop $ICON_IPC
  System::Call 'user32::LoadImage(i 0, t "$PLUGINSDIR\IObit_PCTransfer.ico", i ${IMAGE_ICON}, i 0, i 0, i ${LR_CREATEDIBSECTION}|${LR_LOADFROMFILE}) i.s'
  Pop $R0
  SendMessage $ICON_IPC ${STM_SETIMAGE} ${IMAGE_ICON} "$R0"
  ${NSD_AddStyle} $ICON_IPC "${IMAGE_ICON}"

  SetCtlColors $ICON_IPC "0x666666" "0xF7F7F7"

  ShowWindow $ICON_IPC ${SW_HIDE}

  nsDialogs::CreateControl /NOUNLOAD STATIC 0x40000000|0x10000000|0x04000000|0x00000100 0x00000020 253 190 155 25 "IObit PCtransfer"
  Pop $Lbl_Offer_IObit_PCtransfer_Title

  CreateFont $FONT_NAME "Microsoft Yahei" 13 600
  SendMessage $Lbl_Offer_IObit_PCtransfer_Title ${WM_SETFONT} $FONT_NAME 0

  SetCtlColors $Lbl_Offer_IObit_PCtransfer_Title "0x666666" "0xF7F7F7"

  ShowWindow $Lbl_Offer_IObit_PCtransfer_Title ${SW_HIDE}

  nsDialogs::CreateControl /NOUNLOAD STATIC 0x40000000|0x10000000|0x04000000|0x00000100 0x00000020 245 220 170 35 "Quickly Backup Important Files"
  Pop $Lbl_Offer_IObit_PCtransfer_SubTitle

  CreateFont $FONT_NAME "Microsoft Yahei" 8 300
  SendMessage $Lbl_Offer_IObit_PCtransfer_SubTitle ${WM_SETFONT} $FONT_NAME 0

  SetCtlColors $Lbl_Offer_IObit_PCtransfer_SubTitle "0x666666" "0xF7F7F7"

  ShowWindow $Lbl_Offer_IObit_PCtransfer_SubTitle ${SW_HIDE}

  # Info IPC #

  nsDialogs::CreateControl /NOUNLOAD SysLink ${WS_CHILD}|${WS_VISIBLE}|${WS_TABSTOP} 0 245 260 140 16 "More info <A>Here</A>"
  Pop $Link_Info_IPC
  StrCpy $1 $Link_Info_IPC
  GetFunctionAddress $3 ".onClick.IObit.PCtransfer"
  nsDialogs::OnNotify /NOUNLOAD $1 $3

  CreateFont $FONT_NAME "Microsoft Yahei" 9 400
  SendMessage $Link_Info_IPC ${WM_SETFONT} $FONT_NAME 0

  SetCtlColors $Link_Info_IPC "0x666666" "0xF7F7F7"

  ShowWindow $Link_Info_IPC ${SW_HIDE}

  nsDialogs::CreateControl STATIC 0x40000000|0x10000000|0x04000000|0x00000003|0x00000100 0 385 260 16 16 "" ; icon
  Pop $ICON_INFO_IPC
  System::Call 'user32::LoadImage(i 0, t "$PLUGINSDIR\Info.ico", i ${IMAGE_ICON}, i 0, i 0, i ${LR_CREATEDIBSECTION}|${LR_LOADFROMFILE}) i.s'
  Pop $R0
  SendMessage $ICON_INFO_IPC ${STM_SETIMAGE} ${IMAGE_ICON} "$R0"
  ${NSD_AddStyle} $ICON_INFO_IPC "${IMAGE_ICON}"

  SetCtlColors $ICON_INFO_IPC "0x666666" "0xF7F7F7"

  ShowWindow $ICON_INFO_IPC ${SW_HIDE}

  # Install IPC #

  nsDialogs::CreateControl /NOUNLOAD BUTTON 0x40000000|0x10000000|0x04000000|0x00010000 0 245 290 14 14 ""
  Pop $Ck_Yes_Install_IPC
  Strcpy $1 $Ck_Yes_Install_IPC
  Call SkinBtn_UnChecked_Yes_Install_IPC
  GetFunctionAddress $3 ".onClick.Yes.Install.IPC"
  SkinBtn::onClick $1 $3
  Strcpy $Bool_Yes_Install_IPC 0

  ShowWindow $Ck_Yes_Install_IPC ${SW_HIDE}

  nsDialogs::CreateControl /NOUNLOAD STATIC 0x40000000|0x10000000|0x04000000|0x00000100 0x00000020 265 290 140 25 "Yes install PCtransfer"
  Pop $Lbl_Yes_Install_IPC

  CreateFont $FONT_NAME "Microsoft Yahei" 7 300
  SendMessage $Lbl_Yes_Install_IPC ${WM_SETFONT} $FONT_NAME 0

  SetCtlColors $Lbl_Yes_Install_IPC "0x666666" "0xF7F7F7"

  ShowWindow $Lbl_Yes_Install_IPC ${SW_HIDE}

  # ...:: IObit Protect Folder ::... #

  nsDialogs::CreateControl STATIC 0x40000000|0x10000000|0x04000000|0x00000003|0x00000100 0 505 150 32 32 "" ; icon
  Pop $ICON_IPF
  System::Call 'user32::LoadImage(i 0, t "$PLUGINSDIR\IObit_Protect_Folder.ico", i ${IMAGE_ICON}, i 0, i 0, i ${LR_CREATEDIBSECTION}|${LR_LOADFROMFILE}) i.s'
  Pop $R0
  SendMessage $ICON_IPF ${STM_SETIMAGE} ${IMAGE_ICON} "$R0"
  ${NSD_AddStyle} $ICON_IPF "${IMAGE_ICON}"

  SetCtlColors $ICON_IPF "0x666666" "0xF7F7F7"

  ShowWindow $ICON_IPF ${SW_HIDE}

  nsDialogs::CreateControl /NOUNLOAD STATIC 0x40000000|0x10000000|0x04000000|0x00000100 0x00000020 455 190 155 25 "Protect Folder"
  Pop $Lbl_Offer_IObit_Protect_Folder_Title

  CreateFont $FONT_NAME "Microsoft Yahei" 13 600
  SendMessage $Lbl_Offer_IObit_Protect_Folder_Title ${WM_SETFONT} $FONT_NAME 0

  SetCtlColors $Lbl_Offer_IObit_Protect_Folder_Title "0x666666" "0xF7F7F7"

  ShowWindow $Lbl_Offer_IObit_Protect_Folder_Title ${SW_HIDE}

  nsDialogs::CreateControl /NOUNLOAD STATIC 0x40000000|0x10000000|0x04000000|0x00000100 0x00000020 445 220 170 35 "Protected Folder keeps locking your important data"
  Pop $Lbl_Offer_IObit_Protect_Folder_SubTitle

  CreateFont $FONT_NAME "Microsoft Yahei" 8 300
  SendMessage $Lbl_Offer_IObit_Protect_Folder_SubTitle ${WM_SETFONT} $FONT_NAME 0

  SetCtlColors $Lbl_Offer_IObit_Protect_Folder_SubTitle "0x666666" "0xF7F7F7"

  ShowWindow $Lbl_Offer_IObit_Protect_Folder_SubTitle ${SW_HIDE}

  # Info IPF #

  nsDialogs::CreateControl /NOUNLOAD SysLink ${WS_CHILD}|${WS_VISIBLE}|${WS_TABSTOP} 0 445 260 140 16 "More info <A>Here</A>"
  Pop $Link_Info_IPF
  StrCpy $1 $Link_Info_IPF
  GetFunctionAddress $3 ".onClick.IObit.Protect.Folder"
  nsDialogs::OnNotify /NOUNLOAD $1 $3

  CreateFont $FONT_NAME "Microsoft Yahei" 9 400
  SendMessage $Link_Info_IPF ${WM_SETFONT} $FONT_NAME 0

  SetCtlColors $Link_Info_IPF "0x666666" "0xF7F7F7"

  ShowWindow $Link_Info_IPF ${SW_HIDE}

  nsDialogs::CreateControl STATIC 0x40000000|0x10000000|0x04000000|0x00000003|0x00000100 0 585 260 16 16 "" ; icon
  Pop $ICON_INFO_IPF
  System::Call 'user32::LoadImage(i 0, t "$PLUGINSDIR\Info.ico", i ${IMAGE_ICON}, i 0, i 0, i ${LR_CREATEDIBSECTION}|${LR_LOADFROMFILE}) i.s'
  Pop $R0
  SendMessage $ICON_INFO_IPF ${STM_SETIMAGE} ${IMAGE_ICON} "$R0"
  ${NSD_AddStyle} $ICON_INFO_IPF "${IMAGE_ICON}"

  SetCtlColors $ICON_INFO_IPF "0x666666" "0xF7F7F7"

  ShowWindow $ICON_INFO_IPF ${SW_HIDE}

  # Install IPF #

  nsDialogs::CreateControl /NOUNLOAD BUTTON 0x40000000|0x10000000|0x04000000|0x00010000 0 445 290 14 14 ""
  Pop $Ck_Yes_Install_IPF
  Strcpy $1 $Ck_Yes_Install_IPF
  Call SkinBtn_UnChecked_Yes_Install_IPF
  GetFunctionAddress $3 ".onClick.Yes.Install.IPF"
  SkinBtn::onClick $1 $3
  Strcpy $Bool_Yes_Install_IPF 0

  ShowWindow $Ck_Yes_Install_IPF ${SW_HIDE}

  nsDialogs::CreateControl /NOUNLOAD STATIC 0x40000000|0x10000000|0x04000000|0x00000100 0x00000020 460 290 140 25 "Yes install Protect Folder"
  Pop $Lbl_Yes_Install_IPF

  CreateFont $FONT_NAME "Microsoft Yahei" 7 300
  SendMessage $Lbl_Yes_Install_IPF ${WM_SETFONT} $FONT_NAME 0

  SetCtlColors $Lbl_Yes_Install_IPF "0x666666" "0xF7F7F7"

  ShowWindow $Lbl_Yes_Install_IPF ${SW_HIDE}

  # IObit Page 1 #

  nsDialogs::CreateControl /NOUNLOAD BUTTON 0x40000000|0x10000000|0x04000000|0x00010000|0x00000000|0x00000C00|0x00000009|0x00002000 0 45% 359 13 13 ""
  Pop $Ck_IObit_Page_1
  StrCpy $1 $Ck_IObit_Page_1
  Call "SkinBtn_Checked_IObit_Page_1"
  GetFunctionAddress $3 ".onClick.IObit.Page.1"
  SkinBtn::onClick /NOUNLOAD $1 $3

  ShowWindow $Ck_IObit_Page_1 ${SW_SHOW}

  # IObit Page 2 #

  nsDialogs::CreateControl /NOUNLOAD BUTTON 0x40000000|0x10000000|0x04000000|0x00010000|0x00000000|0x00000C00|0x00000009|0x00002000 0 50% 359 13 13 ""
  Pop $Ck_IObit_Page_2
  StrCpy $1 $Ck_IObit_Page_2
  Call "SkinBtn_UnChecked_IObit_Page_2"
  GetFunctionAddress $3 ".onClick.IObit.Page.2"
  SkinBtn::onClick /NOUNLOAD $1 $3

  ShowWindow $Ck_IObit_Page_2 ${SW_SHOW}

  # IObit Page 3 #

  nsDialogs::CreateControl /NOUNLOAD BUTTON 0x40000000|0x10000000|0x04000000|0x00010000|0x00000000|0x00000C00|0x00000009|0x00002000 0 55% 359 13 13 ""
  Pop $Ck_IObit_Page_3
  StrCpy $1 $Ck_IObit_Page_3
  Call "SkinBtn_UnChecked_IObit_Page_3"
  GetFunctionAddress $3 ".onClick.IObit.Page.3"
  SkinBtn::onClick /NOUNLOAD $1 $3

  ShowWindow $Ck_IObit_Page_3 ${SW_SHOW}

  # Eula #

  nsDialogs::CreateControl SysLink ${WS_CHILD}|${WS_VISIBLE}|${WS_TABSTOP} 0 25 336 490 16 "By installing or using this products, you agree to its <A>EULA</A> && <A>Privacy Policy</A>"
  pop $Lnk_Read_IObit_Eula
  StrCpy $1 $Lnk_Read_IObit_Eula
  GetFunctionAddress $3 ".onClick.Read.IObit.Eula"
  nsDialogs::OnNotify $1 $3
  Strcpy $Bool_Read_IObit_Eula 0

  CreateFont $FONT_NAME "Microsoft Yahei" 7 300
  SendMessage $Lnk_Read_IObit_Eula ${WM_SETFONT} $FONT_NAME 0

  SetCtlColors $Lnk_Read_IObit_Eula "0x666666" "0xFFFFFF"

  ShowWindow $Lnk_Read_IObit_Eula ${SW_SHOW}

  # ...:: Back ::... #

  nsDialogs::CreateControl /NOUNLOAD LINK 0x40000000|0x10000000|0x04000000|0x00010000|0x0000000B 0 585 359 45 16 "Back"
  Pop $Lnk_Back_IObit_Offer
  Strcpy $1 $Lnk_Back_IObit_Offer
  GetFunctionAddress $3 ".onClick.Back.IObit.Offer"
  nsDialogs::onClick /NOUNLOAD $1 $3

  CreateFont $FONT_NAME "Microsoft Yahei" 9 400
  SendMessage $Lnk_Back_IObit_Offer ${WM_SETFONT} $FONT_NAME 0

  SetCtlColors $Lnk_Back_IObit_Offer "0x666666" "0xFFFFFF"

  ShowWindow $Lnk_Back_IObit_Offer ${SW_HIDE}

  # ...:: Eula ::... #

  System::Call `kernel32::GetModuleHandle(i 0) i.R3`
  System::Call 'User32::CreateWindowEx(i0,t"STATIC",i0,i0x50020100,i25,i80,i600,i255,i$DIALOG,i1130,i0,i0)i.R1'
  Strcpy $IOBITLICENSEAGREEMENTCONTROL $R1
  WebCtrl::ShowWebInCtrl $IOBITLICENSEAGREEMENTCONTROL "$PLUGINSDIR\License\IObit.htm"
  System::Call "user32::SetDlgItemText(i$HWNDPARENT,i1,ts)" "Œ“Ω” ‹(&I)"

  ShowWindow $IOBITLICENSEAGREEMENTCONTROL ${SW_HIDE}

  ClearErrors
  StrCpy $SETTINGSDIR "$EXEDIR\NSIS_TempDir\Settings"
  ReadINIStr $locale_language_name "$SETTINGSDIR\Settings.ini" "Language" "Language"
  IfErrors 0 +3
  ${If} $locale_language_name != "1"

    Strcpy $LANGUAGEDIR "$EXEDIR\NSIS_TempDir\Language"

    ReadINIStr $IObit_RECOMMENDATION_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "IObit_Products" "IObit_Recommendation"
    ReadINIStr $IObit_RECOMMENDATION_INFO_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "IObit_Products" "IObit_Info_Recommendation"

    ReadINIStr $IObit_BUTTON_INSTALL_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "IObit_Products" "IObit_Button_Install"
    ReadINIStr $IObit_BUTTON_BACK_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "IObit_Products" "IObit_Button_Back"

    ReadINIStr $IObit_MORE_INFO_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "IObit_Products" "IObit_More_Info"

    ReadINIStr $IObit_AGREE_LICENSE_AGREEMENT_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "IObit_Products" "IObit_Agree_License_Agreement"

    ReadINIStr $IObit_IU_TITLE_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "IObit_Products" "IObit_Uninstaller_Title"
    ReadINIStr $IObit_IU_SUBTITLE_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "IObit_Products" "IObit_Uninstaller_SubTitle"
    ReadINIStr $IObit_IU_INFO_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "IObit_Products" "IObit_Uninstaller_Info"
    ReadINIStr $IObit_IU_INSTALL_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "IObit_Products" "IObit_Uninstaller_Accept"

    ReadINIStr $IObit_DB_TITLE_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "IObit_Products" "IObit_Driver_Booster_Title"
    ReadINIStr $IObit_DB_SUBTITLE_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "IObit_Products" "IObit_Driver_Booster_SubTitle"
    ReadINIStr $IObit_DB_INFO_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "IObit_Products" "IObit_Driver_Booster_Info"
    ReadINIStr $IObit_DB_INSTALL_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "IObit_Products" "IObit_Driver_Booster_Accept"

    ReadINIStr $IObit_SM_TITLE_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "IObit_Products" "IObit_Smart_Defrag_Title"
    ReadINIStr $IObit_SM_SUBTITLE_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "IObit_Products" "IObit_Smart_Defrag_SubTitle"
    ReadINIStr $IObit_SM_INFO_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "IObit_Products" "IObit_Smart_Defrag_Info"
    ReadINIStr $IObit_SM_INSTALL_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "IObit_Products" "IObit_Smart_Defrag_Accept"

    ReadINIStr $IObit_ASC_TITLE_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "IObit_Products" "IObit_Advanced_SystemCare_Title"
    ReadINIStr $IObit_ASC_SUBTITLE_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "IObit_Products" "IObit_Advanced_SystemCare_SubTitle"
    ReadINIStr $IObit_ASC_INFO_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "IObit_Products" "IObit_Advanced_SystemCare_Info"
    ReadINIStr $IObit_ASC_INSTALL_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "IObit_Products" "IObit_Advanced_SystemCare_Accept"

    ReadINIStr $IObit_IMF_TITLE_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "IObit_Products" "IObit_Malware_Fighter_Title"
    ReadINIStr $IObit_IMF_SUBTITLE_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "IObit_Products" "IObit_Malware_Fighter_SubTitle"
    ReadINIStr $IObit_IMF_INFO_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "IObit_Products" "IObit_Malware_Fighter_Info"
    ReadINIStr $IObit_IMF_INSTALL_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "IObit_Products" "IObit_Malware_Fighter_Accept"

    ReadINIStr $IObit_IUK_TITLE_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "IObit_Products" "IObit_Unlocker_Title"
    ReadINIStr $IObit_IUK_SUBTITLE_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "IObit_Products" "IObit_Unlocker_SubTitle"
    ReadINIStr $IObit_IUK_INFO_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "IObit_Products" "IObit_Unlocker_Info"
    ReadINIStr $IObit_IUK_INSTALL_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "IObit_Products" "IObit_Unlocker_Accept"

    ReadINIStr $IObit_IUD_TITLE_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "IObit_Products" "IObit_Undelete_Title"
    ReadINIStr $IObit_IUD_SUBTITLE_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "IObit_Products" "IObit_Undelete_SubTitle"
    ReadINIStr $IObit_IUD_INFO_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "IObit_Products" "IObit_Undelete_Info"
    ReadINIStr $IObit_IUD_INSTALL_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "IObit_Products" "IObit_Undelete_Accept"

    ReadINIStr $IObit_IPC_TITLE_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "IObit_Products" "IObit_PCtransfer_Title"
    ReadINIStr $IObit_IPC_SUBTITLE_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "IObit_Products" "IObit_PCtransfer_SubTitle"
    ReadINIStr $IObit_IPC_INFO_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "IObit_Products" "IObit_PCtransfer_Info"
    ReadINIStr $IObit_IPC_INSTALL_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "IObit_Products" "IObit_PCtransfer_Accept"

    ReadINIStr $IObit_IPF_TITLE_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "IObit_Products" "IObit_Protected_Folder_Title"
    ReadINIStr $IObit_IPF_SUBTITLE_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "IObit_Products" "IObit_Protected_Folder_SubTitle"
    ReadINIStr $IObit_IPF_INFO_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "IObit_Products" "IObit_Protected_Folder_Info"
    ReadINIStr $IObit_IPF_INSTALL_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "IObit_Products" "IObit_Protected_Folder_Accept"

    # IObit #

    SendMessage $Lbl_Recommendation ${WM_SETTEXT} 0 "STR:$IObit_RECOMMENDATION_LANGUAGE"
    SendMessage $Lbl_Welcome ${WM_SETTEXT} 0 "STR:$IObit_RECOMMENDATION_INFO_LANGUAGE"

    SendMessage $Btn_Install ${WM_SETTEXT} 0 "STR:$IObit_BUTTON_INSTALL_LANGUAGE"
    SendMessage $Btn_Back ${WM_SETTEXT} 0 "STR:$IObit_BUTTON_BACK_LANGUAGE"

    SendMessage $Lnk_Read_IObit_Eula ${WM_SETTEXT} 0 "STR:$IObit_AGREE_LICENSE_AGREEMENT_LANGUAGE"
    SendMessage $Lnk_Back_IObit_Offer ${WM_SETTEXT} 0 "STR:$IObit_BUTTON_BACK_LANGUAGE"

    # ...:: IObit Uninstaller ::... #

    SendMessage $Lbl_Offer_IObit_Uninstaller_Title ${WM_SETTEXT} 0 "STR:$IObit_IU_TITLE_LANGUAGE"
    SendMessage $Lbl_Offer_IObit_Uninstaller_SubTitle ${WM_SETTEXT} 0 "STR:$IObit_IU_SUBTITLE_LANGUAGE"

    SendMessage $Link_Info_IU ${WM_SETTEXT} 0 "STR:$IObit_MORE_INFO_LANGUAGE"
    SendMessage $Lbl_Yes_Install_IU ${WM_SETTEXT} 0 "STR:$IObit_IU_INSTALL_LANGUAGE"

    # ...:: IObit Driver Booster ::... #

    SendMessage $Lbl_Offer_IObit_Driver_Booster_Title ${WM_SETTEXT} 0 "STR:$IObit_DB_TITLE_LANGUAGE"
    SendMessage $Lbl_Offer_IObit_Driver_Booster_SubTitle ${WM_SETTEXT} 0 "STR:$IObit_DB_SUBTITLE_LANGUAGE"

    SendMessage $Link_Info_DB ${WM_SETTEXT} 0 "STR:$IObit_MORE_INFO_LANGUAGE"
    SendMessage $Lbl_Yes_Install_DB ${WM_SETTEXT} 0 "STR:$IObit_DB_INSTALL_LANGUAGE"

    # ...:: IObit Smart Defrag ::... #

    SendMessage $Lbl_Offer_IObit_Smart_Defrag_Title ${WM_SETTEXT} 0 "STR:$IObit_SM_TITLE_LANGUAGE"
    SendMessage $Lbl_Offer_IObit_Smart_Defrag_SubTitle ${WM_SETTEXT} 0 "STR:$IObit_SM_SUBTITLE_LANGUAGE"

    SendMessage $Link_Info_SM ${WM_SETTEXT} 0 "STR:$IObit_MORE_INFO_LANGUAGE"
    SendMessage $Lbl_Yes_Install_SM ${WM_SETTEXT} 0 "STR:$IObit_SM_INSTALL_LANGUAGE"

    # ...:: IObit Advanced SystemCare ::... #

    SendMessage $Lbl_Offer_IObit_Advanced_SystemCare_Title ${WM_SETTEXT} 0 "STR:$IObit_ASC_TITLE_LANGUAGE"
    SendMessage $Lbl_Offer_IObit_Advanced_SystemCare_SubTitle ${WM_SETTEXT} 0 "STR:$IObit_ASC_SUBTITLE_LANGUAGE"

    SendMessage $Link_Info_ASC ${WM_SETTEXT} 0 "STR:$IObit_MORE_INFO_LANGUAGE"
    SendMessage $Lbl_Yes_Install_ASC ${WM_SETTEXT} 0 "STR:$IObit_ASC_INSTALL_LANGUAGE"

    # ...:: IObit Malware Fighter ::... #

    SendMessage $Lbl_Offer_IObit_Malware_Fighter_Title ${WM_SETTEXT} 0 "STR:$IObit_IMF_TITLE_LANGUAGE"
    SendMessage $Lbl_Offer_IObit_Malware_Fighter_SubTitle ${WM_SETTEXT} 0 "STR:$IObit_IMF_SUBTITLE_LANGUAGE"

    SendMessage $Link_Info_IMF ${WM_SETTEXT} 0 "STR:$IObit_MORE_INFO_LANGUAGE"
    SendMessage $Lbl_Yes_Install_IMF ${WM_SETTEXT} 0 "STR:$IObit_IMF_INSTALL_LANGUAGE"

    # ...:: IObit Unlocker ::... #

    SendMessage $Lbl_Offer_IObit_Unlocker_Title ${WM_SETTEXT} 0 "STR:$IObit_IUK_TITLE_LANGUAGE"
    SendMessage $Lbl_Offer_IObit_Unlocker_SubTitle ${WM_SETTEXT} 0 "STR:$IObit_IUK_SUBTITLE_LANGUAGE"

    SendMessage $Link_Info_IUK ${WM_SETTEXT} 0 "STR:$IObit_MORE_INFO_LANGUAGE"
    SendMessage $Lbl_Yes_Install_IUK ${WM_SETTEXT} 0 "STR:$IObit_IUK_INSTALL_LANGUAGE"

    # ...:: IObit Undelete ::... #

    SendMessage $Lbl_Offer_IObit_Undelete_Title ${WM_SETTEXT} 0 "STR:$IObit_IUD_TITLE_LANGUAGE"
    SendMessage $Lbl_Offer_IObit_Undelete_SubTitle ${WM_SETTEXT} 0 "STR:$IObit_IUD_SUBTITLE_LANGUAGE"

    SendMessage $Link_Info_IUD ${WM_SETTEXT} 0 "STR:$IObit_MORE_INFO_LANGUAGE"
    SendMessage $Lbl_Yes_Install_IUD ${WM_SETTEXT} 0 "STR:$IObit_IUD_INSTALL_LANGUAGE"

    # ...:: IObit PCtransfer ::... #

    SendMessage $Lbl_Offer_IObit_PCtransfer_Title ${WM_SETTEXT} 0 "STR:$IObit_IPC_TITLE_LANGUAGE"
    SendMessage $Lbl_Offer_IObit_PCtransfer_SubTitle ${WM_SETTEXT} 0 "STR:$IObit_IPC_SUBTITLE_LANGUAGE"

    SendMessage $Link_Info_IPC ${WM_SETTEXT} 0 "STR:$IObit_MORE_INFO_LANGUAGE"
    SendMessage $Lbl_Yes_Install_IPC ${WM_SETTEXT} 0 "STR:$IObit_IPC_INSTALL_LANGUAGE"

    # ...:: IObit Protect Folder ::... #

    SendMessage $Lbl_Offer_IObit_Protect_Folder_Title ${WM_SETTEXT} 0 "STR:$IObit_IPF_TITLE_LANGUAGE"
    SendMessage $Lbl_Offer_IObit_Protect_Folder_SubTitle ${WM_SETTEXT} 0 "STR:$IObit_IPF_SUBTITLE_LANGUAGE"

    SendMessage $Link_Info_IPF ${WM_SETTEXT} 0 "STR:$IObit_MORE_INFO_LANGUAGE"
    SendMessage $Lbl_Yes_Install_IPF ${WM_SETTEXT} 0 "STR:$IObit_IPF_INSTALL_LANGUAGE"

    ${ToolTip} $ICON_INFO_IU "$PLUGINSDIR\IObit_Uninstaller.ico" "IObit Uninstaller" "$IObit_IU_INFO_LANGUAGE"

    ${ToolTip} $ICON_INFO_DB "$PLUGINSDIR\IObit_Driver_Booster.ico" "IObit Driver Booster" "$IObit_DB_INFO_LANGUAGE"

    ${ToolTip} $ICON_INFO_SM "$PLUGINSDIR\IObit_Smart_Defrag.ico" "IObit Smart Defrag" "$IObit_SM_INFO_LANGUAGE"

    ${ToolTip} $ICON_INFO_ASC "$PLUGINSDIR\IObit_Advanced_System_Care.ico" "IObit Advanced SystemCare" "$IObit_ASC_INFO_LANGUAGE"

    ${ToolTip} $ICON_INFO_IMF "$PLUGINSDIR\IObit_Malware_Fighter.ico" "IObit Malware Fighter" "$IObit_IMF_INFO_LANGUAGE"

    ${ToolTip} $ICON_INFO_IUK "$PLUGINSDIR\IObit_Unlocker.ico" "IObit Unlocker" "$IObit_IUK_INFO_LANGUAGE"

    ${ToolTip} $ICON_INFO_IUD "$PLUGINSDIR\IObit_Undelete.ico" "IObit Undelete" "$IObit_IUD_INFO_LANGUAGE"

    ${ToolTip} $ICON_INFO_IPC "$PLUGINSDIR\IObit_PCTransfer.ico" "IObit PCtransfer" "$IObit_IPC_INFO_LANGUAGE"

    ${ToolTip} $ICON_INFO_IPF "$PLUGINSDIR\IObit_Protect_Folder.ico" "IObit Protect Folder" "$IObit_IPF_INFO_LANGUAGE"

  ${ElseIf} $locale_language_name == "0"

    Strcpy $LANGUAGEDIR "$EXEDIR\NSIS_TempDir\Language"

    ReadINIStr $IObit_RECOMMENDATION_LANGUAGE "$LANGUAGEDIR\English.ini" "IObit_Products" "IObit_Recommendation"
    ReadINIStr $IObit_RECOMMENDATION_INFO_LANGUAGE "$LANGUAGEDIR\English.ini" "IObit_Products" "IObit_Info_Recommendation"

    ReadINIStr $IObit_BUTTON_INSTALL_LANGUAGE "$LANGUAGEDIR\English.ini" "IObit_Products" "IObit_Button_Install"
    ReadINIStr $IObit_BUTTON_BACK_LANGUAGE "$LANGUAGEDIR\English.ini" "IObit_Products" "IObit_Button_Back"

    ReadINIStr $IObit_MORE_INFO_LANGUAGE "$LANGUAGEDIR\English.ini" "IObit_Products" "IObit_More_Info"

    ReadINIStr $IObit_AGREE_LICENSE_AGREEMENT_LANGUAGE "$LANGUAGEDIR\English.ini" "IObit_Products" "IObit_Agree_License_Agreement"

    ReadINIStr $IObit_IU_TITLE_LANGUAGE "$LANGUAGEDIR\English.ini" "IObit_Products" "IObit_Uninstaller_Title"
    ReadINIStr $IObit_IU_SUBTITLE_LANGUAGE "$LANGUAGEDIR\English.ini" "IObit_Products" "IObit_Uninstaller_SubTitle"
    ReadINIStr $IObit_IU_INFO_LANGUAGE "$LANGUAGEDIR\English.ini" "IObit_Products" "IObit_Uninstaller_Info"
    ReadINIStr $IObit_IU_INSTALL_LANGUAGE "$LANGUAGEDIR\English.ini" "IObit_Products" "IObit_Uninstaller_Accep"

    ReadINIStr $IObit_DB_TITLE_LANGUAGE "$LANGUAGEDIR\English.ini" "IObit_Products" "IObit_Driver_Booster_Title"
    ReadINIStr $IObit_DB_SUBTITLE_LANGUAGE "$LANGUAGEDIR\English.ini" "IObit_Products" "IObit_Driver_Booster_SubTitle"
    ReadINIStr $IObit_DB_INFO_LANGUAGE "$LANGUAGEDIR\English.ini" "IObit_Products" "IObit_Driver_Booster_Info"
    ReadINIStr $IObit_DB_INSTALL_LANGUAGE "$LANGUAGEDIR\English.ini" "IObit_Products" "IObit_Driver_Booster_Accept"

    ReadINIStr $IObit_SM_TITLE_LANGUAGE "$LANGUAGEDIR\English.ini" "IObit_Products" "IObit_Smart_Defrag_Title"
    ReadINIStr $IObit_SM_SUBTITLE_LANGUAGE "$LANGUAGEDIR\English.ini" "IObit_Products" "IObit_Smart_Defrag_SubTitle"
    ReadINIStr $IObit_SM_INFO_LANGUAGE "$LANGUAGEDIR\English.ini" "IObit_Products" "IObit_Smart_Defrag_Info"
    ReadINIStr $IObit_SM_INSTALL_LANGUAGE "$LANGUAGEDIR\English.ini" "IObit_Products" "IObit_Smart_Defrag_Accept"

    ReadINIStr $IObit_ASC_TITLE_LANGUAGE "$LANGUAGEDIR\English.ini" "IObit_Products" "IObit_Advanced_SystemCare_Title"
    ReadINIStr $IObit_ASC_SUBTITLE_LANGUAGE "$LANGUAGEDIR\English.ini" "IObit_Products" "IObit_Advanced_SystemCare_SubTitle"
    ReadINIStr $IObit_ASC_INFO_LANGUAGE "$LANGUAGEDIR\English.ini" "IObit_Products" "IObit_Advanced_SystemCare_Info"
    ReadINIStr $IObit_ASC_INSTALL_LANGUAGE "$LANGUAGEDIR\English.ini" "IObit_Products" "IObit_Advanced_SystemCare_Accept"

    ReadINIStr $IObit_IMF_TITLE_LANGUAGE "$LANGUAGEDIR\English.ini" "IObit_Products" "IObit_Malware_Fighter_Title"
    ReadINIStr $IObit_IMF_SUBTITLE_LANGUAGE "$LANGUAGEDIR\English.ini" "IObit_Products" "IObit_Malware_Fighter_SubTitle"
    ReadINIStr $IObit_IMF_INFO_LANGUAGE "$LANGUAGEDIR\English.ini" "IObit_Products" "IObit_Malware_Fighter_Info"
    ReadINIStr $IObit_IMF_INSTALL_LANGUAGE "$LANGUAGEDIR\English.ini" "IObit_Products" "IObit_Malware_Fighter_Accept"

    ReadINIStr $IObit_IUK_TITLE_LANGUAGE "$LANGUAGEDIR\English.ini" "IObit_Products" "IObit_Unlocker_Title"
    ReadINIStr $IObit_IUK_SUBTITLE_LANGUAGE "$LANGUAGEDIR\English.ini" "IObit_Products" "IObit_Unlocker_SubTitle"
    ReadINIStr $IObit_IUK_INFO_LANGUAGE "$LANGUAGEDIR\English.ini" "IObit_Products" "IObit_Unlocker_Info"
    ReadINIStr $IObit_IUK_INSTALL_LANGUAGE "$LANGUAGEDIR\English.ini" "IObit_Products" "IObit_Unlocker_Accept"

    ReadINIStr $IObit_IUD_TITLE_LANGUAGE "$LANGUAGEDIR\English.ini" "IObit_Products" "IObit_Undelete_Title"
    ReadINIStr $IObit_IUD_SUBTITLE_LANGUAGE "$LANGUAGEDIR\English.ini" "IObit_Products" "IObit_Undelete_SubTitle"
    ReadINIStr $IObit_IUD_INFO_LANGUAGE "$LANGUAGEDIR\English.ini" "IObit_Products" "IObit_Undelete_Info"
    ReadINIStr $IObit_IUD_INSTALL_LANGUAGE "$LANGUAGEDIR\English.ini" "IObit_Products" "IObit_Undelete_Accept"

    ReadINIStr $IObit_IPC_TITLE_LANGUAGE "$LANGUAGEDIR\English.ini" "IObit_Products" "IObit_PCtransfer_Title"
    ReadINIStr $IObit_IPC_SUBTITLE_LANGUAGE "$LANGUAGEDIR\English.ini" "IObit_Products" "IObit_PCtransfer_SubTitle"
    ReadINIStr $IObit_IPC_INFO_LANGUAGE "$LANGUAGEDIR\English.ini" "IObit_Products" "IObit_PCtransfer_Info"
    ReadINIStr $IObit_IPC_INSTALL_LANGUAGE "$LANGUAGEDIR\English.ini" "IObit_Products" "IObit_PCtransfer_Accept"

    ReadINIStr $IObit_IPF_TITLE_LANGUAGE "$LANGUAGEDIR\English.ini" "IObit_Products" "IObit_Protected_Folder_Title"
    ReadINIStr $IObit_IPF_SUBTITLE_LANGUAGE "$LANGUAGEDIR\English.ini" "IObit_Products" "IObit_Protected_Folder_SubTitle"
    ReadINIStr $IObit_IPF_INFO_LANGUAGE "$LANGUAGEDIR\English.ini" "IObit_Products" "IObit_Protected_Folder_Info"
    ReadINIStr $IObit_IPF_INSTALL_LANGUAGE "$LANGUAGEDIR\English.ini" "IObit_Products" "IObit_Protected_Folder_Accept"

    # IObit #

    SendMessage $Lbl_Recommendation ${WM_SETTEXT} 0 "STR:$IObit_RECOMMENDATION_LANGUAGE"
    SendMessage $Lbl_Welcome ${WM_SETTEXT} 0 "STR:$IObit_RECOMMENDATION_INFO_LANGUAGE"

    SendMessage $Btn_Install ${WM_SETTEXT} 0 "STR:$IObit_BUTTON_INSTALL_LANGUAGE"
    SendMessage $Btn_Back ${WM_SETTEXT} 0 "STR:$IObit_BUTTON_BACK_LANGUAGE"

    SendMessage $Lnk_Read_IObit_Eula ${WM_SETTEXT} 0 "STR:$IObit_AGREE_LICENSE_AGREEMENT_LANGUAGE"
    SendMessage $Lnk_Back_IObit_Offer ${WM_SETTEXT} 0 "STR:$IObit_BUTTON_BACK_LANGUAGE"

    # ...:: IObit Uninstaller ::... #

    SendMessage $Lbl_Offer_IObit_Uninstaller_Title ${WM_SETTEXT} 0 "STR:$IObit_IU_TITLE_LANGUAGE"
    SendMessage $Lbl_Offer_IObit_Uninstaller_SubTitle ${WM_SETTEXT} 0 "STR:$IObit_IU_SUBTITLE_LANGUAGE"

    SendMessage $Link_Info_IU ${WM_SETTEXT} 0 "STR:$IObit_MORE_INFO_LANGUAGE"
    SendMessage $Lbl_Yes_Install_IU ${WM_SETTEXT} 0 "STR:$IObit_IU_INSTALL_LANGUAGE"

    # ...:: IObit Driver Booster ::... #

    SendMessage $Lbl_Offer_IObit_Driver_Booster_Title ${WM_SETTEXT} 0 "STR:$IObit_DB_TITLE_LANGUAGE"
    SendMessage $Lbl_Offer_IObit_Driver_Booster_SubTitle ${WM_SETTEXT} 0 "STR:$IObit_DB_SUBTITLE_LANGUAGE"

    SendMessage $Link_Info_DB ${WM_SETTEXT} 0 "STR:$IObit_MORE_INFO_LANGUAGE"
    SendMessage $Lbl_Yes_Install_DB ${WM_SETTEXT} 0 "STR:$IObit_DB_INSTALL_LANGUAGE"

    # ...:: IObit Smart Defrag ::... #

    SendMessage $Lbl_Offer_IObit_Smart_Defrag_Title ${WM_SETTEXT} 0 "STR:$IObit_SM_TITLE_LANGUAGE"
    SendMessage $Lbl_Offer_IObit_Smart_Defrag_SubTitle ${WM_SETTEXT} 0 "STR:$IObit_SM_SUBTITLE_LANGUAGE"

    SendMessage $Link_Info_SM ${WM_SETTEXT} 0 "STR:$IObit_MORE_INFO_LANGUAGE"
    SendMessage $Lbl_Yes_Install_SM ${WM_SETTEXT} 0 "STR:$IObit_SM_INSTALL_LANGUAGE"

    # ...:: IObit Advanced SystemCare ::... #

    SendMessage $Lbl_Offer_IObit_Advanced_SystemCare_Title ${WM_SETTEXT} 0 "STR:$IObit_ASC_TITLE_LANGUAGE"
    SendMessage $Lbl_Offer_IObit_Advanced_SystemCare_SubTitle ${WM_SETTEXT} 0 "STR:$IObit_ASC_SUBTITLE_LANGUAGE"

    SendMessage $Link_Info_ASC ${WM_SETTEXT} 0 "STR:$IObit_MORE_INFO_LANGUAGE"
    SendMessage $Lbl_Yes_Install_ASC ${WM_SETTEXT} 0 "STR:$IObit_ASC_INSTALL_LANGUAGE"

    # ...:: IObit Malware Fighter ::... #

    SendMessage $Lbl_Offer_IObit_Malware_Fighter_Title ${WM_SETTEXT} 0 "STR:$IObit_IMF_TITLE_LANGUAGE"
    SendMessage $Lbl_Offer_IObit_Malware_Fighter_SubTitle ${WM_SETTEXT} 0 "STR:$IObit_IMF_SUBTITLE_LANGUAGE"

    SendMessage $Link_Info_IMF ${WM_SETTEXT} 0 "STR:$IObit_MORE_INFO_LANGUAGE"
    SendMessage $Lbl_Yes_Install_IMF ${WM_SETTEXT} 0 "STR:$IObit_IMF_INSTALL_LANGUAGE"

    # ...:: IObit Unlocker ::... #

    SendMessage $Lbl_Offer_IObit_Unlocker_Title ${WM_SETTEXT} 0 "STR:$IObit_IUK_TITLE_LANGUAGE"
    SendMessage $Lbl_Offer_IObit_Unlocker_SubTitle ${WM_SETTEXT} 0 "STR:$IObit_IUK_SUBTITLE_LANGUAGE"

    SendMessage $Link_Info_IUK ${WM_SETTEXT} 0 "STR:$IObit_MORE_INFO_LANGUAGE"
    SendMessage $Lbl_Yes_Install_IUK ${WM_SETTEXT} 0 "STR:$IObit_IUK_INSTALL_LANGUAGE"

    # ...:: IObit Undelete ::... #

    SendMessage $Lbl_Offer_IObit_Undelete_Title ${WM_SETTEXT} 0 "STR:$IObit_IUD_TITLE_LANGUAGE"
    SendMessage $Lbl_Offer_IObit_Undelete_SubTitle ${WM_SETTEXT} 0 "STR:$IObit_IUD_SUBTITLE_LANGUAGE"

    SendMessage $Link_Info_IUD ${WM_SETTEXT} 0 "STR:$IObit_MORE_INFO_LANGUAGE"
    SendMessage $Lbl_Yes_Install_IUD ${WM_SETTEXT} 0 "STR:$IObit_IUD_INSTALL_LANGUAGE"

    # ...:: IObit PCtransfer ::... #

    SendMessage $Lbl_Offer_IObit_PCtransfer_Title ${WM_SETTEXT} 0 "STR:$IObit_IPC_TITLE_LANGUAGE"
    SendMessage $Lbl_Offer_IObit_PCtransfer_SubTitle ${WM_SETTEXT} 0 "STR:$IObit_IPC_SUBTITLE_LANGUAGE"

    SendMessage $Link_Info_IPC ${WM_SETTEXT} 0 "STR:$IObit_MORE_INFO_LANGUAGE"
    SendMessage $Lbl_Yes_Install_IPC ${WM_SETTEXT} 0 "STR:$IObit_IPC_INSTALL_LANGUAGE"

    # ...:: IObit Protect Folder ::... #

    SendMessage $Lbl_Offer_IObit_Protect_Folder_Title ${WM_SETTEXT} 0 "STR:$IObit_IPF_TITLE_LANGUAGE"
    SendMessage $Lbl_Offer_IObit_Protect_Folder_SubTitle ${WM_SETTEXT} 0 "STR:$IObit_IPF_SUBTITLE_LANGUAGE"

    SendMessage $Link_Info_IPF ${WM_SETTEXT} 0 "STR:$IObit_MORE_INFO_LANGUAGE"
    SendMessage $Lbl_Yes_Install_IPF ${WM_SETTEXT} 0 "STR:$IObit_IPF_INSTALL_LANGUAGE"

    ${ToolTip} $ICON_INFO_IU "$PLUGINSDIR\IObit_Uninstaller.ico" "IObit Uninstaller" "$IObit_IU_INFO_LANGUAGE"

    ${ToolTip} $ICON_INFO_DB "$PLUGINSDIR\IObit_Driver_Booster.ico" "IObit Driver Booster" "$IObit_DB_INFO_LANGUAGE"

    ${ToolTip} $ICON_INFO_SM "$PLUGINSDIR\IObit_Smart_Defrag.ico" "IObit Smart Defrag" "$IObit_SM_INFO_LANGUAGE"

    ${ToolTip} $ICON_INFO_ASC "$PLUGINSDIR\IObit_Advanced_System_Care.ico" "IObit Advanced SystemCare" "$IObit_ASC_INFO_LANGUAGE"

    ${ToolTip} $ICON_INFO_IMF "$PLUGINSDIR\IObit_Malware_Fighter.ico" "IObit Malware Fighter" "$IObit_IMF_INFO_LANGUAGE"

    ${ToolTip} $ICON_INFO_IUK "$PLUGINSDIR\IObit_Unlocker.ico" "IObit Unlocker" "$IObit_IUK_INFO_LANGUAGE"

    ${ToolTip} $ICON_INFO_IUD "$PLUGINSDIR\IObit_Undelete.ico" "IObit Undelete" "$IObit_IUD_INFO_LANGUAGE"

    ${ToolTip} $ICON_INFO_IPC "$PLUGINSDIR\IObit_PCTransfer.ico" "IObit PCtransfer" "$IObit_IPC_INFO_LANGUAGE"

    ${ToolTip} $ICON_INFO_IPF "$PLUGINSDIR\IObit_Protect_Folder.ico" "IObit Protect Folder" "$IObit_IPF_INFO_LANGUAGE"

  ${EndIf}

  # ...:: BACKGROUND ::... #

  nsDialogs::CreateControl /NOUNLOAD STATIC 0x10000000|0x40000000|0x04000000|0x0000000E 0 0 0 100% 100% ""
  Pop $BGImage
  Push $0
  Push $R0
  StrCpy $R0 $BGImage
  System::Call "user32::LoadImage(i 0, ts, i 0, i0, i0, i0x0010) i.r0" "$PLUGINSDIR\005.bmp"
  SendMessage $R0 0x0172 0 $0
  Pop $R0
  Exch $0

  # ...:: Back ::... #

  GetFunctionAddress $0 "onGUICallback"
  WndProc::onCallback $HWNDPARENT $0
  WndProc::onCallback $BGImage $0

  nsDialogs::Show

  System::Call "user32::DestroyIcon(iR0)"
  System::Call 'user32::DestroyImage(iR0)'
  System::Call "gdi32::DeleteObject(i$R0)"
  System::Call 'user32::DestroyImage(i$R0)'
  Return
FunctionEnd

# IU #

Function ".onClick.IObit.Uninstaller"
  Pop $0
  Pop $1
  Pop $2
  ${If} $0 = $Link_Info_IU
    ${If} $1 = ${NM_CLICK}
      ${OrIf} $1 = ${NM_RETURN}
        System::Call `*$2(i,i,i,i,i.r3)`
        ${If} $3 == 0 ; link index
	  ExecShell "" "https://www.iobit.com/en/advanceduninstaller.php"
    	${EndIf}
    ${EndIf}
  ${EndIf}
FunctionEnd

# DB #

Function ".onClick.IObit.Driver.Booster"
  Pop $0
  Pop $1
  Pop $2
  ${If} $0 = $Link_Info_DB
    ${If} $1 = ${NM_CLICK}
      ${OrIf} $1 = ${NM_RETURN}
        System::Call `*$2(i,i,i,i,i.r3)`
        ${If} $3 == 0 ; link index
	  ExecShell "" "https://www.iobit.com/en/driver-booster.php"
    	${EndIf}
    ${EndIf}
  ${EndIf}
FunctionEnd

# SM #

Function ".onClick.IObit.Smart.Defrag"
  Pop $0
  Pop $1
  Pop $2
  ${If} $0 = $Link_Info_SM
    ${If} $1 = ${NM_CLICK}
      ${OrIf} $1 = ${NM_RETURN}
        System::Call `*$2(i,i,i,i,i.r3)`
        ${If} $3 == 0 ; link index
	  ExecShell "" "https://www.iobit.com/en/iobitsmartdefrag.php"
    	${EndIf}
    ${EndIf}
  ${EndIf}
FunctionEnd

# ASC #

Function ".onClick.IObit.Advanced.SystemCare"
  Pop $0
  Pop $1
  Pop $2
  ${If} $0 = $Link_Info_ASC
    ${If} $1 = ${NM_CLICK}
      ${OrIf} $1 = ${NM_RETURN}
        System::Call `*$2(i,i,i,i,i.r3)`
        ${If} $3 == 0 ; link index
	  ExecShell "" "https://www.iobit.com/en/advancedsystemcarefree.php"
    	${EndIf}
    ${EndIf}
  ${EndIf}
FunctionEnd

# IMF #

Function ".onClick.IObit.Malware.Fighter"
  Pop $0
  Pop $1
  Pop $2
  ${If} $0 = $Link_Info_IMF
    ${If} $1 = ${NM_CLICK}
      ${OrIf} $1 = ${NM_RETURN}
        System::Call `*$2(i,i,i,i,i.r3)`
        ${If} $3 == 0 ; link index
	  ExecShell "" "https://www.iobit.com/en/malware-fighter.php"
    	${EndIf}
    ${EndIf}
  ${EndIf}
FunctionEnd

# IUK #

Function ".onClick.IObit.Unlocker"
  Pop $0
  Pop $1
  Pop $2
  ${If} $0 = $Link_Info_IUK
    ${If} $1 = ${NM_CLICK}
      ${OrIf} $1 = ${NM_RETURN}
        System::Call `*$2(i,i,i,i,i.r3)`
        ${If} $3 == 0 ; link index
	  ExecShell "" "https://www.iobit.com/en/iobit-unlocker.php"
    	${EndIf}
    ${EndIf}
  ${EndIf}
FunctionEnd

# IUD #

Function ".onClick.IObit.Undelete"
  Pop $0
  Pop $1
  Pop $2
  ${If} $0 = $Link_Info_IUD
    ${If} $1 = ${NM_CLICK}
      ${OrIf} $1 = ${NM_RETURN}
        System::Call `*$2(i,i,i,i,i.r3)`
        ${If} $3 == 0 ; link index
	  ExecShell "" "https://www.iobit.com/en/iobitundelete.php"
    	${EndIf}
    ${EndIf}
  ${EndIf}
FunctionEnd

# IPC #

Function ".onClick.IObit.PCtransfer"
  Pop $0
  Pop $1
  Pop $2
  ${If} $0 = $Link_Info_IPC
    ${If} $1 = ${NM_CLICK}
      ${OrIf} $1 = ${NM_RETURN}
        System::Call `*$2(i,i,i,i,i.r3)`
        ${If} $3 == 0 ; link index
	  ExecShell "" "https://www.iobit.com/en/pctransfer.php"
    	${EndIf}
    ${EndIf}
  ${EndIf}
FunctionEnd

# IPF #

Function ".onClick.IObit.Protect.Folder"
  Pop $0
  Pop $1
  Pop $2
  ${If} $0 = $Link_Info_IPF
    ${If} $1 = ${NM_CLICK}
      ${OrIf} $1 = ${NM_RETURN}
        System::Call `*$2(i,i,i,i,i.r3)`
        ${If} $3 == 0 ; link index
	  ExecShell "" "https://www.iobit.com/en/password-protected-folder.php"
    	${EndIf}
    ${EndIf}
  ${EndIf}
FunctionEnd

# Eula IU #

Function "SkinBtn_Checked_Yes_Install_IU"
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_checkbox_checked.bmp $Ck_Yes_Install_IU
FunctionEnd

Function "SkinBtn_UnChecked_Yes_Install_IU"
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_checkbox_unchecked.bmp $Ck_Yes_Install_IU
FunctionEnd

Function ".onClick.Yes.Install.IU"
  ${If} $Bool_Yes_Install_IU == 1
     IntOp $Bool_Yes_Install_IU $Bool_Yes_Install_IU - 1
     Strcpy $1 $Ck_Yes_Install_IU
       Call "SkinBtn_UnChecked_Yes_Install_IU"

  ${Else}
     IntOp $Bool_Yes_Install_IU $Bool_Yes_Install_IU + 1
     Strcpy $1 $Ck_Yes_Install_IU
       Call "SkinBtn_Checked_Yes_Install_IU"

  ${EndIf}
FunctionEnd

# Eula DB #

Function "SkinBtn_Checked_Yes_Install_DB"
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_checkbox_checked.bmp $Ck_Yes_Install_DB
FunctionEnd

Function "SkinBtn_UnChecked_Yes_Install_DB"
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_checkbox_unchecked.bmp $Ck_Yes_Install_DB
FunctionEnd

Function ".onClick.Yes.Install.DB"
  ${If} $Bool_Yes_Install_DB == 1
     IntOp $Bool_Yes_Install_DB $Bool_Yes_Install_DB - 1
     Strcpy $1 $Ck_Yes_Install_DB
       Call "SkinBtn_UnChecked_Yes_Install_DB"

  ${Else}
     IntOp $Bool_Yes_Install_DB $Bool_Yes_Install_DB + 1
     Strcpy $1 $Ck_Yes_Install_DB
       Call "SkinBtn_Checked_Yes_Install_DB"

  ${EndIf}
FunctionEnd

# Eula SM #

Function "SkinBtn_Checked_Yes_Install_SM"
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_checkbox_checked.bmp $Ck_Yes_Install_SM
FunctionEnd

Function "SkinBtn_UnChecked_Yes_Install_SM"
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_checkbox_unchecked.bmp $Ck_Yes_Install_SM
FunctionEnd

Function ".onClick.Yes.Install.SM"
  ${If} $Bool_Yes_Install_SM == 1
     IntOp $Bool_Yes_Install_SM $Bool_Yes_Install_SM - 1
     Strcpy $1 $Ck_Yes_Install_SM
       Call "SkinBtn_UnChecked_Yes_Install_SM"

  ${Else}
     IntOp $Bool_Yes_Install_SM $Bool_Yes_Install_SM + 1
     Strcpy $1 $Ck_Yes_Install_SM
       Call "SkinBtn_Checked_Yes_Install_SM"

  ${EndIf}
FunctionEnd

# Eula ASC #

Function "SkinBtn_Checked_Yes_Install_ASC"
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_checkbox_checked.bmp $Ck_Yes_Install_ASC
FunctionEnd

Function "SkinBtn_UnChecked_Yes_Install_ASC"
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_checkbox_unchecked.bmp $Ck_Yes_Install_ASC
FunctionEnd

Function ".onClick.Yes.Install.ASC"
  ${If} $Bool_Yes_Install_ASC == 1
     IntOp $Bool_Yes_Install_ASC $Bool_Yes_Install_ASC - 1
     Strcpy $1 $Ck_Yes_Install_ASC
       Call "SkinBtn_UnChecked_Yes_Install_ASC"

  ${Else}
     IntOp $Bool_Yes_Install_ASC $Bool_Yes_Install_ASC + 1
     Strcpy $1 $Ck_Yes_Install_ASC
       Call "SkinBtn_Checked_Yes_Install_ASC"

  ${EndIf}
FunctionEnd

# Eula IMF #

Function "SkinBtn_Checked_Yes_Install_IMF"
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_checkbox_checked.bmp $Ck_Yes_Install_IMF
FunctionEnd

Function "SkinBtn_UnChecked_Yes_Install_IMF"
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_checkbox_unchecked.bmp $Ck_Yes_Install_IMF
FunctionEnd

Function ".onClick.Yes.Install.IMF"
  ${If} $Bool_Yes_Install_IMF == 1
     IntOp $Bool_Yes_Install_IMF $Bool_Yes_Install_IMF - 1
     Strcpy $1 $Ck_Yes_Install_IMF
       Call "SkinBtn_UnChecked_Yes_Install_IMF"

  ${Else}
     IntOp $Bool_Yes_Install_IMF $Bool_Yes_Install_IMF + 1
     Strcpy $1 $Ck_Yes_Install_IMF
       Call "SkinBtn_Checked_Yes_Install_IMF"

  ${EndIf}
FunctionEnd

# Eula IUK #

Function "SkinBtn_Checked_Yes_Install_IUK"
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_checkbox_checked.bmp $Ck_Yes_Install_IUK
FunctionEnd

Function "SkinBtn_UnChecked_Yes_Install_IUK"
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_checkbox_unchecked.bmp $Ck_Yes_Install_IUK
FunctionEnd

Function ".onClick.Yes.Install.IUK"
  ${If} $Bool_Yes_Install_IUK == 1
     IntOp $Bool_Yes_Install_IUK $Bool_Yes_Install_IUK - 1
     Strcpy $1 $Ck_Yes_Install_IUK
       Call "SkinBtn_UnChecked_Yes_Install_IUK"

  ${Else}
     IntOp $Bool_Yes_Install_IUK $Bool_Yes_Install_IUK + 1
     Strcpy $1 $Ck_Yes_Install_IUK
       Call "SkinBtn_Checked_Yes_Install_IUK"

  ${EndIf}
FunctionEnd

# Eula IUD #

Function "SkinBtn_Checked_Yes_Install_IUD"
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_checkbox_checked.bmp $Ck_Yes_Install_IUD
FunctionEnd

Function "SkinBtn_UnChecked_Yes_Install_IUD"
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_checkbox_unchecked.bmp $Ck_Yes_Install_IUD
FunctionEnd

Function ".onClick.Yes.Install.IUD"
  ${If} $Bool_Yes_Install_IUD == 1
     IntOp $Bool_Yes_Install_IUD $Bool_Yes_Install_IUD - 1
     Strcpy $1 $Ck_Yes_Install_IUD
       Call "SkinBtn_UnChecked_Yes_Install_IUD"

  ${Else}
     IntOp $Bool_Yes_Install_IUD $Bool_Yes_Install_IUD + 1
     Strcpy $1 $Ck_Yes_Install_IUD
       Call "SkinBtn_Checked_Yes_Install_IUD"

  ${EndIf}
FunctionEnd

# Eula IPC #

Function "SkinBtn_Checked_Yes_Install_IPC"
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_checkbox_checked.bmp $Ck_Yes_Install_IPC
FunctionEnd

Function "SkinBtn_UnChecked_Yes_Install_IPC"
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_checkbox_unchecked.bmp $Ck_Yes_Install_IPC
FunctionEnd

Function ".onClick.Yes.Install.IPC"
  ${If} $Bool_Yes_Install_IPC == 1
     IntOp $Bool_Yes_Install_IPC $Bool_Yes_Install_IPC - 1
     Strcpy $1 $Ck_Yes_Install_IPC
       Call "SkinBtn_UnChecked_Yes_Install_IPC"

  ${Else}
     IntOp $Bool_Yes_Install_IPC $Bool_Yes_Install_IPC + 1
     Strcpy $1 $Ck_Yes_Install_IPC
       Call "SkinBtn_Checked_Yes_Install_IPC"

  ${EndIf}
FunctionEnd

# Eula IPF #

Function "SkinBtn_Checked_Yes_Install_IPF"
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_checkbox_checked.bmp $Ck_Yes_Install_IPF
FunctionEnd

Function "SkinBtn_UnChecked_Yes_Install_IPF"
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_checkbox_unchecked.bmp $Ck_Yes_Install_IPF
FunctionEnd

Function ".onClick.Yes.Install.IPF"
  ${If} $Bool_Yes_Install_IPF == 1
     IntOp $Bool_Yes_Install_IPC $Bool_Yes_Install_IPF - 1
     Strcpy $1 $Ck_Yes_Install_IPF
       Call "SkinBtn_UnChecked_Yes_Install_IPF"

  ${Else}
     IntOp $Bool_Yes_Install_IPF $Bool_Yes_Install_IPF + 1
     Strcpy $1 $Ck_Yes_Install_IPF
       Call "SkinBtn_Checked_Yes_Install_IPF"

  ${EndIf}
FunctionEnd

Function ".onClick.Read.IObit.Eula"
  Pop $0
  Pop $1
  Pop $2
  ${If} $0 = $Lnk_Read_IObit_Eula
    ${If} $1 = ${NM_CLICK}
    	${OrIf} $1 = ${NM_RETURN}
        System::Call `*$2(i,i,i,i,i.r3)`
        ${If} $3 == 0 ; link index
	   Call ".onClick.Read.IObit.License"
        ${Else}
	  ExecShell "Open" "https://www.iobit.com/en/privacy.php"
    	${EndIf}
    ${EndIf}
  ${EndIf}
FunctionEnd

Function ".onClick.Read.IObit.License"
  ShowWindow $Lnk_Read_IObit_Eula ${SW_HIDE}
  ShowWindow $Ck_IObit_Page_1 ${SW_HIDE}
  ShowWindow $Ck_IObit_Page_2 ${SW_HIDE}
  ShowWindow $Ck_IObit_Page_3 ${SW_HIDE}
  ShowWindow $Lnk_Back_IObit_Offer ${SW_SHOW}
  ShowWindow $IOBITLICENSEAGREEMENTCONTROL ${SW_SHOW}
FunctionEnd

Function ".onClick.Back.IObit.Offer"
  ShowWindow $Lnk_Read_IObit_Eula ${SW_SHOW}
  ShowWindow $Ck_IObit_Page_1 ${SW_SHOW}
  ShowWindow $Ck_IObit_Page_2 ${SW_SHOW}
  ShowWindow $Ck_IObit_Page_3 ${SW_SHOW}
  ShowWindow $IOBITLICENSEAGREEMENTCONTROL ${SW_HIDE}
  ShowWindow $Lnk_Back_IObit_Offer ${SW_HIDE}
FunctionEnd

# Page 1 #

Function "SkinBtn_Checked_IObit_Page_1"
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_radiobutton_check.bmp $Ck_IObit_Page_1
FunctionEnd

Function "SkinBtn_UnChecked_IObit_Page_1"
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_radiobutton_uncheck.bmp $Ck_IObit_Page_1
FunctionEnd

Function ".onClick.IObit.Page.1"
  System::Call "user32::InvalidateRect(i,i,i)i ($Ck_IObit_Page_3, 0, 1)"
  Call "SkinBtn_UnChecked_IObit_Page_3"
  System::Call "user32::RedrawWindow(i,i,i,i)i ($Ck_IObit_Page_3, 0, 0, ${RDW_INVALIDATE}|${RDW_ERASE}|${RDW_UPDATENOW})"

  System::Call "user32::InvalidateRect(i,i,i)i ($Ck_IObit_Page_2, 0, 1)"
  Call "SkinBtn_UnChecked_IObit_Page_2"
  System::Call "user32::RedrawWindow(i,i,i,i)i ($Ck_IObit_Page_2, 0, 0, ${RDW_INVALIDATE}|${RDW_ERASE}|${RDW_UPDATENOW})"

  System::Call "user32::InvalidateRect(i,i,i)i ($Ck_IObit_Page_1, 0, 1)"
  Call "SkinBtn_Checked_IObit_Page_1"
  System::Call "user32::RedrawWindow(i,i,i,i)i ($Ck_IObit_Page_1, 0, 0, ${RDW_INVALIDATE}|${RDW_ERASE}|${RDW_UPDATENOW})"

  # Page 3 #

  # IObit Undelete #

  ShowWindow $ICON_IUD ${SW_HIDE}
  ShowWindow $Link_Info_IUD ${SW_HIDE}
  ShowWindow $ICON_INFO_IUD ${SW_HIDE}

  ShowWindow $Lbl_Offer_IObit_Undelete_Title ${SW_HIDE}
  ShowWindow $Lbl_Offer_IObit_Undelete_SubTitle ${SW_HIDE}

  ShowWindow $Ck_Yes_Install_IUD ${SW_HIDE}
  ShowWindow $Lbl_Yes_Install_IUD ${SW_HIDE}

  # IObit PCtransfer #

  ShowWindow $ICON_IPC ${SW_HIDE}
  ShowWindow $Link_Info_IPC ${SW_HIDE}
  ShowWindow $ICON_INFO_IPC ${SW_HIDE}

  ShowWindow $Lbl_Offer_IObit_PCtransfer_Title ${SW_HIDE}
  ShowWindow $Lbl_Offer_IObit_PCtransfer_SubTitle ${SW_HIDE}

  ShowWindow $Ck_Yes_Install_IPC ${SW_HIDE}
  ShowWindow $Lbl_Yes_Install_IPC ${SW_HIDE}

  # IObit Protect Folder #

  ShowWindow $ICON_IPF ${SW_HIDE}
  ShowWindow $Link_Info_IPF ${SW_HIDE}
  ShowWindow $ICON_INFO_IPF ${SW_HIDE}

  ShowWindow $Lbl_Offer_IObit_Protect_Folder_Title ${SW_HIDE}
  ShowWindow $Lbl_Offer_IObit_Protect_Folder_SubTitle ${SW_HIDE}

  ShowWindow $Ck_Yes_Install_IPF ${SW_HIDE}
  ShowWindow $Lbl_Yes_Install_IPF ${SW_HIDE}

  # Page 2 #

  # IObit Advanced SystemCare #

  ShowWindow $ICON_ASC ${SW_HIDE}
  ShowWindow $Link_Info_ASC ${SW_HIDE}
  ShowWindow $ICON_INFO_ASC ${SW_HIDE}

  ShowWindow $Lbl_Offer_IObit_Advanced_SystemCare_Title ${SW_HIDE}
  ShowWindow $Lbl_Offer_IObit_Advanced_SystemCare_SubTitle ${SW_HIDE}

  ShowWindow $Ck_Yes_Install_ASC ${SW_HIDE}
  ShowWindow $Lbl_Yes_Install_ASC ${SW_HIDE}

  # IObit Malware Fighter #

  ShowWindow $ICON_IMF ${SW_HIDE}
  ShowWindow $Link_Info_IMF ${SW_HIDE}
  ShowWindow $ICON_INFO_IMF ${SW_HIDE}

  ShowWindow $Lbl_Offer_IObit_Malware_Fighter_Title ${SW_HIDE}
  ShowWindow $Lbl_Offer_IObit_Malware_Fighter_SubTitle ${SW_HIDE}

  ShowWindow $Ck_Yes_Install_IMF ${SW_HIDE}
  ShowWindow $Lbl_Yes_Install_IMF ${SW_HIDE}

  # IObit Unlocker #

  ShowWindow $ICON_IUK ${SW_HIDE}
  ShowWindow $Link_Info_IUK ${SW_HIDE}
  ShowWindow $ICON_INFO_IUK ${SW_HIDE}

  ShowWindow $Lbl_Offer_IObit_Unlocker_Title ${SW_HIDE}
  ShowWindow $Lbl_Offer_IObit_Unlocker_SubTitle ${SW_HIDE}

  ShowWindow $Ck_Yes_Install_IUK ${SW_HIDE}
  ShowWindow $Lbl_Yes_Install_IUK ${SW_HIDE}

  # Page 1 #

  # IObit Uinstaller #

  ShowWindow $ICON_IU ${SW_SHOW}
  ShowWindow $Link_Info_IU ${SW_SHOW}
  ShowWindow $ICON_INFO_IU ${SW_SHOW}

  ShowWindow $Lbl_Offer_IObit_Uninstaller_Title ${SW_SHOW}
  ShowWindow $Lbl_Offer_IObit_Uninstaller_SubTitle ${SW_SHOW}

  ShowWindow $Ck_Yes_Install_IU ${SW_SHOW}
  ShowWindow $Lbl_Yes_Install_IU ${SW_SHOW}

  # IObit Driver Booster #

  ShowWindow $ICON_DB ${SW_SHOW}
  ShowWindow $Link_Info_DB ${SW_SHOW}
  ShowWindow $ICON_INFO_DB ${SW_SHOW}

  ShowWindow $Lbl_Offer_IObit_Driver_Booster_Title ${SW_SHOW}
  ShowWindow $Lbl_Offer_IObit_Driver_Booster_SubTitle ${SW_SHOW}

  ShowWindow $Ck_Yes_Install_DB ${SW_SHOW}
  ShowWindow $Lbl_Yes_Install_DB ${SW_SHOW}

  # IObit Smart Defrag #

  ShowWindow $ICON_SM ${SW_SHOW}
  ShowWindow $Link_Info_SM ${SW_SHOW}
  ShowWindow $ICON_INFO_SM ${SW_SHOW}

  ShowWindow $Lbl_Offer_IObit_Smart_Defrag_Title ${SW_SHOW}
  ShowWindow $Lbl_Offer_IObit_Smart_Defrag_SubTitle ${SW_SHOW}

  ShowWindow $Ck_Yes_Install_SM ${SW_SHOW}
  ShowWindow $Lbl_Yes_Install_SM ${SW_SHOW}

FunctionEnd

# Page 2 #

Function "SkinBtn_Checked_IObit_Page_2"
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_radiobutton_check.bmp $Ck_IObit_Page_2
FunctionEnd

Function "SkinBtn_UnChecked_IObit_Page_2"
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_radiobutton_uncheck.bmp $Ck_IObit_Page_2
FunctionEnd

Function ".onClick.IObit.Page.2"
  System::Call "user32::InvalidateRect(i,i,i)i ($Ck_IObit_Page_3, 0, 1)"
  Call "SkinBtn_UnChecked_IObit_Page_3"
  System::Call "user32::RedrawWindow(i,i,i,i)i ($Ck_IObit_Page_3, 0, 0, ${RDW_INVALIDATE}|${RDW_ERASE}|${RDW_UPDATENOW})"

  System::Call "user32::InvalidateRect(i,i,i)i ($Ck_IObit_Page_1, 0, 1)"
  Call "SkinBtn_UnChecked_IObit_Page_1"
  System::Call "user32::RedrawWindow(i,i,i,i)i ($Ck_IObit_Page_1, 0, 0, ${RDW_INVALIDATE}|${RDW_ERASE}|${RDW_UPDATENOW})"

  System::Call "user32::InvalidateRect(i,i,i)i ($Ck_IObit_Page_2, 0, 1)"
  Call "SkinBtn_Checked_IObit_Page_2"
  System::Call "user32::RedrawWindow(i,i,i,i)i ($Ck_IObit_Page_2, 0, 0, ${RDW_INVALIDATE}|${RDW_ERASE}|${RDW_UPDATENOW})"

  # Page 3 #

  # IObit Undelete #

  ShowWindow $ICON_IUD ${SW_HIDE}
  ShowWindow $Link_Info_IUD ${SW_HIDE}
  ShowWindow $ICON_INFO_IUD ${SW_HIDE}

  ShowWindow $Lbl_Offer_IObit_Undelete_Title ${SW_HIDE}
  ShowWindow $Lbl_Offer_IObit_Undelete_SubTitle ${SW_HIDE}

  ShowWindow $Ck_Yes_Install_IUD ${SW_HIDE}
  ShowWindow $Lbl_Yes_Install_IUD ${SW_HIDE}

  # IObit PCtransfer #

  ShowWindow $ICON_IPC ${SW_HIDE}
  ShowWindow $Link_Info_IPC ${SW_HIDE}
  ShowWindow $ICON_INFO_IPC ${SW_HIDE}

  ShowWindow $Lbl_Offer_IObit_PCtransfer_Title ${SW_HIDE}
  ShowWindow $Lbl_Offer_IObit_PCtransfer_SubTitle ${SW_HIDE}

  ShowWindow $Ck_Yes_Install_IPC ${SW_HIDE}
  ShowWindow $Lbl_Yes_Install_IPC ${SW_HIDE}

  # IObit Protect Folder #

  ShowWindow $ICON_IPF ${SW_HIDE}
  ShowWindow $Link_Info_IPF ${SW_HIDE}
  ShowWindow $ICON_INFO_IPF ${SW_HIDE}

  ShowWindow $Lbl_Offer_IObit_Protect_Folder_Title ${SW_HIDE}
  ShowWindow $Lbl_Offer_IObit_Protect_Folder_SubTitle ${SW_HIDE}

  ShowWindow $Ck_Yes_Install_IPF ${SW_HIDE}
  ShowWindow $Lbl_Yes_Install_IPF ${SW_HIDE}

  # Page 1 #

  # IObit Uinstaller #

  ShowWindow $ICON_IU ${SW_HIDE}
  ShowWindow $Link_Info_IU ${SW_HIDE}
  ShowWindow $ICON_INFO_IU ${SW_HIDE}

  ShowWindow $Lbl_Offer_IObit_Uninstaller_Title ${SW_HIDE}
  ShowWindow $Lbl_Offer_IObit_Uninstaller_SubTitle ${SW_HIDE}

  ShowWindow $Ck_Yes_Install_IU ${SW_HIDE}
  ShowWindow $Lbl_Yes_Install_IU ${SW_HIDE}

  # IObit Driver Booster #

  ShowWindow $ICON_DB ${SW_HIDE}
  ShowWindow $Link_Info_DB ${SW_HIDE}
  ShowWindow $ICON_INFO_DB ${SW_HIDE}

  ShowWindow $Lbl_Offer_IObit_Driver_Booster_Title ${SW_HIDE}
  ShowWindow $Lbl_Offer_IObit_Driver_Booster_SubTitle ${SW_HIDE}

  ShowWindow $Ck_Yes_Install_DB ${SW_HIDE}
  ShowWindow $Lbl_Yes_Install_DB ${SW_HIDE}

  # IObit Smart Defrag #

  ShowWindow $ICON_SM ${SW_HIDE}
  ShowWindow $Link_Info_SM ${SW_HIDE}
  ShowWindow $ICON_INFO_SM ${SW_HIDE}

  ShowWindow $Lbl_Offer_IObit_Smart_Defrag_Title ${SW_HIDE}
  ShowWindow $Lbl_Offer_IObit_Smart_Defrag_SubTitle ${SW_HIDE}

  ShowWindow $Ck_Yes_Install_SM ${SW_HIDE}
  ShowWindow $Lbl_Yes_Install_SM ${SW_HIDE}

  # Page 2 #

  # IObit Advanced SystemCare #

  ShowWindow $ICON_ASC ${SW_SHOW}
  ShowWindow $Link_Info_ASC ${SW_SHOW}
  ShowWindow $ICON_INFO_ASC ${SW_SHOW}

  ShowWindow $Lbl_Offer_IObit_Advanced_SystemCare_Title ${SW_SHOW}
  ShowWindow $Lbl_Offer_IObit_Advanced_SystemCare_SubTitle ${SW_SHOW}

  ShowWindow $Ck_Yes_Install_ASC ${SW_SHOW}
  ShowWindow $Lbl_Yes_Install_ASC ${SW_SHOW}

  # IObit Malware Fighter #

  ShowWindow $ICON_IMF ${SW_SHOW}
  ShowWindow $Link_Info_IMF ${SW_SHOW}
  ShowWindow $ICON_INFO_IMF ${SW_SHOW}

  ShowWindow $Lbl_Offer_IObit_Malware_Fighter_Title ${SW_SHOW}
  ShowWindow $Lbl_Offer_IObit_Malware_Fighter_SubTitle ${SW_SHOW}

  ShowWindow $Ck_Yes_Install_IMF ${SW_SHOW}
  ShowWindow $Lbl_Yes_Install_IMF ${SW_SHOW}

  # IObit Unlocker #

  ShowWindow $ICON_IUK ${SW_SHOW}
  ShowWindow $Link_Info_IUK ${SW_SHOW}
  ShowWindow $ICON_INFO_IUK ${SW_SHOW}

  ShowWindow $Lbl_Offer_IObit_Unlocker_Title ${SW_SHOW}
  ShowWindow $Lbl_Offer_IObit_Unlocker_SubTitle ${SW_SHOW}

  ShowWindow $Ck_Yes_Install_IUK ${SW_SHOW}
  ShowWindow $Lbl_Yes_Install_IUK ${SW_SHOW}

FunctionEnd

# Page 3 #

Function "SkinBtn_Checked_IObit_Page_3"
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_radiobutton_check.bmp $Ck_IObit_Page_3
FunctionEnd

Function "SkinBtn_UnChecked_IObit_Page_3"
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_radiobutton_uncheck.bmp $Ck_IObit_Page_3
FunctionEnd

Function ".onClick.IObit.Page.3"
  System::Call "user32::InvalidateRect(i,i,i)i ($Ck_IObit_Page_1, 0, 1)"
  Call "SkinBtn_UnChecked_IObit_Page_1"
  System::Call "user32::RedrawWindow(i,i,i,i)i ($Ck_IObit_Page_1, 0, 0, ${RDW_INVALIDATE}|${RDW_ERASE}|${RDW_UPDATENOW})"

  System::Call "user32::InvalidateRect(i,i,i)i ($Ck_IObit_Page_2, 0, 1)"
  Call "SkinBtn_UnChecked_IObit_Page_2"
  System::Call "user32::RedrawWindow(i,i,i,i)i ($Ck_IObit_Page_2, 0, 0, ${RDW_INVALIDATE}|${RDW_ERASE}|${RDW_UPDATENOW})"

  System::Call "user32::InvalidateRect(i,i,i)i ($Ck_IObit_Page_3, 0, 1)"
  Call "SkinBtn_Checked_IObit_Page_3"
  System::Call "user32::RedrawWindow(i,i,i,i)i ($Ck_IObit_Page_3, 0, 0, ${RDW_INVALIDATE}|${RDW_ERASE}|${RDW_UPDATENOW})"

  # Page 1 #

  # IObit Uinstaller #

  ShowWindow $ICON_IU ${SW_HIDE}
  ShowWindow $Link_Info_IU ${SW_HIDE}
  ShowWindow $ICON_INFO_IU ${SW_HIDE}

  ShowWindow $Lbl_Offer_IObit_Uninstaller_Title ${SW_HIDE}
  ShowWindow $Lbl_Offer_IObit_Uninstaller_SubTitle ${SW_HIDE}

  ShowWindow $Ck_Yes_Install_IU ${SW_HIDE}
  ShowWindow $Lbl_Yes_Install_IU ${SW_HIDE}

  # IObit Driver Booster #

  ShowWindow $ICON_DB ${SW_HIDE}
  ShowWindow $Link_Info_DB ${SW_HIDE}
  ShowWindow $ICON_INFO_DB ${SW_HIDE}

  ShowWindow $Lbl_Offer_IObit_Driver_Booster_Title ${SW_HIDE}
  ShowWindow $Lbl_Offer_IObit_Driver_Booster_SubTitle ${SW_HIDE}

  ShowWindow $Ck_Yes_Install_DB ${SW_HIDE}
  ShowWindow $Lbl_Yes_Install_DB ${SW_HIDE}

  # IObit Smart Defrag #

  ShowWindow $ICON_SM ${SW_HIDE}
  ShowWindow $Link_Info_SM ${SW_HIDE}
  ShowWindow $ICON_INFO_SM ${SW_HIDE}

  ShowWindow $Lbl_Offer_IObit_Smart_Defrag_Title ${SW_HIDE}
  ShowWindow $Lbl_Offer_IObit_Smart_Defrag_SubTitle ${SW_HIDE}

  ShowWindow $Ck_Yes_Install_SM ${SW_HIDE}
  ShowWindow $Lbl_Yes_Install_SM ${SW_HIDE}

  # Page 2 #

  # IObit Advanced SystemCare #

  ShowWindow $ICON_ASC ${SW_HIDE}
  ShowWindow $Link_Info_ASC ${SW_HIDE}
  ShowWindow $ICON_INFO_ASC ${SW_HIDE}

  ShowWindow $Lbl_Offer_IObit_Advanced_SystemCare_Title ${SW_HIDE}
  ShowWindow $Lbl_Offer_IObit_Advanced_SystemCare_SubTitle ${SW_HIDE}

  ShowWindow $Ck_Yes_Install_ASC ${SW_HIDE}
  ShowWindow $Lbl_Yes_Install_ASC ${SW_HIDE}

  # IObit Malware Fighter #

  ShowWindow $ICON_IMF ${SW_HIDE}
  ShowWindow $Link_Info_IMF ${SW_HIDE}
  ShowWindow $ICON_INFO_IMF ${SW_HIDE}

  ShowWindow $Lbl_Offer_IObit_Malware_Fighter_Title ${SW_HIDE}
  ShowWindow $Lbl_Offer_IObit_Malware_Fighter_SubTitle ${SW_HIDE}

  ShowWindow $Ck_Yes_Install_IMF ${SW_HIDE}
  ShowWindow $Lbl_Yes_Install_IMF ${SW_HIDE}

  # IObit Unlocker #

  ShowWindow $ICON_IUK ${SW_HIDE}
  ShowWindow $Link_Info_IUK ${SW_HIDE}
  ShowWindow $ICON_INFO_IUK ${SW_HIDE}

  ShowWindow $Lbl_Offer_IObit_Unlocker_Title ${SW_HIDE}
  ShowWindow $Lbl_Offer_IObit_Unlocker_SubTitle ${SW_HIDE}

  ShowWindow $Ck_Yes_Install_IUK ${SW_HIDE}
  ShowWindow $Lbl_Yes_Install_IUK ${SW_HIDE}

  # Page 3 #

  # IObit Undelete #

  ShowWindow $ICON_IUD ${SW_SHOW}
  ShowWindow $Link_Info_IUD ${SW_SHOW}
  ShowWindow $ICON_INFO_IUD ${SW_SHOW}

  ShowWindow $Lbl_Offer_IObit_Undelete_Title ${SW_SHOW}
  ShowWindow $Lbl_Offer_IObit_Undelete_SubTitle ${SW_SHOW}

  ShowWindow $Ck_Yes_Install_IUD ${SW_SHOW}
  ShowWindow $Lbl_Yes_Install_IUD ${SW_SHOW}

  # IObit PCtransfer #

  ShowWindow $ICON_IPC ${SW_SHOW}
  ShowWindow $Link_Info_IPC ${SW_SHOW}
  ShowWindow $ICON_INFO_IPC ${SW_SHOW}

  ShowWindow $Lbl_Offer_IObit_PCtransfer_Title ${SW_SHOW}
  ShowWindow $Lbl_Offer_IObit_PCtransfer_SubTitle ${SW_SHOW}

  ShowWindow $Ck_Yes_Install_IPC ${SW_SHOW}
  ShowWindow $Lbl_Yes_Install_IPC ${SW_SHOW}

  # IObit Protect Folder #

  ShowWindow $ICON_IPF ${SW_SHOW}
  ShowWindow $Link_Info_IPF ${SW_SHOW}
  ShowWindow $ICON_INFO_IPF ${SW_SHOW}

  ShowWindow $Lbl_Offer_IObit_Protect_Folder_Title ${SW_SHOW}
  ShowWindow $Lbl_Offer_IObit_Protect_Folder_SubTitle ${SW_SHOW}

  ShowWindow $Ck_Yes_Install_IPF ${SW_SHOW}
  ShowWindow $Lbl_Yes_Install_IPF ${SW_SHOW}

FunctionEnd

# Back #

Function ".onClick.Back"
  SendMessage $HWNDPARENT "0x408" "-1" "0"
FunctionEnd

# ...:: Language ::... #

# ENGLISH #

!define LANGSTRING_BUTTON_INSTALL_1033 "Install"
!define LANGSTRING_BUTTON_CUSTOM_INSTALL_1033 "Custom"
!define LANGSTRING_LNK_LICENSE_1033 "Licene Agreement"
!define LANGSTRING_CK_LICENSE_1033 "Yes Accept"

!define LANGSTRING_BUTTON_BROWSE_1033 "Browse"

!define LANGSTRING_REQUIRED_SPACE_1033 "Required Space: $ESTIM.INST.SIZE"
!define LANGSTRING_TOTAL_SPACE_1033 "Total Space: $SPACE.TOTAL $1"

!define LANGSTRING_CK_SHORTCUT_1033 "Create desktop icon"
!define LANGSTRING_CK_LAUNCH_1033 "Launch after install"
!define LANGSTRING_CK_TASKBAR_1033 "Pin icon to taskbar"
!define LANGSTRING_CK_WEBSITE_1033 "Visit program website"

!define LANGSTRING_WELCOME_1033 "Nullsoft Installer"

# Close #

!define LANGSTRING_QUIT_WARNING_1033 "Warning!"
!define LANGSTRING_QUIT_MESSAGE_1_1033 "Setup is not complete. If you close now, NSIS will not be installed."
!define LANGSTRING_QUIT_MESSAGE_2_1033 "Are you sure you want to close?"
!define LANGSTRING_QUIT_BUTTON_YES_1033 "Yes"
!define LANGSTRING_QUIT_BUTTON_NO_1033 "No"

# ROMANIAN #

!define LANGSTRING_BUTTON_INSTALL_1048 "Instalare"
!define LANGSTRING_BUTTON_CUSTOM_INSTALL_1048 "Personalizat"
!define LANGSTRING_LNK_LICENSE_1048 "Acordul de licent„"
!define LANGSTRING_CK_LICENSE_1048 "Da Accept"

!define LANGSTRING_BUTTON_BROWSE_1048 "Caut„"

!define LANGSTRING_REQUIRED_SPACE_1048 "Spatiu Recomandat: $ESTIM.INST.SIZE"
!define LANGSTRING_TOTAL_SPACE_1048 "Spatiul Total: $SPACE.TOTAL $1"

!define LANGSTRING_CK_SHORTCUT_1048 "Creaz„ o iconit„ pe desktop"
!define LANGSTRING_CK_LAUNCH_1048 "Lanseaz„ dup„ instalare"
!define LANGSTRING_CK_TASKBAR_1048 "Fixeaz„ Ón bara de activit„ti"
!define LANGSTRING_CK_WEBSITE_1048 "Viziteaz„ site-ul web"

!define LANGSTRING_WELCOME_1048 "Nullsoft Installer"

# Close #

!define LANGSTRING_QUIT_WARNING_1048 "Atentie!"
!define LANGSTRING_QUIT_MESSAGE_1_1048 "Configurarea nu este complet„. Dac„ Ónchideti acum, NSIS nu va fi instalat."
!define LANGSTRING_QUIT_MESSAGE_2_1048 "Esti sigur c„ doresti s„ Ónchizi acum?"
!define LANGSTRING_QUIT_BUTTON_YES_1048 "Da"
!define LANGSTRING_QUIT_BUTTON_NO_1048 "Nu"

# Variables #

var /GLOBAL LANGSTRING_BUTTON_INSTALL
var /GLOBAL LANGSTRING_BUTTON_CUSTOM_INSTALL
var /GLOBAL LANGSTRING_LNK_LICENSE
var /GLOBAL LANGSTRING_CK_LICENSE

var /GLOBAL LANGSTRING_BUTTON_BROWSE

var /GLOBAL LANGSTRING_REQUIRED_SPACE
var /GLOBAL LANGSTRING_TOTAL_SPACE

var /GLOBAL LANGSTRING_CK_SHORTCUT
var /GLOBAL LANGSTRING_CK_LAUNCH
var /GLOBAL LANGSTRING_CK_TASKBAR
var /GLOBAL LANGSTRING_CK_WEBSITE

var /GLOBAL LANGSTRING_WELCOME

# Close #

var /GLOBAL LANGSTRING_QUIT_WARNING
var /GLOBAL LANGSTRING_QUIT_MESSAGE_1
var /GLOBAL LANGSTRING_QUIT_MESSAGE_2
var /GLOBAL LANGSTRING_QUIT_BUTTON_YES
var /GLOBAL LANGSTRING_QUIT_BUTTON_NO

!macro __NSD_CB_GetSelection CONTROL VAR

    Push $0
    SendMessage ${CONTROL} ${CB_GETCURSEL} 0 0 $0
    System::Alloc ${NSIS_MAX_STRLEN}
    System::Call 'user32::SendMessage(i ${CONTROL}, i ${CB_GETLBTEXT}, i r0, i ss)'
    Pop $0
    System::Call '*$0(&t${NSIS_MAX_STRLEN}.s)'
    System::Free $0
    Exch
    Pop $0
    Pop ${VAR}

!macroend

!define NSD_CB_GetSelection `!insertmacro __NSD_CB_GetSelection`

Function GetSelectedLang

    !macro SetPageStrings LANGID

      StrCpy $LANGSTRING_BUTTON_INSTALL "${LANGSTRING_BUTTON_INSTALL_${LANGID}}"
      StrCpy $LANGSTRING_BUTTON_CUSTOM_INSTALL "${LANGSTRING_BUTTON_CUSTOM_INSTALL_${LANGID}}"
      StrCpy $LANGSTRING_LNK_LICENSE "${LANGSTRING_LNK_LICENSE_${LANGID}}"
      StrCpy $LANGSTRING_CK_LICENSE "${LANGSTRING_CK_LICENSE_${LANGID}}"

      StrCpy $LANGSTRING_BUTTON_BROWSE "${LANGSTRING_BUTTON_BROWSE_${LANGID}}"

      StrCpy $LANGSTRING_REQUIRED_SPACE "${LANGSTRING_REQUIRED_SPACE_${LANGID}}"
      StrCpy $LANGSTRING_TOTAL_SPACE "${LANGSTRING_TOTAL_SPACE_${LANGID}}"

      StrCpy $LANGSTRING_CK_SHORTCUT "${LANGSTRING_CK_SHORTCUT_${LANGID}}"
      StrCpy $LANGSTRING_CK_LAUNCH "${LANGSTRING_CK_LAUNCH_${LANGID}}"
      StrCpy $LANGSTRING_CK_TASKBAR "${LANGSTRING_CK_TASKBAR_${LANGID}}"
      StrCpy $LANGSTRING_CK_WEBSITE "${LANGSTRING_CK_WEBSITE_${LANGID}}"

      StrCpy $LANGSTRING_WELCOME "${LANGSTRING_WELCOME_${LANGID}}"

      # Close #

      StrCpy $LANGSTRING_QUIT_WARNING "${LANGSTRING_QUIT_WARNING_${LANGID}}"
      StrCpy $LANGSTRING_QUIT_MESSAGE_1 "${LANGSTRING_QUIT_MESSAGE_1_${LANGID}}"
      StrCpy $LANGSTRING_QUIT_MESSAGE_2 "${LANGSTRING_QUIT_MESSAGE_2_${LANGID}}"
      StrCpy $LANGSTRING_QUIT_BUTTON_YES "${LANGSTRING_QUIT_BUTTON_YES_${LANGID}}"
      StrCpy $LANGSTRING_QUIT_BUTTON_NO "${LANGSTRING_QUIT_BUTTON_NO_${LANGID}}"

    !macroend

    ${NSD_CB_GetSelection} $DropList $LANNAME

    ${Select} $LANNAME
      ${Case} $ENGLISH
        !insertmacro SetPageStrings 1033

         SetShellVarContext all

         Strcpy $SETTINGSDIR "$EXEDIR\NSIS_TempDir\Settings"
         WriteINIStr "$SETTINGSDIR\Settings.ini" "Language" "Language" "$ENGLISH"

         SendMessage $Btn_Install ${WM_SETTEXT} 0 "STR:$LANGSTRING_BUTTON_INSTALL"
         SendMessage $Btn_Custom_Install ${WM_SETTEXT} 0 "STR:$LANGSTRING_BUTTON_CUSTOM_INSTALL"
         SendMessage $Lnk_Show_Eula ${WM_SETTEXT} 0 "STR:$LANGSTRING_LNK_LICENSE"
         SendMessage $Lbl_Accept_Eula ${WM_SETTEXT} 0 "STR:$LANGSTRING_CK_LICENSE"

         SendMessage $Btn_Browse ${WM_SETTEXT} 0 "STR:$LANGSTRING_BUTTON_BROWSE"

         SendMessage $Lbl_Required_Space ${WM_SETTEXT} 0 "STR:$LANGSTRING_REQUIRED_SPACE"
         SendMessage $Lbl_Total_Space ${WM_SETTEXT} 0 "STR:$LANGSTRING_TOTAL_SPACE"

         SendMessage $Lbl_ShortCut ${WM_SETTEXT} 0 "STR:$LANGSTRING_CK_SHORTCUT"
         SendMessage $Lbl_AutoRun ${WM_SETTEXT} 0 "STR:$LANGSTRING_CK_LAUNCH"
         SendMessage $Lbl_Taskbar ${WM_SETTEXT} 0 "STR:$LANGSTRING_CK_TASKBAR"
         SendMessage $Lbl_Website ${WM_SETTEXT} 0 "STR:$LANGSTRING_CK_WEBSITE"

         SendMessage $Lbl_Welcome ${WM_SETTEXT} 0 "STR:$LANGSTRING_WELCOME"

         # close #

         SendMessage $Lbl_Warning_Title ${WM_SETTEXT} 0 "STR:$LANGSTRING_QUIT_WARNING"
         SendMessage $Lbl_Quit_Msg_1 ${WM_SETTEXT} 0 "STR:$LANGSTRING_QUIT_MESSAGE_1"
         SendMessage $Lbl_Quit_Msg_2 ${WM_SETTEXT} 0 "STR:$LANGSTRING_QUIT_MESSAGE_2"

         SendMessage $Btn_Yes_Quit ${WM_SETTEXT} 0 "STR:$LANGSTRING_QUIT_BUTTON_YES"
         SendMessage $Btn_No_Quit ${WM_SETTEXT} 0 "STR:$LANGSTRING_QUIT_BUTTON_NO"

      ;${Case} French
        ;!insertmacro SetPageStrings 1036

      ;${Case} German
        ;!insertmacro SetPageStrings 1031

      ;${Case} Greek
        ;!insertmacro SetPageStrings 1032

      ${Case} $ROMANIAN
        !insertmacro SetPageStrings 1048

         SetShellVarContext all

         Strcpy $SETTINGSDIR "$EXEDIR\NSIS_TempDir\Settings"
         WriteINIStr "$SETTINGSDIR\Settings.ini" "Language" "Language" "$ROMANIAN"

         SendMessage $Btn_Install ${WM_SETTEXT} 0 "STR:$LANGSTRING_BUTTON_INSTALL"
         SendMessage $Btn_Custom_Install ${WM_SETTEXT} 0 "STR:$LANGSTRING_BUTTON_CUSTOM_INSTALL"
         SendMessage $Lnk_Show_Eula ${WM_SETTEXT} 0 "STR:$LANGSTRING_LNK_LICENSE"
         SendMessage $Lbl_Accept_Eula ${WM_SETTEXT} 0 "STR:$LANGSTRING_CK_LICENSE"

         SendMessage $Btn_Browse ${WM_SETTEXT} 0 "STR:$LANGSTRING_BUTTON_BROWSE"

         SendMessage $Lbl_Required_Space ${WM_SETTEXT} 0 "STR:$LANGSTRING_REQUIRED_SPACE"
         SendMessage $Lbl_Total_Space ${WM_SETTEXT} 0 "STR:$LANGSTRING_TOTAL_SPACE"

         SendMessage $Lbl_ShortCut ${WM_SETTEXT} 0 "STR:$LANGSTRING_CK_SHORTCUT"
         SendMessage $Lbl_AutoRun ${WM_SETTEXT} 0 "STR:$LANGSTRING_CK_LAUNCH"
         SendMessage $Lbl_Taskbar ${WM_SETTEXT} 0 "STR:$LANGSTRING_CK_TASKBAR"
         SendMessage $Lbl_Website ${WM_SETTEXT} 0 "STR:$LANGSTRING_CK_WEBSITE"

         SendMessage $Lbl_Welcome ${WM_SETTEXT} 0 "STR:$LANGSTRING_WELCOME"

         # close #

         SendMessage $Lbl_Warning_Title ${WM_SETTEXT} 0 "STR:$LANGSTRING_QUIT_WARNING"
         SendMessage $Lbl_Quit_Msg_1 ${WM_SETTEXT} 0 "STR:$LANGSTRING_QUIT_MESSAGE_1"
         SendMessage $Lbl_Quit_Msg_2 ${WM_SETTEXT} 0 "STR:$LANGSTRING_QUIT_MESSAGE_2"

         SendMessage $Btn_Yes_Quit ${WM_SETTEXT} 0 "STR:$LANGSTRING_QUIT_BUTTON_YES"
         SendMessage $Btn_No_Quit ${WM_SETTEXT} 0 "STR:$LANGSTRING_QUIT_BUTTON_NO"

     ;${Case} SimpChinese
       ;!insertmacro SetPageStrings 2052

      ${CaseElse}
        !insertmacro SetPageStrings 1033
    ${EndSelect}
FunctionEnd

# Express Install #

Function ".onClick.Install"
  System::Call user32::SetWindowPos(i$HWNDPARENT,i0,i0,i0,i651,i451,i0x0002)
  System::Call user32::SetWindowPos(i$Dialog,i0,i0,i0,i651,i451,i0x0002)
  StrCpy $R9 1
  SendMessage $HWNDPARENT 0x408 1 0
  Abort
FunctionEnd 

# ...:: Install ::... #

var ProgressBar
var INSTALL_PERCENT
var INSTALL_TITLE_LANGUAGE
var UNIINSTALL_TITLE_LANGUAGE

Function "InstFilesPageShow"
    FindWindow $R2 "#32770" "" $HWNDPARENT
    GetDlgItem $0 $HWNDPARENT 1
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 2
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 3
    
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $1 $R2 1027
    ShowWindow $1 ${SW_HIDE}

    # WINDOW #

    StrCpy $R0 $R2
    System::Call "user32::MoveWindow(i R0, i 0, i 0, i 651, i 451) i r2"
    GetFunctionAddress $0 onGUICallback
    WndProc::onCallback $R0 $0

    GetDlgItem $R3 $R2 1990
    SetCtlColors $R3 "0x666666" "0xFFFFFF"
    System::Call "user32::MoveWindow(i R3, i 600, i 6, i 16, i 16) i r2"
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_min.bmp $R3
    GetFunctionAddress $3 ".onClick.Minimize"
    SkinBtn::onClick $R3 $3

    GetDlgItem $R4 $R2 1991
    SetCtlColors $R4 "0x666666" "0xFFFFFF"
    System::Call "user32::MoveWindow(i R4, i 620, i 6, i 16, i 16) i r2"
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_close.bmp $R4
    ;GetFunctionAddress $3 ".onClick.Close"
    SkinBtn::onClick $R4 $3
    EnableWindow $R4 0

    # PROGRESSBAR #

    GetDlgItem $R0 $R2 1004
    SetCtlColors $R2 "0x666666" "0xFFFFFF"
    System::Call "user32::MoveWindow(i R0, i 35, i 340, i 570, i 6) i r2"

    # DETAILPRINT #

    GetDlgItem $R1 $R2 1006
    SetCtlColors $R1 "0x7B8DB6" "0xFFFFFF"
    System::Call "user32::MoveWindow(i R1, i 35, i 315, i 570, i 20) i r2"
    CreateFont $FONT_NAME "Microsoft Yahei" 9 400
    SendMessage $R1 ${WM_SETFONT} $FONT_NAME 0

    # SHOW DETAIL #

    GetDlgItem $R8 $R2 1013
    SetCtlColors $R8 "0x7B8DB6" "0xFFFFFF"
    System::Call "user32::MoveWindow(i R8, i 35, i 85, i 570, i 210) i r2"

    # BACKGROUND #

    FindWindow $R2 "#32770" "" $HWNDPARENT
    GetDlgItem $R0 $R2 1995
    System::Call "user32::MoveWindow(i R0, i 0, i 0, i 651, i 451) i r2"
    ${NSD_SetImage} $R0 "$PLUGINSDIR\001.bmp" $ImageHandle

    # PROGRESSBAR ::... #

    FindWindow $R2 "#32770" "" $HWNDPARENT
    GetDlgItem $5 $R2 1004
    SkinProgress::Set $5 "$PLUGINSDIR\progressbar_foreground.bmp" "$PLUGINSDIR\progressbar_background.bmp"
    StrCpy $ProgressBar $5

    ClearErrors
    StrCpy $SETTINGSDIR "$EXEDIR\NSIS_TempDir\Settings"
    ReadINIStr $locale_language_name "$SETTINGSDIR\Settings.ini" "Language" "Language"
    IfErrors 0 +3
    ${If} $locale_language_name != "1"
      Strcpy $LANGUAGEDIR "$EXEDIR\NSIS_TempDir\Language"
      ReadINIStr $INSTALL_TITLE_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "NSIS_Installer" "NSIS_Install_Title"
      ReadINIStr $UNIINSTALL_TITLE_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "NSIS_Installer" "NSIS_Uninstall_Title"
    ${ElseIf} $locale_language_name == "0"
      Strcpy $LANGUAGEDIR "$EXEDIR\NSIS_TempDir\Language"
      ReadINIStr $INSTALL_TITLE_LANGUAGE "$LANGUAGEDIR\English.ini" "NSIS_Installer" "NSIS_Install_Title"
      ReadINIStr $UNIINSTALL_TITLE_LANGUAGE "$LANGUAGEDIR\English.ini" "NSIS_Installer" "NSIS_Uninstall_Title"
    ${EndIf}

    # Title #

    GetDlgItem $R7 $R2 1002
    SetCtlColors $R7 "0xA5B6DA" "0xFFFFFF"
    System::Call "user32::MoveWindow(i R7, i 22, i 5, i 200, i 16) i r2"
    System::Call "user32::SetWindowText(i R7, t $\"Nullsoft Installer$\")"
    CreateFont $FONT_NAME "Microsoft Yahei" 8 300
    SendMessage $R7 ${WM_SETFONT} $FONT_NAME 0

    GetDlgItem $R9 $R2 1005
    SetCtlColors $R9 "0xA5B6DA" "0xFFFFFF"
    System::Call "user32::MoveWindow(i R9, i 320, i 200, i 85, i 20) i r2"
    System::Call "user32::SetWindowText(i R9, t $\"0%$\")"
    CreateFont $FONT_NAME "Microsoft Yahei" 10 300
    SendMessage $R9 ${WM_SETFONT} $FONT_NAME 0
FunctionEnd

# SECTION #

!define _SOURCE_FILE '!insertmacro _SOURCE_FILE'
!macro _SOURCE_FILE _VAR _FILE
    Push "${_FILE}"
     ${GetParent} "${_FILE}" $0
    Pop ${_VAR}
!macroend

!define CopyFolders "!insertmacro _CopyFolders"
!macro _CopyFolders _SOURCEFOLDER_ _DESTFOLDER_
!verbose push
!verbose 3
   Push "${_SOURCEFOLDER_}"
   Push "${_DESTFOLDER_}"
   DetailPrint "Copy From: ${_SOURCEFOLDER_}"
   DetailPrint "Copy To: ${_DESTFOLDER_}"
   CreateDirectory "${_DESTFOLDER_}"
     CopyFiles /SILENT `${_SOURCEFOLDER_}\*.*` `${_DESTFOLDER_}` 
   DetailPrint "$1"
!verbose pop
!macroend

var UNINSTALL_LANGUAGE
var INSTALL_LANGUAGE

var START_INSTALL_LANGUAGE
var SECONDS_INSTALL_LANGUAGE

var SUCESSFULLY_INSTALL_LANGUAGE
var FAILED_INSTALL_LANGUAGE

var CHECK_INSTALL_LANGUAGE
var SIZE_INSTALL_LANGUAGE

var CONNECT_SERVER_LANGUAGE
var NO_INTERNET_CONNECTION_LANGUAGE
var YES_INTERNET_CONNECTION_LANGUAGE

var ELAPSEDTIME_LANGUAGE
var HOURS_LANGUAGE
var MINUTES_LANGUAGE
var SECONDS_LANGUAGE
var MILISECONDS_LANGUAGE

var TickCount 
var Time

Section "MAIN" SEC01

  ${TickCountStart}
  System::Call "kernel32::GetTickCount()l .s"
  Pop $TickCount 

  ClearErrors
  StrCpy $SETTINGSDIR "$EXEDIR\NSIS_TempDir\Settings"
  ReadINIStr $locale_language_name "$SETTINGSDIR\Settings.ini" "Language" "Language"
  IfErrors 0 +3
  ${If} $locale_language_name != "1"
    Strcpy $LANGUAGEDIR "$EXEDIR\NSIS_TempDir\Language"

    ReadINIStr $UNINSTALL_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "NSIS_Installer" "NSIS_Uninstall"
    ReadINIStr $INSTALL_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "NSIS_Installer" "NSIS_Install"

    ReadINIStr $START_INSTALL_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "NSIS_Installer" "NSIS_Start_Install"
    ReadINIStr $SECONDS_INSTALL_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "NSIS_Installer" "NSIS_Seconds"

    ReadINIStr $SUCESSFULLY_INSTALL_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "NSIS_Installer" "NSIS_Succefully_Install"
    ReadINIStr $FAILED_INSTALL_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "NSIS_Installer" "NSIS_Failed_Install"

    ReadINIStr $CHECK_INSTALL_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "NSIS_Installer" "NSIS_Check_Files"
    ReadINIStr $SIZE_INSTALL_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "NSIS_Installer" "_Size"

    ReadINIStr $CONNECT_SERVER_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "NSIS_Installer" "NSIS_Connect_Server"
    ReadINIStr $NO_INTERNET_CONNECTION_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "NSIS_Installer" "NSIS_No_Internet_Connection"
    ReadINIStr $YES_INTERNET_CONNECTION_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "NSIS_Installer" "NSIS_Yes_Internet_Connection"

    ReadINIStr $ELAPSEDTIME_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "NSIS_Installer" "NSIS_ElapsedTime"
    ReadINIStr $HOURS_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "NSIS_Installer" "NSIS_Hours"
    ReadINIStr $MINUTES_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "NSIS_Installer" "NSIS_Minutes"
    ReadINIStr $SECONDS_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "NSIS_Installer" "NSIS_Seconds"
    ReadINIStr $MILISECONDS_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "NSIS_Installer" "NSIS_Miliseconds"

  ${ElseIf} $locale_language_name == "0"
    Strcpy $LANGUAGEDIR "$EXEDIR\NSIS_TempDir\Language"

    ReadINIStr $UNINSTALL_LANGUAGE "$LANGUAGEDIR\English.ini" "NSIS_Installer" "NSIS_Uninstall"
    ReadINIStr $INSTALL_LANGUAGE "$LANGUAGEDIR\English.ini" "NSIS_Installer" "NSIS_Install"

    ReadINIStr $START_INSTALL_LANGUAGE "$LANGUAGEDIR\English.ini" "NSIS_Installer" "NSIS_Start_Install"
    ReadINIStr $SECONDS_INSTALL_LANGUAGE "$LANGUAGEDIR\English.ini" "NSIS_Installer" "NSIS_Seconds"

    ReadINIStr $SUCESSFULLY_INSTALL_LANGUAGE "$LANGUAGEDIR\English.ini" "NSIS_Installer" "NSIS_Succefully_Install"
    ReadINIStr $FAILED_INSTALL_LANGUAGE "$LANGUAGEDIR\English.ini" "NSIS_Installer" "NSIS_Failed_Install"

    ReadINIStr $CHECK_INSTALL_LANGUAGE "$LANGUAGEDIR\English.ini" "NSIS_Installer" "NSIS_Check_Files"
    ReadINIStr $SIZE_INSTALL_LANGUAGE "$LANGUAGEDIR\English.ini" "NSIS_Installer" "NSIS_Size"

    ReadINIStr $CONNECT_SERVER_LANGUAGE "$LANGUAGEDIR\English.ini" "NSIS_Installer" "NSIS_Connect_Server"
    ReadINIStr $NO_INTERNET_CONNECTION_LANGUAGE "$LANGUAGEDIR\English.ini" "NSIS_Installer" "NSIS_No_Internet_Connection"
    ReadINIStr $YES_INTERNET_CONNECTION_LANGUAGE "$LANGUAGEDIR\English.ini" "NSIS_Installer" "NSIS_Yes_Internet_Connection"

    ReadINIStr $ELAPSEDTIME_LANGUAGE "$LANGUAGEDIR\English.ini" "NSIS_Installer" "NSIS_ElapsedTime"
    ReadINIStr $HOURS_LANGUAGE "$LANGUAGEDIR\English.ini" "NSIS_Installer" "NSIS_Hours"
    ReadINIStr $MINUTES_LANGUAGE "$LANGUAGEDIR\English.ini" "NSIS_Installer" "NSIS_Minutes"
    ReadINIStr $SECONDS_LANGUAGE "$LANGUAGEDIR\English.ini" "NSIS_Installer" "NSIS_Seconds"
    ReadINIStr $MILISECONDS_LANGUAGE "$LANGUAGEDIR\English.ini" "NSIS_Installer" "NSIS_Miliseconds"

  ${EndIf}

  ${If} $PortableMode = 0

   # STANDARD #

    IfFileExists "$INSTDIR\uninst-nsis.exe" "NSIS.Yes.Uninstall" "NSIS.Continue.Install"
    StrCmp $0 1 "NSIS.Yes.Uninstall" "NSIS.Continue.Install"
    ${If} "$0" == "1"
      NSIS.Yes.Uninstall:

      SetShellVarContext all

      nsExec::Exec 'taskkill /F /IM "makensisw.exe"'
      nsExec::Exec 'taskkill /F /IM "NSIS.exe"'

      ExecWait '"$INSTDIR\uninst-nsis.exe" /S _?=$INSTDIR'

      GoTo NSIS.Continue.Install.files

    ${ElseIf} $0 == "0"
      NSIS.Continue.Install:

      GoTo NSIS.Continue.Install.files

    ${EndIf}

    NSIS.Continue.Install.files:

  Strcpy $INSTALL_PERCENT $R9

  DetailPrint `$INSTALL_LANGUAGE`

  DetailPrint `$START_INSTALL_LANGUAGE 5 $SECONDS_INSTALL_LANGUAGE`

  IntFmt $R1 "0x%08X" 5

  ${GetTime} "" "L" $0 $1 $2 $3 $4 $5 $6
  Strcpy $R2 $6

  loop:

  ${GetTime} "" "L" $0 $1 $2 $3 $4 $5 $6

  Strcmp $R2 $6 loop 0
  Strcpy $R2 $6
  IntOp $R1 $R1 - 1
  IntCmp $R1 0 +3 +3 0
    DetailPrint `$START_INSTALL_LANGUAGE $R1 $SECONDS_INSTALL_LANGUAGE`
  goto loop

  loop1: 
    IntCmp $R1 $R0 done1 0 done1
    IntOp $R1 $R1 + 1
    SendMessage $ProgressBar ${PBM_SETPOS} "$R1" "0"
    SendMessage $INSTALL_PERCENT ${WM_SETTEXT} 0 "STR:$R1"

    ${TBProgress} $R1

    SetDetailsPrint textonly
    DetailPrint `$INSTALL_LANGUAGE`
    SetDetailsPrint listonly

    ClearErrors
    SetShellVarContext "all"

    ${If} $LANGUAGE == 1033 ; ENGLISH
     SetOutPath "$INSTDIR"
     File /r /x thumbs.db "English\*.*"
    ${ElseIf} $LANGUAGE == 1048 ; ROMANIAN
     SetOutPath "$INSTDIR"
     File /r /x thumbs.db "Romanian\*.*"
    ${EndIf}

    # Prograss (2%) Installing #
    IntOp $R1 $R1 + 1
    SendMessage $ProgressBar ${PBM_SETPOS} "$R1" "0"
    SendMessage $INSTALL_PERCENT ${WM_SETTEXT} 0 "STR:$R1%"
    ${TBProgress} $R1

    ClearErrors
    SetShellVarContext "all"

    CreateDirectory "$INSTDIR"
    SetOutPath "$INSTDIR\Bin"
    File /r /x thumbs.db "NSIS\Bin\*.*"

    # Prograss (2%) Installing #
    IntOp $R1 $R1 + 1
    SendMessage $ProgressBar ${PBM_SETPOS} "$R1" "0"
    SendMessage $INSTALL_PERCENT ${WM_SETTEXT} 0 "STR:$R1%"
    ${TBProgress} $R1

    SetOutPath "$INSTDIR\Contrib"
    File /r /x thumbs.db "NSIS\Contrib\*.*"

    # Prograss (2%) Installing #
    IntOp $R1 $R1 + 1
    SendMessage $ProgressBar ${PBM_SETPOS} "$R1" "0"
    SendMessage $INSTALL_PERCENT ${WM_SETTEXT} 0 "STR:$R1%"
    ${TBProgress} $R1

    SetOutPath "$INSTDIR\Docs"
    File /r /x thumbs.db "NSIS\Docs\*.*"

    # Prograss (2%) Installing #
    IntOp $R1 $R1 + 1
    SendMessage $ProgressBar ${PBM_SETPOS} "$R1" "0"
    SendMessage $INSTALL_PERCENT ${WM_SETTEXT} 0 "STR:$R1%"
    ${TBProgress} $R1

    SetOutPath "$INSTDIR\Examples"
    File /r /x thumbs.db "NSIS\Examples\*.*"

    # Prograss (2%) Installing #
    IntOp $R1 $R1 + 1
    SendMessage $ProgressBar ${PBM_SETPOS} "$R1" "0"
    SendMessage $INSTALL_PERCENT ${WM_SETTEXT} 0 "STR:$R1%"
    ${TBProgress} $R1

    SetOutPath "$INSTDIR\Include"
    File /r /x thumbs.db "NSIS\Include\*.*"

    # Prograss (2%) Installing #
    IntOp $R1 $R1 + 1
    SendMessage $ProgressBar ${PBM_SETPOS} "$R1" "0"
    SendMessage $INSTALL_PERCENT ${WM_SETTEXT} 0 "STR:$R1%"
    ${TBProgress} $R1

    SetOutPath "$INSTDIR\Menu"
    File /r /x thumbs.db "NSIS\Menu\*.*"

    # Prograss (2%) Installing #
    IntOp $R1 $R1 + 1
    SendMessage $ProgressBar ${PBM_SETPOS} "$R1" "0"
    SendMessage $INSTALL_PERCENT ${WM_SETTEXT} 0 "STR:$R1%"
    ${TBProgress} $R1

    SetOutPath "$INSTDIR\Plugins"
    File /r /x thumbs.db "NSIS\Plugins\*.*"

    # Prograss (2%) Installing #
    IntOp $R1 $R1 + 1
    SendMessage $ProgressBar ${PBM_SETPOS} "$R1" "0"
    SendMessage $INSTALL_PERCENT ${WM_SETTEXT} 0 "STR:$R1%"
    ${TBProgress} $R1

    SetOutPath "$INSTDIR\Stubs"
    File /r /x thumbs.db "NSIS\Stubs\*.*"

    # Prograss (2%) Installing #
    IntOp $R1 $R1 + 1
    SendMessage $ProgressBar ${PBM_SETPOS} "$R1" "0"
    SendMessage $INSTALL_PERCENT ${WM_SETTEXT} 0 "STR:$R1%"
    ${TBProgress} $R1

    SetOutPath "$INSTDIR"
    File /r /x thumbs.db "NSIS\COPYING"
    File /r /x thumbs.db "NSIS\NSIS.chm"
    File /r /x thumbs.db "NSIS\NSIS.exe"
    File /r /x thumbs.db "NSIS\nsisconf.nsh"

    # Prograss (2%) Installing #
    IntOp $R1 $R1 + 1
    SendMessage $ProgressBar ${PBM_SETPOS} "$R1" "0"
    SendMessage $INSTALL_PERCENT ${WM_SETTEXT} 0 "STR:$R1%"
    ${TBProgress} $R1

    SetOutPath "$INSTDIR\Feedback"
    File /r /x thumbs.db "Feedback\*.*"

    # Prograss (2%) Installing #
    IntOp $R1 $R1 + 1
    SendMessage $ProgressBar ${PBM_SETPOS} "$R1" "0"
    SendMessage $INSTALL_PERCENT ${WM_SETTEXT} 0 "STR:$R1%"
    ${TBProgress} $R1

    # ASSOSIATION

    SetOverwrite on
    ReadRegStr $R0 HKCR ".nsi" ""
	StrCmp $R0 "NSISFile" 0 +2
    DeleteRegKey HKCR "NSISFile"

    WriteRegStr HKCR ".nsi" "" "NSIS.Script"
    WriteRegStr HKCR "NSIS.Script" "" "NSIS Script File"
    WriteRegStr HKCR "NSIS.Script\DefaultIcon" "" "$INSTDIR\makensisw.exe,1"
    ReadRegStr $R0 HKCR "NSIS.Script\shell\open\command" ""
    StrCmp $R0 "" 0 no_nsiopen
    WriteRegStr HKCR "NSIS.Script\shell" "" "open"
    WriteRegStr HKCR "NSIS.Script\shell\open\command" "" 'notepad.exe "%1"'
    no_nsiopen:
    WriteRegStr HKCR "NSIS.Script\shell\compile" "MUIVerb" "$(NSIS.Context.Menu.Compile.With.NSIS)"
    WriteRegStr HKCR "NSIS.Script\shell\compile\command" "" '"$INSTDIR\makensisw.exe" "%1"'
    WriteRegStr HKCR "NSIS.Script" "Icon" "$INSTDIR\makensisw.exe,1"

    WriteRegStr HKCR "NSIS.Script\shell\compile-compressor" "MUIVerb" "$(NSIS.Context.Menu.Chose.Compress)"
    WriteRegStr HKCR "NSIS.Script\shell\compile-compressor\command" "" '"$INSTDIR\makensisw.exe" /ChooseCompressor "%1"'
    WriteRegStr HKCR "NSIS.Script" "Icon" "$INSTDIR\makensisw.exe,1"

    ReadRegStr $R0 HKCR ".nsh" ""
	StrCmp $R0 "NSHFile" 0 +2
    DeleteRegKey HKCR "NSHFile"

    WriteRegStr HKCR ".nsh" "" "NSIS.Header"
    WriteRegStr HKCR "NSIS.Header" "" "NSIS Header File"
    WriteRegStr HKCR "NSIS.Header\DefaultIcon" "" "$INSTDIR\makensisw.exe,1"
    ReadRegStr $R0 HKCR "NSIS.Header\shell\open\command" ""
    StrCmp $R0 "" 0 no_nshopen
    WriteRegStr HKCR "NSIS.Header\shell" "" "open"
    WriteRegStr HKCR "NSIS.Header\shell\open\command" "" 'notepad.exe "%1"'
    no_nshopen:

    SetShellVarContext all

    System::Call 'Shell32::SHChangeNotify(i ${SHCNE_ASSOCCHANGED}, i ${SHCNF_IDLIST}, i 0, i 0)'
    System::Call 'Shell32::SHChangeNotify(i 0x8000000, i 0, i 0, i 0)'

    # Prograss (3%) Installing #
    IntOp $R1 $R1 + 1
    SendMessage $ProgressBar ${PBM_SETPOS} "$R1" "0"
    SendMessage $INSTALL_PERCENT ${WM_SETTEXT} 0 "STR:$R1%"
    ${TBProgress} $R1

    SetShellVarContext all

    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NSIS" "DisplayName" "Nullsoft Install System"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NSIS" "UninstallString" '"$INSTDIR\uninst-nsis.exe"' 
    WriteUninstaller "$INSTDIR\uninst-nsis.exe"
    WriteRegExpandStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NSIS" "InstallLocation" "$INSTDIR"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NSIS" "DisplayIcon" "$INSTDIR\NSIS.exe,0"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NSIS" "DisplayVersion" "2.51"
    WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NSIS" "VersionMajor" "2.51.0.0"
    WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NSIS" "VersionMinor" "2.51.0.0"
    WriteRegExpandStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NSIS" "Publisher" "Nullsoft Install System"
    ${GetSize} "$INSTDIR" "/S=0K" $0 $1 $2
    IntFmt $0 "0x%08X" $0
    WriteRegDWord HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NSIS" "EstimatedSize" "$0"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NSIS" "URLInfoAbout" "http://nsis.sf.net"

    WriteRegExpandStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NSIS" "HelpLink" "http://nsis.sf.net"
    WriteRegExpandStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NSIS" "URLUpdateInfo" "http://nsis.sf.net"

    SetOverwrite off

    # Prograss (25%) Installing #
    IntOp $R1 $R1 + 1
    SendMessage $ProgressBar ${PBM_SETPOS} "$R1" "0"
    SendMessage $INSTALL_PERCENT ${WM_SETTEXT} 0 "STR:$R1%"
    ${TBProgress} $R1

    # ...:: IObit ::... #

    ${CheckInternetConnection} "https://www.iobit.com/en/index.php" $0 
    ${If} $0 == "OK" 

      DetailPrint "$YES_INTERNET_CONNECTION_LANGUAGE"

      DetailPrint "$CONNECT_SERVER_LANGUAGE"

       # ...:: IObit Uninstaller ::... #

       ${If} $Bool_Yes_Install_IU == 1
  	  IfFileExists "$PROGRAMFILES\IObit\IObit Uninstaller\IObitUninstaler.exe" "IObitUninstallerDown" "IObitUninstallerEnd"
	  StrCmp $0 "1" "IObitUninstallerDown" "IObitUninstallerEnd"
  	  ${If} $0 == "1"
    	    IObitUninstallerDown:

                SetShellVarContext "all"

		; === Get Toolbox URL from .ini file ===
		ReadINIStr $0 "$PLUGINSDIR\Toolbox.ini" "Toolbox_102" "File_1"
		${GetOptions} "|$0" "|URL:" $1

		; === Get file name of Toolbox from .ini file ===
		${GetOptions} "|$0" "|NAME:" $2

		; === Get Toolbox Already Exist ===
        	MessageBox MB_YESNO|MB_USERICON 'Warnig!$\n$\n$2 already exists.$\n$\nDo you want to download it again?' IDYES "IObitUninstallerEnd" IDNO "IObitUninstallerExit"
        	Abort

             GoTo IObitUninstallerExit

  	  ${ElseIf} $0 == "0"
    	     IObitUninstallerEnd:

                SetShellVarContext "all"

		RMDir /r "$TEMP\Toolbox"
		CreateDirectory "$TEMP\Toolbox"

		; === Get Toolbox URL from .ini file ===
		ReadINIStr $0 "$PLUGINSDIR\Toolbox.ini" "Toolbox_102" "File_1"
		${GetOptions} "|$0" "|URL:" $1

		; === Get file name of Toolbox from .ini file ===
		${GetOptions} "|$0" "|NAME:" $2

		; === Download and install Toolbox ===
		inetc::get /POPUP "" /CAPTION "$2" "$1" "$TEMP\Toolbox\$2" /END
		Pop $0
		StrCmp $0 "OK" +3
		  MessageBox MB_USERICON "Download of $2: $0"
		Goto +3

                SetShellVarContext "all"

      		ExecWait '"$TEMP\Toolbox\$2" /VERYSILENT /NORESTART'

              GoTo IObitUninstallerExit

  	  ${EndIf}
	  IObitUninstallerExit:
       ${EndIf}

       # Prograss (25%) Installing #
       IntOp $R1 $R1 + 1
       SendMessage $ProgressBar ${PBM_SETPOS} "$R1" "0"
       SendMessage $INSTALL_PERCENT ${WM_SETTEXT} 0 "STR:$R1%"
       ${TBProgress} $R1

       # ...:: IObit Driver Booster ::... #

       ${If} $Bool_Yes_Install_DB == 1
  	  IfFileExists "$PROGRAMFILES\IObit\Driver Booster\DriverBooster.exe" "IObitDriverBoosterDown" "IObitDriverBoosterEnd"
	  StrCmp $0 "1" "IObitDriverBoosterDown" "IObitDriverBoosterEnd"
  	  ${If} $0 == "1"
    	    IObitDriverBoosterDown:

                SetShellVarContext "all"

		; === Get Toolbox URL from .ini file ===
		ReadINIStr $0 "$PLUGINSDIR\Toolbox.ini" "Toolbox_101" "File_1"
		${GetOptions} "|$0" "|URL:" $1

		; === Get file name of Toolbox from .ini file ===
		${GetOptions} "|$0" "|NAME:" $2

		; === Get Toolbox Already Exist ===
        	MessageBox MB_YESNO|MB_USERICON 'Warnig!$\n$\n$2 already exists.$\n$\nDo you want to download it again?' IDYES "IObitDriverBoosterEnd" IDNO "IObitDriverBoosterExit"
        	Abort

        	GoTo IObitDriverBoosterExit

  	  ${ElseIf} $0 == "0"
    	    IObitDriverBoosterEnd:

                SetShellVarContext "all"
		RMDir /r "$TEMP\Toolbox"
		CreateDirectory "$TEMP\Toolbox"

		; === Get Toolbox URL from .ini file ===
		ReadINIStr $0 "$PLUGINSDIR\Toolbox.ini" "Toolbox_101" "File_1"
		${GetOptions} "|$0" "|URL:" $1

		; === Get file name of Toolbox from .ini file ===
		${GetOptions} "|$0" "|NAME:" $2

		; === Download and install Toolbox ===
		inetc::get /POPUP "" /CAPTION "$2" "$1" "$TEMP\Toolbox\$2" /END
		Pop $0
		StrCmp $0 "OK" +3
		  MessageBox MB_USERICON "Download of $2: $0"
		Goto +3

                SetShellVarContext "all"

      		ExecWait '"$TEMP\Toolbox\$2" /VERYSILENT /NORESTART'

        	GoTo IObitDriverBoosterExit

  	  ${EndIf}
	  IObitDriverBoosterExit:
       ${EndIf}

       # Prograss (25%) Installing #
       IntOp $R1 $R1 + 1
       SendMessage $ProgressBar ${PBM_SETPOS} "$R1" "0"
       SendMessage $INSTALL_PERCENT ${WM_SETTEXT} 0 "STR:$R1%"
       ${TBProgress} $R1

       # ...:: IObit Smart Defrag ::... #

       ${If} $Bool_Yes_Install_SM == 1
  	 IfFileExists "$PROGRAMFILES\IObit\Smart Defrag\SmartDefrag.exe" "IObitSmartDefragDown" "IObitSmartDefragEnd"
	 StrCmp $0 "1" "IObitSmartDefragDown" "IObitSmartDefragEnd"
         ${If} $0 == "1"
    	   IObitSmartDefragDown:

                SetShellVarContext "all"

		; === Get Toolbox URL from .ini file ===
		ReadINIStr $0 "$PLUGINSDIR\Toolbox.ini" "Toolbox_103" "File_1"
		${GetOptions} "|$0" "|URL:" $1

		; === Get file name of Toolbox from .ini file ===
		${GetOptions} "|$0" "|NAME:" $2

		; === Get Toolbox Already Exist ===
        	MessageBox MB_YESNO|MB_USERICON 'Warnig!$\n$\n$2 already exists.$\n$\nDo you want to download it again?' IDYES "IObitSmartDefragEnd" IDNO "IObitSmartDefragExit"
        	Abort

        	GoTo IObitSmartDefragExit

         ${ElseIf} $0 == "0"
    	   IObitSmartDefragEnd:

                SetShellVarContext "all"
		RMDir /r "$TEMP\Toolbox"
		CreateDirectory "$TEMP\Toolbox"

		; === Get Toolbox URL from .ini file ===
		ReadINIStr $0 "$PLUGINSDIR\Toolbox.ini" "Toolbox_103" "File_1"
		${GetOptions} "|$0" "|URL:" $1

		; === Get file name of Toolbox from .ini file ===
		${GetOptions} "|$0" "|NAME:" $2

		; === Download and install Toolbox ===
		inetc::get /POPUP "" /CAPTION "$2" "$1" "$TEMP\Toolbox\$2" /END
		Pop $0
		StrCmp $0 "OK" +3
		   MessageBox MB_USERICON "Download of $2: $0"
		Goto +3

                SetShellVarContext "all"

      		ExecWait '"$TEMP\Toolbox\$2" /VERYSILENT /NORESTART'

        	GoTo IObitSmartDefragExit

         ${EndIf}
	 IObitSmartDefragExit:
       ${EndIf}

       # Prograss (25%) Installing #
       IntOp $R1 $R1 + 1
       SendMessage $ProgressBar ${PBM_SETPOS} "$R1" "0"
       SendMessage $INSTALL_PERCENT ${WM_SETTEXT} 0 "STR:$R1%"
       ${TBProgress} $R1

       # ...:: IObit Advanced SystemCare ::... #

       ${If} $Bool_Yes_Install_ASC == 1
  	 IfFileExists "$PROGRAMFILES\IObit\Advanced SystemCare\ASC.exe" "IObitAdvancedSystemCareDown" "IObitAdvancedSystemCareEnd"
	 StrCmp $0 "1" "IObitAdvancedSystemCareDown" "IObitAdvancedSystemCareEnd"
  	 ${If} $0 == "1"
    	   IObitAdvancedSystemCareDown:

                SetShellVarContext "all"

		; === Get Toolbox Already Exist ===
        	MessageBox MB_YESNO|MB_USERICON 'Warnig!$\n$\nIObit Advanced SystemCare already exists.$\n$\nDo you want to download it again?' IDYES "IObitAdvancedSystemCareEnd" IDNO "IObitAdvancedSystemCareExit"
        	Abort

        	GoTo IObitAdvancedSystemCareExit

  	 ${ElseIf} $0 == "0"
    	   IObitAdvancedSystemCareEnd:

                SetShellVarContext "all"
		RMDir /r "$TEMP\Toolbox"
		CreateDirectory "$TEMP\Toolbox"

		; === Download and install Toolbox ===
		inetc::get /POPUP "" /CAPTION "advanced-systemcare-setup.exe" "http://update.iobit.com/dl/advanced-systemcare-setup.exe" "$TEMP\Toolbox\advanced-systemcare-setup.exe" /END
		Pop $0
		StrCmp $0 "OK" +3
		  MessageBox MB_USERICON "Download of advanced-systemcare-setup.exe: $0"
		Goto +3

                SetShellVarContext "all"

      		ExecWait '"$TEMP\Toolbox\advanced-systemcare-setup.exe" /VERYSILENT /NORESTART'

        	GoTo IObitAdvancedSystemCareExit

  	 ${EndIf}
	 IObitAdvancedSystemCareExit:
       ${EndIf}

       # Prograss (25%) Installing #
       IntOp $R1 $R1 + 1
       SendMessage $ProgressBar ${PBM_SETPOS} "$R1" "0"
       SendMessage $INSTALL_PERCENT ${WM_SETTEXT} 0 "STR:$R1%"
       ${TBProgress} $R1

       # ...:: IObit Malware Fighter ::... #

       ${If} $Bool_Yes_Install_IMF == 1
  	 IfFileExists "$PROGRAMFILES\IObit\Malware Fighter\IMF.exe" "IObitMalwareFighterDown" "IObitMalwareFighterEnd"
	 StrCmp $0 "1" "IObitMalwareFighterDown" "IObitMalwareFighterEnd"
  	 ${If} $0 == "1"
    	   IObitMalwareFighterDown:

                SetShellVarContext "all"

		; === Get Toolbox URL from .ini file ===
		ReadINIStr $0 "$PLUGINSDIR\Toolbox.ini" "Toolbox_104" "File_1"
		${GetOptions} "|$0" "|URL:" $1

		; === Get file name of Toolbox from .ini file ===
		${GetOptions} "|$0" "|NAME:" $2

		; === Get Toolbox Already Exist ===
        	MessageBox MB_YESNO|MB_USERICON 'Warnig!$\n$\n$2 already exists.$\n$\nDo you want to download it again?' IDYES "IObitMalwareFighterEnd" IDNO "IObitMalwareFighterExit"
        	Abort

        	GoTo IObitMalwareFighterExit

  	 ${ElseIf} $0 == "0"
    	   IObitMalwareFighterEnd:

                SetShellVarContext "all"

		RMDir /r "$TEMP\Toolbox"
		CreateDirectory "$TEMP\Toolbox"

		; === Get Toolbox URL from .ini file ===
		ReadINIStr $0 "$PLUGINSDIR\Toolbox.ini" "Toolbox_104" "File_1"
		${GetOptions} "|$0" "|URL:" $1

		; === Get file name of Toolbox from .ini file ===
		${GetOptions} "|$0" "|NAME:" $2

		; === Download and install Toolbox ===
		inetc::get /POPUP "" /CAPTION "$2" "$1" "$TEMP\Toolbox\$2" /END
		Pop $0
		StrCmp $0 "OK" +3
		  MessageBox MB_USERICON "Download of $2: $0"
		Goto +3

                SetShellVarContext "all"

      		ExecWait '"$TEMP\Toolbox\$2" /VERYSILENT /NORESTART'

        	GoTo IObitMalwareFighterExit

  	 ${EndIf}
	 IObitMalwareFighterExit:
       ${EndIf}

       # Prograss (25%) Installing #
       IntOp $R1 $R1 + 1
       SendMessage $ProgressBar ${PBM_SETPOS} "$R1" "0"
       SendMessage $INSTALL_PERCENT ${WM_SETTEXT} 0 "STR:$R1%"
       ${TBProgress} $R1

       # ...:: IObit Unlocker ::... #

       ${If} $Bool_Yes_Install_IUK == 1
  	 IfFileExists "$PROGRAMFILES\IObit\IObit Unlocker\IObitUnlocker.exe" "IObitUnlockerDown" "IObitUnlockerEnd"
	 StrCmp $0 "1" "IObitUnlockerDown" "IObitUnlockerEnd"
  	 ${If} $0 == "1"
    	   IObitUnlockerDown:

                SetShellVarContext "all"

		; === Get Toolbox Already Exist ===
        	MessageBox MB_YESNO|MB_USERICON 'Warnig!$\n$\nIObit Unlocker already exists.$\n$\nDo you want to download it again?' IDYES "IObitUnlockerEnd" IDNO "IObitUnlockerExit"
        	Abort

        	GoTo IObitUnlockerExit

  	 ${ElseIf} $0 == "0"
    	   IObitUnlockerEnd:

                SetShellVarContext "all"

		RMDir /r "$TEMP\Toolbox"
		CreateDirectory "$TEMP\Toolbox"

		; === Download and install Toolbox ===
		inetc::get /POPUP "" /CAPTION "unlocker-setup.exe" "http://update.iobit.com/dl/unlocker-setup.exe" "$TEMP\Toolbox\unlocker-setup.exe" /END
		Pop $0
		StrCmp $0 "OK" +3
		  MessageBox MB_USERICON "Download of unlocker-setup.exe: $0"
		Goto +3

                SetShellVarContext "all"

      		ExecWait '"$TEMP\Toolbox\unlocker-setup.exe" /VERYSILENT /NORESTART'

        	GoTo IObitUnlockerExit

  	 ${EndIf}
	 IObitUnlockerExit:
       ${EndIf}

       # ...:: IObit Undelete ::... #

       ${If} $Bool_Yes_Install_IUD == 1
  	 IfFileExists "$PROGRAMFILES\IObit\IObit Undelete\IObit-Undelete.exe" "IObitUndeleteDown" "IObitUndeleteEnd"
	 StrCmp $0 "1" "IObitUndeleteDown" "IObitUndeleteEnd"
  	 ${If} $0 == "1"
    	   IObitUndeleteDown:

                SetShellVarContext "all"

		; === Get Toolbox Already Exist ===
        	MessageBox MB_YESNO|MB_USERICON 'Warnig!$\n$\nIObit Undelete already exists.$\n$\nDo you want to download it again?' IDYES "IObitUndeleteEnd" IDNO "IObitUndeleteExit"
        	Abort

        	GoTo IObitUndeleteExit

  	 ${ElseIf} $0 == "0"
    	   IObitUndeleteEnd:

                SetShellVarContext "all"

		RMDir /r "$TEMP\Toolbox"
		CreateDirectory "$TEMP\Toolbox"

		; === Download and install Toolbox ===
		inetc::get /POPUP "" /CAPTION "IObit-Undelete.exe" "http://update.iobit.com/dl/IObit-Undelete.exe" "$TEMP\Toolbox\IObit-Undelete.exe" /END
		Pop $0
		StrCmp $0 "OK" +3
		  MessageBox MB_USERICON "Download of IObit-Undelete.exe: $0"
		Goto +3

                SetShellVarContext "all"
		CreateDirectory "$PROGRAMFILES\IObit\IObit Undelete"
    		  ${CopyFolders} "$TEMP\Toolbox" "$PROGRAMFILES\IObit\IObit Undelete"

                SetShellVarContext "all"
                CreateShortCut "$DESKTOP\IObit Undelete.lnk" "$PROGRAMFILES\IObit\IObit Undelete\IObit-Undelete.exe"

        	GoTo IObitUndeleteExit

  	 ${EndIf}
	 IObitUndeleteExit:
       ${EndIf}

       # ...:: IObit PCtransfer ::... #

       ${If} $Bool_Yes_Install_IPC == 1
  	 IfFileExists "$PROGRAMFILES\IObit\PCtransfer\PCtransfer.exe" "IObitPCtransferDown" "IObitPCtransferEnd"
	 StrCmp $0 "1" "IObitPCtransferDown" "IObitPCtransferEnd"
  	 ${If} $0 == "1"
    	   IObitPCtransferDown:

                SetShellVarContext "all"

		; === Get Toolbox Already Exist ===
        	MessageBox MB_YESNO|MB_USERICON 'Warnig!$\n$\nIObit PCtransfer already exists.$\n$\nDo you want to download it again?' IDYES "IObitPCtransferEnd" IDNO "IObitPCtransferExit"
        	Abort

        	GoTo IObitPCtransferExit

  	 ${ElseIf} $0 == "0"
    	   IObitPCtransferEnd:

                SetShellVarContext "all"
		RMDir /r "$TEMP\Toolbox"
		CreateDirectory "$TEMP\Toolbox"

		; === Download and install Toolbox ===
		inetc::get /POPUP "" /CAPTION "pctransfer.exe" "http://update.iobit.com/dl/pctransfer.exe" "$TEMP\Toolbox\pctransfer.exe" /END
		Pop $0
		StrCmp $0 "OK" +3
		  MessageBox MB_USERICON "Download of pctransfer.exe: $0"
		Goto +3

                SetShellVarContext "all"
		CreateDirectory "$PROGRAMFILES\IObit\PCtransfer"

      		ExecWait '"$TEMP\Toolbox\pctransfer.exe" /VERYSILENT /NORESTART'

                SetShellVarContext "all"
                CreateShortCut "$DESKTOP\IObit PCtransfer.lnk" "$PROGRAMFILES\IObit\PCtransfer\PCtransfer.exe"

        	GoTo IObitPCtransferExit

  	 ${EndIf}
	 IObitPCtransferExit:
       ${EndIf}

       # ...:: IObit Protect Folder ::... #

       ${If} $Bool_Yes_Install_IPF == 1
  	 IfFileExists "$PROGRAMFILES\IObit\Protected Folder\ProtectedFolder.exe" "IObitProtectedFolderDown" "IObitProtectedFolderEnd"
	 StrCmp $0 "1" "IObitProtectedFolderDown" "IObitProtectedFolderEnd"
  	 ${If} $0 == "1"
    	   IObitProtectedFolderDown:

                SetShellVarContext "all"

		; === Get Toolbox Already Exist ===
        	MessageBox MB_YESNO|MB_USERICON 'Warnig!$\n$\nIObit Protected Folder already exists.$\n$\nDo you want to download it again?' IDYES "IObitProtectedFolderEnd" IDNO "IObitProtectedFolderExit"
        	Abort

        	GoTo IObitProtectedFolderExit

  	 ${ElseIf} $0 == "0"
    	   IObitProtectedFolderEnd:

                SetShellVarContext "all"

		RMDir /r "$TEMP\Toolbox"
		CreateDirectory "$TEMP\Toolbox"

		; === Download and install Toolbox ===
		inetc::get /POPUP "" /CAPTION "protected-folder-setup.exe" "http://update.iobit.com/dl/protected-folder-setup.exe" "$TEMP\Toolbox\protected-folder-setup.exe" /END
		Pop $0
		StrCmp $0 "OK" +3
		  MessageBox MB_USERICON "Download of protected-folder-setup.exe: $0"
		Goto +3

                SetShellVarContext "all"

      		ExecWait '"$TEMP\Toolbox\protected-folder-setup.exe" /VERYSILENT /NORESTART'

        	GoTo IObitProtectedFolderExit

  	 ${EndIf}
	 IObitProtectedFolderExit:
       ${EndIf}

    ${Else} 

      DetailPrint "$NO_INTERNET_CONNECTION_LANGUAGE"

    ${EndIf} 

    # Prograss (25%) Installing #
    IntOp $R1 $R1 + 1
    SendMessage $ProgressBar ${PBM_SETPOS} "$R1" "0"
    SendMessage $INSTALL_PERCENT ${WM_SETTEXT} 0 "STR:$R1%"
    ${TBProgress} $R1

    IfFileExists "$INSTDIR\NSIS.exe" "done1" "NSIS.Failed.Install.Standard"

    Sleep 100
    StrCmp $R1 "100" 0 loop1
  done1:

  loop2: 
    IntCmp $R1 $R0 done2 0 done2
    IntOp $R1 $R1 + 1
    SendMessage $ProgressBar ${PBM_SETPOS} "$R1" "0"
    SendMessage $INSTALL_PERCENT ${WM_SETTEXT} 0 "STR:$R1%"
    ${TBProgress} $R1

    DetailPrint `$CHECK_INSTALL_LANGUAGE`

    SetAutoClose true 

    Sleep 100
    StrCmp $R1 "100" 0 loop2
  done2:

  # Check If Installed #

  IfFileExists "$INSTDIR\NSIS.exe" "NSIS.Successfully.Install.Standard" "NSIS.Failed.Install.Standard"
  StrCmp $0 1 "NSIS.Successfully.Install.Standard" "NSIS.Failed.Install.Standard"
  ${If} $0 == "1"
    NSIS.Successfully.Install.Standard:

      SendMessage $ProgressBar ${PBM_SETRANGE32} "0" "100"
      SendMessage $ProgressBar ${PBM_SETPOS} "100" "0"
      SendMessage $INSTALL_PERCENT ${WM_SETTEXT} 0 "STR:100%"

      ${GetSize} "$INSTDIR" "/M=*.* /S=0K" $0 $1 $2
      IfErrors 0 +2
      StrCpy $0 $0 * 1024
      IntCmp $0 100 +3 0 +3
        IntCmp $0 0 +2 +2 0
        IntOp $0 103 + 0
      IntOp $0 $0 * 10
      IntOp $0 $0 / 1024
      StrCpy $1 "$0" "" -1
      IntCmp $0 9 +3 +3 0
        StrCpy $0 "$0" -1 ""
        Goto +2
        StrCpy $0 "0"

      Sleep 2500

      DetailPrint `$SUCESSFULLY_INSTALL_LANGUAGE - $SIZE_INSTALL_LANGUAGE $0.$1 Mib`

      Call RefreshShellIcons

      StrCpy $R9 1
      Call RelGotoPage
      SetAutoClose true 
     Abort

  ${ElseIf} $0 == "0"
    NSIS.Failed.Install.Standard:

      SendMessage $ProgressBar ${PBM_SETRANGE32} "0" "100"
      SendMessage $ProgressBar ${PBM_SETPOS} "100" "0"
      SendMessage $INSTALL_PERCENT ${WM_SETTEXT} 0 "STR:100%"

      Sleep 2500

      DetailPrint `$FAILED_INSTALL_LANGUAGE`

      StrCpy $R9 1
      Call RelGotoPage
      SetAutoClose true 
     Abort

  ${Endif} 

  # === PORTABLE === #

  ${Else}

    IfFileExists "$INSTDIR\*.*" "NSIS.Detect.Prewiev.Portable" "NSIS.Not.Detect.Portable"
    StrCmp $0 1 "NSIS.Detect.Prewiev.Portable" "NSIS.Not.Detect.Portable"
    ${If} "$0" == "1"
      NSIS.Detect.Prewiev.Portable:

      setShellVarContext all

      ClearErrors

      RMDir /r '$INSTDIR'

      GoTo NSIS.Continue.Install.Portable

    ${ElseIf} $0 == "0"
      NSIS.Not.Detect.Portable:

      GoTo NSIS.Continue.Install.Portable

    ${EndIf}

    NSIS.Continue.Install.Portable:

  DetailPrint `Start install 5 seconds`

  IntFmt $R1 "0x%08X" 5

  ${GetTime} "" "L" $0 $1 $2 $3 $4 $5 $6
  Strcpy $R2 $6

  loop4:

  ${GetTime} "" "L" $0 $1 $2 $3 $4 $5 $6

  Strcmp $R2 $6 loop4 0
  Strcpy $R2 $6
  IntOp $R1 $R1 - 1
  IntCmp $R1 0 +3 +3 0
    DetailPrint `Start install $R1 seconds`
  goto loop4

  loop5: 
    IntCmp $R1 $R0 done5 0 done5
    IntOp $R1 $R1 + 1
    SendMessage $ProgressBar ${PBM_SETPOS} "$R1""0"

    DetailPrint `Progress installing ... $R1%`

    ${TBProgress} $R1

    SetOutPath "$INSTDIR\App\NSIS\Bin"
    File /r /x thumbs.db "NSIS\Bin\*.*"

    # Prograss (25%) Installing #
    IntOp $R1 $R1 + 1
    SendMessage $ProgressBar ${PBM_SETPOS} "$R1" "0"
    SendMessage $INSTALL_PERCENT ${WM_SETTEXT} 0 "STR:$R1%"
    ${TBProgress} $R1

    SetOutPath "$INSTDIR\App\NSIS\Contrib"
    File /r /x thumbs.db "NSIS\Contrib\*.*"

    # Prograss (25%) Installing #
    IntOp $R1 $R1 + 1
    SendMessage $ProgressBar ${PBM_SETPOS} "$R1" "0"
    SendMessage $INSTALL_PERCENT ${WM_SETTEXT} 0 "STR:$R1%"
    ${TBProgress} $R1

    SetOutPath "$INSTDIR\App\NSIS\Docs"
    File /r /x thumbs.db "NSIS\Docs\*.*"

    # Prograss (25%) Installing #
    IntOp $R1 $R1 + 1
    SendMessage $ProgressBar ${PBM_SETPOS} "$R1" "0"
    SendMessage $INSTALL_PERCENT ${WM_SETTEXT} 0 "STR:$R1%"
    ${TBProgress} $R1

    SetOutPath "$INSTDIR\App\NSIS\Examples"
    File /r /x thumbs.db "NSIS\Examples\*.*"

    # Prograss (25%) Installing #
    IntOp $R1 $R1 + 1
    SendMessage $ProgressBar ${PBM_SETPOS} "$R1" "0"
    SendMessage $INSTALL_PERCENT ${WM_SETTEXT} 0 "STR:$R1%"
    ${TBProgress} $R1

    SetOutPath "$INSTDIR\App\NSIS\Include"
    File /r /x thumbs.db "NSIS\Include\*.*"

    # Prograss (25%) Installing #
    IntOp $R1 $R1 + 1
    SendMessage $ProgressBar ${PBM_SETPOS} "$R1" "0"
    SendMessage $INSTALL_PERCENT ${WM_SETTEXT} 0 "STR:$R1%"
    ${TBProgress} $R1

    SetOutPath "$INSTDIR\App\NSIS\Menu"
    File /r /x thumbs.db "NSIS\Menu\*.*"

    # Prograss (25%) Installing #
    IntOp $R1 $R1 + 1
    SendMessage $ProgressBar ${PBM_SETPOS} "$R1" "0"
    SendMessage $INSTALL_PERCENT ${WM_SETTEXT} 0 "STR:$R1%"
    ${TBProgress} $R1

    SetOutPath "$INSTDIR\App\NSIS\Plugins"
    File /r /x thumbs.db "NSIS\Plugins\*.*"

    # Prograss (25%) Installing #
    IntOp $R1 $R1 + 1
    SendMessage $ProgressBar ${PBM_SETPOS} "$R1" "0"
    SendMessage $INSTALL_PERCENT ${WM_SETTEXT} 0 "STR:$R1%"
    ${TBProgress} $R1

    SetOutPath "$INSTDIR\App\NSIS\Stubs"
    File /r /x thumbs.db "NSIS\Stubs\*.*"

    # Prograss (25%) Installing #
    IntOp $R1 $R1 + 1
    SendMessage $ProgressBar ${PBM_SETPOS} "$R1" "0"
    SendMessage $INSTALL_PERCENT ${WM_SETTEXT} 0 "STR:$R1%"
    ${TBProgress} $R1

    SetOutPath "$INSTDIR\App\NSIS"
    File /r /x thumbs.db "NSIS\COPYING"
    File /r /x thumbs.db "NSIS\NSIS.chm"
    File /r /x thumbs.db "NSIS\NSIS.exe"
    File /r /x thumbs.db "NSIS\nsisconf.nsh"

    # Prograss (25%) Installing #
    IntOp $R1 $R1 + 1
    SendMessage $ProgressBar ${PBM_SETPOS} "$R1" "0"
    SendMessage $INSTALL_PERCENT ${WM_SETTEXT} 0 "STR:$R1%"
    ${TBProgress} $R1

    ${If} $LANGUAGE == 1033 ; ENGLISH
       SetOutPath "$INSTDIR\App\NSIS"
       File /r /x thumbs.db "English\*.*"
    ${ElseIf} $LANGUAGE == 1048 ; ROMANIAN
       SetOutPath "$INSTDIR\App\NSIS"
       File /r /x thumbs.db "Romanian\*.*"
    ${EndIf}

    SetOutPath "$INSTDIR"
    File "Portable\NSIS Portable.exe"
    File "Portable\Makensisw Portable.exe"

    FileOpen $0 "$INSTDIR\App\NSIS\portable.dat" w
    FileWrite $0 "# PORTABLE #"
    FileWriteByte $0 "13"
    FileWriteByte $0 "10"
    FileWrite $0 "Install Mode: Portable Version"
    FileWriteByte $0 "13"
    FileWriteByte $0 "10"
    FileClose $0

    # Prograss (25%) Installing #
    IntOp $R1 $R1 + 1
    SendMessage $ProgressBar ${PBM_SETPOS} "$R1" "0"
    SendMessage $INSTALL_PERCENT ${WM_SETTEXT} 0 "STR:$R1%"
    ${TBProgress} $R1

    # ...:: IObit ::... #

    ${CheckInternetConnection} "https://www.iobit.com/en/index.php" $0 
    ${If} $0 == "OK" 

      DetailPrint "$YES_INTERNET_CONNECTION_LANGUAGE"

      DetailPrint "$CONNECT_SERVER_LANGUAGE"

       # ...:: IObit Uninstaller ::... #

       ${If} $Bool_Yes_Install_IU == 1
  	  IfFileExists "$PROGRAMFILES\IObit\IObit Uninstaller\IObitUninstaler.exe" "IObitUninstallerDown1" "IObitUninstallerEnd1"
	  StrCmp $0 "1" "IObitUninstallerDown1" "IObitUninstallerEnd1"
  	  ${If} $0 == "1"
    	    IObitUninstallerDown1:

                SetShellVarContext "all"

		; === Get Toolbox URL from .ini file ===
		ReadINIStr $0 "$PLUGINSDIR\Toolbox.ini" "Toolbox_102" "File_1"
		${GetOptions} "|$0" "|URL:" $1

		; === Get file name of Toolbox from .ini file ===
		${GetOptions} "|$0" "|NAME:" $2

		; === Get Toolbox Already Exist ===
        	MessageBox MB_YESNO|MB_USERICON 'Warnig!$\n$\n$2 already exists.$\n$\nDo you want to download it again?' IDYES "IObitUninstallerEnd1" IDNO "IObitUninstallerExit1"
        	Abort

             GoTo IObitUninstallerExit1

  	  ${ElseIf} $0 == "0"
    	     IObitUninstallerEnd1:

                SetShellVarContext "all"

		RMDir /r "$TEMP\Toolbox"
		CreateDirectory "$TEMP\Toolbox"

		; === Get Toolbox URL from .ini file ===
		ReadINIStr $0 "$PLUGINSDIR\Toolbox.ini" "Toolbox_102" "File_1"
		${GetOptions} "|$0" "|URL:" $1

		; === Get file name of Toolbox from .ini file ===
		${GetOptions} "|$0" "|NAME:" $2

		; === Download and install Toolbox ===
		inetc::get /POPUP "" /CAPTION "$2" "$1" "$TEMP\Toolbox\$2" /END
		Pop $0
		StrCmp $0 "OK" +3
		  MessageBox MB_USERICON "Download of $2: $0"
		Goto +3

                SetShellVarContext "all"

      		ExecWait '"$TEMP\Toolbox\$2" /VERYSILENT /NORESTART'

              GoTo IObitUninstallerExit1

  	  ${EndIf}
	  IObitUninstallerExit1:
       ${EndIf}

       # Prograss (25%) Installing #
       IntOp $R1 $R1 + 1
       SendMessage $ProgressBar ${PBM_SETPOS} "$R1" "0"
       SendMessage $INSTALL_PERCENT ${WM_SETTEXT} 0 "STR:$R1%"
       ${TBProgress} $R1

       # ...:: IObit Driver Booster ::... #

       ${If} $Bool_Yes_Install_DB == 1
  	  IfFileExists "$PROGRAMFILES\IObit\Driver Booster\DriverBooster.exe" "IObitDriverBoosterDown1" "IObitDriverBoosterEnd1"
	  StrCmp $0 "1" "IObitDriverBoosterDown1" "IObitDriverBoosterEnd1"
  	  ${If} $0 == "1"
    	    IObitDriverBoosterDown1:

                SetShellVarContext "all"

		; === Get Toolbox URL from .ini file ===
		ReadINIStr $0 "$PLUGINSDIR\Toolbox.ini" "Toolbox_101" "File_1"
		${GetOptions} "|$0" "|URL:" $1

		; === Get file name of Toolbox from .ini file ===
		${GetOptions} "|$0" "|NAME:" $2

		; === Get Toolbox Already Exist ===
        	MessageBox MB_YESNO|MB_USERICON 'Warnig!$\n$\n$2 already exists.$\n$\nDo you want to download it again?' IDYES "IObitDriverBoosterEnd1" IDNO "IObitDriverBoosterExit1"
        	Abort

        	GoTo IObitDriverBoosterExit1

  	  ${ElseIf} $0 == "0"
    	    IObitDriverBoosterEnd1:

                SetShellVarContext "all"
		RMDir /r "$TEMP\Toolbox"
		CreateDirectory "$TEMP\Toolbox"

		; === Get Toolbox URL from .ini file ===
		ReadINIStr $0 "$PLUGINSDIR\Toolbox.ini" "Toolbox_101" "File_1"
		${GetOptions} "|$0" "|URL:" $1

		; === Get file name of Toolbox from .ini file ===
		${GetOptions} "|$0" "|NAME:" $2

		; === Download and install Toolbox ===
		inetc::get /POPUP "" /CAPTION "$2" "$1" "$TEMP\Toolbox\$2" /END
		Pop $0
		StrCmp $0 "OK" +3
		  MessageBox MB_USERICON "Download of $2: $0"
		Goto +3

                SetShellVarContext "all"

      		ExecWait '"$TEMP\Toolbox\$2" /VERYSILENT /NORESTART'

        	GoTo IObitDriverBoosterExit1

  	  ${EndIf}
	  IObitDriverBoosterExit1:
       ${EndIf}

       # Prograss (25%) Installing #
       IntOp $R1 $R1 + 1
       SendMessage $ProgressBar ${PBM_SETPOS} "$R1" "0"
       SendMessage $INSTALL_PERCENT ${WM_SETTEXT} 0 "STR:$R1%"
       ${TBProgress} $R1

       # ...:: IObit Smart Defrag ::... #

       ${If} $Bool_Yes_Install_SM == 1
  	 IfFileExists "$PROGRAMFILES\IObit\Smart Defrag\SmartDefrag.exe" "IObitSmartDefragDown1" "IObitSmartDefragEnd1"
	 StrCmp $0 "1" "IObitSmartDefragDown1" "IObitSmartDefragEnd1"
         ${If} $0 == "1"
    	   IObitSmartDefragDown1:

                SetShellVarContext "all"

		; === Get Toolbox URL from .ini file ===
		ReadINIStr $0 "$PLUGINSDIR\Toolbox.ini" "Toolbox_103" "File_1"
		${GetOptions} "|$0" "|URL:" $1

		; === Get file name of Toolbox from .ini file ===
		${GetOptions} "|$0" "|NAME:" $2

		; === Get Toolbox Already Exist ===
        	MessageBox MB_YESNO|MB_USERICON 'Warnig!$\n$\n$2 already exists.$\n$\nDo you want to download it again?' IDYES "IObitSmartDefragEnd1" IDNO "IObitSmartDefragExit1"
        	Abort

        	GoTo IObitSmartDefragExit1

         ${ElseIf} $0 == "0"
    	   IObitSmartDefragEnd1:

                SetShellVarContext "all"
		RMDir /r "$TEMP\Toolbox"
		CreateDirectory "$TEMP\Toolbox"

		; === Get Toolbox URL from .ini file ===
		ReadINIStr $0 "$PLUGINSDIR\Toolbox.ini" "Toolbox_103" "File_1"
		${GetOptions} "|$0" "|URL:" $1

		; === Get file name of Toolbox from .ini file ===
		${GetOptions} "|$0" "|NAME:" $2

		; === Download and install Toolbox ===
		inetc::get /POPUP "" /CAPTION "$2" "$1" "$TEMP\Toolbox\$2" /END
		Pop $0
		StrCmp $0 "OK" +3
		   MessageBox MB_USERICON "Download of $2: $0"
		Goto +3

                SetShellVarContext "all"

      		ExecWait '"$TEMP\Toolbox\$2" /VERYSILENT /NORESTART'

        	GoTo IObitSmartDefragExit1

         ${EndIf}
	 IObitSmartDefragExit1:
       ${EndIf}

       # Prograss (25%) Installing #
       IntOp $R1 $R1 + 1
       SendMessage $ProgressBar ${PBM_SETPOS} "$R1" "0"
       SendMessage $INSTALL_PERCENT ${WM_SETTEXT} 0 "STR:$R1%"
       ${TBProgress} $R1

       # ...:: IObit Advanced SystemCare ::... #

       ${If} $Bool_Yes_Install_ASC == 1
  	 IfFileExists "$PROGRAMFILES\IObit\Advanced SystemCare\ASC.exe" "IObitAdvancedSystemCareDown1" "IObitAdvancedSystemCareEnd1"
	 StrCmp $0 "1" "IObitAdvancedSystemCareDown1" "IObitAdvancedSystemCareEnd1"
  	 ${If} $0 == "1"
    	   IObitAdvancedSystemCareDown1:

                SetShellVarContext "all"

		; === Get Toolbox Already Exist ===
        	MessageBox MB_YESNO|MB_USERICON 'Warnig!$\n$\nIObit Advanced SystemCare already exists.$\n$\nDo you want to download it again?' IDYES "IObitAdvancedSystemCareEnd1" IDNO "IObitAdvancedSystemCareExit1"
        	Abort

        	GoTo IObitAdvancedSystemCareExit1

  	 ${ElseIf} $0 == "0"
    	   IObitAdvancedSystemCareEnd1:

                SetShellVarContext "all"
		RMDir /r "$TEMP\Toolbox"
		CreateDirectory "$TEMP\Toolbox"

		; === Download and install Toolbox ===
		inetc::get /POPUP "" /CAPTION "advanced-systemcare-setup.exe" "http://update.iobit.com/dl/advanced-systemcare-setup.exe" "$TEMP\Toolbox\advanced-systemcare-setup.exe" /END
		Pop $0
		StrCmp $0 "OK" +3
		  MessageBox MB_USERICON "Download of advanced-systemcare-setup.exe: $0"
		Goto +3

                SetShellVarContext "all"

      		ExecWait '"$TEMP\Toolbox\advanced-systemcare-setup.exe" /VERYSILENT /NORESTART'

        	GoTo IObitAdvancedSystemCareExit1

  	 ${EndIf}
	 IObitAdvancedSystemCareExit1:
       ${EndIf}

       # Prograss (25%) Installing #
       IntOp $R1 $R1 + 1
       SendMessage $ProgressBar ${PBM_SETPOS} "$R1" "0"
       SendMessage $INSTALL_PERCENT ${WM_SETTEXT} 0 "STR:$R1%"
       ${TBProgress} $R1

       # ...:: IObit Malware Fighter ::... #

       ${If} $Bool_Yes_Install_IMF == 1
  	 IfFileExists "$PROGRAMFILES\IObit\Malware Fighter\IMF.exe" "IObitMalwareFighterDown1" "IObitMalwareFighterEnd1"
	 StrCmp $0 "1" "IObitMalwareFighterDown1" "IObitMalwareFighterEnd1"
  	 ${If} $0 == "1"
    	   IObitMalwareFighterDown1:

                SetShellVarContext "all"

		; === Get Toolbox URL from .ini file ===
		ReadINIStr $0 "$PLUGINSDIR\Toolbox.ini" "Toolbox_104" "File_1"
		${GetOptions} "|$0" "|URL:" $1

		; === Get file name of Toolbox from .ini file ===
		${GetOptions} "|$0" "|NAME:" $2

		; === Get Toolbox Already Exist ===
        	MessageBox MB_YESNO|MB_USERICON 'Warnig!$\n$\n$2 already exists.$\n$\nDo you want to download it again?' IDYES "IObitMalwareFighterEnd1" IDNO "IObitMalwareFighterExit1"
        	Abort

        	GoTo IObitMalwareFighterExit1

  	 ${ElseIf} $0 == "0"
    	   IObitMalwareFighterEnd1:

                SetShellVarContext "all"

		RMDir /r "$TEMP\Toolbox"
		CreateDirectory "$TEMP\Toolbox"

		; === Get Toolbox URL from .ini file ===
		ReadINIStr $0 "$PLUGINSDIR\Toolbox.ini" "Toolbox_104" "File_1"
		${GetOptions} "|$0" "|URL:" $1

		; === Get file name of Toolbox from .ini file ===
		${GetOptions} "|$0" "|NAME:" $2

		; === Download and install Toolbox ===
		inetc::get /POPUP "" /CAPTION "$2" "$1" "$TEMP\Toolbox\$2" /END
		Pop $0
		StrCmp $0 "OK" +3
		  MessageBox MB_USERICON "Download of $2: $0"
		Goto +3

                SetShellVarContext "all"

      		ExecWait '"$TEMP\Toolbox\$2" /VERYSILENT /NORESTART'

        	GoTo IObitMalwareFighterExit1

  	 ${EndIf}
	 IObitMalwareFighterExit1:
       ${EndIf}

       # Prograss (25%) Installing #
       IntOp $R1 $R1 + 1
       SendMessage $ProgressBar ${PBM_SETPOS} "$R1" "0"
       SendMessage $INSTALL_PERCENT ${WM_SETTEXT} 0 "STR:$R1%"
       ${TBProgress} $R1

       # ...:: IObit Unlocker ::... #

       ${If} $Bool_Yes_Install_IUK == 1
  	 IfFileExists "$PROGRAMFILES\IObit\IObit Unlocker\IObitUnlocker.exe" "IObitUnlockerDown1" "IObitUnlockerEnd1"
	 StrCmp $0 "1" "IObitUnlockerDown" "IObitUnlockerEnd1"
  	 ${If} $0 == "1"
    	   IObitUnlockerDown1:

                SetShellVarContext "all"

		; === Get Toolbox Already Exist ===
        	MessageBox MB_YESNO|MB_USERICON 'Warnig!$\n$\nIObit Unlocker already exists.$\n$\nDo you want to download it again?' IDYES "IObitUnlockerEnd1" IDNO "IObitUnlockerExit1"
        	Abort

        	GoTo IObitUnlockerExit1

  	 ${ElseIf} $0 == "0"
    	   IObitUnlockerEnd1:

                SetShellVarContext "all"

		RMDir /r "$TEMP\Toolbox"
		CreateDirectory "$TEMP\Toolbox"

		; === Download and install Toolbox ===
		inetc::get /POPUP "" /CAPTION "unlocker-setup.exe" "http://update.iobit.com/dl/unlocker-setup.exe" "$TEMP\Toolbox\unlocker-setup.exe" /END
		Pop $0
		StrCmp $0 "OK" +3
		  MessageBox MB_USERICON "Download of unlocker-setup.exe: $0"
		Goto +3

                SetShellVarContext "all"

      		ExecWait '"$TEMP\Toolbox\unlocker-setup.exe" /VERYSILENT /NORESTART'

        	GoTo IObitUnlockerExit1

  	 ${EndIf}
	 IObitUnlockerExit1:
       ${EndIf}

       # ...:: IObit Undelete ::... #

       ${If} $Bool_Yes_Install_IUD == 1
  	 IfFileExists "$PROGRAMFILES\IObit\IObit Undelete\IObit-Undelete.exe" "IObitUndeleteDown1" "IObitUndeleteEnd1"
	 StrCmp $0 "1" "IObitUndeleteDown1" "IObitUndeleteEnd1"
  	 ${If} $0 == "1"
    	   IObitUndeleteDown1:

                SetShellVarContext "all"

		; === Get Toolbox Already Exist ===
        	MessageBox MB_YESNO|MB_USERICON 'Warnig!$\n$\nIObit Undelete already exists.$\n$\nDo you want to download it again?' IDYES "IObitUndeleteEnd1" IDNO "IObitUndeleteExit1"
        	Abort

        	GoTo IObitUndeleteExit1

  	 ${ElseIf} $0 == "0"
    	   IObitUndeleteEnd1:

                SetShellVarContext "all"

		RMDir /r "$TEMP\Toolbox"
		CreateDirectory "$TEMP\Toolbox"

		; === Download and install Toolbox ===
		inetc::get /POPUP "" /CAPTION "IObit-Undelete.exe" "http://update.iobit.com/dl/IObit-Undelete.exe" "$TEMP\Toolbox\IObit-Undelete.exe" /END
		Pop $0
		StrCmp $0 "OK" +3
		  MessageBox MB_USERICON "Download of IObit-Undelete.exe: $0"
		Goto +3

                SetShellVarContext "all"
		CreateDirectory "$PROGRAMFILES\IObit\IObit Undelete"
    		  ${CopyFolders} "$TEMP\Toolbox" "$PROGRAMFILES\IObit\IObit Undelete"

                SetShellVarContext "all"
                CreateShortCut "$DESKTOP\IObit Undelete.lnk" "$PROGRAMFILES\IObit\IObit Undelete\IObit-Undelete.exe"

        	GoTo IObitUndeleteExit1

  	 ${EndIf}
	 IObitUndeleteExit1:
       ${EndIf}

       # ...:: IObit PCtransfer ::... #

       ${If} $Bool_Yes_Install_IPC == 1
  	 IfFileExists "$PROGRAMFILES\IObit\PCtransfer\PCtransfer.exe" "IObitPCtransferDown1" "IObitPCtransferEnd1"
	 StrCmp $0 "1" "IObitPCtransferDown1" "IObitPCtransferEnd1"
  	 ${If} $0 == "1"
    	   IObitPCtransferDown1:

                SetShellVarContext "all"

		; === Get Toolbox Already Exist ===
        	MessageBox MB_YESNO|MB_USERICON 'Warnig!$\n$\nIObit PCtransfer already exists.$\n$\nDo you want to download it again?' IDYES "IObitPCtransferEnd1" IDNO "IObitPCtransferExit1"
        	Abort

        	GoTo IObitPCtransferExit1

  	 ${ElseIf} $0 == "0"
    	   IObitPCtransferEnd1:

                SetShellVarContext "all"
		RMDir /r "$TEMP\Toolbox"
		CreateDirectory "$TEMP\Toolbox"

		; === Download and install Toolbox ===
		inetc::get /POPUP "" /CAPTION "pctransfer.exe" "http://update.iobit.com/dl/pctransfer.exe" "$TEMP\Toolbox\pctransfer.exe" /END
		Pop $0
		StrCmp $0 "OK" +3
		  MessageBox MB_USERICON "Download of pctransfer.exe: $0"
		Goto +3

                SetShellVarContext "all"
		CreateDirectory "$PROGRAMFILES\IObit\PCtransfer"

      		ExecWait '"$TEMP\Toolbox\pctransfer.exe" /VERYSILENT /NORESTART'

                SetShellVarContext "all"
                CreateShortCut "$DESKTOP\IObit PCtransfer.lnk" "$PROGRAMFILES\IObit\PCtransfer\PCtransfer.exe"

        	GoTo IObitPCtransferExit1

  	 ${EndIf}
	 IObitPCtransferExit1:
       ${EndIf}

       # ...:: IObit Protect Folder ::... #

       ${If} $Bool_Yes_Install_IPF == 1
  	 IfFileExists "$PROGRAMFILES\IObit\Protected Folder\ProtectedFolder.exe" "IObitProtectedFolderDown1" "IObitProtectedFolderEnd1"
	 StrCmp $0 "1" "IObitProtectedFolderDown1" "IObitProtectedFolderEnd1"
  	 ${If} $0 == "1"
    	   IObitProtectedFolderDown1:

                SetShellVarContext "all"

		; === Get Toolbox Already Exist ===
        	MessageBox MB_YESNO|MB_USERICON 'Warnig!$\n$\nIObit Protected Folder already exists.$\n$\nDo you want to download it again?' IDYES "IObitProtectedFolderEnd1" IDNO "IObitProtectedFolderExit1"
        	Abort

        	GoTo IObitProtectedFolderExit1

  	 ${ElseIf} $0 == "0"
    	   IObitProtectedFolderEnd1:

                SetShellVarContext "all"

		RMDir /r "$TEMP\Toolbox"
		CreateDirectory "$TEMP\Toolbox"

		; === Download and install Toolbox ===
		inetc::get /POPUP "" /CAPTION "protected-folder-setup.exe" "http://update.iobit.com/dl/protected-folder-setup.exe" "$TEMP\Toolbox\protected-folder-setup.exe" /END
		Pop $0
		StrCmp $0 "OK" +3
		  MessageBox MB_USERICON "Download of protected-folder-setup.exe: $0"
		Goto +3

                SetShellVarContext "all"

      		ExecWait '"$TEMP\Toolbox\protected-folder-setup.exe" /VERYSILENT /NORESTART'

        	GoTo IObitProtectedFolderExit1

  	 ${EndIf}
	 IObitProtectedFolderExit1:
       ${EndIf}

    ${Else} 

      DetailPrint "$NO_INTERNET_CONNECTION_LANGUAGE"

    ${EndIf} 

    IfFileExists "$INSTDIR\NSIS Portable.exe" "Done5" "NSIS.Failed.Install.Portable"

    Sleep 100
    StrCmp $R1 "100" 0 loop5
  done5:

  loop6: 
    IntCmp $R1 $R0 done6 0 done6
    IntOp $R1 $R1 + 1
    SendMessage $ProgressBar ${PBM_SETPOS} "$R1""0"

    DetailPrint `Checking integrity files ... $R1%`

    ${TBProgress} $R1

    SetAutoClose true 

    Sleep 100
    StrCmp $R1 "100" 0 loop6
  done6:

  IfFileExists "$INSTDIR\NSIS Portable.exe" "NSIS.Successfully.Install.Portable" "NSIS.Failed.Install.Portable"
  StrCmp $0 1 "NSIS.Successfully.Install.Portable" "NSIS.Failed.Install.Portable"
  ${If} $0 == "1"
    NSIS.Successfully.Install.Portable:

      SendMessage $ProgressBar ${PBM_SETRANGE32} "0" "100"
      SendMessage $ProgressBar ${PBM_SETPOS} "100" "0"
      SendMessage $INSTALL_PERCENT ${WM_SETTEXT} 0 "STR:100%"

      ${GetSize} "$INSTDIR" "/M=*.* /S=0K" $0 $1 $2
      IfErrors 0 +2
      StrCpy $0 $0 * 1024
      IntCmp $0 100 +3 0 +3
        IntCmp $0 0 +2 +2 0
        IntOp $0 103 + 0
      IntOp $0 $0 * 10
      IntOp $0 $0 / 1024
      StrCpy $1 "$0" "" -1
      IntCmp $0 9 +3 +3 0
        StrCpy $0 "$0" -1 ""
        Goto +2
        StrCpy $0 "0"

      Sleep 2500

      DetailPrint `$SUCESSFULLY_INSTALL_LANGUAGE - $SIZE_INSTALL_LANGUAGE $0.$1 Mib`

      Call RefreshShellIcons

      StrCpy $R9 1
      Call RelGotoPage
      SetAutoClose true 
     Abort

  ${ElseIf} $0 == "0"
    NSIS.Failed.Install.Portable:

      SendMessage $ProgressBar ${PBM_SETRANGE32} "0" "100"
      SendMessage $ProgressBar ${PBM_SETPOS} "100" "0"
      SendMessage $INSTALL_PERCENT ${WM_SETTEXT} 0 "STR:100%"

      Sleep 2500

      DetailPrint `$FAILED_INSTALL_LANGUAGE`

      StrCpy $R9 1
      Call RelGotoPage
      SetAutoClose true 
     Abort

  ${Endif} 

  ${EndIf}
SectionEnd

Function 'RelGotoPage'
   IntCmp $R9 0 0 Move Move
   StrCmp $R9 "X" 0 Move
   StrCpy $R9 "120"
 
   Move:
     SendMessage $HWNDPARENT "0x408" "$R9" ""
FunctionEnd 

!ifdef INIT
  Function "Init"
    StrCpy $0 0
    ${If} ${SectionIsSelected} $0
      SectionGetSize $${Main} $1
      IntOp $0 $0 + $1
    ${EndIf}	
    InTop $0 $0 * 1024
    IntOp $1 $0 / 1000000
    IntOp $2 $0 % 1000000
    StrCpy $2 $2 2 0
    IntOp $3 $0 / 1048576
    IntOp $4 $0 % 1048576
    StrCpy $4 $4 2 0
    SectionSetSize $${Main} "0" ;  ($1,$2 MB)
    Strcpy $ESTIM.INST.SIZE '$3,$4 MB'
  FunctionEnd
!endif

Section -Post
  System::Alloc 400 
  pop $2 
  Push $0
  ${TickCountEnd} $0
  System::Call 'kernel32::GetTickCount64()l.r0'
  System::Call 'kernel32::GetTickCount()i .r0'
  StrCmp $0 error 0 +2
  Exch $0
  System::Free $2
  System::Call 'kernel32::GetTickCount(v)i.r1'
  IntOp $0 $1 - $TickCount
  IntOp $2 $1 - $0
     IntOp $1 $0 / 1000
     IntOp $0 $0 % 1000
     IntOp $2 $1 / 60
     IntOp $1 $1 % 60
     IntOp $3 $2 / 60
     IntOp $2 $2 % 60
  StrCpy $Time "$ELAPSEDTIME_LANGUAGE $3 $HOURS_LANGUAGE $2 $MINUTES_LANGUAGE $1 $SECONDS_LANGUAGE $0 $MILISECONDS_LANGUAGE"
  DetailPrint "$Time"
SectionEnd

Function RefreshShellIcons
  System::Call "shell32::SHChangeNotify(i 0x08000000, i 0, i 0, i 0)"
FunctionEnd

#...:: FINISH ::... #

Function "Page.Complete"

  # Variables #

  var /GLOBAL Btn_Finish

  # Language #

  var /GLOBAL NSIS_FINISH_INSTALL_LANGUAGE
  var /GLOBAL NSIS_BUTTON_CLOSE_INSTALL_LANGUAGE

  GetDlgItem $0 $HWNDPARENT 1
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 2
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 3
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 1990
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 1991
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 1992
  ShowWindow $0 ${SW_HIDE}

  System::Call user32::SetWindowPos(i$HWNDPARENT,i0,i0,i0,i651,i451,i0x0002)
  nsDialogs::Create /NOUNLOAD 1044
  Pop $Dialog
  ${If} $Dialog == error
   Abort
  ${EndIf}
  System::Call user32::SetWindowPos(i$Dialog,i0,i0,i0,i651,i451,i0x0002)

  SetCtlColors $Dialog "0x666666" "0xFFFFFF"

  ${TBProgress_State} NoProgress

  # Close #

  nsDialogs::CreateControl /NOUNLOAD BUTTON 0x40000000|0x10000000|0x04000000|0x00010000 0 623 6 16 16 ""
  Pop $Btn_Close
  Strcpy $1 $Btn_Close
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_close.bmp $1
  GetFunctionAddress $3 ".OnClick.Finish"
  SkinBtn::onClick /NOUNLOAD $1 $3

  SetCtlColors $Btn_Close "0x666666" "0xFFFFFF"

  # Minimize #

  nsDialogs::CreateControl /NOUNLOAD BUTTON 0x40000000|0x10000000|0x04000000|0x00010000 0 600 6 16 16 ""
  Pop $Btn_Minimize
  Strcpy $1 $Btn_Minimize
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_min.bmp $1
  GetFunctionAddress $3 ".onClick.Minimize"
  SkinBtn::onClick /NOUNLOAD $1 $3

  SetCtlColors $Btn_Minimize "0x666666" "0xFFFFFF"

  # Finish #

  nsDialogs::CreateControl /NOUNLOAD BUTTON 0x40000000|0x10000000|0x04000000|0x00010000 0 242 259 165 46 "Close"
  Pop $Btn_Finish
  Strcpy $1 $Btn_Finish
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_complete.bmp $1
  GetFunctionAddress $3 ".OnClick.Finish"
  SkinBtn::onClick /NOUNLOAD $1 $3

  EnableWindow $Btn_Finish 1

  CreateFont $FONT_NAME "Microsoft Yahei" 12 400
  SendMessage $Btn_Finish ${WM_SETFONT} $FONT_NAME 0

  SetCtlColors $Btn_Finish "0x7B8DB6" "0xFFFFFF"

  # Finish #

  nsDialogs::CreateControl /NOUNLOAD STATIC 0x40000000|0x10000000|0x04000000|0x00000100 0x00000020 22 5 200 16 "Nullsoft Installer"
  Pop $Lbl_Welcome

  CreateFont $FONT_NAME "Microsoft Yahei" 8 300
  SendMessage $Lbl_Welcome ${WM_SETFONT} $FONT_NAME 0

  SetCtlColors $Lbl_Welcome "0xA5B6DA" "0xFFFFFF"

  ClearErrors
  StrCpy $SETTINGSDIR "$EXEDIR\NSIS_TempDir\Settings"
  ReadINIStr $locale_language_name "$SETTINGSDIR\Settings.ini" "Language" "Language"
  IfErrors 0 +3
  ${If} $locale_language_name != "1"

    Strcpy $LANGUAGEDIR "$EXEDIR\NSIS_TempDir\Language"

    ReadINIStr $NSIS_FINISH_INSTALL_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "NSIS_Installer" "NSIS_Finish_Install_Title"
    ReadINIStr $NSIS_BUTTON_CLOSE_INSTALL_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "NSIS_Installer" "NSIS_Button_Close"

    SendMessage $Btn_Finish ${WM_SETTEXT} 0 "STR:$NSIS_BUTTON_CLOSE_INSTALL_LANGUAGE"

    ReadINIStr $NSIS_TOOLTIPS_CLOSE_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "NSIS_Installer" "NSIS_Button_Close"
    ReadINIStr $NSIS_TOOLTIPS_MINIMIZE_LANGUAGE "$LANGUAGEDIR\$locale_language_name.ini" "NSIS_Installer" "NSIS_Button_Minimize"

    ToolTips::Classic $btn_Minimize "$NSIS_TOOLTIPS_MINIMIZE_LANGUAGE"
    ToolTips::Classic $btn_Close "$NSIS_TOOLTIPS_CLOSE_LANGUAGE"

  ${ElseIf} $locale_language_name == "0"

    Strcpy $LANGUAGEDIR "$EXEDIR\NSIS_TempDir\Language"

    ReadINIStr $NSIS_FINISH_INSTALL_LANGUAGE "$LANGUAGEDIR\English.ini" "NSIS_Installer" "NSIS_Finish_Install_Title"
    ReadINIStr $NSIS_BUTTON_CLOSE_INSTALL_LANGUAGE "$LANGUAGEDIR\English.ini" "NSIS_Installer" "NSIS_Button_Close"

    SendMessage $Btn_Finish ${WM_SETTEXT} 0 "STR:$NSIS_BUTTON_CLOSE_INSTALL_LANGUAGE"

    ReadINIStr $NSIS_TOOLTIPS_CLOSE_LANGUAGE "$LANGUAGEDIR\English.ini" "NSIS_Installer" "NSIS_Button_Close"
    ReadINIStr $NSIS_TOOLTIPS_MINIMIZE_LANGUAGE "$LANGUAGEDIR\English.ini" "NSIS_Installer" "NSIS_Button_Minimize"

    ToolTips::Classic $btn_Minimize "$NSIS_TOOLTIPS_MINIMIZE_LANGUAGE"
    ToolTips::Classic $btn_Close "$NSIS_TOOLTIPS_CLOSE_LANGUAGE"

  ${EndIf}

  # Background #

  nsDialogs::CreateControl /NOUNLOAD STATIC 0x10000000|0x40000000|0x04000000|0x0000000E 0 0 0 100% 100% ""
  Pop $BGIMAGE
  Push $0
  Push $R0
  StrCpy $R0 $BGIMAGE
  System::Call "user32::LoadImage(i 0, ts, i 0, i0, i0, i0x0010) i.r0" $PLUGINSDIR\001.bmp
  SendMessage $R0 0x0172 0 $0
  Pop $R0
  Exch $0

  # Back #

  GetFunctionAddress $0 "onGUICallback"
  WndProc::onCallback $HWNDPARENT $0
  WndProc::onCallback $BGImage $0

  nsDialogs::Show

  System::Call "user32::DestroyIcon(iR0)"
  System::Call 'user32::DestroyImage(iR0)'
  System::Call "gdi32::DeleteObject(i$R0)"
  System::Call 'user32::DestroyImage(i$R0)'
  Return
FunctionEnd

# SHORTCUT #

Function SkinBtn_Checked_ShortCut
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_checkbox_checked.bmp $Ck_ShortCut
FunctionEnd

Function SkinBtn_UnChecked_ShortCut
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_checkbox_unchecked.bmp $Ck_ShortCut
FunctionEnd

Function ".OnClick.ShortCut"
  ${IF} $Bool_ShortCut == 1
    IntOp $Bool_ShortCut $Bool_ShortCut - 1
    StrCpy $1 $Ck_ShortCut
       Call "SkinBtn_UnChecked_ShortCut"
  ${else}
    IntOp $Bool_ShortCut $Bool_ShortCut + 1
    StrCpy $1 $Ck_ShortCut
       Call "SkinBtn_Checked_ShortCut"
  ${Endif}
FunctionEnd

# AUTORUN #

Function SkinBtn_Checked_AutoRun
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_checkbox_checked.bmp $Ck_AutoRun
FunctionEnd

Function SkinBtn_UnChecked_AutoRun
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_checkbox_unchecked.bmp $Ck_AutoRun
FunctionEnd

Function ".OnClick.AutoRun"
  ${IF} $Bool_AutoRun == 1
    IntOp $Bool_AutoRun $Bool_AutoRun - 1
    StrCpy $1 $Ck_AutoRun
       Call "SkinBtn_UnChecked_AutoRun"
  ${else}
    IntOp $Bool_AutoRun $Bool_AutoRun + 1
    StrCpy $1 $Ck_AutoRun
       Call "SkinBtn_Checked_AutoRun"
  ${Endif}
FunctionEnd

# TASKBAR #

Function SkinBtn_Checked_Taskbar
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_checkbox_checked.bmp $Ck_Taskbar
FunctionEnd

Function SkinBtn_UnChecked_Taskbar
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_checkbox_unchecked.bmp $Ck_Taskbar
FunctionEnd

Function ".OnClick.Taskbar"
  ${IF} $Bool_Taskbar == 1
    IntOp $Bool_Taskbar $Bool_Taskbar - 1
    StrCpy $1 $Ck_Taskbar
       Call "SkinBtn_UnChecked_Taskbar"
  ${else}
    IntOp $Bool_Taskbar $Bool_Taskbar + 1
    StrCpy $1 $Ck_Taskbar
       Call "SkinBtn_Checked_Taskbar"
  ${Endif}
FunctionEnd

# WEBSITE #

Function SkinBtn_Checked_Website
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_checkbox_checked.bmp $Ck_Website
FunctionEnd

Function SkinBtn_UnChecked_Website
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_checkbox_unchecked.bmp $Ck_Website
FunctionEnd

Function ".OnClick.Website"
  ${IF} $Bool_Website == 1
    IntOp $Bool_Website $Bool_Website - 1
    StrCpy $1 $Ck_Website
       Call "SkinBtn_UnChecked_Website"
  ${else}
    IntOp $Bool_Website $Bool_Website + 1
    StrCpy $1 $Ck_Website
       Call "SkinBtn_Checked_Website"
  ${Endif}
FunctionEnd

# ...:: Leave ::... #

Function "Page.Complete.Leave"
  ${If} $PortableMode = 0
    ${If} $Bool_ShortCut == 1
      SetShellVarContext all
      CreateShortCut "$DESKTOP\NSIS.lnk" "$INSTDIR\NSIS.exe"
    ${EndIf}

    ${If} $Bool_AutoRun == 1
      ExecShell "open" '$INSTDIR\NSIS.exe'
    ${EndIf}

    ${If} $Bool_Taskbar == 1
      SetShellVarContext ALL
      CreateShortCut "$APPDATA\Microsoft\Internet Explorer\Quick Launch\NSIS.lnk" "$INSTDIR\NSIS.exe"
      CreateShortCut "$DESKTOP\NSIS.lnk" "$INSTDIR\NSIS.exe"
      ExecShell taskbarpin "$DESKTOP\NSIS.lnk"
    ${EndIf}

    ${If} $Bool_Website == 1
      ExecShell open "http://nsis.sf.net/"
    ${EndIf}

  ${Else}

    ${If} $Bool_AutoRun == 1
      ExecShell "open" '$INSTDIR\NSIS Portable.exe'
    ${EndIf}

    ${If} $Bool_Website == 1
      ExecShell open "http://nsis.sf.net/"
    ${EndIf}

  ${EndIf}
FunctionEnd

# ...:: MINIMIZE ::... #

Function ".onClick.Minimize"
  ShowWindow $HWNDPARENT ${SW_MINIMIZE}
FunctionEnd

# ...:: Finish ::... #

Function ".OnClick.Finish"
  SendMessage $HWNDPARENT 0x408 1 0
FunctionEnd

# Call Back #

Function "onGUICallback"
  ${If} $0 = ${WM_LBUTTONDOWN}
    SendMessage $HWNDPARENT ${WM_NCLBUTTONDOWN} ${HTCAPTION} $0
  ${EndIf}
FunctionEnd

Function .OnGuiEnd
  SetShellVarContext "all"
  Delete /REBOOTOK "$EXEDIR\NSIS_TempDir\Language\English.ini"
  Delete /REBOOTOK "$EXEDIR\NSIS_TempDir\Language\Romanian.ini"
  RMDir /r "$EXEDIR\NSIS_TempDir\Language"
  Delete /REBOOTOK "$EXEDIR\NSIS_TempDir\Settings\Settings.ini"
  RMDir /r "$EXEDIR\NSIS_TempDir\Settings"
  Delete /REBOOTOK "$EXEDIR\NSIS_TempDir\License\js\jsScroll.js"
  RMDir /r "$EXEDIR\NSIS_TempDir\License\js"
  Delete /REBOOTOK "$EXEDIR\NSIS_TempDir\License\License.htm"
  RMDir /r "$EXEDIR\NSIS_TempDir\License"
  RMDir /r "$EXEDIR\NSIS_TempDir"
  SetOutPath $EXEDIR
FunctionEnd

# UNINSTALL

# UI #

!define UN_CUSTOMUI
!ifndef UN_CUSTOMUI
  !define UN_MUI_UI "UI\UI.exe"
  ChangeUI all "UI\UI.exe"
!else
  !define UN_MUI_UI "UI\UI.exe"
  ChangeUI all "UI\UI.exe"
!endif

Function 'un.onInit'
  # Language

  System::Call 'KERNEL32::GetUserDefaultLangID()i.r0'
  System::Call 'kernel32::GetSystemDefaultLCID()i.R0'
  System::Call `kernel32::GetUserDefaultUILanguage() i.s`
  System::Call 'KERNEL32::GetUserDefaultLangID()i.r0'
  Pop $R0
  strcpy $LANGUAGE '$R0'
  System::Call 'KERNEL32::GetLocaleInfo(i$0,i${LOCALE_SCOUNTRY},t.r1,i1000)'
  System::Call 'KERNEL32::GetLocaleInfo(i$0,i${LOCALE_SENGCOUNTRY},t.r1,i1000)' 
  System::Call 'KERNEL32::GetLocaleInfo(i$0,i${LOCALE_SENGLANGUAGE},t.r2,i1000)'
  StrCpy $Lang $2
  StrCmp $LANGUAGE "" 0 Un.End
  StrCmp $Language "1048" 0 +2
  StrCpy $Lang "Romanian"
  StrCmp $Language "1033" 0 +2
  StrCpy $Lang "English"
  Un.End:

  SetShellVarContext all
  IfSilent 0 +3 
   MessageBox MB_ICONQUESTION|MB_YESNO|MB_TOPMOST "$(NSIS.Msg.Uninstall)" IDYES next IDNO +2 
  Abort 
  HideWindow
  next:
  !insertmacro RequireAdmin

  ClearErrors
  CreateDirectory "$TEMP\Uninst_NSIS"
  IfErrors 0 +3
  ClearErrors
  InitPluginsDir
  StrCpy $0 "$TEMP\Uninst_NSIS"
  SetOutPath $0
  File /r /x thumbs.db "${NSISDIR}\Plugins\chngvrbl.dll"
  Push $0
  Push 26
  CallInstDLL $0\chngvrbl.dll changeVariable

  InitPluginsDir
  SetOverwrite on
  AllowSkipFiles on
  File "/oname=$PLUGINSDIR\001.bmp" "Skin\001.bmp"
  File "/oname=$PLUGINSDIR\002.bmp" "Skin\002.bmp"
  File "/oname=$PLUGINSDIR\003.bmp" "Skin\003.bmp"
  File "/oname=$PLUGINSDIR\004.bmp" "Skin\004.bmp"
  File "/oname=$PLUGINSDIR\btn_step_browser.bmp" "Skin\btn_step_browser.bmp"
  File "/oname=$PLUGINSDIR\btn_step_checkbox_checked.bmp" "Skin\btn_step_checkbox_checked.bmp"
  File "/oname=$PLUGINSDIR\btn_step_checkbox_unchecked.bmp" "Skin\btn_step_checkbox_unchecked.bmp"
  File "/oname=$PLUGINSDIR\btn_step_close.bmp" "Skin\btn_step_close.bmp"
  File "/oname=$PLUGINSDIR\btn_step_complete.bmp" "Skin\btn_step_complete.bmp"
  File "/oname=$PLUGINSDIR\btn_step_custom_install_down.bmp" "Skin\btn_step_custom_install_down.bmp"
  File "/oname=$PLUGINSDIR\btn_step_custom_install_up.bmp" "Skin\btn_step_custom_install_up.bmp"
  File "/oname=$PLUGINSDIR\btn_step_install.bmp" "Skin\btn_step_install.bmp"
  File "/oname=$PLUGINSDIR\btn_step_min.bmp" "Skin\btn_step_min.bmp"
  File "/oname=$PLUGINSDIR\btn_step_next.bmp" "Skin\btn_step_next.bmp"
  File "/oname=$PLUGINSDIR\progressbar_background.bmp" "Skin\progressbar_background.bmp"
  File "/oname=$PLUGINSDIR\progressbar_foreground.bmp" "Skin\progressbar_foreground.bmp"

  SkinBtn::Init "$PLUGINSDIR\btn_step_browser.bmp"
  SkinBtn::Init "$PLUGINSDIR\btn_step_checkbox_checked.bmp"
  SkinBtn::Init "$PLUGINSDIR\btn_step_checkbox_unchecked.bmp"
  SkinBtn::Init "$PLUGINSDIR\btn_step_close.bmp"
  SkinBtn::Init "$PLUGINSDIR\btn_step_complete.bmp"
  SkinBtn::Init "$PLUGINSDIR\btn_step_custom_install_down.bmp"
  SkinBtn::Init "$PLUGINSDIR\btn_step_custom_install_up.bmp"
  SkinBtn::Init "$PLUGINSDIR\btn_step_install.bmp"
  SkinBtn::Init "$PLUGINSDIR\btn_step_min.bmp"
  SkinBtn::Init "$PLUGINSDIR\btn_step_next.bmp"
  SkinBtn::Init "$PLUGINSDIR\btn_step_return.bmp"
FunctionEnd

Function un.GUIInit
  MoveAnywhere::Hook

  System::Call user32::SetWindowLong(i$HWNDPARENT,i-16,0x9480084C)i.R0
  GetDlgItem $0 $HWNDPARENT 1034
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 1035
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 1036
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 1037
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 1038
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 1039
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 1256
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 1028
  ShowWindow $0 ${SW_HIDE}

  System::Call user32::GetSystemMetrics(i0)i.r1
  System::Call user32::GetSystemMetrics(i1)i.r2
  IntOp $1 $1 - 651
  IntOp $1 $1 / 2
  IntOp $2 $2 - 451
  IntOp $2 $2 / 2
  System::Call user32::MoveWindow(i$HWNDPARENT,i$1,i$2,i651,i451,1)

  System::Alloc 16
  System::Call user32::GetWindowRect(i$HWNDPARENT,isR0)
  System::Call *$R0(i.R1,i.R2,i.R3,i.R4)
  IntOp $R3 $R3 - $R1
  IntOp $R4 $R4 - $R2
  System::Call gdi32::CreateRoundRectRgn(i0,i0,iR3,iR4,i5,i5)i.r0
  System::Call user32::SetWindowRgn(i$HWNDPARENT,ir0,i1)
  System::Free $R0
  System::Call User32::GetDesktopWindow()i.R0

  SetCtlColors $HWNDPARENT "0x313131" "0xFFFFFF"
FunctionEnd

Function un.ModifyUnConfirm

  var /GLOBAL Un_Dialog
  var /GLOBAL Un_BGImage
  var /GLOBAL Un_ImageHandle
  var /GLOBAL Un_Btn_Minimize
  var /GLOBAL Un_Btn_Close
  var /GLOBAL UN_FONT_NAME
  var /GLOBAL Un_Lbl_Welcome
  var /GLOBAL Un_Btn_Uninstall

  var /GLOBAL Un_Lnk_Feedback
  var /GLOBAL Un_Bool_Feedback

  var /GLOBAL Un_Btn_Custom_Uninstall
  var /GLOBAL Un_Bool_Custom_Uninstall

  var /GLOBAL Un_Generate

  var /GLOBAL Un_Lbl_Save
  var /GLOBAL Un_Btn_Save

  var /GLOBAL Un_Lbl_Generate
  var /GLOBAL Un_Btn_Generate

  var /GLOBAL UN_MYDESTDIR

  var /GLOBAL Un_Lbl_Message
  var /GLOBAL Un_Feedback
  var /GLOBAL Un_PATH_MESSAGE
  var /GLOBAL Un_PATH_EMAIL
  var /GLOBAL Un_Btn_Send

  GetDlgItem $0 $HWNDPARENT 1
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 2
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 3
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 1990
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 1991
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 1992
  ShowWindow $0 ${SW_HIDE}

  System::Call user32::SetWindowPos(i$HWNDPARENT,i0,i0,i0,i651,i451,i0x0002)
  nsDialogs::Create /NOUNLOAD 1044
  Pop $Un_Dialog
  ${If} $Un_Dialog == error
   Abort
  ${EndIf}
  System::Call user32::SetWindowPos(i$Un_Dialog,i0,i0,i0,i651,i580,i0x0002)

  SetCtlColors $Un_Dialog "0x666666" "0xFFFFFF"

  Strcpy $UN_MYDESTDIR "$DESKTOP\NSIS Portable"

  # ...:: Minimize ::... #

  nsDialogs::CreateControl /NOUNLOAD BUTTON 0x40000000|0x10000000|0x04000000|0x00010000 0 600 6 16 16 ""
  Pop $Un_Btn_Minimize
  StrCpy $1 $Un_Btn_Minimize
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_min.bmp $1
  GetFunctionAddress $3 "Un.onClick.Minimize"
  SkinBtn::onClick /NOUNLOAD $1 $3

  ToolTips::Classic $Un_Btn_Minimize "$(NSIS.Btn.Minimize)"

  SetCtlColors $Un_Btn_Minimize "0x313131" "0xFFFFFF"

  # ...:: Close ::... #

  nsDialogs::CreateControl /NOUNLOAD BUTTON 0x40000000|0x10000000|0x04000000|0x00010000 0 623 6 16 16 ""
  Pop $Un_Btn_Close
  StrCpy $1 $Un_Btn_Close
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_close.bmp $1
  GetFunctionAddress $3 "Un.onClick.Close"
  SkinBtn::onClick /NOUNLOAD $1 $3

  SendMessage $HWNDPARENT ${DM_SETDEFID} $Un_Btn_Close 0
  SendMessage $HWNDPARENT ${WM_NEXTDLGCTL} $Un_Btn_Close 1

  ToolTips::Classic $Un_Btn_Close "$(NSIS.Btn.Close)"

  SetCtlColors $Un_Btn_Close "0x313131" "0xFFFFFF"

  # Feedback #

  nsDialogs::CreateControl /NOUNLOAD LINK 0x40000000|0x10000000|0x04000000|0x00010000|0x0000000B 0 17 409 115 16 "$(NSIS.Feedback)"
  Pop $Un_Lnk_Feedback
  Strcpy $1 $Un_Lnk_Feedback
  GetFunctionAddress $3 "Un.onClick.Feedback"
  nsDialogs::onClick /NOUNLOAD $1 $3
  Strcpy $Un_Bool_Feedback 0

  CreateFont $UN_FONT_NAME "Microsoft Yahei" 9 400
  SendMessage $Un_Lnk_Feedback ${WM_SETFONT} $UN_FONT_NAME 0

  SetCtlColors $Un_Lnk_Feedback "0xA5B6DA" "0xFFFFFF"

  # Custom #

  nsDialogs::CreateControl /NOUNLOAD BUTTON 0x40000000|0x10000000|0x04000000|0x00010000 0 540 409 100 16 "$(NSIS.Custom.Install)"
  Pop $Un_Btn_Custom_Uninstall
  Strcpy $1 $Un_Btn_Custom_Uninstall
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_custom_install_down.bmp $1
  GetFunctionAddress $3 "Un.onClick.Custom.Uninstall"
  SkinBtn::onClick /NOUNLOAD $1 $3
  Strcpy $Un_Bool_Custom_Uninstall 0

  CreateFont $UN_FONT_NAME "Microsoft Yahei" 9 400
  SendMessage $Un_Btn_Custom_Uninstall ${WM_SETFONT} $UN_FONT_NAME 0

  SetCtlColors $Un_Btn_Custom_Uninstall "0x7B8DB6" "0xFFFFFF"

  # Generate

  nsDialogs::CreateControl /NOUNLOAD STATIC 0x40000000|0x10000000|0x04000000|0x00000100 0x00000020 235 350 250 15 "$(NSIS.Generate)"
  Pop $Un_Generate

  SetCtlColors $Un_Generate "0x7B8DB6" "0xFFFFFF"

  CreateFont $UN_FONT_NAME "Microsoft Yahei" 10 400
  SendMessage $Un_Generate ${WM_SETFONT} $UN_FONT_NAME 0

  ShowWindow $Un_Generate ${SW_HIDE}

  # Save #

  nsDialogs::CreateControl /NOUNLOAD STATIC 0x40000000|0x10000000|0x04000000|0x00000100 0x00000020 210 385 70 15 "$(NSIS.Save)"
  Pop $Un_Lbl_Save

  CreateFont $UN_FONT_NAME "Microsoft Yahei" 10 400
  SendMessage $Un_Lbl_Save ${WM_SETFONT} $UN_FONT_NAME 0

  SetCtlColors $Un_Lbl_Save "0x7B8DB6" "0xFFFFFF"

  ShowWindow $Un_Lbl_Save ${SW_HIDE}

  # Save #

  nsDialogs::CreateControl /NOUNLOAD BUTTON 0x40000000|0x10000000|0x04000000|0x00010000 0 150 425 165 46 "$(NSIS.Btn.Save)"
  Pop $Un_Btn_Save
  StrCpy $1 $Un_Btn_Save
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_install.bmp $1
  GetFunctionAddress $3 "Un.onClick.Save"
  SkinBtn::onClick /NOUNLOAD $1 $3

  CreateFont $UN_FONT_NAME "Microsoft Yahei" 10 400
  SendMessage $Un_Btn_Save ${WM_SETFONT} $UN_FONT_NAME 0

  SetCtlColors $Un_Btn_Save "0x7B8DB6" "0xFFFFFF"

  ShowWindow $Un_Btn_Save ${SW_HIDE}

  # Generate #

  nsDialogs::CreateControl /NOUNLOAD STATIC 0x40000000|0x10000000|0x04000000|0x00000100 0x00000020 350 385 70 15 "$(NSIS.Generate)"
  Pop $Un_Lbl_Generate

  CreateFont $UN_FONT_NAME "Microsoft Yahei" 10 400
  SendMessage $Un_Lbl_Generate ${WM_SETFONT} $UN_FONT_NAME 0

  SetCtlColors $Un_Lbl_Generate "0x7B8DB6" "0xFFFFFF"

  ShowWindow $Un_Lbl_Generate ${SW_HIDE}

  # Generate #

  nsDialogs::CreateControl /NOUNLOAD BUTTON 0x40000000|0x10000000|0x04000000|0x00010000 0 320 425 165 46 "$(NSIS.Btn.Generate)"
  Pop $Un_Btn_Generate
  StrCpy $1 $Un_Btn_Generate
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_install.bmp $1
  GetFunctionAddress $3 "Un.onClick.Generate"
  SkinBtn::onClick /NOUNLOAD $1 $3

  CreateFont $UN_FONT_NAME "Microsoft Yahei" 10 400
  SendMessage $Un_Btn_Generate ${WM_SETFONT} $UN_FONT_NAME 0

  SetCtlColors $Un_Btn_Generate "0x7B8DB6" "0xFFFFFF"

  ShowWindow $Un_Btn_Generate ${SW_HIDE}

  # Feedback

  nsDialogs::CreateControl /NOUNLOAD STATIC 0x40000000|0x10000000|0x04000000|0x00000100 0x00000020 260 320 150 15 "$(NSIS.Feedback)"
  Pop $Un_Feedback

  SetCtlColors $Un_Feedback "0x7B8DB6" "0xFFFFFF"

  CreateFont $UN_FONT_NAME "Microsoft Yahei" 10 400
  SendMessage $Un_Feedback ${WM_SETFONT} $UN_FONT_NAME 0

  ShowWindow $Un_Feedback ${SW_HIDE}

  # ...:: Email ::... #

  nsDialogs::CreateControl /NOUNLOAD STATIC 0x40000000|0x10000000|0x04000000|0x00000100 0x00000020 180 355 255 15 "$(NSIS.Sorry.Leave)"
  pop $Un_Lbl_Message

  SetCtlColors $Un_Lbl_Message "0x7B8DB6" "0xFFFFFF"

  ShowWindow $Un_Lbl_Message ${SW_HIDE}

  nsDialogs::CreateControl /NOUNLOAD EDIT 0x40000000|0x10000000|0x04000000|0x00200000|0x00010000|0x00001000|0x00000080|0x00000004 0x00000100|0x00000200 90 390 460 70 "$(NSIS.Enter.Message)"
  Pop $Un_PATH_MESSAGE

  CreateFont $0 "MV Boli" "10" "100"
  SendMessage $Un_PATH_MESSAGE ${WM_SETFONT} $0 0 

  SetCtlColors $Un_PATH_MESSAGE 0x666666 0xFFFFFF

  ShowWindow $Un_PATH_MESSAGE ${SW_HIDE}

  # ...:: Email ::... #

  nsDialogs::CreateControl /NOUNLOAD EDIT 0x40000000|0x10000000|0x04000000|0x00010000|0x00000080 0x00000100|0x00000200 90 470 460 20 "$(NSIS.Enter.Email)"
  Pop $Un_PATH_EMAIL

  CreateFont $0 "MV Boli" "10" "100"
  SendMessage $Un_PATH_EMAIL ${WM_SETFONT} $0 0 

  SetCtlColors $Un_PATH_EMAIL 0x666666 0xFFFFFF

  ShowWindow $Un_PATH_EMAIL ${SW_HIDE}

  # btn send email

  nsDialogs::CreateControl /NOUNLOAD BUTTON 0x40000000|0x10000000|0x04000000|0x00010000 0 270 510 100 40 "$(NSIS.Btn.Send)"
  Pop $Un_Btn_Send
  Strcpy $1 $Un_Btn_Send
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_browser.bmp $1
  GetFunctionAddress $3 "un.onClick.Send.Feedback"
  SkinBtn::onClick /NOUNLOAD $1 $3

  CreateFont $UN_FONT_NAME "Microsoft Yahei" 10 400
  SendMessage $Un_Btn_Send ${WM_SETFONT} $UN_FONT_NAME 0

  SetCtlColors $Un_Btn_Send "0x7B8DB6" "0xFFFFFF"

  ShowWindow $Un_Btn_Send ${SW_HIDE}

  # Uninstall #

  nsDialogs::CreateControl /NOUNLOAD STATIC 0x40000000|0x10000000|0x04000000|0x00000100 0x00000020 22 5 200 16 "Nullsoft Installer"
  Pop $Un_Lbl_Welcome

  CreateFont $UN_FONT_NAME "Microsoft Yahei" 8 300
  SendMessage $Un_Lbl_Welcome ${WM_SETFONT} $UN_FONT_NAME 0

  SetCtlColors $Un_Lbl_Welcome "0xA5B6DA" "0xFFFFFF"

  # Uninstall #

  nsDialogs::CreateControl /NOUNLOAD BUTTON 0x40000000|0x10000000|0x04000000|0x00010000 0 242 259 165 46 "$(NSIS.Btn.Uninstall)"
  Pop $Un_Btn_Uninstall
  StrCpy $1 $Un_Btn_Uninstall
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_install.bmp $1
  GetFunctionAddress $3 "Un.onClick.Express.Uninstall"
  SkinBtn::onClick /NOUNLOAD $1 $3

  CreateFont $UN_FONT_NAME "Microsoft Yahei" 12 400
  SendMessage $Un_Btn_Uninstall ${WM_SETFONT} $UN_FONT_NAME 0

  SetCtlColors $Un_Btn_Uninstall "0x7B8DB6" "0xFFFFFF"

  # BACKGROUND #

  nsDialogs::CreateControl /NOUNLOAD STATIC 0x10000000|0x40000000|0x04000000|0x0000000E 0 0 0 100% 100% ""
  Pop $Un_BGImage
  Push $0
  Push $R0
  StrCpy $R0 $Un_BGImage
  System::Call "user32::LoadImage(i 0, ts, i 0, i0, i0, i0x0010) i.r0" $PLUGINSDIR\001.bmp
  SendMessage $R0 0x0172 0 $0
  Pop $R0
  Exch $0

  # Back

  GetFunctionAddress $0 "Un.onGUICallback"
  WndProc::onCallback $HWNDPARENT $0
  WndProc::onCallback $Un_BGImage $0

  nsDialogs::Show

  System::Call "user32::DestroyIcon(iR0)"
  System::Call 'user32::DestroyImage(iR0)'
  Return
FunctionEnd

# Feedback #

Function "Un.onClick.Feedback"
  ${If} $Un_Bool_Feedback == 1
    IntOp $Un_Bool_Feedback $Un_Bool_Feedback - 1
    Strcpy $1 $Un_Lnk_Feedback

    EnableWindow $Un_Btn_Custom_Uninstall 1
    Call "Un.onClick.Hide.Feedback"

  ${Else} 
    IntOp $Un_Bool_Feedback $Un_Bool_Feedback + 1
    Strcpy $1 $Un_Lnk_Feedback

    EnableWindow $Un_Btn_Custom_Uninstall 0
    Call "Un.onClick.Show.Feedback"

  ${EndIf}
FunctionEnd

Function "Un.onClick.Show.Feedback"
  System::Call user32::SetWindowPos(i$HWNDPARENT,i0,i0,i0,i651,i585,i0x0002)
  System::Call user32::SetWindowPos(i$Un_Dialog,i0,i0,i0,i651,i585,i0x0002)

  System::Alloc 16
  System::Call user32::GetWindowRect(i$HWNDPARENT,isR0)
  System::Call *$R0(i.R1,i.R2,i.R3,i.R4)
  IntOp $R3 $R3 - $R1
  IntOp $R4 $R4 - $R2
  System::Call gdi32::CreateRoundRectRgn(i0,i0,iR3,iR4,i5,i5)i.r0
  System::Call user32::SetWindowRgn(i$HWNDPARENT,ir0,i1)
  System::Free $R0

  System::Call user32::SetWindowPos(i$Un_Lnk_Feedback,i0,i17,i550,i115,i16,i0x0001)

  System::Call user32::SetWindowPos(i$Un_Btn_Custom_Uninstall,i0,i540,i550,i100,i16,i0x0001)

  ShowWindow $Un_Lbl_Welcome ${SW_HIDE}
  SendMessage $Un_Lbl_Welcome ${WM_SETTEXT} 0 "STR:Nullsoft Installer"
  ShowWindow $Un_Lbl_Welcome ${SW_SHOW}

  ShowWindow $Un_Generate ${SW_HIDE}

  ShowWindow $Un_Lbl_Save ${SW_HIDE}
  ShowWindow $Un_Btn_Save ${SW_HIDE}

  ShowWindow $Un_Lbl_Generate ${SW_HIDE}
  ShowWindow $Un_Btn_Generate ${SW_HIDE}

  # Feedback #

  ShowWindow $Un_Feedback ${SW_SHOW}

  ShowWindow $Un_Lbl_Message ${SW_SHOW}

  ShowWindow $Un_PATH_MESSAGE ${SW_SHOW}

  ShowWindow $Un_PATH_EMAIL ${SW_SHOW}

  ShowWindow $Un_Btn_Send ${SW_SHOW}

  ${NSD_SetImage} $Un_BGImage "$PLUGINSDIR\003.bmp" $Un_ImageHandle
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_custom_install_up.bmp $Un_Btn_Custom_Uninstall
FunctionEnd

Function "Un.onClick.Hide.Feedback"
  System::Call user32::SetWindowPos(i$HWNDPARENT,i0,i0,i0,i651,i451,i0x0002)
  System::Call user32::SetWindowPos(i$Un_Dialog,i0,i0,i0,i651,i451,i0x0002)

  System::Alloc 16
  System::Call user32::GetWindowRect(i$HWNDPARENT,isR0)
  System::Call *$R0(i.R1,i.R2,i.R3,i.R4)
  IntOp $R3 $R3 - $R1
  IntOp $R4 $R4 - $R2
  System::Call gdi32::CreateRoundRectRgn(i0,i0,iR3,iR4,i5,i5)i.r0
  System::Call user32::SetWindowRgn(i$HWNDPARENT,ir0,i1)
  System::Free $R0

  # Portable #

  ShowWindow $Un_Generate ${SW_HIDE}

  ShowWindow $Un_Lbl_Save ${SW_HIDE}
  ShowWindow $Un_Btn_Save ${SW_HIDE}

  ShowWindow $Un_Lbl_Generate ${SW_HIDE}
  ShowWindow $Un_Btn_Generate ${SW_HIDE}

  ShowWindow $Un_Lbl_Welcome ${SW_HIDE}
  SendMessage $Un_Lbl_Welcome ${WM_SETTEXT} 0 "STR:Nullsoft Installer"
  ShowWindow $Un_Lbl_Welcome ${SW_SHOW}

  # Feedback #

  ShowWindow $Un_Feedback ${SW_HIDE}

  ShowWindow $Un_Lbl_Message ${SW_HIDE}

  ShowWindow $Un_PATH_MESSAGE ${SW_HIDE}

  ShowWindow $Un_PATH_EMAIL ${SW_HIDE}

  ShowWindow $Un_Btn_Send ${SW_HIDE}

  System::Call user32::SetWindowPos(i$Un_Lnk_Feedback,i0,i17,i409,i115,i16,i0x0001)

  System::Call user32::SetWindowPos(i$Un_Btn_Custom_Uninstall,i0,i540,i409,i100,i16,i0x0001)

  ${NSD_SetImage} $Un_BGImage "$PLUGINSDIR\001.bmp" $Un_ImageHandle
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_custom_install_down.bmp $Un_Btn_Custom_Uninstall
FunctionEnd

# Custom #

Function "Un.onClick.Custom.Uninstall"
  ${If} $Un_Bool_Custom_Uninstall == 1
    IntOp $Un_Bool_Custom_Uninstall $Un_Bool_Custom_Uninstall - 1
    Strcpy $1 $Un_Btn_Custom_Uninstall

    EnableWindow $Un_Lnk_Feedback 1
    Call "Un.onClick.Hide"

  ${Else} 
    IntOp $Un_Bool_Custom_Uninstall $Un_Bool_Custom_Uninstall + 1
    Strcpy $1 $Un_Btn_Custom_Uninstall

    EnableWindow $Un_Lnk_Feedback 0
    Call "Un.onClick.Show"

  ${EndIf}
FunctionEnd

Function "Un.onClick.Show"
  System::Call user32::SetWindowPos(i$HWNDPARENT,i0,i0,i0,i651,i585,i0x0002)
  System::Call user32::SetWindowPos(i$Un_Dialog,i0,i0,i0,i651,i585,i0x0002)

  System::Alloc 16
  System::Call user32::GetWindowRect(i$HWNDPARENT,isR0)
  System::Call *$R0(i.R1,i.R2,i.R3,i.R4)
  IntOp $R3 $R3 - $R1
  IntOp $R4 $R4 - $R2
  System::Call gdi32::CreateRoundRectRgn(i0,i0,iR3,iR4,i5,i5)i.r0
  System::Call user32::SetWindowRgn(i$HWNDPARENT,ir0,i1)
  System::Free $R0

  # Feedback #

  ShowWindow $Un_Feedback ${SW_HIDE}

  ShowWindow $Un_Lbl_Message ${SW_HIDE}

  ShowWindow $Un_PATH_MESSAGE ${SW_HIDE}

  ShowWindow $Un_PATH_EMAIL ${SW_HIDE}

  ShowWindow $Un_Btn_Send ${SW_HIDE}

  # Portable #

  System::Call user32::SetWindowPos(i$Un_Lnk_Feedback,i0,i17,i550,i115,i16,i0x0001)

  System::Call user32::SetWindowPos(i$Un_Btn_Custom_Uninstall,i0,i540,i550,i100,i16,i0x0001)

  ShowWindow $Un_Lbl_Welcome ${SW_HIDE}
  SendMessage $Un_Lbl_Welcome ${WM_SETTEXT} 0 "STR:Nullsoft Installer"
  ShowWindow $Un_Lbl_Welcome ${SW_SHOW}

  ShowWindow $Un_Generate ${SW_SHOW}

  ShowWindow $Un_Lbl_Save ${SW_SHOW}
  ShowWindow $Un_Btn_Save ${SW_SHOW}

  ShowWindow $Un_Lbl_Generate ${SW_SHOW}
  ShowWindow $Un_Btn_Generate ${SW_SHOW}

  ${NSD_SetImage} $Un_BGImage "$PLUGINSDIR\003.bmp" $Un_ImageHandle
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_custom_install_up.bmp $Un_Btn_Custom_Uninstall
FunctionEnd

Function "Un.onClick.Hide"
  System::Call user32::SetWindowPos(i$HWNDPARENT,i0,i0,i0,i651,i451,i0x0002)
  System::Call user32::SetWindowPos(i$Un_Dialog,i0,i0,i0,i651,i451,i0x0002)

  System::Alloc 16
  System::Call user32::GetWindowRect(i$HWNDPARENT,isR0)
  System::Call *$R0(i.R1,i.R2,i.R3,i.R4)
  IntOp $R3 $R3 - $R1
  IntOp $R4 $R4 - $R2
  System::Call gdi32::CreateRoundRectRgn(i0,i0,iR3,iR4,i5,i5)i.r0
  System::Call user32::SetWindowRgn(i$HWNDPARENT,ir0,i1)
  System::Free $R0

  # Portable #

  ShowWindow $Un_Generate ${SW_HIDE}

  ShowWindow $Un_Lbl_Save ${SW_HIDE}
  ShowWindow $Un_Btn_Save ${SW_HIDE}

  ShowWindow $Un_Lbl_Generate ${SW_HIDE}
  ShowWindow $Un_Btn_Generate ${SW_HIDE}

  ShowWindow $Un_Lbl_Welcome ${SW_HIDE}
  SendMessage $Un_Lbl_Welcome ${WM_SETTEXT} 0 "STR:Nullsoft Installer"
  ShowWindow $Un_Lbl_Welcome ${SW_SHOW}

  # Feedback #

  ShowWindow $Un_Feedback ${SW_HIDE}

  ShowWindow $Un_Lbl_Message ${SW_HIDE}

  ShowWindow $Un_PATH_MESSAGE ${SW_HIDE}

  ShowWindow $Un_PATH_EMAIL ${SW_HIDE}

  ShowWindow $Un_Btn_Send ${SW_HIDE}

  System::Call user32::SetWindowPos(i$Un_Lnk_Feedback,i0,i17,i409,i115,i16,i0x0001)

  System::Call user32::SetWindowPos(i$Un_Btn_Custom_Uninstall,i0,i540,i409,i100,i16,i0x0001)

  ${NSD_SetImage} $Un_BGImage "$PLUGINSDIR\001.bmp" $Un_ImageHandle
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_custom_install_down.bmp $Un_Btn_Custom_Uninstall
FunctionEnd

# Save #

Function "Un.onClick.Save"
  nsDialogs::SelectFolderDialog "$(NSIS.Save.Location)" "c:\"
  pop $0
  StrCmp $0 "error" +3
  StrCpy $UN_MYDESTDIR "$0"
  ${If} $UN_MYDESTDIR != ""

  ${EndIf}
FunctionEnd

# Generate#

!define UN_NSIS_SOURCE_FILE '!insertmacro UN_NSIS_SOURCE_FILE'
!macro UN_NSIS_SOURCE_FILE UN_VAR UN_FILE
    Push "${UN_FILE}"
     ${GetParent} "${UN_FILE}" $0
    Pop ${UN_VAR}
!macroend

!define UnCopyFolders "!insertmacro _UnCopyFolders"
!macro _UnCopyFolders _UNSOURCEFOLDER_ _UNDESTFOLDER_
!verbose push
!verbose 3
   Push "${_UNSOURCEFOLDER_}"
   Push "${_UNDESTFOLDER_}"
   DetailPrint "$(NSIS.Copy.From) ${_UNSOURCEFOLDER_}"
   DetailPrint "$(NSIS.Copy.To) ${_UNDESTFOLDER_}"
   CreateDirectory "${_UNDESTFOLDER_}"
     CopyFiles /SILENT `${_UNSOURCEFOLDER_}\*.*` `${_UNDESTFOLDER_}` 
   DetailPrint "$1"
!verbose pop
!macroend

Function "Un.onClick.Generate"
  var /GLOBAL RUNDIR
  ClearErrors
  ReadRegStr $RUNDIR HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NSIS" "InstallLocation"
  IfErrors 0 +3
  ${If} $RUNDIR != "1"

    Banner::show /NOUNLOAD /set 76 "$(NSIS.Please.Wait)" "$(NSIS.Please.Wait.Generate)" 
    Banner::getWindow /NOUNLOAD 

    ClearErrors
    SetShellVarContext "all"
    CreateDirectory "$UN_MYDESTDIR\NSIS Portable\App\NSIS"
    Setoutpath "$UN_MYDESTDIR\NSIS Portable"
    File "Portable\NSIS Portable.exe"
    File "Portable\Makensisw Portable.exe"

    ${UnCopyFolders} "$RUNDIR" "$UN_MYDESTDIR\NSIS Portable\App\NSIS"

    IfFileExists "$UN_MYDESTDIR\NSIS Portable\App\NSIS\*" "NSIS.Done.Copying" "NSIS.Failed.Copying"

    NSIS.Failed.Copying:
      Banner::destroy
       Messagebox MB_OK|MB_USERICON '$(NSIS.Failed.Generate)'
    Abort

    NSIS.Done.Copying:
     Banner::destroy
     Delete /REBOOTOK "$UN_MYDESTDIR\NSIS Portable\App\NSIS\uninst-nsis.exe"
     RMDir /r "$UN_MYDESTDIR\NSIS Portable\App\NSIS\Uninst_NSIS"

    FileOpen $0 "$UN_MYDESTDIR\NSIS Portable\App\NSIS\portable.dat" w
    FileWrite $0 "# PORTABLE #"
    FileWriteByte $0 "13"
    FileWriteByte $0 "10"
    FileWrite $0 "Install Mode: Portable Version"
    FileWriteByte $0 "13"
    FileWriteByte $0 "10"
    FileClose $0

     ${GetSize} "$UN_MYDESTDIR\NSIS Portable" "/M=*.* /S=0K" $0 $1 $2
     IfErrors 0 +2
     StrCpy $0 $0 * 1024
     IntCmp $0 100 +3 0 +3
      IntCmp $0 0 +2 +2 0
      IntOp $0 103 + 0
     IntOp $0 $0 * 10
     IntOp $0 $0 / 1024
     StrCpy $1 "$0" "" -1
     IntCmp $0 9 +3 +3 0
      StrCpy $0 "$0" -1 ""
      Goto +2
      StrCpy $0 "0"

      Messagebox MB_OK|MB_USERICON '$(NSIS.Succefully.Generate) ($0.$1 MiB)'

      ExecShell open "$UN_MYDESTDIR\NSIS Portable"
    Abort
  ${EndIf}
FunctionEnd

# Feedback #

var /GLOBAL Un_YOUR_Message
var /GLOBAL Un_YOUR_Email

Function "un.onClick.Send.Feedback"
  ${NSD_GetText} $Un_PATH_MESSAGE $R0
  StrCpy $Un_YOUR_Message "$R0"

  ${NSD_GetText} $Un_PATH_EMAIL $R2
  StrCpy $Un_YOUR_Email "$R2"

  ClearErrors
  ReadRegStr $RUNDIR HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NSIS" "InstallLocation"
  IfErrors 0 +3
  ${If} $RUNDIR != "1"
    nsExec::ExecToStack '"$RUNDIR\Feedback\senditquiet.exe" -s smtp.mail.sourceforge.net -protocol ssl -f $Un_YOUR_Email -t kichik@users.sourceforge.net -subject Uninstall -body $Un_YOUR_Message' $0
    pop $0
    pop $1
      MessageBox MB_OK "$1"
    Abort
  ${EndIf}
FunctionEnd

Function "Un.onClick.Express.Uninstall"
  System::Call user32::SetWindowPos(i$HWNDPARENT,i0,i0,i0,i651,i451,i0x0002)
  System::Call user32::SetWindowPos(i$Dialog,i0,i0,i0,i651,i451,i0x0002)
  SendMessage $HWNDPARENT 0x408 1 0
FunctionEnd

Function "Un.InstFilesPageShow"
    FindWindow $R2 "#32770" "" $HWNDPARENT
    GetDlgItem $0 $HWNDPARENT 1
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 2
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 3
    
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $1 $R2 1027
    ShowWindow $1 ${SW_HIDE}

    # WINDOW #

    StrCpy $R0 $R2
    System::Call "user32::MoveWindow(i R0, i 0, i 0, i 651, i 451) i r2"
    GetFunctionAddress $0 un.onGUICallback
    WndProc::onCallback $R0 $0

    GetDlgItem $R3 $R2 1990
    SetCtlColors $R3 "0x666666" "0xFFFFFF"
    System::Call "user32::MoveWindow(i R3, i 600, i 6, i 16, i 16) i r2"
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_min.bmp $R3
    GetFunctionAddress $3 "Un.onClick.Minimize"
    SkinBtn::onClick $R3 $3

    GetDlgItem $R4 $R2 1991
    SetCtlColors $R4 "0x666666" "0xFFFFFF"
    System::Call "user32::MoveWindow(i R4, i 620, i 6, i 16, i 16) i r2"
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_close.bmp $R4
    ;GetFunctionAddress $3 "Un.onClick.Close"
    SkinBtn::onClick $R4 $3
    EnableWindow $R4 0

    # PROGRESSBAR #

    GetDlgItem $R0 $R2 1004
    SetCtlColors $R2 "0x666666" "0xFFFFFF"
    System::Call "user32::MoveWindow(i R0, i 35, i 340, i 570, i 6) i r2"

    # DETAILPRINT #

    GetDlgItem $R1 $R2 1006
    SetCtlColors $R1 "0x7B8DB6" "0xFFFFFF"
    System::Call "user32::MoveWindow(i R1, i 35, i 315, i 570, i 20) i r2"
    CreateFont $UN_FONT_NAME "Microsoft Yahei" 10 400
    SendMessage $R1 ${WM_SETFONT} $UN_FONT_NAME 0

    # SHOW DETAIL #

    GetDlgItem $R8 $R2 1016
    SetCtlColors $R8 "0x7B8DB6" "0xFFFFFF"
    System::Call "user32::MoveWindow(i R8, i 35, i 85, i 570, i 210) i r2"

    # BACKGROUND #

    FindWindow $R2 "#32770" "" $HWNDPARENT
    GetDlgItem $R0 $R2 1995
    System::Call "user32::MoveWindow(i R0, i 0, i 0, i 651, i 451) i r2"
    ${NSD_SetImage} $R0 "$PLUGINSDIR\001.bmp" $Un_ImageHandle

    # PROGRESSBAR ::... #

    FindWindow $R2 "#32770" "" $HWNDPARENT
    GetDlgItem $5 $R2 1004
    SkinProgress::Set $5 "$PLUGINSDIR\progressbar_foreground.bmp" "$PLUGINSDIR\progressbar_foreground.bmp"

    # Title #

    GetDlgItem $R7 $R2 1002
    SetCtlColors $R7 "0xA5B6DA" "0xFFFFFF"
    System::Call "user32::MoveWindow(i R7, i 22, i 5, i 200, i 16) i r2"
    System::Call "user32::SetWindowText(i R7, t $\"Nullsoft Installer$\")"
    CreateFont $UN_FONT_NAME "Microsoft Yahei" 8 300
    SendMessage $R7 ${WM_SETFONT} $UN_FONT_NAME 0

    StrCpy $R9 1
    Call Un.RelGotoPage
FunctionEnd

Section "Uninstall"

   DetailPrint `Start Uninstall ...`

   DeleteRegKey HKCR "NSIS.Script"
   DeleteRegKey HKCR "NSIS.Header"

   DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Classes\NSIS.Header\shell\open\command"
   DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Classes\NSIS.Header\shell\open"
   DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Classes\NSIS.Header\shell"
   DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Classes\NSIS.Header\DefaultIcon"
   DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Classes\NSIS.Header"

   DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Classes\NSIS.LangFile\DefaultIcon"
   DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Classes\NSIS.LangFile"
   DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Classes\NSIS.Script\shell\open\command"
   DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Classes\NSIS.Script\shell\open"
   DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Classes\NSIS.Script\shell\compile-compressor\command"
   DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Classes\NSIS.Script\shell\compile-compressor"
   DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Classes\NSIS.Script\shell\compile\command"
   DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Classes\NSIS.Script\shell\compile"
   DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Classes\NSIS.Script\shell"
   DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Classes\NSIS.Script\DefaultIcon"
   DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Classes\NSIS.Script"

   DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Classes\NSIS.Script\W7Menu\shell\compile-compressor\command"
   DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Classes\NSIS.Script\W7Menu\shell\compile-compressor"
   DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Classes\NSIS.Script\W7Menu\shell\compile\command"
   DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Classes\NSIS.Script\W7Menu\shell\compile"
   DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Classes\NSIS.Script\W7Menu\shell"
   DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Classes\NSIS.Script\W7Menu\DefaultIcon"
   DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Classes\NSIS.Script\W7Menu"
   DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NSIS"
   DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\NSIS"

   SetShellVarContext all  

   Delete "$DESKTOP\NSIS.lnk"
   Delete "$DESKTOP\NSIS.lnk" 

   Sleep 500
   Sleep 500
   Sleep 500

   SetShellVarContext all  

   Delete "$INSTDIR\Bin\*.*"
   RMDir /r "$INSTDIR\Bin"

   Delete "$INSTDIR\Contrib\*.*"
   RMDir /r "$INSTDIR\Contrib"

   Delete "$INSTDIR\Docs\*.*"
   RMDir /r "$INSTDIR\Docs"

   Delete "$INSTDIR\Examples\*.*"
   RMDir /r "$INSTDIR\Examples"

   Delete "$INSTDIR\Include\*.*"
   RMDir /r "$INSTDIR\Include"

   Delete "$INSTDIR\Notepad2\*.*"
   RMDir /r "$INSTDIR\Notepad2"

   Delete "$INSTDIR\Menu\*.*"
   RMDir /r "$INSTDIR\Menu"

   Delete "$INSTDIR\Plugins\*.*"
   RMDir /r "$INSTDIR\Plugins"

   Delete "$INSTDIR\Stubs\*.*"
   RMDir /r "$INSTDIR\Stubs"

   Delete "$INSTDIR\Tools\*.*"
   RMDir /r "$INSTDIR\Tools"

   Delete "$INSTDIR\VNISEdit\*.*"
   RMDir /r "$INSTDIR\VNISEdit"

   Delete "$DESKTOP\VNISEdit.lnk"
   Delete "$DESKTOP\VNISEdit.lnk" 

   RMDir /r "$SMPROGRAMS\NSIS"

   Delete "$DESKTOP\NSIS.lnk"
   Delete "$DESKTOP\NSIS.lnk" 

   Delete "$INSTDIR\NSIS.exe"
   Delete "$INSTDIR\makensis.exe"
   Delete "$INSTDIR\makensisw.exe"
   Delete "$INSTDIR\COPYING"
   Delete "$INSTDIR\NSIS.exe.manifest"
   Delete "$INSTDIR\nsisconf.nsh"
   Delete "$INSTDIR\NSIS.chm" 
   Delete "$INSTDIR\*.*"

   RMDir /r "$INSTDIR\Feedback"
   RMDir /r "$INSTDIR\Bin"
   RMDir /r "$INSTDIR\Contrib"
   RMDir /r "$INSTDIR\Docs"
   RMDir /r "$INSTDIR\Examples"
   RMDir /r "$INSTDIR\Contrib"
   RMDir /r "$INSTDIR\Include"
   RMDir /r "$INSTDIR\Source"
   RMDir /r "$INSTDIR\Stubs"
   RMDir /r "$INSTDIR\Tools" 

   System::Call 'Shell32::SHChangeNotify(i ${SHCNE_ASSOCCHANGED}, i ${SHCNF_IDLIST}, i 0, i 0)'
   System::Call 'shell32::SHChangeNotify(i 0x08000000, i 0, i 0, i 0)'

   Delete "$INSTDIR\uninstall.exe"
   Delete "$INSTDIR\uninst-nsis.exe"

   RMDir /r "$INSTDIR"
   RMDir /r "$INSTDIR"
   RMDir "$InstDir"

   Sleep 500
   Sleep 500
   Sleep 500

   Call Un.RefreshShellIcons

   SetAutoClose true
SectionEnd

Function 'Un.RelGotoPage'
   IntCmp $R9 0 0 Move Move
   StrCmp $R9 "X" 0 Move
   StrCpy $R9 "120"
 
   Move:
     SendMessage $HWNDPARENT "0x408" "$R9" ""
FunctionEnd 

Function Un.RefreshShellIcons
  System::Call "shell32::SHChangeNotify(i 0x08000000, i 0, i 0, i 0)"
FunctionEnd

# FINISH

Function "un.NSIS.Finish.Page"

  var /GLOBAL Un_Btn_Finish

  GetDlgItem $0 $HWNDPARENT 1
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 2
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 3
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 1990
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 1991
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 1992
  ShowWindow $0 ${SW_HIDE}

  System::Call "user32::SetWindowPos(i$HWNDPARENT,i,i,i,i 651,i 451,i 0x16)"
  nsDialogs::Create /NOUNLOAD 1044
  Pop $Un_Dialog
  ${If} $Un_Dialog == error
   Abort
  ${EndIf}
  System::Call "user32::MoveWindow(i$Un_Dialog,i0,i0,i 651,i 451,i0)"

  SetCtlColors $Un_Dialog "0x666666" "0xFFFFFF"

  # ...:: Minimize ::... #

  nsDialogs::CreateControl /NOUNLOAD BUTTON 0x40000000|0x10000000|0x04000000|0x00010000 0 600 6 16 16 ""
  Pop $Un_Btn_Minimize
  StrCpy $1 $Un_Btn_Minimize
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_min.bmp $1
  GetFunctionAddress $3 "Un.onClick.Minimize"
  SkinBtn::onClick /NOUNLOAD $1 $3

  ToolTips::Classic $Un_Btn_Minimize "Minimize"

  SetCtlColors $Un_Btn_Minimize "0x313131" "0xFFFFFF"

  # ...:: Close ::... #

  nsDialogs::CreateControl /NOUNLOAD BUTTON 0x40000000|0x10000000|0x04000000|0x00010000 0 623 6 16 16 ""
  Pop $Un_Btn_Close
  StrCpy $1 $Un_Btn_Close
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_close.bmp $1
  GetFunctionAddress $3 "Un.onClick.Close"
  SkinBtn::onClick /NOUNLOAD $1 $3

  ToolTips::Classic $Un_Btn_Close "Close"

  SetCtlColors $Un_Btn_Close "0x313131" "0xFFFFFF"

  # Finish #

  nsDialogs::CreateControl /NOUNLOAD STATIC 0x40000000|0x10000000|0x04000000|0x00000100 0x00000020 22 5 200 16 "Nullsoft Installer"
  Pop $Un_Lbl_Welcome

  CreateFont $UN_FONT_NAME "Microsoft Yahei" 8 300
  SendMessage $Un_Lbl_Welcome ${WM_SETFONT} $UN_FONT_NAME 0

  SetCtlColors $Un_Lbl_Welcome "0xA5B6DA" "0xFFFFFF"

  # Finish #

  nsDialogs::CreateControl /NOUNLOAD BUTTON 0x40000000|0x10000000|0x04000000|0x00010000 0 242 259 165 46 "$(NSIS.Btn.Close)"
  Pop $Un_Btn_Finish
  StrCpy $1 $Un_Btn_Finish
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_step_complete.bmp $1
  GetFunctionAddress $3 "un.OnClick.Finish"
  SkinBtn::onClick /NOUNLOAD $1 $3

  CreateFont $UN_FONT_NAME "Microsoft Yahei" 12 400
  SendMessage $Un_Btn_Finish ${WM_SETFONT} $UN_FONT_NAME 0

  SetCtlColors $Un_Btn_Finish "0x7B8DB6" "0xFFFFFF"

  # BACKGROUND #

  nsDialogs::CreateControl /NOUNLOAD STATIC 0x10000000|0x40000000|0x04000000|0x0000000E 0 0 0 100% 100% ""
  Pop $Un_BGImage
  Push $0
  Push $R0
  StrCpy $R0 $Un_BGImage
  System::Call "user32::LoadImage(i 0, ts, i 0, i0, i0, i0x0010) i.r0" $PLUGINSDIR\001.bmp
  SendMessage $R0 0x0172 0 $0
  Pop $R0
  Exch $0

  # Back

  GetFunctionAddress $0 "Un.onGUICallback"
  WndProc::onCallback $HWNDPARENT $0
  WndProc::onCallback $Un_BGImage $0

  nsDialogs::Show

  System::Call "user32::DestroyIcon(iR0)"
  System::Call 'user32::DestroyImage(iR0)'
  Return
FunctionEnd

# Finish

Function "un.OnClick.Finish"
  SendMessage $HWNDPARENT 0x408 1 0
FunctionEnd

# ...:: MINIMIZE ::... #

Function "Un.onClick.Minimize"
  ShowWindow $HWNDPARENT ${SW_MINIMIZE}
FunctionEnd

# ...:: CLOSE ::... #

Function "Un.onClick.Close"
  SendMessage $HWNDPARENT ${WM_CLOSE} 0 0
FunctionEnd

# Back

Function "Un.onGUICallback"
  ${If} $0 = ${WM_LBUTTONDOWN}
    SendMessage $HWNDPARENT ${WM_NCLBUTTONDOWN} ${HTCAPTION} $0
  ${EndIf}
FunctionEnd

# End

Function "Un.onGUIEnd"
  SetShellVarContext "all"
  RMDir /r "$TEMP\Uninst_NSIS"
  SetOutPath $TEMP
FunctionEnd