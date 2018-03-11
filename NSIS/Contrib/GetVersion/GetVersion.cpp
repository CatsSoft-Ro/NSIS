#include "GetVersion.h"

#ifdef UNICODE
#include "nsis_unicode\pluginapi.h"
#else
#include "nsis_ansi\pluginapi.h"
#endif

/**
 GetVersion.cpp - Windows version info plugin for NSIS by Afrow UK
 Based on example script by Microsoft at:
  http://msdn.microsoft.com/library/default.asp?url=/library/en-us/sysinfo/base/getting_the_system_version.asp
*/

typedef void (WINAPI *PGNSI)(LPSYSTEM_INFO);
typedef BOOL (WINAPI *PGPI)(DWORD, DWORD, DWORD, DWORD, PDWORD);

HINSTANCE g_hInstance;

#ifdef UNICODE
BOOL CallGetVersion(LPOSVERSIONINFOEXW posvi, BOOL *pbOsVersionInfoEx)
{
  // Try calling GetVersionEx using the OSVERSIONINFOEX structure.
  // If that fails, try using the OSVERSIONINFO structure.

  posvi->dwOSVersionInfoSize = sizeof(OSVERSIONINFOEX);

  if (!(*pbOsVersionInfoEx = GetVersionEx((LPOSVERSIONINFOW)posvi)))
  {
    posvi->dwOSVersionInfoSize = sizeof(OSVERSIONINFO);
    if (!GetVersionEx((LPOSVERSIONINFOW)posvi))
      return FALSE;
  }
  return TRUE;
}
#else
BOOL CallGetVersion(LPOSVERSIONINFOEXA posvi, BOOL *pbOsVersionInfoEx)
{
  // Try calling GetVersionEx using the OSVERSIONINFOEX structure.
  // If that fails, try using the OSVERSIONINFO structure.

  posvi->dwOSVersionInfoSize = sizeof(OSVERSIONINFOEX);

  if (!(*pbOsVersionInfoEx = GetVersionEx((LPOSVERSIONINFOA)posvi)))
  {
    posvi->dwOSVersionInfoSize = sizeof(OSVERSIONINFO);
    if (!GetVersionEx((LPOSVERSIONINFOA)posvi))
      return FALSE;
  }
  return TRUE;
}
#endif

NSISFUNC(WindowsName)
{
  EXDLL_INIT();

  TCHAR *szOsName = NULL;
  OSVERSIONINFOEX osvi;
  BOOL bOsVersionInfoEx;

  if (CallGetVersion(&osvi, &bOsVersionInfoEx))
  {
    if (osvi.dwPlatformId == VER_PLATFORM_WIN32_NT)
    {
      if (osvi.dwMajorVersion == 6 && osvi.dwMinorVersion == 0)
      {
        if (osvi.wProductType == VER_NT_WORKSTATION)
          szOsName = TEXT("Vista");
        else
          szOsName = TEXT("Server 2008");
      }
	    else if (osvi.dwMajorVersion == 6 && osvi.dwMinorVersion == 1)
      {
        if (osvi.wProductType == VER_NT_WORKSTATION)
          szOsName = TEXT("7");
        else
          szOsName = TEXT("Server 2008 R2");
      }
      else if (osvi.dwMajorVersion == 6 && osvi.dwMinorVersion == 2)
      {
        if (osvi.wProductType == VER_NT_WORKSTATION)
          szOsName = TEXT("8");
        else
          szOsName = TEXT("Server 2012");
      }
      else if (osvi.dwMajorVersion == 5 && osvi.dwMinorVersion == 2)
      {
        PGNSI pGNSI = (PGNSI)GetProcAddress(GetModuleHandle(TEXT("kernel32.dll")), "GetNativeSystemInfo");
        SYSTEM_INFO si;
        if (pGNSI != NULL)
          pGNSI(&si);
        else
          GetSystemInfo(&si);

        if (GetSystemMetrics(SM_SERVERR2))
          szOsName = TEXT("Server 2003 R2");
        else if (osvi.wProductType == VER_NT_WORKSTATION && si.wProcessorArchitecture == PROCESSOR_ARCHITECTURE_AMD64)
          szOsName = TEXT("XP x64");
        else
          szOsName = TEXT("Server 2003");
      }
      else if (osvi.dwMajorVersion == 5 && osvi.dwMinorVersion == 1)
      {
        szOsName = TEXT("XP");
      }
      else if (osvi.dwMajorVersion == 5 && osvi.dwMinorVersion == 0)
      {
        szOsName = TEXT("2000");
      }
      else if (osvi.dwMajorVersion <= 4)
      {
        szOsName = TEXT("NT");
      }
    }
    else if (osvi.dwPlatformId == VER_PLATFORM_WIN32_CE)
    {
      szOsName = TEXT("CE");
    }
    else if (osvi.dwPlatformId == VER_PLATFORM_WIN32_WINDOWS)
    {
      if (osvi.dwMajorVersion == 4 && osvi.dwMinorVersion == 0)
      {
        if (osvi.szCSDVersion[1] == 'C' || osvi.szCSDVersion[1] == 'B')
          szOsName = TEXT("95 OSR2");
        else
          szOsName = TEXT("95");
      }
      else if (osvi.dwMajorVersion == 4 && osvi.dwMinorVersion == 10)
      {
        if (osvi.szCSDVersion[1] == 'A')
          szOsName = TEXT("98 SE");
        else
          szOsName = TEXT("98");
      }
      else if (osvi.dwMajorVersion == 4 && osvi.dwMinorVersion == 90)
      {
        szOsName = TEXT("ME");
      }
    }
    else if (osvi.dwPlatformId == VER_PLATFORM_WIN32s)
    {
      szOsName = TEXT("Win32s");
    }
  }

  if (szOsName == NULL)
    szOsName = TEXT("");

  pushstring(szOsName);
}

