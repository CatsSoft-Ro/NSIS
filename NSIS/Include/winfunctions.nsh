#  -------------------------------------------------------------------------------
#  WinFunctions.nsh
#  created 2004 by Comm@nder21 (com_mander_21@yahoo.de)
#  -------------------------------------------------------------------------------
#  ChangeLog:
#  2004-07-30 - v0.1 (Comm@nder21):  *Initial Release
#  
#  << contributors, add your entries here :) >>
#  -------------------------------------------------------------------------------
#  This NSIS header file contains many useful macros for easy use of the mighty System.dll plugin.
#  It's free to be constantly updated by the NSIS community, while this header is kept.
#  -------------------------------------------------------------------------------
#  The MSDN path is relative to the following basic URL: "http://msdn.microsoft.com/library/default.asp?url=" (without quotes :) ), the file is relative to the path.
#  -------------------------------------------------------------------------------
#  Syntax:
#  To use the content of this file in your script, place this file in any include-folder and include it: !include WinFunctions.nsh
#  To use a macro simply include it like that: !insertmacro AnimateWindow $HWND  "500"  "${AW_SHOW}|${AW_SLIDE}"  "r0"
#  In this example, "AnimateWindow" is the macro name, "$HDWN" is a variable containing a window handle, "500" is simply an integer, "${AW_ ..." are flags and "r0" is the name of a variable.
#  About the types of those parameters, read the SystemDLL readme. Parameters beginning with "_" MUST be the NAME of variables (without the $ character), because they'll contain the return values.
#  -------------------------------------------------------------------------------


!ifndef	WINFUNCTIONS_INCLUDED
!define	WINFUNCTIONS_INCLUDED
!echo	WinFunctions.nsh  Headerfile, 2004 by Comm@nder21

!include	WinMessages.nsh

#  -------------------------------------------------------------------------------
# Window Functions
# MSDN path: "/library/en-us/winui/WinUI/WindowsUserInterface/Windowing/Windows/WindowReference/WindowFunctions/"

# AnimateWindow()
# MSDN file: "AnimateWindow.asp"
!macro	AnimateWindow  hWnd dwTime  dwFlags  _ReturnVar
	System::Call  "user32::AnimateWindow(i ${hWnd}, i ${dwTime}, i ${dwFlags}) i ${_ReturnVar}"
!macroend


# BringWindowToTop()
# MSDN file: "BringWindowToTop.asp"
!macro	BringWindowToTop  hWnd  _ReturnVar
	System::Call "user32::BringWindowToTop(i ${hWnd}) i ${_ReturnVar}"
!macroend


# CloseWindow()
# MSDN file: "CloseWindow.asp"
!macro	CloseWindow  hWnd  _ReturnVar
	System::Call "user32::CloseWindow(i ${hWnd}) i ${_ReturnVar}"
!macroend


# CreateWindow()
# MSDN file: "CreateWindow.asp"
!macro	CreateWindow  hWnd  lpClassName  lpWindowName  dwStyle  X  Y  nWidth  nHeigth  hWndParent  hMenu  hInstance  lpParam  _ReturnVar
	System::Call "user32::CreateWindow(i ${hWnd}, t ${lpClassName}, t ${lpWindowName}, i ${dwStyle}, i ${X}, i ${Y}, i ${nWidth}, i ${nHeigth}, i ${hWndParent}, i ${hMenu}, i ${hInstance}, t ${lpParam}) i ${_ReturnVar}"
!macroend


# DestroyWindow()
# MSDN file: "DestroyWindow.asp"
!macro	DestroyWindow  hWnd  _ReturnVar
	System::Call "user32::DestroyWindow(i ${hWnd}) i ${_ReturnVar}"
!macroend


# EndTask()
# MSDN file: "EndTask.asp"
!macro	EndTask  hWnd  fForce  _ReturnVar
	System::Call "user32::EndTask(i ${hWnd}, i 'FALSE', i ${fForce}) i ${_ReturnVar}"
!macroend


# FindWindow()
# MSDN file: "FindWindow.asp"
!macro	FindWindow  lpClassName  lpWindowName  _ReturnVar
	System::Call "user32::FindWindow(t ${lpClassName}, t ${lpWindowName}) i ${_ReturnVar}"
!macroend


# GetDesktopWindow()
# MSDN file: "GetDesktopWindow.asp"
!macro	GetDesktopWindow  _ReturnVar
	System::Call "user32::GetDesktopWindow() i ${_ReturnVar}"
!macroend


# GetForegroundWindow()
# MSDN file: "GetForegroundWindow.asp"
!macro	GetForegroundWindow  _ReturnVar
	System::Call "user32::GetForegroundWindow() i ${_ReturnVar}"
!macroend


# GetNextWindow()
# MSDN file: "GetNextWindow.asp"
!macro	GetNextWindow  hWnd  wCmd  _ReturnVar
	System::Call "user32::GetNextWindow(i ${hWnd}, i ${wCmd}) i ${_ReturnVar}"
!macroend


# GetParent()
# MSDN file: "GetParent.asp"
!macro	GetParent  hWnd  _ReturnVar
	System::Call "user32::GetParent(i ${hWnd}) i ${_ReturnVar}"
!macroend


# GetShellWindow()
# MSDN file: "GetShellWindow.asp"
!macro	GetShellWindow  _ReturnVar
	System::Call "user32::GetShellWindow() i ${_ReturnVar}"
!macroend


# GetTitleBarInfo()
# MSDN file: "GetTitleBarInfo.asp"
!macro	GetTitleBarInfo  hWnd  _pti  _ReturnVar
	System::Call "user32::GetTitleBarInfo(i ${hWnd}, .i .${pti}) i ${_ReturnVar}"
!macroend


# GetTopWindow()
# MSDN file: "GetTopWindow.asp"
!macro	GetTopWindow  hWnd  _ReturnVar
	System::Call "user32::GetTopWindow(i ${hWnd}) i ${_ReturnVar}"
!macroend


# GetWindow ()
# MSDN file: "GetWindow .asp"
!macro	GetWindow   hWnd  uCmd  _ReturnVar
	System::Call "user32::GetWindow (i ${hWnd}, i ${uCmd}) i ${_ReturnVar}"
!macroend


# GetWindowInfo()
# MSDN file: "GetWindowInfo.asp"
!macro	GetWindowInfo  hWnd  _pwi  _ReturnVar
	System::Call "user32::GetWindowInfo(i ${hWnd}, .i .${pwi}) i ${_ReturnVar}"
!macroend


# GetWindowModuleFileName()
# MSDN file: "GetWindowModuleFileName.asp"
!macro	GetWindowModuleFileName  hWnd  lpszFileName  _ReturnVar
	System::Call "user32::GetWindowModuleFileName(i ${hWnd}, t ${lpszFileName}, i ${NSIS_MAX_STRLEN}) i ${_ReturnVar}"
!macroend


# MoveWindow()
# MSDN file: "MoveWindow.asp"
!macro	MoveWindow  hWnd  X  Y  nWidth  nHeigth  bRepaint  _ReturnVar
	System::Call "user32::MoveWindow(i ${hWnd}, i ${X},it ${Y}, i ${nWidth}, i ${nHeigth}, i ${bRepaint}) i ${_ReturnVar}"
!macroend


# ShowWindow()
# MSDN file: "ShowWindow.asp"
!macro	ShowWindow  hWnd  nCmdShow  _ReturnVar
	System::Call "user32::ShowWindow(i ${hWnd}, i ${nCmdShow}) i ${_ReturnVar}"
!macroend
#  -------------------------------------------------------------------------------





#  -------------------------------------------------------------------------------
!endif
# EOF