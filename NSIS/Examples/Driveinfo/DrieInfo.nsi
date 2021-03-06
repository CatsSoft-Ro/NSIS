!define NAME "DriveInfo"

Name "${NAME}"
Outfile "${NAME} setup.exe"
RequestExecutionlevel highest
SetCompressor LZMA

Page instfiles ''

ShowInstDetails show

Section "Test" Main
Push "C:\"
DriveInfo::GetDriveLabel "C:\"
Pop $0
DriveInfo::GetDriveFS "C:\"
Pop $1
MessageBox MB_OK "$0 (C:) - $1"

SectionEnd