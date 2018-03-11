#include <windows.h>
#include <commctrl.h>
#include "..\ExDll\exdll.h"
#include <process.h>

/**
 RealProgress.cpp - Real install progress NSIS plugin by Afrow UK
 Last modified: 31st May 2007 
*/

#define IDC_PROGRESSBAR    1004
#define IDC_PROGRESSBARNEW 1005
#define IDC_PROGRESSTEXT   1006
#define IDC_PROGRESSLIST   1016

HINSTANCE g_hInst;
HWND g_hWndParent;
UINT g_uMsgCreate;

// HWND of our child window.
HWND g_hChildWnd;
// HWND of our own progress bar control.
HWND g_hProgressBarNew = FALSE;
// Stores the progress bar value to be added.
int g_iProgressBarAdd;
// Stores the total progress bar position.
int g_iProgressBarPos;
// Have we already added our own progress bar?
BOOL g_bProgressBarAdded;
// Set to true when we want to stop processing the current file extraction.
BOOL g_bFileProgressDone = TRUE;
// Handle to our thread that gradually increases the progress bar over a period of time.
HANDLE g_hGradualProgressThread;
// Number of seconds until next progress bar increase and the amount to increase by.
int g_iGradualProgressSeconds, g_iProgressBarIncrease;
// Enable/disable GradualProgress threads and window procedures.
BOOL g_bGradualProgressDone = TRUE,
// This is set to TRUE while a thread is running.
     g_bGradualProgressThreadRunning,
// For GradualProgress should we check if a new item added = StopAt (below).
     g_bGradualProgressStop;
// If this the new item = below, then stop increasing the progress bar.
char g_szGradualProgressStopAt[32];

// Stores pointer to NSIS's child window procedure.
WNDPROC WndProcOld;
// Stores pointer to NSIS's child dialog procedure.
DLGPROC DlgProcOld;

#ifndef SetWindowLongPtr
#define SetWindowLongPtr SetWindowLong
#endif

#ifndef GetWindowLongPtr
#define GetWindowLongPtr GetWindowLong
#endif

#ifndef DWLP_DLGPROC
#define DWLP_DLGPROC DWL_DLGPROC
#endif

#ifndef GWLP_WNDPROC
#define GWLP_WNDPROC GWL_WNDPROC
#endif

void GetPCComplete(char *szDetails, int iDetailsStrLen, char *szFileProgress);
unsigned int CharArrayLen(char *s);
int str2int(char *p);

// Increases progress bar position var.
// Prevents the value being > 100.
void IncreaseProgressBarPos(int iBy)
{
  // Can't go over 100.
  if (g_iProgressBarPos + iBy > 100)
    g_iProgressBarPos = 100;
  // Can't go under 0.
  else if (g_iProgressBarPos + iBy < 0)
    g_iProgressBarPos = 0;
  else
    g_iProgressBarPos += iBy;
}

// Handles window messages and notifications sent from the child window.
static BOOL CALLBACK WndProc(HWND hWndDlg, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
  // g_uMsgCreate is the message that we sent ourselves!
  if (uMsg == g_uMsgCreate)
  {
    if (!g_bProgressBarAdded)
    {
      if (!(g_hProgressBarNew = GetDlgItem(hWndDlg, IDC_PROGRESSBARNEW)))
      {
        HWND hProgressBar = GetDlgItem(hWndDlg, IDC_PROGRESSBAR);
        RECT rProgressBarPos;

        // Get the position and dimensions of the existing progress bar.
        GetWindowRect(hProgressBar, &rProgressBarPos);
        MapWindowPoints(HWND_DESKTOP, hWndDlg, (LPPOINT)&rProgressBarPos, 2);
        // Create the new progress bar in the same place.
        g_hProgressBarNew = CreateWindow
                            (
                              "msctls_progress32",
                              "",
                              WS_CHILD | WS_VISIBLE | WS_BORDER,
                              rProgressBarPos.left,
                              rProgressBarPos.top,
                              rProgressBarPos.right - rProgressBarPos.left,
                              rProgressBarPos.bottom - rProgressBarPos.top,
                              hWndDlg,
                              (HMENU)IDC_PROGRESSBARNEW,
                              g_hInst,
                              NULL
                            );

        // Set the style of the new progress bar to that of the old one.
        SetWindowLongPtr(g_hProgressBarNew, GWL_STYLE, GetWindowLongPtr(hProgressBar, GWL_STYLE));

        // Hide the old progress bar and show the new one.
        ShowWindow(hProgressBar, SW_HIDE);
        ShowWindow(g_hProgressBarNew, SW_SHOWNA);
      }

      // We've added our progress bar now!
      g_bProgressBarAdded = TRUE;

    }
    return FALSE;
  }
  else
    // Call the default window procedure if we haven't used our own.
    return CallWindowProc(WndProcOld, hWndDlg, uMsg, wParam, lParam);
}

