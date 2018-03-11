#include <windows.h>
#include "..\ExDll\exdll.h"
#include <Richedit.h>

/**
    ScrollLicense v0.7 by Afrow UK
    A plugin dll for NSIS that stops the user continuing from the LicensePage
    without scrolling to the end of the license.

    Last modified: 19th July 2007
*/

// Dialog control defines
#define IDD_LICENSEA  102  // Default license page

#define IDD_LICENSEB  108  // License page with "Accept" check-box
#define IDC_LB_CHECK  1034 // Check-box

#define IDD_LICENSEC  109  // License page with "Accept" and "Decline" radio-buttons
#define IDC_LC_RB1    1034 // Radio-button 1
#define IDC_LC_RB2    1035 // Radio-button 2

#define IDC_NEXT      1    // Next button
#define IDC_BACK      3    // Back button

#define IDC_LICENSE   1000 // License RichEdit20A

#define IDC_LB_CHECK2 1035 // Custom check-box

// Two labels on license page (the 2nd is only on MUI)
#define IDC_LABEL1    1006
#define IDC_LABEL2    1040

// This is the parameter to enable the second check-box
// and the default label text
#define CHECK_PARAM   TEXT("/CHECKBOX")
#define CHECK_LABEL   TEXT("I have read and understand the terms in the License Agreement")

// This is the size of the gap created to put the new check-box there
#define CHECK_GAP     32;

// Another parameter to set the number of lines on the license rich-edit control
// It's used to check when the user has scrolled to the end
#define LINES_PARAM   TEXT("/LINES")
#define LINES_DEFAULT 13


#ifndef SetWindowLongPtr
#define SetWindowLongPtr SetWindowLong
#endif

#ifndef GetWindowLongPtr
#define GetWindowLongPtr GetWindowLong
#endif

#ifndef GWLP_WNDPROC
#define GWLP_WNDPROC GWL_WNDPROC
#endif

#ifndef DWLP_DLGPROC
#define DWLP_DLGPROC DWL_DLGPROC
#endif

// Global variables
HINSTANCE g_hInstance;
UINT g_uMsgCreate;

HWND g_hWndParent, g_hChildWnd;

HWND g_hLicense, g_hNext;
HWND g_hCheckBox, g_hCheckBox2;
HWND g_hRadioButton1, g_hRadioButton2;

int g_iLineCount, g_iVisibleLines;
int g_iLicensePageID;

BOOL g_bCheckBox = FALSE; // This is used to enable the 2nd check-box
char *g_pszCheckBoxText;

// This is used so the plugin code isn't executed again if the license has already been read
BOOL g_bLicenseRead = FALSE;
// This is used to check if the plugin has already been enabled
BOOL g_bEnabled = FALSE;

// Declare window and dialog procedures
WNDPROC WndProcOld;
DLGPROC DlgProcOld;

// Other custom function declarations
int my_atoi(char *p);

//wsprintf(szParam, "%i", g_iVisibleLines);
//MessageBox(g_hWndParent, szParam, "", MB_OK);

