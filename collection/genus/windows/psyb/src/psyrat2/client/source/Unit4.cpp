//---------------------------------------------------------------------------

#include <vcl.h>
#include <winsock.h>
#pragma hdrstop

#include "Unit4.h"
#include "Unit1.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "Unit8"
#pragma link "Unit6"
#pragma link "Unit7"
#pragma link "Unit5"
#pragma resource "*.dfm"
TForm4 *Form4;
char szBuffer[4096],szIn[128000];
char filelocation[2048];
DWORD ret;
//---------------------------------------------------------------------------
void dir_slice (char s[],int numdirs)
{
   int i,j;
   char s2[1024];
   ZeroMemory(&s2,1024);
   i=strlen(s);
   j=0;
   if (s[i-1] == '\\'){
      i--;
      //ShowMessage("ok");
   }
   while ((j < numdirs) && (i > 0)) {
      if (s[i-1] == '\\') j++;
      i--;
   }
   strncpy(s2,s,i);
   strcpy(s,s2);
}

int findlastchr (char s[]) {
   int i;
   i=strlen(s);
   while (s[i-1] != '\\')
      i--;
   return i;
}

void __fastcall TForm4::dir_refresh() {
   int i,j,k;
   char *token, *token2, *token3, *filename1p;
   char tok[] = "^";
   char tok2[] = ":";
   char tok3[] = "*";
   char filename1[1024],filetype[5],filesize[32],tmp2[1024], fsize_final[64];
   char filename[1024],modulefilename[1024];
        BOOLEAN downdir, samedir;
        SuspendThread(hTimeThread);
        ZeroMemory(&szBuffer,4096);
        ZeroMemory(&filename1,1024);
        ZeroMemory(&tmp2,1024);
        ZeroMemory(&filename,1024);
        ZeroMemory(&modulefilename,1024);
        ZeroMemory(&fsize_final,64);
        ZeroMemory(&filetype,5);
        Sleep(100);
        strcpy(filelocation,txtLocation->Text.c_str());
        strcpy(szBuffer,"listdir ");
        strncat(szBuffer,filelocation,strlen(filelocation));
        send(fileclient,(const char *)szBuffer,strlen(szBuffer),0);
        //strncpy(filelocation,txtDrives->Text.c_str(),3);
        if (strstr(filelocation,"\\..\\")) {
           dir_slice(filelocation,2);
           strcat(filelocation,"\\");
        }
        if (strstr(filelocation,"\\.\\")) {
           dir_slice(filelocation,1);
           strcat(filelocation,"\\");
        }
        txtLocation->Text = filelocation;
        ret = recv(fileclient,(char *)szIn,sizeof(szIn),0);
        if (ret==4294967295) {
            closesocket(fileclient);
        } else {
           //txtStatus->Lines->Add(szIn);
           token = strtok(szIn,tok);
           lstFiles->Clear();
           while (token!=NULL)
           {
               ZeroMemory(filename1,1024);
               ZeroMemory(filetype,5);
               ZeroMemory(filesize,32);
               //ZeroMemory(tmp2,1024);

               strncpy(filename1,token,strcspn(token,":"));
               token2 = strstr(token,":")+1;
               strncpy(filetype,token2,3);
               lstFiles->Items->Add(); // Add a new item
               j = lstFiles->Items->Count - 1; // get the new items index
               if (strstr(filetype,"fil")) {
                   lstFiles->Items->Item[j]->ImageIndex=4;
                   lstFiles->Items->Item[j]->Caption="2";
                   token3 = strstr(token,"*")+1;
                   strcpy(filesize,token3);
                   if (StrToInt(filesize) < 1024) {
                      wsprintf(fsize_final,"%s B",filesize);
                   } else if ((StrToInt(filesize) > 1024) && (StrToInt(filesize) < 1048576)) {
                      wsprintf(fsize_final,"%s KB",IntToStr(StrToInt(filesize)/1024));
                   } else if ((StrToInt(filesize) > 1048576) && (StrToInt(filesize) < 1073741824)) {
                      wsprintf(fsize_final,"%s MB",IntToStr(StrToInt(filesize)/1048576));
                   } else
                      wsprintf(fsize_final,"%s GB",IntToStr(StrToInt(filesize)/1073741824));
                } else {
                   lstFiles->Items->Item[j]->ImageIndex=1;
                   lstFiles->Items->Item[j]->Caption="1";
                   strcpy(fsize_final,"");
                }
                //ShowMessage(IntToStr(j));
                //filename1p = filename1;
                lstFiles->Items->Item[j]->SubItems->Add(filename1); // set the item text
                lstFiles->Items->Item[j]->SubItems->Add(filetype);
                lstFiles->Items->Item[j]->SubItems->Add(fsize_final);
                lstFiles->CustomSort(NULL,0);
                token = strtok(NULL,tok);
           }
        }
        ResumeThread(hTimeThread);
}

