!addplugindir .

Name nsURI
OutFile nsURI.exe

XPStyle on
InstallColors /windows
ShowInstDetails show

Section Install
    # ANSI/GBK decodeURI
    nsURI::decodeURI "http://www.baidu.com/s?wd=%B0%D9%B6%C8%CB%D1%CB%F7"
    Pop $R0
    DetailPrint "ANSI/GBK decodeURI:"
    DetailPrint $R0

    # UTF-8 decodeURI
    nsURI::decodeURI "http://www.baidu.com/s?wd=%E7%99%BE%E5%BA%A6%E6%90%9C%E7%B4%A2"
    Pop $R0
    DetailPrint "UTF-8 decodeURI:"
    DetailPrint $R0

    # UTF-8 encodeURI
    nsURI::encodeURI "http://www.baidu.com/s?wd=百度搜索"
    Pop $R0
    DetailPrint "UTF-8 encodeURI:"
    DetailPrint $R0

    # UTF-8 encodeURIComponent
    nsURI::encodeURIComponent "http://www.baidu.com/s?wd=百度搜索"
    Pop $R0
    DetailPrint "UTF-8 encodeURIComponent:"
    DetailPrint $R0

    # UTF-8 decodeURIComponent
    nsURI::decodeURIComponent $R0
    Pop $R0
    DetailPrint "UTF-8 decodeURIComponent:"
    DetailPrint $R0
SectionEnd