#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include "../ExDll/exdll.h"

#define NSIS_MAX_STRLEN 1024

// HINSTANCE g_hInstance;
// HWND g_hwndParent;

// char find[NSIS_MAX_STRLEN];
char section_name[NSIS_MAX_STRLEN];
char ini_filename[NSIS_MAX_STRLEN];
char ini_output[32767];

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

static void doini(char *szIni, char *szFind, BOOL bKey)
{
	char buf[32];
	int keys=0;

	while (*szIni) 
	{
		if (*szIni != ';')
		{
			section_name[0]=0;
			if (!bKey || (bKey && my_strchr(szIni,'=')))
			{
				if (bKey)
					lstrcpyn(section_name, szIni, ((int)my_strchr(szIni,'=')-(int)szIni+1));
				else
					lstrcpy(section_name, szIni);

				if (szFind)
				{		
					if (!lstrcmpi(szFind, section_name))
					{
						++keys;
						break;
					}
				}
				else
				{
					pushstring(section_name);
					++keys;
				}
			}
		}
		szIni = szIni + lstrlen(szIni) + 1;
	}
	wsprintf((char *)buf,"%d",keys);
	pushstring(buf);
}

void __declspec(dllexport) Section(HWND hwndParent, int string_size, char *variables, stack_t **stacktop)
{
	EXDLL_INIT();

	if (!popstring(ini_filename) && !popstring(section_name))
	{
		GetFullPathName(ini_filename, sizeof(ini_filename)-1, ini_filename, NULL);
		GetPrivateProfileString(NULL, NULL, NULL, ini_output, sizeof(ini_output)-1, ini_filename);
		if (GetPrivateProfileSection(section_name, ini_output, sizeof(ini_output)-1, ini_filename))	
		{
			doini((char *)ini_output, NULL, TRUE);
			return;
		}
	}
	pushstring("error");
}

void __declspec(dllexport) SectionNames(HWND hwndParent, int string_size, char *variables, stack_t **stacktop)
{
	EXDLL_INIT();

	if (!popstring(ini_filename))
	{
		GetFullPathName(ini_filename, sizeof(ini_filename)-1, ini_filename, NULL);
		if (GetPrivateProfileSectionNames(ini_output, sizeof(ini_output)-1, ini_filename))
	 	{
			doini((char *)ini_output, NULL, FALSE);
			return;
		}
	}
	pushstring("error");
}

void __declspec(dllexport) KeyExist(HWND hwndParent, int string_size, char *variables, stack_t **stacktop)
{
	EXDLL_INIT();

	if (!popstring(ini_filename) && !popstring(section_name))
	{
		GetFullPathName(ini_filename, sizeof(ini_filename)-1, ini_filename, NULL);
		GetPrivateProfileString(NULL, NULL, NULL, ini_output, sizeof(ini_output)-1, ini_filename);
		if (GetPrivateProfileSection(section_name, ini_output, sizeof(ini_output)-1, ini_filename))
		{
			if (!popstring(ini_filename))
			{
				doini((char *)ini_output, ini_filename, TRUE);
				return;
			}
		}
	}
	pushstring("error");
}

void __declspec(dllexport) SectionExist(HWND hwndParent, int string_size, char *variables, stack_t **stacktop)
{
	EXDLL_INIT();

	if (!popstring(ini_filename))
	{
		GetFullPathName(ini_filename, sizeof(ini_filename)-1, ini_filename, NULL);
		if (GetPrivateProfileSectionNames(ini_output, sizeof(ini_output)-1, ini_filename))
		{
			if (!popstring(ini_filename))
			{
				doini((char *)ini_output, ini_filename, FALSE);
				return;
			}

		}
	}
	pushstring("error");
}

BOOL WINAPI DllMain(HANDLE hInst, ULONG ul_reason_for_call, LPVOID lpReserved)
{
	// g_hInstance=hInst;
	return TRUE;
}


