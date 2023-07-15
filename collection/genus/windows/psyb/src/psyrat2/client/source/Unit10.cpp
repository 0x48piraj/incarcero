//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "Unit1.h"
#include "Unit10.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TForm10 *Form10;
char szIn[128000],szBuffer[4096];
DWORD ret;
//---------------------------------------------------------------------------
__fastcall TForm10::TForm10(TComponent* Owner)
        : TForm(Owner)
{
}
//---------------------------------------------------------------------------

void __fastcall TForm10::Button1Click(TObject *Sender)
{
   char *token,*token2,tmp[128];
   int i;
   ZeroMemory(&szBuffer,4096);
   ZeroMemory(&szIn,128000);
   ZeroMemory(&tmp,128);
   strcpy(szBuffer,"listprocs");
   send(prcclient,(const char *)szBuffer,strlen(szBuffer),0);
   ret = recv(prcclient,(char *)szIn,sizeof(szIn),0);
   if (ret==4294967295) {
      closesocket(prcclient);
   } else {
      lstProcs->Clear();
      token = strtok(szIn,"^");
      while (token != NULL) {
         ZeroMemory(&tmp,128);
         token2 = strstr(token,":")+1;
         lstProcs->Items->Add();
         i = lstProcs->Items->Count - 1;
         strncpy(tmp,token,strcspn(token,":"));
         lstProcs->Items->Item[i]->ImageIndex = 15;
         lstProcs->Items->Item[i]->Caption =  tmp;
         lstProcs->Items->Item[i]->SubItems->Add(token2);
         token = strtok(NULL,"^");
      }

   }
}
//---------------------------------------------------------------------------

void __fastcall TForm10::Button2Click(TObject *Sender)
{
   int i;
   ZeroMemory(&szBuffer,4096);
   if ((lstProcs->Selected) && (lstProcs->Items->Count - 1)) {
      i=lstProcs->Selected->Index;
      strcpy(szBuffer,"killproc ");
      strcat(szBuffer,lstProcs->Items->Item[i]->SubItems->Text.c_str());
      send(prcclient,(const char *)szBuffer,strlen(szBuffer),0);
      ret = recv(prcclient,(char *)szIn,sizeof(szIn),0);
      if (ret==4294967295) {
         closesocket(prcclient);
      } else {
         if (strcmp(szIn,"OK") == 0)
            StatusBar1->Panels->Items[0]->Text = "Successfully terminated process.";
         else
            StatusBar1->Panels->Items[0]->Text = "Could not terminate process.";
      }
   } else
      ShowMessage("No item selected.");

}
//---------------------------------------------------------------------------
