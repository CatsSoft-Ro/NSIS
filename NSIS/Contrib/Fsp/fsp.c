/***************************************************
* FILE NAME: fct.c
*
* PURPOSE:
*    NSIS plug-in Find_and_Close_or_Terminate.
*
* CHANGE HISTORY
*
* $LOG$
*
* Author              Date          Modifications
* Takhir Bedertdinov  Nov 21 2005   Original
*        Moscow, Russia, ineum@narod.ru
* Takhir Bedertdinov  Jan  7 2005   Partial class 
*        name support
**************************************************/

#include <windows.h>
#include <commctrl.h>
#include <fcntl.h>
#include <stdio.h>
#include <io.h>
#include <sys\stat.h>
#include "..\ExDll\exdll.h"

#define FS "/FS"
#define FN "/FN"
#define PBF "/PBF"
#define INTERVAL "/INT"
#define DEF_INT 500


HWND tbwnd, prwnd;
HANDLE hThread = NULL;
BOOL stopit = FALSE;
DWORD fs = 0;
DWORD interval = DEF_INT;
DWORD tbf = 100;
DWORD tbs = 0;
char fn[MAX_PATH] = "";


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

DWORD my_atoui(char *s)
{
  unsigned int v=0;
  char m=10;
  char t='9';

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


/*****************************************************
 * FUNCTION NAME: trackFile()
 * PURPOSE: 
 *    tracks output file size, updates result
 * SPECIAL CONSIDERATIONS:
 *    
 *****************************************************/
int __stdcall trackFile(void *pp)
{
   DWORD pb_start, pb_new, pb_max, pb_min, tl;
   char tmplt[128] = "";
   WIN32_FIND_DATA wfd;
   HANDLE hFf;
   char *p;

   pb_start = SendMessage(tbwnd, PBM_GETPOS, 0, 0);
   pb_max = SendMessage(tbwnd, PBM_GETRANGE, 0, 0);
   pb_min = SendMessage(tbwnd, PBM_GETRANGE, 1, 0);
   tbf = (tbf * pb_max) / 100;
   while(!stopit)
   {
      if(*fn == 0)
      {
         GetWindowText(prwnd, tmplt, sizeof(tmplt));
         p = my_strchr(tmplt, '%');
         if(p != NULL)
         {
            p--;
            while(*p >= '0' && *p <= '9') p--;
            pb_new = my_atoui(++p);
            if(pb_new > 0)
            {
               pb_new = MulDiv(pb_new, tbf - pb_start, 100) + pb_start;
               SendMessage(tbwnd, PBM_SETPOS, pb_new, 0);
            }
         }
      }
      else if((hFf = FindFirstFile(fn, &wfd)) != NULL)
      {
         FindClose(hFf);
         if(wfd.nFileSizeLow < fs)
         {
            if(*tmplt == 0)
            {
               GetWindowText(prwnd, tmplt, sizeof(tmplt));
               tl = lstrlen(tmplt);
            }
            pb_new = MulDiv(wfd.nFileSizeLow, tbf - pb_start, fs) + pb_start;
            SendMessage(tbwnd, PBM_SETPOS, pb_new, 0);
            tmplt[tl] = 0;
            if(my_strchr(tmplt, '%') == NULL)
            {
               wsprintf(tmplt + tl, " %d%%",
                  MulDiv(wfd.nFileSizeLow, 100, fs));
               SetWindowText(prwnd, tmplt);
            }
         }
      }
      Sleep(interval);
   }
   return 1;
}


/*****************************************************
 * FUNCTION NAME: stop()
 * PURPOSE: 
 *    waits for thread exit and closes handle
 * SPECIAL CONSIDERATIONS:
 *    tested with my consApp.exe
 *****************************************************/
void __declspec(dllexport) stop(HWND hwndParent,
                                int string_size,
                                char *variables,
                                stack_t **stacktop)
{
   if(hThread != NULL)
   {
      stopit = TRUE;
      WaitForSingleObject(hThread, INFINITE);
      CloseHandle(hThread);
      hThread = NULL;
   }
}

/*****************************************************
 * FUNCTION NAME: track()
 * PURPOSE: 
 *    track file extraction entry point
 * SPECIAL CONSIDERATIONS:
 *    
 *****************************************************/
void __declspec(dllexport) track(HWND hwndParent,
                                int string_size,
                                char *variables,
                                stack_t **stacktop)
{
   HWND childwnd;
   DWORD dwThreadId;
   char s[300];
   char *pvalue;

   EXDLL_INIT();

   if(hwndParent == NULL ||
      (childwnd = FindWindowEx(hwndParent, NULL, "#32770", NULL)) == NULL ||
      (tbwnd = GetDlgItem(childwnd, 1004)) == NULL ||
      (prwnd = GetDlgItem(childwnd, 1006)) == NULL)
      return;

   while(!popstring(s) && *s == '/' && lstrcmpi(s, "/END") != 0)
   {
      pvalue = my_strchr(s, '=');
      if(pvalue != NULL)
         *pvalue++ = 0;
      if(lstrcmpi(s, FS) == 0)
      {
         fs = my_atoui(pvalue);
      }
      else if(lstrcmpi(s, INTERVAL) == 0)
      {
         interval = my_atoui(pvalue);
      }
      else if(lstrcmpi(s, FN) == 0)
      {
         lstrcpy(fn, pvalue);
      }
      else if(lstrcmpi(s, PBF) == 0)
      {
         tbf = my_atoui(pvalue);
      }
      else
      {
         if(pvalue != NULL) *(--pvalue) = '=';
         pushstring(s);
         break;
      }
      *s = 0;
   }

   hThread = CreateThread(NULL, 0, trackFile, NULL, 0, &dwThreadId);
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
   if(ul_reason_for_call == DLL_PROCESS_DETACH &&
      hThread != NULL)
      stop(NULL, 0, NULL, NULL);
	return TRUE;
}
