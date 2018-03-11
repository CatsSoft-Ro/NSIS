!ifndef COMMCTRL_INCLUDED
!define COMMCTRL_INCLUDED

!verbose push
!verbose 3

!include "Util.nsh"
!include "nsDialogs.nsh"

!verbose push
!verbose 3
!ifndef _COMMCTRL_VERBOSE
	!define _COMMCTRL_VERBOSE 3
!endif
!verbose ${_COMMCTRL_VERBOSE}
!define COMMCTRL_VERBOSE `!insertmacro COMMCTRL_VERBOSE`
!verbose pop

!macro COMMCTRL_VERBOSE _VERBOSE
	!verbose push
	!verbose 3
	!undef _COMMCTRL_VERBOSE
	!define _COMMCTRL_VERBOSE ${_VERBOSE}
	!verbose pop
!macroend

!ifdef DEFINE
  !verbose push
  !verbose ${_COMMCTRL_VERBOSE}
  !ifndef COMMCTRL_TEMP_DEFINE
  !define COMMCTRL_TEMP_DEFINE `${DEFINE}`
  !endif
  !undef DEFINE
  !verbose pop
!endif

!ifmacrondef COMMCTRL_USER_DEFINE
  !define COMMCTRL_USER_DEFINE COMMCTRL_USER_DEFINE
!else
  !define /date COMMCTRL_USER_DEFINE COMMCTRL_%Y.%m.%d_%X_USER_DEFINE
!endif

!macro ${COMMCTRL_USER_DEFINE} CONSTANT VALUE
  !verbose push
  !verbose ${_COMMCTRL_VERBOSE}
  !ifndef ${CONSTANT}
  !define ${CONSTANT} `${VALUE}`
  !endif
  !verbose pop
!macroend

!define DEFINE `!insertmacro ${COMMCTRL_USER_DEFINE}`

!macro COMMCTRL_ENCODING_AUTO_DEFINE CONSTANT
  !verbose push
  !verbose ${_COMMCTRL_VERBOSE}
  !ifdef UNICODE
    !define ${CONSTANT} `${${CONSTANT}W}`
  !else
    !define ${CONSTANT} `${${CONSTANT}A}`
  !endif
  !verbose pop
!macroend

!define ENCODING_AUTO_DEFINE `!insertmacro COMMCTRL_ENCODING_AUTO_DEFINE`

/* Window Classes */
${DEFINE} HOTKEY_CLASS          msctls_hotkey32
${DEFINE} PROGRESS_CLASS        msctls_progress32
${DEFINE} STATUSCLASSNAME       msctls_statusbar32
${DEFINE} TOOLBARCLASSNAME      ToolbarWindow32
${DEFINE} TOOLTIPS_CLASS        tooltips_class32
${DEFINE} TRACKBAR_CLASS        msctls_trackbar32
${DEFINE} UPDOWN_CLASS          msctls_updown32
${DEFINE} ANIMATE_CLASS         SysAnimate32
${DEFINE} DATETIMEPICK_CLASS    SysDateTimePick32
${DEFINE} MONTHCAL_CLASS        SysMonthCal32
${DEFINE} REBARCLASSNAME        ReBarWindow32
${DEFINE} WC_COMBOBOXEX         ComboBoxEx32
${DEFINE} WC_IPADDRESS          SysIPAddress32
${DEFINE} WC_LISTVIEW           SysListView32
${DEFINE} WC_TABCONTROL         SysTabControl32
${DEFINE} WC_TREEVIEW           SysTreeView32
${DEFINE} WC_HEADER             SysHeader32
${DEFINE} WC_PAGESCROLLER       SysPager
${DEFINE} WC_NATIVEFONTCTL      NativeFontCtl
${DEFINE} WC_BUTTON             Button
${DEFINE} WC_STATIC             Static
${DEFINE} WC_EDIT               Edit
${DEFINE} WC_LISTBOX            ListBox
${DEFINE} WC_COMBOBOX           ComboBox
${DEFINE} WC_SCROLLBAR          ScrollBar
${DEFINE} WC_LINK               SysLink

/* Window Styles */
${DEFINE} WS_CAPTION            0x00C00000

${DEFINE} WS_TABSTOP            0x00010000
${DEFINE} WS_GROUP              0x00020000
${DEFINE} WS_SIZEBOX            0x00040000
${DEFINE} WS_SYSMENU            0x00080000
${DEFINE} WS_HSCROLL            0x00100000
${DEFINE} WS_VSCROLL            0x00200000
${DEFINE} WS_DLGFRAME           0x00400000
${DEFINE} WS_BORDER             0x00800000
${DEFINE} WS_MAXIMIZE           0x01000000
${DEFINE} WS_CLIPCHILDREN       0x02000000
${DEFINE} WS_CLIPSIBLINGS       0x04000000
${DEFINE} WS_DISABLED           0x08000000
${DEFINE} WS_VISIBLE            0x10000000
${DEFINE} WS_ICONIC             0x20000000
${DEFINE} WS_CHILD              0x40000000
${DEFINE} WS_POPUP              0x80000000

/* Extended Window Styles */
${DEFINE} WS_EX_DLGMODALFRAME   0x00000001
${DEFINE} WS_EX_NOPARENTNOTIFY  0x00000004
${DEFINE} WS_EX_TOPMOST         0x00000008
${DEFINE} WS_EX_ACCEPTFILES     0x00000010
${DEFINE} WS_EX_TRANSPARENT     0x00000020
${DEFINE} WS_EX_MDICHILD        0x00000040
${DEFINE} WS_EX_TOOLWINDOW      0x00000080
${DEFINE} WS_EX_WINDOWEDGE      0x00000100
${DEFINE} WS_EX_CLIENTEDGE      0x00000200
${DEFINE} WS_EX_CONTEXTHELP     0x00000400
${DEFINE} WS_EX_RIGHT           0x00001000
${DEFINE} WS_EX_RTLREADING      0x00002000
${DEFINE} WS_EX_LEFTSCROLLBAR   0x00004000
${DEFINE} WS_EX_CONTROLPARENT   0x00010000
${DEFINE} WS_EX_STATICEDGE      0x00020000
${DEFINE} WS_EX_APPWINDOW       0x00040000
${DEFINE} WS_EX_LAYERED         0x00080000

${DEFINE} MAX_PATH              260 ;WinDef.nsh

/* Font Weights */
${DEFINE} FW_DONTCARE           0
${DEFINE} FW_THIN               100
${DEFINE} FW_EXTRALIGHT         200
${DEFINE} FW_ULTRALIGHT         200
${DEFINE} FW_LIGHT              300
${DEFINE} FW_NORMAL             400
${DEFINE} FW_REGULAR            400
${DEFINE} FW_MEDIUM             500
${DEFINE} FW_SEMIBOLD           600
${DEFINE} FW_DEMIBOLD           600
${DEFINE} FW_BOLD               700
${DEFINE} FW_EXTRABOLD          800
${DEFINE} FW_ULTRABOLD          800
${DEFINE} FW_HEAVY              900
${DEFINE} FW_BLACK              900


