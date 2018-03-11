#include "NSISFunctions.h"
#include "HardwareInfo.h"

#include <stdio.h>

// Global NSIS access functions
//
CHardwareInfo g_hwInfo;

NSISDLLEXPORTFUNC GetCpuSpeed(NSISDLLEXPORTFUNCPARAMS)
{
	HWINFODLL_INIT();

	{
		int iCpuSpeed = 0;
		g_hwInfo.GetCPUSpeed(iCpuSpeed);

		int iCpuSpeedGhz = 0;
		int iCpuSpeedMhz = 0;

		// If cpu speed is at least 1 Ghz
		if ((iCpuSpeed / 1000) >= 1)
		{
			iCpuSpeedGhz = iCpuSpeed / 1000;
			iCpuSpeedMhz = iCpuSpeed % 1000;
		}
		else
		{
			iCpuSpeedMhz = iCpuSpeed % 1000;
		}

		char szCpuSpeedGhz[MAX_PATH] = "0";
		char szCpuSpeedMhz[MAX_PATH] = "0";

		if (iCpuSpeedGhz >= 0)
			sprintf(szCpuSpeedGhz, "%d", iCpuSpeedGhz);

		if (iCpuSpeedMhz >= 100)
			sprintf(szCpuSpeedMhz, "%2d", iCpuSpeedMhz);
		else if ((iCpuSpeedMhz >= 10) && (iCpuSpeedMhz < 100))
			sprintf(szCpuSpeedMhz, "0%1d", iCpuSpeedMhz);
		

		char szBuf[MAX_PATH];
		sprintf(szBuf, "%d", iCpuSpeed);


		setuservariable(INST_0, szBuf);
		setuservariable(INST_1, szCpuSpeedGhz);
		setuservariable(INST_2, szCpuSpeedMhz);
	}
}

NSISDLLEXPORTFUNC GetCpuNameAndSpeed(NSISDLLEXPORTFUNCPARAMS)
{
	HWINFODLL_INIT();

	{
		char szCpuDesc[MAX_PATH] = "";
		int iCpuSpeed = 0;

		g_hwInfo.GetCPUSpeed(iCpuSpeed);
		g_hwInfo.GetCPUDescription(szCpuDesc); 

		char szBuf[MAX_PATH];
		sprintf(szBuf, "%s, ~%d Mhz", szCpuDesc, iCpuSpeed);

		setuservariable(INST_0, szBuf);
	}
}

NSISDLLEXPORTFUNC GetSystemMemory(NSISDLLEXPORTFUNCPARAMS)
{
	HWINFODLL_INIT();
	
	{
		int iSystemMemory = 0;
		g_hwInfo.GetTotalSystemMemory(iSystemMemory);

		char szBuf[MAX_PATH];
		sprintf(szBuf, "%d", iSystemMemory);

		setuservariable(INST_0, szBuf);
	}
}

NSISDLLEXPORTFUNC GetVideoCardName(NSISDLLEXPORTFUNCPARAMS)
{
	HWINFODLL_INIT();

	{
		//CString cstrVidCardName;
		char szVidCardName[MAX_PATH] = "";

		g_hwInfo.GetVideoAdapterDescription(szVidCardName); 

		char szBuf[MAX_PATH] = "";
		sprintf(szBuf, "%s", szVidCardName);

		setuservariable(INST_0, szBuf);
	}
}

NSISDLLEXPORTFUNC GetVideoCardMemory(NSISDLLEXPORTFUNCPARAMS)
{
	HWINFODLL_INIT();

	{
		int iVideoAdapterTotalMem = 0;
		g_hwInfo.GetVideoAdapterTotalMemory(iVideoAdapterTotalMem);

		char szBuf[MAX_PATH];
		sprintf(szBuf, "%d", iVideoAdapterTotalMem);

		setuservariable(INST_0, szBuf);
	}
}