// Handles window notifications sent from the child dialog for GradualProgress.
static BOOL CALLBACK GradualProgressDlgProc(HWND hWndDlg, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
  static NMHDR* pnmh;
  static HWND hDetails = GetDlgItem(g_hChildWnd, IDC_PROGRESSTEXT);
  static char szDetails[1024];
  if (uMsg == WM_NOTIFY)
  {
    pnmh = (NMHDR *)lParam;
    if (pnmh->idFrom == IDC_PROGRESSLIST && !g_bGradualProgressDone)
    {
      if (pnmh->code == LVN_INSERTITEM)
      {
        // We should check if the newly added item matches that of the item that we are after.
        if (g_bGradualProgressStop)
        {
          // Get the text of the newly added item.
          GetWindowText(hDetails, szDetails, sizeof(szDetails));
          // If it equals the item that we are after, then we must stop increasing the progress bar.
          if (lstrcmpi(szDetails, g_szGradualProgressStopAt) == 0)
            g_bGradualProgressDone = TRUE;
        }
        // We've finished.
        else
          g_bGradualProgressDone = TRUE;
      }
    }
  }
  // Call the default window procedure if we haven't used our own.
  return CallWindowProc((WNDPROC)DlgProcOld, hWndDlg, uMsg, wParam, lParam);
}

// Handles window notifications sent from the child dialog for FileProgress.
static BOOL CALLBACK DetailProgressDlgProc(HWND hWndDlg, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
  static NMHDR* pnmh;
  static HWND hDetails = GetDlgItem(g_hChildWnd, IDC_PROGRESSTEXT);
  static int  iDetailCount = 0;
  static char t[128];

  if (uMsg == WM_NOTIFY)
  {
    pnmh = (NMHDR *)lParam;
    if (pnmh->idFrom == IDC_PROGRESSLIST && !g_bFileProgressDone)
    {
      if (pnmh->code == LVN_INSERTITEM)
      {
        // Increment insert item count.
        iDetailCount++;

        // If the progress is 100 then we're done!
        if (iDetailCount == g_iProgressBarAdd)
          // We're done now. Let's stop updating the progress bar from now on.
          g_bFileProgressDone = TRUE;

        // Set new progress bar position.
        SendMessage(g_hProgressBarNew, PBM_SETPOS, (LPARAM)(g_iProgressBarPos + (g_iProgressBarIncrease / g_iProgressBarAdd * iDetailCount)), 0);

      }
    }
  }
  // Call the default window procedure if we haven't used our own.
  return CallWindowProc((WNDPROC)DlgProcOld, hWndDlg, uMsg, wParam, lParam);
}

// Handles window notifications sent from the child dialog for FileProgress.
static BOOL CALLBACK FileProgressDlgProc(HWND hWndDlg, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
  static NMHDR* pnmh;
  static HWND hDetails = GetDlgItem(g_hChildWnd, IDC_PROGRESSTEXT);
  static char szDetails[1024],
              szFileProgress[4];
  static int  iDetailsStrLen,
              iProgressBarInc;

  if (uMsg == WM_NOTIFY)
  {
    pnmh = (NMHDR *)lParam;
    if (pnmh->idFrom == IDC_PROGRESSLIST && !g_bFileProgressDone)
    {
      if (pnmh->code == LVN_INSERTITEM || pnmh->code == LVN_ITEMCHANGED)
      {
        iDetailsStrLen = GetWindowText(hDetails, szDetails, sizeof(szDetails))-1;
        if (iDetailsStrLen > 4)
        {
          // We've got a new string... does it have a % on the end?
          if (szDetails[iDetailsStrLen] == '%')
          {
            // Get the percent complete of the current file being extracted.
            GetPCComplete(szDetails, iDetailsStrLen, szFileProgress);
            iProgressBarInc = str2int(szFileProgress);

            // If the progress is 100 then we're done!
            if (iProgressBarInc == 100)
            {
              // We're done now. Let's stop updating the progress bar from now on.
              g_bFileProgressDone = TRUE;

              // Set final progress bar position.
              IncreaseProgressBarPos(g_iProgressBarAdd);
              SendMessage(g_hProgressBarNew, PBM_SETPOS, (LPARAM)g_iProgressBarPos, 0);

            }
            else
              // Set new progress bar position.
              SendMessage(g_hProgressBarNew, PBM_SETPOS, (LPARAM)(g_iProgressBarPos + (iProgressBarInc * g_iProgressBarAdd / 100)), 0);

          }
        }
      }
    }
  }
  // Call the default window procedure if we haven't used our own.
  return CallWindowProc((WNDPROC)DlgProcOld, hWndDlg, uMsg, wParam, lParam);
}