/* GetSystemMetrics() codes */
${DEFINE} SM_CXSCREEN                    0
${DEFINE} SM_CYSCREEN                    1
${DEFINE} SM_CXVSCROLL                   2
${DEFINE} SM_CYHSCROLL                   3
${DEFINE} SM_CYCAPTION                   4
${DEFINE} SM_CXBORDER                    5
${DEFINE} SM_CYBORDER                    6
${DEFINE} SM_CXDLGFRAME                  7
${DEFINE} SM_CXFIXEDFRAME                7
${DEFINE} SM_CYDLGFRAME                  8
${DEFINE} SM_CYFIXEDFRAME                8
${DEFINE} SM_CYVTHUMB                    9
${DEFINE} SM_CXHTHUMB                    10
${DEFINE} SM_CXICON                      11
${DEFINE} SM_CYICON                      12
${DEFINE} SM_CXCURSOR                    13
${DEFINE} SM_CYCURSOR                    14
${DEFINE} SM_CYMENU                      15
${DEFINE} SM_CXFULLSCREEN                16
${DEFINE} SM_CYFULLSCREEN                17
${DEFINE} SM_CYKANJIWINDOW               18
${DEFINE} SM_MOUSEPRESENT                19
${DEFINE} SM_CYVSCROLL                   20
${DEFINE} SM_CXHSCROLL                   21
${DEFINE} SM_DEBUG                       22
${DEFINE} SM_SWAPBUTTON                  23
${DEFINE} SM_CXMIN                       28
${DEFINE} SM_CYMIN                       29
${DEFINE} SM_CXSIZE                      30
${DEFINE} SM_CYSIZE                      31
${DEFINE} SM_CXFRAME                     32
${DEFINE} SM_CXSIZEFRAME                 32
${DEFINE} SM_CYFRAME                     33
${DEFINE} SM_CYSIZEFRAME                 33
${DEFINE} SM_CXMINTRACK                  34
${DEFINE} SM_CYMINTRACK                  35
${DEFINE} SM_CXDOUBLECLK                 36
${DEFINE} SM_CYDOUBLECLK                 37
${DEFINE} SM_CXICONSPACING               38
${DEFINE} SM_CYICONSPACING               39
${DEFINE} SM_MENUDROPALIGNMENT           40
${DEFINE} SM_PENWINDOWS                  41
${DEFINE} SM_DBCSENABLED                 42
${DEFINE} SM_CMOUSEBUTTONS               43
${DEFINE} SM_SECURE                      44
${DEFINE} SM_CXEDGE                      45
${DEFINE} SM_CYEDGE                      46
${DEFINE} SM_CXMINSPACING                47
${DEFINE} SM_CYMINSPACING                48
${DEFINE} SM_CXSMICON                    49
${DEFINE} SM_CYSMICON                    50
${DEFINE} SM_CYSMCAPTION                 51
${DEFINE} SM_CXSMSIZE                    52
${DEFINE} SM_CYSMSIZE                    53
${DEFINE} SM_CXMENUSIZE                  54
${DEFINE} SM_CYMENUSIZE                  55
${DEFINE} SM_ARRANGE                     56
${DEFINE} SM_CXMINIMIZED                 57
${DEFINE} SM_CYMINIMIZED                 58
${DEFINE} SM_CXMAXTRACK                  59
${DEFINE} SM_CYMAXTRACK                  60
${DEFINE} SM_CXMAXIMIZED                 61
${DEFINE} SM_CYMAXIMIZED                 62
${DEFINE} SM_NETWORK                     63
${DEFINE} SM_CLEANBOOT                   67
${DEFINE} SM_CXDRAG                      68
${DEFINE} SM_CYDRAG                      69
${DEFINE} SM_SHOWSOUNDS                  70
${DEFINE} SM_CXMENUCHECK                 71
${DEFINE} SM_CYMENUCHECK                 72
${DEFINE} SM_SLOWMACHINE                 73
${DEFINE} SM_MIDEASTENABLED              74
${DEFINE} SM_MOUSEWHEELPRESENT           75
${DEFINE} SM_XVIRTUALSCREEN              76
${DEFINE} SM_YVIRTUALSCREEN              77
${DEFINE} SM_CXVIRTUALSCREEN             78
${DEFINE} SM_CYVIRTUALSCREEN             79
${DEFINE} SM_CMONITORS                   80
${DEFINE} SM_SAMEDISPLAYFORMAT           81
${DEFINE} SM_IMMENABLED                  82
${DEFINE} SM_CXFOCUSBORDER               83
${DEFINE} SM_CYFOCUSBORDER               84
${DEFINE} SM_TABLETPC                    86
${DEFINE} SM_MEDIACENTER                 87
${DEFINE} SM_STARTER                     88
${DEFINE} SM_SERVERR2                    89
${DEFINE} SM_MOUSEHORIZONTALWHEELPRESENT 91
${DEFINE} SM_CXPADDEDBORDER              92
${DEFINE} SM_DIGITIZER                   94
${DEFINE} SM_MAXIMUMTOUCHES              95
${DEFINE} SM_REMOTESESSION               0x1000
${DEFINE} SM_SHUTTINGDOWN                0x2000
${DEFINE} SM_REMOTECONTROL               0x2001

/* Drives Types (defined in WinCore.nsh) */
${DEFINE} DRIVE_UNKNOWN           0
${DEFINE} DRIVE_NO_ROOT_DIR       1
${DEFINE} DRIVE_REMOVABLE         2
${DEFINE} DRIVE_FIXED             3
${DEFINE} DRIVE_REMOTE            4
${DEFINE} DRIVE_CDROM             5
${DEFINE} DRIVE_RAMDISK           6

/* Edit Control Notification Codes */
${DEFINE} EN_SETFOCUS             0x0100
${DEFINE} EN_KILLFOCUS            0x0200
${DEFINE} EN_CHANGE               0x0300
${DEFINE} EN_UPDATE               0x0400
${DEFINE} EN_ERRSPACE             0x0500
${DEFINE} EN_MAXTEXT              0x0501
${DEFINE} EN_HSCROLL              0x0601
${DEFINE} EN_VSCROLL              0x0602

#if(_WIN32_WINNT >= 0x0500)
${DEFINE} EN_ALIGN_LTR_EC         0x0700
${DEFINE} EN_ALIGN_RTL_EC         0x0701
#endif /* _WIN32_WINNT >= 0x0500 */

/* User Button Notification Codes */
${DEFINE} BN_CLICKED              0
${DEFINE} BN_PAINT                1
${DEFINE} BN_HILITE               2
${DEFINE} BN_UNHILITE             3
${DEFINE} BN_DISABLE              4
${DEFINE} BN_DOUBLECLICKED        5
#if(WINVER >= 0x0400)
${DEFINE} BN_PUSHED               ${BN_HILITE}
${DEFINE} BN_UNPUSHED             ${BN_UNHILITE}
${DEFINE} BN_DBLCLK               ${BN_DOUBLECLICKED}
${DEFINE} BN_SETFOCUS             6
${DEFINE} BN_KILLFOCUS            7
#endif /* WINVER >= 0x0400 */

/* Listview Styles */
${DEFINE} LVS_ICON                0x00000000
${DEFINE} LVS_REPORT              0x00000001
${DEFINE} LVS_SMALLICON           0x00000002
${DEFINE} LVS_LIST                0x00000003
${DEFINE} LVS_SINGLESEL           0x00000004
${DEFINE} LVS_SHOWSELALWAYS       0x00000008
${DEFINE} LVS_SORTASCENDING       0x00000010
${DEFINE} LVS_SORTDESCENDING      0x00000020
${DEFINE} LVS_SHAREIMAGELISTS     0x00000040
${DEFINE} LVS_NOLABELWRAP         0x00000080
${DEFINE} LVS_ALIGNTOP            0x00000000
${DEFINE} LVS_AUTOARRANGE         0x00000100
${DEFINE} LVS_EDITLABELS          0x00000200
${DEFINE} LVS_OWNERDRAWFIXED      0x00000400
${DEFINE} LVS_ALIGNLEFT           0x00000800
${DEFINE} LVS_OWNERDATA           0x00001000
${DEFINE} LVS_NOSCROLL            0x00002000
${DEFINE} LVS_NOCOLUMNHEADER      0x00004000
${DEFINE} LVS_NOSORTHEADER        0x00008000

/* Extended Listview Styles */
${DEFINE} LVS_EX_GRIDLINES        0x00000001
${DEFINE} LVS_EX_SUBITEMIMAGES    0x00000002
${DEFINE} LVS_EX_CHECKBOXES       0x00000004
${DEFINE} LVS_EX_TRACKSELECT      0x00000008
${DEFINE} LVS_EX_HEADERDRAGDROP   0x00000010
${DEFINE} LVS_EX_FULLROWSELECT    0x00000020
${DEFINE} LVS_EX_ONECLICKACTIVATE 0x00000040
${DEFINE} LVS_EX_TWOCLICKACTIVATE 0x00000080
${DEFINE} LVS_EX_FLATSB           0x00000100
${DEFINE} LVS_EX_REGIONAL         0x00000200
${DEFINE} LVS_EX_INFOTIP          0x00000400
${DEFINE} LVS_EX_UNDERLINEHOT     0x00000800
${DEFINE} LVS_EX_UNDERLINECOLD    0x00001000
${DEFINE} LVS_EX_MULTIWORKAREAS   0x00002000
${DEFINE} LVS_EX_LABELTIP         0x00004000
${DEFINE} LVS_EX_BORDERSELECT     0x00008000
${DEFINE} LVS_EX_DOUBLEBUFFER     0x00010000

