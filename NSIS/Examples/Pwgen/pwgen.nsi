!AddPluginDir "..\..\Plugins"

Name "����������ɲ��"

OutFile "pwgen-test.exe"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\SimpChinese.nlf"

Function .onInit
	pwgen::GeneratePassword 10
	Pop $0
	MessageBox MB_OK "������� : $0"
FunctionEnd

Section
SectionEnd
