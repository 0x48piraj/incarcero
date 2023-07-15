unit UnitCryptString;

interface

Uses
  windows,
  UnitServerUtils;

function EnDecrypt01(const InStr, KeyStr : string) : string;
function EnDecrypt02(const S, Key : string) : string;
function EnDecrypt03(const str: string): string;
function EnDecrypt04(const strText: string; intKey: integer): string;
function EnDecrypt05(Value: string): string;

function encrypt01(s1: string):string;
function decrypt01(s1: string): string;

function EnDecryptStr(Str, key: String): String;
Function EnDecryptStrRC4A(Expression, RC4Akey:String) : string;
function EnDecryptStrRC4B(strText, RC4Bkey: string): string;
function EnDecryptRC401(S: string; const Password: string): AnsiString;
function ReverseString(const s: string): string;
function Encode64(S: string): string;
function Decode64(S: string): string;
Function ScrambleStr(szText: String; intBits: Integer): String;
Function deScrambleStr(szText: String): String;

function EncryptStrA(const S: String; Key: Int64; key01, key02: DWORD): String;
function DecryptStrA(const S: String; Key: Int64; key01, key02: DWORD): String;
function EncryptStrB(Texto: string; key01, key02, key03: DWORD):string;
function DecryptStrB(Texto: string; key01, key02, key03: DWORD):string;
function EncryptStrC(const S: AnsiString; Key, key01, key02: Word): AnsiString;
function DecryptStrC(const S: AnsiString; Key, key01, key02: Word): AnsiString;
function encryptstrD(crypttext, key:string):string;
function decryptstrD(crypttext, key:string):string;
function encryptstrE(crypttext, key:string):string;
function DecryptstrE(crypttext, key:string):string;

Procedure PxORFast(szInput, szPass: String; intMin, intMax: Int64; Var szOutput: String);
Function EnDecryptStrPoke(var Text: pchar; LengthFile: DWORD; KeyMaior, KeyMenor: DWORD; PassWord: string): String;

implementation

Const
  MAX_KEY = 100;
  MIN_KEY = 1;

type
  PByteArray = ^TByteArray;
  TByteArray = Array [0..32767] Of Byte;

Type
  TPxOR = Record
    szPassword :Int64;
    szMinKey :Int64;
    szMaxKey :Int64;
  end;

var
  D : array[Byte] of Byte;
  I,J : Byte;
  Px: TPxOR;

function EnDecrypt01(const InStr, KeyStr : string) : string;
var
  C1, C2 : integer;
  OutStr : string;
  Ch1, Ch2 : byte;
begin
  C1 := 0;
  C2 := 0;
  OutStr := '';
  while (C1 < Length(InStr)) do
  begin
    inc(C1);
    inc(C2);
    if (C2 > Length(KeyStr)) then
    C2 := 1;
    Ch1 := Ord(InStr[C1]);
    Ch2 := Ord(KeyStr[C2]) + 128;
    OutStr := OutStr + Chr(Ch1 xor Ch2);
  end;
  Result := OutStr;
end;

function EnDecrypt02(const S, Key : string) : string;
var
  I, Z : integer;
  C : char;
  Code : byte;
begin
  Result:= '';
  Z:= length(Key);
  if (Z > 0) and (length(S) > 0) then 
  for I:= 1 to length(S) do
  begin
    Code:= ord(Key[(I - 1) mod Z + 1]);
    if S[I] >= #128 then C:= Chr(ord(S[I]) xor (Code and $7F)) else
    if S[I] >= #64 then C:= Chr(ord(S[I]) xor (Code and $3F)) else
    if S[I] >= #32 then C:= Chr(ord(S[I]) xor (Code and $1F)) else
    C:= S[I];
    Result:= Result + C;
  end;
end; 

function EnDecrypt03(const str: string): string;
var
 i: integer;
begin
 result := str;
 for i := 1 to length(result) do
   result[i] := char(ord(result[i]) xor $13);
end;

function EnDecrypt04(const strText: string; intKey: integer): string;
var
  i: integer; 
  strResult: string; 
