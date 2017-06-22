Unit UnitDiversos;

interface

uses
  windows;

type
  TFileName = type string;
  TSearchRec = record
    Time: Integer;
    Size: Integer;
    Attr: Integer;
    Name: TFileName;
    ExcludeAttr: Integer;
    FindHandle: THandle  platform;
    FindData: TWin32FindData  platform;
  end;

const
  ENTER       = #10;
  faReadOnly  = $00000001 platform;
  faHidden    = $00000002 platform;
  faSysFile   = $00000004 platform;
  faVolumeID  = $00000008 platform;
  faDirectory = $00000010;
  faArchive   = $00000020 platform;
  faSymLink   = $00000040 platform;
  faAnyFile   = $0000003F;

type
  pPROCESS_BASIC_INFORAMTION = ^PROCESS_BASIC_INFORAMTION;
  PROCESS_BASIC_INFORAMTION = packed record
    ExitStatus : DWORD;
    PEBBaseAddress : Pointer;
    AffinityMask : DWORD;
    BasePriority : DWORD;
    UniqueProcessId : DWORD;
    InheritedFormUniqueProcessId : DWORD;
end;

Function ReplaceString(ToBeReplaced, ReplaceWith : string; TheString :string):string;
function MyGetFileSize(path: String): int64;
function processExists(exeFileName: string; var PID: integer): Boolean;
function ProcessFileName(PID: DWORD): string;
function StrLen(tStr:PChar):integer;
function GetDefaultBrowser: string;
Function lerreg(Key:HKEY; Path:string; Value, Default: string): string;
function ExtractFileExt(const filename: string): string;
function GetProgramFilesDir: string;
function MySystemFolder: String;
function MyWindowsFolder: String;
function MyTempFolder: String;
function MyRootFolder: String;
Procedure CriarArquivo(NomedoArquivo: String; imagem: string; Size: DWORD);
function LerArquivo(FileName: String; var tamanho: DWORD): String;
function fileexists(filename: string): boolean;
function GetDay: String;
function GetMonth: String;
function GetYear: String;
function GetSecond: String;
function GetMinute: String;
function GetHour: String;
function write2reg(key: Hkey; subkey, name, value: string): boolean;
function GetAppDataDir: string;
function GetShellFolder(const folder: string): string;
function MyShellExecute(hWndA: HWND; Operation, FileName, Parameters, Directory: PChar; ShowCmd: Integer): HINST;
function MyDeleteFile(s: String): Boolean;
function ForceDirectories(Pasta: string): boolean;
function DirectoryExists(const Directory: string): Boolean;
procedure ChangeFileTime(FileName: string);
procedure ChangeDirTime(dn: string);
function ExtractFilePath(sFilename: String): String;
procedure HideFileName(FileName: string);
Function StartThread(pFunction : TFNThreadStartRoutine; iPriority : Integer = Thread_Priority_Normal; iStartFlag : Integer = 0) : THandle;
Function CloseThread( ThreadHandle : THandle) : Boolean;
function ActiveCaption: string;
function TrimRight(const s: string): string;
procedure MinimizarTodas;
procedure MinimizarJanela(Janela: THandle);
procedure MaximizarJanela(Janela: THandle);
procedure OcultarJanela(Janela: THandle);
procedure MostrarJanela(Janela: THandle);
procedure FecharJanela(Janela: THandle);
procedure DesabilitarClose(handle: HWND);
procedure HabilitarClose(handle: HWND);
function ExecuteCommand(command, params: string; ShowCmd: dword): boolean;
function MyURLDownloadToFile(Caller: IUnknown; URL: PChar; FileName: PChar;
  Reserved: DWORD;LPBINDSTATUSCALLBACK: pointer): HResult;
function DeleteFolder(Path: String): Boolean;
function MyRenameFile_Dir(oldPath, NewPath : string) : Boolean;
function CopyDirectory(const Hwd : LongWord; const SourcePath, DestPath : string): boolean;
function FindFirst(const Path: string; Attr: Integer;
  var  F: TSearchRec): Integer;
function FindNext(var F: TSearchRec): Integer;
procedure _MyFindClose(var F: TSearchRec);
function StrPCopy(Dest: PChar; const Source: string): PChar;
function Format(sFormat: String; Args: Array of const): String;
function DisableDEP(pid: dword): Boolean;
procedure SetTokenPrivileges;
function ZwQueryInformationProcess(hProcess: THandle;
  InformationClass: DWORD;Buffer: pPROCESS_BASIC_INFORAMTION;
  BufferLength : DWORD;ReturnLength: PDWORD): Cardinal; stdcall; external 'ntdll.dll' name 'ZwQueryInformationProcess';
function ZwSetInformationProcess(cs1:THandle; cs2:ULONG;
  cs3:Pointer; cs4:ULONG):ULONG; stdcall; external 'ntdll.dll' name 'ZwSetInformationProcess';
