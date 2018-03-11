InetBgDL::Get [/RESET] <URL1> <local_file1> [<URLN> <local_fileN>] /END
	/RESET must be used if status $0 > 299, it can also be used to abort all active downloads.

InetBgDL::GetStats
	$0 = HTTP status code, 0=Completed
	$1 = Completed files
	$2 = Remaining files
	$3 = Number of downloaded bytes for the current file
	$4 = Size of current file (Empty string if the size is unknown)


History
=======

20130326 - AndersK
+Added build flag to hardcode a long INTERNET_OPTION_RECEIVE_TIMEOUT
+Debug version prints WinInet info.

20130324 - AndersK
*/RESET should be faster to abort
+Uses INTERNET_FLAG_SECURE on HTTPS URLs

20110922 - AndersK
*Initial public release