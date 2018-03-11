/************************************************************ 
 * SimpleBg plugin for NSIS.
 * Copyright 2007, 2010, 2013-2014 MouseHelmet Software
 * Written by Jason Ross (JasonFriday13 on the NSIS forums).
 ************************************************************/

#include <windows.h>
#include "nsis\pluginapi.h" /* This means NSIS 2.42 or higher is required. */

HINSTANCE hInstance;

UINT_PTR oldProc;
TCHAR g_caption[1024];
HWND hwndparent, hwndImage, m_bgwndDummy;
COLORREF c1, c2;

COLORREF GetColor(void)
{
  TCHAR szTemp0[64], szTemp1[64], szTemp2[64];

  popstring(szTemp0);
  popstring(szTemp1);
  popstring(szTemp2);

  return RGB(myatoi(szTemp0), myatoi(szTemp1), myatoi(szTemp2));
}

LRESULT CALLBACK BGWndProcDummy(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
  return DefWindowProc(hwnd,uMsg,wParam,lParam);
}

LRESULT CALLBACK BGWndProc(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam)
{
  if (hwnd == hwndparent)
  {
    if (msg == WM_SIZE) 
      ShowWindow(hwndImage, wParam == SIZE_MINIMIZED ? SW_HIDE : SW_SHOW);
    if (msg == WM_WINDOWPOSCHANGED||WM_WINDOWPOSCHANGED)
      SetWindowPos(hwndImage, hwndparent, 0, 0, 0, 0, SWP_NOACTIVATE|SWP_NOMOVE|SWP_NOSIZE);
    if (msg == WM_SETTEXT) 
      SetWindowText(hwndImage, (LPCTSTR)lParam);

    return CallWindowProc((WNDPROC)oldProc, hwnd, msg, wParam, lParam);
  }

  switch (msg)
  {
    case WM_PAINT:
    {
      PAINTSTRUCT ps;
      HDC hdc;
      RECT r;
      LOGBRUSH lh;
      HFONT newFont;
      int ry;

      hdc = BeginPaint(hwnd, &ps);
      
      newFont = CreateFont(40, 0, 0, 0, 700, TRUE, 0, 0,
        DEFAULT_CHARSET,
        OUT_DEFAULT_PRECIS,
        CLIP_DEFAULT_PRECIS,
        DEFAULT_QUALITY,
        DEFAULT_PITCH,
        _T("TIMES NEW ROMAN")
        );
      
      // Original code from NSIS source for background drawing.
      lh.lbStyle = BS_SOLID;
      
      GetClientRect(hwnd, &r);
      ry = r.bottom;
      r.bottom = 0;

      // JF: made slower, reduced to 4 pixels high, because I like how it looks better/
      while (r.top < ry)
      {
        int rv,gv,bv;
        HBRUSH brush;
        rv = (GetRValue(c2) * r.top + GetRValue(c1) * (ry - r.top)) / ry;
        gv = (GetGValue(c2) * r.top + GetGValue(c1) * (ry - r.top)) / ry;
        bv = (GetBValue(c2) * r.top + GetBValue(c1) * (ry - r.top)) / ry;
        lh.lbColor = RGB(rv, gv, bv);
        brush = CreateBrushIndirect(&lh);
        // note that we don't need to do "SelectObject(hdc, brush)"
        // because FillRect lets us specify the brush as a parameter.
        r.bottom += 4;
        FillRect(hdc, &r, brush);
        DeleteObject(brush);
        r.top += 4;
      }			
      if (newFont)
      {
        HFONT oldFont;
        
        //Draw the black shadow first, then the text on top of that.           
        r.left = 20; //Offset to the right by four pixels to the text.
        r.top = 12;  //Offset down by four pixels to the text.
        SetBkMode(hdc, TRANSPARENT);
        SetTextColor(hdc, 0); //Set to black shadow.
        oldFont = SelectObject(hdc, newFont);
        ExtTextOut(hdc, r.left, r.top, 0, 0, g_caption, lstrlen(g_caption), 0);
        //DrawTextEx(hdc, g_caption, lstrlen(g_caption), &r, DT_TOP|DT_LEFT|DT_SINGLELINE|DT_NOPREFIX, 0);
        
        r.left = 16;
        r.top = 8;
        SetTextColor(hdc, RGB(255, 255, 255));
        
        ExtTextOut(hdc, r.left, r.top, 0, 0, g_caption, lstrlen(g_caption), 0);
        //DrawTextEx(hdc, g_caption, lstrlen(g_caption), &r, DT_TOP|DT_LEFT|DT_SINGLELINE|DT_NOPREFIX, 0);
        SelectObject(hdc, oldFont);
        DeleteObject(newFont);
      }
      EndPaint(hwnd, &ps);
    }
    break;
    return 0;
  }
  return DefWindowProc(hwnd,msg,wParam,lParam);
}

