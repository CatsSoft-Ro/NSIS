;		Chngvrblʾ��
;		Ansifa
;		2008-12-12
SetCompressor /SOLID lzma
SetCompress force
XPStyle on
SetFont /LANG=2052 "tahoma" 8
LoadLanguageFile "${NSISDIR}\Contrib\Language files\SimpChinese.nlf"
OutFile "Chngvrbl.EXE"
Name "Chngvrbl Test"
InstallDir "$TEMP"

Page components
Page directory
Page instfiles
Function .onInit

;	����������淽����ȡ�û�������������ʹ�õ���ʱ�ļ���ֵ
;	��ȡ������ע�ͺ�,���ǿ���ʹ��
;	"Chngvrbl.EXE /TEMP=C:\UserTemp"
;	������ȥָ���˳���ʹ�õ���ʱ�ļ���

;Push "/TEMP="
;Call GetParam
;Pop $0

;�������ָ���˳���ʹ�õ���ʱ�ļ���,Ҳ����ȥ���˾�,�˾�$0ֵ������������
StrCpy $0 "C:\UserTemp"

;���û���Զ�����ʱ�ļ��еĻ�,ʹ��Ĭ�ϵ�$PLUGINSDIR�ļ���
StrCmp $0 "" nousertemp usertemp
usertemp:
	SetOutPath $0
	File /oname=$0\chngvrbl.dll "${NSISDIR}\Plugins\chngvrbl.dll"
	Push $0
	Push 25 ; $PLUGINSDIR
	CallInstDLL "$0\chngvrbl.dll" changeVariable
	Delete "$0\chngvrbl.dll"
;�������MessageBoxֻ����ʾ����
MessageBox MB_ICONINFORMATION|MB_OK '���ڵ���ʱ�ļ����� $0 �˳������ʱ�ļ���������,�򿪿���?'
nousertemp:
	InitPluginsDir
FunctionEnd
Section "����һ��ʾ��"
SectionEnd
