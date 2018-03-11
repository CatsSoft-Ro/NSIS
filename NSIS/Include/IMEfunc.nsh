/*____________________________________________


   [ ���뷨��Ϣ��װж�� NSIS ʵ�ú��� ]
      < ͷ�ļ�: IMEfunc.nsh >


   By Engine @ bbs.hanzify.org  2006

 Email: hesung at qq.com



  * �ṩһ��ͨ�ú꣬����������(�ֱ����ڰ�װ�����ж�ض�����)����...

  (1) �� InstallIME ( ����ҪԤ���� )
  (2) ���� RemoveIME ( ��ҪԤ���� )
  (3) ���� un.RemoveIME ( ��ҪԤ���� )

______________________________________________
*/

#####################################################################
##  ʹ��˵���� ##
#################

#------------------------------------------------------------------
# ע�����뷨���ܲ���:
# �� InstallIME ( ����ҪԤ���� )
#------------------------------------------------------------------

# �÷�:
/****************************
#; ����Ľű���ͷ����ͷ�ļ�
!include "IMEfunc.nsh"


#; ����Ҫ�ĵط������:
!insertmacro InstallIME "���뷨ime�ļ�����·��" "���뷨�����ı�"

;; ����: !insertmacro InstallIME "$SYSDIR\unispim.ime" "�Ϲ�ƴ�����뷨3.0"
*****************************/


#------------------------------------------------------------------
# ��ע�����뷨���ܲ���:
# ���� RemoveIME ( ��ҪԤ���� )
# ���� un.RemoveIME ( ��ҪԤ���� )
#------------------------------------------------------------------

# �÷�:
/****************************
#; ����Ľű���ͷ����ͷ�ļ�:
!include "IMEfunc.nsh"

#; �����ű��������õ��ĺ���: (����ж�س������� ${un.RemoveIME})
${RemoveIME}

#; �������÷���:
Push "���뷨ime�ļ���"
Call RemoveIME

#; Ȼ��Ӧ����һϵ��ɾ���ļ��Ĵ���...
*****************************/

# ����:
/****************************
Push "unispim.ime"
Call RemoveIME
DetailPrint `��ע�� $\"�Ϲ�ƴ�����뷨3.0$\" ���...`

;; ���Լ���һϵ��ɾ���������..
; Delete "$SYSDIR\unispim.ime"
; Delete "$SYSDIR\upengine.dll"
; RMDir /r "$SYSDIR\IME\Unispim"
; RMDir /r "$APPDATA\Unispim"
;; ����һЩע�����Ŀ���ȵ�...
*****************************/


#####################################################################



;<IMEfunc.nsh> ��ʼ...



!ifndef INC.UNINSTALLIMEFUNC.NSH
 !define INC.UNINSTALLIMEFUNC.NSH

!verbose push
!verbose 3

!include    "logiclib.nsh"

;------------------------------------


!macro InstallIME ARG_IME_FILE ARG_IME_TEXT

 IfFileExists ${ARG_IME_FILE} +3
  DetailPrint "ע�����뷨��Ϣʧ�ܣ��Ҳ����ļ�$\"${ARG_IME_FILE}$\"��"
  ;; ��Ҫ���ڰ�װ������Թ���...
  Abort
 System::Call 'imm32::ImmInstallIME(t `${ARG_IME_FILE}` ,t `${ARG_IME_TEXT}`)'
 DetailPrint `ע�� $\"${ARG_IME_TEXT}$\" ���...`

!macroend


;------------------------------------


!define RemoveIME `!insertmacro DEF_FUNC_RemoveIME ""`
!define un.RemoveIME `!insertmacro DEF_FUNC_RemoveIME "un."`

################################
!define INC.USEFULLIB.NSH

/***
����˵��:

���桰 �������뷨�ȼ���Ϣ���֡� ʹ�õ���
��ɫ���ʺ����� Usefullib.nsh �е� ReadRegBin ������

�統ǰ���NSIS\includeĿ¼��û��Usefullib.nsh�����Գ��������������
http://forums.winamp.com/attachment.php s=&postid=2015251
�������ʱ�������ȡ�������Ƚ����� !define INC.USEFULLIB.NSH ע�͵�...
***/
################################

!ifdef INC.USEFULLIB.NSH
 !echo "��Ҫ������ɫ���ʵ�ʵ�ú������ļ� Usefullib.nsh ..."
 !include "Usefullib.nsh"
!endif

