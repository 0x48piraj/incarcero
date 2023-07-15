//---------------------------------------------------------------------------

#ifndef Unit1H
#define Unit1H
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <ComCtrls.hpp>
#include <ImgList.hpp>
#include <Menus.hpp>
#include <winsock.h>
//---------------------------------------------------------------------------
BOOLEAN timecheck,listening;
HANDLE hTimeThread,hThread;

class TForm1 : public TForm
{
__published:	// IDE-managed Components
   TListView *lstConns;
   TImageList *ImageList1;
   TMainMenu *MainMenu1;
   TMenuItem *File1;
   TMenuItem *Listen1;
   TMenuItem *Stop1;
   TStatusBar *status;
   TMenuItem *Settings1;
   TPopupMenu *PopupMenu1;
   TMenuItem *Info1;
   TMenuItem *Files1;
   TMenuItem *Batch1;
   TMenuItem *Uninstall1;
   TMenuItem *Restart1;
   TMenuItem *Screenshot1;
        TMenuItem *Processes1;
   void __fastcall Settings1Click(TObject *Sender);
   void __fastcall Listen1Click(TObject *Sender);
   void __fastcall Stop1Click(TObject *Sender);
   void __fastcall Info1Click(TObject *Sender);
   void __fastcall Files1Click(TObject *Sender);
   void __fastcall Uninstall1Click(TObject *Sender);
   void __fastcall Restart1Click(TObject *Sender);
   void __fastcall Screenshot1Click(TObject *Sender);
        void __fastcall Processes1Click(TObject *Sender);
private:	// User declarations
public:		// User declarations
   __fastcall TForm1(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TForm1 *Form1;
//---------------------------------------------------------------------------
#endif

/*void stopcheck() {
   TerminateThread(hTimeThread,0);
   CloseHandle(hTimeThread);
}

void startcheck() {
   DWORD dwThreadId;
   hTimeThread = CreateThread(NULL, 0, TimeoutWatchThread,
      0, 0, &dwThreadId);
}                */