__fastcall TForm4::TForm4(TComponent* Owner)
   : TForm(Owner)
{
}
//---------------------------------------------------------------------------

void __fastcall TForm4::Button9Click(TObject *Sender)
{
   char test[1024];
   char tok[] = "^";
   char *token;
   ZeroMemory(&szBuffer,4096);
   ZeroMemory(&szIn,128000);
   SuspendThread(hTimeThread);
   strcpy(szBuffer,"getdrives");
   send(fileclient,(const char *)szBuffer,strlen(szBuffer),0);
   ret = recv(fileclient,(char *)szIn,sizeof(szIn),0);
   //ShowMessage(ret);
   if (ret==4294967295) {
      closesocket(fileclient);
   } else {
      txtDrives->Clear();
      txtDrives->Text = "Drives recieved.";
      StatusBar1->Panels->Items[0]->Text = "Drives recieved.";
      token = strtok(szIn,tok);
      while (token!=NULL) {
         txtDrives->Items->Add(token);
         token = strtok(NULL,tok);
      }
      ZeroMemory(&szIn,128000);
   }
   ResumeThread(hTimeThread);
}
//---------------------------------------------------------------------------

void __fastcall TForm4::txtDrivesChange(TObject *Sender)
{
   char *token, *token2, *token3;
   char tok[] = "^";
   char tok2[] = ":";
   char tok3[] = "*";
   char filename1[1024],filetype[5],filesize[32],tmp2[1024], fsize_final[64];
   int i;
   SuspendThread(hTimeThread);
   lstFiles->Clear();
   ZeroMemory(&szBuffer,4096);
   ZeroMemory(&szIn,128000);
   ZeroMemory(&filelocation,2048);
   strcpy(szBuffer,"listdir ");
   strncat(szBuffer,txtDrives->Text.c_str(),3);
   send(fileclient,(const char *)szBuffer,strlen(szBuffer),0);
   strncpy(filelocation,txtDrives->Text.c_str(),3);
   txtLocation->Text = filelocation;
   ret = recv(fileclient,(char *)szIn,sizeof(szIn),0);
   if (ret==4294967295) {
      closesocket(fileclient);
   } else {
      token = strtok(szIn,tok);
      while (token!=NULL)
      {
         ZeroMemory(&filename1,1024);
         ZeroMemory(&filetype,5);
         ZeroMemory(&filesize,32);
         ZeroMemory(&fsize_final,64);
         //ZeroMemory(tmp2,1024);
         lstFiles->Items->Add(); // Add a new item
         i = lstFiles->Items->Count - 1;
         strncpy(filename1,token,strcspn(token,":"));
         token2 = strstr(token,":")+1;
         strncpy(filetype,token2,3);
         if (strstr(filetype,"dir")) {
            lstFiles->Items->Item[i]->ImageIndex=1;
            lstFiles->Items->Item[i]->Caption="1";
            strcpy(fsize_final,"");
         } else if (strstr(filetype,"fil")) {
            lstFiles->Items->Item[i]->ImageIndex=4;
            lstFiles->Items->Item[i]->Caption="2";
            token3 = strstr(token2,"*")+1;
            strcpy(filesize,token3);
            if (StrToInt(filesize) < 1024) {
               wsprintf(fsize_final,"%s B",filesize);
            } else if ((StrToInt(filesize) > 1024) && (StrToInt(filesize) < 1048576)) {
               wsprintf(fsize_final,"%s KB",IntToStr(StrToInt(filesize)/1024));
            } else if ((StrToInt(filesize) > 1048576) && (StrToInt(filesize) < 1073741824)) {
               wsprintf(fsize_final,"%s MB",IntToStr(StrToInt(filesize)/1048576));
            } else
               wsprintf(fsize_final,"%s GB",IntToStr(StrToInt(filesize)/1073741824));
         }

         lstFiles->Items->Item[i]->SubItems->Add(filename1); // set the item text
         lstFiles->Items->Item[i]->SubItems->Add(filetype);
         lstFiles->Items->Item[i]->SubItems->Add(fsize_final);
         lstFiles->CustomSort(NULL,0);
         token = strtok(NULL,tok);
      }
   }
   ResumeThread(hTimeThread);
}
//---------------------------------------------------------------------------
void __fastcall TForm4::lstFilesDblClick(TObject *Sender)
{
   int i,j,k;
   char *token, *token2, *token3, *filename1p;
   char tok[] = "^";
   char tok2[] = ":";
   char tok3[] = "*";
   char filename1[1024],filetype[5],filesize[32],tmp2[1024], fsize_final[64];
   char filename[1024],modulefilename[1024];
   BOOLEAN downdir, samedir;
   SuspendThread(hTimeThread);
   ZeroMemory(&szBuffer,4096);
   ZeroMemory(&szIn,128000);
   if (!(lstFiles->Items->Count == 0)) {
   i = lstFiles->Selected->Index;
   if (strcmp(lstFiles->Items->Item[i]->SubItems->Strings[1].c_str(),"dir") == 0) {
        //if (strcmp(lstFiles->Items->Item[i]->SubItems->Strings[0].c_str(),"dir") == 0) {
        strcpy(filelocation,txtLocation->Text.c_str());
           strcat(filelocation,lstFiles->Items->Item[i]->SubItems->Strings[0].c_str());
           strcat(filelocation,"\\");
        strcpy(szBuffer,"listdir ");
        strncat(szBuffer,filelocation,strlen(filelocation));
        send(fileclient,(const char *)szBuffer,strlen(szBuffer),0);
        //strncpy(filelocation,txtDrives->Text.c_str(),3);
        if (strstr(filelocation,"\\..\\")) {
           dir_slice(filelocation,2);
           strcat(filelocation,"\\");
        }
        if (strstr(filelocation,"\\.\\")) {
           dir_slice(filelocation,1);
           strcat(filelocation,"\\");
        }
        txtLocation->Text = filelocation;
        ret = recv(fileclient,(char *)szIn,sizeof(szIn),0);
        if (ret==4294967295) {
            closesocket(fileclient);
        } else {
           //txtStatus->Lines->Add(szIn);
           token = strtok(szIn,tok);
           lstFiles->Clear();
           while (token!=NULL)
           {
               ZeroMemory(filename1,1024);
               ZeroMemory(filetype,5);
               ZeroMemory(filesize,32);
               //ZeroMemory(tmp2,1024);

               strncpy(filename1,token,strcspn(token,":"));
               token2 = strstr(token,":")+1;
               strncpy(filetype,token2,3);
               lstFiles->Items->Add(); // Add a new item
               j = lstFiles->Items->Count - 1; // get the new items index
               if (strstr(filetype,"fil")) {
                   lstFiles->Items->Item[j]->ImageIndex=4;
                   lstFiles->Items->Item[j]->Caption="2";
                   token3 = strstr(token,"*")+1;
                   strcpy(filesize,token3);
                   if (StrToInt(filesize) < 1024) {
                      wsprintf(fsize_final,"%s B",filesize);
                   } else if ((StrToInt(filesize) > 1024) && (StrToInt(filesize) < 1048576)) {
                      wsprintf(fsize_final,"%s KB",IntToStr(StrToInt(filesize)/1024));
                   } else if ((StrToInt(filesize) > 1048576) && (StrToInt(filesize) < 1073741824)) {
                      wsprintf(fsize_final,"%s MB",IntToStr(StrToInt(filesize)/1048576));
                   } else
                      wsprintf(fsize_final,"%s GB",IntToStr(StrToInt(filesize)/1073741824));
                } else {
                   lstFiles->Items->Item[j]->ImageIndex=1;
                   lstFiles->Items->Item[j]->Caption="1";
                   strcpy(fsize_final,"");
                }
                //ShowMessage(IntToStr(j));
                //filename1p = filename1;

                lstFiles->Items->Item[j]->SubItems->Add(filename1); // set the item text
                lstFiles->Items->Item[j]->SubItems->Add(filetype);
                lstFiles->Items->Item[j]->SubItems->Add(fsize_final);
                lstFiles->CustomSort(0,0);
                token = strtok(NULL,tok);


           }
        }

   } else {
      int j;
      ZeroMemory(&filename,1024);
      ZeroMemory(&modulefilename,1024);
      //ShowMessage("not a directory foo.");
      i = lstFiles->Selected->Index;
      GetModuleFileName(NULL,modulefilename,1024);
      strncpy(filename,modulefilename,findlastchr(modulefilename));
      strcat(filename,lstFiles->Items->Item[i]->SubItems->Strings[0].c_str());
      //ShowMessage(filename);
      ZeroMemory(szBuffer,4096);
      ZeroMemory(&szIn,128000);
      strcpy(szBuffer,"sendfile ");
      strcat(szBuffer,txtLocation->Text.c_str());
      strcat(szBuffer,lstFiles->Items->Item[i]->SubItems->Strings[0].c_str());
      //ShowMessage(filename);
      //ShowMessage(lstFiles->Items->Item[i]->SubItems->Strings[0].c_str());
      send(fileclient,(const char *)szBuffer,strlen(szBuffer),0);
      HANDLE hTrans;
      hTrans = CreateFile(filename,
         GENERIC_WRITE,
         FILE_SHARE_WRITE,
         NULL,
         CREATE_ALWAYS,
         FILE_ATTRIBUTE_NORMAL,
         NULL);
		if (hTrans != INVALID_HANDLE_VALUE) {
         DWORD fsize,bytesread,totalbytesread;
         char szfIn[2048];
			//uberfsize = GetFileSize(hTrans,NULL);
			//wsprintf(szFsize,"%d",uberfsize);
         ret = recv(fileclient,(char *)szIn,sizeof(szIn),0);
         //ShowMessage(ret);
      if (ret==4294967295) {
         closesocket(fileclient);
      } else {
			fsize = StrToInt(szIn);
         ProgressBar1->Max = fsize;
			//send(client,&szOut,strlen(szOut),0);
         totalbytesread = 0;
			bytesread = 0;
         strcpy(szBuffer,"okgo");
         send(fileclient,(const char *)szBuffer,strlen(szBuffer),0);
			while (totalbytesread < fsize) {
				ZeroMemory(&szfIn,2048);
				bytesread = recv(fileclient,(char *)szfIn,sizeof(szfIn),0);
            WriteFile(hTrans,&szfIn,bytesread,&bytesread,NULL);
				totalbytesread += bytesread;
				//bytesread = totalbytesread;
            ProgressBar1->Position = totalbytesread;
				//printf("%s",sendblk);
				//send(client,(const char *)szBuffer,strlen(szBuffer),0);
			}
         CloseHandle(hTrans);
         ProgressBar1->Position = 0;
         StatusBar1->Panels->Items[0]->Text = "File downloaded successfully!";
			ZeroMemory(szBuffer,4096);
      }
      }
   }
   }
   ResumeThread(hTimeThread);
}
//---------------------------------------------------------------------------
void __fastcall TForm4::FormCreate(TObject *Sender)
{
   lstFiles->Columns->Items[2]->Width = 0;
}
//---------------------------------------------------------------------------
void __fastcall TForm4::frCopy1Button1Click(TObject *Sender)
{
   int i;
   char filename[32];
   SuspendThread(hTimeThread);
   ZeroMemory(&szBuffer,2048);
   ZeroMemory(&szIn,128000);
   i = lstFiles->Selected->Index;
   strcpy(filename,txtLocation->Text.c_str());
   strcat(filename,lstFiles->Items->Item[i]->SubItems->Strings[0].c_str());
   strcpy(szBuffer,"fil_copy ");
   strcat(szBuffer,filename);
   strcat(szBuffer," ");
   strcat(szBuffer,frCopy1->Edit1->Text.c_str());
   strcat(szBuffer,lstFiles->Items->Item[i]->SubItems->Strings[0].c_str());
   send(fileclient,(const char *)szBuffer,strlen(szBuffer),0);
   ret = recv(fileclient,(char *)szIn,sizeof(szIn),0);
   if (ret==4294967295) {
      closesocket(fileclient);
   } else {
      if (strcmp(szIn,"ERR_CPY") == 0)
         MessageBox(0,"Error copying file.","Error",MB_ICONERROR);
      else
         StatusBar1->Panels->Items[0]->Text = "Copied file successfully.";
      frCopy1->Visible = FALSE;
      lstFiles->Enabled = TRUE;
   }
  ResumeThread(hTimeThread);
}
//---------------------------------------------------------------------------
void __fastcall TForm4::frCopy1Button2Click(TObject *Sender)
{
   frCopy1->Visible = FALSE;
   lstFiles->Enabled = TRUE;   
}
//---------------------------------------------------------------------------
void __fastcall TForm4::frMove1Button1Click(TObject *Sender)
{
   int i;
   char filename[32];
   SuspendThread(hTimeThread);
   ZeroMemory(&szBuffer,2048);
   ZeroMemory(&szIn,128000);
   i = lstFiles->Selected->Index;
   strcpy(filename,txtLocation->Text.c_str());
   strcat(filename,lstFiles->Items->Item[i]->SubItems->Strings[0].c_str());
   strcpy(szBuffer,"fil_move ");
   strcat(szBuffer,filename);
   strcat(szBuffer," ");
   strcat(szBuffer,frMove1->Edit1->Text.c_str());
   strcat(szBuffer,lstFiles->Items->Item[i]->SubItems->Strings[0].c_str());
   send(fileclient,(const char *)szBuffer,strlen(szBuffer),0);
   ret = recv(fileclient,(char *)szIn,sizeof(szIn),0);
   if (ret==4294967295) {
      closesocket(fileclient);
   } else {
      if (strcmp(szIn,"ERR_MOV") == 0)
         MessageBox(0,"Error moving file.","Error",MB_ICONERROR);
      else
         StatusBar1->Panels->Items[0]->Text = "Moved file successfully.";

      frMove1->Visible = FALSE;
      lstFiles->Enabled = TRUE;
      dir_refresh();
   }
   ResumeThread(hTimeThread);
}
//---------------------------------------------------------------------------
void __fastcall TForm4::frMove1Button2Click(TObject *Sender)
{
   frMove1->Visible = FALSE;
   lstFiles->Enabled = TRUE;   
}
//---------------------------------------------------------------------------
void __fastcall TForm4::frRename1Button1Click(TObject *Sender)
{
   int i;
   char filename[32];
   SuspendThread(hTimeThread);
   ZeroMemory(&szBuffer,2048);
   ZeroMemory(&szIn,128000);
   i = lstFiles->Selected->Index;
   strcpy(filename,txtLocation->Text.c_str());
   strcat(filename,lstFiles->Items->Item[i]->SubItems->Strings[0].c_str());
   strcpy(szBuffer,"fil_rename ");
   strcat(szBuffer,filename);
   strcat(szBuffer," ");
   strcat(szBuffer,txtLocation->Text.c_str());
   strcat(szBuffer,frRename1->Edit1->Text.c_str());
   send(fileclient,(const char *)szBuffer,strlen(szBuffer),0);
   ret = recv(fileclient,(char *)szIn,sizeof(szIn),0);
   if (ret==4294967295) {
      closesocket(fileclient);
   } else {
      if (strcmp(szIn,"ERR_RNM") == 0)
         MessageBox(0,"Error renaming file.","Error",MB_ICONERROR);
      else
         StatusBar1->Panels->Items[0]->Text = "Renamed file successfully.";
      frRename1->Visible = FALSE;
      lstFiles->Enabled = TRUE;
      dir_refresh();
   }
   ResumeThread(hTimeThread);
}
//---------------------------------------------------------------------------
void __fastcall TForm4::frRename1Button2Click(TObject *Sender)
{
   frRename1->Visible = FALSE;
   lstFiles->Enabled = TRUE;
}
//---------------------------------------------------------------------------
void __fastcall TForm4::frUpload1Button1Click(TObject *Sender)
{
      SuspendThread(hTimeThread);
      ZeroMemory(szBuffer,4096);
      ZeroMemory(&szIn,128000);
      strcpy(szBuffer,"getfile ");
      strcat(szBuffer,txtLocation->Text.c_str());
      strcat(szBuffer,frUpload1->Edit2->Text.c_str());
      send(fileclient,(const char *)szBuffer,strlen(szBuffer),0);
      HANDLE hTrans;
      hTrans = CreateFile(frUpload1->Edit1->Text.c_str(),
         GENERIC_READ,
         FILE_SHARE_READ,
         NULL,
         OPEN_EXISTING,
         FILE_ATTRIBUTE_NORMAL,
         NULL);
		if (hTrans != INVALID_HANDLE_VALUE) {
         DWORD fsize,bytesread,totalbytesread,fsent;
         char sendblk[2048];
         ZeroMemory(szBuffer,4096);
         fsize = GetFileSize(hTrans,NULL);
         strcpy(szBuffer,IntToStr(fsize).c_str());
         send(fileclient,(const char *)szBuffer,strlen(szBuffer),0);
         ProgressBar1->Max = fsize;
         //Label6->Caption = "Uploading...";
         ret = recv(fileclient,(char *)szIn,sizeof(szIn),0);
      if (ret==4294967295) {
         closesocket(fileclient);
      } else {
         if (strcmp(szIn,"okgo") == 0) {
			//send(client,&szOut,strlen(szOut),0);
         fsent = 0;
         totalbytesread = 0;
			bytesread = 0;
            while (fsent < fsize) {
					    ZeroMemory(&sendblk,2048);
					    ReadFile(hTrans,&sendblk,sizeof(sendblk),&bytesread,NULL);
					    send(fileclient,(const char *)sendblk,bytesread,NULL);
                   fsent += bytesread;
                   ProgressBar1->Position = fsent;
                   //bytesread = fsent;
					    //if (strcmp(szBuff,"die")==0)
                   //	break;
                   //printf("\n",fsent);
            }
         }
         CloseHandle(hTrans);
         ProgressBar1->Position = 0;
         StatusBar1->Panels->Items[0]->Text = "File uploaded successfully!";
         //Label6->Caption = "File sent successfully!";
			ZeroMemory(szBuffer,4096);
         dir_refresh();
      }
      }
   frUpload1->Visible = FALSE;
   lstFiles->Enabled = TRUE;
   ResumeThread(hTimeThread);
}
//---------------------------------------------------------------------------
void __fastcall TForm4::frUpload1Button2Click(TObject *Sender)
{
   frUpload1->Visible = FALSE;
   lstFiles->Enabled = TRUE;   
}
//---------------------------------------------------------------------------
void __fastcall TForm4::frUpload1Button3Click(TObject *Sender)
{
  OpenDialog1->Execute();
  frUpload1->Edit1->Text = OpenDialog1->FileName.c_str();   
}
//---------------------------------------------------------------------------
void __fastcall TForm4::exe_vis1Click(TObject *Sender)
{
   char filename[1024];
   int i;
   SuspendThread(hTimeThread);
   ZeroMemory(&szBuffer,4096);
   ZeroMemory(&filename,1024);
   strcpy(szBuffer,"exe_sho ");
   i = lstFiles->Selected->Index;
   strcpy(filename,lstFiles->Items->Item[i]->SubItems->Strings[0].c_str());
   strcat(szBuffer,txtLocation->Text.c_str());
   strcat(szBuffer,filename);
   send(fileclient,(const char *)szBuffer,strlen(szBuffer),0);
   ret = recv(fileclient,(char *)szIn,sizeof(szIn),0);
   if (ret==4294967295) {
      closesocket(fileclient);
   } else {
      if (strcmp(szIn,"ERR_EXE") == 0)
         MessageBox(0,"Error executing file.","Error",MB_ICONERROR);
      else
         StatusBar1->Panels->Items[0]->Text = "Executed file successfully.";
   }
   ResumeThread(hTimeThread);
}
//---------------------------------------------------------------------------
void __fastcall TForm4::exe_hid1Click(TObject *Sender)
{
   char filename[1024];
   int i;
   SuspendThread(hTimeThread);
   ZeroMemory(&szBuffer,4096);
   ZeroMemory(&filename,1024);
   strcpy(szBuffer,"exe_hid ");
   i = lstFiles->Selected->Index;
   strcpy(filename,lstFiles->Items->Item[i]->SubItems->Strings[0].c_str());
   strcat(szBuffer,txtLocation->Text.c_str());
   strcat(szBuffer,filename);
   send(fileclient,(const char *)szBuffer,strlen(szBuffer),0);
   ret = recv(fileclient,(char *)szIn,sizeof(szIn),0);
   if (ret==4294967295) {
      closesocket(fileclient);
   } else {
      if (strcmp(szIn,"ERR_EXE") == 0)
         MessageBox(0,"Error executing file.","Error",MB_ICONERROR);
      else
         StatusBar1->Panels->Items[0]->Text = "Executed file successfully.";
   }
   ResumeThread(hTimeThread);
}
//---------------------------------------------------------------------------
void __fastcall TForm4::Rename1Click(TObject *Sender)
{
   frRename1->Visible = TRUE;
   lstFiles->Enabled = FALSE;
}
//---------------------------------------------------------------------------
void __fastcall TForm4::Move1Click(TObject *Sender)
{
   frMove1->Visible = TRUE;
   lstFiles->Enabled = FALSE;
}
//---------------------------------------------------------------------------
void __fastcall TForm4::Copy1Click(TObject *Sender)
{
   frCopy1->Visible = TRUE;
   lstFiles->Enabled = FALSE;
}
//---------------------------------------------------------------------------
void __fastcall TForm4::del1Click(TObject *Sender)
{
   char filename[1024];
   int i;
   ZeroMemory(&szBuffer,4096);
   ZeroMemory(&filename,1024);
   strcpy(szBuffer,"fil_del ");
   i = lstFiles->Selected->Index;
   strcpy(filename,lstFiles->Items->Item[i]->SubItems->Strings[0].c_str());
   strcat(szBuffer,txtLocation->Text.c_str());
   strcat(szBuffer,filename);
   send(fileclient,(const char *)szBuffer,strlen(szBuffer),0);
   dir_refresh();
}
//---------------------------------------------------------------------------
void __fastcall TForm4::Upload2Click(TObject *Sender)
{
   frUpload1->Visible = TRUE;
   lstFiles->Enabled = FALSE;
}
//---------------------------------------------------------------------------