void Destroy(void)
{
  if (IsWindow(hwndparent))
    SetWindowLongPtr(hwndparent, GWLP_WNDPROC, (UINT_PTR)oldProc);
  if (IsWindow(hwndImage))
  {
    DestroyWindow(hwndImage);
    DestroyWindow(m_bgwndDummy);
    hwndImage = 0;
    m_bgwndDummy = 0;
    UnregisterClass(_T("_Nb0"), hInstance);
    UnregisterClass(_T("_Nc0"), hInstance);
  }
}

/*  Our callback function so that our dll stays loaded. */
UINT_PTR __cdecl NSISPluginCallback(enum NSPIM Event) 
{
  if (Event == NSPIM_GUIUNLOAD)
    Destroy();

  return 0;
}

//__declspec(dllexport) void SetBg(HWND hwndParent, int string_size, TCHAR *variables, stack_t **stacktop)
void __declspec(dllexport) __cdecl SetBg(HWND hwndParent, int string_size, TCHAR *variables, stack_t **stacktop, extra_parameters* xp)
{
  RECT vp;
  HWND m_bgwnd;
  WNDCLASSEX wc, wcDummy;

  if (!IsWindow(hwndImage))
  {
    EXDLL_INIT();

    xp->RegisterPluginCallback(hInstance, NSISPluginCallback);

    c1 = GetColor();
    c2 = GetColor();
    popstring(g_caption);

    hwndparent = hwndParent;

    wcDummy.cbSize = sizeof(WNDCLASSEX);
    wcDummy.style = 0;
    wcDummy.lpfnWndProc = BGWndProcDummy;
    wcDummy.cbClsExtra = 0;
    wcDummy.cbWndExtra = 0;
    wcDummy.hInstance = hInstance;
    wcDummy.hIcon = 0;
    wcDummy.hCursor = 0;
    wcDummy.hbrBackground = 0;
    wcDummy.lpszMenuName = 0;
    wcDummy.lpszClassName = _T("_Nc0");
    wcDummy.hIconSm = 0;

    wc.cbSize = sizeof(WNDCLASSEX);
    wc.style = 0;
    wc.lpfnWndProc = BGWndProc;
    wc.cbClsExtra = 0;
    wc.cbWndExtra = 0;
    wc.hInstance = hInstance;
    wc.hIcon = 0;
    wc.hCursor = 0;
    wc.hbrBackground = 0;
    wc.lpszMenuName = 0;
    wc.lpszClassName = _T("_Nb0");
    wc.hIconSm = 0;

    if (!hwndparent) 
      return;

    //Register Dummy wndclass.
    if (!RegisterClassEx(&wcDummy)) 
      return;
    
    if (!RegisterClassEx(&wc)) 
      return;

    vp.left = 0;
    vp.top = 0;
    vp.right = GetSystemMetrics(SM_CXSCREEN);
    vp.bottom = GetSystemMetrics(SM_CYSCREEN);

    //Create Dummy window.
    m_bgwndDummy = CreateWindowEx(0,wcDummy.lpszClassName,0,0,
      0,0,0,0,0,NULL,hInstance,NULL);
    
    //Create actual BgGradient window with Dummy window as the parent.
    //The window must be disabled, because then the user cannot move
    //the window around and/or close it, and take the focus away from
    //the main installer window. We want the installer in control of
    //the background window, not the user.
    m_bgwnd = CreateWindowEx(0,wc.lpszClassName,0,WS_POPUP|WS_SYSMENU|WS_CAPTION|WS_DISABLED,
      vp.left,vp.top,vp.right,vp.bottom,m_bgwndDummy,NULL,hInstance,NULL);
    
    if (!m_bgwnd) 
      return;

    SendMessage(m_bgwnd, WM_SETICON, ICON_SMALL, (LPARAM)LoadImage(GetModuleHandle(NULL), MAKEINTRESOURCE(103), IMAGE_ICON, 0, 0, LR_DEFAULTSIZE));
    oldProc = SetWindowLongPtr(hwndparent, GWLP_WNDPROC, (UINT_PTR)BGWndProc);

    ShowWindow(m_bgwnd, SW_SHOWNA);
    hwndImage = m_bgwnd;
  }
}

/* Our DLL entry point, this is called when we first load up our DLL. */
BOOL WINAPI DllMain(HINSTANCE hInst, DWORD ul_reason_for_call, LPVOID lpReserved)
{
  hInstance = hInst;

  if (ul_reason_for_call == DLL_PROCESS_DETACH)
    Destroy();

  return TRUE;
}