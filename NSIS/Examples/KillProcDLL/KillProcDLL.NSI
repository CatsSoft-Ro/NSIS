#	KillProc Example
#   By Ansifa
#   2008-12-12

OutFile "KillProc.EXE"
Name "KillProc Test"
SetFont /LANG=2052 "tahoma" 8
LoadLanguageFile "${NSISDIR}\Contrib\Language files\SimpChinese.nlf"

Section

#	�÷�:
#	KillProcDLL::KillProc "������"
#	����ֱֵ����$R0,����ҪPop $R0֮��.

KillProcDLL::KillProc "taskmgr.exe"
StrCmp $R0 0 +1 +2
MessageBox MB_ICONINFORMATION|MB_OK 'Windows���̹������ɹ�����!'
StrCmp $R0 603 +1 +2
MessageBox MB_ICONINFORMATION|MB_OK 'Windows���̹�������δ����!'
SectionEnd