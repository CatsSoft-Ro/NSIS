; 7zArchive.nsh copyright 2008 qwertymodo


; This header is designed to add or extract files in an archive.
; It can handle 7z, zip, gzip, bzip2, or tar archives.


; This header requires 7za.exe (7-zip command-line, http://www.7-zip.com)
; to be located in the NSIS plugins folder.  7-zip is a free, open-source program,
; copyright Igor Pavlov, distibuted under the GNU LGPL open-source license


; * * * SYNTAX * * *
;
; !include 7zArchive.nsh
;
; . . .
;
; ${AddToArchive} "C:\SomeDirectory\DestinationArchive.zip" "FilesToBeAdded" "ArchiveType" "otherparameters"
;


; In order to place a file in a subdirectory within the archive,
; recreate the folder structure found in the archive and put the
; highest parent directory as the "FilesToAdd" parameter.

; eg:

; If you want to place file.txt in archive.zip within a nested
; folder structure of folder1\folder2\folder3\file.txt, use the
; following code:

; !include AddToArchive.nsh
;
; . . .
;
; SetOutPath $TEMP\folder1\folder2\folder3
; File file.txt
;
; ${AddToArchive} "path\to\archive.zip" "$TEMP\folder1" "zip" ""
;
;
;
; ${ExtractFromArchive} "C:\SomeDirectory\SourceArchive.zip" "FileFilter" "C:\SomeDirectory\DestinationDirectory" "extractwithpaths?" "otherparameters"
;
; extractwithpaths? can be "fullpaths" or "nopaths" defaults to nopaths
;


!include FileFunc.nsh

Function ArchiveIt

  InitPluginsDir
  File /oname=$PLUGINSDIR\7za.exe "${NSISDIR}\plugins\7za.exe"

  ClearErrors

  Exch $0      ; ADDITIONAL_PARAMETERS (added to the end of the program call)
  Exch 1
  Exch $1      ; ARCHIVE_TYPE (7z, zip, gzip, bzip2, or tar)
  Exch 2
  Exch $2      ; FILE_TO_ADD
  Exch 3
  Exch $3      ; DESTINATION_ARCHIVE


  ;Default to zip compression if not specified
  StrCmp $1 "" 0 +2
  StrCpy $1 "zip"
  StrCpy $1 "-t$1"

  ;Start archive
    nsExec::ExecToLog '"$PLUGINSDIR\7za.exe" a $1 $\"$3$\" $\"$2$\" $0'

  Pop $0 ;nsExec return value

  Pop $3
  Pop $0
  Pop $1
  Pop $2

FunctionEnd

Function ExtractIt

  InitPluginsDir
  File /oname=$PLUGINSDIR\7za.exe "${NSISDIR}\plugins\7za.exe"

  ClearErrors

  Exch $0      ; ADDITIONAL_PARAMETERS (added to the end of the program call)
  Exch 1
  Exch $1      ; EXTRACT_PATHS (either "fullpaths" or "nopaths"; defaults to nopaths)
  Exch 2
  Exch $2      ; DESTINATION_FOLDER
  Exch 3
  Exch $3      ; FILE_FILTER (if blank, extracts all files; allows for wildcards, e.g. "*.doc")
  Exch 4
  Exch $4      ; SOURCE_ARCHIVE
  Push $5

  ;Extract all files if no filter specified
  StrCmp $3 "" +2 0
  StrCpy $3 "$\"$3$\""

  ;Default folder if not specified
  StrCmp $2 "" 0 GotFolder
  !insertmacro GetParent
  ${GetParent} "$4" $2
  !insertmacro GetBaseName
  ${GetBaseName} "$4" $5
  StrCpy $2 "$2\$5"

  GotFolder:
  CreateDirectory $2
  StrCmp $1 "fullpaths" 0 +2
  StrCpy $5 "x"
  StrCmp $1 "nopaths" +2 0
  StrCmp $1 "" 0 +2
  StrCpy $5 "e"

  nsExec::ExecToLog '"$PLUGINSDIR\7za.exe" x $\"$4$\" $\"-o$2$\" $3 $0'

  StackBack:

  Pop $0 ;nsExec return value

  Pop $5
  Pop $4
  Pop $0
  Pop $1
  Pop $2
  Pop $3

FunctionEnd

!macro _AddToArchive DESTINATION_ARCHIVE FILE_TO_ADD ARCHIVE_TYPE ADDITIONAL_PARAMETERS
  Push "${DESTINATION_ARCHIVE}"
  Push "${FILE_TO_ADD}"
  Push "${ARCHIVE_TYPE}"
  Push "${ADDITIONAL_PARAMETERS}"
  Call ArchiveIt
!macroend

!macro _ExtractFromArchive SOURCE_ARCHIVE FILE_FILTER DESTINATION_FOLDER EXTRACT_PATHS ADDITIONAL_PARAMETERS
  Push "${SOURCE_ARCHIVE}"
  Push "${FILE_FILTER}"
  Push "${DESTINATION_FOLDER}"
  Push "${EXTRACT_PATHS}"
  Push "${ADDITIONAL_PARAMETERS}"
  Call ExtractIt
!macroend

!define AddToArchive '!insertmacro "_AddToArchive"'
!define ExtractFromArchive '!insertmacro "_ExtractFromArchive"'