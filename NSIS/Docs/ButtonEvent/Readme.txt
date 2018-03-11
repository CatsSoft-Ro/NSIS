
 ==============================================================

 ButtonEvent NSIS plug-in v0.8

  Afrow Soft Ltd / Stuart 'Afrow UK' Welch
  4th May 2011

  An NSIS plug-in that allows NSIS coder to add a custom button
  and tie a NSIS function to it.

 --------------------------------------------------------------

 Place ButtonEvent.dll in your NSIS\Plugins folder or
 simply extract all files in the Zip to NSIS\

 See Examples\ButtonEvent\ButtonEventMUI.nsi for example of use.

 ==============================================================
 Adding The Button(s) To Your Dialog(s):

  The ButtonEvent plug-in does not add the command button(s)
  itself. This is so because across different OS' different
  languages and fonts are used and therefore the NSIS dialog
  will vary in size. This means that we cannot specify a
  fixed position for a new button at run time because
  it may overlap other controls on the dialog across
  different systems.

  You must add the command button with Resource Hacker.
  Download Resource Hacker from:
  http://www.angusj.com/resourcehacker/

  Make a copy of the default UI file you are using and copy
  it to your installer's folder.
  The UI files are under Contrib\UIs.
  MUI: modern.exe, Classic: default.exe

  You can use the new UI with:
  (MUI)
  !define MUI_UI ui_file
  (Classic)
  ChangeUI all ui_file

  When adding the button to the dialog of your choice, give it
  a control ID of 1200 or 1201 etc.
  The control ID is what you must specify when calling the
  ButtonEvent plug-in.

 ==============================================================
 The Functions:

  ButtonEvent::AddEventHandler control_id /NOTIFY|$FuncAddress

   Adds an event handler to a button with an ID if control_id
   and ties the $FuncAddress NSIS function to it or
   executes the page LEAVE function when using /NOTIFY.

   Use this instruction in the SHOW function of the page
   that contains your new button.

   $FuncAddress is obtained by using GetFunctionAddress:

     GetFunctionAddress $R0 MyFunction
     ButtonEvent::AddEventHandler 2000 $R0
     ...
     Function MyFunction
     ...

   The /NOTIFY flag is used like so:

     !include MUI.nsh
     !include LogicLib.nsh
     ...
     !define MUI_PAGE_CUSTOMFUNCTION_SHOW  PageShow
     !define MUI_PAGE_CUSTOMFUNCTION_LEAVE PageLeave
     !insertmacro MUI_PAGE_*
     ...
     Function PageShow
       ButtonEvent::AddEventHandler 2000 /NOTIFY
     FunctionEnd

     Function PageLeave

       ButtonEvent::WhichButtonId /NOUNLOAD
         Pop $R0

       ${If} $R0 == 2000
         ; Do stuff here.

         Abort
       ${EndIf}

     FunctionEnd

          -------------------------------------------

  ButtonEvent::WhichButtonId /NOUNLOAD
    Pop $Var

   Returns the control_id in $Var that triggered the page's
   leave function (/NOTIFY) or the function at $FuncAddress.

          -------------------------------------------

  ButtonEvent::UnsetEventHandler control_id
    Pop $Var

   The ButtonEvent plug-in is compiled to allow 8 event handlers
   per installer. Use this to remove the event handler from
   control_id allowing another event handler to take its place.

 ==============================================================
 Change Log:

  v0.8 - 4th May 2011
  * Fixed Debug build configuration failing.
  * Fixed crash if more than one button was used on the same NSIS page
    (inner dialog).

  v0.7 - 6th February 2011
  * Fixed Unicode build.
  * Added DLL version resource.

  v0.6 - 24th December 2010
  * Added Unicode build.
  * Integrated new NSIS plug-in API.
  * Removed Unload function (no longer required).
  * Rebuilt in VS2010.

  v0.5 - 1st August 2007
  * Added /NOTIFY switch which can be placed instead of
   $FuncAddress on AddEventHandler.
  * With /NOTIFY, sent & caught WM_NOTIFY_OUTER_NEXT messages.
  * WhichButtonId re-added to return the control ID of the
   button that triggered the leave function/$FuncAddress.
  * Added UnsetEventHandler to remove a control from the
   event controls list.
  * Added ButtonEventNotify.nsi example script.

  v0.4 - 1st July 2007
  * Fixed possible crash with plug-in unloading.
  * Buttons no longer send WM_NOTIFY_OUTER_NEXT to call the
   page leave function. ExecuteCodeSegment is now called
   to execute an NSIS function.
  * Added 8 button limit check.

  v0.3 - 26th August 2006
  * Fixed bug where WM_NOTIFY_OUTER_NEXT was being sent twice
   (for inner and outer dialogs).
  * Fixed bug where -1 was always the returned control ID.
  * Disabled parent window button in the example for the
   InstFiles page.

  v0.2 - 23rd April 2006
  * /PARENT no longer used. Plug-in detects if control is
   child of parent or inner dialog.
  * Fixed bug where the control ID returned from WhichButtonID
   was not cleared afterwards.
  * Using new my_atoi function.

  v0.1 - 29th March 2006
  * First build.