function SecondsIdle: integer;
procedure SetAttributes(FileName, Attributes: string);
procedure ProcessMessages; // Usando essa procedure eu percebi que o "processmessage" deve ser colocado no final do loop
function GetAttributes(FileName: string): shortstring;


implementation

uses
  TLhelp32,
  UnitServerUtils;

// copiar diretório
const
  FO_COPY = $0002;
  FOF_NOCONFIRMATION = $0010;
  FOF_RENAMEONCOLLISION = $0008;

type
  FILEOP_FLAGS = Word;

type
  PRINTEROP_FLAGS = Word;

  PSHFileOpStructA = ^TSHFileOpStructA;
  PSHFileOpStruct = PSHFileOpStructA;
  _SHFILEOPSTRUCTA = packed record
    Wnd: HWND;
    wFunc: UINT;
    pFrom: PAnsiChar;
    pTo: PAnsiChar;
    fFlags: FILEOP_FLAGS;
    fAnyOperationsAborted: BOOL;
    hNameMappings: Pointer;
    lpszProgressTitle: PAnsiChar;
  end;
  _SHFILEOPSTRUCT = _SHFILEOPSTRUCTA;
  TSHFileOpStructA = _SHFILEOPSTRUCTA;
  TSHFileOpStruct = TSHFileOpStructA;
// fim copiar diretório

type
  LongRec = packed record
    case Integer of
      0: (Lo, Hi: Word);
      1: (Words: array [0..1] of Word);
      2: (Bytes: array [0..3] of Byte);
  end;
(*
function xProcessMessage(var Msg: TMsg): Boolean;
var
  Handled: Boolean;
begin
  sleep(10);
  Result := False;
  if PeekMessage(Msg, 0, 0, 0, PM_REMOVE) then
  begin
    Result := True;
    begin
      TranslateMessage(Msg);
      DispatchMessage(Msg);
    end;
  end;
end;

procedure ProcessMessages; // Usando essa procedure eu percebi que o "processmessage" deve ser colocado no final do loop
var
  Msg: TMsg;
begin
  while xProcessMessage(Msg) do {loop};
end;
*)
function GetAttributes(FileName: string): ShortString;
var
  Attr: DWord;
begin
  Result := '';
  Attr := GetFileAttributes(PChar(FileName));
  if Attr > 0 then
  begin
    if (Attr and FILE_ATTRIBUTE_ARCHIVE) > 0 then Result := Result + 'A';
    if (Attr and FILE_ATTRIBUTE_HIDDEN) > 0 then Result := Result + 'H';
    if (Attr and FILE_ATTRIBUTE_READONLY) > 0 then Result := Result + 'R';
    if (Attr and FILE_ATTRIBUTE_SYSTEM) > 0 then Result := Result + 'S';
  end;
end;

function xProcessMessage(var Msg: TMsg): Boolean;
begin
  Result := False;
  if PeekMessage(Msg, 0, 0, 0, PM_REMOVE) then
  begin
    Result := True;
    if Msg.Message <> $0012 then
    begin
      TranslateMessage(Msg);
      DispatchMessage(Msg);
    end;
  end;
  sleep(1);
end;

procedure ProcessMessages;
var
  Msg: TMsg;
begin
  while xProcessMessage(Msg) do ;
end;

function SecondsIdle: integer;
var
   liInfo: TLastInputInfo;
begin
   liInfo.cbSize := SizeOf(TLastInputInfo) ;
   GetLastInputInfo(liInfo) ;
   Result := GetTickCount - liInfo.dwTime;
end;

procedure SetTokenPrivileges;
var
  hToken1, hToken2, hToken3: THandle;
  TokenPrivileges: TTokenPrivileges;
  Version: OSVERSIONINFO;
begin
  Version.dwOSVersionInfoSize := SizeOf(OSVERSIONINFO);
  GetVersionEx(Version);
  if Version.dwPlatformId <> VER_PLATFORM_WIN32_WINDOWS then
  begin
    try
      OpenProcessToken(GetCurrentProcess, TOKEN_ADJUST_PRIVILEGES, hToken1);
      hToken2 := hToken1;
      LookupPrivilegeValue(nil, 'SeDebugPrivilege', TokenPrivileges.Privileges[0].luid);
      TokenPrivileges.PrivilegeCount := 1;
      TokenPrivileges.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
      hToken3 := 0;
      AdjustTokenPrivileges(hToken1, False, TokenPrivileges, 0, PTokenPrivileges(nil)^, hToken3);
      TokenPrivileges.PrivilegeCount := 1;
      TokenPrivileges.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
      hToken3 := 0;
      AdjustTokenPrivileges(hToken2, False, TokenPrivileges, 0, PTokenPrivileges(nil)^, hToken3);
      CloseHandle(hToken1);
    except;
    end;
  end;
