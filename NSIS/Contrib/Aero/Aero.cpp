/*
  Aero NSIS plug-in by Stuart Welch <afrowuk@afrowsoft.co.uk>
*/

#include <windows.h>
#include "aero.h"

#ifdef UNICODE
#include "nsis_unicode\pluginapi.h"
#else
#include "nsis_ansi\pluginapi.h"
#endif

HANDLE  g_hInstance;
HWND    g_hWndParent, g_hBack, g_hNext, g_hCancel, g_hBrandingText;
PWCHAR  g_pwszBack, g_pwszNext, g_pwszCancel;
WNDPROC ParentDlgProcOld;
MARGINS g_margins;
RECT    g_rectAero, g_rectWindow;
RECT    g_rectBrandingText, g_rect1035, g_rect1045, g_rect1256, g_rectCancel, g_rectBack, g_rectNext;
HBRUSH  g_hbAero;
HTHEME  g_hWindowTheme, g_hButtonTheme;
BOOL    g_fDrawBrandingText, g_fDrawButtonText, g_fClassicUI, g_fRTL;

static UINT_PTR PluginCallback(enum NSPIM msg)
{
  if (msg == NSPIM_GUIUNLOAD)
  {
    if (g_hbAero != NULL)
      DeleteObject(g_hbAero);
    if (g_hWindowTheme != NULL)
      CloseThemeData(g_hWindowTheme);
    if (g_hButtonTheme != NULL)
      CloseThemeData(g_hButtonTheme);
    if (g_pwszBack != NULL)
      GlobalFree(g_pwszBack);
    if (g_pwszNext != NULL)
      GlobalFree(g_pwszNext);
    if (g_pwszCancel != NULL)
      GlobalFree(g_pwszCancel);
    BufferedPaintUnInit();
  }
  return 0;
}

#define GetButtonTextBuffer(hWnd) (hWnd == g_hBack ? g_pwszBack : hWnd == g_hCancel ? g_pwszCancel : g_pwszNext)

// Saves the given ANSI text to the given Unicode char buffer.
void SaveButtonText(PTCHAR pszText, PWCHAR* ppwszBuffer)
{
  if (*ppwszBuffer != NULL)
    GlobalFree(*ppwszBuffer);

  int cchLen = lstrlen(pszText);
  *ppwszBuffer = (PWCHAR)GlobalAlloc(GPTR, sizeof(WCHAR) * (cchLen + 1));
  if (*ppwszBuffer)
#ifdef UNICODE
    lstrcpy(*ppwszBuffer, pszText);
#else
    MultiByteToWideChar(CP_ACP, MB_PRECOMPOSED, pszText, cchLen, *ppwszBuffer, cchLen);
#endif
}

// Reloads the given Unicode char buffer with the text from the given window before clearing the given window's text.
void RefreshSavedButtonText(HWND hWnd, PWCHAR* ppwszBuffer)
{
  if (*ppwszBuffer != NULL)
    GlobalFree(*ppwszBuffer);

  int cchLen = GetWindowTextLength(hWnd) + 1;
  *ppwszBuffer = (PWCHAR)GlobalAlloc(GPTR, sizeof(WCHAR) * cchLen);
  if (*ppwszBuffer)
  {
    GetWindowTextW(hWnd, *ppwszBuffer, cchLen);
    SetWindowText(hWnd, TEXT(""));
  }
}

int GetButtonState(HWND hWnd)
{
  int iState;

  if (GetWindowLongPtr(hWnd, GWL_STYLE) & WS_DISABLED)
    iState = PBS_DISABLED;
  else
    iState = PBS_NORMAL;

  return iState;
}