/* Listview Messages */
${DEFINE} LVM_FIRST                     0x1000
${DEFINE} LVM_GETBKCOLOR                0x1000
${DEFINE} LVM_SETBKCOLOR                0x1001
${DEFINE} LVM_GETIMAGELIST              0x1002
${DEFINE} LVM_SETIMAGELIST              0x1003
${DEFINE} LVM_GETITEMCOUNT              0x1004
${DEFINE} LVM_GETITEM                   0x1005
${DEFINE} LVM_SETITEM                   0x1006
${DEFINE} LVM_INSERTITEM                0x1007
${DEFINE} LVM_DELETEITEM                0x1008
${DEFINE} LVM_DELETEALLITEMS            0x1009
${DEFINE} LVM_GETCALLBACKMASK           0x100A
${DEFINE} LVM_SETCALLBACKMASK           0x100B
${DEFINE} LVM_GETNEXTITEM               0x100C
${DEFINE} LVM_FINDITEM                  0x100D
${DEFINE} LVM_GETITEMRECT               0x100E
${DEFINE} LVM_SETITEMPOSITION           0x100F
${DEFINE} LVM_GETITEMPOSITION           0x1010
${DEFINE} LVM_GETSTRINGWIDTH            0x1011
${DEFINE} LVM_HITTEST                   0x1012
${DEFINE} LVM_ENSUREVISIBLE             0x1013
${DEFINE} LVM_SCROLL                    0x1014
${DEFINE} LVM_REDRAWITEMS               0x1015
${DEFINE} LVM_ARRANGE                   0x1016
${DEFINE} LVM_EDITLABEL                 0x1017
${DEFINE} LVM_GETEDITCONTROL            0x1018
${DEFINE} LVM_GETCOLUMN                 0x1019
${DEFINE} LVM_SETCOLUMN                 0x101A
${DEFINE} LVM_INSERTCOLUMN              0x101B
${DEFINE} LVM_DELETECOLUMN              0x101C
${DEFINE} LVM_GETCOLUMNWIDTH            0x101D
${DEFINE} LVM_SETCOLUMNWIDTH            0x101E
${DEFINE} LVM_GETHEADER                 0x101F
${DEFINE} LVM_CREATEDRAGIMAGE           0x1021
${DEFINE} LVM_GETVIEWRECT               0x1022
${DEFINE} LVM_GETTEXTCOLOR              0x1023
${DEFINE} LVM_SETTEXTCOLOR              0x1024
${DEFINE} LVM_GETTEXTBKCOLOR            0x1025
${DEFINE} LVM_SETTEXTBKCOLOR            0x1026
${DEFINE} LVM_GETTOPINDEX               0x1027
${DEFINE} LVM_GETCOUNTPERPAGE           0x1028
${DEFINE} LVM_GETORIGIN                 0x1029
${DEFINE} LVM_UPDATE                    0x102A
${DEFINE} LVM_SETITEMSTATE              0x102B
${DEFINE} LVM_GETITEMSTATE              0x102C
${DEFINE} LVM_GETITEMTEXT               0x102D
${DEFINE} LVM_SETITEMTEXT               0x102E
${DEFINE} LVM_SETITEMCOUNT              0x102F
${DEFINE} LVM_SORTITEMS                 0x1030
${DEFINE} LVM_SETITEMPOSITION32         0x1031
${DEFINE} LVM_GETSELECTEDCOUNT          0x1032
${DEFINE} LVM_GETITEMSPACING            0x1033
${DEFINE} LVM_GETISEARCHSTRING          0x1034
${DEFINE} LVM_SETICONSPACING            0x1035
${DEFINE} LVM_SETEXTENDEDLISTVIEWSTYLE  0x1036
${DEFINE} LVM_GETEXTENDEDLISTVIEWSTYLE  0x1037
${DEFINE} LVM_GETSUBITEMRECT            0x1038
${DEFINE} LVM_SUBITEMHITTEST            0x1039
${DEFINE} LVM_SETCOLUMNORDERARRAY       0x103A
${DEFINE} LVM_GETCOLUMNORDERARRAY       0x103B
${DEFINE} LVM_SETHOTITEM                0x103C
${DEFINE} LVM_GETHOTITEM                0x103D
${DEFINE} LVM_SETHOTCURSOR              0x103E
${DEFINE} LVM_GETHOTCURSOR              0x103F
${DEFINE} LVM_APPROXIMATEVIEWRECT       0x1040
${DEFINE} LVM_SETWORKAREAS              0x1041
${DEFINE} LVM_GETSELECTIONMARK          0x1042
${DEFINE} LVM_SETSELECTIONMARK          0x1043
${DEFINE} LVM_SETBKIMAGE                0x1044
${DEFINE} LVM_GETBKIMAGE                0x1045
${DEFINE} LVM_GETWORKAREAS              0x1046
${DEFINE} LVM_SETHOVERTIME              0x1047
${DEFINE} LVM_GETHOVERTIME              0x1048
${DEFINE} LVM_GETNUMBEROFWORKAREAS      0x1049
${DEFINE} LVM_SETTOOLTIPS               0x104A
${DEFINE} LVM_GETTOOLTIPS               0x104E

${DEFINE} LVM_SORTITEMSEX               0x1051
${DEFINE} LVM_GETGROUPSTATE             0x105C
${DEFINE} LVM_GETFOCUSEDGROUP           0x105D
${DEFINE} LVM_GETGROUPRECT              0x1062
${DEFINE} LVM_SETSELECTEDCOLUMN         0x108C
${DEFINE} LVM_SETVIEW                   0x108E
${DEFINE} LVM_GETVIEW                   0x108F
${DEFINE} LVM_INSERTGROUP               0x1091
${DEFINE} LVM_SETGROUPINFO              0x1093
${DEFINE} LVM_GETGROUPINFO              0x1095
${DEFINE} LVM_REMOVEGROUP               0x1096
${DEFINE} LVM_MOVEGROUP                 0x1097
${DEFINE} LVM_GETGROUPCOUNT             0x1098
${DEFINE} LVM_GETGROUPINFOBYINDEX       0x1099
${DEFINE} LVM_MOVEITEMTOGROUP           0x109A
${DEFINE} LVM_SETGROUPMETRICS           0x109B
${DEFINE} LVM_GETGROUPMETRICS           0x109C
${DEFINE} LVM_ENABLEGROUPVIEW           0x109D
${DEFINE} LVM_SORTGROUPS                0x109E
${DEFINE} LVM_INSERTGROUPSORTED         0x109F
${DEFINE} LVM_REMOVEALLGROUPS           0x10A0
${DEFINE} LVM_HASGROUP                  0x10A1
${DEFINE} LVM_SETTILEVIEWINFO           0x10A2
${DEFINE} LVM_GETTILEVIEWINFO           0x10A3
${DEFINE} LVM_SETTILEINFO               0x10A4
${DEFINE} LVM_GETTILEINFO               0x10A5
${DEFINE} LVM_SETINSERTMARK             0x10A6
${DEFINE} LVM_GETINSERTMARK             0x10A7
${DEFINE} LVM_INSERTMARKHITTEST         0x10A8
${DEFINE} LVM_GETINSERTMARKRECT         0x10A9
${DEFINE} LVM_SETINSERTMARKCOLOR        0x10AA
${DEFINE} LVM_GETINSERTMARKCOLOR        0x10AB
${DEFINE} LVM_SETINFOTIP                0x10AD
${DEFINE} LVM_GETSELECTEDCOLUMN         0x10AE
${DEFINE} LVM_ISGROUPVIEWENABLED        0x10AF
${DEFINE} LVM_GETOUTLINECOLOR           0x10B0
${DEFINE} LVM_SETOUTLINECOLOR           0x10B1
${DEFINE} LVM_CANCELEDITLABEL           0x10B3
${DEFINE} LVM_MAPINDEXTOID              0x10B4
${DEFINE} LVM_MAPIDTOINDEX              0x10B5
${DEFINE} LVM_ISITEMVISIBLE             0x10B6
${DEFINE} LVM_GETEMPTYTEXT              0x10CC
${DEFINE} LVM_GETFOOTERRECT             0x10CD
${DEFINE} LVM_GETFOOTERINFO             0x10CE
${DEFINE} LVM_GETFOOTERITEMRECT         0x10CF
${DEFINE} LVM_GETFOOTERITEM             0x10D0
${DEFINE} LVM_GETITEMINDEXRECT          0x10D1
${DEFINE} LVM_SETITEMINDEXSTATE         0x10D2
${DEFINE} LVM_GETNEXTITEMINDEX          0x10D3

/* Listview Notifications */
${DEFINE} LVN_FIRST                     -100
${DEFINE} LVN_LAST                      -199

${DEFINE} LVN_ITEMCHANGING              -100
${DEFINE} LVN_ITEMCHANGED               -101
${DEFINE} LVN_INSERTITEM                -102
${DEFINE} LVN_DELETEITEM                -103
${DEFINE} LVN_DELETEALLITEMS            -104
${DEFINE} LVN_BEGINLABELEDITA           -105
${DEFINE} LVN_BEGINLABELEDITW           -175
${ENCODING_AUTO_DEFINE} LVN_BEGINLABELEDIT
${DEFINE} LVN_ENDLABELEDITA             -106
${DEFINE} LVN_ENDLABELEDITW             -176
${ENCODING_AUTO_DEFINE} LVN_ENDLABELEDIT
${DEFINE} LVN_COLUMNCLICK               -108
${DEFINE} LVN_BEGINDRAG                 -109
${DEFINE} LVN_BEGINRDRAG                -111

#if (_WIN32_IE >= 0x0300)
${DEFINE} LVN_ODCACHEHINT               -113
${DEFINE} LVN_ODFINDITEMA               -152
${DEFINE} LVN_ODFINDITEMW               -179
${ENCODING_AUTO_DEFINE} LVN_ODFINDITEM
${DEFINE} LVN_ITEMACTIVATE              -114
${DEFINE} LVN_ODSTATECHANGED            -115
#endif      // _WIN32_IE >= 0x0300

#if (_WIN32_IE >= 0x0400)
${DEFINE} LVN_HOTTRACK                  -121
#endif

