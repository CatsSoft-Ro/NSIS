// Обработка сбоев при распаковке архива
#undef  ON_CHECK_FAIL
#define ON_CHECK_FAIL()   UnarcQuit()
void UnarcQuit();

// Доступ к структуре архива
#include "ArcStructure.h"

#include "../Compression/MultiThreading.h"
#include "unarcdll.h"

// Доступ к парсингу командной строки и выполнению операций над архивом
#include "ArcCommand.h"
#include "ArcProcess.h"


// Экстренный выход из программы в случае ошибки
void UnarcQuit()
{
  CurrentProcess->quit(FREEARC_ERRCODE_GENERAL);
}


/******************************************************************************
** Описание интерфейса с программой, использующей DLL *************************
******************************************************************************/
class DLLUI : public BASEUI
{
private:
  char outdir[MY_FILENAME_MAX*4];  //unicode: utf-8 encoding
  uint64 totalBytes;
public:
  COMMAND *command;
  Mutex mutex;
  Event DoEvent, EventDone;

  char *what; Number n1, n2; int result; char *str;
  bool event (char *_what, Number _n1, Number _n2, char *_str);

  DLLUI (COMMAND *_command) : command(_command) {}
  bool AllowProcessing (char cmd, int silent, FILENAME arcname, char* comment, int cmtsize, FILENAME outdir);
  FILENAME GetOutDir ();
  void BeginProgress (uint64 totalBytes);
  bool ProgressRead  (uint64 readBytes);
  bool ProgressWrite (uint64 writtenBytes);
  bool ProgressFile  (bool isdir, const char *operation, FILENAME filename, uint64 filesize);
  char AskOverwrite  (FILENAME filename, uint64 size, time_t modified);
  void Abort         (COMMAND *cmd, int errcode);
};


/******************************************************************************
** Реализация интерфейса с программой, использующей DLL ***********************
******************************************************************************/
bool DLLUI::event (char *_what, Number _n1, Number _n2, char *_str)
{
  Lock _(mutex);
  what = _what;
  n1   = _n1;
  n2   = _n2;
  str  = _str;

  DoEvent.Signal();
  EventDone.Wait();
  return result>=FREEARC_OK;
}

void DLLUI::BeginProgress (uint64 totalBytes)
{
  this->totalBytes = totalBytes;
}

bool DLLUI::ProgressRead (uint64 readBytes)
{
  return event ("read", readBytes>>20, totalBytes>>20, "");
}

bool DLLUI::ProgressWrite (uint64 writtenBytes)
{
  return event ("write", writtenBytes>>20, 0, "");
}

bool DLLUI::ProgressFile (bool isdir, const char *operation, FILENAME filename, uint64 filesize)
{
  return event ("filename", 0, 0, filename);
}

FILENAME DLLUI::GetOutDir()
{
  return outdir;
}

bool DLLUI::AllowProcessing (char cmd, int silent, FILENAME arcname, char* comment, int cmtsize, FILENAME _outdir)
{
  strcpy (outdir, _outdir);
  return TRUE;
}

char DLLUI::AskOverwrite (FILENAME filename, uint64 size, time_t modified)
{
  return 'n';
}

void DLLUI::Abort (COMMAND *cmd, int errcode)
{
  event ("quit", errcode, 0, "");
}


/******************************************************************************
** Реализация функционала DLL *************************************************
******************************************************************************/
static THREAD_FUNC_RET_TYPE THREAD_FUNC_CALL_TYPE timer_thread (void *paramPtr)
{
 // DLLUI *ui = (DLLUI*) paramPtr;
 // for(;;)
 // {
   // Sleep(10);
    //ui->event ("timer", 0, 0, "");
 // }
}

static THREAD_FUNC_RET_TYPE THREAD_FUNC_CALL_TYPE decompress_thread (void *paramPtr)
{
  uint64 total_files, origsize, compsize;
  DLLUI *ui = (DLLUI*) paramPtr;
  // Выполнить разобранную команду
  if (ui->command->cmd=='l')
  {
    PROCESS (ui->command, ui, total_files, origsize, compsize);
    ui->event ("total_files", total_files,  0, "");
    ui->event ("origsize",    origsize>>20, 0, "");
    ui->event ("compsize",    compsize>>20, 0, "");
  }
  else
    PROCESS (ui->command, ui);
  ui->what = "quit";
  ui->n1   = FREEARC_OK;
  ui->DoEvent.Signal();
  return 0;
}