// Increases our progress bar by x per y seconds up to z!
BOOL WINAPI GradualProgressThread(LPVOID Param)
{
  int iProgressBarNewPos = g_iProgressBarPos - g_iProgressBarAdd,
      iGradualProgressIncrease = g_iProgressBarIncrease,
      iGradualProgressSeconds = g_iGradualProgressSeconds,
      iProgressBarEndPos   = g_iProgressBarPos;

  g_bGradualProgressThreadRunning = TRUE;

  do
  {
    // Pause execution for set amount of time.
    Sleep(iGradualProgressSeconds*1000);
    // Get the new progress bar value.
    iProgressBarNewPos += iGradualProgressIncrease;
    // Set the new progress bar value.
    SendMessage(g_hProgressBarNew, PBM_SETPOS, (LPARAM)(iProgressBarNewPos), 0);
  }
  while (iProgressBarNewPos < iProgressBarEndPos  && !g_bGradualProgressDone);

  // Set the final progress bar position.
  SendMessage(g_hProgressBarNew, PBM_SETPOS, (LPARAM)iProgressBarEndPos, 0);

  g_bGradualProgressDone = TRUE;
  g_bGradualProgressThreadRunning = FALSE;

  return TRUE;
}

// Adds our own progress bar to the InstFiles page, replacing the original.
// The original will be hidden (not destroyed).
void AddProgressBar()
{
  // Reset our progress bar position value.
  g_iProgressBarPos = 0;

  // Get the child window handle.
  if (!g_hChildWnd)
    g_hChildWnd = FindWindowEx(g_hWndParent, NULL, "#32770", NULL);

  // Assign our child window procedure.
  g_uMsgCreate = RegisterWindowMessage("nsis realprogress create");
  WndProcOld = (WNDPROC)SetWindowLongPtr(g_hChildWnd, GWLP_WNDPROC, (long)WndProc);
  // This causes the WndProc callback to be called so that we can do stuff right away!
  SendMessage(g_hChildWnd, g_uMsgCreate, TRUE, (LPARAM)g_hChildWnd);

}

extern "C"
void __declspec(dllexport) UseProgressBar(HWND hWndParent, int string_size, 
                                      char *variables, stack_t **stacktop,
                                      extra_parameters *extra)
{
  g_hWndParent=hWndParent;

  EXDLL_INIT();
  {
    char szParam[10];

    // Attempt to get a parameter.
    if (popstring(szParam) == 0)
    {

      // Get the child window handle.
      if (!g_hChildWnd)
        g_hChildWnd = FindWindowEx(g_hWndParent, NULL, "#32770", NULL);

      g_hProgressBarNew = GetDlgItem(g_hChildWnd, str2int(szParam));

      // If the plugin has not already been called,
      // add our new progress bar control.
      if (!g_bProgressBarAdded)
      {
        // We didn't add (create) our own progress bar.
        if (g_hProgressBarNew)
          g_bProgressBarAdded = TRUE;
        AddProgressBar();
      }

    }

  }
}

extern "C"
void __declspec(dllexport) GetProgress(HWND hWndParent, int string_size, 
                                      char *variables, stack_t **stacktop,
                                      extra_parameters *extra)
{
  g_hWndParent=hWndParent;

  EXDLL_INIT();
  {
    char szParam[10];
    int iRetVal;
    BOOL bOriginal = FALSE;

    // Attempt to get a parameter.
    if (popstring(szParam) == 0)
    {
      if (lstrcmpi(szParam, "/ORIGINAL") == 0)
      {
        iRetVal = (UINT)SendMessage(GetDlgItem(g_hChildWnd, IDC_PROGRESSBAR), PBM_GETPOS, 0, 0);
        bOriginal = TRUE;
      }
    }

    // If the plugin has not already been called,
    // add our new progress bar control.
    if (!g_bProgressBarAdded)
    {
      AddProgressBar();
      if (!bOriginal)
        iRetVal = 0;
    }
    else if (!bOriginal)
      iRetVal = g_iProgressBarPos;

    wsprintf(szParam, "%i", iRetVal);
    pushstring(szParam);

  }
}

