#	FindProc Example
#   By Ansifa
#   2008-12-12

OutFile "FindProc.EXE"
Name "FindProc Test"
SetFont /LANG=2052 "tahoma" 8
LoadLanguageFile "${NSISDIR}\Contrib\Language files\SimpChinese.nlf"

Section

#	�÷�:
#	FindProcDLL::FindProc "������"
#	����ֱֵ����$R0,����ҪPop $R0֮��.

FindProcDLL::FindProc "taskmgr.exe"
StrCmp $R0 1 +1 +2
MessageBox MB_ICONINFORMATION|MB_OK 'Windows���̹�������������!'
SectionEnd
