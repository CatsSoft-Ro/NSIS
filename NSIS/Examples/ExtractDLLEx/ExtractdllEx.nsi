#       ExtractDllEx Example
#       By Ansifa
#       2008.12.12

;�����ļ�����*.exeѹ�������ļ�����Output\pack.7z_,�Ա������ѹ
;CompressFile.exe ������:
;	CompressFile.exe "�����ѹ�����ļ�" "����δ��ѹ�����ļ�"
!system "md Output"
!system "cd Output"
!system "CompressFile.exe Output\pack.7z_ *.exe"

SetCompressor /SOLID lzma
SetCompress force
XPStyle on
SetFont /LANG=2052 "tahoma" 8
LoadLanguageFile "${NSISDIR}\Contrib\Language files\SimpChinese.nlf"

ShowInstDetails show
OutFile "Output\ExtractDllEx.EXE"
Name "Extractdll Test"
Section

;ExtractDllEx::extract "�ѽ�ѹ,���Ǵ��ָ����ʱ�ļ�" "�����Ѿ�ѹ�����ļ�"
ExtractDllEx::extract "pack.tmp" "pack.7z_"
Pop $0
StrCmp $0 "success" +1 +2
MessageBox MB_ICONINFORMATION|MB_OK '��ѹ�ɹ�!'

DetailPrint '����ֵ:$0'
SectionEnd
