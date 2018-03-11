; NSIS frontend to bass (NSISBASS)
; Macros and ´System::Call´ definitions required
; to use BASS Sound System
;
; Written by Saivert
; Updated by Bonk
;
; Dependencies: System.dll - NSIS plugin
;               Bass.dll - BASS Sound System library
;
; Define BASS_LOCATION to the location of BASS.DLL on
; the compiler system if it is located somewhere else.
; '${NSISDIR}\Contrib\nsisbass\bass.dll' is the default.

!ifndef nsisbass.NSH.Included
!verbose push
!verbose 3
!define nsisbass.NSH.Included

Var BFNCHANHANDLE

!define BASS_DLL "$PLUGINSDIR\bass.dll"

; Include the function prototypes for bass.dll
!include "${NSISDIR}\Include\bass.nsh"

; NSISBASSIsPaused, how to use:
;   Call NSISBASSIsPaused
;   Pop $0
; $0 is now either "1" or "0"


!macro NSISBASS_ISPAUSED
!verbose push
!verbose 3
;Function NSISBASSIsPaused
  Push $0
  System::Call /NOUNLOAD '${bfnChannelIsActive} (s) .r0' '$BFNCHANHANDLE'

  StrCmp $0 ${BASS_ACTIVE_PAUSED} paused notpaused
  paused:
    Pop $0
    Push "1"
    ;Return
    Goto doneispaused
  notpaused:
    Pop $0
    Push "0"
  doneispaused:
;FunctionEnd
!verbose pop
!macroend

!define NSISBASS_IsPaused `!insertmacro NSISBASS_ISPAUSED`

!macro NSISBASS_PAUSE
!verbose push
!verbose 3

  System::Call /NOUNLOAD '${bfnChannelPause} (s)' '$BFNCHANHANDLE'

!verbose pop
!macroend

!define NSISBASS_Pause `!insertmacro NSISBASS_PAUSE`

!macro NSISBASS_RESUME
!verbose push
!verbose 3

  System::Call /NOUNLOAD '${bfnChannelPlay} (s,0)' '$BFNCHANHANDLE'

!verbose pop
!macroend

!define NSISBASS_Resume `!insertmacro NSISBASS_RESUME`

!macro NSISBASS_UNIQUEID

  !ifdef NSISBASS_UNIQUEID
    !undef NSISBASS_UNIQUEID
  !endif
  
  !define NSISBASS_UNIQUEID${__LINE__}

!macroend


; 1st. Use the NSISBASS_INIT macro to initialize the
; BASS Sound System.

!macro NSISBASS_INIT
!verbose push
!verbose 3

  !ifdef BASS_LOCATION
    ReserveFile "${BASS_LOCATION}"
  !else
    ReserveFile "${NSISDIR}\Plugins\bass.dll"
  !endif
  ReserveFile "${NSISDIR}\Plugins\system.dll"
  InitPluginsDir
  Detailprint "Initializing BASS Sound System"
  SetDetailsPrint none
  !ifndef BASS_LOCATION
    File "/oname=$PLUGINSDIR\bass.dll" "${NSISDIR}\Plugins\bass.dll"
  !else
    File "/oname=$PLUGINSDIR\bass.dll" "${BASS_LOCATION}"
  !endif
  SetDetailsPrint both
  ; Open device
  System::Call /NOUNLOAD '${bfnInit} (-1,44100,0,0,0) .r0'
!verbose pop
!macroend

!define NSISBASS_Init `!insertmacro NSISBASS_INIT`

; 2nd. Now it's time to ouptut some sound.
; The macro will leave "failed" at the top of the stack if it
; couldn't load the song or if sound card init failed.
;
; Example usage:
;   !insertmacro NSISBASS_PLAY "medley.mp3" 0 ${BASS_SAMPLE_LOOP}

!macro NSISBASS_PLAY SONG RESTART FLAGS
!verbose push
!verbose 3

  Push ${SONG}
  Push ${RESTART}
  Push "${FLAGS}"
  ;Call NSISBASSPlay

  Pop $4 ; Flags
  Pop $3 ; restart
  Pop $2 ; Filename
  Push $1
  Push $0
  StrCpy $0 "" ; Clear
  StrCpy $1 ""

  System::Call /NOUNLOAD '${bfnStreamCreateFile} (0,s,0,0,$4) .r1' '$2'
  StrCpy $BFNCHANHANDLE $1
  StrCmp $1 "0" NSISBASS_FAIL
  System::Call /NOUNLOAD '${bfnStart} .r0'
  System::Call /NOUNLOAD '${bfnChannelPlay} (r1,$3) .r0'
  Goto NSISBASS_EXIT

  NSISBASS_FAIL:
    StrCmp $1 "0" 0 +2
    System::Call /NOUNLOAD "${bfnStreamFree} (r1)"
    System::Call /NOUNLOAD "${bfnStop} () .r0"
    Push "failed"
  NSISBASS_EXIT:
; Restore registers
  Pop $0
  Pop $1
  Pop $2
  Pop $3
  Pop $4

!verbose pop
!macroend

!define NSISBASS_Play `!insertmacro NSISBASS_PLAY`


;***************************************************************

!macro NSISBASS_PLAYNET URL OFFSET FLAGS BUFFER USER
!verbose push
!verbose 3

  Push ${URL}
  Push ${OFFSET}
  Push ${FLAGS}
  Push ${BUFFER}
  Push ${USER}
  ;Call NSISBASSPlayNet

  Pop $6 ; User
  Pop $5 ; Buffer?
  Pop $4 ; Flags
  Pop $3 ; Offset
  Pop $2 ; URL
  Push $1
  Push $0
  StrCpy $0 "" ; Clear
  StrCpy $1 ""

  System::Call /NOUNLOAD '${bfnSetConfig} (BASS_CONFIG_NET_PREBUF,$5) .r0'
  System::Call /NOUNLOAD '${bfnStreamCreateURL} (s,$3,$4,0,$6) .r1' '$2'
  StrCpy $BFNCHANHANDLE $1
  StrCmp $1 "0" NSISBASS_FAIL
  System::Call /NOUNLOAD '${bfnStart} .r0'
  System::Call /NOUNLOAD '${bfnChannelPlay} (r1,$3) .r0'
  Goto NSISBASS_EXIT

  NSISBASS_FAIL:
    StrCmp $1 "0" 0 +2
    System::Call /NOUNLOAD "${bfnStreamFree} (r1)"
    System::Call /NOUNLOAD "${bfnStop} () .r0"
    Push "failed"
  NSISBASS_EXIT:
; Restore registers
  Pop $0
  Pop $1
  Pop $2
  Pop $3
  Pop $4
  Pop $5
  Pop $6

!verbose pop
!macroend

!define NSISBASS_PlayNet `!insertmacro NSISBASS_PLAYNET`


!macro NSISBASS_GETTAGS TAGS
!verbose push
!verbose 3

  Push $0
  Push $1
  Push ${TAGS} ; TAGS

  ;Call NSISBASSGetTags

  StrCpy $1 $BFNCHANHANDLE
  Pop $2 ; TAGS
  System::Call /NOUNLOAD "${bfnChannelGetTags} (r1,r2) .r0"

  Pop $2
  Pop $1
  ;Pop $0

!verbose pop
!macroend

!define NSISBASS_GetTags `!insertmacro NSISBASS_GETTAGS`


!macro NSISBASS_GETCPU
!verbose push
!verbose 3

  Push $0
  Push $1
  ;Call NSISBASSGetCPU
  System::Call /NOUNLOAD "${bfnGetCPU} () .r0"
  Pop $1
  ;Pop $0

!verbose pop
!macroend

!define NSISBASS_GetCPU `!insertmacro NSISBASS_GETCPU`


!macro NSISBASS_CHANGETLEVEL
!verbose push
!verbose 3

  Push $0
  Push $1
  ;Call NSISBASSChanGetLevel
  StrCpy $1 $BFNCHANHANDLE
  System::Call /NOUNLOAD "${bfnChannelGetLevel} (r1) .r0"
  Pop $1
  ;Pop $0

!verbose pop
!macroend

;Function NSISBASSChanGetLevel
;  StrCpy $1 $BFNCHANHANDLE
;  System::Call /NOUNLOAD "${bfnChannelGetLevel} (r1) .r0"
;FunctionEnd

!define NSISBASS_ChanGetLevel `!insertmacro NSISBASS_CHANGETLEVEL`


!macro NSISBASS_GETVOLUME
!verbose push
!verbose 3

  Push $0
  Push $1
  ;Call NSISBASSGetVolume
  System::Call /NOUNLOAD "${bfnGetVolume} () .r0"
  Pop $1
  ;Pop $0

!verbose pop
!macroend

!define NSISBASS_GetVolume `!insertmacro NSISBASS_GETVOLUME`


!macro NSISBASS_SETVOLUME VOL
!verbose push
!verbose 3

  Push $0
  Push $1
  Push ${VOL} ; VOLUME

  ;Call NSISBASSSetVolume

  Pop $2
  System::Call /NOUNLOAD "${bfnSetVolume} (r2) .r0"

  Pop $2
  Pop $1
  ;Pop $0