${DEFINE} LVN_GETDISPINFOA              -150
${DEFINE} LVN_GETDISPINFOW              -177
${ENCODING_AUTO_DEFINE} LVN_GETDISPINFO
${DEFINE} LVN_SETDISPINFOA              -151
${DEFINE} LVN_SETDISPINFOW              -178
${ENCODING_AUTO_DEFINE} LVN_SETDISPINFO
${DEFINE} LVN_KEYDOWN                   -155
${DEFINE} LVN_MARQUEEBEGIN              -156
${DEFINE} LVN_GETINFOTIPA               -157
${DEFINE} LVN_GETINFOTIPW               -158
${ENCODING_AUTO_DEFINE} LVN_GETINFOTIP
${DEFINE} LVN_INCREMENTALSEARCHA        -162
${DEFINE} LVN_INCREMENTALSEARCHW        -163
${ENCODING_AUTO_DEFINE} LVN_INCREMENTALSEARCH
${DEFINE} LVN_COLUMNDROPDOWN            -164
${DEFINE} LVN_COLUMNOVERFLOWCLICK       -166
${DEFINE} LVN_BEGINSCROLL               -180
${DEFINE} LVN_ENDSCROLL                 -181
${DEFINE} LVN_LINKCLICK                 -184
${DEFINE} LVN_GETEMPTYMARKUP            -187

/* Listview Alignment */
${DEFINE} LVA_DEFAULT                   0x0000
${DEFINE} LVA_ALIGNLEFT                 0x0001
${DEFINE} LVA_ALIGNTOP                  0x0002
${DEFINE} LVA_SNAPTOGRID                0x0005

/* Listview Control View */
${DEFINE} LV_VIEW_ICON                  0x0000
${DEFINE} LV_VIEW_DETAILS               0x0001
${DEFINE} LV_VIEW_SMALLICON             0x0002
${DEFINE} LV_VIEW_LIST                  0x0003
${DEFINE} LV_VIEW_TILE                  0x0004

/* Listview Item States */
${DEFINE} LVIS_FOCUSED                  0x0001
${DEFINE} LVIS_SELECTED                 0x0002
${DEFINE} LVIS_CUT                      0x0004
${DEFINE} LVIS_DROPHILITED              0x0008
${DEFINE} LVIS_GLOW                     0x0010
${DEFINE} LVIS_ACTIVATING               0x0020
${DEFINE} LVIS_OVERLAYMASK              0x0F00
${DEFINE} LVIS_STATEIMAGEMASK           0xF000
${DEFINE} LVIS_UNCHECKED                0x1000
${DEFINE} LVIS_CHECKED                  0x2000

/* Types of Listview State Image List */
${DEFINE} LVSIL_NORMAL                  0
${DEFINE} LVSIL_SMALL                   1
${DEFINE} LVSIL_STATE                   2
${DEFINE} LVSIL_HEADER                  3

/* Listview Column Flags */
${DEFINE} LVCF_FMT                      0x0001
${DEFINE} LVCF_WIDTH                    0x0002
${DEFINE} LVCF_TEXT                     0x0004
${DEFINE} LVCF_SUBITEM                  0x0008
${DEFINE} LVCF_IMAGE                    0x0010
${DEFINE} LVCF_ORDER                    0x0020

/* Listview Column Formats */
${DEFINE} LVCFMT_LEFT                   0x0000
${DEFINE} LVCFMT_RIGHT                  0x0001
${DEFINE} LVCFMT_CENTER                 0x0002
${DEFINE} LVCFMT_JUSTIFYMASK            0x0003
${DEFINE} LVCFMT_IMAGE                  0x0800
${DEFINE} LVCFMT_BITMAP_ON_RIGHT        0x1000
${DEFINE} LVCFMT_COL_HAS_IMAGES         0x8000

/* Listview LVFINDINFO Structure Flags */
${DEFINE} LVFI_PARAM                    0x0001
${DEFINE} LVFI_STRING                   0x0002
${DEFINE} LVFI_SUBSTRING                0x0004      # Vista or later
${DEFINE} LVFI_PARTIAL                  0x0008
${DEFINE} LVFI_WRAP                     0x0020
${DEFINE} LVFI_NEARESTXY                0x0040

/* Listview Item Flags */
${DEFINE} LVIF_TEXT                     0x0001
${DEFINE} LVIF_IMAGE                    0x0002
${DEFINE} LVIF_PARAM                    0x0004
${DEFINE} LVIF_STATE                    0x0008
${DEFINE} LVIF_INDENT                   0x0010
${DEFINE} LVIF_GROUPID                  0x0100
${DEFINE} LVIF_COLUMNS                  0x0200
${DEFINE} LVIF_NORECOMPUTE              0x0800

/* Treeview Styles */
${DEFINE} TVS_HASBUTTONS                0x0001
${DEFINE} TVS_HASLINES                  0x0002
${DEFINE} TVS_LINESATROOT               0x0004
${DEFINE} TVS_EDITLABELS                0x0008
${DEFINE} TVS_DISABLEDRAGDROP           0x0010
${DEFINE} TVS_SHOWSELALWAYS             0x0020
${DEFINE} TVS_RTLREADING                0x0040
${DEFINE} TVS_NOTOOLTIPS                0x0080
${DEFINE} TVS_CHECKBOXES                0x0100
${DEFINE} TVS_TRACKSELECT               0x0200
${DEFINE} TVS_SINGLEEXPAND              0x0400
${DEFINE} TVS_INFOTIP                   0x0800
${DEFINE} TVS_FULLROWSELECT             0x1000
${DEFINE} TVS_NOSCROLL                  0x2000
${DEFINE} TVS_NONEVENHEIGHT             0x4000
${DEFINE} TVS_NOHSCROLL                 0x8000  ; TVS_NOSCROLL overrides this

/* Treeview Messages */
${DEFINE} TVM_INSERTITEM                0x1100
${DEFINE} TVM_DELETEITEM                0x1101
${DEFINE} TVM_EXPAND                    0x1102
${DEFINE} TVM_GETITEMRECT               0x1104
${DEFINE} TVM_GETCOUNT                  0x1105
${DEFINE} TVM_GETINDENT                 0x1106
${DEFINE} TVM_SETINDENT                 0x1107
${DEFINE} TVM_GETIMAGELIST              0x1108
${DEFINE} TVM_SETIMAGELIST              0x1109
${DEFINE} TVM_GETNEXTITEM               0x110A
${DEFINE} TVM_SELECTITEM                0x110B
${DEFINE} TVM_GETITEM                   0x110C
${DEFINE} TVM_SETITEM                   0x110D
${DEFINE} TVM_EDITLABEL                 0x110E
${DEFINE} TVM_GETEDITCONTROL            0x110F
${DEFINE} TVM_GETVISIBLECOUNT           0x1110
${DEFINE} TVM_HITTEST                   0x1111
${DEFINE} TVM_CREATEDRAGIMAGE           0x1112
${DEFINE} TVM_SORTCHILDREN              0x1113
${DEFINE} TVM_ENSUREVISIBLE             0x1114
${DEFINE} TVM_SORTCHILDRENCB            0x1115
${DEFINE} TVM_ENDEDITLABELNOW           0x1116
${DEFINE} TVM_GETISEARCHSTRING          0x1117
${DEFINE} TVM_SETTOOLTIPS               0x1118
${DEFINE} TVM_GETTOOLTIPS               0x1119
${DEFINE} TVM_SETINSERTMARK             0x111A
${DEFINE} TVM_SETUNICODEFORMAT          0x2005
${DEFINE} TVM_GETUNICODEFORMAT          0x2006
${DEFINE} TVM_SETITEMHEIGHT             0x111B
${DEFINE} TVM_GETITEMHEIGHT             0x111C
${DEFINE} TVM_SETBKCOLOR                0x111D
${DEFINE} TVM_SETTEXTCOLOR              0x111E
${DEFINE} TVM_GETBKCOLOR                0x111F
${DEFINE} TVM_GETTEXTCOLOR              0x1120
${DEFINE} TVM_SETSCROLLTIME             0x1121
${DEFINE} TVM_GETSCROLLTIME             0x1122
${DEFINE} TVM_SETINSERTMARKCOLOR        0x1125
${DEFINE} TVM_GETINSERTMARKCOLOR        0x1126
${DEFINE} TVM_GETITEMSTATE              0x1127
${DEFINE} TVM_SETLINECOLOR              0x1128
${DEFINE} TVM_GETLINECOLOR              0x1129
${DEFINE} TVM_MAPACCIDTOHTREEITEM       0x112A
${DEFINE} TVM_MAPHTREEITEMTOACCID       0x112B

/* Treeview Item Actions */
${DEFINE} TVE_COLLAPSE                  0x0001
${DEFINE} TVE_EXPAND                    0x0002
${DEFINE} TVE_TOGGLE                    0x0003
${DEFINE} TVE_EXPANDPARTIAL             0x4000
${DEFINE} TVE_COLLAPSERESET             0x8000

/* Types of inserting item of Treeview (TVINSERTSTRUCT) */
${DEFINE} TVI_ROOT                      0xFFFF0000
${DEFINE} TVI_FIRST                     0xFFFF0001
${DEFINE} TVI_LAST                      0xFFFF0002
${DEFINE} TVI_SORT                      0xFFFF0003

/* Types of Treeview State Image List */
${DEFINE} TVSIL_NORMAL                  0
${DEFINE} TVSIL_STATE                   2