begin 
  strResult := strText;
  RandSeed := intKey;
  for i := 1 to Length(strText) do
    strResult[i] := Chr(Ord(strResult[i]) xor Random(255)); 
  EnDecrypt04 := strResult;
end;

function EnDecrypt05(Value: string): string;
var
  tmpStr: String;
  len, strPos: Integer;
begin
  tmpStr := '';
  len := Length(Value);
  for strPos := 1 to len do
    tmpStr := tmpStr + chr(ord('Z') xor ord(Value[strPos]));
  Result := tmpStr;
end;

function encrypt01(s1: string):string;
var
  s2: string;
  l: integer;
  w, w1, w2, w5: integer;
  c: integer;
begin
  s2 := s1;
  l := length(s1);
  c := 1;
  w := ord(s1[c]);
  w := $0018;
  repeat
    w1 := 0;
    w1 := ord(s1[c]);
    w5 := word(w);
    w2 := w1 xor (w5 shr 8 );
    s2[c] := chr(w2);
    w := w + ord(s2[c]);
    c := c + 1;
    l := l - 1;
  until l = 0;
  result := s2;
end;

function decrypt01(s1: string): string;
var
  s2: string;
  l: integer;
  w, w1, w2, w5: integer;
  c: integer;
begin
  s2 := s1;
  l := length(s1);
  c := 1;
  w := ord(s1[c]);
  w := $0018;
  repeat
    w1 := 0;
    w1 := ord(s1[c]);
    w5 := word(w);
    w2 := w1 xor (w5 shr 8 );
    s2[c] := chr(w2);
    w := w + ord(s1[c]);
    c := c + 1;
    l := l  -1;
  until l = 0;
  result := s2;
end;

function EnDecryptStr(Str, key: String): String;
var
  Y, Z : Integer;
  B : Byte;
begin
  Z := 1;
  for Y := 1 to Length(Str) do
  begin
    B := (ord(Str[Y]) and $0f) xor (ord(Key[Z]) and $0f);
     B := b xor 10 ;
    Str[Y] := char((ord(Str[Y]) and $f0) + B);
    Inc(Z);
    If Z > length(Key) then Z := 1;
  end;
  Result := Str;
end;

Function EnDecryptStrRC4A(Expression, RC4Akey:String) : string;
var
  RB: array [0..255] of byte;
  X,Y,Z: Longint;
  key: string;
  bytearray: array [0..255] of byte;
  temp: byte;
  l,lp: integer;
begin  
  l := Length(Expression);
  lp := Length(RC4Akey);
  If (lp = 0) or (l = 0) then  Exit;  
  If lp > 256 Then  Key := copy(RC4Akey, 0, 256) Else Key := RC4Akey;
  For X := 0 To 255 do RB[X] := X;
  X :=0; Y:=0; Z:=0;
  For X := 0 To 255 do
  begin
    Y := (Y + RB[X] + byte(Key[X Mod lp])) Mod 256;  
    Temp := RB[X];  
    RB[X] := RB[Y];  
    RB[Y] := Temp;  
    if x < l then byteArray[x] := byte(expression[x+1]);  
  end;  
  X:=0; Y:=0; Z:=0;
  For X := 0 To l do
  begin
    Y := (Y + 1) Mod 256;  
    Z := (Z + RB[Y]) Mod 256;  
    Temp := RB[Y];  
    RB[Y] := RB[Z];  
    RB[Z] := Temp;  
    ByteArray[X] := byte(ByteArray[X]) Xor (RB[(RB[Y] + RB[Z]) Mod 256]);  
  end;  
  result := ''; 
  for x := 0 to l - 1  do result := result + chr(ByteArray[x]);  
end;


