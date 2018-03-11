/*
NSIS ��Դ�ϼ�
By:Ansifa
*/

#��ͷ�ļ�
#$INSTDIR	NSISĿ¼
#$S_DOC     ����˵�����Ŀ¼
Var S_DOC
Var S_ExExamples
############################################
#��װ�����
#�÷���!insertmacro Plugins "AnimGif" "�ڳ�������� GIF ����" "AnimGif.dll"
############################################
!macro Plugins Name Comment DLLName
Section "${Name} (${Comment})"
SectionIn 1 2
SetOutPath "$INSTDIR"
File /r "Plugins\${Name}\*"
IfFileExists "$INSTDIR\Docs\${Name}\${Name}.txt" +1 +2
CreateShortCut "$S_DOC\${Name} (${Comment}).lnk" "$INSTDIR\Docs\${Name}\${Name}.txt"
IfFileExists "$INSTDIR\Docs\${Name}\Readme.txt" +1 +2
CreateShortCut "$S_DOC\${Name} (${Comment}).lnk" "$INSTDIR\Docs\${Name}\Readme.txt"
;WriteINIStr "$INSTDIR\ExtRes.ini" Plugins "${Name}" 1
SectionEnd
!macroend

############################################
#��װ����ʾ��
#�÷���!insertmacro Examples "NSIS ��ȡ��������̷�" "NSIS ��ȡ��������̷�.nsi"
############################################
!macro Examples Name File
Section "${Name}"
SectionIn 1 3
SetOutPath "$INSTDIR\ExExamples"
File /r "..\..\trunk\����\${File}"
IfFileExists "$INSTDIR\ExExamples\${File}" +1 +2
CreateShortCut "$S_ExExamples\${Name}.lnk" "$INSTDIR\ExExamples\${File}"
;WriteINIStr "$INSTDIR\ExtRes.ini" Examples "${Name}" 1
SectionEnd
!macroend

############################################
#ж�ز����
#�÷���!insertmacro Plugins "AnimGif" "�ڳ�������� GIF ����" "AnimGif.dll"
############################################
!macro UnPlugins Name Comment DLLName
Section "Un.${Name} (${Comment})"
SectionIn RO
RMDir /r "$INSTDIR\Docs\${Name}"
RMDir /r "$INSTDIR\Examples\${Name}"
Delete "$INSTDIR\Examples\${Name}.nsi"
Delete "$INSTDIR\Plugins\${DLLName}"
Delete "$S_DOC\${Name} (${Comment}).lnk"
;DeleteINIStr "$INSTDIR\ExtRes.ini" Plugins "${Name}"
SectionEnd
!macroend

############################################
#ж�ش���ʾ��
#�÷���!insertmacro Examples "NSIS ��ȡ��������̷�" "NSIS ��ȡ��������̷�.nsi"
############################################
!macro UnExamples Name File
Section "Un.${Name}"
SectionIn RO
Delete  "$INSTDIR\ExExamples\${File}"
Delete "$S_ExExamples\${Name}.lnk"
;DeleteINIStr "$INSTDIR\ExtRes.ini" Examples "${Name}"
SectionEnd
!macroend
