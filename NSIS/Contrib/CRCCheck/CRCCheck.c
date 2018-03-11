#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <stdlib.h>
#include "..\ExDLL\exdll.h"

HINSTANCE g_hInstance;

HWND g_hwndParent;

unsigned int CRCTable[256];

#define CRCBLOCKSIZE 4096

BOOL FileCRC(HANDLE hFile, unsigned long *crc) {
	static unsigned char crcblock[CRCBLOCKSIZE];
	unsigned long read;
	unsigned char *p;

	unsigned int c = 0xFFFFFFFF;
  
	SetFilePointer(hFile, 0, NULL, FILE_BEGIN);
	do {
		if (ReadFile(hFile, crcblock, CRCBLOCKSIZE, &read, NULL) == FALSE)
			return FALSE;
		for (p = crcblock; p < crcblock + read; p++)
			c = CRCTable[(c & 0xFF) ^ *p] ^ (c >> 8);
	} while (read);
    
	*crc = (c ^ 0xFFFFFFFF);

	return TRUE;
}

void __declspec(dllexport) GenCRC(HWND hwndParent, int string_size, char *variables, stack_t **stacktop)
{
  g_hwndParent = hwndParent;

  EXDLL_INIT();

  {
  	char source[260];
	  HANDLE hSource;
    char crcstr;
    unsigned long result;

    popstring(source);

	  hSource = CreateFile(source, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
	  if (hSource == INVALID_HANDLE_VALUE) {
		  pushstring("0");
		  return;
	  }

    if (!FileCRC(hSource, &result)) {
		  pushstring("0");
		  return;
    }

    _ultoa(result, &crcstr, 10);
    pushstring(&crcstr);

	  CloseHandle(hSource);
	
	  return;
  }
}

BOOL APIENTRY DllMain(HANDLE hInst, unsigned long ul_reason_for_call, LPVOID lpReserved)
{
  g_hInstance = hInst;

  if (ul_reason_for_call == DLL_PROCESS_ATTACH)
  {
    //InitCRC();
    int i, j;
    unsigned long c;

	  for (c = i = 0; i < 256; c = ++i) {
		  for (j = 0; j < 8; j++) {
			  if (c & 1)
          c = (c>>1) ^ 0xEDB88320;
			  else
          c >>= 1;
		  }
		  CRCTable[i] = c;
	  }
  }

	return TRUE;
}