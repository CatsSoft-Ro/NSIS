;handle to window 1
var hwindow1
;handle to controls
Var hBUTTON1
Var hEDIT1
Var hCHECKBOX1
Var hMEMO

Function nsWindowsPage1
  IsWindow $hwindow1 Create_End
  ;define the window style
  !define ExStyle ${WS_EX_CLIENTEDGE}|${WS_EX_APPWINDOW}|${WS_EX_WINDOWEDGE}
  !define Style ${WS_VISIBLE}|${WS_SYSMENU}|${WS_CAPTION}|${WS_OVERLAPPEDWINDOW}

	${NSW_CreateWindowEx} $hwindow1 $hwndparent ${ExStyle} ${Style} "WND 1 (please drop some file(s) / Dir(s) to here)" 1018

  ;set the child window's pos to the center of parent window
  ${NSW_CenterWindow} $hwindow1 $hwndparent
  ;set the distransparent percentage
  ${NSW_SetTransparent} $hwindow1 80
  ;drop multi files/dirs
	${NSW_onDropFiles} $hwindow1 onDropMultiFiles
  ;call back function of window 1
	${NSW_OnBack} OnBack1

	${NSW_CreateButton} 100 -30 50 18u 'WND 2'
	Pop $R0
	${NSW_OnClick} $R0 nsWindowsPage2

	${NSW_CreateButton} 0 0 100% 12u Test
	Pop $hBUTTON1
	${NSW_OnClick} $hBUTTON1 OnClick1

	${NSW_CreateButton} 50 -30 50 18u 'Close'
	Pop $R0
	${NSW_OnClick} $R0 OnBack1

	${NSW_CreateText} 0 35 100% 12u "hello (please drop one dir to here)"
	Pop $hEDIT1
	${NSW_OnChange} $hEDIT1 OnChange1
	;DropFiles ;single dir only
	${NSW_onDropFiles} $hEDIT1 onDropSingleDir

	${NSW_CreateCheckbox} 0 -40 100% 8u Test
	Pop $hCHECKBOX1
	${NSW_OnClick} $hCHECKBOX1 OnCheckbox

	${NSW_CreateMemo} 0 40u 75% 40u "* Type `hello there` above. Type `hello there` above. Type `hello there` above. Type `hello there` above.$\r$\n* Click the button.$\r$\n* Check the checkbox.$\r$\n* Hit the Back button.$\r$\n* Hit the Back button.$\r$\n* Hit the Back button.$\r$\n* Hit the Back button.$\r$\n* Hit the Back button."
	Pop $hMEMO

	${NSW_Show} ;show window
Create_End:
  ShowWindow $hwindow1 ${SW_SHOW}
FunctionEnd

Function OnClick1

	Pop $0 # HWND

	MessageBox MB_OK NSW_MaximizeWindow
  ${NSW_SetTransparent} $hwindow1 100
${NSW_MaximizeWindow} $hwindow1
	MessageBox MB_OK NSW_MinimizeWindow
${NSW_MinimizeWindow} $hwindow1
	MessageBox MB_OK NSW_RestoreWindow
;  SendMessage $hwindow1 ${SW_MAXIMIZE} 0 0
  ${NSW_SetTransparent} $hwindow1 80
${NSW_RestoreWindow} $hwindow1
;	MessageBox MB_OK clicky
FunctionEnd

Function OnChange1

	Pop $0 # HWND

	${NSW_GetText} $hEDIT1 $0

	${If} $0 == "hello there"
		MessageBox MB_OK "right back at ya"
	${EndIf}

FunctionEnd

Function OnBack1
  EnableWindow $hwindow1 0
	MessageBox MB_YESNO "are you sure? $$hwindow1:$hwindow1" IDYES +3
  EnableWindow $hwindow1 1
	Abort
  ${NSW_DestroyWindow} $hwindow1
  BringToFront
  ${NSW_RestoreWindow} $hwndparent
  EnableWindow $hwndparent 1

FunctionEnd

Function onDropMultiFiles ;drop multi file/dir (s)
	Pop $iDropFiles ;numbers of file
  StrCpy $sDropFiles ""
  ${For} $R0 1 $iDropFiles
    Pop $R1
    StrCpy $sDropFiles "$sDropFiles$R1$\r$\n"
  ${Next}
  ;your code here:
	;MessageBox MB_OK "onDropFiles $$sDropFiles:$sDropFiles"
	${NSW_SetText} $hMEMO "file numbers :$iDropFiles$\r$\n$sDropFiles"

FunctionEnd

Function onDropSingleDir ;drop single dir
	Pop $iDropFiles ;numbers of dirs
	Pop $sDropFiles ;full path of this (the first one) dir
  ${For} $R0 2 $iDropFiles
    Pop $R1  ;pop up the rest strings from static memory (if you droped more than one)
  ${Next}
  ;your code:
	;MessageBox MB_OK "onDropFiles $$sDropFiles:$sDropFiles"
  ${GetFileAttributes} "$sDropFiles" "DIRECTORY" $R0
  StrCmp $R0 1 0 +2
	  ${NSW_SetText} $hEDIT1 "$sDropFiles"

FunctionEnd


