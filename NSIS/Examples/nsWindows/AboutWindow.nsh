; --------------------------------------
; �����NSIS���� nsWindows �������ڴ��ڵ�ʾ��
; �����в��ֳ��ú�������ϸ˵��

; ����, ��Ȼ��Ҫ�������ͷ�ļ�, ����ʹ�����еĺ����ͺ�
!include "nsWindows.nsh"

; ��������������ĳ�ͻ���������ǰ�����ж�
!ifndef hWNDAboutWindow
 ;  ������Ĵ��ھ��
 ;  �����Ҫ�ڽű��������ط�ʹ��ĳ�ؼ�, ��Ҫ���������ؼ��ľ��
  var hWNDAboutWindow
  !define hWNDAboutWindow
!endif

; �����������ڴ�������
Function ${un}.AboutWindow
; �жϴ����Ƿ����, ������ھ���ʾ����, �����ظ�����
  IsWindow $hWNDAboutWindow Create_End
  
/*�����ﴴ������,�Լ���������*/
  ; �����Ȼ�ǲ�����ڵ�������
  ; ��ʽ:	${NSW_CreateWindow} ���洰�ھ���ı��� ���ڱ��� Ҫģ�µ�NSIS�ڲ��Ի���
	${NSW_CreateWindow} $hWNDAboutWindow "���� $(^NameDA) v${VERSION} �������ǿ��" 1018
;  ShowWindow $hWNDAboutWindow ${SW_HIDE}

;�������ں�,��Ҫ�ȶԴ��ڽ��е���,�������ڴ�С,λ��,������ɫ,�ȵ�
  ; ���ô��ڵı���ɫ(�����ǰ�ɫ)
	SetCtlColors $hWNDAboutWindow "" ${WHITE}
  ; ���ô��ڴ�С(��λ: ����)
  ${NSW_SetWindowSize} $hWNDAboutWindow 450 420
  ; ���ô���λ��(��λ: ����)
  ;  ${NSW_SetWindowPos} $hWNDAboutWindow 450 420
  ; ���ô��ھ���
  ; ��ʽ: ${NSW_CenterWindow} ���ھ��  �������յĸ����ھ��
  ${NSW_CenterWindow} $hWNDAboutWindow $hwndparent
  
  ; ��С������
;  ${NSW_MinimizeWindow} $hwndparent
;  EnableWindow $hwndparent 0

  ;���ô��ڲ�͸����
  ${NSW_SetTransparent} $hWNDAboutWindow 95

  ;���ڵ�ҳ��ص�����, Ҳ��������X��ť��Ҫִ�еĺ���
	${NSW_OnBack} ${un}.OnAboutClose

