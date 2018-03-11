/*****************************************************************
 *                Dump Log NSIS plugin v1.0                      *
 *                                                               *
 * 2005 Shengalts Aleksander aka Instructor (Shengalts@mail.ru)  *
 *****************************************************************/


#include <windows.h>
#include <commctrl.h>

/* Maximum string lenght (default: 1024) */
#define MAX_STRLEN 1024

/* NSIS stack structure */
typedef struct _stack_t {
	struct _stack_t *next;
	char text[MAX_STRLEN];
} stack_t;

stack_t **g_stacktop;


/* NSIS variables */
enum
{
INST_0,         // $0
INST_1,         // $1
INST_2,         // $2
INST_3,         // $3
INST_4,         // $4
INST_5,         // $5
INST_6,         // $6
INST_7,         // $7
INST_8,         // $8
INST_9,         // $9
INST_R0,        // $R0
INST_R1,        // $R1
INST_R2,        // $R2
INST_R3,        // $R3
INST_R4,        // $R4
INST_R5,        // $R5
INST_R6,        // $R6
INST_R7,        // $R7
INST_R8,        // $R8
INST_R9,        // $R9
INST_CMDLINE,   // $CMDLINE
INST_INSTDIR,   // $INSTDIR
INST_OUTDIR,    // $OUTDIR
INST_EXEDIR,    // $EXEDIR
INST_LANG,      // $LANGUAGE
__INST_LAST
};

/* Defines */
#define IDC_SysListView32 1016

/* Global variables */
char szBuf[MAX_STRLEN]="";
char szFile[MAX_STRLEN]="";
char szError[4]="";
int nVarError=0;

/* Funtions prototypes and macros */
int popstring(char *str);
int getvarindex(char *var);
void setvar(const int varnum, const char *var, int g_stringsize, char *g_variables);

/* NSIS functions code */
void __declspec(dllexport) DumpLog(HWND hwndParent, int string_size, 
                                      char *variables, stack_t **stacktop)
{
  g_stacktop=stacktop;
  {
	int nSum=0;
	int nCount=0;
	int nTmp=0;
	int nBytesDone=0;
	LVITEM item;
	HANDLE hLog=0;
	HANDLE hFileHandle=0;

	popstring(szFile);
	popstring(szError);
	nVarError=getvarindex(szError);

	hLog=GetDlgItem(FindWindowEx(hwndParent, NULL, "#32770", NULL), IDC_SysListView32);
	nSum=SendMessage(hLog, LVM_GETITEMCOUNT, 0, 0);

	if (nSum > 0 && (hFileHandle=CreateFile(szFile, GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0)) != INVALID_HANDLE_VALUE)
	{
		item.iSubItem=0;
		item.pszText=&szBuf[0];
		item.cchTextMax=sizeof(szBuf) - 3;

		for (; nCount < nSum; ++nCount)
		{
			nTmp=SendMessage(hLog, LVM_GETITEMTEXT, nCount, (LPARAM)&item);
			lstrcat(szBuf, "\r\n");
			WriteFile(hFileHandle, szBuf, nTmp + 2, &nBytesDone, NULL);
		}
		CloseHandle(hFileHandle);

		setvar(nVarError, "0", string_size, variables);
	}
	else
		setvar(nVarError, "-1", string_size, variables);
  }
}

BOOL WINAPI DllMain(HANDLE hInst, ULONG ul_reason_for_call, LPVOID lpReserved)
{
	return TRUE;
}

//Function: Removes the element from the top of the NSIS stack and puts it in the buffer
int popstring(char *str)
{
	stack_t *th;
	if (!g_stacktop || !*g_stacktop) return 1;
	th=(*g_stacktop);
	lstrcpy(str,th->text);
	*g_stacktop = th->next;
	GlobalFree((HGLOBAL)th);
	return 0;
}

//Function: Sets user variable
void setvar(const int varnum, const char *var, int g_stringsize, char *g_variables)
{
	if (var != NULL && varnum >= 0 && varnum < __INST_LAST) 
		lstrcpy(g_variables + varnum*g_stringsize, var);
}

// Function: Converts .r0-.r9 and .R0-.R9 to variable index
int getvarindex(char *var)
{
	int nVar=-1;

	if (!lstrcmp(var, ".r0")) nVar=INST_0;
	else if (!lstrcmp(var, ".r1")) nVar=INST_1;
	else if (!lstrcmp(var, ".r2")) nVar=INST_2;
	else if (!lstrcmp(var, ".r3")) nVar=INST_3;
	else if (!lstrcmp(var, ".r4")) nVar=INST_4;
	else if (!lstrcmp(var, ".r5")) nVar=INST_5;
	else if (!lstrcmp(var, ".r6")) nVar=INST_6;
	else if (!lstrcmp(var, ".r7")) nVar=INST_7;
	else if (!lstrcmp(var, ".r8")) nVar=INST_8;
	else if (!lstrcmp(var, ".r9")) nVar=INST_9;
	else if (!lstrcmp(var, ".R0")) nVar=INST_R0;
	else if (!lstrcmp(var, ".R1")) nVar=INST_R1;
	else if (!lstrcmp(var, ".R2")) nVar=INST_R2;
	else if (!lstrcmp(var, ".R3")) nVar=INST_R3;
	else if (!lstrcmp(var, ".R4")) nVar=INST_R4;
	else if (!lstrcmp(var, ".R5")) nVar=INST_R5;
	else if (!lstrcmp(var, ".R6")) nVar=INST_R6;
	else if (!lstrcmp(var, ".R7")) nVar=INST_R7;
	else if (!lstrcmp(var, ".R8")) nVar=INST_R8;
	else if (!lstrcmp(var, ".R9")) nVar=INST_R9;

	return nVar;
}
