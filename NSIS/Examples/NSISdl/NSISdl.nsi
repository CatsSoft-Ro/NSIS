!include 'MUI2.nsh'

Name "TT4.8��������"
OutFile "NSISdl.exe"

ShowInstDetails show

!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_LANGUAGE "SimpChinese"

Section Install

    NSISdl::download /TRANSLATE2 '�������� %s' '��������...' '(ʣ�� 1 ��)' '(ʣ�� 1 ����)' '(ʣ�� 1 Сʱ)' '(ʣ�� %u ��)' '(ʣ�� %u ����)' '(ʣ�� %u Сʱ)' '����ɣ�%skB(%d%%) ��С��%skB �ٶȣ�%u.%01ukB/s' /TIMEOUT=7500 /NOIEPROXY 'http://dl_dir.qq.com/invc/tt/tt4.8setupv892.exe' '$EXEDIR\tt4.8setupv892.exe'
    Pop $R0
    StrCmp $R0 "success" 0 +3
    MessageBox MB_YESNO|MB_ICONQUESTION "TT4.8 �ѳɹ���������$\r$\n$\t$EXEDIR\tt4.8setupv892.exe$\r$\n�Ƿ�����ִ�а�װ����" IDNO +2
    ExecWait '$EXEDIR\tt4.8setupv892.exe'

SectionEnd