NSISFUNC(WindowsType)
{
  EXDLL_INIT();

  TCHAR *szOsType = NULL;
  OSVERSIONINFOEX osvi;
  BOOL bOsVersionInfoEx;

  if (CallGetVersion(&osvi, &bOsVersionInfoEx))
  {
    PGNSI pGNSI = (PGNSI)GetProcAddress(GetModuleHandle(TEXT("kernel32.dll")), "GetNativeSystemInfo");
    SYSTEM_INFO si;
    if (pGNSI)
      pGNSI(&si);
    else
      GetSystemInfo(&si);

    if (osvi.dwPlatformId == VER_PLATFORM_WIN32_NT)
    {
      if (osvi.dwMajorVersion == 6)
      {
        PGPI pGPI = (PGPI)GetProcAddress(GetModuleHandle(TEXT("kernel32.dll")), "GetProductInfo");
        if (pGPI != NULL)
        {
          DWORD dwType = 0;
          pGPI(osvi.dwMajorVersion, osvi.dwMinorVersion, 0, 0, &dwType);

          switch (dwType)
          {
            case PRODUCT_ULTIMATE:
              szOsType = TEXT("Ultimate");
              break;
            case PRODUCT_ULTIMATE_N:
              szOsType = TEXT("Ultimate N");
              break;
            case PRODUCT_PROFESSIONAL:
              szOsType = TEXT("Professional");
              break;
            case PRODUCT_PROFESSIONAL_N:
              szOsType = TEXT("Professional N");
              break;
            case PRODUCT_HOME_PREMIUM:
              szOsType = TEXT("Home Premium");
              break;
            case PRODUCT_HOME_PREMIUM_N:
              szOsType = TEXT("Home Premium N");
              break;
            case PRODUCT_HOME_BASIC:
              szOsType = TEXT("Home Basic");
              break;
            case PRODUCT_HOME_BASIC_N:
              szOsType = TEXT("Home Basic N");
              break;
            case PRODUCT_ENTERPRISE:
              szOsType = TEXT("Enterprise");
              break;
            case PRODUCT_ENTERPRISE_N:
              szOsType = TEXT("Enterprise N");
              break;
            case PRODUCT_BUSINESS:
              szOsType = TEXT("Business");
              break;
            case PRODUCT_BUSINESS_N:
              szOsType = TEXT("Business N");
              break;
            case PRODUCT_STARTER:
              szOsType = TEXT("Starter");
              break;
            case PRODUCT_STARTER_N:
              szOsType = TEXT("Starter N");
              break;
          }
        }
      }
      else if (osvi.dwMajorVersion == 5 && osvi.dwMinorVersion == 1)
      {
        DWORD dwInstMCE = 0;
        HKEY hKeyMCE;
        if (RegOpenKeyEx(HKEY_LOCAL_MACHINE, TEXT("SYSTEM\\WPA\\MediaCenter"), 0, KEY_QUERY_VALUE, &hKeyMCE) == ERROR_SUCCESS)
        {
          DWORD dwBufLen = sizeof(DWORD);
          RegQueryValueEx(hKeyMCE, TEXT("Installed"), NULL, NULL, (LPBYTE)dwInstMCE, &dwBufLen);
          RegCloseKey(hKeyMCE);
        }

        DWORD dwInstTPCE = 0;
        HKEY hKeyTPCE;
        if (RegOpenKeyEx(HKEY_LOCAL_MACHINE, TEXT("SYSTEM\\WPA\\TabletPC"), 0, KEY_QUERY_VALUE, &hKeyTPCE) == ERROR_SUCCESS)
        {
          DWORD dwBufLen = sizeof(DWORD);
          RegQueryValueEx(hKeyTPCE, TEXT("Installed"), NULL, NULL, (LPBYTE)dwInstTPCE, &dwBufLen);
          RegCloseKey(hKeyTPCE);
        }

        if (dwInstMCE == 0 && dwInstTPCE == 0)
        {
          if (osvi.wSuiteMask & VER_SUITE_PERSONAL)
            szOsType = TEXT("Home Edition");
          else if (osvi.wSuiteMask & VER_SUITE_EMBEDDEDNT)
            szOsType = TEXT("Embedded");
          else if (si.wProcessorArchitecture == PROCESSOR_ARCHITECTURE_AMD64)
            szOsType = TEXT("Professional x64 Edition");
          else
            szOsType = TEXT("Professional");
        }
        else if (dwInstMCE == 1)
          szOsType = TEXT("Media Center Edition");
        else if (dwInstTPCE == 1)
          szOsType = TEXT("Tablet PC Edition");
      }
      else if (osvi.dwMajorVersion == 5 && osvi.dwMinorVersion == 0)
        szOsType = TEXT("Professional");
      else if (osvi.dwMajorVersion == 4)
        szOsType = TEXT("Workstation 4.0");
    }
  }
  
  if (szOsType == NULL)
    szOsType = TEXT("");

  pushstring(szOsType);
}

