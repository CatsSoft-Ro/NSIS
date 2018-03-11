/*
_______________________________________________________________________________________________________

                Created and developed by Jason Ross aka JasonFriday13 on the forums
                      Code portions from abort to finish script by Afrow UK
                         Other code portions from Modern User Interface,
                           Copyright (c) 2002 - 2005 Joost Verburg
_______________________________________________________________________________________________________

var CURRENT_PAGE refers to the number of pages to skip to get to the finish page.
This value decreases as the installer pages advance (go forward), and the value increases as the
pages retreat (go backward).

var CANCELLED is a boolean value. This variable is self explanatory.

var LEAVE is to tell the installer if the leave custom function is called.
This boolean value tells the installer when the pages are going backards though the installer,
and this disables the minusing of the $CURRENT_PAGE variable. I have discovered that the leave
functions are not called when going backwards through the installer. I hope this does not
change in the near future as this is the only way to discriminate which way the pages are going.

*/
var CANCELLED
var CURRENT_PAGE
var LEAVE

  !define MUI_ABORTWARNING
  !define MUI_CUSTOMFUNCTION_ABORT "abortToFINISH"
  
  Function abortToFINISH
    !ifdef CUSTOMFUNCTION_ABORT
      Call "${CUSTOMFUNCTION_ABORT}"
    !endif
    StrCpy $CANCELLED true
    Call RelGotoPage
    Abort
  FunctionEnd
  
  Function preFINISH
    StrCmp $CANCELLED true 0 preFINISH_End ;The following line prevents the cancel button being enabled.
      !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Settings" "CancelEnabled" "0"
      !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field 4" "Type" ""   ;All of these are here
      !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field 4" "State" "0" ;to prevent any
      !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field 5" "Type" ""   ;'show readme' or
      !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field 5" "State" "0" ;'run program' or
      !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field 6" "Type" ""   ;'links' on the finish
      !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field 6" "State" "0" ;page when it aborts.
      !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field 2" "Text" "Cancelling the $(^Name) Setup Wizard"
      !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field 3" "Text" "The $(^Name) Setup Wizard has been cancelled.\r\n\r\nClick Finish to close this wizard."
    preFINISH_End:
  FunctionEnd

  Function RelGotoPage
    pop $CURRENT_PAGE
    IntCmp $CURRENT_PAGE 0 0 Move Move
      StrCmp $CURRENT_PAGE "X" 0 Move
        StrCpy $CURRENT_PAGE "120"

    Move:
    SendMessage $HWNDPARENT "0x408" "$CURRENT_PAGE" ""
  FunctionEnd

!macro FUNCTIONS

  Function PRECURRENT_PAGE
    StrCmp $LEAVE true +4 +1
    pop $CURRENT_PAGE
    IntOp $CURRENT_PAGE $CURRENT_PAGE + 1
    push $CURRENT_PAGE
    StrCpy $LEAVE false
    !ifdef PAGE_CUSTOMFUNCTION_PRE
      Call "${PAGE_CUSTOMFUNCTION_PRE}"
      !undef PAGE_CUSTOMFUNCTION_PRE
    !endif
  FunctionEnd
  
  Function SHOWCURRENT_PAGE

    !ifdef PAGE_CUSTOMFUNCTION_SHOW
      Call "${PAGE_CUSTOMFUNCTION_SHOW}"
      !undef PAGE_CUSTOMFUNCTION_SHOW
    !endif

  FunctionEnd
  
  Function LEAVECURRENT_PAGE
    pop $CURRENT_PAGE
    IntOp $CURRENT_PAGE $CURRENT_PAGE - 1
    push $CURRENT_PAGE
    StrCpy $LEAVE true
    !ifdef PAGE_CUSTOMFUNCTION_LEAVE
      Call "${PAGE_CUSTOMFUNCTION_LEAVE}"
      !undef PAGE_CUSTOMFUNCTION_LEAVE
    !endif
  FunctionEnd

  !define FUNCTIONS
