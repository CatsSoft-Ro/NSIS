Name "Test CLRDLL MakeLogEntry"
OutFile "TestCLRDLL.exe"
ShowInstDetails show
Var DetailsHWND
Page instfiles

Function .onGUIEnd
	CLR::Destroy
FunctionEnd

Section
	InitPluginsDir
	SetOutPath $PLUGINSDIR
	File "TestCLRDLL.dll"
	DetailPrint "===================================="
	FindWindow $0 "#32770" "" $HWNDPARENT
	GetDlgItem $DetailsHWND $0 1016
	CLR::Call /NOUNLOAD "TestCLRDLL.dll" \
		"NSIS.TestClass" \
		"ChopString" \
		3 \
		$DetailsHWND "Testing Make Log Entry" 9
	Pop $0
	DetailPrint "ChopString Result = $0"
	DetailPrint "===================================="
	DetailPrint "Chopping a short string to gen error"
	CLR::Call /NOUNLOAD "TestCLRDLL.dll" \
		"NSIS.TestClass" \
		"ChopString" \
		3 \
		$DetailsHWND "Testing" 9
	Pop $0
	DetailPrint "ChopString Result = $0"
SectionEnd