/* Treeview Item Flags */
${DEFINE} TVIF_TEXT                     0x0001
${DEFINE} TVIF_IMAGE                    0x0002
${DEFINE} TVIF_PARAM                    0x0004
${DEFINE} TVIF_STATE                    0x0008
${DEFINE} TVIF_HANDLE                   0x0010
${DEFINE} TVIF_SELECTEDIMAGE            0x0020
${DEFINE} TVIF_CHILDREN                 0x0040
${DEFINE} TVIF_INTEGRAL                 0x0080

/* Treeview Item States */
${DEFINE} TVIS_SELECTED                 0x0002
${DEFINE} TVIS_CUT                      0x0004
${DEFINE} TVIS_DROPHILITED              0x0008
${DEFINE} TVIS_BOLD                     0x0010
${DEFINE} TVIS_EXPANDED                 0x0020
${DEFINE} TVIS_EXPANDEDONCE             0x0040
${DEFINE} TVIS_EXPANDPARTIAL            0x0080
${DEFINE} TVIS_OVERLAYMASK              0x0F00
${DEFINE} TVIS_UNCHECKED                0x1000
${DEFINE} TVIS_CHECKED                  0x2000
${DEFINE} TVIS_STATEIMAGEMASK           0xF000
${DEFINE} TVIS_USERMASK                 0xF000


${DEFINE} TVGN_ROOT                     0x0000
${DEFINE} TVGN_NEXT                     0x0001
${DEFINE} TVGN_PREVIOUS                 0x0002
${DEFINE} TVGN_PARENT                   0x0003
${DEFINE} TVGN_CHILD                    0x0004
${DEFINE} TVGN_FIRSTVISIBLE             0x0005
${DEFINE} TVGN_NEXTVISIBLE              0x0006
${DEFINE} TVGN_PREVIOUSVISIBLE          0x0007
${DEFINE} TVGN_DROPHILITE               0x0008
${DEFINE} TVGN_CARET                    0x0009
#if (_WIN32_IE >= 0x0400)
${DEFINE} TVGN_LASTVISIBLE              0x000A
#endif      // _WIN32_IE >= 0x0400


/* Extended ComboBoxEx styles */
${DEFINE} CBES_EX_NOEDITIMAGE           0x00000001
${DEFINE} CBES_EX_NOEDITIMAGEINDENT     0x00000002
${DEFINE} CBES_EX_PATHWORDBREAKPROC     0x00000004
${DEFINE} CBES_EX_NOSIZELIMIT           0x00000008
${DEFINE} CBES_EX_CASESENSITIVE         0x00000010

/* ComboBoxEx messages */
${DEFINE} CBEM_INSERTITEM               0x0401
${DEFINE} CBEM_SETIMAGELIST             0x0402
${DEFINE} CBEM_GETIMAGELIST             0x0403
${DEFINE} CBEM_GETITEM                  0x0404
${DEFINE} CBEM_SETITEM                  0x0405
${DEFINE} CBEM_DELETEITEM               ${CB_DELETESTRING}
${DEFINE} CBEM_GETCOMBOCONTROL          0x0406
${DEFINE} CBEM_GETEDITCONTROL           0x0407
${DEFINE} CBEM_GETEXTENDEDSTYLE         0x0409
${DEFINE} CBEM_HASEDITCHANGED           0x040A
${DEFINE} CBEM_SETEXTENDEDSTYLE         0x040E

/* ComboBoxEx Item Flags */
${DEFINE} CBEIF_TEXT                    0x00000001
${DEFINE} CBEIF_IMAGE                   0x00000002
${DEFINE} CBEIF_SELECTEDIMAGE           0x00000004
${DEFINE} CBEIF_OVERLAY                 0x00000008
${DEFINE} CBEIF_INDENT                  0x00000010
${DEFINE} CBEIF_LPARAM                  0x00000020
${DEFINE} CBEIF_DI_SETITEM              0x10000000

/* LoadImage function flags: LR_*... */
; All are defined in nsDialogs.nsh

/* Image List Creation Flags */
${DEFINE} ILC_COLOR                     0x00000000
${DEFINE} ILC_MASK                      0x00000001
${DEFINE} ILC_COLOR4                    0x00000004
${DEFINE} ILC_COLOR8                    0x00000008
${DEFINE} ILC_COLOR16                   0x00000010
${DEFINE} ILC_COLOR24                   0x00000018
${DEFINE} ILC_COLOR32                   0x00000020
${DEFINE} ILC_COLORDDB                  0x000000FE

${DEFINE} ILC_PALETTE                   0x00000800 ; Not implemented.
${DEFINE} ILC_MIRROR                    0x00002000
${DEFINE} ILC_PERITEMMIRROR             0x00008000
${DEFINE} ILC_ORIGINALSIZE              0x00010000 ; Vista, Reserved.
${DEFINE} ILC_HIGHQUALITYSCALE          0x00020000 ; Vista, Reserved.

/* Image types: IMAGE_BITMAP, IMAGE_ICON... */
; All types are defined in nsDialogs.nsh

${DEFINE} CLR_NONE                      0xFFFFFFFF
${DEFINE} CLR_DEFAULT                   0xFF000000

/* OEM resources: bitmaps, cursors and icons */
${DEFINE} OBM_CLOSE                     32754
${DEFINE} OBM_UPARROW                   32753
${DEFINE} OBM_DNARROW                   32752
${DEFINE} OBM_RGARROW                   32751
${DEFINE} OBM_LFARROW                   32750
${DEFINE} OBM_REDUCE                    32749
${DEFINE} OBM_ZOOM                      32748
${DEFINE} OBM_RESTORE                   32747
${DEFINE} OBM_REDUCED                   32746
${DEFINE} OBM_ZOOMD                     32745
${DEFINE} OBM_RESTORED                  32744
${DEFINE} OBM_UPARROWD                  32743
${DEFINE} OBM_DNARROWD                  32742
${DEFINE} OBM_RGARROWD                  32741
${DEFINE} OBM_LFARROWD                  32740
${DEFINE} OBM_MNARROW                   32739
${DEFINE} OBM_COMBO                     32738
${DEFINE} OBM_UPARROWI                  32737
${DEFINE} OBM_DNARROWI                  32736
${DEFINE} OBM_RGARROWI                  32735
${DEFINE} OBM_LFARROWI                  32734

${DEFINE} OBM_OLD_CLOSE                 32767
${DEFINE} OBM_SIZE                      32766
${DEFINE} OBM_OLD_UPARROW               32765
${DEFINE} OBM_OLD_DNARROW               32764
${DEFINE} OBM_OLD_RGARROW               32763
${DEFINE} OBM_OLD_LFARROW               32762
${DEFINE} OBM_BTSIZE                    32761
${DEFINE} OBM_CHECK                     32760
${DEFINE} OBM_CHECKBOXES                32759
${DEFINE} OBM_BTNCORNERS                32758
${DEFINE} OBM_OLD_REDUCE                32757
${DEFINE} OBM_OLD_ZOOM                  32756
${DEFINE} OBM_OLD_RESTORE               32755

${DEFINE} OCR_NORMAL                    32512
${DEFINE} OCR_IBEAM                     32513
${DEFINE} OCR_WAIT                      32514
${DEFINE} OCR_CROSS                     32515
${DEFINE} OCR_UP                        32516
${DEFINE} OCR_SIZE                      32640   /* OBSOLETE: use OCR_SIZEALL */
${DEFINE} OCR_ICON                      32641   /* OBSOLETE: use OCR_NORMAL */
${DEFINE} OCR_SIZENWSE                  32642
${DEFINE} OCR_SIZENESW                  32643
${DEFINE} OCR_SIZEWE                    32644
${DEFINE} OCR_SIZENS                    32645
${DEFINE} OCR_SIZEALL                   32646
${DEFINE} OCR_ICOCUR                    32647   /* OBSOLETE: use OIC_WINLOGO */
${DEFINE} OCR_NO                        32648
${DEFINE} OCR_HAND                      32649
${DEFINE} OCR_APPSTARTING               32650

${DEFINE} OIC_SAMPLE                    32512
${DEFINE} OIC_HAND                      32513
${DEFINE} OIC_QUES                      32514
${DEFINE} OIC_BANG                      32515
${DEFINE} OIC_NOTE                      32516
${DEFINE} OIC_WINLOGO                   32517
${DEFINE} OIC_WARNING                   ${OIC_BANG}
${DEFINE} OIC_ERROR                     ${OIC_HAND}
${DEFINE} OIC_INFORMATION               ${OIC_NOTE}
${DEFINE} OIC_SHIELD                    32518

${DEFINE} IDI_APPLICATION               32512
${DEFINE} IDI_HAND                      32513
${DEFINE} IDI_ERROR                     32513
${DEFINE} IDI_QUESTION                  32514
${DEFINE} IDI_WARNING                   32515
${DEFINE} IDI_EXCLAMATION               32515
${DEFINE} IDI_ASTERISK                  32516
${DEFINE} IDI_INFORMATION               32516
${DEFINE} IDI_WINLOGO                   32517
${DEFINE} IDI_SHIELD                    32518

