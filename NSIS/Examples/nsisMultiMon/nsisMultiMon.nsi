/*nsisMultiMon Test
nsisMultiMon������ʾ��������
By Ansifa*/

OutFile "nsisMultiMon Test.EXE"
ShowInstDetails show
Section
nsisMultiMon::GetAllMonitorCount
DetailPrint '����$R0����ʾ��'

nsisMultiMon::GetActiveMonitorCount
DetailPrint '�����ʾ����$R0��'

nsisMultiMon::GetVirtualDesktopRect
DetailPrint '���淶ΧΪ��ԭ�㣺($R0,$R1)������($R2,$R3)'

nsisMultiMon::GetMonitorRect 0 ; [ID:int]
DetailPrint '��ʾ��0����һ������ΧΪ��ԭ�㣺($R0,$R1)������($R2,$R3)'

nsisMultiMon::GetWorkArea
DetailPrint '��������Χ����ȥ������������״̬����Ϊ��ԭ�㣺($R0,$R1)������($R2,$R3)'

nsisMultiMon::IsPointOnMonitor 0 800 600 ; [ID:int] [X:int] [Y:int]
DetailPrint '�㣺(800��600)�Ƿ�����ʾ��0���棺$R0'

nsisMultiMon::IsPointOnMonitor 0 2000 2000 ; [ID:int] [X:int] [Y:int]
DetailPrint '�㣺(2000��2000)�Ƿ�����ʾ��0���棺$R0'

DetailPrint "����װ���򴰿��Ƶ���ʾ��n���棬�Թ�����/��ʾ��Ϊ������ʾ����"
nsisMultiMon::CenterInstallerOnMonitor 0 0 ; [��ʾ�����n] [������Ϊ����ֵ0����ʾ��1]

SectionEnd