NSISFUNC(WindowsVersion)
{
  EXDLL_INIT();

  OSVERSIONINFOEX osvi;
  BOOL bOsVersionInfoEx;

  if (CallGetVersion(&osvi, &bOsVersionInfoEx))
  {
    TCHAR szOsVer[16];
    wsprintf(szOsVer, TEXT("%i.%i"), osvi.dwMajorVersion, osvi.dwMinorVersion);
    pushstring(szOsVer);
  }
  else
    pushstring(TEXT(""));
}

NSISFUNC(WindowsPlatformId)
{
  EXDLL_INIT();

  OSVERSIONINFOEX osvi;
  BOOL bOsVersionInfoEx;

  if (CallGetVersion(&osvi, &bOsVersionInfoEx))
  {
    TCHAR szOsPId[16];
    wsprintf(szOsPId, TEXT("%i"), osvi.dwPlatformId);
    pushstring(szOsPId);
  }
  else
    pushstring(TEXT(""));
}

NSISFUNC(WindowsPlatformArchitecture)
{
  EXDLL_INIT();

  TCHAR *szOsPlatArch = NULL;
  OSVERSIONINFOEX osvi;
  BOOL bOsVersionInfoEx;

  if (CallGetVersion(&osvi, &bOsVersionInfoEx))
  {
    if (osvi.dwPlatformId == VER_PLATFORM_WIN32_NT)
    {
      PGNSI pGNSI = (PGNSI)GetProcAddress(GetModuleHandle(TEXT("kernel32.dll")), "GetNativeSystemInfo");
      if (pGNSI != NULL) // 64-bit only possible if GetNativeSystemInfo() exists (Windows XP and above).
      {
        SYSTEM_INFO si;
        pGNSI(&si);

        if (si.wProcessorArchitecture == PROCESSOR_ARCHITECTURE_AMD64 || si.wProcessorArchitecture == PROCESSOR_ARCHITECTURE_IA64)
          szOsPlatArch = TEXT("64");
      }
    }
  }

  if (szOsPlatArch == NULL)
    szOsPlatArch = TEXT("32");

  pushstring(szOsPlatArch);
}