/* Messagebox types */
${DEFINE} MB_ABORTRETRYIGNORE           0x00000002
${DEFINE} MB_CANCELTRYCONTINUE          0x00000006
${DEFINE} MB_HELP                       0x00004000
${DEFINE} MB_OK                         0x00000000
${DEFINE} MB_OKCANCEL                   0x00000001
${DEFINE} MB_RETRYCANCEL                0x00000005
${DEFINE} MB_YESNO                      0x00000004
${DEFINE} MB_YESNOCANCEL                0x00000003

${DEFINE} MB_ICONSTOP                   0x00000010
${DEFINE} MB_ICONERROR                  0x00000010
${DEFINE} MB_ICONHAND                   0x00000010
${DEFINE} MB_ICONQUESTION               0x00000020
${DEFINE} MB_ICONEXCLAMATION            0x00000030
${DEFINE} MB_ICONWARNING                0x00000030
${DEFINE} MB_ICONINFORMATION            0x00000040
${DEFINE} MB_ICONASTERISK               0x00000040

${DEFINE} MB_DEFBUTTON1                 0x00000000
${DEFINE} MB_DEFBUTTON2                 0x00000100
${DEFINE} MB_DEFBUTTON3                 0x00000200
${DEFINE} MB_DEFBUTTON4                 0x00000300

${DEFINE} MB_APPLMODAL                  0x00000000
${DEFINE} MB_SYSTEMMODAL                0x00001000
${DEFINE} MB_TASKMODAL                  0x00002000

${DEFINE} MB_DEFAULT_DESKTOP_ONLY       0x00020000
${DEFINE} MB_RIGHT                      0x00080000
${DEFINE} MB_SETFOREGROUND              0x00010000
${DEFINE} MB_TOPMOST                    0x00040000
${DEFINE} MB_RTLREADING                 0x00100000
${DEFINE} MB_SERVICE_NOTIFICATION       0x00200000

/* Messagebox return values */
${DEFINE} IDOK                          1
${DEFINE} IDCANCEL                      2
${DEFINE} IDABORT                       3
${DEFINE} IDRETRY                       4
${DEFINE} IDIGNORE                      5
${DEFINE} IDYES                         6
${DEFINE} IDNO                          7
#if(WINVER >= 0x0400)
${DEFINE} IDCLOSE                       8
${DEFINE} IDHELP                        9
#endif /* WINVER >= 0x0400 */
${DEFINE} IDTRYAGAIN                    10
${DEFINE} IDCONTINUE                    11

/* SHGetFileInfo function flags */
${DEFINE} SHGFI_LARGEICON               0x00000000  ;// get large icon
${DEFINE} SHGFI_SMALLICON               0x00000001  ;// get small icon
${DEFINE} SHGFI_OPENICON                0x00000002  ;// get open icon
${DEFINE} SHGFI_SHELLICONSIZE           0x00000004  ;// get shell size icon
${DEFINE} SHGFI_PIDL                    0x00000008  ;// pszPath is a pidl
${DEFINE} SHGFI_USEFILEATTRIBUTES       0x00000010  ;// use passed dwFileAttribute
${DEFINE} SHGFI_ICON                    0x00000100  ;// get icon
${DEFINE} SHGFI_DISPLAYNAME             0x00000200  ;// get display name
${DEFINE} SHGFI_TYPENAME                0x00000400  ;// get type name
${DEFINE} SHGFI_ATTRIBUTES              0x00000800  ;// get attributes
${DEFINE} SHGFI_ICONLOCATION            0x00001000  ;// get icon location
${DEFINE} SHGFI_EXETYPE                 0x00002000  ;// return exe type
${DEFINE} SHGFI_SYSICONINDEX            0x00004000  ;// get system icon index
${DEFINE} SHGFI_LINKOVERLAY             0x00008000  ;// put a link overlay on icon
${DEFINE} SHGFI_SELECTED                0x00010000  ;// show icon in selected state
${DEFINE} SHGFI_ATTR_SPECIFIED          0x00020000  ;// get only specified attributes

/* Flags of OPENFILENAME structure */
${DEFINE} OFN_READONLY                  0x00000001
${DEFINE} OFN_OVERWRITEPROMPT           0x00000002
${DEFINE} OFN_HIDEREADONLY              0x00000004
${DEFINE} OFN_NOCHANGEDIR               0x00000008
${DEFINE} OFN_SHOWHELP                  0x00000010
${DEFINE} OFN_ENABLEHOOK                0x00000020
${DEFINE} OFN_ENABLETEMPLATE            0x00000040
${DEFINE} OFN_ENABLETEMPLATEHANDLE      0x00000080
${DEFINE} OFN_NOVALIDATE                0x00000100
${DEFINE} OFN_ALLOWMULTISELECT          0x00000200
${DEFINE} OFN_EXTENSIONDIFFERENT        0x00000400
${DEFINE} OFN_PATHMUSTEXIST             0x00000800
${DEFINE} OFN_FILEMUSTEXIST             0x00001000
${DEFINE} OFN_CREATEPROMPT              0x00002000
${DEFINE} OFN_SHAREAWARE                0x00004000
${DEFINE} OFN_NOREADONLYRETURN          0x00008000
${DEFINE} OFN_NOTESTFILECREATE          0x00010000
${DEFINE} OFN_NONETWORKBUTTON           0x00020000
${DEFINE} OFN_NOLONGNAMES               0x00040000
#if(WINVER >= 0x0400)
${DEFINE} OFN_EXPLORER                  0x00080000
${DEFINE} OFN_NODEREFERENCELINKS        0x00100000
${DEFINE} OFN_LONGNAMES                 0x00200000
${DEFINE} OFN_ENABLEINCLUDENOTIFY       0x00400000
${DEFINE} OFN_ENABLESIZING              0x00800000
#endif /* WINVER >= 0x0400 */
#if (_WIN32_WINNT >= 0x0500)
${DEFINE} OFN_DONTADDTORECENT           0x02000000
${DEFINE} OFN_FORCESHOWHIDDEN           0x10000000
#endif // (_WIN32_WINNT >= 0x0500)
#if (_WIN32_WINNT >= 0x0500)
${DEFINE} OFN_EX_NOPLACESBAR            0x00000001
#endif // (_WIN32_WINNT >= 0x0500)
${DEFINE} OFN_SHAREFALLTHROUGH          2
${DEFINE} OFN_SHARENOWARN               1
${DEFINE} OFN_SHAREWARN                 0

/* File attributes */
; All attributes are defined in WinNT.nsh
${DEFINE} FILE_ATTRIBUTE_READONLY               0x00000001
${DEFINE} FILE_ATTRIBUTE_HIDDEN                 0x00000002
${DEFINE} FILE_ATTRIBUTE_SYSTEM                 0x00000004
${DEFINE} FILE_ATTRIBUTE_DIRECTORY              0x00000010
${DEFINE} FILE_ATTRIBUTE_ARCHIVE                0x00000020
${DEFINE} FILE_ATTRIBUTE_DEVICE                 0x00000040
${DEFINE} FILE_ATTRIBUTE_NORMAL                 0x00000080
${DEFINE} FILE_ATTRIBUTE_TEMPORARY              0x00000100
${DEFINE} FILE_ATTRIBUTE_SPARSE_FILE            0x00000200
${DEFINE} FILE_ATTRIBUTE_REPARSE_POINT          0x00000400
${DEFINE} FILE_ATTRIBUTE_COMPRESSED             0x00000800
${DEFINE} FILE_ATTRIBUTE_OFFLINE                0x00001000
${DEFINE} FILE_ATTRIBUTE_NOT_CONTENT_INDEXED    0x00002000
${DEFINE} FILE_ATTRIBUTE_ENCRYPTED              0x00004000

/* SetWindowPos Function Flags */
${DEFINE} SWP_NOSIZE              0x0001
${DEFINE} SWP_NOMOVE              0x0002
${DEFINE} SWP_NOZORDER            0x0004
${DEFINE} SWP_NOREDRAW            0x0008
${DEFINE} SWP_NOACTIVATE          0x0010
${DEFINE} SWP_FRAMECHANGED        0x0020  /* The frame changed: send WM_NCCALCSIZE */
${DEFINE} SWP_SHOWWINDOW          0x0040
${DEFINE} SWP_HIDEWINDOW          0x0080
${DEFINE} SWP_NOCOPYBITS          0x0100
${DEFINE} SWP_NOOWNERZORDER       0x0200  /* Don't do owner Z ordering */
${DEFINE} SWP_NOSENDCHANGING      0x0400  /* Don't send WM_WINDOWPOSCHANGING */
#if(WINVER >= 0x0400)
${DEFINE} SWP_DEFERERASE          0x2000
${DEFINE} SWP_ASYNCWINDOWPOS      0x4000
#endif /* WINVER >= 0x0400 */

${DEFINE} HWND_TOP                0
${DEFINE} HWND_BOTTOM             1
${DEFINE} HWND_TOPMOST            -1
${DEFINE} HWND_NOTOPMOST          -2

${DEFINE} WM_NOTIFY_OUTER_NEXT    0x0408
#// custom pages should send this message to let NSIS know they're ready
${DEFINE} WM_NOTIFY_CUSTOM_READY  0x040D
#// sent as wParam with WM_NOTIFY_OUTER_NEXT when user cancels - heed its warning
${DEFINE} NOTIFY_BYE_BYE          x

