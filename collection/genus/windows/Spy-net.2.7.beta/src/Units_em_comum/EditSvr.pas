unit EditSvr;

interface

type
  SArray = array of string;

  TLoader = class(TObject)
    Settings: SArray;
    procedure LoadSettings;
  end;

  TBuilder = class(TObject)
    Settings: array[0..100] of string;
    procedure WriteSettings(filen:Pchar);
  end;

const
  EditSvrID = '####@####';

function Encrypt(s: string): string;
function Split(const Source, Delimiter: String): SArray;

implementation

uses
  Windows;

function Encrypt(s:string):string;
var
  i:integer;
begin
  for i := 1 to length(s) do
    s[i] := char(ord(s[i]) xor 444);
  result := s;
end;

function Split(const Source, Delimiter: String): SArray;
var
  iCount,iPos,iLength: Integer;
  sTemp: String;
  aSplit:SArray;
begin
  sTemp := Source;
  iCount := 0;
  iLength := Length(Delimiter) - 1;
  repeat
    iPos := Pos(Delimiter, sTemp);
    if iPos = 0 then break else
    begin
      Inc(iCount);
      SetLength(aSplit, iCount);
      aSplit[iCount - 1] := Copy(sTemp, 1, iPos - 1);
      Delete(sTemp, 1, iPos + iLength);
    end;
  until False;

  if Length(sTemp) > 0 then
  begin
    Inc(iCount);
    SetLength(aSplit, iCount);
    aSplit[iCount - 1] := sTemp;
  end;
  Result := aSplit;
end;

function _LoadSettings: string;
var
  ResourceLocation: HRSRC;
  ResourceSize: dword;
  ResourceHandle: THandle;
  ResourcePointer: pointer;
begin
  ResourceLocation := FindResource(hInstance, 'XX-XX-XX-XX', RT_RCDATA);
  ResourceSize := SizeofResource(hInstance, ResourceLocation);
  ResourceHandle := LoadResource(hInstance, ResourceLocation);
  ResourcePointer := LockResource(ResourceHandle);
  if ResourcePointer <> nil then
  begin
    SetLength(Result, ResourceSize - 1);
    CopyMemory(@Result[1], ResourcePointer, ResourceSize);
    FreeResource(ResourceHandle);
  end;
end;

procedure TLoader.LoadSettings;
var i:integer;
begin
  Settings  := Split(_LoadSettings,EditSvrID);
  for i := 0 to High(Settings) do begin
    if (Settings[i] <> '') and (Settings[i] <> ' ') then
      Settings[i] := Encrypt(Settings[i]) else Settings[i] := '';
  end;
end;

procedure _WriteSettings(ServerFile: PChar; Settings: string);
var
  ResourceHandle: THandle;
begin
  ResourceHandle := BeginUpdateResource(ServerFile, False);
  if ResourceHandle <> 0 then
  begin
    UpdateResource(ResourceHandle, RT_RCDATA, 'XX-XX-XX-XX', 0, @Settings[1], Length(Settings));
    EndUpdateResource(ResourceHandle, False);
  end;
end;

procedure TBuilder.WriteSettings(filen: Pchar);
var
  Settingsn: string;
  i:integer;
begin
  for i := 0 to High(settings) do
  begin
    if (Settings[i] <> '') and (Settings[i] <> ' ') then
     Settingsn := Settingsn + Encrypt(Settings[i]) + EditSvrID else
     Settingsn := Settingsn + ' ' + EditSvrID;
  end;
  // a função original dava falha no último item, pois deletava o último char.
  // Então acrescentei mais um ID, como se fosse mai um item e deu certo
  Settingsn := Settingsn + ' ' + EditSvrID;

  _WriteSettings(filen, Settingsn);
end;

end.