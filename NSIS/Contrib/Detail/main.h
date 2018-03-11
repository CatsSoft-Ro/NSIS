#ifndef _MAIN_H
#define _MAIN_H

#pragma comment(lib, "libctiny.lib")
#pragma comment(linker, "/defaultlib:kernel32.lib")
#pragma comment(linker, "/nodefaultlib:libc.lib")
#pragma comment(linker, "/nodefaultlib:libcmt.lib")

#define PLUGFUNCTION(myFunction) void __declspec(dllexport) myFunction(HWND hwndParent, int string_size, char *variables, stack_t **stacktop, extra_parameters *extra)

unsigned int my_atoi(char *s) 
{
	unsigned int v=0;
	if (*s == '0' && (s[1] == 'x' || s[1] == 'X')) 
	{
		s+=2;
		for (;;) 
		{
			int c=*s++;
			if (c >= '0' && c <= '9') c-='0';
			else if (c >= 'a' && c <= 'f') c-='a'-10;
			else if (c >= 'A' && c <= 'F') c-='A'-10;
			else break;
			v<<=4;
			v+=c;
		}
	}
	else if (*s == '0' && s[1] <= '7' && s[1] >= '0') 
	{
		s++;
		for (;;) 
		{
			int c=*s++;
			if (c >= '0' && c <= '7') c-='0';
			else break;
			v<<=3;
			v+=c;
		}
	}
	else 
	{
		for (;;) 
		{
			int c=*s++ - '0';
			if (c < 0 || c > 9) break;
			v*=10;
			v+=c;
		}
	}
	return (int)v;
}

#endif