${DEFINE} GMEM_FIXED              0x0000
${DEFINE} GMEM_MOVEABLE           0x0002
${DEFINE} GMEM_ZEROINIT           0x0040
${DEFINE} GHND                    ${GMEM_MOVEABLE}|${GMEM_ZEROINIT}
${DEFINE} GPTR                    ${GMEM_FIXED}|${GMEM_ZEROINIT}

/* Define extra controls */
!define __NSD_ListView_CLASS SysListView32
!define __NSD_ListView_STYLE ${DEFAULT_STYLES}|${LVS_REPORT}|${LVS_SINGLESEL}|${LVS_SHAREIMAGELISTS}|${LVS_NOSORTHEADER}
!define __NSD_ListView_EXSTYLE ${WS_EX_WINDOWEDGE}|${WS_EX_CLIENTEDGE}

!define __NSD_TreeView_CLASS SysTreeView32
!define __NSD_TreeView_STYLE ${DEFAULT_STYLES}|${TVS_HASBUTTONS}|${TVS_HASLINES}|${TVS_LINESATROOT}|${TVS_DISABLEDRAGDROP}
!define __NSD_TreeView_EXSTYLE ${WS_EX_WINDOWEDGE}|${WS_EX_CLIENTEDGE}

!define __NSD_ComboBoxEx_CLASS ComboBoxEx32
!define __NSD_ComboBoxEx_STYLE ${DEFAULT_STYLES}|${WS_TABSTOP}|${CBS_DROPDOWN}
!define __NSD_ComboBoxEx_EXSTYLE 0

!define __NSD_DropListEx_CLASS ComboBoxEx32
!define __NSD_DropListEx_STYLE ${DEFAULT_STYLES}|${WS_TABSTOP}|${CBS_DROPDOWNLIST}
!define __NSD_DropListEx_EXSTYLE 0

!insertmacro __NSD_DefineControl ListView
!insertmacro __NSD_DefineControl TreeView
!insertmacro __NSD_DefineControl ComboBoxEx
!insertmacro __NSD_DefineControl DropListEx

/*
#################################################################
# ${NSD_AddStyle} control_HWND style                            #
# Adds one or more window styles to a control.                   #
#################################################################

!macro __NSD_AddStyle CONTROL STYLE
  Push ${CONTROL}
  Exch $R0
  System::Call "user32::GetWindowLong(iR0,i${GWL_STYLE})i.s"
  Exch $R0
  System::Call "user32::SetWindowLong(is,i${GWL_STYLE},i$R0|${STYLE})"
  Pop $R0
!macroend
!define /redef NSD_AddStyle "!insertmacro __NSD_AddStyle"

#################################################################
# ${NSD_AddExStyle} control_HWND style                          #
# Adds one or more extended window styles to a control.          #
#################################################################

!macro __NSD_AddExStyle CONTROL EXSTYLE
  Push ${CONTROL}
  Exch $R0
  System::Call "user32::GetWindowLong(iR0,i${GWL_EXSTYLE})i.s"
  Exch $R0
  System::Call "user32::SetWindowLong(is,i${GWL_EXSTYLE},i$R0|${EXSTYLE})"
  Pop $R0
!macroend
!define /redef NSD_AddExStyle "!insertmacro __NSD_AddExStyle"
*/

#################################################################
# ${NSD_RemoveStyle} control_HWND style                         #
# Removes one or more window style from a control.              #
#################################################################

!macro _NSD_RemoveStyle_Call CONTROL STYLE
	!verbose push
	!verbose ${_LISTVIEW_NSH_VERBOSE}
  Push `${CONTROL}`
  Push `${STYLE}`
  ${CallArtificialFunction} _NSD_RemoveStyle_
  !verbose pop
!macroend

!macro _NSD_RemoveStyle_
  System::Store SR1R0
  IntOp $R1 $R1 ~
  System::Call "user32::GetWindowLong(iR0,i${GWL_STYLE})i.R2"
  IntOp $R2 $R1 & $R2
  System::Call "user32::SetWindowLong(iR0,i${GWL_STYLE},iR2)"
  System::Store L
!macroend

!define NSD_RemoveStyle "!insertmacro _NSD_RemoveStyle_Call"

#################################################################
# ${NSD_RemoveExStyle} control_HWND style                       #
# Removes one or more extended window style from a control.     #
#################################################################

!macro _NSD_RemoveExStyle_Call CONTROL EXSTYLE
	!verbose push
	!verbose ${_LISTVIEW_NSH_VERBOSE}
  Push `${CONTROL}`
  Push `${EXSTYLE}`
  ${CallArtificialFunction} _NSD_RemoveExStyle_
  !verbose pop
!macroend

!macro _NSD_RemoveExStyle_
  System::Store SR1R0
  IntOp $R1 $R1 ~
  System::Call "user32::GetWindowLong(iR0,i${GWL_EXSTYLE})i.R2"
  IntOp $R2 $R1 & $R2
  System::Call "user32::SetWindowLong(iR0,i${GWL_EXSTYLE},iR2)"
  System::Store L
!macroend

!define NSD_RemoveExStyle "!insertmacro _NSD_RemoveExStyle_Call"

#################################################################
# ${NSD_CB_DelString} combo_HWND string                         #
# Deletes a specified string from a combobox                    #
#################################################################

!macro __NSD_CB_DelString_Call CONTROL STRING
	!verbose push
	!verbose ${_LISTVIEW_NSH_VERBOSE}
  Push `${CONTROL}`
  Push `${STRING}`
  ${CallArtificialFunction} __NSD_CB_DelString_
  !verbose pop
!macroend

!macro __NSD_CB_DelString_
  System::Store SR1R0
  System::Call `user32::SendMessage(iR0,i${CB_FINDSTRING},i-1,tR1)i.s`
  System::Call `user32::SendMessage(iR0,i${CB_DELETESTRING},is,i0)
  System::Store L
!macroend

!define NSD_CB_DelString `!insertmacro __NSD_CB_DelString_Call`


#################################################################
# ${NSD_CB_Clear} combo_HWND                                    #
# Deletes all strings from a combobox (no return value)         #
#################################################################

!macro __NSD_CB_Clear CONTROL #VAR
	SendMessage ${CONTROL} ${CB_RESETCONTENT} 0 0 #${VAR}
!macroend

!define NSD_CB_Clear `!insertmacro __NSD_LB_Clear`


#################################################################
# ${NSD_CB_GetCount} combo_HWND output_variable                 #
# Retrieves the number of strings from a combobox               #
#################################################################

!macro __NSD_CB_GetCount CONTROL VAR
  SendMessage ${CONTROL} ${CB_GETCOUNT} 0 0 ${VAR}
!macroend

!define NSD_CB_GetCount `!insertmacro __NSD_CB_GetCount`


#################################################################
# ${NSD_CB_GetSelection} combo_HWND output_variable             #
# Retrieves the selected string from a combobox                 #
#################################################################

!macro __NSD_CB_GetSelection_Call CONTROL VAR
	!verbose push
	!verbose ${_LISTVIEW_NSH_VERBOSE}
  Push `${CONTROL}`
  ${CallArtificialFunction} __NSD_CB_GetSelection_
  Pop `${VAR}`
  !verbose pop
!macroend

!macro __NSD_CB_GetSelection_
  System::Store SR0
  System::Call `user32::SendMessage(iR0,i${CB_GETCURSEL},i0,i0)i.s`
  System::Call `user32::SendMessage(iR0,i${CB_GETLBTEXT},is,t.s)'
  System::Store L
!macroend

!define NSD_CB_GetSelection `!insertmacro __NSD_CB_GetSelection_Call`


#################################################################
# ${NSD_LB_DelString} listbox_HWND string                       #
# Deletes a string from a list box                              #
#################################################################

!macro __NSD_LB_DelString_Call CONTROL STRING
	!verbose push
	!verbose ${_LISTVIEW_NSH_VERBOSE}
  Push `${CONTROL}`
  Push `${STRING}`
  ${CallArtificialFunction} __NSD_LB_DelString_
  !verbose pop
!macroend

!macro __NSD_LB_DelString_
  System::Store SR1R0
  System::Call `user32::SendMessage(iR0,i${LB_FINDSTRING},i-1,tR1)i.s`
  System::Call `user32::SendMessage(iR0,i${LB_DELETESTRING},is,i0)`
  System::Store L
!macroend

!ifdef NSD_LB_DelString
    !undef NSD_LB_DelString
!endif
!define NSD_LB_DelString `!insertmacro __NSD_LB_DelString_Call`


#################################################################
# ${NSD_LB_Clear} listbox_HWND                                  #
# Deletes all strings from a list box (no return value)         #
#################################################################

!macro _NSD_LB_Clear CONTROL #VAR
	SendMessage ${CONTROL} ${LB_RESETCONTENT} 0 0 #${VAR}
!macroend

!ifdef NSD_LB_Clear
  !undef NSD_LB_Clear
!endif
!define NSD_LB_Clear `!insertmacro _NSD_LB_Clear`


######################## ListView Macros ########################


#################################################################
# ${NSD_LV_InsertColumn} hwndLV iCol cx pszText                 #
# Inserts a new column to a listview (report view)              #
#################################################################