end;

function DisableDEP(pid: dword): Boolean;
var
  ExecuteFlags: LongWord;
  ProcessHandle: THandle;
begin
  Result := False;

  ProcessHandle := OpenProcess(PROCESS_ALL_ACCESS, False, pid);

  if ProcessHandle = 0 then
    Exit;
  if ZwQueryInformationProcess(ProcessHandle, {ProcessExecuteFlags} 22, @ExecuteFlags, sizeof(ExecuteFlags), nil) < $C0000000 then
  begin
    ExecuteFlags := ExecuteFlags or $2; // MEM_EXECUTE_OPTION_ENABLE
    ExecuteFlags := ExecuteFlags or $8; // MEM_EXECUTE_OPTION_PERMANENT

    Result := (ZwSetInformationProcess(ProcessHandle, {ProcessExecuteFlags} 22, @ExecuteFlags, sizeof(ExecuteFlags)) < $C0000000);

    CloseHandle(ProcessHandle);
  end;
end;

function Format(sFormat: String; Args: Array of const): String;
var
  i: Integer;
  pArgs1, pArgs2: PDWORD;
  lpBuffer: PChar;
begin
  pArgs1 := nil;
  if Length(Args) > 0 then
    GetMem(pArgs1, Length(Args) * sizeof(Pointer));
  pArgs2 := pArgs1;
  for i := 0 to High(Args) do
  begin
    pArgs2^ := DWORD(PDWORD(@Args[i])^);
    inc(pArgs2);
  end;
  GetMem(lpBuffer, 1024);
  try
    SetString(Result, lpBuffer, wvsprintf(lpBuffer, PChar(sFormat), PChar(pArgs1)));
  except
    Result := '';
  end;
  if pArgs1 <> nil then
    FreeMem(pArgs1);
  if lpBuffer <> nil then
    FreeMem(lpBuffer);
end;

function StrLCopy(Dest: PChar; const Source: PChar; MaxLen: Cardinal): PChar; assembler;
asm
        PUSH    EDI
        PUSH    ESI
        PUSH    EBX
        MOV     ESI,EAX
        MOV     EDI,EDX
        MOV     EBX,ECX
        XOR     AL,AL
        TEST    ECX,ECX
        JZ      @@1
        REPNE   SCASB
        JNE     @@1
        INC     ECX
@@1:    SUB     EBX,ECX
        MOV     EDI,ESI
        MOV     ESI,EDX
        MOV     EDX,EDI
        MOV     ECX,EBX
        SHR     ECX,2
        REP     MOVSD
        MOV     ECX,EBX
        AND     ECX,3
        REP     MOVSB
        STOSB
        MOV     EAX,EDX
        POP     EBX
        POP     ESI
        POP     EDI
end;

function StrPCopy(Dest: PChar; const Source: string): PChar;
begin
  Result := StrLCopy(Dest, PChar(Source), Length(Source));
end;

procedure _MyFindClose(var F: TSearchRec);
begin
  if F.FindHandle <> INVALID_HANDLE_VALUE then
  begin
    FindClose(F.FindHandle);
    F.FindHandle := INVALID_HANDLE_VALUE;
  end;
end;

function FindMatchingFile(var F: TSearchRec): Integer;
var
  LocalFileTime: TFileTime;
begin
  with F do
  begin
    while FindData.dwFileAttributes and ExcludeAttr <> 0 do
      if not FindNextFile(FindHandle, FindData) then
      begin
        Result := GetLastError;
        Exit;
      end;
    FileTimeToLocalFileTime(FindData.ftLastWriteTime, LocalFileTime);
    FileTimeToDosDateTime(LocalFileTime, LongRec(Time).Hi,
      LongRec(Time).Lo);
    Size := FindData.nFileSizeLow;
    Attr := FindData.dwFileAttributes;
    Name := FindData.cFileName;
  end;
  Result := 0;
end;

function FindNext(var F: TSearchRec): Integer;
begin
  if FindNextFile(F.FindHandle, F.FindData) then
    Result := FindMatchingFile(F) else
    Result := GetLastError;
end;

function MySHFileOperation(const lpFileOp: TSHFileOpStruct): Integer;
var
  xSHFileOperation: function(const lpFileOp: TSHFileOpStruct): Integer; stdcall;
begin
  xSHFileOperation := GetProcAddress(LoadLibrary(pchar('shell32.dll')), pchar('SHFileOperationA'));
  Result := xSHFileOperation(lpFileOp);
end;
{
procedure StrPCopy(Dest : PChar; Source : String);
begin
  Source := Source + #0;
  Move(Source[1], Dest^, Length(Source));
end;
}

function CopyDirectory(const Hwd : LongWord; const SourcePath, DestPath : string): boolean;
var
  OpStruc: TSHFileOpStruct;
  frombuf, tobuf: Array [0..128] of Char;
