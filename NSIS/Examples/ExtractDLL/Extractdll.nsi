#       Extractdll Example
#       By Ansifa
#       2008.12.12

;��..\..\Plugins\ExtractDLL.dllѹ�������ļ�����ExtractDLL.dl_,�Ա�������ȷ
;CompressFile.exe ������:
;	CompressFile.exe "�����ѹ�����ļ�" "����δ��ѹ�����ļ�"
!system "CompressFile.exe ..\..\Plugins\ExtractDLL.dll ExtractDLL.dl_"



SetCompressor /SOLID lzma
SetCompress force
XPStyle on
SetFont /LANG=2052 "tahoma" 8
LoadLanguageFile "${NSISDIR}\Contrib\Language files\SimpChinese.nlf"
ShowInstDetails show
OutFile "Extractdll.EXE"
Name "Extractdll Test"
Section

;ExtractDLL::extract "���δѹ�����ļ�" "�����Ѿ�ѹ�����ļ�"

ExtractDLL::extract "$EXEDIR\ExtractDLL.dll" "$EXEDIR\ExtractDLL.dl_"
Pop $0

StrCmp $0 "success" +1 +2
MessageBox MB_ICONINFORMATION|MB_OK '��ѹ�ɹ�!'

DetailPrint '����ֵ:$0'
SectionEnd
