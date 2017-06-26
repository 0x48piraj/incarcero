//---------------------------------------------------------------------------


#ifndef Unit5H
#define Unit5H
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
//---------------------------------------------------------------------------
class TfrUpload : public TFrame
{
__published:	// IDE-managed Components
   TLabel *Label1;
   TLabel *Label2;
   TEdit *Edit2;
   TEdit *Edit1;
   TButton *Button3;
   TButton *Button1;
   TButton *Button2;
private:	// User declarations
public:		// User declarations
   __fastcall TfrUpload(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TfrUpload *frUpload;
//---------------------------------------------------------------------------
#endif
