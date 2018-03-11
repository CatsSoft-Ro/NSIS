#include <windows.h>
#include <Richedit.h>

#ifdef UNICODE
#include "nsis_unicode\pluginapi.h"
#else
#include "nsis_ansi\pluginapi.h"
#endif

#define HEADER_FOOTER_MARGIN_SIZE 50 // Pixels
#define PAGE_MARGIN_SIZE 1000 // Twips
#define IDC_PRINT_BUTTON 1001

#define NSISFUNC(name) extern "C" void __declspec(dllexport) name(HWND hWndParent, int string_size, TCHAR* variables, stack_t** stacktop, extra_parameters* extra)
#define DLL_INIT() g_hWndParent = hWndParent; EXDLL_INIT()

HINSTANCE g_hInstance;
HWND g_hWndParent;
WNDPROC g_pWndProcOld;
TCHAR* g_pszDocName = NULL;

BOOL PrintRichEdit(HWND hRichEdit, TCHAR* pszDocName);

static UINT_PTR PluginCallback(enum NSPIM msg)
{
  if (msg == NSPIM_UNLOAD)
  {
    if (g_pszDocName)
      LocalFree(g_pszDocName);
  }
  return 0;
}

void MyZeroMemory(PVOID ptr, UINT len)
{
  for (UINT i = 0; i < len; i++)
    *((PBYTE)((PBYTE)ptr)+i) = 0;
}

BOOL CALLBACK InnerDlgWndProc(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
  if (uMsg == WM_COMMAND)
  {
    if (HIWORD(wParam) == BN_CLICKED && LOWORD(wParam) == IDC_PRINT_BUTTON)
    {
      PrintRichEdit(GetDlgItem(hWnd, 1000), g_pszDocName);
      return FALSE;
    }
  }
  return CallWindowProc(g_pWndProcOld, hWnd, uMsg, wParam, lParam);
}

NSISFUNC(AddPrintButton)
{
  DLL_INIT();

  TCHAR* pszButtonText = (TCHAR*)LocalAlloc(LMEM_FIXED, sizeof(TCHAR) * string_size);
  if (pszButtonText)
  {
    if (popstring(pszButtonText) == 0)
    {
      if (!g_pszDocName)
        g_pszDocName = (TCHAR*)LocalAlloc(LMEM_FIXED, sizeof(TCHAR) * string_size);
      if (g_pszDocName)
        popstring(g_pszDocName);

      HWND hInnerDlg = FindWindowEx(hWndParent, NULL, TEXT("#32770"), NULL);
      if (IsWindow(hInnerDlg))
      {
        // Get the static text for the rich edit control.
        HWND hStatic = GetDlgItem(hInnerDlg, 1006);
        if (IsWindow(hStatic))
        {
          // Add the button.
          RECT rcStatic, rcButton;
          GetWindowRect(hStatic, &rcStatic);
          MapWindowPoints(HWND_DESKTOP, hInnerDlg, (LPPOINT)&rcStatic, 2);
          GetClientRect(GetDlgItem(hWndParent, 1), &rcButton);
          HWND hButton = CreateWindow(TEXT("BUTTON"), pszButtonText, WS_CHILD | WS_VISIBLE | WS_CLIPSIBLINGS | WS_TABSTOP | BS_DEFPUSHBUTTON, rcStatic.right - rcButton.right, rcStatic.top, rcButton.right, rcButton.bottom, hInnerDlg, (HMENU)IDC_PRINT_BUTTON, g_hInstance, NULL);

          // Change its font to that that the other buttons use.
          HFONT hFont = (HFONT)SendMessage(GetDlgItem(hWndParent, 1), WM_GETFONT, 0, 0);
          SendMessage(hButton, WM_SETFONT, (WPARAM)hFont, 0);

          // Resize the static text so that it is out of the way.
          RECT rcStaticClient;
          GetClientRect(hStatic, &rcStaticClient);
          SetWindowPos(hStatic, NULL, 0, 0, rcStaticClient.right - rcButton.right - 4, rcStaticClient.bottom + 4, SWP_NOMOVE | SWP_NOZORDER);

          // Assign a click handler.
          extra->RegisterPluginCallback((HMODULE)g_hInstance, PluginCallback);
          g_pWndProcOld = (WNDPROC)SetWindowLongPtr(hInnerDlg, GWL_WNDPROC, (LONG)InnerDlgWndProc);
        }
      }
    }

    LocalFree(pszButtonText);
  }
}