!define HKCU_PRELAOD_TEMPKEY `Keyboard Layout\UninstallTempkey`
!define HKML_KEYBOARD_LAYOUT `SYSTEM\CurrentControlSet\Control\Keyboard Layouts`
!define HKML_WINDOWS_VERSION `SOFTWARE\Microsoft\Windows NT\CurrentVersion`
!define HKCU_IME_HOTKEYS     `Control Panel\Input Method\Hot Keys`

!macro DEF_FUNC_RemoveIME ARG_UNFIX

 !ifdef INC.USEFULLIB.NSH
  ${${ARG_UNFIX}ReadRegBin} ;;����usefullib.nsh�еĺ���
 !endif

 Function ${ARG_UNFIX}RemoveIME

    Exch $R0 ;;Ҫж�ص�IME
    Push $R1
    Push $R2 ;;KBlayout��
    Push $R3

        StrCpy $R1 0
        ${Do}
            EnumRegKey $R2 HKLM "${HKML_KEYBOARD_LAYOUT}" $R1
                ${IfThen} $R2 == "" ${|} Goto TheEnd ${|}
            ReadRegStr $R3 HKLM "${HKML_KEYBOARD_LAYOUT}\$R2" "IME file"
                ${IfThen} $R3 == $R0 ${|} ${ExitDo} ${|}
            IntOp $R1 $R1 + 1
        ${Loop}
        StrCpy $R1 "0x$R2"
        System::Call "User32::UnloadKeyboardLayout(i R1) i .R0"

        DeleteRegKey HKLM "${HKML_KEYBOARD_LAYOUT}\$R2"
        StrCpy $R1 1
        ${DO}
            ReadRegStr $R0 HKLM "SYSTEM\ControlSet00$R1\Control" "CurrentUser"
                ${IfThen} $R0 == "" ${|} ${ExitDo} ${|}
            DeleteRegKey HKLM "SYSTEM\ControlSet00$R1\Control\Keyboard Layouts\$R2"
            IntOp $R1 $R1 + 1
        ${Loop}

        ;;����TrimPreload����������Ŀ
        Call ${ARG_UNFIX}TrimPreload

        !ifdef INC.USEFULLIB.NSH
        ;;�������뷨�ȼ���Ϣ
            StrCpy $R0 ""
            ${ForEach} $R3 0 6 + 2
                    StrCpy $R1 $R2 2 $R3
                    StrCpy $R0 "$R1$R0"
            ${Next} ;;ת�����뷽ʽ

            StrCpy $R1 0
            ${Do}
                EnumRegKey $R3 HKCU "${HKCU_IME_HOTKEYS}" $R1
                    ${IfThen} $R3 == "" ${|} ${ExitDo} ${|}
                ${${ARG_UNFIX}ReadRegBin} $R2 ${HKCU} "${HKCU_IME_HOTKEYS}\$R3" "Target IME"
                    ${If} $R2 == $R0
                        DeleteRegKey HKCU "${HKCU_IME_HOTKEYS}\$R3"
                        ${ExitDo}
                    ${EndIf}
                IntOp $R1 $R1 + 1
            ${Loop}
        !endif
        TheEnd:

    Pop $R3
    Pop $R2
    Pop $R1
    Pop $R0

 FunctionEnd

 # X. ���� TrimPreload :
 # X. RemoveIME ���Ӻ����������뷨Ԥ����-ע��������...
 Function ${ARG_UNFIX}TrimPreload

    Push $0
    Push $1
    Push $2
    Push $3
    Push $4 ;KBlayout
    Push $5 ;Counter
    Push $6 ;HKL
    Push $7 ;HIWORD
    Push $8 ;LangID
    Push $9 ;DefaultLangID
    Push $R0 ;Windows Version

 SetPluginUnload alwaysoff
    System::Call 'user32::GetKeyboardLayout(i 0)i.r0'
        IntFmt $0 "%08x" $0
        StrCpy $9 $0 "" -4
    System::Call 'user32::GetKeyboardLayoutList(i 0, i 0) i .r3'
        IntOp $3 $3 * 4
    System::Alloc $3
        Pop $2
    System::Call 'user32::GetKeyboardLayoutList(i r3, i r2) i .r0'
        IntCmp 1 $0 0 0 TheEnd

    ClearErrors
    ReadRegStr $R0 HKLM "${HKML_WINDOWS_VERSION}" CurrentVersion
        IfErrors 0 +2
        StrCpy $R0 "Win9X"
    DeleteRegKey HKCU "Keyboard Layout\Preload"
    DeleteRegKey HKCU "Keyboard Layout\Substitutes"

    IntOp $3 $2 + $3
    IntOp $3 $3 - 4
    ${ForEach} $2 $2 $3 + 4
        System::Call '*$2(i .r0)'
        IntFmt $6 "%08x" $0
        StrCpy $8 $6 "" -4
        StrCpy $7 $6 4
            ReadRegStr $5 HKCU "${HKCU_PRELAOD_TEMPKEY}\$8\Preload" ""
            IntOp $5 $5 + 1
        ${If} $8 == $7
            StrCpy $4 "0000$8"
            WriteRegStr HKCU "${HKCU_PRELAOD_TEMPKEY}\$8\Preload" "" $5
            WriteRegStr HKCU "${HKCU_PRELAOD_TEMPKEY}\$8\Preload" $5 $4
            ${Continue}
        ${EndIf}
        StrCpy $0 $6 1
        ${Switch} $0
            ${Case} 'e'
                StrCpy $4 $6
                WriteRegStr HKCU "${HKCU_PRELAOD_TEMPKEY}\$8\Preload" "" $5
                WriteRegStr HKCU "${HKCU_PRELAOD_TEMPKEY}\$8\Preload" $5 $4
                ${Break}
            ${Case} 'f'
                IntOp $7 0x$7 & 0x0fff
                IntFmt $7 "%04x" $7
                StrCpy $1 0
                ${Do}
                    EnumRegKey $4 HKLM "${HKML_KEYBOARD_LAYOUT}" $1
                        ${IfThen} $4 == "" ${|} ${ExitDo} ${|}
                    ReadRegStr $0 HKLM "${HKML_KEYBOARD_LAYOUT}\$4" "Layout Id"
                        ${IfThen} $0 == $7 ${|} Goto Default ${|}
                    IntOp $1 $1 + 1
                ${Loop}
                ${Break}
            ${CaseElse}
                StrCpy $4 "0000$6" 8
                Default:
                ReadRegStr $0 HKCU "${HKCU_PRELAOD_TEMPKEY}\$8" ""
                IntOp $1 0x$0 + 0xd000
                IntFmt $1 "%04x" $1
                IntOp $0 $0 + 1
                WriteRegStr HKCU "${HKCU_PRELAOD_TEMPKEY}\$8" "" $0
                ${If} $R0 == "Win9X"
                    WriteRegStr HKCU "Keyboard Layout\Substitutes\$1$8" "" $4
                ${Else}
                    WriteRegStr HKCU "Keyboard Layout\Substitutes" "$1$8" $4
                ${EndIf}
                WriteRegStr HKCU "${HKCU_PRELAOD_TEMPKEY}\$8\Preload" "" $5
                WriteRegStr HKCU "${HKCU_PRELAOD_TEMPKEY}\$8\Preload" $5 "$1$8"
        ${EndSwitch}
    ${Next}

    StrCpy $1 1
    ${Do}
        ${If} $1 == 1
            StrCpy $8 $9
        ${Else}
            EnumRegKey $8 HKCU "${HKCU_PRELAOD_TEMPKEY}" 0
            ${If} $8 == ""
                DeleteRegKey HKCU "${HKCU_PRELAOD_TEMPKEY}"
                ${ExitDo}
            ${EndIf}
        ${EndIf}
        ReadRegStr $5 HKCU "${HKCU_PRELAOD_TEMPKEY}\$8\Preload" ""
        ${For} $0 1 $5
            ReadRegStr $6 HKCU "${HKCU_PRELAOD_TEMPKEY}\$8\Preload" $0
            ${If} $R0 == "Win9X"
                WriteRegStr HKCU "Keyboard Layout\Preload\$1" "" $6
            ${Else}
                WriteRegStr HKCU "Keyboard Layout\Preload" $1 $6
            ${EndIf}
            IntOp $1 $1 + 1
        ${Next}
        DeleteRegKey HKCU "${HKCU_PRELAOD_TEMPKEY}\$8"
    ${Loop}
    TheEnd:
 SetPluginUnload manual
 System::Free $0

    Pop $R0
    Pop $9
    Pop $8
    Pop $7
    Pop $6
    Pop $5
    Pop $4
    Pop $3
    Pop $2
    Pop $1
    Pop $0

 FunctionEnd

!macroend # DEF_FUNC_RemoveIME

!verbose pop
!endif # INC.UNINSTALLIMEFUNC.NSH