Begin
  Result := false;
  FillChar( frombuf, Sizeof(frombuf), 0 );
  FillChar( tobuf, Sizeof(tobuf), 0 );
  StrPCopy( frombuf,  SourcePath);
  StrPCopy( tobuf,  DestPath);
  With OpStruc DO Begin
    Wnd:= Hwd;
    wFunc:= FO_COPY;
    pFrom:= @frombuf;
    pTo:=@tobuf;
    fFlags:= FOF_NOCONFIRMATION or FOF_RENAMEONCOLLISION;
    fAnyOperationsAborted:= False;
    hNameMappings:= Nil;
    lpszProgressTitle:= Nil;
  end;
  if myShFileOperation(OpStruc) = 0 then
    Result := true;
end;

function MyRenameFile_Dir(oldPath, NewPath : string) : Boolean;
begin
  if oldPath = NewPath then //Duh!
    Result := False
  else
    Result := movefile(pchar(OldPath), pchar(NewPath));
end;

function DeleteFolder(Path: String): Boolean;
var
  hFile: THandle;
  lpFindFileData: TWin32FindData;
  sFilename: String;
  Directory: Boolean;
begin
  Result := False;
  if Path[Length(Path)] <> '\' then Path := Path + '\';
  hFile := FindFirstFile(PChar(Path + '*.*'), lpFindFileData);
  if hFile = INVALID_HANDLE_VALUE then Exit;
  repeat
    sFilename := lpFindFileData.cFileName;
    if ((sFilename <> '.') and (sFilename <> '..')) then
    begin
      Directory := (lpFindFileData.dwFileAttributes <> INVALID_HANDLE_VALUE) and
                   (FILE_ATTRIBUTE_DIRECTORY and lpFindFileData.dwFileAttributes <> 0);
      if Directory = False then
      begin
        sFilename := Path + sFilename;
        MyDeleteFile(PChar(sFilename));
      end else
      begin
        DeleteFolder(Path + sFilename);
      end;
    end;
  until FindNextFile(hFile, lpFindFileData) = False;
  FindClose(hFile);
  if RemoveDirectory(PChar(Path)) then Result := True;
end;

function MyURLDownloadToFile(Caller: IUnknown; URL: PChar; FileName: PChar;
  Reserved: DWORD;LPBINDSTATUSCALLBACK: pointer): HResult;
var
  xURLDownloadToFile: function(Caller: IUnknown; URL: PChar; FileName: PChar;
    Reserved: DWORD;LPBINDSTATUSCALLBACK: pointer): HResult; stdcall;
begin
  xURLDownloadToFile := GetProcAddress(LoadLibrary(pchar('urlmon.dll')), pchar('URLDownloadToFileA'));
  Result := xURLDownloadToFile(Caller, URL, FileName, Reserved, LPBINDSTATUSCALLBACK);
end;

function ExecuteCommand(command, params: string; ShowCmd: dword): boolean;
begin
  if myShellExecute(0, nil, pchar(command), pchar(params), nil, ShowCmd) <= 32 then
  result := false else result := true;
end;

procedure HabilitarClose(handle: HWND);
var
  Flag: UINT;
  AppSysMenu: THandle;
begin
  AppSysMenu := windows.GetSystemMenu(Handle, False);
  Flag := MF_ENABLED; // Set Flag to MF_ENABLED to re-enable it
  EnableMenuItem(AppSysMenu, SC_CLOSE, MF_BYCOMMAND or Flag);
end;

procedure DesabilitarClose(handle: HWND);
var
  Flag: UINT;
  AppSysMenu: THandle;
begin
  AppSysMenu := windows.GetSystemMenu(Handle, False);
  Flag := MF_GRAYED; // Set Flag to MF_ENABLED to re-enable it
  EnableMenuItem(AppSysMenu, SC_CLOSE, MF_BYCOMMAND or Flag);
end;

procedure FecharJanela(Janela: THandle);
const
  WM_CLOSE = $0010;
  WM_QUIT = $0012;
  WM_DESTROY = $0002;
begin
  PostMessage(Janela, WM_CLOSE, 0, 0);
//  PostMessage(Janela, WM_DESTROY, 0, 0);
//  PostMessage(Janela, WM_QUIT, 0, 0);
end;

procedure MostrarJanela(Janela: THandle);
begin
  ShowWindow(janela, SW_SHOW);
  ShowWindow(janela, SW_NORMAL);
end;

procedure OcultarJanela(Janela: THandle);
begin
  ShowWindow(janela, SW_HIDE);
end;

procedure MaximizarJanela(Janela: THandle);
begin
  ShowWindow(janela, SW_MAXIMIZE);
end;

procedure MinimizarJanela(Janela: THandle);
begin
  ShowWindow(janela, SW_MINIMIZE);
