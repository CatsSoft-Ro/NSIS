/*
	EmbedHTMLBrowser C++ class by Stuart Welch <afrowuk@afrowsoft.co.uk>
	v1.0.0.1 - 19th October 2014
*/

#include "EmbedHTMLBrowser.h"

#pragma comment(lib, "Shlwapi.lib")

CEmbedHTMLBrowser::CEmbedHTMLBrowser(HWND hWndParent, const RECT& rc, const PTCHAR szUrl, bool bEnableMaxEmulation) :
	m_pOleObject(NULL),
	m_pOleInPlaceObject(NULL),
	m_pWebBrowser2(NULL),
	m_iComRefCount(0),
	m_hWndControl(NULL)
{
	this->m_rObject = rc;
	this->m_hWndParent = hWndParent;

	ZeroMemory(this->m_wszExecutableName, sizeof(this->m_wszExecutableName));
	ZeroMemory(this->m_wszOptionKeyPath, sizeof(this->m_wszOptionKeyPath));

	if (GetModuleFileNameW(NULL, this->m_wszExecutableName, MAX_PATH) > 0)
	{
		PathStripPathW(this->m_wszExecutableName);
		wsprintfW(this->m_wszOptionKeyPath, L"SOFTWARE\\%s EmbedHTMLBrowser %d", this->m_wszExecutableName, rand() % 1000 + 1);
	}

	this->ApplyBrowserRegistryConfig(bEnableMaxEmulation);

	if (CreateBrowser())
	{
		bstr_t url(szUrl);
		variant_t flags(0x02u); //navNoHistory
		this->m_pWebBrowser2->put_Silent(VARIANT_TRUE);
		this->m_pWebBrowser2->Navigate(url, &flags, 0, 0, 0);
	}
}

bool CEmbedHTMLBrowser::CreateBrowser()
{
	if (FAILED(::OleCreate(CLSID_WebBrowser, IID_IOleObject, OLERENDER_DRAW, 0, this, this, (void**)&this->m_pOleObject)))
	{
		return false;
	}

	this->m_pOleObject->SetClientSite(this);
	OleSetContainedObject(this->m_pOleObject, TRUE);

	if (FAILED(this->m_pOleObject->QueryInterface(&this->m_pWebBrowser2)))
	{
		return false;
	}

	RECT hiMetricRect = PixelToHiMetric(this->m_rObject);
	SIZEL sz;
	sz.cx = hiMetricRect.right - hiMetricRect.left;
	sz.cy = hiMetricRect.bottom - hiMetricRect.top;
	this->m_pOleObject->SetExtent(DVASPECT_CONTENT, &sz);

	if (FAILED(this->m_pOleObject->DoVerb(OLEIVERB_INPLACEACTIVATE, NULL, this, -1, this->m_hWndParent, &this->m_rObject)))
	{
		return false;
	}
	
	return true;
}

RECT CEmbedHTMLBrowser::PixelToHiMetric(const RECT& rc)
{
	static bool s_initialized = false;
	static int s_pixelsPerInchX, s_pixelsPerInchY;

	if (!s_initialized)
	{
		HDC hdc = ::GetDC(0);
		s_pixelsPerInchX = ::GetDeviceCaps(hdc, LOGPIXELSX);
		s_pixelsPerInchY = ::GetDeviceCaps(hdc, LOGPIXELSY);
		::ReleaseDC(0, hdc);
		s_initialized = true;
	}

	RECT rcNew;
	rcNew.left = MulDiv(2540, rc.left, s_pixelsPerInchX);
	rcNew.top = MulDiv(2540, rc.top, s_pixelsPerInchY);
	rcNew.right = MulDiv(2540, rc.right, s_pixelsPerInchX);
	rcNew.bottom = MulDiv(2540, rc.bottom, s_pixelsPerInchY);
	return rcNew;
}

void CEmbedHTMLBrowser::Destroy()
{
	this->RevertBrowserRegistryConfig();
	
	if (this->m_pWebBrowser2)
	{
		this->m_pWebBrowser2->Stop();
		this->m_pWebBrowser2->ExecWB(OLECMDID_CLOSE, OLECMDEXECOPT_DONTPROMPTUSER, 0, 0);
		this->m_pWebBrowser2->put_Visible(VARIANT_FALSE);
		this->m_pWebBrowser2->Release();
		this->m_pWebBrowser2 = NULL;
	}

	if (this->m_pOleInPlaceObject)
	{
		this->m_pOleInPlaceObject->InPlaceDeactivate();
		this->m_pOleInPlaceObject->Release();
		this->m_pOleInPlaceObject = NULL;
	}
	
	if (this->m_pOleObject)
	{
		this->m_pOleObject->DoVerb(OLEIVERB_HIDE, NULL, this, 0, this->m_hWndParent, NULL);
		this->m_pOleObject->Close(OLECLOSE_NOSAVE);
		OleSetContainedObject(this->m_pOleObject, FALSE);
		this->m_pOleObject->SetClientSite(NULL);
	}
}