NSISFUNC(WindowsServerName)
{
  EXDLL_INIT();

  TCHAR *szOsServName = NULL;
  OSVERSIONINFOEX osvi;
  BOOL bOsVersionInfoEx;

  if (CallGetVersion(&osvi, &bOsVersionInfoEx))
  {
    if (osvi.dwPlatformId == VER_PLATFORM_WIN32_NT)
    {
      if (bOsVersionInfoEx)
      {
        if (osvi.wProductType == VER_NT_SERVER || osvi.wProductType == VER_NT_DOMAIN_CONTROLLER)
        {
          if (osvi.dwMajorVersion == 6)
          {
            PGPI pGPI = (PGPI)GetProcAddress(GetModuleHandle(TEXT("kernel32.dll")), "GetProductInfo");
            if (pGPI != NULL)
            {
              DWORD dwType = 0;
              pGPI(osvi.dwMajorVersion, osvi.dwMinorVersion, 0, 0, &dwType);

              switch (dwType)
              {
                case PRODUCT_CLUSTER_SERVER:
                  szOsServName = TEXT("HPC Edition");
                  break;
                case PRODUCT_CLUSTER_SERVER_V:
                  szOsServName = TEXT("Server Hyper Core V");
                  break;
                case PRODUCT_DATACENTER_EVALUATION_SERVER:
                  szOsServName = TEXT("Server Datacenter (evaluation installation)");
                  break;
                case PRODUCT_DATACENTER_SERVER:
                  szOsServName = TEXT("Server Datacenter");
                  break;
                case PRODUCT_DATACENTER_SERVER_CORE:
                  szOsServName = TEXT("Server Datacenter (core installation)");
                  break;
                case PRODUCT_DATACENTER_SERVER_CORE_V:
                  szOsServName = TEXT("Server Datacenter without Hyper-V (core installation)");
                  break;
                case PRODUCT_DATACENTER_SERVER_V:
                  szOsServName = TEXT("Server Datacenter without Hyper-V");
                  break;
                case PRODUCT_ENTERPRISE_EVALUATION:
                  szOsServName = TEXT("Server Enterprise (evaluation installation)");
                  break;
                case PRODUCT_ENTERPRISE_SERVER:
                  szOsServName = TEXT("Server Enterprise");
                  break;
                case PRODUCT_ENTERPRISE_SERVER_CORE:
                  szOsServName = TEXT("Server Enterprise (core installation)");
                  break;
                case PRODUCT_ENTERPRISE_SERVER_CORE_V:
                  szOsServName = TEXT("Server Enterprise without Hyper-V (core installation)");
                  break;
                case PRODUCT_ENTERPRISE_SERVER_IA64:
                  szOsServName = TEXT("Server Enterprise for Itanium-based Systems");
                  break;
                case PRODUCT_ENTERPRISE_SERVER_V:
                  szOsServName = TEXT("Server Enterprise without Hyper-V");
                  break;
                case PRODUCT_ESSENTIALBUSINESS_SERVER_MGMT:
                  szOsServName = TEXT("Essential Server Solution Management");
                  break;
                case PRODUCT_ESSENTIALBUSINESS_SERVER_ADDL:
                  szOsServName = TEXT("Essential Server Solution Additional");
                  break;
                case PRODUCT_ESSENTIALBUSINESS_SERVER_MGMTSVC:
                  szOsServName = TEXT("Essential Server Solution Management SVC");
                  break;
                case PRODUCT_ESSENTIALBUSINESS_SERVER_ADDLSVC:
                  szOsServName = TEXT("Essential Server Solution Additional SVC");
                  break;
                case PRODUCT_HOME_PREMIUM_SERVER:
                  szOsServName = TEXT("Home Server 2011");
                  break;
                case PRODUCT_HOME_SERVER:
                  szOsServName = TEXT("Storage Server 2008 R2 Essentials");
                  break;
                case PRODUCT_HYPERV:
                  szOsServName = TEXT("Hyper-V Server");
                  break;
                case PRODUCT_MEDIUMBUSINESS_SERVER_MANAGEMENT:
                  szOsServName = TEXT("Essential Business Server Management Server");
                  break;
                case PRODUCT_MEDIUMBUSINESS_SERVER_MESSAGING:
                  szOsServName = TEXT("Essential Business Server Messaging Server");
                  break;
                case PRODUCT_MEDIUMBUSINESS_SERVER_SECURITY:
                  szOsServName = TEXT("Essential Business Server Security Server");
                  break;
                case PRODUCT_SB_SOLUTION_SERVER:
                  szOsServName = TEXT("Server For SB Solutions");
                  break;
                case PRODUCT_SB_SOLUTION_SERVER_EM:
                case PRODUCT_SERVER_FOR_SB_SOLUTIONS_EM:
                  szOsServName = TEXT("Server For SB Solutions EM");
                  break;
                case PRODUCT_SERVER_FOR_SMALLBUSINESS:
                  szOsServName = TEXT("Server 2008 for Windows Essential Server Solutions");
                  break;
                case PRODUCT_SERVER_FOR_SMALLBUSINESS_V:
                  szOsServName = TEXT("Server 2008 without Hyper-V for Windows Essential Server Solutions");
                  break;
                case PRODUCT_SERVER_FOUNDATION:
                  szOsServName = TEXT("Server Foundation");
                  break;
                case PRODUCT_SMALLBUSINESS_SERVER:
                  szOsServName = TEXT("Small Business Server");
                  break;
                case PRODUCT_SMALLBUSINESS_SERVER_PREMIUM:
                  szOsServName = TEXT("Small Business Server Premium");
                  break;
                case PRODUCT_MULTIPOINT_STANDARD_SERVER:
                  szOsServName = TEXT("MultiPoint Server Standard");
                  break;
                case PRODUCT_MULTIPOINT_PREMIUM_SERVER:
                  szOsServName = TEXT("MultiPoint Server Premium");
                  break;
                case PRODUCT_SOLUTION_EMBEDDEDSERVER:
                  szOsServName = TEXT("MultiPoint Server");
                  break;
                case PRODUCT_STANDARD_SERVER:
                  szOsServName = TEXT("Server Standard");
                  break;
                case PRODUCT_STANDARD_SERVER_CORE:
                  szOsServName = TEXT("Server Standard (core installation)");
                  break;
                case PRODUCT_STANDARD_SERVER_V:
                  szOsServName = TEXT("Server Standard without Hyper-V");
                  break;
                case PRODUCT_STANDARD_SERVER_CORE_V:
                  szOsServName = TEXT("Server Standard without Hyper-V (core installation)");
                  break;
                case PRODUCT_STANDARD_SERVER_SOLUTIONS:
                  szOsServName = TEXT("Server Solutions Premium");
                  break;
                case PRODUCT_STANDARD_SERVER_SOLUTIONS_CORE:
                  szOsServName = TEXT("Server Solutions Premium (core installation)");
                  break;
                case PRODUCT_STORAGE_ENTERPRISE_SERVER:
                  szOsServName = TEXT("Storage Server Enterprise");
                  break;
                case PRODUCT_STORAGE_ENTERPRISE_SERVER_CORE:
                  szOsServName = TEXT("Storage Server Enterprise (core installation)");
                  break;
                case PRODUCT_STORAGE_EXPRESS_SERVER:
                  szOsServName = TEXT("Storage Server Express");
                  break;
                case PRODUCT_STORAGE_EXPRESS_SERVER_CORE:
                  szOsServName = TEXT("Storage Server Express (core installation)");
                  break;
                case PRODUCT_STORAGE_STANDARD_EVALUATION_SERVER:
                  szOsServName = TEXT("Storage Server Standard (evaluation installation)");
                  break;
                case PRODUCT_STORAGE_STANDARD_SERVER:
                  szOsServName = TEXT("Storage Server Standard");
                  break;
                case PRODUCT_STORAGE_STANDARD_SERVER_CORE:
                  szOsServName = TEXT("Storage Server Standard (core installation)");
                  break;
                case PRODUCT_STORAGE_WORKGROUP_EVALUATION_SERVER:
                  szOsServName = TEXT("Storage Server Workgroup (evaluation installation)");
                  break;
                case PRODUCT_STORAGE_WORKGROUP_SERVER:
                  szOsServName = TEXT("Storage Server Workgroup");
                  break;
                case PRODUCT_STORAGE_WORKGROUP_SERVER_CORE:
                  szOsServName = TEXT("Storage Server Workgroup (core installation)");
                  break;
                case PRODUCT_WEB_SERVER:
                  szOsServName = TEXT("Web Server Edition");
                  break;
                case PRODUCT_WEB_SERVER_CORE:
                  szOsServName = TEXT("Web Server Edition (core installation)");
                  break;
              }
            }
          }
          if (osvi.dwMajorVersion == 5 && osvi.dwMinorVersion == 2)
          {
            PGNSI pGNSI = (PGNSI)GetProcAddress(GetModuleHandle(TEXT("kernel32.dll")), "GetNativeSystemInfo");
            SYSTEM_INFO si;
            if (pGNSI)
              pGNSI(&si);
            else
              GetSystemInfo(&si);

            if (si.wProcessorArchitecture == PROCESSOR_ARCHITECTURE_IA64)
            {
              if (osvi.wSuiteMask & VER_SUITE_DATACENTER)
                szOsServName = TEXT("Datacenter Edition for Itanium-based Systems");
              else if (osvi.wSuiteMask & VER_SUITE_ENTERPRISE)
                szOsServName = TEXT("Enterprise Edition for Itanium-based Systems");
            }
            else if (si.wProcessorArchitecture == PROCESSOR_ARCHITECTURE_AMD64)
            {
              if (osvi.wSuiteMask & VER_SUITE_DATACENTER)
                szOsServName = TEXT("Datacenter x64 Edition");
              else if (osvi.wSuiteMask & VER_SUITE_ENTERPRISE)
                szOsServName = TEXT("Enterprise x64 Edition");
              else
                szOsServName = TEXT("Standard x64 Edition");
            }
            else
            {
              if (osvi.wSuiteMask & VER_SUITE_DATACENTER)
                szOsServName = TEXT("Datacenter Edition");
              else if (osvi.wSuiteMask & VER_SUITE_ENTERPRISE)
                szOsServName = TEXT("Enterprise Edition");
              else if (osvi.wSuiteMask == VER_SUITE_BLADE)
                szOsServName = TEXT("Enterprise Edition");
              else if (osvi.wSuiteMask == VER_SUITE_STORAGE_SERVER)
                szOsServName = TEXT("Storage Server 2003");
              else if (osvi.wSuiteMask == VER_SUITE_COMPUTE_SERVER)
                szOsServName = TEXT("Server 2003");
              else if (osvi.wSuiteMask == VER_SUITE_SMALLBUSINESS)
                szOsServName = TEXT("Small Business Server");
              else
                szOsServName = TEXT("Standard Edition");
            }
          }
          else if (osvi.dwMajorVersion == 5 && osvi.dwMinorVersion == 0)
          {
            if (osvi.wSuiteMask & VER_SUITE_DATACENTER)
              szOsServName = TEXT("Datacenter Server");
            else if (osvi.wSuiteMask & VER_SUITE_ENTERPRISE)
              szOsServName = TEXT("Advanced Server");
            else
              szOsServName = TEXT("Server");
          }
          else
          {
            if (osvi.wSuiteMask & VER_SUITE_ENTERPRISE)
              szOsServName = TEXT("Server 4.0 Enterprise Edition");
            else
              szOsServName = TEXT("Server 4.0");
          }
        }
      }
      else // !bOsVersionInfoEx
      {
        HKEY hKey;
        LONG lRet = RegOpenKeyEx(HKEY_LOCAL_MACHINE, TEXT("SYSTEM\\CurrentControlSet\\Control\\ProductOptions"), 0, KEY_QUERY_VALUE, &hKey);
        if (lRet == ERROR_SUCCESS)
        {
          TCHAR szProductType[128];
          DWORD dwBufLen = sizeof(szProductType);
          lRet = RegQueryValueEx(hKey, TEXT("ProductType"), NULL, NULL, (LPBYTE)szProductType, &dwBufLen);
          if (lRet == ERROR_SUCCESS)
          {
            RegCloseKey(hKey);

            if (lstrcmpi(TEXT("WINNT"), szProductType) == 0)
              szOsServName = TEXT("Workstation");
            else if (lstrcmpi(TEXT("LANMANNT"), szProductType) == 0)
              szOsServName = TEXT("Server");
            else if (lstrcmpi(TEXT("SERVERNT"), szProductType) == 0)
              szOsServName = TEXT("Advanced Server");
          }
        }
      }
    }
  }
  
  if (szOsServName == NULL)
    szOsServName = TEXT("");

  pushstring(szOsServName);
}

