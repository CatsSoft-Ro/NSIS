WndProc
--------
����������ӦWindow��Ϣ���ڻص���������һЩ����
��WndSubclass������ƣ�������Subclass Window

�÷�
--------
WndProc::onCallback [/r=x] ������ �ص�������ַ

/r=x ����Ϊ��ѡ�x��ʾҪʹ�õı�������������:
0 - 20 �ֱ��ʾ$0 - $R9
32 ��ʾ��1����Var�����ı�����33�ǵ�2�����������...

��ָ��/r=x���������ʹ����x��ʼ�������ĸ�������Ϊ��Ϣ���������ĸ�����
����ָ��/r=0, ���ڻص������У�
$0 = hwnd,       // handle to window
$1 = uMsg,      // message identifier
$2 = wParam,   // first message parameter
$3 = lParam   // second message parameter

��ûָ��/r=x��������ֻʹ��������Var���������������ֱ���ΪuMsg,wParam,lParam

ʹ�� GetFunctionAddress ��ȡ�����Ļص�������ַ��

ʹ�� SetErrorLevel �� Abort ������Ϣ���������÷���ֵ, �÷���Example������ӡ�
	

��Ȩ����
-------------------------------
Copyright (c) 2011 -2012 gfm688