/***********************************************************
 *                                                         *
 * SysRestore plug-in for NSIS                             *
 *                                                         *
 * Written by Jason Ross aka JasonFriday13 on the forums.  *
 *                                                         *
 ***********************************************************/

/*	Include the windows.h file, and the NSIS plugin header. */
#include <windows.h>
#include <srrestoreptapi.h>
#ifdef UNICODE
	#include "nsis\unicode\pluginapi.h" /* This means NSIS 2.42 or higher is required. */
#else
	#include "nsis\pluginapi.h" /* This means NSIS 2.42 or higher is required. */
#endif

/*	Link with srclient.lib */
#pragma comment (lib, "srclient.lib")

/*	Handle for the plugin. */
HANDLE hInstance;

/*	Variables for the System Restore API */
RESTOREPOINTINFO RestPtInfo;
STATEMGRSTATUS SMgrStatus;

/*	Uninstaller and temporary variables. */
BOOL RestorePointStarted;
BOOL Initialized;
INT64 SequenceNumber;
/*	TempVar for popping off of the stack. */
TCHAR TempVar[64];

/*  Our callback function so that our dll stays loaded. */
UINT_PTR __cdecl NSISPluginCallback(enum NSPIM Event) 
{
	return 0;
}

void Initialize(extra_parameters* xp)
{
	if (!Initialized)
	{
		xp->RegisterPluginCallback(hInstance, NSISPluginCallback);
		Initialized = TRUE;
	}
}

/*	This function is common to all functions. To reduce size,
		having one copy instead of two saves space (I think). */
int SetRestorePoint(void)
{
	TCHAR *szTemp;
	
	szTemp = (TCHAR *)LocalAlloc(LPTR, sizeof(TCHAR)*64);
	SRSetRestorePoint(&RestPtInfo, &SMgrStatus);
	SequenceNumber = SMgrStatus.llSequenceNumber;
	wsprintf(szTemp, TEXT("%u"), SMgrStatus.nStatus);
	pushstring(szTemp);
	LocalFree(szTemp);

	return SMgrStatus.nStatus;
}

/*	These functions must be internal to the dll,
		because they use a global variable. It does
		not work if these functions are exported. */
int Begin(BOOL Uninstaller)
{  
	ZeroMemory(&RestPtInfo, sizeof(RESTOREPOINTINFO));
	ZeroMemory(&SMgrStatus, sizeof(STATEMGRSTATUS));

	/*	Initialize the RESTOREPOINTINFO structure. */
	RestPtInfo.dwEventType = BEGIN_SYSTEM_CHANGE;

	/*	Notify the system that changes are about to be made.
			An application is to be installed (or uninstalled). */
	if (Uninstaller)
		RestPtInfo.dwRestorePtType = APPLICATION_UNINSTALL;
	else
		RestPtInfo.dwRestorePtType = APPLICATION_INSTALL;

	/*	Set RestPtInfo.llSequenceNumber. */
	RestPtInfo.llSequenceNumber = 0;

	/*	String to be displayed by System Restore for this restore point. */
	popstring(RestPtInfo.szDescription);
	
	/*	Notify the system that changes are to be made and that
			the beginning of the restore point should be marked. */
	return SetRestorePoint();
}

int Finish(void)
{
	/*	Re-initialize the RESTOREPOINTINFO structure to notify the 
			system that the operation is finished. */
	RestPtInfo.dwEventType = END_SYSTEM_CHANGE;

	/*	End the system change by returning the sequence number 
			received from the first call to SRSetRestorePoint. */
	RestPtInfo.llSequenceNumber = SequenceNumber;

	/*	Notify the system that the operation is done and that this
			is the end of the restore point. */
	return SetRestorePoint();
}

int Remove(void)
{
	int result;

	result = SRRemoveRestorePoint((DWORD)SequenceNumber);

	if (result == ERROR_SUCCESS)
		return 1;
	else
		return 0;

  /*	Re-initialize the RESTOREPOINTINFO structure to notify the 
			system that the operation is finished. */
	//RestPtInfo.dwEventType = END_SYSTEM_CHANGE;

  /*	Set to remove. */
	//RestPtInfo.dwRestorePtType = CANCELLED_OPERATION;

	/*	End the system change by returning the sequence number 
			received from the first call to SRSetRestorePoint. */
	//RestPtInfo.llSequenceNumber = SequenceNumber;
	
	/*	Remove the restore point. */
	//return SetRestorePoint();
}

__declspec(dllexport) void StartRestorePoint(HWND hwndParent, int string_size, TCHAR *variables, stack_t **stacktop, extra_parameters* xp)
{
	EXDLL_INIT();

	Initialize(xp);

	/*	This is to prevent multiple calls to SRSetRestorePoint. */
	if (!RestorePointStarted)
	{
		if (Begin(FALSE))
			RestorePointStarted = TRUE;
	}
	else
		pushstring(TEXT("1"));
}

__declspec(dllexport) void StartUnRestorePoint(HWND hwndParent, int string_size, TCHAR *variables, stack_t **stacktop, extra_parameters* xp)
{
	EXDLL_INIT();

	Initialize(xp);

	/* This is to prevent multiple calls to SRSetRestorePoint. */
	if (!RestorePointStarted)
	{
		if (Begin(TRUE))
			RestorePointStarted = TRUE;
	}
	else
		pushstring(TEXT("1"));
}

__declspec(dllexport) void FinishRestorePoint(HWND hwndParent, int string_size, TCHAR *variables, stack_t **stacktop, extra_parameters* xp)
{
	EXDLL_INIT();

	Initialize(xp);

	/*	This is to prevent multiple calls to SRSetRestorePoint. */
	if (RestorePointStarted)
	{
		if (Finish())
			RestorePointStarted = FALSE;
	}
	else
		pushstring(TEXT("2"));
}

void __declspec(dllexport) RemoveRestorePoint(HWND hwndParent, int string_size, TCHAR *variables, stack_t **stacktop, extra_parameters* xp)
{
	EXDLL_INIT();

	Initialize(xp);

	/*	This is to prevent multiple calls to SRSetRestorePoint. */
  if (SequenceNumber)
	{	
		if (Remove())
			SequenceNumber = 0;
	}
	else
		pushstring(TEXT("3"));
}

BOOL WINAPI DllMain(HANDLE hInst, ULONG ul_reason_for_call, LPVOID lpReserved)
{
  hInstance = hInst;

	Initialized = FALSE;
	RestorePointStarted = FALSE;
	SequenceNumber = 0;
	
	return 1;
}