void AeroDisable(HWND hWnd)
{
  // Restore control positions.
  SetWindowPos(GetDlgItem(hWnd, 1028), 0, g_rectBrandingText.left, g_rectBrandingText.top, 0, 0, SWP_NOSIZE | SWP_NOZORDER);
  if (g_fClassicUI)
  {
    ShowWindow(GetDlgItem(hWnd, -1), SW_SHOW);
    SetWindowPos(GetDlgItem(hWnd, 1), 0, g_rectNext.left, g_rectNext.top, 0, 0, SWP_NOSIZE | SWP_NOZORDER);
    SetWindowPos(GetDlgItem(hWnd, 2), 0, g_rectCancel.left, g_rectCancel.top, 0, 0, SWP_NOSIZE | SWP_NOZORDER);
    SetWindowPos(GetDlgItem(hWnd, 3), 0, g_rectBack.left, g_rectBack.top, 0, 0, SWP_NOSIZE | SWP_NOZORDER);
  }
  else
  {
    SetWindowPos(GetDlgItem(hWnd, 1035), 0, g_rect1035.left, g_rect1035.top, 0, 0, SWP_NOSIZE | SWP_NOZORDER);
    SetWindowPos(GetDlgItem(hWnd, 1045), 0, g_rect1045.left, g_rect1045.top, 0, 0, SWP_NOSIZE | SWP_NOZORDER);
    SetWindowPos(GetDlgItem(hWnd, 1256), 0, g_rect1256.left, g_rect1256.top, 0, 0, SWP_NOSIZE | SWP_NOZORDER);
  }

  DeleteObject(g_hbAero);
  g_hbAero = NULL;

  // Restore button texts to what we saved.
  if (g_fDrawButtonText)
  {
    SetWindowTextW(g_hBack, g_pwszBack);
    SetWindowTextW(g_hNext, g_pwszNext);
    SetWindowTextW(g_hCancel, g_pwszCancel);
  }

  // Ensure Aero is disabled completely by using 0 margins.
  MARGINS m;
  m.cxLeftWidth = m.cxRightWidth = m.cyBottomHeight = m.cyTopHeight = 0;
  DwmExtendFrameIntoClientArea(hWnd, &m);
}

