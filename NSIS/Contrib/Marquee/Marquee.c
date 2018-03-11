/*******************************************************
* FILE NAME: Marquee.c
*
* Copyright 2005 - Present NSIS
*
* PURPOSE:
*    Text animation plug-in
*
* CHANGE HISTORY
*
* Author              Date          Modifications
* Takhir Bedertdinov  Mar 12, 2005  Original
*       --//--        Jul 24, 2005  /SWING and /START opt.
*                  internal 'stop' auto-call on next start
*       --//--        Aug 30, 2005  /HWND for splash wnd
*       --//--        Jan  9, 2006  Early Win95 msvcrt free
*******************************************************/



#include <windows.h>
#include <windowsx.h>
#include <stdio.h>
#include <fcntl.h>
#include <time.h>
#include <io.h>
#include <sys/stat.h>
#include "..\exdll\exdll.h"

#define NOCOLOR 0xFFFFFFFF

HINSTANCE g_hInstance;
HWND childwnd = NULL;
BOOL terminate = FALSE;
HANDLE hThread = NULL;
char *marquee = NULL;
HFONT hFont = NULL;
HBRUSH hBrush = NULL;
RECT rw, rc;
HRGN hRgn = NULL;
COLORREF textColor,
         bordColor,
         bkColor;
int iInterval,
    iStep,
    iScrolls,
    iBorder;
SIZE sz;
int textPos;
BOOL fSwing = FALSE;

enum START {
   START_DEFAULT = 0,
   START_LEFT,
   START_RIGHT,
   START_CENTER
};

char *my_strchr(char *s, char c)
{
   while(*s != 0)
   {
      if(*s == c)
         return s;
      s++;
   }
   return NULL;
}