!verbose pop
!macroend

!define NSISBASS_SetVolume `!insertmacro NSISBASS_SETVOLUME`


!macro NSISBASS_SETCHANFLAGS FLAGS
!verbose push
!verbose 3

  Push $0
  Push $1
  Push ${FLAGS} ; FLAGS

  ;Call NSISBASSSetChanFlags

  StrCpy $1 $BFNCHANHANDLE
  Pop $2
  System::Call /NOUNLOAD "${bfnChannelSetFlags} (r1.r2) .r0"

  Pop $2
  Pop $1
  ;Pop $0

!verbose pop
!macroend

!define NSISBASS_SetChanFlags `!insertmacro NSISBASS_SETCHANFLAGS`


!macro NSISBASS_ERRORGETCODE
!verbose push
!verbose 3

  Push $0
  Push $1

  ;Call NSISBASSErrorGetCode

  System::Call /NOUNLOAD "${bfnErrorGetCode} () .r0"

  Pop $1
  ;Pop $0

!verbose pop
!macroend

!define NSISBASS_ErrorGetCode `!insertmacro NSISBASS_ERRORGETCODE`


!macro NSISBASS_CHANNELSETFX TYPE PRIOR
!verbose push
!verbose 3

  Push $0
  Push $1
  Push ${TYPE} ; TYPE
  Push ${PRIOR} ; PRIORITY

  ;Call NSISBASSChannelSetFX

  StrCpy $1 $BFNCHANHANDLE
  Pop $2
  Pop $3
  System::Call /NOUNLOAD "${bfnChannelSetFX} (r1,r2,r3) .r0"

  Pop $2
  Pop $1
  ;Pop $0

!verbose pop
!macroend

!define NSISBASS_ChannelSetFX `!insertmacro NSISBASS_CHANNELSETFX`



;***************************************************************



!macro NSISBASS_STOP
!verbose push
!verbose 3

; Save registers
  Push $0
  Push $1

  ;Call NSISBASSStop

  System::Call /NOUNLOAD "${bfnStop} () .r0"
  StrCpy $BFNCHANHANDLE $1
  System::Call /NOUNLOAD "${bfnStreamFree} (r1)"
  System::Call /NOUNLOAD "${bfnMusicFree} (r1)"

; Restore registers
  Pop $1
  Pop $0
!verbose pop
!macroend

!define NSISBASS_Stop `!insertmacro NSISBASS_STOP`


!macro NSISBASS_PLAYMUSIC SONG RESTART FLAGS
!verbose push
!verbose 3

; Save registers
  Push $0
  Push $1
  Push $2
  Push $3
  Push $4

  Push "${SONG}"
  Push "${RESTART}"
  Push "${FLAGS}"
  ;Call NSISBASSPlayMusic

  Pop $4 ; Flags
  Pop $3 ; restart
  Pop $2 ; Filename
  StrCpy $0 "" ; Clear
  StrCpy $1 "" ;   all

  System::Call /NOUNLOAD '${bfnMusicLoad} (0,s,0,0,$4,0) .r1' '$2'
  StrCpy $BFNCHANHANDLE $1
  StrCmp $1 "0" NSISBASS_FAIL
  System::Call /NOUNLOAD '${bfnStart} .r0'
  System::Call /NOUNLOAD '${bfnChannelPlay} (r1,$3) .r0'
  Goto NSISBASS_EXIT

  NSISBASS_FAIL:
    StrCmp $1 "0" 0 +2
    System::Call /NOUNLOAD "${bfnMusicFree} (r1)"
    System::Call /NOUNLOAD "${bfnStop} () .r0"
    Push "failed"
  NSISBASS_EXIT:


; Restore registers
  Pop $4
  Pop $3
  Pop $2
  Pop $1
  Pop $0
!verbose pop
!macroend

!define NSISBASS_PlayMusic `!insertmacro NSISBASS_PLAYMUSIC`


; This is a simple one.
; It frees BASS.DLL
!macro NSISBASS_FREE
!verbose push
!verbose 3

  Push $0
  Push $1
  System::Call /NOUNLOAD "${bfnStop} () .r0"

  StrCpy $1 $BFNCHANHANDLE
  System::Call /NOUNLOAD "${bfnStreamFree} (r1)"
  System::Call /NOUNLOAD "${bfnMusicFree} (r1)"

  System::Call "${bfnFree} ()?u" ; Also unloads DLL
  Pop $1
  Pop $0
!verbose pop
!macroend

!define NSISBASS_Free `!insertmacro NSISBASS_FREE`

!verbose pop
!endif

