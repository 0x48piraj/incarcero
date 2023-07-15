//---------------------------------------------------------------------------


#ifndef Unit6H
#define Unit6H
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
//---------------------------------------------------------------------------
class TfrRename : public TFrame
{
__published:	// IDE-managed Components
   TLabel *Label1;
   TEdit *Edit1;
   TButton *Button1;
   TButton *Button2;
private:	// User declarations
public:		// User declarations
   __fastcall TfrRename(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TfrRename *frRename;
//---------------------------------------------------------------------------
#endif