int __cdecl FreeArcExtract (cbtype *callback, ...)
{
  va_list argptr;
  va_start(argptr, callback);

  int argc=0;
  char *argv[1000] = {"c:\\unarc.dll"};  //// Здесь будет искаться arc.ini!

  for (int i=1; i<1000; i++)
  {
    argc = i;
    argv[i] = va_arg(argptr, char*);
    if (argv[i]==NULL || argv[i][0]==0)
      {argv[i]=NULL; break;}
  }
  va_end(argptr);




  COMMAND command (argc, argv);    // Распарсить команду
  if (command.ok) {                // Если парсинг был удачен и можно выполнить команду
    command.Prepare();
    Thread thread;
    DLLUI *ui = new DLLUI(&command);
    thread.Create (timer_thread,      ui);   //   Спец. тред, вызывающий callback 100 раз в секунду
    thread.Create (decompress_thread, ui);   //   Выполнить разобранную команду

    for(;;)
    {
      ui->DoEvent.Wait();
      if (strequ (ui->what, "quit"))
        return ui->n1;  // error code of command
      ui->result = callback? callback (ui->what, ui->n1, ui->n2, ui->str) : FREEARC_OK;
      ui->EventDone.Signal();
    }
    thread.Wait();
  }
  return command.ok? FREEARC_OK : FREEARC_ERRCODE_GENERAL;
}


//FreeArc for NSIS Plugin Code starting here.

//Contacts and Copyright
//FreeArc for NSIS is written by Muhammad Khalifa 
//(Syrian Arab Republic) 

//me@smart-arab.com
//http://www.smart-arab.com


#include "pluginapi.h"
#include "windows.h"
#include <commctrl.h>
#include <stdio.h>


using namespace std;

HWND g_hwndParent;
HWND g_hwnddialog;
HWND g_hwndprogress;
HWND g_hwndText;
HWND g_hwndList;

char ArchiveName[256] = "";
	
char ProgressInfo[256] = "";

// To Do
char DetailsInfo[256] = "";

int ShowProgressInfo;

// To Do
int ShowDetailsInfo;

void InitDialogs (HWND hWndParent)
{
	g_hwnddialog = FindWindowExA(hWndParent,NULL, "#32770" , "");

	if (g_hwnddialog)
		g_hwndList = FindWindowExA(g_hwnddialog, NULL, "SysListView32", NULL);
	
	if(g_hwnddialog)
		g_hwndText=GetDlgItem(g_hwnddialog, 1006);
		
	if(g_hwnddialog)
		g_hwndprogress=GetDlgItem(g_hwnddialog, 1004);
}

void SetStatus(const char *pStr)
{
	if (g_hwnddialog)
	{
		if (g_hwndText)
			SetWindowTextA(g_hwndText, pStr);
	}
	return;
}

// To Do
void LogMessage(char *pStr)
{
	if (!g_hwndList)
		return;;	
	
	LVITEM item={0};
	int nItemCount=SendMessage(g_hwndList, LVM_GETITEMCOUNT, 0, 0);
	item.mask=LVIF_TEXT;
	//item.pszText=pStr;
	item.cchTextMax=strlen(pStr);
	item.iItem=nItemCount;
	ListView_InsertItem(g_hwndList, &item);
    ListView_EnsureVisible(g_hwndList, item.iItem, 0);
    return;
}

void SetProgressPos (int Pos)
{	
	SendMessage(g_hwndprogress, PBM_SETPOS, (LPARAM)Pos, 0);
}

typedef int Number;
int TotalProgress = 0;

int __stdcall callbackProgress (char *what, int int1, int int2, char *str)
{
	if(strcmp(what , "compsize") == 0)
		TotalProgress = int1;
	
	if(strcmp(what, "read") == 0)
	{
		if(ShowProgressInfo > 0)
		{
			char PreProgressInfo[256];
			char ReadyProgressInfo[256];
			sprintf(PreProgressInfo, "(%d / %d MB)", int1, int2);
			sprintf(ReadyProgressInfo, ProgressInfo, PreProgressInfo);
			SetStatus(ReadyProgressInfo);
		}
	}
	
	// To Do
	if(strcmp(what , "filename") == 0)
	{
		if(ShowDetailsInfo > 0)
		{
			char PreDetailsInfo[255];
			char ReadyDetailsInfo[256];
			sprintf(PreDetailsInfo, "%s", str);
			sprintf(ReadyDetailsInfo, DetailsInfo, PreDetailsInfo);
			LogMessage(ReadyDetailsInfo);
		}
	}
	
	if(strcmp(what , "read") == 0)
		SetProgressPos(int1);
	
	return 1;
}

extern "C" 
{
void __cdecl ExtractFreeArcArchive(HWND hWndParent, int string_size,char *variables, stack_t **stacktop)
	{
		EXDLL_INIT();

		InitDialogs(hWndParent);

		popstring(ArchiveName);

		ShowProgressInfo = popint();
		popstring(ProgressInfo);

		//To Do
		//ShowDetailsInfo = popint();
		//popstring(DetailsInfo);
		
		char* ExtractPath = getuservariable(INST_OUTDIR);
		
		char ReadyExtractPath[256] = "";
		sprintf(ReadyExtractPath , "-dp%s" , ExtractPath); 
		
		FreeArcExtract(callbackProgress , "l", ArchiveName, ReadyExtractPath , NULL);
				
		SendMessage(g_hwndprogress, PBM_SETRANGE, 0, MAKELPARAM(0,TotalProgress));

		int result = FreeArcExtract(callbackProgress , "x" , "-o+", ArchiveName , ReadyExtractPath, NULL);
		pushint(result);
		
	}
}