NSISFUNC(WindowsServicePack)
{
  EXDLL_INIT();

  TCHAR *szOsServPack = NULL;
  OSVERSIONINFOEX osvi;
  BOOL bOsVersionInfoEx;

  if (CallGetVersion(&osvi, &bOsVersionInfoEx))
  {
    if (osvi.dwPlatformId == VER_PLATFORM_WIN32_NT)
    {
      if (osvi.dwMajorVersion == 4 && lstrcmpi(osvi.szCSDVersion, TEXT("Service Pack 6")) == 0)
      { 
        HKEY hKey;
        LONG lRet = RegOpenKeyEx(HKEY_LOCAL_MACHINE, TEXT("SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Hotfix\\Q246009"), 0, KEY_QUERY_VALUE, &hKey);
        if (lRet == ERROR_SUCCESS)
        {
          RegCloseKey(hKey);
          szOsServPack = TEXT("Service Pack 6a");
        }
        else
          szOsServPack = osvi.szCSDVersion;
      }
      else
        szOsServPack = osvi.szCSDVersion;
    }
  }

  if (szOsServPack == NULL)
    szOsServPack = TEXT("");

  pushstring(szOsServPack);
}

NSISFUNC(WindowsServicePackBuild)
{
  EXDLL_INIT();

  OSVERSIONINFOEX osvi;
  BOOL bOsVersionInfoEx;

  if (CallGetVersion(&osvi, &bOsVersionInfoEx))
  {
    TCHAR szServPackBuild[16];
    wsprintf(szServPackBuild, TEXT("%i"), osvi.dwBuildNumber & 0xFFFF);
    pushstring(szServPackBuild);
  }
  else
    pushstring(TEXT(""));
}

