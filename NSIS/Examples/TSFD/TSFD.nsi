SetCompressor /SOLID lzma
SetCompress force
XPStyle on
OutFile "TSFD Example.EXE"
Name "TSFD Example.EXE"
Function .onInit
SetSilent silent
FunctionEnd
Section
tSFD::SelectFileDialog /NOUNLOAD open $EXEDIR "ָ���ļ� TSFD.nsi|TSFD.nsi|NSIS�ű� (*.nsi)|*.nsi|�����ļ� (*.exe)|*.exe|�����ļ� (*.*)|*.*"
Pop $0
tSFD::SelectFileDialog /NOUNLOAD save $EXEDIR "ָ���ļ� TSFD.nsi|TSFD.nsi|NSIS�ű� (*.nsi)|*.nsi|�����ļ� (*.exe)|*.exe|�����ļ� (*.*)|*.*"
Pop $1
MessageBox MB_ICONINFORMATION|MB_OK 'Open Result:$0$\r$\nSave Result:$1$\r$\n$\r$\nTSFD Example by Ansifa$\r$\n2008.12.12'
SectionEnd