// ----- IUnknown -----

HRESULT STDMETHODCALLTYPE CEmbedHTMLBrowser::QueryInterface(REFIID riid, void**ppvObject)
{
	if (!ppvObject)
			return E_INVALIDARG;

	if (riid == __uuidof(IUnknown))
	{
		(*ppvObject) = static_cast<IOleClientSite*>(this);
	}
	else if (riid == __uuidof(IOleInPlaceSite))
	{
		(*ppvObject) = static_cast<IOleInPlaceSite*>(this);
	}
	else if (riid == __uuidof(IDocHostUIHandler))
	{
		(*ppvObject) = static_cast<IDocHostUIHandler*>(this);
	}
	else
	{
		(*ppvObject) = NULL;
		return E_NOINTERFACE;
	}

	this->AddRef();
	return S_OK;
}

ULONG STDMETHODCALLTYPE CEmbedHTMLBrowser::AddRef(void)
{
	return InterlockedIncrement(&this->m_iComRefCount);
}

ULONG STDMETHODCALLTYPE CEmbedHTMLBrowser::Release(void)
{
	LONG iComRefCount = InterlockedDecrement(&this->m_iComRefCount);
	if (iComRefCount == 0) { delete this; }
	return iComRefCount;
}

// ---------- IOleWindow ----------

HRESULT STDMETHODCALLTYPE CEmbedHTMLBrowser::GetWindow(__RPC__deref_out_opt HWND *phwnd)
{
	(*phwnd) = this->m_hWndParent;
	return S_OK;
}

HRESULT STDMETHODCALLTYPE CEmbedHTMLBrowser::ContextSensitiveHelp(BOOL fEnterMode)
{
	return E_NOTIMPL;
}

// ---------- IOleInPlaceSite ----------

HRESULT STDMETHODCALLTYPE CEmbedHTMLBrowser::CanInPlaceActivate(void)
{
	return S_OK;
}

HRESULT STDMETHODCALLTYPE CEmbedHTMLBrowser::OnInPlaceActivate(void)
{
	OleLockRunning(this->m_pOleObject, TRUE, FALSE);

	this->m_pOleObject->QueryInterface(&this->m_pOleInPlaceObject);
	this->m_pOleInPlaceObject->SetObjectRects(&this->m_rObject, &this->m_rObject);

	return S_OK;
}

HRESULT STDMETHODCALLTYPE CEmbedHTMLBrowser::OnUIActivate(void)
{
	return S_OK;
}

HRESULT STDMETHODCALLTYPE CEmbedHTMLBrowser::GetWindowContext(__RPC__deref_out_opt IOleInPlaceFrame **ppFrame, __RPC__deref_out_opt IOleInPlaceUIWindow **ppDoc, __RPC__out LPRECT lprcPosRect, __RPC__out LPRECT lprcClipRect, __RPC__inout LPOLEINPLACEFRAMEINFO lpFrameInfo)
{
	(*ppFrame) = NULL;
	(*ppDoc) = NULL;
	(*lprcPosRect).left = this->m_rObject.left;
	(*lprcPosRect).top = this->m_rObject.top;
	(*lprcPosRect).right = this->m_rObject.right;
	(*lprcPosRect).bottom = this->m_rObject.bottom;
	*lprcClipRect = *lprcPosRect;

	lpFrameInfo->fMDIApp = false;
	lpFrameInfo->hwndFrame = this->m_hWndParent;
	lpFrameInfo->haccel = NULL;
	lpFrameInfo->cAccelEntries = 0;

	return S_OK;
}

HRESULT STDMETHODCALLTYPE CEmbedHTMLBrowser::Scroll(SIZE scrollExtant)
{
	return E_NOTIMPL;
}

HRESULT STDMETHODCALLTYPE CEmbedHTMLBrowser::OnUIDeactivate(BOOL fUndoable)
{
	return S_OK;
}

HWND CEmbedHTMLBrowser::GetControlWindow()
{
	if (this->m_hWndControl)
		return this->m_hWndControl;

	if (!this->m_pOleInPlaceObject)
		return 0;

	this->m_pOleInPlaceObject->GetWindow(&this->m_hWndControl);
	return this->m_hWndControl;
}

