#pragma once

#define NSISFUNC(name) extern "C" void __declspec(dllexport) name(HWND hWndParent, int string_size, TCHAR* variables, stack_t** stacktop, extra_parameters* extra)
#define DLL_INIT() EXDLL_INIT(); extra->RegisterPluginCallback((HMODULE)g_hInstance, PluginCallback)