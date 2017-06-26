//---------------------------------------------------------------------------

#ifndef Unit9H
#define Unit9H
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <ComCtrls.hpp>
#include <ExtCtrls.hpp>
//---------------------------------------------------------------------------
class TForm9 : public TForm
{
__published:	// IDE-managed Components
   TButton *Button1;
   TProgressBar *ProgressBar1;
   TStatusBar *StatusBar1;
   TImage *Image1;
   void __fastcall Button1Click(TObject *Sender);
   void __fastcall FormResize(TObject *Sender);
private:	// User declarations
public:		// User declarations
   char scr_boxname[128];
   SOCKET scrclient;
   __fastcall TForm9(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TForm9 *Form9;
//---------------------------------------------------------------------------
#endif
 