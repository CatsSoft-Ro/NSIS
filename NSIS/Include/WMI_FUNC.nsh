!ifndef WMI_FUNC_INCLUDED
!define WMI_FUNC_INCLUDED

!include Util.nsh

!verbose push
!verbose 3
!ifndef _WMI_FUNC_VERBOSE
	!define _WMI_FUNC_VERBOSE 3
!endif
!verbose ${_WMI_FUNC_VERBOSE}
!define WMI_FUNC_VERBOSE `!insertmacro WMI_FUNC_VERBOSE`
!verbose pop

!macro WMI_FUNC_VERBOSE _VERBOSE
	!verbose push
	!verbose 3
	!undef _WMI_FUNC_VERBOSE
	!define _WMI_FUNC_VERBOSE ${_VERBOSE}
	!verbose pop
!macroend

!define VT_EMPTY                       0
!define VT_NULL                        1
!define VT_I2                          2
!define VT_I4                          3
!define VT_R4                          4
!define VT_R8                          5
!define VT_CY                          6
!define VT_DATE                        7
!define VT_BSTR                        8
!define VT_DISPATCH                    9
!define VT_ERROR                       10
!define VT_BOOL                        11
!define VT_UNKNOWN                     13
!define VT_UI1                         17
!define VT_UI2                         18
!define VT_UI4                         19
!define VT_UI8                         21
!define VT_INT                         22
!define VT_UINT                        23
!define VT_ARRAY                       8200
!define VT_BYREF                       16384
!define VT_BYREF|VT_I1                 16400
!define VT_BYREF|VT_UI1                16401
!define VT_BYREF|VT_UI2                16402
!define VT_BYREF|VT_UI4                16403
!define VT_BYREF|VT_I8                 16404
!define VT_BYREF|VT_UI8                16405
!define VT_BYREF|VT_INT                16406
!define VT_BYREF|VT_UINT               16407
!define VT_BYREF|VT_I4                 16387
!define VT_BYREF|VT_R4                 16388
!define VT_BYREF|VT_R8                 16389
!define VT_BYREF|VT_CY                 16390
!define VT_BYREF|VT_DATE               16391
!define VT_BYREF|VT_BSTR               16392
!define VT_BYREF|VT_BOOL               16395
!define VT_BYREF|VT_VARIANT            16396
!define VT_BYREF|VT_UNKNOWN            16397
!define VT_BYREF|VT_DECIMAL            16398
;/////////////////////////////////////
!define RPC_C_AUTHN_NONE           0
!define RPC_C_AUTHN_DCE_PRIVATE    1
!define RPC_C_AUTHN_DCE_PUBLIC     2
!define RPC_C_AUTHN_DEC_PUBLIC     4
!define RPC_C_AUTHN_GSS_NEGOTIATE  9
!define RPC_C_AUTHN_WINNT         10
!define RPC_C_AUTHN_GSS_SCHANNEL  14
!define RPC_C_AUTHN_GSS_KERBEROS  16
!define RPC_C_AUTHN_DPA           17
!define RPC_C_AUTHN_MSN           18
!define RPC_C_AUTHN_KERNEL        20
!define RPC_C_AUTHN_DIGEST        21
!define RPC_C_AUTHN_NEGO_EXTENDER 30
!define RPC_C_AUTHN_PKU2U         31
!define RPC_C_AUTHN_MQ            100
!define RPC_C_AUTHN_DEFAULT       0xFFFFFFFF
;/////////////////////////////////////
!define RPC_C_AUTHN_LEVEL_DEFAULT       0
!define RPC_C_AUTHN_LEVEL_NONE          1
!define RPC_C_AUTHN_LEVEL_CONNECT       2
!define RPC_C_AUTHN_LEVEL_CALL          3
!define RPC_C_AUTHN_LEVEL_PKT           4
!define RPC_C_AUTHN_LEVEL_PKT_INTEGRITY 5
!define RPC_C_AUTHN_LEVEL_PKT_PRIVACY   6
;/////////////////////////////////
!define RPC_C_IMP_LEVEL_DEFAULT     0
!define RPC_C_IMP_LEVEL_ANONYMOUS   1
!define RPC_C_IMP_LEVEL_IDENTIFY    2
!define RPC_C_IMP_LEVEL_IMPERSONATE 3
!define RPC_C_IMP_LEVEL_DELEGATE    4
;/////////////////////////////////
!define RPC_C_AUTHZ_NONE    0
!define RPC_C_AUTHZ_NAME    1
!define RPC_C_AUTHZ_DCE     2
!define RPC_C_AUTHZ_DEFAULT 0xffffffff
;/////////////////////////////////
!define COINIT_APARTMENTTHREADED       2
!define EOAC_NONE                      0
!define CLSCTX_INPROC_SERVER           1
!define WBEM_FLAG_CONNECT_USE_MAX_WAIT 128
!define WBEM_INFINITE                  0xffffffff
!define WBEM_FLAG_FORWARD_ONLY         0x20
!define WBEM_FLAG_RETURN_IMMEDIATELY   0x10
;/////////////////////////////////////
!define WBEM_S_NO_ERROR                0
;/////////////////////////////////////
!define CLSID_IEnumWbemClassObject     "{1B1CAD8C-2DAB-11D2-B604-00104B703EFD}"
!define IID_IEnumWbemClassObject       "{7C857801-7381-11CF-884D-00AA004B2E24}"
!define CLSID_WbemLocator              "{4590f811-1d3a-11d0-891f-00aa004b2e24}"
!define IID_IWbemLocator               "{dc12a687-737f-11cf-884d-00aa004b2e24}"

