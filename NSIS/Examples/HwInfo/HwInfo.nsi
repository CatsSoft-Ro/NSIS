;	HwInfo Exmple
;	by Ansifa
;	2008-12-12

ShowInstDetails show
OutFile "HwInfo.EXE"
Name "HwInfo Test"
SetFont /LANG=2052 "tahoma" 8
LoadLanguageFile "${NSISDIR}\Contrib\Language files\SimpChinese.nlf"

Section
HwInfo::GetCpuSpeed
DetailPrint 'CPU �ٶ� : $0'

HwInfo::GetSystemMemory
DetailPrint 'ϵͳ�ڴ� : $0MB'

HwInfo::GetVideoCardName
DetailPrint '�Կ����� : $0'

HwInfo::GetVideoCardMemory
DetailPrint '�Դ��С : $0MB'
SectionEnd
