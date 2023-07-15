//---------------------------------------------------------------------------

#ifndef Unit4H
#define Unit4H
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <ComCtrls.hpp>
#include <ImgList.hpp>
#include "Unit8.h"
#include "Unit6.h"
#include "Unit7.h"
#include "Unit5.h"
#include <Dialogs.hpp>
#include <Menus.hpp>
//---------------------------------------------------------------------------
class TForm4 : public TForm
{
__published:	// IDE-managed Components
   TListView *lstFiles;
   TEdit *txtLocation;
   TButton *Button9;
   TComboBox *txtDrives;
   TProgressBar *ProgressBar1;
   TStatusBar *StatusBar1;
   TImageList *ImageList1;
   TfrCopy *frCopy1;
   TfrMove *frMove1;
   TfrRename *frRename1;
   TfrUpload *frUpload1;
   TOpenDialog *OpenDialog1;
   TPopupMenu *PopupMenu1;
   TMenuItem *exe_vis1;
   TMenuItem *exe_hid1;
   TMenuItem *Rename1;
   TMenuItem *Move1;
   TMenuItem *Copy1;
   TMenuItem *del1;
   TMenuItem *N2;
   TMenuItem *Upload2;
   void __fastcall Button9Click(TObject *Sender);
   void __fastcall txtDrivesChange(TObject *Sender);
   void __fastcall lstFilesDblClick(TObject *Sender);
   void __fastcall FormCreate(TObject *Sender);
   void __fastcall dir_refresh();
   void __fastcall frCopy1Button1Click(TObject *Sender);
   void __fastcall frCopy1Button2Click(TObject *Sender);
   void __fastcall frMove1Button1Click(TObject *Sender);
   void __fastcall frMove1Button2Click(TObject *Sender);
   void __fastcall frRename1Button1Click(TObject *Sender);
   void __fastcall frRename1Button2Click(TObject *Sender);
   void __fastcall frUpload1Button1Click(TObject *Sender);
   void __fastcall frUpload1Button2Click(TObject *Sender);
   void __fastcall frUpload1Button3Click(TObject *Sender);
   void __fastcall exe_vis1Click(TObject *Sender);
   void __fastcall exe_hid1Click(TObject *Sender);
   void __fastcall Rename1Click(TObject *Sender);
   void __fastcall Move1Click(TObject *Sender);
   void __fastcall Copy1Click(TObject *Sender);
   void __fastcall del1Click(TObject *Sender);
   void __fastcall Upload2Click(TObject *Sender);
private:	// User declarations
public:		// User declarations
   SOCKET fileclient;
   char fil_boxname[128];
   __fastcall TForm4(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TForm4 *Form4;
//---------------------------------------------------------------------------
#endif