extern "C"
void __declspec(dllexport) SetProgress(HWND hWndParent, int string_size, 
                                      char *variables, stack_t **stacktop,
                                      extra_parameters *extra)
{
  g_hWndParent=hWndParent;

  EXDLL_INIT();
  {
    char szParam[8];

    // Attempt to get a parameter.
    if (popstring(szParam) == 0)
    {

      // If the plugin has not already been called,
      // add our new progress bar control.
      if (!g_bProgressBarAdded)
        AddProgressBar();
      
      // What should we set the progress bar position to?
      g_iProgressBarPos = 0;
      IncreaseProgressBarPos(str2int(szParam));
      // Set the new progress bar value.
      SendMessage(g_hProgressBarNew, PBM_SETPOS, (LPARAM)g_iProgressBarPos, 0);

    }

  }
}

extern "C"
void __declspec(dllexport) AddProgress(HWND hWndParent, int string_size, 
                                      char *variables, stack_t **stacktop,
                                      extra_parameters *extra)
{
  g_hWndParent=hWndParent;

  EXDLL_INIT();
  {
    char szParam[8];

    // Attempt to get a parameter.
    if (popstring(szParam) == 0)
    {

      // If the plugin has not already been called,
      // add our new progress bar control.
      if (!g_bProgressBarAdded)
        AddProgressBar();
      
      // Increment the progress bar position.
      IncreaseProgressBarPos(str2int(szParam));
      // Set the new progress bar position.
      SendMessage(g_hProgressBarNew, PBM_SETPOS, (LPARAM)g_iProgressBarPos, 0);

    }

  }
}

extern "C"
void __declspec(dllexport) DetailProgress(HWND hWndParent, int string_size, 
                                      char *variables, stack_t **stacktop,
                                      extra_parameters *extra)
{
  g_hWndParent=hWndParent;

  EXDLL_INIT();
  {
    char szParam[8];

    // Attempt to get a parameter.
    if (popstring(szParam) == 0)
    {
      // Get the number of details to be printed.
      g_iProgressBarAdd = str2int(szParam);

      if (popstring(szParam) == 0)
      {
        // Get the amount to increment the progress bar by for the proceding details.
        g_iProgressBarIncrease = str2int(szParam);

        // If the plugin has not already been called,
        // add our new progress bar control.
        if (!g_bProgressBarAdded)
          AddProgressBar();

	      // Assign our child dialog procedure.
        if (!DlgProcOld)
	        DlgProcOld = (DLGPROC)SetWindowLongPtr(g_hChildWnd, DWLP_DLGPROC, (long)DetailProgressDlgProc);
        else
          SetWindowLongPtr(g_hChildWnd, DWLP_DLGPROC, (long)DetailProgressDlgProc);

        // If this was TRUE, our dialog procedure code would not be executed!
        g_bFileProgressDone = FALSE;
      }

    }
  }
}

extern "C"
void __declspec(dllexport) GradualProgress(HWND hWndParent, int string_size, 
                                      char *variables, stack_t **stacktop,
                                      extra_parameters *extra)
{
  g_hWndParent=hWndParent;

  EXDLL_INIT();
  {
    char szParam[32];
    LPDWORD ThreadID = 0;

    // Attempt to get a parameter.
    if (popstring(szParam) == 0)
    {
      // Get the amount of time to increment the progress bar by.
      g_iGradualProgressSeconds = str2int(szParam);

    // Attempt to get a second parameter.
    if (popstring(szParam) == 0)
    {
      // Get the amount to increment the progress bar by each time.
      g_iProgressBarIncrease = str2int(szParam);

    // Attempt to get a third parameter.
    if (popstring(szParam) == 0)
    {
      // Get the amount to increment the progress bar by.
      g_iProgressBarAdd = str2int(szParam);

    // Attempt to get a fourth parameter.
    if (popstring(szParam) == 0)
    {
      lstrcpy(g_szGradualProgressStopAt, szParam);
      g_bGradualProgressStop = TRUE;
    }
    else
      g_bGradualProgressStop = FALSE;

      // If the plugin has not already been called,
      // add our new progress bar control.
      if (!g_bProgressBarAdded)
        AddProgressBar();

	    // Assign our child dialog procedure.
      if (!DlgProcOld)
	      DlgProcOld = (DLGPROC)SetWindowLongPtr(g_hChildWnd, DWLP_DLGPROC, (LONG)GradualProgressDlgProc);
      else
        SetWindowLongPtr(g_hChildWnd, DWLP_DLGPROC, (LONG)GradualProgressDlgProc);

      // If any previous threads are running, close them.
      if (g_hGradualProgressThread)
        CloseHandle(g_hGradualProgressThread);

      // If this was TRUE, our thread code would not be executed!
      g_bGradualProgressDone = TRUE;
      while (g_bGradualProgressThreadRunning)
      {
        Sleep(50);
      }
      g_bGradualProgressDone = FALSE;

      IncreaseProgressBarPos(g_iProgressBarAdd);

      // Start our thread to increase the progress bar.
      g_hGradualProgressThread = CreateThread(
                            (LPSECURITY_ATTRIBUTES)NULL,
                            0,
                            (LPTHREAD_START_ROUTINE)GradualProgressThread,
                            (LPVOID)NULL,
                            0,
                            (LPDWORD)ThreadID
                            );

    }
    }
    }

  }
}

extern "C"
void __declspec(dllexport) FileProgress(HWND hWndParent, int string_size, 
                                      char *variables, stack_t **stacktop,
                                      extra_parameters *extra)
{
  g_hWndParent=hWndParent;

  EXDLL_INIT();
  {
    char szParam[8];

    // Attempt to get a parameter.
    if (popstring(szParam) == 0)
    {
      // Get the amount to increment the progress bar by for the proceding file.
      g_iProgressBarAdd = str2int(szParam);

      // If the plugin has not already been called,
      // add our new progress bar control.
      if (!g_bProgressBarAdded)
        AddProgressBar();

	    // Assign our child dialog procedure.
      if (!DlgProcOld)
	      DlgProcOld = (DLGPROC)SetWindowLongPtr(g_hChildWnd, DWLP_DLGPROC, (LONG)FileProgressDlgProc);
      else
        SetWindowLongPtr(g_hChildWnd, DWLP_DLGPROC, (LONG)FileProgressDlgProc);

      // If this was TRUE, our dialog procedure code would not be executed!
      g_bFileProgressDone = FALSE;

    }

  }
}

extern "C"
void __declspec(dllexport) Unload(HWND hWndParent, int string_size, 
                                      char *variables, stack_t **stacktop,
                                      extra_parameters *extra)
{
  g_hWndParent=hWndParent;

  EXDLL_INIT();
  {
    // We don't need to handle any more window notifications.
    // Give control back to the installer.
	  SetWindowLongPtr(g_hChildWnd, GWLP_WNDPROC, (LONG)WndProcOld);
	  SendMessage(g_hChildWnd, g_uMsgCreate, FALSE, (LPARAM)g_hChildWnd);
    if (DlgProcOld)
	    SetWindowLongPtr(g_hChildWnd, DWLP_DLGPROC, (LONG)DlgProcOld);

    // If any previous threads are running, close them.
    if (g_hGradualProgressThread)
    {
      g_bGradualProgressDone = TRUE;
      CloseHandle(g_hGradualProgressThread);
    }
  }
}

BOOL WINAPI DllMain(HANDLE hInstNew,
                    ULONG ul_reason_for_call,
                    LPVOID lpReserved)
{
    g_hInst=(HINSTANCE)hInstNew;
    return TRUE;
}

// Get percent complete of current file being extracted.
void GetPCComplete(char *szDetails, int iDetailsStrLen, char *szFileProgress)
{
      int iFileProgressStrLen = 0, i;

      // Find how many characters make up the extraction progress value (e.g. 99% is 2 chars)
      for (i=iDetailsStrLen-1; i>=iDetailsStrLen-4; i--)
      {
        // If we meet a space character, then we are at the end of the % complete value.
        if (szDetails[i] != ' ')
          iFileProgressStrLen++;
        else
          break;
      }

      // Grab the extraction progress value from the details label string.
      for (i=0; i<iFileProgressStrLen; i++)
        szFileProgress[i] = szDetails[iDetailsStrLen-iFileProgressStrLen+i];
      szFileProgress[iFileProgressStrLen] = '\0';
}

// Gets number of chars in char array.
unsigned int CharArrayLen(char *s)
{
  for (int i=0; i<1024; i++)
  {
    if (s[i] == '\0')
      return i;
  }
  return 0;
}

// Function: Converts char to int
int str2int(char *p)
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
