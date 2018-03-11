!ifndef TOOLTIP_INCLUDED
!define TOOLTIP_INCLUDED

!include "WinMessages.nsh"
!include "logiclib.nsh"
!include "nsDialogs.nsh"

!define TOOLTIPS_CLASS "tooltips_class32"

!define TTF_IDISHWND       0x0001
!define TTF_CENTERTIP      0x0002
!define TTF_RTLREADING     0x0004
!define TTF_SUBCLASS       0x0010
!define TTF_TRACK          0x0020
!define TTF_ABSOLUTE       0x0080
!define TTF_TRANSPARENT    0x0100
!define TTF_PARSELINKS     0x1000
!define TTF_DI_SETITEM     0x8000

!define TTI_INFO_LARGE      4
!define TTI_WARNING_LARGE   5
!define TTI_ERROR_LARGE     6

!define TTM_NOICON          0
!define TTM_INFOICON        1
!define TTM_ALERTICON       2
!define TTM_ERRORICON       3
!define TTM_ACTIVATE        0x401 ;Включение или отключение всплывающих подсказок
!define TTM_SETDELAYTIME    0x403
!define TTM_ADDTOOL         0x404 ;Добавление инструмента
!define TTM_DELTOOL         0x405 ;Удаление инструмента из ToolTip
!define TTM_RELAYEVENT      0x407 ;Передает для обработки элементу управления ToolTip сообщение мыши
!define TTM_TRACKACTIVATE   0x411 ;Включение или выключение перемещающейся подсказки
!define TTM_TRACKPOSITION   0x412 ;Установка места вывода перемещающейся подсказки, в экранных координатах
!define TTM_SETTIPBKCOLOR   0x413 ;Установка цвета фона всплывающей подсказки
!define TTM_SETTIPTEXTCOLOR 0x414 ;Установка цвета текста всплывающей подсказки
!define TTM_SETMAXTIPWIDTH  0x418 ;Установка максимальной ширины выводимой подсказки (в пикселах)
!define TTM_SETTITLE        0x420 ;Добавление стандартной иконки и заголовка в всплывающую подсказку
!define TTM_ADJUSTRECT      0x41F ;Вычисляет прямоугольную область вывода текста ToolTip

/*
WM_LBUTTONDOWN
WM_LBUTTONUP
WM_MBUTTONDOWN
WM_MBUTTONUP
WM_MOUSEMOVE
WM_RBUTTONDOWN
WM_RBUTTONUP
*/
!define TTS_ALWAYSTIP      0x01
!define TTS_NOPREFIX       0x02
!define TTS_BALLOON        0x40
!define TTS_CLOSE          0x80
!define TTS_USEVISUALSTYLE 0x100

!define TTDT_AUTOMATIC     0
!define TTDT_RESHOW        1
!define TTDT_AUTOPOP       2
!define TTDT_INITIAL       3

!define CreateToolTip "!insertmacro __CreateToolTip"
!define AddToolTip    "!insertmacro __AddToolTip"
!define AddToolTipEx    "!insertmacro __AddToolTipEx"

!macro __CreateToolTip Style HWND
    System::Call "user32::CreateWindowEx(i0,t'${TOOLTIPS_CLASS}',\
    t,i${TTS_ALWAYSTIP}|${Style},i0,i0,i0,i0,i$HWNDPARENT,i0,i0,i0)i.s"
    Pop ${HWND}
    SendMessage ${HWND} ${TTM_SETMAXTIPWIDTH} 0 0xFFFFFF
!macroend

!macro __AddToolTip htip hwnd text
    !ifndef TOOLTIP_RECT
      !define TOOLTIP_RECT
      var /global TOOLTIP_RECT
      var /global TOOLTIP_TOOLINFO
    !endif
    System::Call "*(i,i,i,i)i.s"
    Pop $TOOLTIP_RECT
    System::Call "user32::GetClientRect(i${hwnd},i$TOOLTIP_RECT)"
    Push `${text}`
    System::Call "*$TOOLTIP_RECT(i.s,i.s,i.s,i.s)"
    System::Call "*(i48,i${TTF_SUBCLASS}|${TTF_PARSELINKS},\
                    i${hwnd},i,is,is,is,is,i,ts,i,i0)i.s"
    Pop $TOOLTIP_TOOLINFO
    SendMessage ${htip} ${TTM_ADDTOOL} 0 $TOOLTIP_TOOLINFO
    System::Free $TOOLTIP_RECT
    System::Free $TOOLTIP_TOOLINFO
!macroend

!macro __AddToolTipEx htip hwnd_ text
    !ifndef TOOLTIP_TOOLINFO_Ex
      !define TOOLTIP_TOOLINFO_Ex
      var /global TOOLTIP_TOOLINFO_Ex
    !endif
    Push `${text}`
    System::Call "*(i48,i${TTF_ABSOLUTE}|${TTF_IDISHWND}|${TTF_TRACK}|${TTF_PARSELINKS},\
                    i$hwndparent,i${hwnd_},i,i,i,i,i,ts,i,i0)i.s"
    Pop $TOOLTIP_TOOLINFO_Ex
    SendMessage ${htip} ${TTM_SETDELAYTIME} ${TTDT_AUTOMATIC} 1
    SendMessage ${htip} ${TTM_ADDTOOL} 0 $TOOLTIP_TOOLINFO_Ex
!macroend

!define MAKELONG32 "!insertmacro __MAKELONG32 "
!macro __MAKELONG32 _outvar _wlow _whiw
   Push `${_wlow}`
   Push `${_whiw}`
   System::Store SR0R1
   IntOp $R1 $R1 & 0xFFFF
   IntOp $R0 $R0 << 16
   System::Int64Op $R1 | $R0
   System::Store L
   Pop `${_outvar}`
!macroend

!define GetCursorDlgPos "!insertmacro Call_GetCursorDlgPos"
!macro Call_GetCursorDlgPos hwnd x y
   Push `${hwnd}`
   System::Store S
   System::Call "*(i,i)i.R0"
   System::Call "user32::GetCursorPos(iR0)"
   System::Call "user32::ScreenToClient(is,iR0)"
   System::Call "*$R0(i.s,i.s)"
   System::Free $R0
   System::Store L
   Pop `${x}`
   Pop `${y}`
!macroend

!define GetCursorPos "!insertmacro Call_GetCursorPos"
!macro Call_GetCursorPos x y
   System::Store S
   System::Call "*(i,i)i.R0"
   System::Call "user32::GetCursorPos(iR0)"
   System::Call "*$R0(i.s,i.s)"
   System::Free $R0
   System::Store L
   Pop `${x}`
   Pop `${y}`
!macroend

!endif