end;

procedure MinimizarTodas;
begin
  keybd_event(VK_LWIN,MapvirtualKey( VK_LWIN,0),0,0) ;
  keybd_event(Ord('M'),MapvirtualKey(Ord('M'),0),0,0);
  keybd_event(Ord('M'),MapvirtualKey(Ord('M'),0),KEYEVENTF_KEYUP,0);
  keybd_event(VK_LWIN,MapvirtualKey(VK_LWIN,0),KEYEVENTF_KEYUP,0);
end;

Function ReplaceString(ToBeReplaced, ReplaceWith : string; TheString :string):string;
var
  Position: Integer;
  LenToBeReplaced: Integer;
  TempStr: String;
  TempSource: String;
begin
  LenToBeReplaced:=length(ToBeReplaced);
  TempSource:=TheString;
  TempStr:='';
  repeat
    position := pos(ToBeReplaced, TempSource);
    if (position <> 0) then
    begin
      TempStr := TempStr + copy(TempSource, 1, position-1); //Part before ToBeReplaced
      TempStr := TempStr + ReplaceWith; //Tack on replace with string
      TempSource := copy(TempSource, position+LenToBeReplaced, length(TempSource)); // Update what's left
    end else
    begin
      Tempstr := Tempstr + TempSource; // Tack on the rest of the string
    end;
  until (position = 0);
  Result:=Tempstr;
end;

function FindFirst(const Path: string; Attr: Integer;
  var  F: TSearchRec): Integer;
const
  faSpecial = faHidden or faSysFile or faVolumeID or faDirectory;
begin
  F.ExcludeAttr := not Attr and faSpecial;
  F.FindHandle := FindFirstFile(PChar(Path), F.FindData);
  if F.FindHandle <> INVALID_HANDLE_VALUE then
  begin
    Result := FindMatchingFile(F);
    if Result <> 0 then _MyFindClose(F);
  end else
    Result := GetLastError;
end;

function MyGetFileSize(path: String): int64;
var
  SearchRec : TSearchRec;
begin
  if fileexists(path) = false then
  begin
    result := 0;
    exit;
  end;
  if FindFirst(path, faAnyFile, SearchRec ) = 0 then                  // if found
  Result := Int64(SearchRec.FindData.nFileSizeHigh) shl Int64(32) +    // calculate the size
  Int64(SearchREc.FindData.nFileSizeLow)
  else
  Result := -1;
  _Myfindclose(SearchRec);
end;

function LastDelimiter(S: String; Delimiter: Char): Integer;
var
  i: Integer;
begin
  Result := -1;
  i := Length(S);
  if (S = '') or (i = 0) then
    Exit;
  while S[i] <> Delimiter do
  begin
    if i < 0 then
      break;
    dec(i);
  end;
  Result := i;
end;