BOOL CALLBACK ParentDlgProc(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
  switch (uMsg)
  {
  case WM_DWMCOMPOSITIONCHANGED:

    BOOL fAero;
    if (SUCCEEDED(DwmIsCompositionEnabled(&fAero)) && fAero)
    {      
      // Hide/reposition controls when Aero is enabled.
      SetWindowPos(GetDlgItem(hWnd, 1028), 0, 0, g_rectAero.bottom + 1, 0, 0, SWP_NOSIZE | SWP_NOZORDER);
      if (g_fClassicUI)
      {
        ShowWindow(GetDlgItem(hWnd, -1), SW_HIDE);
        SetWindowPos(GetDlgItem(hWnd, 1), 0, g_rectNext.left + CLASSIC_UI_BUTTON_NUDGE, g_rectNext.top + CLASSIC_UI_BUTTON_NUDGE, 0, 0, SWP_NOSIZE | SWP_NOZORDER);
        SetWindowPos(GetDlgItem(hWnd, 2), 0, g_rectCancel.left - CLASSIC_UI_BUTTON_NUDGE, g_rectCancel.top + CLASSIC_UI_BUTTON_NUDGE, 0, 0, SWP_NOSIZE | SWP_NOZORDER);
        SetWindowPos(GetDlgItem(hWnd, 3), 0, g_rectBack.left + CLASSIC_UI_BUTTON_NUDGE, g_rectBack.top + CLASSIC_UI_BUTTON_NUDGE, 0, 0, SWP_NOSIZE | SWP_NOZORDER);
      }
      else
      {
        SetWindowPos(GetDlgItem(hWnd, 1035), 0, 0, g_rectAero.bottom + 1, 0, 0, SWP_NOSIZE | SWP_NOZORDER);
        SetWindowPos(GetDlgItem(hWnd, 1045), 0, 0, g_rectAero.bottom + 1, 0, 0, SWP_NOSIZE | SWP_NOZORDER);
        SetWindowPos(GetDlgItem(hWnd, 1256), 0, 0, g_rectAero.bottom + 1, 0, 0, SWP_NOSIZE | SWP_NOZORDER);
      }

      // Refresh our saved button texts.
      if (g_fDrawButtonText)
      {
        RefreshSavedButtonText(g_hBack, &g_pwszBack);
        RefreshSavedButtonText(g_hNext, &g_pwszNext);
        RefreshSavedButtonText(g_hCancel, &g_pwszCancel);
      }

      g_hbAero = CreateSolidBrush(COLOR_AERO);
      DwmExtendFrameIntoClientArea(hWnd, &g_margins);
    }
    else
    {
      AeroDisable(hWnd);
    }

  // Fall through on purpose: OpenThemeData can fail on WM_DWMCOMPOSITIONCHANGED.
  case WM_THEMECHANGED:
    
    if (g_fDrawBrandingText)
    {
      if (g_hWindowTheme != NULL)
        CloseThemeData(g_hWindowTheme);
      g_hWindowTheme = OpenThemeData(hWnd, THEME_WINDOW);

      // If no theme loaded, don't draw branding text.
      if (g_hWindowTheme == NULL)
        g_fDrawBrandingText = FALSE;
    }

    if (g_hButtonTheme != NULL)
      CloseThemeData(g_hButtonTheme);
    g_hButtonTheme = OpenThemeData(hWnd, THEME_BUTTON);

    // We need the button theme; disable Aero if we don't have it.
    if (g_hButtonTheme == NULL)
      AeroDisable(hWnd);

    return FALSE;

  case WM_ERASEBKGND:

    if (g_hbAero == NULL)
      break;

    FillRect((HDC)wParam, &g_rectWindow, GetSysColorBrush(COLOR_BTNFACE));
    FillRect((HDC)wParam, &g_rectAero, g_hbAero);
        
    if (g_fDrawBrandingText)
    {
      int cchLen = GetWindowTextLength(g_hBrandingText) + 1;
      PWCHAR pwszBrandingText = (PWCHAR)GlobalAlloc(GPTR, sizeof(WCHAR) * cchLen);
      if (pwszBrandingText)
      {
        GetWindowTextW(g_hBrandingText, pwszBrandingText, cchLen);
        
        if (g_fRTL)
          SetLayout((HDC)wParam, LAYOUT_RTL);

        HDC hDC = CreateCompatibleDC((HDC)wParam);
        if (SaveDC(hDC) != 0)
        {
          BITMAPINFO dib;
          dib.bmiHeader.biSize = sizeof(BITMAPINFO);
          dib.bmiHeader.biHeight = -g_margins.cyBottomHeight;
          dib.bmiHeader.biWidth = g_rectWindow.right;
          dib.bmiHeader.biPlanes = 1;
          dib.bmiHeader.biBitCount = 32;
          dib.bmiHeader.biCompression = BI_RGB;

          HBITMAP hBitmap = CreateDIBSection(hDC, &dib, DIB_RGB_COLORS, NULL, NULL, 0);
          if (hBitmap != NULL)
          {
            DTTOPTS dto;
            dto.dwSize = sizeof(DTTOPTS);
            dto.dwFlags = DTT_COMPOSITED;

            RECT r;
            r.left = g_rectBrandingText.left;
            r.top = 0;
            r.right = g_rectBrandingText.right;
            r.bottom = g_margins.cyBottomHeight;

            HBITMAP hBitmapOld = (HBITMAP)SelectObject(hDC, hBitmap);
            HFONT hFontOld = (HFONT)SendMessage(g_hBrandingText, WM_GETFONT, 0, NULL);
            if (hFontOld) hFontOld = (HFONT)SelectObject(hDC, hFontOld);

            DrawThemeTextEx(g_hWindowTheme, hDC, 0, 0, pwszBrandingText, -1, (g_fClassicUI ? DT_CENTER : 0) | DT_SINGLELINE | DT_VCENTER, &r, &dto);
            BitBlt((HDC)wParam, 0, g_rectAero.top, g_rectWindow.right, g_margins.cyBottomHeight, hDC, 0, 0, SRCCOPY | CAPTUREBLT);

            SelectObject(hDC, hBitmapOld);
            if (hFontOld) SelectObject(hDC, hFontOld);
            DeleteObject(hBitmap);
          }
        
          RestoreDC((HDC)wParam, -1);
          DeleteDC(hDC);
        }

        GlobalFree(pwszBrandingText);
      }
    }
    
    return TRUE;

  case WM_CTLCOLORBTN:

    if (g_hbAero == NULL || ((HWND)lParam != g_hBack && (HWND)lParam != g_hNext && (HWND)lParam != g_hCancel))
      break;
    return (LRESULT)g_hbAero;
  }

  return CallWindowProc(ParentDlgProcOld, hWnd, uMsg, wParam, lParam);
}