DWORD CALLBACK EditStreamCallback(DWORD_PTR dwCookie, LPBYTE pbBuff, LONG cb, LONG* pcb)
{
  ReadFile((HANDLE)dwCookie, pbBuff, cb, (LPDWORD)pcb, NULL);
  return 0;
}

NSISFUNC(Load)
{
  DLL_INIT();

  TCHAR* pszArg = (TCHAR*)LocalAlloc(LMEM_FIXED, sizeof(TCHAR) * string_size);
  if (pszArg)
  {
    if (popstring(pszArg) == 0)
    {
      HWND hRichEdit = (HWND)myatoi(pszArg);
      if (popstring(pszArg) == 0 && IsWindow(hRichEdit))
      {
        SendMessage(hRichEdit, EM_EXLIMITTEXT, 0, 0x7fffffff);

        HANDLE hFile = CreateFile(pszArg, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, 0, NULL);
        if (hFile != INVALID_HANDLE_VALUE)
        {
          EDITSTREAM stEditStream;
          stEditStream.dwCookie = (DWORD_PTR)hFile;
          stEditStream.dwError = 0;
          stEditStream.pfnCallback = EditStreamCallback;

          int i = lstrlen(pszArg) - 1;
          if (pszArg[i] == TEXT('f') && pszArg[--i] == TEXT('t') && pszArg[--i] == TEXT('r') && pszArg[--i] == TEXT('.'))
            SendMessage(hRichEdit, EM_STREAMIN, SF_RTF, (LPARAM)&stEditStream);
          else
            SendMessage(hRichEdit, EM_STREAMIN, SF_TEXT, (LPARAM)&stEditStream);
          
          CloseHandle(hFile);
        }
      }
    }

    LocalFree(pszArg);
  }
}

NSISFUNC(Print)
{
  DLL_INIT();
  
  BOOL fSuccess = FALSE;

  TCHAR* pszArg = (TCHAR*)LocalAlloc(LMEM_FIXED, sizeof(TCHAR) * string_size);
  if (pszArg)
  {
    if (popstring(pszArg) == 0)
    {
      HWND hRichEdit = (HWND)myatoi(pszArg);
      if (popstring(pszArg) == 0 && IsWindow(hRichEdit))
      {
        fSuccess = PrintRichEdit(hRichEdit, pszArg);
      }
    }

    LocalFree(pszArg);
  }

  if (fSuccess == TRUE)
    pushstring(TEXT("OK"));
  else if (fSuccess == 2)
    pushstring(TEXT("CANCEL"));
  else
    pushstring(TEXT("ERROR"));
}