int my_atoi(char *s)
{
  unsigned int v=0;
  int sign=1; // sign of positive
  char m=10; // base of 0
  char t='9'; // cap top of numbers at 9

  if (*s == '-')
  {
    s++;  //skip over -
    sign=-1; // sign flip
  }

  if (*s == '0')
  {
    s++; // skip over 0
    if (s[0] >= '0' && s[0] <= '7')
    {
      m=8; // base of 8
      t='7'; // cap top at 7
    }
    if ((s[0] & ~0x20) == 'X')
    {
      m=16; // base of 16
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
  return ((int)v)*sign;
}

/*****************************************************
 * FUNCTION NAME: mThread()
 * PURPOSE: 
 *    text redraw thread
 * SPECIAL CONSIDERATIONS:
 *    TextOut(hDc, textPos, rc.top, marquee, lstrlen(marquee));
 *****************************************************/
DWORD __stdcall mThread(void *nil)
{
   HDC hDc;

   while(IsWindow(childwnd) && !terminate)
   {
      if(fSwing &&
         ((iStep < 0 && textPos + sz.cx < rc.right && textPos + sz.cx - iStep >= rc.right) ||
          (iStep > 0 && textPos >= rc.left && textPos - iStep < rc.left)))
            iStep = - iStep;
      textPos -= iStep;
      if((iStep > 0 && textPos + sz.cx < rc.left) ||
         (iStep < 0 && textPos >= rc.right))
      {
         if(--iScrolls == 0) break;
         textPos = (iStep < 0) ? rc.left - sz.cx : rc.right;
      }
      hDc = GetDC(childwnd); // client area dc
      SetBkColor(hDc, bkColor);
      if(NOCOLOR != textColor)
         SetTextColor(hDc, textColor);
      if(hFont != NULL)
         SelectObject(hDc, (HGDIOBJ)hFont);
      ExtTextOut(hDc, textPos, rc.top, ETO_CLIPPED | ETO_OPAQUE, &rc,
         marquee, lstrlen(marquee), NULL);
      if(hRgn != NULL && hBrush != NULL)
         FillRgn(hDc, hRgn, hBrush);
      ReleaseDC(childwnd, hDc);
      Sleep(iInterval);
   }
   RedrawWindow(childwnd, &rw, NULL, RDW_INVALIDATE|RDW_ERASE);
   if(hFont != NULL) DeleteObject((HGDIOBJ)hFont);
   if(hBrush != NULL) DeleteObject((HGDIOBJ)hBrush);
   if(hRgn != NULL) DeleteObject((HGDIOBJ)hRgn);
   GlobalFree(marquee);
   marquee = NULL; hFont = NULL; hBrush = NULL; hRgn = NULL;
   return 1;
}


/*****************************************************
 * FUNCTION NAME: stop()
 * PURPOSE: 
 *    stops text drawing and terminates thread
 * SPECIAL CONSIDERATIONS:
 *    
 *****************************************************/
void __declspec(dllexport) stop(HWND hwndParent,
                                int string_size,
                                char *variables,
                                stack_t **stacktop)
{
   if(hThread != NULL)
   {
      terminate = TRUE;
      if(WaitForSingleObject(hThread, iInterval * 5) == STILL_ACTIVE)
         TerminateThread(hThread, 0);
      CloseHandle(hThread);
      hThread = NULL;
   }
}

/*****************************************************
 * FUNCTION NAME: start()
 * PURPOSE: 
 *    parameters initialization and thread start
 * SPECIAL CONSIDERATIONS:
 *    
 *****************************************************/
void __declspec(dllexport) start(HWND hwndParent,
                                int string_size,
                                char *variables,
                                stack_t **stacktop)
{

   DWORD dwThreadId; // verdana 
   int iHeight = 18,
      iWidth = 10,
      iWeight = FW_SEMIBOLD,
      iLeft = 0,
      iRight = 0,
      iTop = 60,
      iSpacer = 1,
      iShift = 0,
      iStart = START_DEFAULT;
   BOOL fItalic = FALSE,
      fUnderline = FALSE;
   DWORD dwCharset = ANSI_CHARSET;
   char szFace[32] = "Times";
   HDC hDc;
   HRGN hRgnExcl;
   char *pvalue;

   EXDLL_INIT();
   if(marquee != NULL) stop(hwndParent, string_size, variables, stacktop);
   marquee = (char*)GlobalAlloc(GPTR, string_size);
   terminate = FALSE;
   iBorder = iScrolls = 0;
   iStep = 1;
   iInterval = 20;
   textColor = bordColor = bkColor = NOCOLOR;
   fSwing = FALSE;

   while(!popstring(marquee) && *marquee == '/')
   {
      pvalue = my_strchr(marquee, '=');
      if(pvalue != NULL)
         *pvalue++ = 0;
      if(lstrcmpi(marquee, "/face") == 0)
         lstrcpy(szFace, pvalue);
      if(lstrcmpi(marquee, "/height") == 0)
         iHeight = my_atoi(pvalue);
      if(lstrcmpi(marquee, "/width") == 0)
         iWidth = my_atoi(pvalue);
      if(lstrcmpi(marquee, "/weight") == 0)
         iWeight = my_atoi(pvalue);
      if(lstrcmpi(marquee, "/left") == 0)
         iLeft = my_atoi(pvalue);
      if(lstrcmpi(marquee, "/right") == 0)
         iRight = my_atoi(pvalue);
      if(lstrcmpi(marquee, "/top") == 0)
         iTop = my_atoi(pvalue);
      if(lstrcmpi(marquee, "/step") == 0)
         iStep = my_atoi(pvalue);
      if(lstrcmpi(marquee, "/interval") == 0)
         iInterval = my_atoi(pvalue);
      if(lstrcmpi(marquee, "/scrolls") == 0)
         iScrolls = my_atoi(pvalue);
      if(lstrcmpi(marquee, "/spacer") == 0)
         iSpacer = my_atoi(pvalue);
      if(lstrcmpi(marquee, "/charset") == 0)
         dwCharset = my_atoi(pvalue);
      if(lstrcmpi(marquee, "/border") == 0)
         iBorder = my_atoi(pvalue);
      if(lstrcmpi(marquee, "/hwnd") == 0)
         childwnd = (HWND) my_atoi(pvalue);
      if(lstrcmpi(marquee, "/swing") == 0)
         fSwing = TRUE;
      if(lstrcmpi(marquee, "/italic") == 0)
         fItalic = TRUE;
      if(lstrcmpi(marquee, "/underline") == 0)
         fUnderline = TRUE;
      if(lstrcmpi(marquee, "/color") == 0)
      {
         textColor = my_atoi(pvalue);
         textColor = (textColor & 0x00ff00) |
            (textColor & 0x0000ff) << 16 | (textColor & 0xff0000) >> 16;
      }
      if(lstrcmpi(marquee, "/bcol") == 0)
      {
         bordColor = my_atoi(pvalue);
         bordColor = (bordColor & 0x00ff00) |
            (bordColor & 0x0000ff) << 16 | (bordColor & 0xff0000) >> 16;
      }
      if(lstrcmpi(marquee, "/gcol") == 0)
      {
         bkColor = my_atoi(pvalue);
         bkColor = (bkColor & 0x00ff00) |
            (bkColor & 0x0000ff) << 16 | (bkColor & 0xff0000) >> 16;
      }
      if(lstrcmpi(marquee, "/start") == 0)
      {
         if(lstrcmpi(pvalue, "left") == 0)
            iStart = START_LEFT;
         else if(lstrcmpi(pvalue, "right") == 0)
            iStart = START_RIGHT;
         else if(lstrcmpi(pvalue, "center") == 0)
            iStart = START_CENTER;
      }
   }
   if(bordColor == NOCOLOR) bordColor = textColor;
   if(iBorder > 0) iShift = iBorder + iSpacer;
   if(iStep == 0 && iStart == START_DEFAULT) iStart = START_CENTER;

   if(marquee == NULL ||
      (childwnd == NULL &&
      (hwndParent == NULL ||
      (childwnd = FindWindowEx(hwndParent, NULL, "#32770", NULL)) == NULL)))
      return;
   if(iWidth >= 0)
      hFont = CreateFont(iHeight, iWidth, 0, 0, iWeight, fItalic, fUnderline, 0, 
      dwCharset, OUT_TT_ONLY_PRECIS, CLIP_DEFAULT_PRECIS, 
      PROOF_QUALITY, FF_DECORATIVE | DEFAULT_PITCH, szFace);
   GetClientRect(childwnd, &rw);
   rw.left = ((rw.right * iLeft) / 100 < iShift) ? 0 : (rw.right * iLeft) / 100 - iShift;
   rw.right -= ((rw.right * iRight) / 100 < iShift) ? 0 : (rw.right * iRight) / 100 - iShift;
   rw.top = (iShift > (rw.bottom * iTop) / 100) ? 0 : (rw.bottom * iTop) / 100 - iShift;
   hDc = GetDC(childwnd); // client area dc
   if(hFont != NULL)
      SelectObject(hDc, (HGDIOBJ)hFont);
   GetTextExtentPoint32(hDc, marquee, lstrlen(marquee), &sz);
   if(rw.top + sz.cy + 2 * (iShift) > rw.bottom)
      rw.top = rw.bottom - sz.cy - 2 * (iShift);
   else rw.bottom = rw.top + sz.cy + iShift * 2;
// background brush... GetDCBrushColor compatibility is bad.
// But for GetPixel winodw must be visible (Sleep may require).
   if(bkColor == NOCOLOR) bkColor = GetPixel(hDc, rw.left, rw.top);
   if(iBorder > 0 && bordColor == NOCOLOR)
      bordColor = GetTextColor(hDc);
   ReleaseDC(childwnd, hDc);
   SetRect(&rc, rw.left + iShift, rw.top + iShift, rw.right - iShift, rw.bottom - iShift);
   if(iBorder > 0)
   {
      hBrush = CreateSolidBrush(bordColor);
      hRgn = CreateRectRgn(rw.left, rw.top, rw.right, rw.bottom);
      hRgnExcl = CreateRectRgn(rw.left + iBorder, rw.top + iBorder,
         rw.right - iBorder, rw.bottom - iBorder);
      CombineRgn(hRgn, hRgn, hRgnExcl, RGN_XOR);
      DeleteObject((HGDIOBJ)hRgnExcl);
   }
   switch(iStart)
   {
   case START_DEFAULT:
      textPos = (iStep < 0) ? rc.left - sz.cx : rc.right;
      break;
   case START_LEFT:
      textPos = rc.left;
      break;
   case START_RIGHT:
      textPos = rc.right - sz.cx;
      break;
   case START_CENTER:
      textPos = (rc.right + rc.left - sz.cx) / 2;
      break;
   }

   hThread = CreateThread(NULL, 0, mThread, NULL, 0, &dwThreadId);
}

/*****************************************************
 * FUNCTION NAME: DllMain()
 * PURPOSE: 
 *    Dll main entry point
 * SPECIAL CONSIDERATIONS:
 *    
 *****************************************************/
BOOL WINAPI DllMain(HANDLE hInst,
                    ULONG ul_reason_for_call,
                    LPVOID lpReserved)
{
    return TRUE;
}
