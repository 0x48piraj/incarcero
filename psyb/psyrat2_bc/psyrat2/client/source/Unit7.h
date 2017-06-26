//---------------------------------------------------------------------------


#ifndef Unit7H
#define Unit7H
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
//---------------------------------------------------------------------------
class TfrMove : public TFrame
{
__published:	// IDE-managed Components
   TLabel *Label1;
   TEdit *Edit1;
   TButton *Button1;
   TButton *Button2;
private:	// User declarations
public:		// User declarations
   __fastcall TfrMove(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TfrMove *frMove;
//---------------------------------------------------------------------------
#endif
