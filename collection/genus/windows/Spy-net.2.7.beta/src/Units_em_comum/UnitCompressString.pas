unit UnitCompressString;

interface

uses
  windows;

function CompressString(str: string): string;
function DeCompressString(str: string): string;

implementation

uses
  StreamUnit,
  ZLibEx,
  UnitDiversos;

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

procedure StrToStream(S: TStream; const SS: string);
var
  SizeStr: integer;
begin
  S.Position := 0;
  SizeStr := Length(SS);
  S.Write(SS[1], SizeStr);
end;

function StreamToStr(S: TStream): string;
var
  SizeStr: integer;
begin
  SizeStr := S.Size;
  S.Position := 0;
  SetLength(Result, SizeStr);
  S.Read(Result[1], SizeStr);
end;

const
  Validador = '@@XXXXXXXXXX@@'; // usado somente para o spynet...

function CompressString(str: string): string;
var
  oCompress               : TZCompressionStream;
  inpStream, outStream    : TMemoryStream;
begin
  inpStream := TMemoryStream.Create;
  outStream := TMemoryStream.Create;

  StrToStream(inpStream, str);
  inpStream.Position := 0;
                                                     //zcNone, zcFastest, zcDefault, zcMax
  oCompress := TZCompressionStream.Create(outStream, zcFastest);
  oCompress.CopyFrom(inpStream, inpStream.Size);
  oCompress.Free;

  result := Validador + StreamToStr(outStream);

  inpStream.Free;
  outStream.Free;
end;


function DeCompressString(str: string): string;
const
  BufferSize = 4096;
var
 oDecompress             : TZDecompressionStream;
 inpStream               : TMemoryStream;
 outStream               : TMemoryStream;
 Buffer                  : array[0..BufferSize-1] of Byte;
 Count                   : integer;
begin
  result := '';
  if pos(Validador, str) <= 0 then exit;
  str := replacestring(Validador, '', str);

  inpStream := TMemoryStream.Create;
  outStream := TMemoryStream.Create;

  StrToStream(inpStream, str);
  inpStream.Position := 0;

  oDecompress := TZDecompressionStream.Create(inpStream);

  while True do
  begin
    processmessages;
    Count := oDecompress.Read(Buffer, BufferSize);
    if Count <> 0 then outStream.WriteBuffer(Buffer, Count) else Break;
  end;
  oDecompress.Free;

  result := StreamToStr(outStream);

  inpStream.Free;
  outStream.Free;
end;

end.
