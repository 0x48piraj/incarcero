//---------------------------------------------------------------------------

#ifndef Unit3H
#define Unit3H
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <ComCtrls.hpp>
//---------------------------------------------------------------------------
class TForm3 : public TForm
{
__published:	// IDE-managed Components
   TMemo *txtCpuInfo;
   TButton *btnUninstall;
   TButton *Button1;
   TButton *Button3;
   TButton *btnRestart;
   TStatusBar *StatusBar1;
   void __fastcall Button1Click(TObject *Sender);
   void __fastcall btnUninstallClick(TObject *Sender);
   void __fastcall btnRestartClick(TObject *Sender);
   void __fastcall Button3Click(TObject *Sender);
private:	// User declarations
public:		// User declarations
   SOCKET infoclient;
   char inf_boxname[128];
   __fastcall TForm3(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TForm3 *Form3;
//---------------------------------------------------------------------------
#endif
