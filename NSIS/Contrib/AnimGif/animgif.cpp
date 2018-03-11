/**********************************************************
* FILE NAME: AnimGif.cpp
*
* Copyright © 2006 Takhir Bedertdinov ineum@narod.ru
*
* Permission to use, copy, modify, distribute and sell this 
* software or any part thereof and/or its documentation for
* any purpose is granted without fee provided that the above
* copyright notice and this permission notice appear in all
* copies.
*
* This software is provided "as is" without express or implied 
* warranty of any kind. The author shall have no liability
* with respect to the infringement of copyrights or patents 
* that any modification to the content of this file or this 
* file itself may incur.
*
*
* PURPOSE:
*
*    Animated GIF plug-in for NSIS installer
*    Displays animated image on target window
*
*
* CHANGE HISTORY:
*
* Author              Date           Modifications
*
* Takhir Bedertdinov
*   Feb. 19, 2006  Original
*   Mar. 03, 2010 $HWNDPAREN buttons click re-send added
*   Mar. 14, 2010 Image position as % of width/height
*********************************************************/



#include <windows.h>
#include <tchar.h>
#include "..\exdll\exdll.h"
#include "winimage.h"

static C_ImageSet imgset;
static C_AnimationWindow anim;

HWND childwnd = NULL;
static void *lpWndProcOld = NULL;
static LRESULT CALLBACK WndProc(HWND, UINT, WPARAM, LPARAM);

enum FITS {
   FIT_NONE = 0,
   FIT_WIDTH,
   FIT_HEIGHT,
   FIT_BOTH
};

/*
as far as we have msvcrt
TCHAR *my_strchr(TCHAR *s, TCHAR c)
{
   while(*s != 0)
   {
      if(*s == c)
         return s;
      s++;
   }
   return NULL;
}

DWORD my_atoui(TCHAR *s)
{
  unsigned int v=0;
  TCHAR m=10;
  TCHAR t='9';

  if (*s == '0')
  {
    s++; // skip over 0
    if (s[0] >= '0' && s[0] <= '7')
    {
      m=8; // octal
      t='7';
    }
    if ((s[0] & ~0x20) == 'X')
    {
      m=16; // hex
      s++; // advance over 'x'
    }
  }

  for (;;)
  {
    int c=*s++;
    if (c >= '0' && c <= t) c-='0';
    else if (m==16 && (c & ~0x20) >= 'A' && (c & ~0x20) <= 'F') c = (c & 7) + 9;
    else break;
    v*=m;
    v+=c;
  }
  return v;
}
*/

/*****************************************************
 * FUNCTION NAME: stop()
 * PURPOSE: 
 *    image banner "stop" dll entry point
 * SPECIAL CONSIDERATIONS:
 *    stops playing, deletes transparent brush
 *****************************************************/
extern "C"
void __declspec(dllexport) stop(HWND hwndParent,
                                int string_size,
                                TCHAR *variables,
                                stack_t **stacktop)
{
   anim.Stop();
//      imgset.ClearImgs(); // result is not good
   if(lpWndProcOld != NULL &&
      IsWindow(childwnd) &&
      (void *)GetWindowLong(childwnd, GWL_WNDPROC) == WndProc)
      SetWindowLong(childwnd, GWL_WNDPROC,(long)lpWndProcOld);

   if(IsWindow(childwnd))
      RedrawWindow(childwnd, NULL, NULL, RDW_INVALIDATE|RDW_ERASE);

   childwnd = NULL;
   lpWndProcOld = NULL;
}



/*****************************************************
 * FUNCTION NAME: show()
 * PURPOSE: 
 *    image banner "play" dll entry point
 * SPECIAL CONSIDERATIONS:
 *    
 *****************************************************/
