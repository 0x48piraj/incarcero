Unit UnitServerUtils;

interface

uses
  windows;

function IntToStr(i: Int64): String;
function StrToInt(S: String): Int64;
function UpperString(S: String): String;
function LowerString(S: String): String;
function ExtractFilename(const path: string): string;

implementation

function ExtractFilename(const path: string): string;
var
i, l: integer;
ch: char;

begin
  l := length(path);
  for i := l downto 1 do
  begin
    ch := path[i];
    if (ch = '\') or (ch = '/') then
    begin
      result := copy(path, i + 1, l - i);
      break;
    end;
  end;
end;

function IntToStr(i: Int64): String;
begin
  Str(i, Result);
end;

function StrToInt(S: String): Int64;
var
  E: integer;
begin
  Val(S, Result, E);
end;

function UpperString(S: String): String;
var
  i: Integer;
begin
  for i := 1 to Length(S) do
    S[i] := char(CharUpper(PChar(S[i])));
  Result := S;
end;

function LowerString(S: String): String;
var
  i: Integer;
begin
  for i := 1 to Length(S) do
    S[i] := char(CharLower(PChar(S[i])));
  Result := S;
end;

end.