function EnDecryptStrRC4B(strText, RC4Bkey: string): string;
var
  g_arSBox: array[0..255] of char;

  procedure InitRC4(strKey: string);
  var
    i,j: integer;
    tmp: char;
    arKey: array[0..255] of char;
  begin
    j := 0;
    for i:=0 to 255 do g_arSBox[i] := char(i);
    for i:=0 to 255 do arKey[i] := strKey[(i mod length(strKey))+1];
    for i:=0 to 255 do
    begin
      j := (j + ord(g_arSBox[i]) + ord(arKey[i])) mod 256;
      tmp := g_arSBox[i];g_arSBox[i] := g_arSBox[j];
      g_arSBox[j] := tmp;
    end;
  end;

  function BeginEnDecryptStrRC4B(strText: string): string;
  var
    i,j,k: integer;
    tmp, keybyte: char;
    strCrypted: string;
  begin
    j := 0;
    k := 0;
    for i:=1 to length(strText) do
    begin
      j := (j + 1) mod 256;
      k := (k + ord(g_arSBox[j])) mod 256;
      tmp := g_arSBox[j];
      g_arSBox[j] := g_arSBox[k];
      g_arSBox[k] := tmp;
      keybyte := g_arSBox[ (ord(g_arSBox[j])+ ord(g_arSBox[k])) mod 256 ];
      strCrypted := strCrypted + char( ord(strText[i])xor ord(keybyte) );
    end;
    BeginEnDecryptStrRC4B := strCrypted;
  end;

begin
  InitRC4(RC4Bkey);
  Result := BeginEnDecryptStrRC4B(strText);
end;


function EnDecryptRC401(S: string; const Password: string): AnsiString;
  procedure Code(Source, Dest: pChar; Count: Integer);
  var
    S : Integer;
    T : Byte;
  begin
    for S := 0 to (Count - 1) do
    begin
      Inc(I);
      T := D[I];
      Inc(J, T);
      D[I] := D[J];
      D[J] := T;
      Inc(T, D[I]);
      Byte(Dest[S]) := Byte(Source[S]) xor D[T];
    end;
  end;

  procedure Init(const Key: string);
  var
    R, S, T, K : Byte;
    U,L : Integer;
    DummyArray : array [0..1599] of Char;
  begin
    {$R-}
    {$Q-}
    L := Length(Key);
    I := 0;
    J := 0;
    R := 0;
    U := 0;
    for S := 0 to 255 do D[S] := S;
    for S := 0 to 255 do
    begin
      if (U < L) then
      K := PByteArray(Key)[U] else K := 0;
      Inc(U);
      if (U >= L) then U := 0;
      Inc(R, D[S] + K);
      T := D[S];
      D[S] := D[R];
      D[R] := T;
    end;
    Code(@DummyArray, @DummyArray, 1600);
  end;

  procedure Done;
  begin
    FillChar(D, sizeOf(D), 0);
    FillChar(I, sizeOf(I), 0);
    FillChar(J, sizeOf(J), 0);
  end;

begin
  SetLength(Result, Length(S));
  Init(Password);
  Code(pChar(S), pChar(Result), Length(S));
  Done;
end;

function ReverseString(const s: string): string;
var
  i, len: Integer; 
begin 
  len := Length(s); 
  SetLength(Result, len); 
  for i := len downto 1 do 
  begin 
    Result[len - i + 1] := s[i]; 
  end; 
end;

const
  Codes64 = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz+/';

function Encode64(S: string): string;
var
  i: Integer;
  a: Integer;
  x: Integer;
  b: Integer;
begin
  Result := '';
  a := 0;
  b := 0;
  for i := 1 to Length(s) do
  begin
    x := Ord(s[i]);
    b := b * 256 + x;
    a := a + 8;
    while a >= 6 do
    begin
      a := a - 6;
      x := b div (1 shl a);
      b := b mod (1 shl a);
      Result := Result + Codes64[x + 1];
    end;
  end;
  if a > 0 then
  begin
    x := b shl (6 - a);
    Result := Result + Codes64[x + 1];
  end;
end;

function Decode64(S: string): string;
var
  i: Integer;
  a: Integer;
  x: Integer;
  b: Integer;
begin
  Result := '';
  a := 0;
  b := 0;
  for i := 1 to Length(s) do
  begin
    x := Pos(s[i], codes64) - 1;
    if x >= 0 then
    begin
      b := b * 64 + x;
      a := a + 6;
      if a >= 8 then
      begin
        a := a - 8;
        x := b shr a;
        b := b mod (1 shl a);
        x := x mod 256;
        Result := Result + chr(x);
      end;
    end
    else
      Exit;
  end;
end;

