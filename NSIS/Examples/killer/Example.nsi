;���Լ��ͽ���32λ������̺�64λ�������

;������ߣ�pigger
;NSIS������̳�׷�
;www.nsisfans.com

OutFile test_ansi.exe

Section test
    ;�������ʾ��
    killer::IsProcessRunning "QQ.exe"
    Pop $R0
    MessageBox MB_OK "�Ƿ������У�$R0"
    
    killer::KillProcess "QQ.exe"
SectionEnd
