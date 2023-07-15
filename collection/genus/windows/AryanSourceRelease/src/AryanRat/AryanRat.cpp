#include <windows.h>
#include <commctrl.h>
#include <stdio.h>
#include "resource.h"

HWND hDlg;

LRESULT CALLBACK MainWndProc(HWND hwnd,UINT Mes,UINT wPar,LONG lPar)
{
ShowWindow(hwnd,SW_SHOW);
return 0;
}

int WINAPI WinMain(HINSTANCE hInst, HINSTANCE hPrev,
				   LPSTR lpszParam, int nCmdShow)
{
	
	hDlg=CreateDialog(hInst,(LPCTSTR)IDD_DIALOG1,NULL,(DLGPROC)MainWndProc);
	ShowWindow(hDlg,SW_SHOW);
	InitCommonControls();
	MSG msg;
	while(GetMessage(&msg,hDlg,0,0)==TRUE)
	{
		TranslateMessage(&msg);
		DispatchMessage(&msg);
	}
	return 0;
}