extern "C"
void __declspec(dllexport) play(HWND hwndParent,
                                int string_size,
                                TCHAR *variables,
                                stack_t **stacktop)
{
   TCHAR fn[MAX_PATH];
   RECT r;
   TCHAR *pvalue;
   int iHAlign = 50,
      iVAlign = 100,
      iFit = FIT_NONE;
   int w, h;
   COLORREF trCol = CLR_INVALID;

   EXDLL_INIT();

   stop(NULL, 0, NULL, NULL);
// parameters check out
//   while(!popstring(fn) && *fn == '/' && (pvalue = my_strchr(fn, '=')) != NULL)
   while(!popstring(fn) && *fn == _T('/') && (pvalue = _tcschr(fn, _T('='))) != NULL)
   {
      *pvalue++ = 0;
      if(lstrcmpi(fn, _T("/halign")) == 0)
      {
		  iHAlign = _tcstoul(pvalue, NULL, 0);
      }
      if(lstrcmpi(fn, _T("/valign")) == 0)
      {
		  iVAlign = _tcstoul(pvalue, NULL, 0);
      }
      else if(lstrcmpi(fn, _T("/hwnd")) == 0)
//         childwnd = (HWND) my_atoui(pvalue);
         childwnd = (HWND) _tcstoul(pvalue, NULL, 0);
      else if(lstrcmpi(fn, _T("/bgcol")) == 0)
      {
         trCol = _tcstoul(pvalue, NULL, 0);
         if(*pvalue == _T('0'))
            trCol = ((trCol & 0xFF) << 16) | (trCol & 0xFF00) | ((trCol & 0xFF0000) >> 16);
         else
            trCol = GetSysColor(trCol);
      }
      else if(lstrcmpi(fn, _T("/fit")) == 0)
      {
         if(lstrcmpi(pvalue, _T("height")) == 0) iFit = FIT_HEIGHT;
         else if(lstrcmpi(pvalue, _T("width")) == 0) iFit = FIT_WIDTH;
         else if(lstrcmpi(pvalue, _T("both")) == 0) iFit = FIT_BOTH;
      }
   }
// if target window not defined
   if(childwnd == NULL)
   {
      if((childwnd = FindWindowEx(hwndParent, NULL, _T("#32770"), NULL)) == NULL)
         return;
      if((hwndParent = FindWindowEx(hwndParent, childwnd, _T("#32770"), NULL)) != NULL &&
         !IsWindowVisible(hwndParent))
         childwnd = hwndParent;
      if(childwnd == NULL)
         return;
   }
   
// check file name and load images
   if(*fn == 0) return;
// on Back and Cancel click 'leave' function not called, our stop() is safe
   imgset.LoadGIF(fn);
   if(imgset.nImages == 0) return;

// calculate target rect
   GetClientRect(childwnd, &r);
   if(iFit == FIT_HEIGHT)
   {
      h = r.bottom - r.top;
      w = (imgset.FrameWidth * (r.bottom - r.top)) / imgset.FrameHeight;
   }
   else if(iFit == FIT_WIDTH)
   {
      w = r.right - r.left;
      h = (imgset.FrameHeight * (r.right - r.left)) / imgset.FrameWidth;
   }
   else if(iFit == FIT_BOTH)
   {
      w = r.right - r.left;
      h = r.bottom - r.top;
   }
   else
   {
      w = imgset.FrameWidth;
      h = imgset.FrameHeight;
   }

   r.left = r.left + (r.right - r.left - w) * iHAlign / 100;
   r.top = r.top + (r.bottom - r.top - h) * iVAlign / 100;
   r.right = r.left + w;
   r.bottom = r.top + h;

// attach to parent window message queue for paint and close events
   lpWndProcOld = (void *)SetWindowLong(childwnd, GWL_WNDPROC, (long)WndProc);
   anim.Play (childwnd, r, &imgset, trCol);
}




/*****************************************************
 * FUNCTION NAME: DllMain()
 * PURPOSE: 
 *    Dll main (initialization) entry point
 * SPECIAL CONSIDERATIONS:
 *    
 *****************************************************/
BOOL WINAPI DllMain(HANDLE hInst,
                    ULONG ul_reason_for_call,
                    LPVOID lpReserved)
{
   if(ul_reason_for_call == DLL_PROCESS_DETACH)
      stop(NULL, 0, NULL, NULL);
   return TRUE;
}

/*****************************************************
 * FUNCTION NAME: WndProc()
 * PURPOSE: 
 *    window proc. 
 * SPECIAL CONSIDERATIONS:
 *    for paint and close purposes
 *****************************************************/
static LRESULT CALLBACK WndProc(HWND hwnd,
                                UINT uMsg,
                                WPARAM wParam,
                                LPARAM lParam)
{
   HDC hdc;
   switch (uMsg)
   {

   case WM_PAINT:
      hdc = GetDC(childwnd);
		anim.Paint(hdc);
      ReleaseDC(childwnd, hdc);
      break;

   case WM_CLOSE:
      stop(hwnd, 0, NULL, NULL);
      break;
// not for childwindow, but for other target /hwnd=
   case WM_COMMAND:
      if(LOWORD(wParam) == IDCANCEL ||
         LOWORD(wParam) == IDOK ||
         LOWORD(wParam) == IDABORT)
         stop(hwnd, 0, NULL, NULL);
	  PostMessage(hwnd, uMsg, wParam, lParam);
      break;

   default:
      break;
   }
   return CallWindowProc((WNDPROC)lpWndProcOld,
         hwnd, uMsg, wParam, lParam);
}



