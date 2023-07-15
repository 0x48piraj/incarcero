//----------------------------------------------------------------------------
#ifndef Unit2H
#define Unit2H
//----------------------------------------------------------------------------
#include <SysUtils.hpp>
#include <Windows.hpp>
#include <Messages.hpp>
#include <Classes.hpp>
#include <Graphics.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <ExtCtrls.hpp>
#include <Forms.hpp>
//----------------------------------------------------------------------------
class TForm2 : public TForm
{
__published:
	TButton *Button1;
   TEdit *txtPort;
   TLabel *Label1;
   TLabel *Label2;
   TEdit *txtPassword;
   void __fastcall Button1Click(TObject *Sender);
private:
public:
	virtual __fastcall TForm2(TComponent *Owner);
};
//----------------------------------------------------------------------------
extern TForm2 *Form2;
//----------------------------------------------------------------------------
#endif
