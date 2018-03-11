/*
	EmbedHTML NSIS plug-in by Stuart Welch <afrowuk@afrowsoft.co.uk>
	v1.0.0.1 - 19th October 2014
*/

#pragma warning(disable: 4005)

#include <windows.h>
#include "pluginapi.h"
#include "EmbedHTML.h"
#include "EmbedHTMLBrowser.h"

HMODULE g_hInstance;
CEmbedHTMLBrowser* g_pWebBrowser = NULL;
DLGPROC ChildDlgProcOld = NULL;

static void DestroyBrowser()
{
	if (g_pWebBrowser)
	{
		g_pWebBrowser->Destroy();
		g_pWebBrowser = NULL;
	}
}

static UINT_PTR PluginCallback(enum NSPIM msg)
{
	if (msg == NSPIM_GUIUNLOAD)
	{
		DestroyBrowser();
	}
	else if (msg == NSPIM_UNLOAD)
	{
		OleUninitialize();
	}

	return 0;
}

static INT_PTR CALLBACK ChildDlgProc(HWND hWndDlg, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	if (uMsg == WM_DESTROY)
	{
		DestroyBrowser();
	}

	return CallWindowProc((WNDPROC)ChildDlgProcOld, hWndDlg, uMsg, wParam, lParam);
}

NSISFUNC(Load)
{
	DLL_INIT();
	{
		BOOL bOK = FALSE;

		if (g_pWebBrowser == NULL)
		{
			PTCHAR pszArg = (PTCHAR)GlobalAlloc(GPTR, sizeof(TCHAR) * string_size);
			if (pszArg)
			{
				BOOL bReplaceRect = FALSE, bNoMaxEmulation = FALSE;

				while (popstring(pszArg) == 0)
				{
					if (lstrcmpi(pszArg, TEXT("/replace")) == 0)
					{
						bReplaceRect = TRUE;
					}
					else if (lstrcmpi(pszArg, TEXT("/nomaxem")) == 0)
					{
						bNoMaxEmulation = TRUE;
					}
					else
					{
						pushstring(pszArg);
						break;
					}
				}

				if (popstring(pszArg) == 0)
				{
					HWND hWndRect = (HWND)myatoi(pszArg);
					if (popstring(pszArg) == 0 && hWndRect > 0 && IsWindow(hWndRect))
					{
						RECT rc;
						GetClientRect(hWndRect, &rc);

						HWND hParent;
						if (bReplaceRect && (hParent = GetParent(hWndRect)))
						{
							GetWindowRect(hWndRect, &rc);
							MapWindowPoints(NULL, hParent, (LPPOINT)&rc, 2);
							DestroyWindow(hWndRect);
						}
						else
						{
							hParent = hWndRect;
						}
							
						OleInitialize(NULL);
						g_pWebBrowser = new CEmbedHTMLBrowser(hParent, rc, pszArg, !bNoMaxEmulation);

						if (hParent != hWndParent)
							ChildDlgProcOld = (DLGPROC)SetWindowLongPtr(hParent, DWLP_DLGPROC, (LONG)ChildDlgProc);

						bOK = TRUE;
					}
				}
			
				GlobalFree(pszArg);
			}
		}

		if (!bOK)
		{
			extra->exec_flags->exec_error = 1;
		}
	}
}

NSISFUNC(GetIEVersion)
{
	EXDLL_INIT();
	{
		pushint(CEmbedHTMLBrowser::GetInternetExplorerVersion());
	}
}

BOOL WINAPI DllMain(HANDLE hInst, ULONG ul_reason_for_call, LPVOID lpReserved)
{
	g_hInstance = (HMODULE)hInst;
	return TRUE;
}