BOOL PrintRichEdit(HWND hRichEdit, TCHAR* pszDocName)
{
  BOOL fSuccess = FALSE;

  PRINTDLG pd;
  MyZeroMemory(&pd, sizeof(pd));
  pd.lStructSize = sizeof(pd);
  pd.Flags = PD_RETURNDC | PD_USEDEVMODECOPIESANDCOLLATE;
  pd.hwndOwner = g_hWndParent;
  pd.hInstance = g_hInstance;
    
  if (PrintDlg(&pd))
  {
    DOCINFO di;
    MyZeroMemory(&di, sizeof(di));
    di.cbSize = sizeof(di);
    di.lpszDocName = pszDocName;

    int result = StartDoc(pd.hDC, &di);
    if (result > 0)
    {
      int cxPPI = GetDeviceCaps(pd.hDC, LOGPIXELSX);
      int cyPPI = GetDeviceCaps(pd.hDC, LOGPIXELSY);
      int cxPhys = MulDiv(GetDeviceCaps(pd.hDC, PHYSICALWIDTH), 1440, cxPPI);
      int cyPhys = MulDiv(GetDeviceCaps(pd.hDC, PHYSICALHEIGHT), 1440, cyPPI);

      if (cxPhys > 0 && cyPhys > 0)
      {
        int cxRes = GetDeviceCaps(pd.hDC, HORZRES);
        int cyRes = GetDeviceCaps(pd.hDC, VERTRES);
        int cxPhysOffset = MulDiv(GetDeviceCaps(pd.hDC, PHYSICALOFFSETX), 1440, cxPPI);
        int cyPhysOffset = MulDiv(GetDeviceCaps(pd.hDC, PHYSICALOFFSETY), 1440, cyPPI);

        FORMATRANGE fr;
        fr.hdc = pd.hDC;
        fr.hdcTarget = pd.hDC;
        fr.rcPage.top = 0;
        fr.rcPage.left = 0;
        fr.rcPage.bottom = cyPhys;
        fr.rcPage.right = cxPhys;
        fr.rc.top = PAGE_MARGIN_SIZE - cyPhysOffset;
        fr.rc.left = PAGE_MARGIN_SIZE - cxPhysOffset;
        fr.rc.bottom = cyPhys - PAGE_MARGIN_SIZE - cyPhysOffset;
        fr.rc.right = cxPhys - PAGE_MARGIN_SIZE - cxPhysOffset;

        if ((pd.Flags & PD_SELECTION) == 0)
          SendMessage(hRichEdit, EM_SETSEL, 0, (LPARAM)-1);
        SendMessage(hRichEdit, EM_EXGETSEL, 0, (LPARAM)&fr.chrg);
              
        // Font used for header and footer.
        HFONT hFont = CreateFont(-MulDiv(10, cyPPI, 72), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, TEXT("Times New Roman"));

        // Get date and time.
        TCHAR* pszDateTime = (TCHAR*)LocalAlloc(LMEM_FIXED, sizeof(TCHAR) * g_stringsize);
        if (pszDateTime)
        {
          SYSTEMTIME time;
          GetSystemTime(&time);
          GetDateFormat(LOCALE_SYSTEM_DEFAULT, 0, &time, NULL, pszDateTime, g_stringsize);
          lstrcat(pszDateTime, TEXT(" "));
          GetTimeFormat(LOCALE_SYSTEM_DEFAULT, TIME_NOSECONDS, &time, NULL, pszDateTime + lstrlen(pszDateTime), g_stringsize);
        }

        TCHAR* pszPage = (TCHAR*)LocalAlloc(LMEM_FIXED, sizeof(TCHAR) * g_stringsize);
        int nPage = 0;

        fSuccess = TRUE;

        while (fr.chrg.cpMin < fr.chrg.cpMax && fSuccess) 
        {
          fSuccess = StartPage(pd.hDC) > 0;
          if (!fSuccess)
            break;

          // Print header and footer.
          if (di.lpszDocName || pszDateTime || pszPage)
          {
            HFONT hFontOld = (HFONT)SelectObject(pd.hDC, hFont);
            SIZE s;
            RECT r;
            GetTextExtentPoint(pd.hDC, di.lpszDocName, lstrlen(di.lpszDocName), &s);
            r.top = HEADER_FOOTER_MARGIN_SIZE;
            r.left = HEADER_FOOTER_MARGIN_SIZE;
            r.bottom = s.cy + HEADER_FOOTER_MARGIN_SIZE;
            r.right = cxRes - HEADER_FOOTER_MARGIN_SIZE;
            if (di.lpszDocName)
            {
              DrawText(pd.hDC, di.lpszDocName, -1, &r, DT_NOPREFIX | DT_LEFT);
            }
            if (pszDateTime)
            {
              DrawText(pd.hDC, pszDateTime, -1, &r, DT_RIGHT);
            }
            if (pszPage)
            {
              r.top = cyRes - s.cy - HEADER_FOOTER_MARGIN_SIZE;
              r.bottom = cyRes - HEADER_FOOTER_MARGIN_SIZE;
              wsprintf(pszPage, TEXT("%d"), ++nPage);
              DrawText(pd.hDC, pszPage, -1, &r, DT_CENTER);
            }
            SelectObject(pd.hDC, hFontOld);
          }
        
          // Print the page.
          int cpMin = SendMessage(hRichEdit, EM_FORMATRANGE, TRUE, (LPARAM)&fr);
          if (cpMin <= fr.chrg.cpMin) 
          {
            fSuccess = FALSE;
            break;
          }
        
          fr.chrg.cpMin = cpMin;
          fSuccess = EndPage(pd.hDC) > 0;
        }
    
        DeleteObject(hFont);
        if (pszDateTime)
          LocalFree(pszDateTime);
        if (pszPage)
          LocalFree(pszPage);

        // Done printing.
        SendMessage(hRichEdit, EM_FORMATRANGE, FALSE, 0);
    
        if (fSuccess)
          EndDoc(pd.hDC);
        else
          AbortDoc(pd.hDC);
        DeleteDC(pd.hDC);
      }
    }
    else if (result == -1)
      fSuccess = 2;
  }
  else
    fSuccess = 2;

  return fSuccess;
}

BOOL WINAPI DllMain(HANDLE hInst, ULONG ul_reason_for_call, LPVOID lpReserved)
{
  g_hInstance = (HINSTANCE)hInst;
  return TRUE;
}