BOOL CALLBACK ButtonWndProc(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
  if (g_hbAero != NULL)
  {
    switch (uMsg)
    {
    case WM_SETTEXT:
    
      // Save the button text to our own buffer.
      if (g_fDrawButtonText)
      {
        SaveButtonText((PTCHAR)lParam, &GetButtonTextBuffer(hWnd));
        InvalidateRect(hWnd, NULL, TRUE);
        return FALSE;
      }
      
      InvalidateRect(hWnd, NULL, TRUE);
      break;

    case WM_ENABLE:
      
      InvalidateRect(hWnd, NULL, TRUE);
      return FALSE;

    case WM_ERASEBKGND:
    
      return TRUE;

    case WM_PAINT:
    
      PAINTSTRUCT ps;
      HDC hdcPaint = BeginPaint(hWnd, &ps);
      if (hdcPaint != NULL)
      {
        RECT r;
        GetClientRect(hWnd, &r);

        if (g_fRTL)
          SetLayout(hdcPaint, LAYOUT_RTL);

        HDC hdcBufferedPaint;
        HPAINTBUFFER hBufferedPaint = BeginBufferedPaint(hdcPaint, &r, BPBF_COMPOSITED, NULL, &hdcBufferedPaint);
        if (hBufferedPaint != NULL)
        {
          PatBlt(hdcBufferedPaint, 0, 0, r.right, r.bottom, BLACKNESS);

          // To fix text flicker we handle button text drawing ourselves.
          if (g_fDrawButtonText)
          {
            SendMessage(hWnd, WM_PRINTCLIENT, (WPARAM)hdcBufferedPaint, PRF_CLIENT);
        
            HFONT hFontOld = (HFONT)SendMessage(hWnd, WM_GETFONT, 0, NULL);
            if (hFontOld) hFontOld = (HFONT)SelectObject(hdcBufferedPaint, hFontOld);
              
            DTTOPTS dto;
            dto.dwSize = sizeof(DTTOPTS);
            dto.dwFlags = DTT_COMPOSITED | DTT_GLOWSIZE;
            dto.iGlowSize = 12; // Button's text otherwise has no glow.
            DrawThemeTextEx(g_hButtonTheme, hdcBufferedPaint, BP_PUSHBUTTON, GetButtonState(hWnd), GetButtonTextBuffer(hWnd), -1, DT_SINGLELINE | DT_CENTER | DT_VCENTER | DT_HIDEPREFIX, &r, &dto);

            if (hFontOld) SelectObject(hdcBufferedPaint, hFontOld);
          }
          // Let the button draw its text.
          else
          {
            SendMessage(hWnd, WM_PRINTCLIENT, (WPARAM)hdcBufferedPaint, PRF_CLIENT);
        
            RECT rContent;
            GetThemeBackgroundContentRect(g_hButtonTheme, NULL, BP_PUSHBUTTON, PBS_NORMAL, &r, &rContent);
            BufferedPaintSetAlpha(hBufferedPaint, &rContent, 255);
          }
        
          EndBufferedPaint(hBufferedPaint, TRUE);
        }

        EndPaint(hWnd, &ps);
      }

      return FALSE;
    }
  }

  return CallWindowProc((WNDPROC)GetProp(hWnd, PROP_AERO_WNDPROC), hWnd, uMsg, wParam, lParam);
}

BOOL CALLBACK BrandingTextWndProc(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
  switch (uMsg)
  {
  case WM_SHOWWINDOW:
    g_fDrawBrandingText = wParam;
  }
  
  return CallWindowProc((WNDPROC)GetProp(hWnd, PROP_AERO_WNDPROC), hWnd, uMsg, wParam, lParam);
}

BOOL CALLBACK EnumChildProc(HWND hWnd, LPARAM lParam)
{
  if (GetWindowLong(hWnd, GWL_STYLE) & SS_ETCHEDHORZ)
  {
    *((HWND*)lParam) = hWnd;
    return FALSE;
  }

  return TRUE;
}

