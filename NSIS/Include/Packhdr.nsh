!ifndef __Packhdr_NSH__
!define __Packhdr_NSH__

!ifndef Packhdr
  !define Packhdr upx
!endif

!if `${Packhdr}` != noicon
  !if `${Packhdr}` != noicon+upx
    !if `${Packhdr}` != upx
      !error `Packhdr must be defined as: noicon, noicon+upx, upx`
    !endif
  !endif
!endif

!ifdef RequestExecutionLevel
!if `${RequestExecutionLevel}` != none

  !if `${RequestExecutionLevel}` = admin
    !define _RequestExecutionLevel requireAdministrator
  !else if `${RequestExecutionLevel}` = highest
    !define _RequestExecutionLevel highestAvailable
  !else if `${RequestExecutionLevel}` = user
    !define _RequestExecutionLevel asInvoker
  !else
    !error `RequestExecutionLevel must be defined as: user, admin, highest`
  !endif

  !tempfile RequestExecutionLevelManifest
  !appendfile `${RequestExecutionLevelManifest}` `<?xml version="1.0" encoding="UTF-8" standalone="yes"?><assembly xmlns="urn:schemas-microsoft-com:asm.v1" manifestVersion="1.0"><assemblyIdentity version="1.0.0.0" processorArchitecture="X86" name="Nullsoft.NSIS.exehead" type="win32"/><description>Nullsoft Install System ${NSIS_VERSION}</description><dependency><dependentAssembly><assemblyIdentity type="win32" name="Microsoft.Windows.Common-Controls" version="6.0.0.0" processorArchitecture="X86" publicKeyToken="6595b64144ccf1df" language="*" /></dependentAssembly></dependency><trustInfo xmlns="urn:schemas-microsoft-com:asm.v3"><security><requestedPrivileges><requestedExecutionLevel level="${_RequestExecutionLevel}" uiAccess="false"/></requestedPrivileges></security></trustInfo><compatibility xmlns="urn:schemas-microsoft-com:compatibility.v1"><application><supportedOS Id="{e2011457-1546-43c5-a5fe-008deee3d3f0}"/><supportedOS Id="{35138b9a-5d96-4fbd-8e2d-a2440225f93a}"/><supportedOS Id="{4a2f28e3-53b9-4441-ba9c-d69d4a4a6e38}"/><supportedOS Id="{1f676c76-80e1-4239-95bb-83d0f6d0da78}"/></application></compatibility></assembly>`

  !undef _RequestExecutionLevel
  !undef RequestExecutionLevel

!endif
!endif

!ifdef RequestExecutionLevelManifest
  !packhdr $%TEMP%\exehead.tmp `"${NSISDIR}\Packhdr\Packhdr.bat" "$%TEMP%\exehead.tmp" ${Packhdr} "${RequestExecutionLevelManifest}"`
!else
  !packhdr $%TEMP%\exehead.tmp `"${NSISDIR}\Packhdr\Packhdr.bat" "$%TEMP%\exehead.tmp" ${Packhdr}`
!endif

!undef Packhdr

!endif