HRESULT STDMETHODCALLTYPE CEmbedHTMLBrowser::OnInPlaceDeactivate(void)
{
	this->m_hWndControl = NULL;
	return S_OK;
}

HRESULT STDMETHODCALLTYPE CEmbedHTMLBrowser::DiscardUndoState(void)
{
	return E_NOTIMPL;
}

HRESULT STDMETHODCALLTYPE CEmbedHTMLBrowser::DeactivateAndUndo(void)
{
	return E_NOTIMPL;
}

HRESULT STDMETHODCALLTYPE CEmbedHTMLBrowser::OnPosRectChange(__RPC__in LPCRECT lprcPosRect)
{
	return E_NOTIMPL;
}

// ---------- IOleClientSite ----------

HRESULT STDMETHODCALLTYPE CEmbedHTMLBrowser::SaveObject(void)
{
	return E_NOTIMPL;
}

HRESULT STDMETHODCALLTYPE CEmbedHTMLBrowser::GetMoniker(DWORD dwAssign, DWORD dwWhichMoniker, __RPC__deref_out_opt IMoniker **ppmk)
{
	if (dwAssign == OLEGETMONIKER_ONLYIFTHERE && dwWhichMoniker == OLEWHICHMK_CONTAINER)
		return E_FAIL;
	return E_NOTIMPL;
}

HRESULT STDMETHODCALLTYPE CEmbedHTMLBrowser::GetContainer(__RPC__deref_out_opt IOleContainer **ppContainer)
{
	return E_NOINTERFACE;
}

HRESULT STDMETHODCALLTYPE CEmbedHTMLBrowser::ShowObject(void)
{
	return S_OK;
}

HRESULT STDMETHODCALLTYPE CEmbedHTMLBrowser::OnShowWindow(BOOL fShow)
{
	return S_OK;
}

HRESULT STDMETHODCALLTYPE CEmbedHTMLBrowser::RequestNewObjectLayout(void)
{
	return E_NOTIMPL;
}

// ----- IStorage -----

HRESULT STDMETHODCALLTYPE CEmbedHTMLBrowser::CreateStream(__RPC__in_string const OLECHAR *pwcsName, DWORD grfMode, DWORD reserved1, DWORD reserved2, __RPC__deref_out_opt IStream **ppstm)
{
	return E_NOTIMPL;
}

HRESULT STDMETHODCALLTYPE CEmbedHTMLBrowser::OpenStream(const OLECHAR *pwcsName, void *reserved1, DWORD grfMode, DWORD reserved2, IStream **ppstm)
{
	return E_NOTIMPL;
}

HRESULT STDMETHODCALLTYPE CEmbedHTMLBrowser::CreateStorage(__RPC__in_string const OLECHAR *pwcsName, DWORD grfMode, DWORD reserved1, DWORD reserved2, __RPC__deref_out_opt IStorage **ppstg)
{
	return E_NOTIMPL;
}

HRESULT STDMETHODCALLTYPE CEmbedHTMLBrowser::OpenStorage(__RPC__in_opt_string const OLECHAR *pwcsName, __RPC__in_opt IStorage *pstgPriority, DWORD grfMode,  __RPC__deref_opt_in_opt SNB snbExclude, DWORD reserved, __RPC__deref_out_opt IStorage **ppstg)
{
	return E_NOTIMPL;
}

HRESULT STDMETHODCALLTYPE CEmbedHTMLBrowser::CopyTo(DWORD ciidExclude, const IID *rgiidExclude, __RPC__in_opt  SNB snbExclude, IStorage *pstgDest)
{
	return E_NOTIMPL;
}

HRESULT STDMETHODCALLTYPE CEmbedHTMLBrowser::MoveElementTo(__RPC__in_string const OLECHAR *pwcsName, __RPC__in_opt IStorage *pstgDest, __RPC__in_string const OLECHAR *pwcsNewName, DWORD grfFlags)
{
	return E_NOTIMPL;
}

HRESULT STDMETHODCALLTYPE CEmbedHTMLBrowser::Commit(DWORD grfCommitFlags)
{
	return E_NOTIMPL;
}

HRESULT STDMETHODCALLTYPE CEmbedHTMLBrowser::Revert(void)
{
	return E_NOTIMPL;
}

HRESULT STDMETHODCALLTYPE CEmbedHTMLBrowser::EnumElements(DWORD reserved1, void *reserved2, DWORD reserved3, IEnumSTATSTG **ppenum)
{
	return E_NOTIMPL;
}

HRESULT STDMETHODCALLTYPE CEmbedHTMLBrowser::DestroyElement(__RPC__in_string const OLECHAR *pwcsName)
{
	return E_NOTIMPL;
}

