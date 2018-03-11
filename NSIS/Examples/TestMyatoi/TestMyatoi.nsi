Name TestMyatoi
OutFile TestMyatoi.exe
ShowInstDetails show

!include MUI2.nsh
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_LANGUAGE English

Section

  !define THE_NUMBER 999

  TestMyatoi::test_myatoi `${THE_NUMBER}`
  Pop $R0
  DetailPrint `test_myatoi: Pushed: ${THE_NUMBER}, Result: $R0`

  TestMyatoi::test_myatou `${THE_NUMBER}`
  Pop $R0
  DetailPrint `test_myatou: Pushed: ${THE_NUMBER}, Result: $R0`

  TestMyatoi::test_popint `${THE_NUMBER}`
  Pop $R0
  DetailPrint `test_popint : Pushed: ${THE_NUMBER}, Result: $R0`

  TestMyatoi::test_my_atoi `${THE_NUMBER}`
  Pop $R0
  DetailPrint `test_my_atoi: Pushed: ${THE_NUMBER}, Result: $R0`

  !undef THE_NUMBER

SectionEnd