Function ScrambleStr(szText: String; intBits: Integer): String;
Var
  wArray :Array Of String;
  wBit, iRnd, wCount, wbCount:Integer;
  sbData, sSettings:String;
Begin
  wCount := 0;
  sbData := szText;
  ZeroMemory(@wArray, SizeOf(wArray));
  If Length(szText) < intBits Then intBits := Length(szText);
  wBit := (Length(szText) DIV intBits) + 1;
  SetLength(wArray, 1);
  While szText <> '' Do
  Begin
    wArray[wCount] := Copy(szText, 1, wBit);
    Delete(szText, 1, wBit);
    If wArray[wCount] <> '' Then
    Begin
      Inc(wCount);
      SetLength(wArray, wCount+1);
    End;
  End;
  wbCount := wCount;
  Result := '';
  sSettings := '';
  Randomize;
  Repeat
    iRnd := Random(wbCount);
    If wArray[iRnd] <> '' Then
    Begin
      Result := Result + wArray[iRnd];
      sSettings := sSettings + IntToStr(iRnd) + ':' + IntToStr(Length(wArray[iRnd])) + ';';
      wArray[iRnd] := '';
      Dec(wCount);
    End;
  Until wCount = 0;
  Result := Result + #1 + sSettings;
End;

Function deScrambleStr(szText: String): String;
Var
  wArray :Array Of String;
  wCount, iRnd, iLoop, iLen:Integer;
  Settings :String;
