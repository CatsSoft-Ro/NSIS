*****************************************************************
***                nsProcess NSIS plugin v1.5                 ***
*****************************************************************

2006 Shengalts Aleksander aka Instructor (Shengalts@mail.ru)

Source function FIND_PROC_BY_NAME based
   upon the Ravi Kochhar (kochhar@physiology.wisc.edu) code
Thanks iceman_k (FindProcDLL plugin) and
   DITMan (KillProcDLL plugin) for direct me


��Ҫ����:
- ͨ�����Ʋ��ҽ���
- ͨ�����ƽ�������
- ����ָ�����Ƶĵ����н��� (��ֹһ��)
- �������Ʋ����ִ�Сд
- ֧�� Win95/98/ME/NT/2000/XP
- �����С (4 Kb)

��������б�:
**** ���ҽ��� ****
	nsProcess::_FindProcess /NOUNLOAD "file.exe" 
	Pop $var	;����ֵ
**** �������� ****
	nsProcess::_KillProcess /NOUNLOAD "file.exe" 
	Pop $var	;����ֵ
**** �ͷŲ�� ****
	nsProcess::_Unload

������б�:
**** ���ҽ��� ****
**** Find process ****
${nsProcess::FindProcess} "[file.exe]" $var

"[file.exe]"  - �������� (�� "notepad.exe")

$var     0    �ɹ�
         603  ���̵�ǰû������
         604  �޷�ȷ��ϵͳ����
         605  ��֧�ֵĲ���ϵͳ
         606  �޷����� NTDLL.DLL
         607  �޷��� NTDLL.DLL ��ó����ַ
         608  NtQuerySystemInformation ʧ��
         609  �޷����� KERNEL32.DLL
         610  �޷��� KERNEL32.DLL ��ó����ַ
         611  CreateToolhelp32Snapshot ʧ��


**** �������� ****
**** Kill process ****
${nsProcess::KillProcess} "[file.exe]" $var

"[file.exe]"  - �������� (�� "notepad.exe")

$var     0    �ɹ�
         601  û�н������̵�Ȩ��
         602  δ�ܽ������ֽ���
         603  ���̵�ǰû������
         604  �޷�ȷ��ϵͳ����
         605  ��֧�ֵĲ���ϵͳ
         606  �޷����� NTDLL.DLL
         607  �޷��� NTDLL.DLL ��ó����ַ
         608  NtQuerySystemInformation ʧ��
         609  �޷����� KERNEL32.DLL
         610  �޷��� KERNEL32.DLL ��ó����ַ
         611  CreateToolhelp32Snapshot ʧ��


**** �ͷŲ�� ****
**** Unload plugin ****
${nsProcess::Unload}
