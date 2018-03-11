#include <windows.h>
#ifdef UNICODE
#include "nsis_unicode\pluginapi.h"
#else
#include "nsis_ansi\pluginapi.h"
#endif

// -------------------------------------------------------------------------------------------
// ButtonEvent v0.8
//  4th May 2011
//
// NSIS plugin that sub-classes the inner dialog and catched button click events.
// Allows NSIS coder to add their own button and tie a NSIS function to it.

// Maximum number of buttons.
#define BUTTON_MAX 8

// Global variables.
// [[

HINSTANCE g_hInstance;
HWND      g_hWndParent;
HWND      g_hWndChild = NULL;
DLGPROC   ParentDlgProcOld = NULL;
DLGPROC   ChildDlgProcOld = NULL;
int       g_arr_iIDCs[BUTTON_MAX];  // Array of control ID's.
int       g_arr_iFuncs[BUTTON_MAX]; // Array of event NSIS function addresses.
int       g_iIDCs = 0;     // Control Id index.
int       g_iNotifyId;
extra_parameters* g_ep;

// ]]

#define NSISFUNC(name) extern "C" void __declspec(dllexport) name(HWND hWndParent, int string_size, TCHAR* variables, stack_t** stacktop, extra_parameters* extra)
#define DLL_INIT() \
{ \
  g_hWndParent = hWndParent; \
  g_ep = extra; \
  EXDLL_INIT(); \
  extra->RegisterPluginCallback(g_hInstance, PluginCallback); \
}

void ExecNSISFunc(int iIDC)
{
  // Loop through buttons till we find the corrent one.
  for (int i = 0; i < g_iIDCs; i++)
  {
    // Is the button user just clicked on one of them?
    if (iIDC == g_arr_iIDCs[i])
    {
      if (g_arr_iFuncs[i] == -1)
      {
        PostMessage(g_hWndParent, WM_NOTIFY_OUTER_NEXT, 1, i+1);
      }
      else
      {
        g_iNotifyId = g_arr_iIDCs[i];
        g_ep->ExecuteCodeSegment(g_arr_iFuncs[i]-1, 0);
        g_iNotifyId = 0;
      }
    }
  }
}

// Callback function to handle the parent dialog.
BOOL CALLBACK ChildDlgProc(HWND hWndDlg, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
  // Command notification sent?
  if (uMsg == WM_COMMAND)
  {
    // Button pressed?
    if (HIWORD(wParam) == BN_CLICKED)
      if (GetDlgItem(hWndDlg, LOWORD(wParam)))
        ExecNSISFunc(LOWORD(wParam));
  }
  // We're done here.
  // Let NSIS carry on from now and handle its own stuff.
	return CallWindowProc((WNDPROC)ChildDlgProcOld, hWndDlg, uMsg, wParam, lParam);
}

// Callback function to handle the parent dialog.
BOOL CALLBACK ParentDlgProc(HWND hWndDlg, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
  // Command notification sent?
  if (uMsg == WM_COMMAND)
  {
    // Button pressed?
    if (HIWORD(wParam) == BN_CLICKED)
      if (GetDlgItem(hWndDlg, LOWORD(wParam)))
        ExecNSISFunc(LOWORD(wParam));
  }
  else if (uMsg == WM_NOTIFY_OUTER_NEXT)
  {
    if (lParam > 0)
      g_iNotifyId = g_arr_iIDCs[(int)lParam - 1];
    else
      g_iNotifyId = 0;
  }
  // We're done here.
  // Let NSIS carry on from now and handle its own stuff.
	return CallWindowProc((WNDPROC)ParentDlgProcOld, hWndDlg, uMsg, wParam, lParam);
}

// Plugin callback for new plugin API.
static UINT_PTR PluginCallback(enum NSPIM msg)
{
  if (msg == NSPIM_GUIUNLOAD)
  {
    // Reset variables just in case.
    g_iIDCs = 0;
  }
  return 0;
}

// NSIS Function: Adds a click event handler to a button.
NSISFUNC(AddEventHandler)
{
  DLL_INIT();

  // Button count limit reached.
  if (g_iIDCs == BUTTON_MAX)
    return;

  PTCHAR pszParam = (PTCHAR)GlobalAlloc(GPTR, sizeof(TCHAR)*string_size);

  // Get button control ID to add event handler to.
  if (popstring(pszParam) != 0)
    goto cleanup;

  int iIDC = myatoi(pszParam);

  // Check that the control isn't already handled.
  BOOL bSet = FALSE;
  for (int i = 0; i < g_iIDCs; i++)
  {
    if (g_arr_iIDCs[i] == iIDC)
    {
      bSet = TRUE;
      break;
    }
  }

  if (!bSet)
  {
    // Get address of NSIS function to execute.
    if (popstring(pszParam) != 0)
      goto cleanup;

    g_arr_iIDCs[g_iIDCs] = iIDC;

    if (lstrcmpi(pszParam, TEXT("/NOTIFY")) == 0)
      g_arr_iFuncs[g_iIDCs] = -1;
    else
      g_arr_iFuncs[g_iIDCs] = myatoi(pszParam);

    g_iIDCs++;
  }

  // Set parent dialog procedure to our own (subclass window).
  if (!ParentDlgProcOld)
    ParentDlgProcOld = (DLGPROC)SetWindowLongPtr(hWndParent, DWLP_DLGPROC, (LONG)ParentDlgProc);

  // We need to sub-class the inner window.
  if (!GetDlgItem(hWndParent, iIDC))
  {
    // Get handle of child window for use later.
    HWND hWndChild = FindWindowEx(hWndParent, NULL, TEXT("#32770"), NULL);

    // Only subclass if the inner window is a new window (otherwise crash!)
    if (g_hWndChild != hWndChild)
    {
      g_hWndChild = hWndChild;

      // Set child dialog procedure to our own (subclass window).
      ChildDlgProcOld = (DLGPROC)SetWindowLongPtr(g_hWndChild, DWLP_DLGPROC, (LONG)ChildDlgProc);
    }
  }

cleanup:
  GlobalFree(pszParam);
}

// NSIS Function: Returns the last button ID clicked on.
NSISFUNC(WhichButtonId)
{
  DLL_INIT();

  TCHAR szOut[8];
  wsprintf(szOut, TEXT("%d"), g_iNotifyId);
  pushstring(szOut);
  g_iNotifyId = 0; // Just for safety.
}

// NSIS Function: Removes a button ID from the buttons Id's list.
NSISFUNC(UnsetEventHandler)
{
  DLL_INIT();

  PTCHAR pszParam = (PTCHAR)GlobalAlloc(GPTR, sizeof(TCHAR)*string_size);
  int i = 0, iIDC;
  BOOL bSet = FALSE;

  popstring(pszParam);
  iIDC = myatoi(pszParam);

  while (i < g_iIDCs)
  {
    if (g_arr_iIDCs[i] == iIDC)
    {
      bSet = TRUE;
      break;
    }
    i++;
  }

  if (bSet)
  {
    i++;
    while (i<g_iIDCs)
    {
      g_arr_iIDCs[i-1] = g_arr_iIDCs[i];
      i++;
    }

    g_iIDCs--;
  }

  GlobalFree(pszParam);
}

// Entry point for DLL.
BOOL WINAPI DllMain(HINSTANCE hInst, ULONG ul_reason_for_call, LPVOID lpReserved)
{
  g_hInstance = hInst;
  return TRUE;
}