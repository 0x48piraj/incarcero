//---------------------------------------------------------------------------


#ifndef Unit8H
#define Unit8H
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
//---------------------------------------------------------------------------
class TfrCopy : public TFrame
{
__published:	// IDE-managed Components
   TLabel *Label1;
   TEdit *Edit1;
   TButton *Button1;
   TButton *Button2;
private:	// User declarations
public:		// User declarations
   __fastcall TfrCopy(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TfrCopy *frCopy;
//---------------------------------------------------------------------------
#endif
