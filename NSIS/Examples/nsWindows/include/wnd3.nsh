;handle to window 3
var hwindow3

Function nsWindowsPage3
  IsWindow $hwindow3 Create_End
	${NSW_CreateWindow} $hwindow3 "WND 3" 1018  ;��������
  ;set window pos
;  ${NSW_SetWindowPos} $hwindow3 0 0  ;��������λ��
  ;set window size
  ${NSW_SetWindowSize} $hwindow3 200 100  ;�������ڴ�С
  ;set the child window's pos to the center of parent window
  ${NSW_CenterWindow} $hwindow3 $hwndparent  ;������$hwindow3������$hwndparent

  ;call back function of window 3
	${NSW_OnBack} OnBack3  ;���ڵĻص�����, �ڵ��Xϵͳ��ť�رմ���ʱִ��

	${NSW_CreateButton} 50 -30 50 18u 'WND 1'
	 Pop $R0
	${NSW_OnClick} $R0 nsWindowsPage1

	${NSW_CreateButton} 100 -30 50 18u 'WND 2'
	 Pop $R0
	${NSW_OnClick} $R0 nsWindowsPage2

;Show Window 3
	${NSW_Show}
Create_End:
;Show Window 3
  ShowWindow $hwindow3 ${SW_SHOW}
FunctionEnd

Function OnBack3
;Close Window 3
  ${NSW_DestroyWindow} $hwindow3
FunctionEnd