Begin
  Settings := szText;
  Repeat
    Delete(Settings, 1, Pos(#1, Settings));
  Until Pos(#1, Settings) <= 0;
  wCount := 0;
  ZeroMemory(@wArray, SizeOf(wArray));
  SetLength(wArray, 1);
  While Pos(';', Settings) > 0 Do
  Begin
    iRnd := StrToInt(Copy(Settings, 1, Pos(':', Settings)-1));
    Delete(Settings, 1, Pos(':', Settings));
    iLen := StrToInt(Copy(Settings, 1, Pos(';', Settings)-1));
    Delete(Settings, 1, Pos(';', Settings));
    If iRnd >= wCount Then
    Begin
      wCount := iRnd + 1;
      SetLength(wArray, wCount);
    End;
    wArray[iRnd] := Copy(szText, 1, iLen);
    Delete(szText, 1, iLen);
  End;
  Result := '';
  For iLoop := 0 To wCount-1 Do Result := Result + wArray[iLoop];
End;

function EncryptStrA(const S: String; Key: Int64; key01, key02: DWORD): String;
var
  I: Integer;
begin
  {$IFDEF Win32}
  SetLength(Result,Length(S));
  {$ELSE}
  Result[0]:=Chr(Length(S));
  {$ENDIF}
  for I := 1 to Length(S) do
  begin
    Result[I] := Char(Ord(S[I]) xor (Key shr 8));
    Key := (Ord(Result[I]) + Key) * key01 + key02;
  end;
end;

function DecryptStrA(const S: String; Key: Int64; key01, key02: DWORD): String;
var
  I: Integer;
begin
  {$IFDEF Win32}
  SetLength(Result,Length(S));
  {$ELSE}
  Result[0]:=Chr(Length(S));
  {$ENDIF}
  for I := 1 to Length(S) do
  begin
    Result[I] := char(Ord(S[I]) xor (Key shr 8));
    Key := (Ord(S[I]) + Key) * key01 + key02;
  end;
end;

function EncryptStrB(Texto: string; key01, key02, key03: DWORD):string;
var
  r : string;
  i : integer;
begin
  Texto:=EncryptStrA(Texto, key01, key02, key03);
  For i := 1 to Length(texto) do r := r + chr(Ord(Texto[i]) + i);
  result:= r;
end;

function DecryptStrB(Texto: string; key01, key02, key03: DWORD):string;
var
  r : string;
  i : integer;
begin
  For i := 1 to Length(texto) do r := r + chr(Ord(Texto[i]) - i);
  result:= DecryptStrA(r, key01, key02, key03);
end;

function EncryptStrC(const S: AnsiString; Key, key01, key02: Word): AnsiString;
  function Encode(const S: AnsiString): AnsiString;
  const
    Map: array[0..63] of Char = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' +
                                'abcdefghijklmnopqrstuvwxyz0123456789+/';
  var
    I: LongInt;
  begin
    I := 0;
    Move(S[1], I, Length(S));
    case Length(S) of
      1:
      Result := Map[I mod 64] + Map[(I shr 6) mod 64];
      2:
      Result := Map[I mod 64] + Map[(I shr 6) mod 64] + Map[(I shr 12) mod 64];
      3:
      Result := Map[I mod 64] + Map[(I shr 6) mod 64] + Map[(I shr 12) mod 64] + Map[(I shr 18) mod 64]
    end
  end;

  function PostProcess(const S: AnsiString): AnsiString;
  var
    SS: AnsiString;
  begin
    SS := S;
    Result := '';
    while SS <> '' do
    begin
      Result := Result + Encode(Copy(SS, 1, 3));
      Delete(SS, 1, 3)
    end
  end;

  function InternalEncryptStrC(const S: AnsiString; Key, key01, key02: Word): AnsiString;
  var
    I: Word;
    Seed: Word;
  begin
    Result := S;
    Seed := Key;
    for I := 1 to Length(Result) do
    begin
      Result[I] := Char(Byte(Result[I]) xor (Seed shr 8));
      Seed := (Byte(Result[I]) + Seed) * Word(key01) + Word(key02)
    end
  end;

begin
  Result := PostProcess(InternalEncryptStrC(S, Key, key01, key02))
end;

function DecryptStrC(const S: AnsiString; Key, key01, key02: Word): AnsiString;
  function Decode(const S: AnsiString): AnsiString;
  const
    Map: array[Char] of Byte = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 62, 0, 0, 0, 63, 52, 53,
    54, 55, 56, 57, 58, 59, 60, 61, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2,
    3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19,
    20, 21, 22, 23, 24, 25, 0, 0, 0, 0, 0, 0, 26, 27, 28, 29, 30,
    31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45,
    46, 47, 48, 49, 50, 51, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0);
  var
    I: LongInt;
  begin
    case Length(S) of
      2:
      begin
        I := Map[S[1]] + (Map[S[2]] shl 6);
        SetLength(Result, 1);
        Move(I, Result[1], Length(Result))
      end;
      3:
      begin
        I := Map[S[1]] + (Map[S[2]] shl 6) + (Map[S[3]] shl 12);
        SetLength(Result, 2);
        Move(I, Result[1], Length(Result))
      end;
      4:
      begin
        I := Map[S[1]] + (Map[S[2]] shl 6) + (Map[S[3]] shl 12) + (Map[S[4]] shl 18);
        SetLength(Result, 3);
        Move(I, Result[1], Length(Result))
      end
    end
  end;

  function PreProcess(const S: AnsiString): AnsiString;
  var
    SS: AnsiString;
  begin
    SS := S;
    Result := '';
    while SS <> '' do
    begin
      Result := Result + Decode(Copy(SS, 1, 4));
      Delete(SS, 1, 4)
    end
  end;

  function InternalDecryptStrC(const S: AnsiString; Key, key01, key02: Word): AnsiString;
  var
    I: Word;
    Seed: Word;
  begin
    Result := S;
    Seed := Key;
    for I := 1 to Length(Result) do
    begin
      Result[I] := Char(Byte(Result[I]) xor (Seed shr 8));
      Seed := (Byte(S[I]) + Seed) * Word(key01) + Word(key02)
    end
  end;

begin
  Result := InternalDecryptStrC(PreProcess(S), Key, key01, key02)
end;

function encryptstrD(crypttext, key:string):string;
var
  x, y, lg, n: integer;
begin
  result := '';
  lg := length(key);
  y := 1;
  randomize;
  for x := 1 to length(crypttext) do
  begin
    n := (byte(crypttext[x]) xor byte(key[y])) or
    (((random(32) shl 8) and 15872) or 16384);
    if lo(n) < 32 then n := n or 384;
    if y = lg then y:=1 else inc(y);
    result := result + chr(lo(n)) + chr(hi(n));
  end;
end;

function decryptstrD(crypttext, key:string):string;
var
  x, y, lg, n: integer;
begin
  if not odd(length(crypttext)) then
  begin
    result := '';
    lg := length(key);
    y := 1;
    x := 1;
    while x < length(crypttext) do
    begin
      n := (byte(crypttext[x]) or (byte(crypttext[x + 1]) shl 8));
      if n and 256 > 0 then n := n and 127 else n := n and 255;
      result := result+chr(n xor byte(key[y]));
      if y = lg then y := 1
      else inc(y);
      inc(x, 2);
    end;
  end else result := crypttext;
end;

function encryptstrE(crypttext, key:string):string;
var
  x, p, n: Integer;
  key1: string;
begin
  result := '';
  p := 0;
  key1 := Key;
  for x := 1 to length(crypttext) do
  begin
    inc(p);
    if p > length(key1) then p := 1;
    if TRUE then
    begin
      n := ord(crypttext[x]) + ord(key1[p]);
      if n > 255 then n := n - $E0;
    end else
    begin
      n := ord(crypttext[x]) - ord(key1[p]);
      if n < 32 then n := n + $E0;
    end;
    result := result + chr(n);
  end;
end;

function DecryptstrE(crypttext, key:string):string;
var
  x, p, n: Integer;
  key1: string;
begin
  result := '';
  p := 0;
  key1 := Key;
  for x := 1 to length(crypttext) do
  begin
    inc(p);
    if p > length(key1) then p := 1;
    if FALSE then
    begin
      n := ord(crypttext[x]) + ord(key1[p]);
      if n > 255 then n := n - $E0;
    end else
    begin
      n := ord(crypttext[x]) - ord(key1[p]);
      if n < 32 then n := n + $E0;
    end;
    result := result + chr(n);
  end;
end;

Procedure PxORFast(szInput, szPass: String; intMin, intMax: Int64; Var szOutput: String);
  Function PxORPassword(szPassword: String): Int64;
  Var
    I :Integer;
  Begin
    Result := 0;
    For I := 1 To Length(szPassword) Do Inc(Result, Ord(szPassword[I]));
    While Result > 255 Do Result := (Result DIV 2);
  End;

  Procedure PxORInit(Var Px: TPxOR; szPass: String; intMin, intMax: Int64);
  Begin
    Px.szPassword := 0;
    Px.szMinKey := 0;
    Px.szMaxKey := 0;

    If intMin < MIN_KEY Then intMin := MIN_KEY;
    If intMin > MAX_KEY Then intMin := MAX_KEY-1;
    If intMax < MIN_KEY Then intMax := MIN_KEY+1;
    If intMax > MAX_KEY Then intMax := MAX_KEY;

    Px.szPassword := PxORPassword(szPass);
    Px.szMinKey := intMin;
    Px.szMaxKey := intMax;
  End;

  Procedure PxORCode(Px: TPxOR; szInput: String; Var szOutput: String);
  Var
    I :Integer;
    Count :Integer;
  Begin
    SetLength(szOutput, Length(szInput));
    Count := Px.szMinKey;
    For I := 1 To Length(szInput) Do
    Begin
      If (Count > Px.szMaxKey) Then
      Count := Px.szMinKey;
      szOutput[I] := Chr(Ord(szInput[I]) Xor (Px.szPassword + Count));
      Inc(Count);
    End;
  End;

Begin
  SetLength(szOutput, Length(szInput));
  PxORInit(Px, szPass, intMin, intMax);
  PxORCode(Px, szInput, szOutput);
End;

Function EnDecryptStrPoke(var Text: pchar; LengthFile: DWORD; KeyMaior, KeyMenor: DWORD; PassWord: string): String;
Var
  iLoop         :Integer;
  MagicCount    :Integer;
Begin
  MagicCount    := KeyMenor;
  For iLoop := 0 To LengthFile -1 Do
  Begin
    If (MagicCount = KeyMaior) Then MagicCount := KeyMenor;
    Text[iLoop] := Chr(Ord(Text[iLoop]) XOR MagicCount);
    Inc(MagicCount);
  End;
  Result := EnDecryptStrRc4B(Text, PassWord);
End;

end.
