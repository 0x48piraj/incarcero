//---------------------------------------------------------------------------

#include <vcl.h>
#include <winsock.h>
#include <jpeg.hpp>
#include <graphics.hpp>
#pragma hdrstop

#include "Unit9.h"
#include "Unit1.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
#define TBitmap Graphics::TBitmap

TForm9 *Form9;
char szIn[128000],szBuffer[4096];
DWORD ret;

//---------------------------------------------------------------------------


int findlastchr (char s[]) {
   int i;
   i=strlen(s);
   while (s[i-1] != '\\')
      i--;
   return i;
}

//---------------------------------------------------------------------------

__fastcall TForm9::TForm9(TComponent* Owner)
   : TForm(Owner)
{
}
//---------------------------------------------------------------------------

void __fastcall TForm9::Button1Click(TObject *Sender)
{
   int i,j,k,l;
   char *token, *token2, *token3, *filename1p;
   char tok[] = "^";
   char tok2[] = ":";
   char tok3[] = "*";
   char filename1[1024],filetype[5],filesize[32],tmp2[1024], fsize_final[64];
   char filename[1024],modulefilename[1024];
   char tmp[128];
   DWORD fsize,bytesread,totalbytesread;
   char szfIn[2048];
   HANDLE hTrans;
   BOOLEAN downdir,samedir;
   BOOLEAN okfile = FALSE;
   TJPEGImage* Image;
   ZeroMemory(&szBuffer,4096);
   ZeroMemory(&filename,1024);
   ZeroMemory(&filename1,1024);
   ZeroMemory(&tmp2,1024);
   ZeroMemory(&modulefilename,1024);
   //ShowMessage(filename);
   ZeroMemory(szBuffer,4096);
   ZeroMemory(&szIn,128000);
   strcpy(szBuffer,"getscreen");
   GetModuleFileName(NULL,modulefilename,1024);
   strncpy(filename,modulefilename,findlastchr(modulefilename));
   //ShowMessage(filename);
   strcat(filename,"screenshots\\");
   //ShowMessage(filename);
   k=0;
   while (okfile == FALSE) {
      wsprintf(filename1,"%sshot%i.jpg",filename,k);
      //ShowMessage(filename1);
      if (FileExists(filename1)) {
         k++;
         ZeroMemory(&filename1,1024);
         wsprintf(filename1,"shot%i.jpg",k);
         //ShowMessage(filename1);
      } else {
         wsprintf(tmp2,"shot%i.jpg",k);
         okfile = TRUE;
      }
   }
   //strcat(filename,filename1);
   //ShowMessage(filename);
   send(scrclient,(const char *)szBuffer,strlen(szBuffer),0);
   Button1->Enabled = FALSE;
   StatusBar1->Panels->Items[1]->Text = "Server is capturing and encoding";
   ZeroMemory(szBuffer,4096);
   ZeroMemory(&szIn,128000);
   //ShowMessage(filename);
   hTrans = CreateFile(filename1,
      GENERIC_WRITE,
      FILE_SHARE_WRITE,
      NULL,
      CREATE_ALWAYS,
      FILE_ATTRIBUTE_NORMAL,
      NULL);
   if (hTrans != INVALID_HANDLE_VALUE) {
      //uberfsize = GetFileSize(hTrans,NULL);
      //wsprintf(szFsize,"%d",uberfsize);
      ret = recv(scrclient,(char *)szIn,sizeof(szIn),0);
      if (ret==4294967295) {
         closesocket(scrclient);
         Button1->Enabled = TRUE;
      } else {
         ZeroMemory(szBuffer,4096);
			fsize = StrToInt(szIn);
         StatusBar1->Panels->Items[0]->Text = fsize;
         //ShowMessage(szIn);
         ProgressBar1->Max = fsize;
			//send(client,&szOut,strlen(szOut),0);
         totalbytesread = 0;
			bytesread = 0;
         strcpy(szBuffer,"okgo");
         send(scrclient,(const char *)szBuffer,strlen(szBuffer),0);
			while (totalbytesread < fsize) {
				ZeroMemory(&szfIn,2048);
				bytesread = recv(scrclient,(char *)szfIn,sizeof(szfIn),0);
            WriteFile(hTrans,&szfIn,bytesread,&bytesread,NULL);
				totalbytesread += bytesread;
				//bytesread = totalbytesread;
            ProgressBar1->Position = totalbytesread;
				//printf("%s",sendblk);
				//send(client,(const char *)szBuffer,strlen(szBuffer),0);
			}
         CloseHandle(hTrans);
         ProgressBar1->Position = 0;
         strcpy(tmp,"Screenshot saved as screenshots\\");
         strcat(tmp,tmp2);
         StatusBar1->Panels->Items[1]->Text = tmp;
			ZeroMemory(&szBuffer,4096);
         Image = new TJPEGImage();
         Image->LoadFromFile(filename1);
         Image->Smoothing = TRUE;
         Image1->Picture = (TPicture *)Image;
         Button1->Enabled = TRUE;
      }
   } else ShowMessage("Couldn't create file.");
}
//---------------------------------------------------------------------------


void __fastcall TForm9::FormResize(TObject *Sender)
{
   Image1->Width = (Form9->Width - 9);
   Image1->Height = (Form9->Height - 97);
   Button1->Top = (Form9->Height - 80);
   ProgressBar1->Top = (Form9->Height - 100);
   Button1->Left = ((ProgressBar1->Width / 2)-(Button1->Width/2));
   ProgressBar1->Width = (Form9->Width - 9);
}
//---------------------------------------------------------------------------