NSISFUNC(Apply)
{
  EXDLL_INIT();

  // Plug-in already called?
  if (ParentDlgProcOld)
    return;

  // Not Vista or above?
  if (LOBYTE(LOWORD(GetVersion())) < 6)
    return;

  HINSTANCE hDll = LoadLibrary(TEXT("Dwmapi.dll"));
  if (hDll == NULL)
    return;
  
  // These APIs are mandatory.
  DwmIsCompositionEnabled = (PDwmIsCompositionEnabled)GetProcAddress(hDll, "DwmIsCompositionEnabled");
  DwmExtendFrameIntoClientArea = (PDwmExtendFrameIntoClientArea)GetProcAddress(hDll, "DwmExtendFrameIntoClientArea");
  if (DwmIsCompositionEnabled == NULL || DwmExtendFrameIntoClientArea == NULL)
    return;

  // Check if Windows Aero is enabled.
  BOOL fAero;
  if (!SUCCEEDED(DwmIsCompositionEnabled(&fAero)))
    return;
  
  // We need some other functions from UxTheme.dll.
  hDll = LoadLibrary(TEXT("UxTheme.dll"));
  if (hDll == NULL)
    return;
  
  // These APIs are mandatory.
  OpenThemeData = (POpenThemeData)GetProcAddress(hDll, "OpenThemeData");
  CloseThemeData = (PCloseThemeData)GetProcAddress(hDll, "CloseThemeData");
  BufferedPaintInit = (PBufferedPaintInit)GetProcAddress(hDll, "BufferedPaintInit");
  BufferedPaintUnInit = (PBufferedPaintUnInit)GetProcAddress(hDll, "BufferedPaintUnInit");
  BeginBufferedPaint = (PBeginBufferedPaint)GetProcAddress(hDll, "BeginBufferedPaint");
  EndBufferedPaint = (PEndBufferedPaint)GetProcAddress(hDll, "EndBufferedPaint");
  BufferedPaintSetAlpha = (PBufferedPaintSetAlpha)GetProcAddress(hDll, "BufferedPaintSetAlpha");
  GetThemeBackgroundContentRect = (PGetThemeBackgroundContentRect)GetProcAddress(hDll, "GetThemeBackgroundContentRect");
  if (OpenThemeData == NULL ||
      CloseThemeData == NULL ||
      BufferedPaintInit == NULL ||
      BufferedPaintUnInit == NULL ||
      BeginBufferedPaint == NULL ||
      EndBufferedPaint == NULL ||
      BufferedPaintSetAlpha == NULL ||
      GetThemeBackgroundContentRect == NULL)
    return;

  // We always need the button theme.
  g_hButtonTheme = OpenThemeData(hWndParent, THEME_BUTTON);
  if (g_hButtonTheme == NULL)
    return;

  BufferedPaintInit();
  
  g_hBrandingText = GetDlgItem(hWndParent, 1028);
  g_fDrawBrandingText = g_fDrawButtonText = TRUE;
  
  // We like to know the position of the branding text.
  GetWindowRect(g_hBrandingText, &g_rectBrandingText);
  MapWindowPoints(HWND_DESKTOP, hWndParent, (LPPOINT)&g_rectBrandingText, 2);
  g_fRTL = extra->exec_flags->rtl;

  // Should we draw the branding text?
  PTCHAR pszParam = (PTCHAR)GlobalAlloc(GPTR, sizeof(TCHAR) * string_size);
  if (pszParam)
  {
    while (popstring(pszParam) == 0)
    {
      if (lstrcmpi(pszParam, TEXT("/nobranding")) == 0)
      {
        g_fDrawBrandingText = FALSE;
      }
      else if (lstrcmpi(pszParam, TEXT("/btnold")) == 0)
      {
        g_fDrawButtonText = FALSE;
      }
      else
      {
        pushstring(pszParam);
        break;
      }
    }
    
    GlobalFree(pszParam);
  }

  // Branding text or button drawing is enabled.
  if (g_fDrawBrandingText || g_fDrawButtonText)
  {
    DrawThemeTextEx = (PDrawThemeTextEx)GetProcAddress(hDll, "DrawThemeTextEx");
    if (DrawThemeTextEx == NULL)
      goto cleanup;
  }

  // Branding text is enabled; load additional APIs.
  g_hWindowTheme = NULL;
  if (g_fDrawBrandingText)
  {
    g_fDrawBrandingText = FALSE;

    if (IsWindow(g_hBrandingText))
    {
      g_hWindowTheme = OpenThemeData(hWndParent, THEME_WINDOW);
      if (g_hWindowTheme != NULL)
        g_fDrawBrandingText = TRUE;
    }
  }

  // Is MUI? (Get the MUI welcome/finish pages rect.)
  HWND hWndCtl = GetDlgItem(hWndParent, 1044);
  if (IsWindow(hWndCtl))
  {
    RECT r1, r2;
    if (!GetClientRect(hWndCtl, &r1) || !GetClientRect(hWndParent, &r2))
      goto cleanup;

    g_margins.cxLeftWidth = g_margins.cxRightWidth = g_margins.cyTopHeight = 0;
    g_margins.cyBottomHeight = r2.bottom - r1.bottom;
    g_rectAero.left = g_rectWindow.left = 0;
    g_rectAero.top = r1.bottom; g_rectWindow.top = 0;
    g_rectAero.right = g_rectWindow.right = r2.right;
    g_rectAero.bottom = r2.bottom; g_rectWindow.bottom = r1.bottom;

    if (fAero)
    {
      SetWindowPos(g_hBrandingText, 0, g_rectBrandingText.left, r2.bottom + 1, 0, 0, SWP_NOSIZE | SWP_NOZORDER);
    }

    hWndCtl = GetDlgItem(hWndParent, 1035);
    if (IsWindow(hWndCtl))
    {
      GetWindowRect(hWndCtl, &g_rect1035);
      MapWindowPoints(HWND_DESKTOP, hWndParent, (LPPOINT)&g_rect1035, 2);
      if (fAero)
        SetWindowPos(hWndCtl, 0, 0, r2.bottom + 1, 0, 0, SWP_NOSIZE | SWP_NOZORDER);
    }

    hWndCtl = GetDlgItem(hWndParent, 1045);
    if (IsWindow(hWndCtl))
    {
      GetWindowRect(hWndCtl, &g_rect1045);
      MapWindowPoints(HWND_DESKTOP, hWndParent, (LPPOINT)&g_rect1045, 2);
      if (fAero)
        SetWindowPos(hWndCtl, 0, 0, r2.bottom + 1, 0, 0, SWP_NOSIZE | SWP_NOZORDER);
    }
    
    hWndCtl = GetDlgItem(hWndParent, 1256);
    if (IsWindow(hWndCtl))
    {
      GetWindowRect(hWndCtl, &g_rect1256);
      MapWindowPoints(HWND_DESKTOP, hWndParent, (LPPOINT)&g_rect1256, 2);
      if (fAero)
        SetWindowPos(hWndCtl, 0, 0, r2.bottom + 1, 0, 0, SWP_NOSIZE | SWP_NOZORDER);
    }
    
    g_fClassicUI = FALSE;
  }
  else // Implement for non MUI?:
  {
    hWndCtl = GetDlgItem(hWndParent, -1);
    if (!IsWindow(hWndCtl))
    {
      hWndCtl = NULL;
      EnumChildWindows(hWndParent, EnumChildProc, (LPARAM)&hWndCtl);
      if (!IsWindow(hWndCtl))
        goto cleanup;
    }

    RECT r1, r2;
    if (!GetWindowRect(hWndCtl, &r1) || !GetClientRect(hWndParent, &r2))
      goto cleanup;

    MapWindowPoints(HWND_DESKTOP, hWndParent, (LPPOINT)&r1, 2);
      
    g_margins.cxLeftWidth = g_margins.cxRightWidth = g_margins.cyTopHeight = 0;
    g_margins.cyBottomHeight = r2.bottom - r1.bottom;
    g_rectAero.left = g_rectWindow.left = 0;
    g_rectAero.top = r1.bottom; g_rectWindow.top = 0;
    g_rectAero.right = g_rectWindow.right = r2.right;
    g_rectAero.bottom = r2.bottom; g_rectWindow.bottom = r1.bottom;

    if (fAero)
    {
      ShowWindow(hWndCtl, SW_HIDE);
      SetWindowPos(g_hBrandingText, 0, 0, r2.bottom + 1, 0, 0, SWP_NOSIZE | SWP_NOZORDER);
    }

    hWndCtl = GetDlgItem(hWndParent, 1);
    if (IsWindow(hWndCtl))
    {
      GetWindowRect(hWndCtl, &g_rectNext);
      MapWindowPoints(HWND_DESKTOP, hWndParent, (LPPOINT)&g_rectNext, 2);
      if (fAero)
        SetWindowPos(hWndCtl, 0, g_rectNext.left + CLASSIC_UI_BUTTON_NUDGE, g_rectNext.top + CLASSIC_UI_BUTTON_NUDGE, 0, 0, SWP_NOSIZE | SWP_NOZORDER);
    }

    hWndCtl = GetDlgItem(hWndParent, 2);
    if (IsWindow(hWndCtl))
    {
      GetWindowRect(hWndCtl, &g_rectCancel);
      MapWindowPoints(HWND_DESKTOP, hWndParent, (LPPOINT)&g_rectCancel, 2);
      if (fAero)
        SetWindowPos(hWndCtl, 0, g_rectCancel.left - CLASSIC_UI_BUTTON_NUDGE, g_rectCancel.top + CLASSIC_UI_BUTTON_NUDGE, 0, 0, SWP_NOSIZE | SWP_NOZORDER);
    }

    hWndCtl = GetDlgItem(hWndParent, 3);
    if (IsWindow(hWndCtl))
    {
      GetWindowRect(hWndCtl, &g_rectBack);
      MapWindowPoints(HWND_DESKTOP, hWndParent, (LPPOINT)&g_rectBack, 2);
      if (fAero)
        SetWindowPos(hWndCtl, 0, g_rectBack.left + CLASSIC_UI_BUTTON_NUDGE, g_rectBack.top + CLASSIC_UI_BUTTON_NUDGE, 0, 0, SWP_NOSIZE | SWP_NOZORDER);
    }
    
    g_fClassicUI = TRUE;
  }

  // Apply Windows Aero.
  if (fAero)
  {
    if (!SUCCEEDED(DwmExtendFrameIntoClientArea(hWndParent, &g_margins)))
      goto cleanup;
    g_hbAero = CreateSolidBrush(COLOR_AERO);
  }
  else
  {
    g_hbAero = NULL;
  }

  // Register callback so /NOUNLOAD does not have to be used.
  extra->RegisterPluginCallback((HMODULE)g_hInstance, PluginCallback);

  // We need to handle WM_ERASEBKGND to fill our aero rect and non aero rect.
  ParentDlgProcOld = (WNDPROC)SetWindowLongPtr(hWndParent, DWLP_DLGPROC, (LONG)ParentDlgProc);

  // Subclass the branding text so we know when it is shown and hidden.
  SetProp(g_hBrandingText, PROP_AERO_WNDPROC, (HANDLE)SetWindowLongPtr(g_hBrandingText, GWLP_WNDPROC, (LONG)BrandingTextWndProc));

  // Subclass the buttons.
  g_pwszBack = g_pwszNext = g_pwszCancel = NULL;
  g_hBack = GetDlgItem(hWndParent, 3);
  SetProp(g_hBack, PROP_AERO_WNDPROC, (HANDLE)SetWindowLongPtr(g_hBack, GWLP_WNDPROC, (LONG)ButtonWndProc));
  g_hCancel = GetDlgItem(hWndParent, 2);
  SetProp(g_hCancel, PROP_AERO_WNDPROC, (HANDLE)SetWindowLongPtr(g_hCancel, GWLP_WNDPROC, (LONG)ButtonWndProc));
  g_hNext = GetDlgItem(hWndParent, 1);
  SetProp(g_hNext, PROP_AERO_WNDPROC, (HANDLE)SetWindowLongPtr(g_hNext, GWLP_WNDPROC, (LONG)ButtonWndProc));

  return;
cleanup:

  if (pszParam != NULL)
    GlobalFree(pszParam);
  
  if (g_hWindowTheme != NULL)
    CloseThemeData(g_hWindowTheme);
  
  if (g_hButtonTheme != NULL)
    CloseThemeData(g_hButtonTheme);

  BufferedPaintUnInit();
}

BOOL WINAPI DllMain(HANDLE hInst, ULONG ul_reason_for_call, LPVOID lpReserved)
{
  g_hInstance = hInst;
  return TRUE;
}