// Callback Function: This handles window messages and notifications sent from the child window
static BOOL CALLBACK WndProc(HWND hWndDlg, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
  if (uMsg == g_uMsgCreate)
  {
    g_hLicense = GetDlgItem(g_hChildWnd, IDC_LICENSE);
    g_hNext    = GetDlgItem(g_hWndParent, IDC_NEXT);

    // Disable next button by default.
    EnableWindow(g_hNext, FALSE);
    
    // Here we disable the current check-box ("LicenseForceSelection checkbox" in NSIS)
    // and add another one if /CHECKBOX was passed
    if (g_hCheckBox = GetDlgItem(g_hChildWnd, IDC_LB_CHECK))
    {
      EnableWindow(g_hCheckBox, FALSE);
      g_iLicensePageID = IDD_LICENSEB;

      // We can't have the 2 check-boxes if we don't have a first one!
      if (!g_hCheckBox)
        g_bCheckBox = FALSE;

      // Also, we can't have two check-boxes if we have two radio-buttons!
      else if ((g_hRadioButton1 = GetDlgItem(g_hChildWnd, IDC_LC_RB1)) && (g_hRadioButton2 = GetDlgItem(g_hChildWnd, IDC_LC_RB2)))
        g_bCheckBox = FALSE;

      // This adds the new check-box if parameter was passed
      if (g_bCheckBox)
      {
        RECT rWndRect;
        HFONT fCheckBox;
        HWND hLabel;
        int iTop = 0; // This is used to define (eventually) the y coord of our new check-box

        // Set iTop to the height of the license box first
        GetClientRect(g_hLicense, &rWndRect);
        iTop += rWndRect.bottom - 16;

        if (hLabel = GetDlgItem(g_hChildWnd, IDC_LABEL2)) // If we have a IDC_LABEL2 control, we're using Modern UI
        {

          // Resize the license box first (to fit in the new check-box)
          SetWindowPos(g_hLicense, NULL, 0, 0, rWndRect.right + 21, rWndRect.bottom - 8, SWP_NOMOVE);

          // Then add the height of IDC_LABEL2 onto iTop
          GetClientRect(hLabel, &rWndRect);
          iTop += rWndRect.bottom;
          
          // Add the height of IDC_LABEL1 control
          if (hLabel = GetDlgItem(g_hChildWnd, IDC_LABEL1))
          {
            GetClientRect(hLabel, &rWndRect);
            iTop += rWndRect.bottom;
          }

          // Set the new position of IDC_LABEL1 control (needs to be moved up to fit in new check-box)
          SetWindowPos(hLabel, NULL, 0, iTop - 24, rWndRect.right + 21, rWndRect.bottom - 10, (UINT)NULL);
          iTop += 12;

          // We've made the license box smaller, therefore we must reduce the limit at which
          // the user must scroll for the Next button to be enable (actually, the check-boxes that
          // enables the Next button)
          g_iVisibleLines -= 3;
        }
        else // Otherwise it's just default UI (god help any other UI's!)
        {
          // Again, (default UI) we must make the license box smaller to fit the new check-box in
          SetWindowPos(g_hLicense, NULL, 0, 0, rWndRect.right + 21, rWndRect.bottom - 14, SWP_NOMOVE);

          // Add the height of IDC_LABEL1 control onto iTop
          if (hLabel = GetDlgItem(g_hChildWnd, IDC_LABEL1))
          {
            GetClientRect(hLabel, &rWndRect);
            iTop += rWndRect.bottom + 8;
          }

          // Reduce scroll limit (because we've made license box smaller)
          g_iVisibleLines -= 2;
        }
        
        // Create the damn check-box finally!
        if (!g_bLicenseRead)
          g_hCheckBox2 = CreateWindow("BUTTON", g_pszCheckBoxText,
            BS_AUTOCHECKBOX | WS_CHILD | WS_VISIBLE | WS_TABSTOP | WS_DISABLED,
            0, iTop, rWndRect.right, 16,
            g_hChildWnd, (HMENU)IDC_LB_CHECK2, g_hInstance, NULL);

        else // If the license has already been read, don't disable the check-box and check it
          g_hCheckBox2 = CreateWindow("BUTTON", g_pszCheckBoxText,
            BS_AUTOCHECKBOX | WS_CHILD | WS_VISIBLE | WS_TABSTOP,
            0, iTop, rWndRect.right, 16,
            g_hChildWnd, (HMENU)IDC_LB_CHECK2, g_hInstance, NULL);

        if (*g_pszCheckBoxText)
          GlobalFree(g_pszCheckBoxText);

        // Set the font to that of the other check-box
        fCheckBox = (HFONT)SendMessage(g_hCheckBox, WM_GETFONT, (WPARAM)NULL, (LPARAM)NULL);
        SendMessage(g_hCheckBox2, WM_SETFONT, (WPARAM)fCheckBox, (LPARAM)TRUE);
      }
    }
    // Here we disable both radio-buttons if they're there ("LicenseForceSelection radiobuttons" in NSIS)
    else if (g_hRadioButton1 && g_hRadioButton2)
      g_iLicensePageID = IDD_LICENSEC;
    else
      g_iLicensePageID = IDD_LICENSEA;

    // Get the number of lines in the license box
    g_iLineCount = SendMessage(g_hLicense, EM_GETLINECOUNT, (WPARAM)NULL, (LPARAM)NULL) - g_iVisibleLines;

    return FALSE;
  }
  // Call the default window procedure if we haven't used our own
  return CallWindowProc((WNDPROC)WndProcOld, hWndDlg, uMsg, wParam, lParam);
}