NSISFUNC(WindowsServicePackMinor)
{
  EXDLL_INIT();

  OSVERSIONINFOEX osvi;
  BOOL bOsVersionInfoEx;

  if (CallGetVersion(&osvi, &bOsVersionInfoEx))
  {
    TCHAR szServicePackMinor[16];
    wsprintf(szServicePackMinor, TEXT("%i"), osvi.wServicePackMinor);
    pushstring(szServicePackMinor);
  }
  else
    pushstring(TEXT(""));
}

NSISFUNC(WindowsServicePackMajor)
{
  EXDLL_INIT();

  OSVERSIONINFOEX osvi;
  BOOL bOsVersionInfoEx;

  if (CallGetVersion(&osvi, &bOsVersionInfoEx))
  {
    TCHAR szServicePackMajor[16];
    wsprintf(szServicePackMajor, TEXT("%i"), osvi.wServicePackMajor);
    pushstring(szServicePackMajor);
  }
  else
    pushstring(TEXT(""));
}

/*extern "C"
void __declspec(dllexport) IEVersion(HWND hWndParent, int string_size, 
                                      TCHAR *variables, stack_t **stacktop,
                                      extra_parameters *extra)
{
  EXDLL_INIT();
  {
    HINSTANCE hBrowser;

    //Load the DLL.
    hBrowser = LoadLibrary(TEXT("shdocvw.dll"));

    if (hBrowser) 
    {
      HRESULT  hr = S_OK;
      DLLGETVERSIONPROC pDllGetVersion;

      pDllGetVersion = (DLLGETVERSIONPROC)GetProcAddress(hBrowser, "DllGetVersion");

      if (pDllGetVersion) 
      {
        TCHAR buf[32];

        DLLVERSIONINFO dvi;

        dvi.cbSize = sizeof(dvi);
        hr = (*pDllGetVersion)(&dvi);

        if (SUCCEEDED(hr)) 
        {
          wsprintf(buf, "%i", dvi.dwBuildNumber);
          pushstring(buf);
          wsprintf(buf, "%i.%i", dvi.dwMajorVersion, dvi.dwMinorVersion);
          pushstring(buf);
        }

      } 
      else
        //If GetProcAddress failed, there is a problem 
        // with the DLL.
        hr = E_FAIL;

      FreeLibrary(hBrowser);
    }
  }
}*/

BOOL WINAPI DllMain(HANDLE hInst, ULONG ul_reason_for_call, LPVOID lpReserved)
{
  g_hInstance = (HINSTANCE)hInst;
  return TRUE;
}