HRESULT STDMETHODCALLTYPE CEmbedHTMLBrowser::RenameElement(__RPC__in_string const OLECHAR *pwcsOldName, __RPC__in_string const OLECHAR *pwcsNewName)
{
	return E_NOTIMPL;
}

HRESULT STDMETHODCALLTYPE CEmbedHTMLBrowser::SetElementTimes(__RPC__in_opt_string const OLECHAR *pwcsName, __RPC__in_opt const FILETIME *pctime, __RPC__in_opt const FILETIME *patime, __RPC__in_opt const FILETIME *pmtime)
{
	return E_NOTIMPL;
}

HRESULT STDMETHODCALLTYPE CEmbedHTMLBrowser::SetClass(__RPC__in REFCLSID clsid)
{
	return S_OK;
}

HRESULT STDMETHODCALLTYPE CEmbedHTMLBrowser::SetStateBits(DWORD grfStateBits, DWORD grfMask)
{
	return E_NOTIMPL;
}

HRESULT STDMETHODCALLTYPE CEmbedHTMLBrowser::Stat(__RPC__out STATSTG *pstatstg, DWORD grfStatFlag)
{
	return E_NOTIMPL;
}

// ----- IDocHostUIHandler -----

HRESULT CEmbedHTMLBrowser::ShowContextMenu(DWORD dwID, POINT *ppt, IUnknown *pcmdTarget, IDispatch *pdispObject) 
{
	return S_OK;
}

HRESULT STDMETHODCALLTYPE CEmbedHTMLBrowser::ShowUI(DWORD dwID, IOleInPlaceActiveObject FAR* pActiveObject, IOleCommandTarget FAR* pCommandTarget, IOleInPlaceFrame  FAR* pFrame, IOleInPlaceUIWindow FAR* pDoc)
{
	return E_NOTIMPL;
}

HRESULT STDMETHODCALLTYPE CEmbedHTMLBrowser::GetHostInfo(DOCHOSTUIINFO FAR *pInfo)
{
	return E_NOTIMPL;
}

HRESULT STDMETHODCALLTYPE CEmbedHTMLBrowser::HideUI(void)
{
	return E_NOTIMPL;
}

HRESULT STDMETHODCALLTYPE CEmbedHTMLBrowser::UpdateUI(void)
{
	return E_NOTIMPL;
}

HRESULT STDMETHODCALLTYPE CEmbedHTMLBrowser::EnableModeless(BOOL fEnable)
{
	return E_NOTIMPL;
}

HRESULT STDMETHODCALLTYPE CEmbedHTMLBrowser::OnDocWindowActivate(BOOL fActivate)
{
	return E_NOTIMPL;
}

HRESULT STDMETHODCALLTYPE CEmbedHTMLBrowser::OnFrameWindowActivate(BOOL fActivate)
{
	return E_NOTIMPL;
}

HRESULT STDMETHODCALLTYPE CEmbedHTMLBrowser::ResizeBorder(LPCRECT prcBorder, IOleInPlaceUIWindow FAR* pUIWindow, BOOL fFrameWindow)
{
	return E_NOTIMPL;
}

HRESULT STDMETHODCALLTYPE CEmbedHTMLBrowser::TranslateAccelerator(LPMSG lpMsg, const GUID FAR* pguidCmdGroup, DWORD nCmdID)
{
	return E_NOTIMPL;
}

HRESULT STDMETHODCALLTYPE CEmbedHTMLBrowser::GetOptionKeyPath(LPOLESTR FAR* pchKey, DWORD dw)
{
	if (*this->m_wszOptionKeyPath)
	{
		if (!pchKey)
			return E_INVALIDARG;

		*pchKey = (LPOLESTR)CoTaskMemAlloc(sizeof(WCHAR) * (lstrlenW(this->m_wszOptionKeyPath) + 1));
		if (*pchKey)
		{
			lstrcpyW(*pchKey, this->m_wszOptionKeyPath);
			return S_OK;
		}
	}

	return S_FALSE;
}

HRESULT STDMETHODCALLTYPE CEmbedHTMLBrowser::GetDropTarget(IDropTarget* pDropTarget, IDropTarget** ppDropTarget)
{
	return E_NOTIMPL;
}

HRESULT STDMETHODCALLTYPE CEmbedHTMLBrowser::GetExternal(IDispatch** ppDispatch)
{
	return E_NOTIMPL;
}

HRESULT STDMETHODCALLTYPE CEmbedHTMLBrowser::TranslateUrl(DWORD dwTranslate, OLECHAR* pchURLIn, OLECHAR** ppchURLOut)
{
	return E_NOTIMPL;
}