/*�����￪ʼ, ������Լ��Ŀؼ�*/
  ; ����һ��Label�ؼ�, ��֧�ֵĿؼ����������˵���ļ�, �÷���������nsDialogs����
	${NSW_CreateLabel} 15 8 95% 40% "����ǿ�����������ķ���֮�⻹����Ҫ���ĵ����˷��벢�����˹ٷ�\
  	�汾�������������ϰ�����ﲻ����֮����������ʹ�ýű�����д��װ�����\
  	�ڴ��������˵�������Ѷ������׳���Ϊ�ˣ���ǿ���Ｏ����һ��\
  	�൱���õĽű��༭�� - VNISEdit ��ǿ�� (Build 060712 By Restools)��\
  	ֻ��Ҫ�����򵼾������ɵ������ܿ�İ�װ�������������������������\
  	���İ�װ��������������桢�����İ�װ�����ڰ�װ�����в������֣����⣬\
  	ֻ��Ҫ�㼸����꼴�ɡ�����֮�⣬VNISEdit ������ע���ת����������԰�\
  	 .reg �ļ�һ���Ե�ת��Ϊ NSIS �ű������������򵼿���һ���Ե�Ϊ��������\
  	����С�Ĳ��������������⣬����ǿ�滹�ڹٷ��汾�Ļ����ϼ�����һЩ����\
  	�Ĳ���ͷ����ű���\
   $\n$\n���ڸ��������ʹ��ʱ���Զ���������ǿ���Ƽ���װȫ�������"
    ; ������ Label �ľ��, �Ӷ�ջ�е���, ���� $R0 ($R0 �൱�ھֲ�����
    ; �������Ҫ������λ��ʹ��������, ���Զ���һ������������.)
		Pop $R0
      SetCtlColors $R0 0x009300 ${WHITE} ;���ÿؼ���ɫ(ǰ��ɫ, ����ɫ)
		
  StrCpy $0 100
  StrCpy $1 12
	${NSW_CreateLabel} 15 $0u 30% 10u "��Ҫ������:"
		Pop $R0
		SetCtlColors $R0 0x009300 ${WHITE}

  IntOp $0 $0 + $1
	${NSW_CreateLink} 40 $0u 30% 12u ��ɫ����
		Pop $R0
		SetCtlColors $R0 ${BLUE} ${WHITE}
	; ��ӿؼ����¼�, һ���� OnClick , Ҳ���ǵ��, �������͵��¼������˵���ļ�
	; ��ʽ: ${NSW_OnClick}  �ؼ���� Ŀ�꺯��
	${NSW_OnClick} $R0 ${un}.On��ɫ����

  IntOp $0 $0 + $1
	${NSW_CreateLink} 40 $0u 30% 12u Restools
		Pop $R0
		SetCtlColors $R0 ${BLUE} ${WHITE}
	${NSW_OnClick} $R0 ${un}.OnRestools

  IntOp $0 $0 + $1
	${NSW_CreateLink} 40 $0u 30% 12u ������
		Pop $R0
		SetCtlColors $R0 ${BLUE} ${WHITE}
	${NSW_OnClick} $R0 ${un}.On������

  IntOp $0 $0 + $1
	${NSW_CreateLink} 40 $0u 30% 12u ��ˮ�껪
		Pop $R0
		SetCtlColors $R0 ${BLUE} ${WHITE}
	${NSW_OnClick} $R0 ${un}.On��ˮ�껪

  IntOp $0 $0 + $1
	${NSW_CreateLink} 40 $0u 30% 12u X-Star
		Pop $R0
		SetCtlColors $R0 ${BLUE} ${WHITE}
	${NSW_OnClick} $R0 ${un}.OnX-Star

  IntOp $0 $0 + $1
	${NSW_CreateLink} 40 $0u 30% 12u zhfi
		Pop $R0
		SetCtlColors $R0 ${BLUE} ${WHITE}
	${NSW_OnClick} $R0 ${un}.Onzhfi

  IntOp $0 $0 + $1
	${NSW_CreateLink} 40 $0u 30% 12u Athanasia
		Pop $R0
		SetCtlColors $R0 ${BLUE} ${WHITE}
	${NSW_OnClick} $R0 ${un}.OnAthanasia

  IntOp $0 $0 + $1
	${NSW_CreateLabel} 15 $0u 95% 20u "������$\t�����������ġ��ֿɡ���� ��\
    $\n�˰汾��zhfi��ǿ��Ļ���������������´�����ڴ�һ����л��"
		Pop $R0
		SetCtlColors $R0 0x009300 ${WHITE}

	${NSW_CreateButton} 40% -22u 50u 18u '�ر�'
		Pop $R0
		SetCtlColors $R0 "" ${WHITE}
	${NSW_OnClick} $R0 ${un}.OnAboutClose

/*�����еĿؼ������֮��, ����������꽫������ʾ����, �Լ�����������ӵ��ؼ����¼�*/
	${NSW_MessageBeep} ${MB_ICONINFORMATION} ;������ʾ����
	${NSW_Show}
Create_End:
  ShowWindow $hWNDAboutWindow ${SW_SHOW}
  EnableWindow $HWNDPARENT 0
FunctionEnd

;�ؼ��ص�����
Function ${un}.OnAboutClose
  ${NSW_CloseWindow} $hWNDAboutWindow
  EnableWindow $HWNDPARENT 1
  BringToFront
FunctionEnd

Function ${un}.On��ɫ����
	ExecShell "open" "http://hi.baidu.com/ikiki/"
FunctionEnd

Function ${un}.OnRestools
	ExecShell "open" "http://restools.hanzify.org/"
FunctionEnd

Function ${un}.On������
	ExecShell "open" "http://chenmy.hanzify.org/"
FunctionEnd

Function ${un}.On��ˮ�껪
	ExecShell "open" "http://www.dreams8.com/"
FunctionEnd

Function ${un}.OnX-Star
	ExecShell "open" "http://hi.baidu.com/XStar2008/"
FunctionEnd

Function ${un}.OnAthanasia
	ExecShell "open" "http://www.dreams8.com/"
FunctionEnd

Function ${un}.Onzhfi
	ExecShell "open" "http://hi.baidu.com/zhfi1022/"
FunctionEnd

