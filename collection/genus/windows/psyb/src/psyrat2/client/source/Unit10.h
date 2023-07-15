//---------------------------------------------------------------------------

#ifndef Unit10H
#define Unit10H
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <ComCtrls.hpp>
//---------------------------------------------------------------------------
class TForm10 : public TForm
{
__published:	// IDE-managed Components
   TListView *lstProcs;
        TButton *Button1;
        TButton *Button2;
   TStatusBar *StatusBar1;
        void __fastcall Button1Click(TObject *Sender);
   void __fastcall Button2Click(TObject *Sender);
private:	// User declarations
public:		// User declarations
        char prc_boxname[128];
        SOCKET prcclient;
        __fastcall TForm10(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TForm10 *Form10;
//---------------------------------------------------------------------------
#endif
