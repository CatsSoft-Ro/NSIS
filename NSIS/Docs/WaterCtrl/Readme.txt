<NSISͼƬˮ����Ч�ű�>
�ű���д��zhfi
�ر��л��Restools��X-Star

��ʾ:ˮ�Ƶ�ͼ�����Ƿ�ת��ͼƬ����ʾ��ʱ��ᷭתͼƬ����ʾ��


Restools��ˮ����Ч��� - ��ֲ��NSIS�� 20080709���� 

restools
http://restools.hanzify.org
ʱ��ִ٣����Կ��ܻ��е��������д���������
waterctrl.dll Ϊһ������ Inno Setup �� 16.5 KB ��ˮ����Ч�����
��Ҫע�⣬���ʹ�� MFC, ϵͳ��Ҫ�� mfc42.dll������һ��ϵͳ�Դ���

v2 �汾  ��������ˮ�Ʋ���ĸ����

Function enablewater(ParentWnd: HWND; Left, Top: integer; Bmp: HBITMAP;
     WaterRadius, WaterHeight: integer): BOOL; external 'enablewater@files:waterctrl.dll stdcall';
//ParentWnd     ������Ч���ڵĸ����ھ����
//Left          ��λ��
//Top           ��λ��
//Bmp           λͼ�����
//WaterRadius   ˮ�ư뾶�����ˮ�ƿ�������Χ���㡣
//WaterHeight   ˮ�Ƹ߶ȣ����ˮ�ƿ��������
//ע�⣬ˮ�Ʋ���Զ�����ͼƬ���趨�߶ȺͿ�ȣ�
//����ˮ�Ƶ�ͼ�����Ƿ�ת��ͼƬ����ʾ��ʱ��ᷭתͼƬ����ʾ��

