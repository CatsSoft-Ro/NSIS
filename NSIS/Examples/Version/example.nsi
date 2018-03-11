Name VersionExample

# Included files
!include Sections.nsh
!include "LogicLib.nsh"

OutFile "Example_Version_NSIS_plugin.exe"

#Declare variables
var isWindowsXP
var MajorVersion
var MinorVersion
var BuildNumber
var PlatformID
var CSDVersion
var ProductType 


Section -Nope
#Nothing to do here
SectionEnd

Function .onInit

  #detect Windows XP
  Version::IsWindowsXP
  #obtain value
  Pop $isWindowsXP
  
  ${if} $isWindowsXP == "1"
    MessageBox MB_OK "Its Windows XP!"
  ${Else}
    MessageBox MB_OK "Its not Windows XP!"
  ${EndIf}
  
  #call plugin dll function 
  Version::GetWindowsVersion

  Pop $MajorVersion
  Pop $MinorVersion
  Pop $BuildNumber
  Pop $PlatformID
  Pop $CSDVersion
  Pop $ProductType

  ${if} $ProductType == "1"
    MessageBox MB_OK "$PlatformID-platform, version $MajorVersion.$MinorVersion, build $BuildNumber, $CSDVersion, Workstation"
  ${ElseIf} $ProductType == "2"
    MessageBox MB_OK "$PlatformID-platform, version $MajorVersion.$MinorVersion, build $BuildNumber, $CSDVersion, DomainController"
  ${ElseIf} $ProductType == "3"
    MessageBox MB_OK "$PlatformID-platform, version $MajorVersion.$MinorVersion, build $BuildNumber, $CSDVersion, Server"
  ${Else}
    MessageBox MB_OK "$PlatformID-platform, version $MajorVersion.$MinorVersion, build $BuildNumber, $CSDVersion, Unknown ProductType"
  ${EndIf}
  Quit
  
FunctionEnd