!macro WMI_FUNC_DECLARE_VAR
   !verbose push
   !verbose ${_FILEFUNC_VERBOSE}
   !ifndef WMI_FUNC_VARS_DECLARE
      !define WMI_FUNC_VARS_DECLARE
      Var /GLOBAL UERROR
      Var /GLOBAL IWbemServices
      Var /GLOBAL IWbemLocator
      Var /GLOBAL IEnumWbemClassObject
      Var /GLOBAL IWbemClassObject
      StrCpy $UERROR 0xFFFFFF
      StrCpy $IWbemServices 0
      StrCpy $IWbemLocator 0
      StrCpy $IEnumWbemClassObject 0
      StrCpy $IWbemClassObject 0
      System::Store S
      System::Call "kernel32::GetCurrentProcess(v)i.R0"
      System::Call "advapi32::OpenProcessToken(iR0,i0x28,*i.R1)i.R0"
      ${Unless} $R0 == 0
         System::Call 'advapi32::LookupPrivilegeValue(i0,t"SeDebugPrivilege",*l.R2) i.R0'
         ${Unless} $R0 == 0
            System::Call "*(i1,lR2,i2)i.R0"
            System::Call "advapi32::AdjustTokenPrivileges(iR1, i0, iR0, i0, i0, i0)"
            System::Free $R0
         ${EndUnless}
         System::Call "kernel32::CloseHandle(iR1)"
      ${EndUnless}
      System::Store L
   !endif
   !verbose pop
!macroend

!macro WMI_FUNC_DECLARE_VAR_VARIANT
   !verbose push
   !verbose ${_FILEFUNC_VERBOSE}
   !ifndef WMI_FUNC_VARS_tagVARIANT
       !define WMI_FUNC_VARS_tagVARIANT
       Var /GLOBAL buffVARIANT
       Var /GLOBAL BSTR_TYPE
       StrCpy $buffVARIANT 0
       StrCpy $BSTR_TYPE 0
   !endif
   !verbose pop
!macroend

!define WMI_Connect "!insertmacro Call_WMIConnect"
!macro Call_WMIConnect NAMECONNECT OUT RESULT
   !verbose push
   !verbose ${_FILEFUNC_VERBOSE}
   !insertmacro WMI_FUNC_DECLARE_VAR
   System::Call "ole32::CoInitializeEx(i0,i${COINIT_APARTMENTTHREADED})"
   System::Call "ole32::CoInitializeSecurity(i0,i-1,i0,i0,i${RPC_C_AUTHN_LEVEL_CONNECT},i${RPC_C_IMP_LEVEL_IMPERSONATE},i0,i${EOAC_NONE},i0)"
   System::Call "ole32::CoCreateInstance(g'${CLSID_WbemLocator}',i0,i${CLSCTX_INPROC_SERVER},g'${IID_IWbemLocator}',*i.s)" ;Create a connection to a WMI namespace
   Pop $IWbemLocator
   System::Call "$IWbemLocator->3(w'${NAMECONNECT}',i0,i0,i0,i${WBEM_FLAG_CONNECT_USE_MAX_WAIT},i0,i0,*i.s)i.s" ;Set the security levels on the WMI connection
   Pop `${OUT}`
   Pop `${RESULT}`
   !verbose pop