!macroend

!macro INTERFACE_INIT
  !ifndef PAGETOTAL
    !error "PAGETOTAL not defined! Please define the total number of pages in the installer."
  !endif
  StrCpy $CANCELLED false
  StrCpy $CURRENT_PAGE ${PAGETOTAL}
  StrCpy $LEAVE true
!macroend

!macro PAGE_FUNCTION_CUSTOM

  Function "PRE"

    Call PRECURRENT_PAGE
    !ifdef PAGE_CUSTOMFUNCTION_PRE
      Call "${PAGE_CUSTOMFUNCTION_PRE}"
      !undef PAGE_CUSTOMFUNCTION_PRE
    !endif

  FunctionEnd

  Function "LEAVE"

    Call LEAVECURRENT_PAGE
    !ifdef PAGE_CUSTOMFUNCTION_LEAVE
      Call "${PAGE_CUSTOMFUNCTION_LEAVE}"
      !undef PAGE_CUSTOMFUNCTION_LEAVE
    !endif

  FunctionEnd

!macroend

!macro PAGE_CUSTOM
  page custom "PRE" "LEAVE"
  !insertmacro PAGE_FUNCTION_CUSTOM
!macroend

!macro PAGE_WELCOME
  !define MUI_PAGE_CUSTOMFUNCTION_PRE "PRECURRENT_PAGE"
  !define MUI_PAGE_CUSTOMFUNCTION_LEAVE "LEAVECURRENT_PAGE"
  !insertmacro MUI_PAGE_WELCOME
!macroend

!macro PAGE_LICENSE FILE
  !define MUI_PAGE_CUSTOMFUNCTION_PRE "PRECURRENT_PAGE"
  !define MUI_PAGE_CUSTOMFUNCTION_SHOW "SHOWCURRENT_PAGE"
  !define MUI_PAGE_CUSTOMFUNCTION_LEAVE "LEAVECURRENT_PAGE"
  !insertmacro MUI_PAGE_LICENSE "${FILE}"
!macroend

!macro PAGE_COMPONENTS
  !define MUI_PAGE_CUSTOMFUNCTION_PRE "PRECURRENT_PAGE"
  !define MUI_PAGE_CUSTOMFUNCTION_SHOW "SHOWCURRENT_PAGE"
  !define MUI_PAGE_CUSTOMFUNCTION_LEAVE "LEAVECURRENT_PAGE"
  !insertmacro MUI_PAGE_COMPONENTS
!macroend

!macro PAGE_DIRECTORY
  !define MUI_PAGE_CUSTOMFUNCTION_PRE "PRECURRENT_PAGE"
  !define MUI_PAGE_CUSTOMFUNCTION_SHOW "SHOWCURRENT_PAGE"
  !define MUI_PAGE_CUSTOMFUNCTION_LEAVE "LEAVECURRENT_PAGE"
  !insertmacro MUI_PAGE_DIRECTORY
!macroend

!macro PAGE_STARTMENU
  !define MUI_PAGE_CUSTOMFUNCTION_PRE "PRECURRENT_PAGE"
  !define MUI_PAGE_CUSTOMFUNCTION_LEAVE "LEAVECURRENT_PAGE"
  !insertmacro MUI_PAGE_STARTMENU
!macroend

!macro PAGE_INSTFILES
  !define MUI_PAGE_CUSTOMFUNCTION_PRE "PRECURRENT_PAGE"
  !define MUI_PAGE_CUSTOMFUNCTION_LEAVE "LEAVECURRENT_PAGE"
  !insertmacro MUI_PAGE_INSTFILES
!macroend

!macro PAGE_FINISH
  !insertmacro FUNCTIONS
  !define MUI_PAGE_CUSTOMFUNCTION_PRE "preFINISH"
  !insertmacro MUI_PAGE_FINISH
!macroend