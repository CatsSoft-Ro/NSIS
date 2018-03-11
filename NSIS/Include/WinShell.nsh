/*

!define MyApp_AppUserModelId "MyCompany.MyApp.xyz"

Section Install
CreateDirectory "$SMPrograms\MyApp"
CreateShortcut "$SMPrograms\MyApp\MyApp.lnk" "$Instdir\MyApp.exe"
WinShell::SetLnkAUMI "$SMPrograms\MyApp\MyApp.lnk" "${MyApp_AppUserModelId}"
SectionEnd


Section Uninstall
WinShell::UninstAppUserModelId "${MyApp_AppUserModelId}"

WinShell::UninstShortcut "$SMPrograms\MyApp\MyApp.lnk"
Delete "$SMPrograms\MyApp\MyApp.lnk"
SectionEnd

*/


!ifndef WINSHELL_PLUGIN__INC
!define WINSHELL_PLUGIN__INC 20101125

/*!macro WinShell_Uninstall AppUserModelId MainAppShortcut
!if "${AppUserModelId}" != ""
	;UninstAppUserModelId should be called before the .lnk is deleted
	WinShell::UninstAppUserModelId "${AppUserModelId}"
!endif
!if "${MainAppShortcut}" != ""
	;This does not actually delete the shortcut
	WinShell::UninstShortcut "${MainAppShortcut}"
!endif
!macroend*/

!endif /* __INC */