; CRCCheck Example
;
; �������˵�������ʹ��CRCCheck.
;
;--------------------------------

Name "CRCCheck Example"
OutFile "CRCCheck Test.exe"
XPStyle on
Page instfiles

Section ""
  SetAutoClose true
  ; ��ȡWindows Explorer �� CRC ֵ
  CRCCheck::GenCRC "$WINDIR\explorer.exe"
  Pop $R1
  MessageBox MB_OK "Windows Explorer CRC: $R1"
SectionEnd
