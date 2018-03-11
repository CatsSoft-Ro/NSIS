#include <windows.h>
#include <commctrl.h>
#include "exdll.h"

PLUGFUNCTION(Print)
{
	// Our function globals
	LVITEM lvi;
	HWND hWnd;
	HWND hLogWindow;
	char text[64], clrtext[24];
	int total;
	int exStyle;
	COLORREF clrPrev;
	// Main function entry
	EXDLL_INIT();
	popstring(text); popstring(clrtext);
	hWnd = FindWindowEx(hwndParent, NULL, "#32770", NULL);
	if(!hWnd) return;
	hLogWindow = FindWindowEx(hWnd, NULL, "SysListView32", NULL);
	if (!hLogWindow) return;
	ZeroMemory(&lvi, sizeof(LVITEM));
	total = SendMessage(hLogWindow, LVM_GETITEMCOUNT, 0, 0);
	lvi.mask = LVIF_TEXT;
	lvi.pszText = text;
	lvi.cchTextMax = 0;
	lvi.iItem = total;
	// Store the current color + extended styles
	clrPrev = SendMessage(hLogWindow, LVM_GETTEXTCOLOR, 0, 0);
	exStyle = SendMessage(hLogWindow, LVM_GETEXTENDEDLISTVIEWSTYLE, 0, 0);
	exStyle |= LVS_EX_BORDERSELECT;
	// insert the text + new color for it and the new style
	SendMessage(hLogWindow, LVM_SETEXTENDEDLISTVIEWSTYLE, 0, exStyle);
	SendMessage(hLogWindow, LVM_SETTEXTCOLOR, 0, my_atoi(clrtext));
	SendMessage(hLogWindow, LVM_INSERTITEM, 0, (LPARAM)&lvi);
	SendMessage(hLogWindow, LVM_ENSUREVISIBLE, lvi.iItem, 0);
	// return the prev color
	SendMessage(hLogWindow, LVM_SETTEXTCOLOR, 0, clrPrev);
	return;
}

PLUGFUNCTION(SetBKImage)
{
	LVBKIMAGE lvbi;
	HWND hWnd;
	HWND hLogWindow;
	char path[260];
	EXDLL_INIT();
	popstring(path);
	hWnd = FindWindowEx(hwndParent, NULL, "#32770", NULL);
	if(!hWnd) return;
	hLogWindow = FindWindowEx(hWnd, NULL, "SysListView32", NULL);
	if (!hLogWindow) return;
	ZeroMemory(&lvbi, sizeof(LVBKIMAGE));
	lvbi.ulFlags = LVBKIF_SOURCE_URL|LVBKIF_STYLE_NORMAL|LVBKIF_STYLE_TILE;
	lvbi.pszImage = path;
	lvbi.cchImageMax = lstrlen(path);
	lvbi.xOffsetPercent = 0;
	lvbi.yOffsetPercent = 0;
	CoInitialize(NULL);
	SendMessage(hLogWindow, LVM_SETBKIMAGE, 0, (LPARAM)&lvbi);
	CoUninitialize();
	return;
}

BOOL WINAPI DllMain(HANDLE hInst, ULONG ul_reason_for_call, LPVOID lpReserved)
{
	return TRUE;
}