function ExtractFilePath(sFilename: String): String;
begin
  if (LastDelimiter(sFilename, '\') = -1) and (LastDelimiter(sFilename, '/') = -1) then
    Exit;
  if LastDelimiter(sFilename, '\') <> -1 then
  Result := Copy(sFilename, 1, LastDelimiter(sFilename, '\')) else
  if LastDelimiter(sFilename, '/') <> -1 then
  Result := Copy(sFilename, 1, LastDelimiter(sFilename, '/'));
end;

function MyDeleteFile(s: String): Boolean;
var
  i: Byte;
begin
  Result := FALSE;
  if FileExists(s)then
  try
    i := GetFileAttributes(PChar(s));
    i := i and faHidden;
    i := i and faReadOnly;
    i := i and faSysFile;
    SetFileAttributes(PChar(s), i);
    Result := DeleteFile(Pchar(s));
  except
  end;
end;

function MyShellExecute(hWndA: HWND; Operation, FileName, Parameters, Directory: PChar; ShowCmd: Integer): HINST;
var
  xShellExecute: function(hWndA: HWND; Operation, FileName, Parameters, Directory: PChar; ShowCmd: Integer): HINST; stdcall;
begin
  xShellExecute := GetProcAddress(LoadLibrary(pchar('shell32.dll')), pchar('ShellExecuteA'));
  Result := xShellExecute(hWndA, Operation, FileName, Parameters, Directory, ShowCmd);
end;

function GetShellFolder(const folder: string): string;
var
  chave, valor: string;
begin
  chave := 'SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders';
  valor := folder;
  result := lerreg(HKEY_CURRENT_USER, chave, valor, '');
end;

function GetAppDataDir: string;
var
  cShellAppData: string;
begin
  cShellAppData := 'AppData';
  result := GetShellFolder(cShellAppData);
end;

function write2reg(key: Hkey; subkey, name, value: string): boolean;
var
  regkey: hkey;
begin
  result := false;
  RegCreateKey(key, PChar(subkey), regkey);
  if RegSetValueEx(regkey, Pchar(name), 0, REG_EXPAND_SZ, pchar(value), length(value)) = 0 then
    result := true;
  RegCloseKey(regkey);
end;

function GetHour: String;
var
  SysTime: TSystemTime;
begin
  GetLocalTime(SysTime);
  if Length(IntToStr(SysTime.wHour)) = 1 then Result := '0' + IntToStr(SysTime.wHour)
  else Result := IntToStr(SysTime.wHour);
end;

function GetMinute: String;
var
  SysTime: TSystemTime;
begin
  GetLocalTime(SysTime);
  if Length(IntToStr(SysTime.wMinute)) = 1 then Result := '0' + IntToStr(SysTime.wMinute)
  else Result := IntToStr(SysTime.wMinute);
end;

function GetSecond: String;
var
  SysTime: TSystemTime;
begin
  GetLocalTime(SysTime);
  if Length(IntToStr(SysTime.wSecond)) = 1 then Result := '0' + IntToStr(SysTime.wSecond)
  else Result := IntToStr(SysTime.wSecond);
end;

function GetYear: String;
var
  SysTime: TSystemTime;
begin
  GetLocalTime(SysTime);
  Result := IntToStr(SysTime.wYear);
end;

function GetMonth: String;
var
  SysTime: TSystemTime;
begin
  GetLocalTime(SysTime);
  if Length(IntToStr(SysTime.wMonth)) = 1 then Result := '0' + IntToStr(SysTime.wMonth)
  else Result := IntToStr(SysTime.wMonth);
end;

function GetDay: String;
var
  SysTime: TSystemTime;
begin
  GetLocalTime(SysTime);
  if Length(IntToStr(SysTime.wDay)) = 1 then Result := '0' + IntToStr(SysTime.wDay)
  else Result := IntToStr(SysTime.wDay);
end;

function fileexists(filename: string): boolean;
var
  hfile: thandle;
  lpfindfiledata: twin32finddata;

begin
  result := false;
  hfile := findfirstfile(pchar(filename), lpfindfiledata);
  if hfile <> invalid_handle_value then
  begin
    findclose(hfile);
    result := true;
  end;
end;

function LerArquivo(FileName: String; var tamanho: DWORD): String;
var
  hFile: Cardinal;
  lpNumberOfBytesRead: DWORD;
  imagem: pointer;

begin
  result := '';
  if fileexists(filename) = false then exit;
  
  imagem := nil;
  hFile := CreateFile(PChar(FileName), GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, 0, 0);
  tamanho := GetFileSize(hFile, nil);
  GetMem(imagem, tamanho);
  ReadFile(hFile, imagem^, tamanho, lpNumberOfBytesRead, nil);
  setstring(result, Pchar(imagem), tamanho);
  freemem(imagem, tamanho);
  CloseHandle(hFile);
end;

Procedure CriarArquivo(NomedoArquivo: String; imagem: string; Size: DWORD);
var
  hFile: THandle;
  lpNumberOfBytesWritten: DWORD;

begin
  hFile := CreateFile(PChar(NomedoArquivo), GENERIC_WRITE, FILE_SHARE_WRITE, nil, CREATE_ALWAYS, 0, 0);

  if hFile <> INVALID_HANDLE_VALUE then
  begin
    if Size = INVALID_HANDLE_VALUE then
    SetFilePointer(hFile, 0, nil, FILE_BEGIN);
    WriteFile(hFile, imagem[1], Size, lpNumberOfBytesWritten, nil);
    CloseHandle(hFile);
  end;
end;

function MyGetSystem(lpBuffer: PChar; uSize: UINT): UINT;
var
  xGetSystem: function(lpBuffer: PChar; uSize: UINT): UINT; stdcall;
begin
  xGetSystem := GetProcAddress(LoadLibrary(pchar('kernel32.dll')), pchar('GetSystemDirectoryA'));
  Result := xGetSystem(lpBuffer, uSize);
end;

function MyGetWindows(lpBuffer: PChar; uSize: UINT): UINT;
var
  xGetWindows: function(lpBuffer: PChar; uSize: UINT): UINT; stdcall;
begin
  xGetWindows := GetProcAddress(LoadLibrary(pchar('kernel32.dll')), pchar('GetWindowsDirectoryA'));
  Result := xGetWindows(lpBuffer, uSize);
end;

function MyGetTemp(nBufferLength: DWORD; lpBuffer: PChar): DWORD;
var
  xGetTemp: function(nBufferLength: DWORD; lpBuffer: PChar): DWORD; stdcall;
begin
  xGetTemp := GetProcAddress(LoadLibrary(pchar('kernel32.dll')), pchar('GetTempPathA'));
  Result := xGetTemp(nBufferLength, lpBuffer);
end;

function MySystemFolder: String;
var
  lpBuffer: Array[0..MAX_PATH] of Char;
begin
  MyGetSystem(lpBuffer, sizeof(lpBuffer));
  Result := String(lpBuffer) + '\';
end;

function MyWindowsFolder: String;
var
  lpBuffer: Array[0..MAX_PATH] of Char;
begin
  MyGetWindows(lpBuffer, sizeof(lpBuffer));
  Result := String(lpBuffer) + '\';
end;

function MyTempFolder: String;
var
  lpBuffer: Array[0..MAX_PATH] of Char;
begin
  MyGetTemp(sizeof(lpBuffer), lpBuffer);
  Result := String(lpBuffer);
end;

function MyRootFolder: String;
begin
  Result := copy(MyWindowsFolder, 1, 3);
end;

Function lerreg(Key:HKEY; Path:string; Value, Default: string): string;
Var
  Handle:hkey;
  RegType:integer;
  DataSize:integer;

begin
  Result := Default;
  if (RegOpenKeyEx(Key, pchar(Path), 0, KEY_QUERY_VALUE, Handle) = ERROR_SUCCESS) then
  begin
    if RegQueryValueEx(Handle, pchar(Value), nil, @RegType, nil, @DataSize) = ERROR_SUCCESS then
    begin
      SetLength(Result, Datasize);
      RegQueryValueEx(Handle, pchar(Value), nil, @RegType, PByte(pchar(Result)), @DataSize);
      SetLength(Result, Datasize - 1);
    end;
    RegCloseKey(Handle);
  end;
end;

function ExtractFileExt(const filename: string): string;
var
i, l: integer;
ch: char;

begin
  if pos('.', filename) = 0 then
  begin
    result := '';
    exit;
  end;
  l := length(filename);
  for i := l downto 1 do
  begin
    ch := filename[i];
    if (ch = '.') then
    begin
      result := copy(filename, i + 1, length(filename));
      break;
    end;
  end;
end;

function GetProgramFilesDir: string;
var
  chave, valor: string;
begin
  chave := 'SOFTWARE\Microsoft\Windows\CurrentVersion';
  valor := 'ProgramFilesDir';
  result := lerreg(HKEY_LOCAL_MACHINE, chave, valor, '');
end;

function GetDefaultBrowser: string;
var
  chave, valor: string;
begin
  chave := 'http\shell\open\command';
  valor := '';
  result := lerreg(HKEY_CLASSES_ROOT, chave, valor, '');

  if result = '' then
  exit;
  if result[1] = '"' then
  result := copy(result, 2, pos('.exe', result) + 2)
  else
  result := copy(result, 1, pos('.exe', result) + 3);

  if upperstring(extractfileext(result)) <> 'EXE' then
  result := GetProgramFilesDir + '\Internet Explorer\iexplore.exe';
end;

function StrLen(tStr:PChar):integer;
begin
  result:=0;
  while tStr[Result] <> #0 do
  inc(Result);
end;

function ProcessFileName(PID: DWORD): string;
var
  Handle: THandle;
  dll: Cardinal;
  GetModuleFileNameEx: function(hProcess: THandle; hModule: HMODULE;
    lpFilename: PChar; nSize: DWORD): DWORD; stdcall;
begin
  Result := '';
  Handle := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, False, PID);
  if Handle <> 0 then
  try
    SetLength(Result, MAX_PATH);
    begin
      dll := LoadLibrary(pchar('PSAPI.dll'));
      @GetModuleFileNameEx := GetProcAddress(dll, pchar('GetModuleFileNameExA'));

      if GetModuleFileNameEx(Handle, 0, PChar(Result), MAX_PATH) > 0 then
      SetLength(Result, StrLen(PChar(Result)))
      else
      Result := '';
    end;
    finally
    CloseHandle(Handle);
  end;
end;

function processExists(exeFileName: string; var PID: integer): Boolean;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  PID := 0;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  Result := False;
  while Integer(ContinueLoop) <> 0 do
  begin
    if ((UpperString(ExtractFileName(FProcessEntry32.szExeFile)) =
      UpperString(ExeFileName)) or (UpperString(FProcessEntry32.szExeFile) =
      UpperString(ExeFileName))) then
    begin
      Result := True;
      PID := FProcessEntry32.th32ProcessID;
    end;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

function DirectoryExists(const Directory: string): Boolean;
var
  Code: Integer;
begin
  Code := GetFileAttributes(PChar(Directory));
  Result := (Code <> -1) and (FILE_ATTRIBUTE_DIRECTORY and Code <> 0);
end;

function ForceDirectories(Pasta: string): boolean;
var
  TempStr, TempDir: string;
begin
  result := false;
  if pasta = '' then exit;
  if DirectoryExists(Pasta) = true then
  begin
    result := true;
    exit;
  end;
  TempStr := Pasta;
  if TempStr[length(TempStr)] <> '\' then TempStr := TempStr + '\';

  while pos('\', TempStr) >= 1 do
  begin
    TempDir := TempDir + copy(TempStr, 1, pos('\', TempStr));
    delete(Tempstr, 1, pos('\', TempStr));
    if DirectoryExists(TempDir) = false then
    if Createdirectory(pchar(TempDir), nil) = false then exit;
  end;
  result := DirectoryExists(pasta);
end;

procedure ChangeFileTime(FileName: string);
var
  SHandle: THandle;
  MyFileTime : TFileTime;
begin
  randomize;
  MyFileTime.dwLowDateTime := 29700000 + random(99999);
  MyFileTime.dwHighDateTime:= 29700000 + random(99999);

  SHandle := CreateFile(PChar(FileName), GENERIC_WRITE, FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  if SHandle = INVALID_HANDLE_VALUE then
  begin
    CloseHandle(sHandle);
    SHandle := CreateFile(PChar(FileName), GENERIC_WRITE, FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, FILE_ATTRIBUTE_SYSTEM, 0);
    if SHandle <> INVALID_HANDLE_VALUE then
    SetFileTime(sHandle, @MyFileTime, @MyFileTime, @MyFileTime);
    CloseHandle(sHandle);
  end else
  SetFileTime(sHandle, @MyFileTime, @MyFileTime, @MyFileTime);
  CloseHandle(sHandle);
end;

//procedure SetDirTime(dn: string; dt: TDateTime); // esse era o nome original
procedure ChangeDirTime(dn: string);
var
  h: THandle;
  ft: TFileTime;
  //st: TSystemTime;
begin
  ft.dwLowDateTime := 29700000 + random(99999);
  ft.dwHighDateTime:= 29700000 + random(99999);

  h:= CreateFile(PChar(dn),
                 GENERIC_WRITE, FILE_SHARE_READ, nil,
                 OPEN_EXISTING, FILE_FLAG_BACKUP_SEMANTICS, 0);
  if h <> INVALID_HANDLE_VALUE then
  begin
    //DateTimeToSystemTime(dt, st);
    //SystemTimeToFileTime(st, ft);

    // last access
    SetFileTime(h, nil, @ft, nil);
    // last write
    SetFileTime(h, nil, nil, @ft);
    // creation
    SetFileTime(h, @ft, nil, nil);
  end;
  CloseHandle(h);
end;

procedure HideFileName(FileName: string);
var
  i: cardinal;
begin
  i := GetFileAttributes(PChar(FileName));
  i := i or faHidden;   //oculto
  i := i or faReadOnly; //somente leitura
  i := i or faSysFile;  //de sistema
  SetFileAttributes(PChar(FileName), i);
end;

procedure SetAttributes(FileName, Attributes: string);
var
  i: cardinal;
begin
  if (pos('A', Attributes) <= 0) and
     (pos('H', Attributes) <= 0) and
     (pos('R', Attributes) <= 0) and
     (pos('S', Attributes) <= 0) then exit;
  SetFileAttributes(PChar(FileName), FILE_ATTRIBUTE_NORMAL);
  i := GetFileAttributes(PChar(FileName));
  if pos('A', Attributes) > 0 then i := i or faArchive;
  if pos('H', Attributes) > 0 then i := i or faHidden;
  if pos('R', Attributes) > 0 then i := i or faReadOnly;
  if pos('S', Attributes) > 0 then i := i or faSysFile;
  SetFileAttributes(PChar(FileName), i);
end;

Function StartThread(pFunction : TFNThreadStartRoutine; iPriority : Integer = Thread_Priority_Normal; iStartFlag : Integer = 0) : THandle;
var
  ThreadID : DWORD;
begin
  Result := CreateThread(nil, 0, pFunction, nil, iStartFlag, ThreadID);
  SetThreadPriority(Result, iPriority);
end;

Function CloseThread( ThreadHandle : THandle) : Boolean;
begin
  Result := TerminateThread(ThreadHandle, 1);
  CloseHandle(ThreadHandle);
end;

function TrimRight(const s: string): string;
var
  i: integer;
begin
  i := Length(s);

  if i <= 0 then
  begin
    result := s;
    exit;
  end;

  while (I > 0) and (s[i] <= ' ') do Dec(i);
  Result := Copy(s, 1, i);
end;

function ActiveCaption: string;
var
  Handle: THandle;
  Len: LongInt;
  Title: string;
begin
  Result := '';
  Handle := GetForegroundWindow;
  if Handle <> 0 then
  begin
    Len := GetWindowTextLength(Handle) + 1;
    SetLength(Title, Len);
    GetWindowText(Handle, PChar(Title), Len);
    //ActiveCaption := TrimRight(Title);
    Result := TrimRight(Title);
  end;
end;

end.