// Callback Function: This handles messages and notifications sent from controls
static BOOL CALLBACK DlgProc(HWND hWndDlg, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
  if (uMsg == WM_COMMAND)
  {
    if (LOWORD(wParam) == IDC_LICENSE)
    {
      // If user has scrolled to the bottom
      if ((SendMessage(g_hLicense, EM_GETFIRSTVISIBLELINE, (WPARAM)NULL, (LPARAM)NULL) >= g_iLineCount) && !g_bLicenseRead)
      {
        // The user has scrolled to the bottom of the license box, therefore he has (supposidly)
        // read the license
        g_bLicenseRead = TRUE;
        // If we're on the check-box license style, then enable the one
        // or both (if the other exists)
        if (g_iLicensePageID == IDD_LICENSEB)
        {
          EnableWindow(g_hCheckBox, TRUE);
          if (g_bCheckBox)
            EnableWindow(g_hCheckBox2, TRUE);
        }
        // Enable the two radio buttons
        else if (g_iLicensePageID == IDD_LICENSEC)
        {
          EnableWindow(g_hRadioButton1, TRUE);
          EnableWindow(g_hRadioButton2, TRUE);
        }
        // Otherwise, just enable the Next button
        else
          EnableWindow(g_hNext, TRUE);
      }
    }
    // If we press both check-boxes, Next button = enabled
    // Otherwise, disabled
    else if (LOWORD(wParam) == IDC_LB_CHECK || (g_bCheckBox && LOWORD(wParam) == IDC_LB_CHECK2))
    {
      EnableWindow(g_hNext,
        (g_bCheckBox ?
          (SendMessage(g_hCheckBox,  BM_GETCHECK, 0, 0) == BST_CHECKED) && (SendMessage(g_hCheckBox2, BM_GETCHECK, 0, 0) == BST_CHECKED)
        : (SendMessage(g_hCheckBox,  BM_GETCHECK, 0, 0) == BST_CHECKED)
        ));
      return FALSE;
    }
  }
  return CallWindowProc((WNDPROC)DlgProcOld, hWndDlg, uMsg, wParam, lParam);
}

// NSIS Function: Enables ScrollLicense
extern "C"
void __declspec(dllexport) Set(HWND hWndParent, int string_size, 
                                      char *variables, stack_t **stacktop,
                                      extra_parameters *extra)
{
  g_hWndParent = hWndParent;
  EXDLL_INIT();
  {

    // Get plugin parameters
    char *pszParam = (char*)GlobalAlloc(GPTR, sizeof(char)*string_size);
    while (popstring(pszParam) == 0)
    {
      // /CHECKBOX?
      if (lstrcmpi(pszParam, CHECK_PARAM) == 0)
      {
        g_pszCheckBoxText = (char*)GlobalAlloc(GPTR, sizeof(char)*string_size);
        if (popstring(g_pszCheckBoxText) != 0)
          lstrcpy(g_pszCheckBoxText, CHECK_LABEL);

        g_bCheckBox = TRUE;
      }
      // /LINES?
      else if (lstrcmpi(pszParam, LINES_PARAM) == 0)
      {
        if (popstring(pszParam) == 0)
          g_iVisibleLines = my_atoi(pszParam);
      }
      // End of params.
      else
      {
        pushstring(pszParam);
        break;
      }
    }
    GlobalFree(pszParam);

    // No /LINES param? Use default
    if (!g_iVisibleLines)
      g_iVisibleLines = LINES_DEFAULT;

    // Set up global variable values
    g_hChildWnd       = FindWindowEx(hWndParent, NULL, "#32770", NULL);
    g_uMsgCreate      = RegisterWindowMessage("scrolllicense create");

    // Assign our child window procedure
    if (!WndProcOld)
    {
      WndProcOld     = (WNDPROC)SetWindowLongPtr(g_hChildWnd, GWLP_WNDPROC, (LONG)WndProc);
      SendMessage(g_hChildWnd, g_uMsgCreate, TRUE, (LPARAM)g_hChildWnd);
    }

    // Assing our child procedure
    if (!DlgProcOld)
      DlgProcOld     = (DLGPROC)SetWindowLongPtr(g_hChildWnd, DWLP_DLGPROC, (LONG)DlgProc);
  }
}


// NSIS Function: Unloads ScrollLicense
extern "C"
void __declspec(dllexport) Unload(HWND hWndParent, int string_size, 
                                      char *variables, stack_t **stacktop,
                                      extra_parameters *extra)
{
  g_hWndParent = hWndParent;
  EXDLL_INIT();
  {
    SetWindowLongPtr(g_hChildWnd, GWLP_WNDPROC, (LONG)WndProcOld);
    SendMessage(g_hChildWnd, g_uMsgCreate, FALSE, (LPARAM)g_hChildWnd);

    // Assign our child and parent dialog procedures
    SetWindowLongPtr(g_hChildWnd, DWLP_DLGPROC, (LONG)DlgProcOld);
  }
}

// Function: Converts char to int
int my_atoi(char *p)
{
  int n=0, f=0;

  for(;;p++) {
    switch(*p) {
    case ' ':
    case '\t':
      continue;
    case '-':
      f++;
    case '+':
      p++;
    }
    break;
  }
  while(*p >= '0' && *p <= '9')
    n = n*10 + *p++ - '0';
  return(f? -n: n);
}

BOOL WINAPI DllMain(HANDLE hInst, ULONG ul_reason_for_call, LPVOID lpReserved)
{
  g_hInstance = (HINSTANCE)hInst;
  return TRUE;
}