!macroend

!define CoSetProxyBlanket "!insertmacro Call_CoSetProxyBlanket"
!macro Call_CoSetProxyBlanket Proxy
    System::Call "ole32::CoSetProxyBlanket(i${Proxy},i${RPC_C_AUTHN_WINNT},\
    i${RPC_C_AUTHZ_NONE},i0,i${RPC_C_AUTHN_LEVEL_CALL},\
    i${RPC_C_IMP_LEVEL_IMPERSONATE},i0,i${EOAC_NONE})"
!macroend

!define Release "!insertmacro Call_Release" ;Cleanup and shut down your application
!macro Call_Release Object
   !verbose push
   !verbose ${_FILEFUNC_VERBOSE}
    System::Call "${Object}->2()"
   !verbose pop
!macroend

!define IWbemServices->ExecQuery "!insertmacro Call_IWbemServices->ExecQuery"
!macro Call_IWbemServices->ExecQuery strQuery OUT RESULT
   !verbose push
   !verbose ${_FILEFUNC_VERBOSE}
   System::Call "$IWbemServices->20(w`WQL`, w`${strQuery}`, i${WBEM_FLAG_FORWARD_ONLY}|${WBEM_FLAG_RETURN_IMMEDIATELY},i0, *i.s)i.s" ;Querying WMI
   Pop `${OUT}`
   Pop `${RESULT}`
   !verbose pop
!macroend

!define IWbemServices->GetObject "!insertmacro Call_IWbemServices->GetObject"
!macro Call_IWbemServices->GetObject ObjectPath OUT RESULT
   System::Call "$IWbemServices->6(w'${ObjectPath}',i0,i0,*i.s,i0)i.s"
   Pop `${OUT}`
   Pop `${RESULT}`
!macroend

!define IEnumWbemClassObject->Next "!insertmacro Call_IEnumWbemClassObject->Next"
!macro Call_IEnumWbemClassObject->Next OUT RESULT
   !verbose push
   !verbose ${_FILEFUNC_VERBOSE}
   System::Call "$IEnumWbemClassObject->4(i${WBEM_INFINITE},i1,*i.s,*i.s)" ;Enumerating WMI
   Pop `${RESULT}`
   Pop `${OUT}`
   !verbose pop
!macroend

!define IWbemClassObject->Get "!insertmacro Call_IWbemClassObject->Get"
!macro Call_IWbemClassObject->Get NameObject OUT
   !verbose push
   !verbose ${_FILEFUNC_VERBOSE}
    !insertmacro WMI_FUNC_DECLARE_VAR_VARIANT
    System::Call "*(i,i,i)i.s"
    Pop $buffVARIANT
    System::Call "$IWbemClassObject->4(w'${NameObject}',i0,i$buffVARIANT,i0,i0)"
    System::Call "*$buffVARIANT(i.s,i,i.s)"
    Pop $BSTR_TYPE
    Pop ${OUT}
    ${Select} $BSTR_TYPE
        ${Case2} ${VT_NULL} ${VT_EMPTY}
            StrCpy `${OUT}` ""
        ${Case3} ${VT_I2} ${VT_I4} ${VT_UI4}
        ${Case2} ${VT_BSTR} ${VT_UI8}
            IntFmt `${OUT}` %S ${OUT}
        ${Case} ${VT_BOOL}
            IntCmp ${OUT} 0 +1 +1 +2
            StrCpy ${OUT} false
            IntCmp ${OUT} 0 +2 +2 +1
            StrCpy ${OUT} true
        ${Case2} ${VT_UNKNOWN} ${VT_BYREF|VT_UNKNOWN}
            StrCpy `${OUT}` "UNKNOWN"
        ${Default}
            StrCpy `${OUT}` "</$BSTR_TYPE/>"
    ${EndSelect}
    System::Call "ole32::VariantClear(i$buffVARIANT)"
    System::Free $buffVARIANT
    !verbose pop
!macroend



!endif