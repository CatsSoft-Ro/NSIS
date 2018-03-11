Function TickCountStart
	!define TickCountStart `!insertmacro TickCountStartCall`
 
	!macro TickCountStartCall
		Call TickCountStart
	!macroend

        System::Alloc 400 
        pop $2 
        Push $0
        System::Call 'kernel32::GetTickCount64()l.r0'
	System::Call 'kernel32::GetTickCount()i .r0'
	StrCmp $0 error 0 +2
	Exch $0
	System::Free $2
FunctionEnd
 
Function TickCountEnd
	!define TickCountEnd `!insertmacro TickCountEndCall`
 
	!macro TickCountEndCall _RESULT
		Call TickCountEnd
		Pop ${_RESULT}
	!macroend
 
	Exch $0
	Push $1
        System::Call 'kernel32::GetTickCount(v)i.r1'
        IntOp $2 $1 - $0
	Pop $0
	Pop $1
	Exch $0
FunctionEnd