HRESULT STDMETHODCALLTYPE CEmbedHTMLBrowser::FilterDataObject(IDataObject* pDO, IDataObject** ppDORet)
{
	return E_NOTIMPL;
}

USHORT CEmbedHTMLBrowser::GetInternetExplorerVersion()
{
	USHORT uVersion = 0;

	HKEY hKey;
	if (SUCCEEDED(RegOpenKeyEx(HKEY_LOCAL_MACHINE, TEXT("SOFTWARE\\Microsoft\\Internet Explorer"), 0, KEY_READ | KEY_WOW64_64KEY, &hKey)))
	{
		DWORD dwType, dwSize;
		PTCHAR pszVersion = NULL;

		if (SUCCEEDED(RegQueryValueEx(hKey, TEXT("svcVersion"), NULL, &dwType, NULL, &dwSize)) && dwType == REG_SZ)
		{
			pszVersion = (PTCHAR)GlobalAlloc(GPTR, dwSize);
			if (pszVersion)
			{
				if (!SUCCEEDED(RegQueryValueEx(hKey, TEXT("svcVersion"), NULL, &dwType, (LPBYTE)pszVersion, &dwSize)))
				{
					GlobalFree(pszVersion);
					pszVersion = NULL;
				}
			}
		}
		else if (SUCCEEDED(RegQueryValueEx(hKey, TEXT("Version"), NULL, &dwType, NULL, &dwSize)) && dwType == REG_SZ)
		{
			pszVersion = (PTCHAR)GlobalAlloc(GPTR, dwSize);
			if (pszVersion)
			{
				if (!SUCCEEDED(RegQueryValueEx(hKey, TEXT("Version"), NULL, &dwType, (LPBYTE)pszVersion, &dwSize)))
				{
					GlobalFree(pszVersion);
					pszVersion = NULL;
				}
			}
		}
		
		if (pszVersion)
		{
			if (*pszVersion)
			{
				for (DWORD i = 0; i < dwSize / sizeof(TCHAR); i++)
				{
					if (pszVersion[i] == '.')
					{
						pszVersion[i] = NULL;
						break;
					}
				}

				uVersion = atoi(pszVersion);
			}

			GlobalFree(pszVersion);
		}

		RegCloseKey(hKey);
	}

	return uVersion;
}

#define OpenBrowserEmulationRegKey(hKey) SUCCEEDED(RegCreateKeyEx(HKEY_CURRENT_USER, TEXT("SOFTWARE\\Microsoft\\Internet Explorer\\Main\\FeatureControl\\FEATURE_BROWSER_EMULATION"), 0, NULL, 0, KEY_WRITE | KEY_SET_VALUE | KEY_WOW64_64KEY, NULL, hKey, NULL))

void CEmbedHTMLBrowser::ApplyBrowserRegistryConfig(BOOL bEnableMaxEmulation)
{
	if (!*this->m_wszExecutableName)
		return;

	HKEY hKey;
	if (bEnableMaxEmulation)
	{
		USHORT uVersion = GetInternetExplorerVersion();
		if (uVersion > 7)
		{
			if (OpenBrowserEmulationRegKey(&hKey))
			{
				DWORD dwValue = uVersion * 1000;
				RegSetKeyValueW(hKey, NULL, this->m_wszExecutableName, REG_DWORD, &dwValue, sizeof(DWORD));
				RegCloseKey(hKey);
			}
		}
	}
	
	if (SUCCEEDED(RegCreateKeyExW(HKEY_CURRENT_USER, this->m_wszOptionKeyPath, 0, NULL, 0, KEY_WRITE | KEY_SET_VALUE, NULL, &hKey, NULL)))
	{
		HKEY hKeyMain;
		if (SUCCEEDED(RegCreateKeyExA(hKey, "Main", 0, NULL, 0, KEY_WRITE | KEY_SET_VALUE, NULL, &hKeyMain, NULL)))
		{
			RegSetKeyValueA(hKeyMain, NULL, "Display Inline Images", REG_SZ, "yes", 4);
			RegCloseKey(hKeyMain);
		}

		RegCloseKey(hKey);
	}
}

void CEmbedHTMLBrowser::RevertBrowserRegistryConfig()
{
	if (!*this->m_wszExecutableName)
		return;

	HKEY hKey;
	if (OpenBrowserEmulationRegKey(&hKey))
	{
		RegDeleteValueW(hKey, this->m_wszExecutableName);
		RegCloseKey(hKey);
	}

	RegDeleteTreeW(HKEY_CURRENT_USER, this->m_wszOptionKeyPath);
}