!macro __NSD_LV_InsertColumn_Call hwndLV_ iCol_ cx_ pszText_
  !verbose push
	!verbose ${_LISTVIEW_NSH_VERBOSE}
  Push `${hwndLV_}`
  Push `${iCol_}`
  Push `${cx_}`
  Push `${pszText_}`
  ${CallArtificialFunction} __NSD_LV_InsertColumn_
  !verbose pop
!macroend

!macro __NSD_LV_InsertColumn_
  System::Store SR3R2R1R0
  System::Call `*(i${LVCF_WIDTH}|${LVCF_TEXT},i,iR2,tR3,i${MAX_PATH},i)i.R2`
  System::Call `user32::SendMessage(iR0,i${LVM_INSERTCOLUMN},iR1,iR2)`
  System::Free $R2
  System::Store L
!macroend

!define NSD_LV_InsertColumn `!insertmacro __NSD_LV_InsertColumn_Call`

#################################################################
# ${NSD_LV_DeleteColumn} hwndLV iCol                            #
# Deletes a new column from a listview (report view)            #
#################################################################

!macro __NSD_LV_DeleteColumn_Call hwndLV_ iCol_
  !verbose push
	!verbose ${_LISTVIEW_NSH_VERBOSE}
  SendMessage ${hwndLV_} ${LVM_DELETECOLUMN} ${iCol_} 0
  !verbose pop
!macroend

!define NSD_LV_DeleteColumn `!insertmacro __NSD_LV_DeleteColumn_Call`


#################################################################
# ${NSD_LV_InsertItem} hwndLV iItem pszText                     #
# Inserts a new item to a listview (report view)                #
#################################################################

!macro __NSD_LV_InsertItem_Call hwndLV_ iItem_ pszText_
  !verbose push
	!verbose ${_LISTVIEW_NSH_VERBOSE}
  Push `${hwndLV_}`
  Push `${iItem_}`
  Push `${pszText_}`
  ${CallArtificialFunction} __NSD_LV_InsertItem_
  !verbose pop
!macroend

!macro __NSD_LV_InsertItem_
  System::Store SR2R1R0
  System::Call `*(i${LVIF_TEXT},iR1,i,i,i,tR2,i${MAX_PATH},i,i)i.R2`
  System::Call `user32::SendMessage(iR0,i${LVM_INSERTITEM},i0,iR2)`
  System::Free $R2
  System::Store L
!macroend

!define NSD_LV_InsertItem `!insertmacro __NSD_LV_InsertItem_Call`

#################################################################
# ${NSD_LV_GetItemText} hwndLV iItem iSubItem pszText           #
# Retrieves the text of an item of a listview                   #
#################################################################

!macro __NSD_LV_GetItemText_Call hwndLV_ iItem_ iSubItem_ pszText_
  !verbose push
	!verbose ${_LISTVIEW_NSH_VERBOSE}
  Push `${hwndLV_}`
  Push `${iItem_}`
  Push `${iSubItem_}`
  ${CallArtificialFunction} __NSD_LV_GetItemText_
  Pop `${pszText_}`
  !verbose pop
!macroend

!macro __NSD_LV_GetItemText_
  System::Store SR2R1R0
  System::Alloc ${MAX_PATH}
  System::Call `*(i${LVIF_TEXT},i,iR2,i,i,isR3,i${MAX_PATH},i,i)i.R2`
  System::Call `user32::SendMessage(iR0,i${LVM_GETITEMTEXT},iR1,iR2)`
  System::Free $R2
  System::Call `*$R3(&t${MAX_PATH}.s)`
  System::Free $R3
  System::Store L
!macroend

!define NSD_LV_GetItemText `!insertmacro __NSD_LV_GetItemText_Call`

#################################################################
# ${NSD_LV_SetItemText} hwndLV iItem iSubItem pszText           #
# Inserts a new subitem to a listview (report view)             #
#################################################################

!macro __NSD_LV_SetItemText_Call hwndLV_ iItem_ iSubItem_ pszText_
  !verbose push
	!verbose ${_LISTVIEW_NSH_VERBOSE}
  Push `${hwndLV_}`
  Push `${iItem_}`
  Push `${iSubItem_}`
  Push `${pszText_}`
  ${CallArtificialFunction} __NSD_LV_SetItemText_
  !verbose pop
!macroend

!macro __NSD_LV_SetItemText_
  System::Store SR3R2R1R0
  System::Call `*(i${LVIF_TEXT},i,iR2,i,i,tR3,i${MAX_PATH},i,i)i.R2`
  System::Call `user32::SendMessage(iR0,i${LVM_SETITEMTEXT},iR1,iR2)`
  System::Free $R2
  System::Store L
!macroend

!define NSD_LV_SetItemText `!insertmacro __NSD_LV_SetItemText_Call`

#################################################################
# ${NSD_LV_SetItemImage} hwndLV iItem iImage                    #
# Sets the icon of an item of a listview (report view)          #
#################################################################

!macro __NSD_LV_SetItemImage_Call hwndLV_ iItem_ iImage_
  !verbose push
	!verbose ${_LISTVIEW_NSH_VERBOSE}
  Push `${hwndLV_}`
  Push `${iItem_}`
  Push `${iImage_}`
  ${CallArtificialFunction} __NSD_LV_SetItemImage_
  !verbose pop
!macroend

!macro __NSD_LV_SetItemImage_
  System::Store SR2R1R0
  System::Call `*(i${LVIF_IMAGE},iR1,i,i,i,t,i,iR2,i)i.R2`
  System::Call `user32::SendMessage(iR0,i${LVM_SETITEM},i0,iR2)`
  System::Free $R2
  System::Store L
!macroend

!define NSD_LV_SetItemImage `!insertmacro __NSD_LV_SetItemImage_Call`

#################################################################
# ${NSD_LV_GetCheckState} hwndLV iItem state                    #
#################################################################

!macro __NSD_LV_GetCheckState_Call hwndLV_ iItem_ state_
  !verbose push
	!verbose ${_LISTVIEW_NSH_VERBOSE}
  Push `${hwndLV_}`
  Push `${iItem_}`
  ${CallArtificialFunction} __NSD_LV_GetCheckState_
  Pop `${state_}`
  !verbose pop
!macroend

!macro __NSD_LV_GetCheckState_
  System::Store SR1R0
  System::Call `user32::SendMessage(iR0,i${LVM_GETITEMSTATE},iR1,i${LVIS_STATEIMAGEMASK})i.R2`
  System::Int64Op $R2 >> 12
  System::Store R2
  System::Int64Op $R2 - 1
  System::Store L
!macroend

!define NSD_LV_GetCheckState `!insertmacro __NSD_LV_GetCheckState_Call`

#################################################################
# ${NSD_LV_SetCheckState} hwndLV iItem state                    #
# Checks an item of a listview with checkboxes exstyle          #
#################################################################

!macro __NSD_LV_SetCheckState_Call hwndLV_ iItem_ state_
  !verbose push
	!verbose ${_LISTVIEW_NSH_VERBOSE}
  Push `${hwndLV_}`
  Push `${iItem_}`
  Push `${state_}`
  ${CallArtificialFunction} __NSD_LV_SetCheckState_
  !verbose pop
!macroend

!macro __NSD_LV_SetCheckState_
  System::Store SR2R1R0
  System::Int64Op $R2 + 1
  System::Store R2
  System::Int64Op $R2 << 12
  System::Call `*(i${LVIF_STATE},i,i,is,i${LVIS_STATEIMAGEMASK},t,i,i,i)i.R2`
  System::Call `user32::SendMessage(iR0,i${LVM_SETITEMSTATE},iR1,iR2)`
  System::Free $R2
  System::Store L
!macroend

!define NSD_LV_SetCheckState `!insertmacro __NSD_LV_SetCheckState_Call`

###################### ListView Macros Ends #####################


######################## TreeView Macros ########################

#################################################################
# ${NSD_TV_InsertItem} hwndTV pszText                           #
#################################################################

!macro __NSD_TV_InsertItem_Call hwndTV_ pszText_
  !verbose push
	!verbose ${_LISTVIEW_NSH_VERBOSE}
  Push `${hwndTV_}`
  Push `${pszText_}`
  ${CallArtificialFunction} __NSD_TV_InsertItem_
  !verbose pop
!macroend

!macro __NSD_TV_InsertItem_
  System::Store SR1R0
  System::Call '*(i${TVI_ROOT},i${TVI_LAST},i${TVIF_TEXT},i,i,i,tR1,i,i,i,i,i)i.R2'
  System::Call `user32::SendMessage(iR0,i${TVM_INSERTITEM},i0,iR2)`
  System::Free $R2
  System::Store L
!macroend

!define NSD_TV_InsertItem `!insertmacro __NSD_TV_InsertItem_Call`

###################### TreeView Macros Ends #####################

!undef DEFINE

!ifdef COMMCTRL_TEMP_DEFINE
  !define DEFINE "${COMMCTRL_TEMP_DEFINE}"
  !undef COMMCTRL_TEMP_DEFINE
!endif

!verbose pop

!endif