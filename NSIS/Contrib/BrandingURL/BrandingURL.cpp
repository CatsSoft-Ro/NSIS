#include <windows.h>
#include "..\ExDll\exdll.h"

/**
    BrandingURL v0.1 by Afrow UK
    Set branding text to a clickable link.

    Last build: 7th June 2007
    Microsoft Visual C++ 6
*/

// Global variables.
HINSTANCE g_hInstance;
HWND g_hWndParent;
HFONT hFont, hFontUnderline;
COLORREF crHyperlink;
WNDPROC ParentWndProcOld, StaticWndProcOld;
HCURSOR hCursor;
char szURL[256];

#define PROP_STATIC_HYPERLINK TEXT("_Plugin_Static_Hyperlink_")

#define IDC_BRANDING 1028

#ifndef IDC_HAND
#define IDC_HAND MAKEINTRESOURCE(32649)
#endif

#ifndef GetWindowLongPtr
#define GetWindowLongPtr GetWindowLong
#endif

#ifndef SetWindowLongPtr
#define SetWindowLongPtr SetWindowLong
#endif

#ifndef GWLP_WNDPROC
#define GWLP_WNDPROC GWL_WNDPROC
#endif

int my_atoi(char *p);

// Handles WM_CTLCOLORSTATIC for the parent window.
LRESULT CALLBACK ParentWndProc(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
  switch (uMsg)
  {
    case WM_COMMAND:
    {
      if (LOWORD(wParam) == IDC_BRANDING)
      {
        ShellExecute(hWnd, "open", szURL, NULL, NULL, SW_SHOWNORMAL);
        return TRUE;
      }
      break;
    }
    case WM_CTLCOLORSTATIC:
    {
      HDC  hDC  = (HDC) wParam;
      HWND hCtl = (HWND)lParam;
      BOOL bHyperlink = (NULL != GetProp(hCtl, PROP_STATIC_HYPERLINK));
      if (bHyperlink)
      {
        LRESULT lr = CallWindowProc(ParentWndProcOld, hWnd, uMsg, wParam, lParam);
        SetTextColor(hDC, crHyperlink);
        return lr;
      }
    }
  }
  // Let NSIS handle everything else.
  return CallWindowProc(ParentWndProcOld, hWnd, uMsg, wParam, lParam);
}

// Handles WM_SETCURSOR for the static control window.
LRESULT CALLBACK StaticWndProc(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
  HWND hCtl = (HWND)lParam;
  switch (uMsg)
  {
    case WM_SETCURSOR:
    {
      SetCursor(hCursor);
      return FALSE;
    }
    case WM_MOUSEMOVE:
    {
      if (GetCapture() != hWnd)
      {
        SendMessage(hWnd, WM_SETFONT, (WPARAM)hFont, 0);
        InvalidateRect(hWnd, NULL, FALSE);
        SetCapture(hWnd);
      }
      else
      {
        RECT r;
        GetWindowRect(hWnd, &r);

        POINT p = {LOWORD(lParam), HIWORD(lParam)};
        ClientToScreen(hWnd, &p);

        if (!PtInRect(&r, p))
        {
          SendMessage(hWnd, WM_SETFONT, (WPARAM)hFontUnderline, 0);
          InvalidateRect(hWnd, NULL, FALSE);
          ReleaseCapture();
        }
      }
      break;
    }
  }
  // Let NSIS handle everything else.
  return CallWindowProc(StaticWndProcOld, hWnd, uMsg, wParam, lParam);
}


// Sub-class child and parent window procedures so that we can set our own cursors.
extern "C" void __declspec(dllexport) Set(HWND hWndParent, int string_size, 
                                      char *variables, stack_t **stacktop,
                                      extra_parameters *extra)
{
  g_hWndParent = hWndParent;
  EXDLL_INIT();
  {
    int r, g, b;
    LOGFONT lFont;
    HWND hStatic;
    DWORD dwStyle;

    // Get colors.
    popstring(szURL);
    if (!*szURL)
      r = 0;
    else
      r = my_atoi(szURL);

    popstring(szURL);
    if (!*szURL)
      g = 0;
    else
      g = my_atoi(szURL);

    popstring(szURL);
    if (!*szURL)
      b = 255;
    else
      b = my_atoi(szURL);

    crHyperlink = RGB(r, g, b);

    // Get static handle.
    hStatic = GetDlgItem(hWndParent, IDC_BRANDING);

    // Get URL.
    popstring(szURL);

    // Make static send notify to parent.
    dwStyle = GetWindowLongPtr(hStatic, GWL_STYLE);
    SetWindowLongPtr(hStatic, GWL_STYLE, dwStyle | SS_NOTIFY);
    SetProp(hStatic, PROP_STATIC_HYPERLINK, (HANDLE)TRUE);

    // Underline static text.
    hFont = (HFONT)SendMessage(hStatic, WM_GETFONT, 0, 0);
    GetObject(hFont, sizeof(lFont), &lFont);
    lFont.lfUnderline = TRUE;
    hFontUnderline = CreateFontIndirect(&lFont);
    SendMessage(hStatic, WM_SETFONT, (WPARAM)hFontUnderline, 0);

    // Create cursor for mouse-over.
    hCursor = (HCURSOR)LoadImage(NULL, IDC_HAND, IMAGE_CURSOR, 0, 0, LR_DEFAULTSIZE | LR_SHARED);
    if (NULL == hCursor)
      hCursor = (HCURSOR)LoadImage(NULL, IDC_ARROW, IMAGE_CURSOR, 0, 0, LR_DEFAULTSIZE | LR_SHARED);

    // Enable static control.
    EnableWindow(hStatic, TRUE);

    // Subclass windows.
    ParentWndProcOld = (WNDPROC)SetWindowLongPtr(g_hWndParent, GWLP_WNDPROC, (LONG)ParentWndProc);
    StaticWndProcOld = (WNDPROC)SetWindowLongPtr(hStatic,      GWLP_WNDPROC, (LONG)StaticWndProc);

    RedrawWindow(hStatic, 0, 0, RDW_INVALIDATE | RDW_UPDATENOW | RDW_ERASE);
  }
}

// Reset window procedures back to originals.
extern "C" void __declspec(dllexport) Unload(HWND hWndParent, int string_size, 
                                      char *variables, stack_t **stacktop,
                                      extra_parameters *extra)
{
  g_hWndParent = hWndParent;
  EXDLL_INIT();
  {
    HWND hStatic = GetDlgItem(hWndParent, IDC_BRANDING);
    SetWindowLongPtr(g_hWndParent, GWLP_WNDPROC, (LONG)ParentWndProcOld);
    SetWindowLongPtr(hStatic,      GWLP_WNDPROC, (LONG)StaticWndProcOld);
  }
}

BOOL WINAPI DllMain(HINSTANCE hInst, ULONG ul_reason_for_call, LPVOID lpReserved)
{
  g_hInstance = hInst;
	return TRUE;
}

// Converts char to int
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