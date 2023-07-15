unit UnitRegistro;

interface

uses
  Windows,
  UnitComandos,
  StreamUnit;

type
  TSysLocale = packed record
    DefaultLCID: Integer;
    PriLangID: Integer;
    SubLangID: Integer;
    FarEast: Boolean;
    MiddleEast: Boolean;
  end;
  TMbcsByteType = (mbSingleByte, mbLeadByte, mbTrailByte);

function ListarClaves(Clave: String): String;
function ListarValores(Clave: String): String;
function BorraClave(Clave: String):boolean;
function AniadirClave(Clave, Val, Tipo: String):boolean;
function RenombrarClave(Ruta, ViejaClave, NuevaClave: PChar):boolean;
function ToKey(Clave: String):hKey;
function IntToHex(Value: Integer; Digits: Integer): string; overload;
function IntToHex(Value: Int64; Digits: Integer): string; overload;
function RenameRegistryItem(Old, New: String): boolean;

implementation

var
  SysLocale: TSysLocale;
  LeadBytes: set of Char = [];

Type
  KeysRecord = record
    Name: shortString;
  end;

type
  ValoresRecord = record
    Name: shortstring;
    Tipo: shortString;
    Dados: shortstring;
  end;

function ListarClaves(Clave: String): String;
var
  phkResult: hkey;
  lpName: PChar;
  lpcbName, dwIndex: Cardinal;
  lpftLastWriteTime: FileTime;
  ResultStream: TMemoryStream;
  KR: KeysRecord;
begin
  result := '';
  if clave = '' then exit;

  RegOpenKeyEx(ToKey(Copy(Clave, 1, Pos('\', Clave) - 1)),
                PChar(Copy(Clave, Pos('\', Clave) + 1, Length(Clave))),
                0,
                KEY_ENUMERATE_SUB_KEYS,
                phkResult);

  lpcbName := 255;
  GetMem(lpName, lpcbName);
  dwIndex := 0;
  ResultStream := TMemoryStream.Create;

  while RegEnumKeyEx(phkResult, dwIndex, @lpName[0] , lpcbName, nil, nil, nil, @lpftLastWriteTime) = ERROR_SUCCESS do
  begin
    Inc(dwIndex);
    lpcbName := 255;
    KR.Name := lpName;
    ResultStream.WriteBuffer(KR, sizeof(KeysRecord));
  end;
  RegCloseKey(phkResult);
  result := StreamToStr(ResultStream);
  ResultStream.Free;
end;

procedure CvtInt;
{ IN:
    EAX:  The integer value to be converted to text
    ESI:  Ptr to the right-hand side of the output buffer:  LEA ESI, StrBuf[16]
    ECX:  Base for conversion: 0 for signed decimal, 10 or 16 for unsigned
    EDX:  Precision: zero padded minimum field width
  OUT:
    ESI:  Ptr to start of converted text (not start of buffer)
    ECX:  Length of converted text
}
asm
        OR      CL,CL
        JNZ     @CvtLoop
@C1:    OR      EAX,EAX
        JNS     @C2
        NEG     EAX
        CALL    @C2
        MOV     AL,'-'
        INC     ECX
        DEC     ESI
        MOV     [ESI],AL
        RET
@C2:    MOV     ECX,10

@CvtLoop:
        PUSH    EDX
        PUSH    ESI
@D1:    XOR     EDX,EDX
        DIV     ECX
        DEC     ESI
        ADD     DL,'0'
        CMP     DL,'0'+10
        JB      @D2
        ADD     DL,('A'-'0')-10
@D2:    MOV     [ESI],DL
        OR      EAX,EAX
        JNE     @D1
        POP     ECX
        POP     EDX
        SUB     ECX,ESI
        SUB     EDX,ECX
        JBE     @D5
        ADD     ECX,EDX
        MOV     AL,'0'
        SUB     ESI,EDX
        JMP     @z
@zloop: MOV     [ESI+EDX],AL
@z:     DEC     EDX
        JNZ     @zloop
        MOV     [ESI],AL
@D5:
end;

function IntToHex(Value: Integer; Digits: Integer): string;
//  FmtStr(Result, '%.*x', [Digits, Value]);
asm
        CMP     EDX, 32        // Digits < buffer length?
        JBE     @A1
        XOR     EDX, EDX
@A1:    PUSH    ESI
        MOV     ESI, ESP
        SUB     ESP, 32
        PUSH    ECX            // result ptr
        MOV     ECX, 16        // base 16     EDX = Digits = field width
        CALL    CvtInt
        MOV     EDX, ESI
        POP     EAX            // result ptr
        CALL    System.@LStrFromPCharLen
        ADD     ESP, 32
        POP     ESI
end;

procedure CvtInt64;
{ IN:
    EAX:  Address of the int64 value to be converted to text
    ESI:  Ptr to the right-hand side of the output buffer:  LEA ESI, StrBuf[32]
    ECX:  Base for conversion: 0 for signed decimal, or 10 or 16 for unsigned
    EDX:  Precision: zero padded minimum field width
  OUT:
    ESI:  Ptr to start of converted text (not start of buffer)
    ECX:  Byte length of converted text
}
asm
        OR      CL, CL
        JNZ     @start             // CL = 0  => signed integer conversion
        MOV     ECX, 10
        TEST    [EAX + 4], $80000000
        JZ      @start
        PUSH    [EAX + 4]
        PUSH    [EAX]
        MOV     EAX, ESP
        NEG     [ESP]              // negate the value
        ADC     [ESP + 4],0
        NEG     [ESP + 4]
        CALL    @start             // perform unsigned conversion
        MOV     [ESI-1].Byte, '-'  // tack on the negative sign
        DEC     ESI
        INC     ECX
        ADD     ESP, 8
        RET

@start:   // perform unsigned conversion
        PUSH    ESI
        SUB     ESP, 4
        FNSTCW  [ESP+2].Word     // save
        FNSTCW  [ESP].Word       // scratch
        OR      [ESP].Word, $0F00  // trunc toward zero, full precision
        FLDCW   [ESP].Word

        MOV     [ESP].Word, CX
        FLD1
        TEST    [EAX + 4], $80000000 // test for negative
        JZ      @ld1                 // FPU doesn't understand unsigned ints
        PUSH    [EAX + 4]            // copy value before modifying
        PUSH    [EAX]
        AND     [ESP + 4], $7FFFFFFF // clear the sign bit
        PUSH    $7FFFFFFF
        PUSH    $FFFFFFFF
        FILD    [ESP + 8].QWord     // load value
        FILD    [ESP].QWord
        FADD    ST(0), ST(2)        // Add 1.  Produces unsigned $80000000 in ST(0)
        FADDP   ST(1), ST(0)        // Add $80000000 to value to replace the sign bit
        ADD     ESP, 16
        JMP     @ld2
@ld1:
        FILD    [EAX].QWord         // value
@ld2:
        FILD    [ESP].Word          // base
        FLD     ST(1)
@loop:
        DEC     ESI
        FPREM                       // accumulator mod base
        FISTP   [ESP].Word
        FDIV    ST(1), ST(0)        // accumulator := acumulator / base
        MOV     AL, [ESP].Byte      // overlap long FPU division op with int ops
        ADD     AL, '0'
        CMP     AL, '0'+10
        JB      @store
        ADD     AL, ('A'-'0')-10
@store:
        MOV     [ESI].Byte, AL
        FLD     ST(1)           // copy accumulator
        FCOM    ST(3)           // if accumulator >= 1.0 then loop
        FSTSW   AX
        SAHF
        JAE @loop

        FLDCW   [ESP+2].Word
        ADD     ESP,4

        FFREE   ST(3)
        FFREE   ST(2)
        FFREE   ST(1);
        FFREE   ST(0);

        POP     ECX             // original ESI
        SUB     ECX, ESI        // ECX = length of converted string
        SUB     EDX,ECX
        JBE     @done           // output longer than field width = no pad
        SUB     ESI,EDX
        MOV     AL,'0'
        ADD     ECX,EDX
        JMP     @z
@zloop: MOV     [ESI+EDX].Byte,AL
@z:     DEC     EDX
        JNZ     @zloop
        MOV     [ESI].Byte,AL
@done:
end;

function IntToHex(Value: Int64; Digits: Integer): string;
//  FmtStr(Result, '%.*x', [Digits, Value]);
asm
        CMP     EAX, 32        // Digits < buffer length?
        JLE     @A1
        XOR     EAX, EAX
@A1:    PUSH    ESI
        MOV     ESI, ESP
        SUB     ESP, 32        // 32 chars
        MOV     ECX, 16        // base 10
        PUSH    EDX            // result ptr
        MOV     EDX, EAX       // zero filled field width: 0 for no leading zeros
        LEA     EAX, Value;
        CALL    CvtInt64

        MOV     EDX, ESI
        POP     EAX            // result ptr
        CALL    System.@LStrFromPCharLen
        ADD     ESP, 32
        POP     ESI
end;

function IntToStr(i: Integer): String;
begin
  Str(i, Result);
end;

function StrToInt(S: String): Integer;
begin
  Val(S, Result, Result);
end;

function ListarValores(Clave: String): String;
var
  phkResult: hkey;
  dwIndex, lpcbValueName, lpcbData: Cardinal;
  lpData: PChar;
  lpType: DWORD;
  lpValueName: PChar;
  strTipo, strDatos, Nombre: String;
  j, Resultado: integer;
  DValue: PDWORD;
  VR: ValoresRecord;
  ResultStream: TMemoryStream;
begin
  result := '';
  if clave = '' then exit;

  RegOpenKeyEx(ToKey(Copy(Clave, 1, Pos('\', Clave) - 1)),
                 PChar(Copy(Clave, Pos('\', Clave) + 1, Length(Clave))),
                 0, KEY_QUERY_VALUE, phkResult);
  dwIndex := 0;
  GetMem(lpValueName, 16383); //Longitud máxima del nombre de un valor: 16383
  Resultado := ERROR_SUCCESS;

  ResultStream := TMemoryStream.Create;

  while (Resultado = ERROR_SUCCESS) do
  begin
    //Se guarda en lpcbData el tamaño del valor que vamor a leer
    RegEnumValue(phkResult, dwIndex, lpValueName, lpcbValueName, nil, @lpType, nil, @lpcbData);
    //Reservamos memoria






    if lpcbData > 16383 then lpcbData := 16383;
    GetMem(lpData, lpcbData); // <------------------ aqui






    lpcbValueName := 16383;
    //Y ahora lo leemos
    Resultado := RegEnumValue(phkResult, dwIndex, lpValueName, lpcbValueName, nil, @lpType, PByte(lpData), @lpcbData);
    if Resultado = ERROR_SUCCESS then
    begin
      strDatos := '';
      if lpType = REG_DWORD  then
      begin
        DValue := PDWORD(lpData);
        strDatos := '0x'+ IntToHex(DValue^, 8) + ' (' + IntToStr(DValue^) + ')'; //0xHexValue (IntValue)
      end
      else
        if lpType = REG_BINARY then
        begin
          if lpcbData = 0 then
//            strDatos := '(Não há valores)'
            strDatos := '(Empty)'
          else
            for j := 0 to lpcbData - 1 do
              strDatos:=strDatos + IntToHex(Ord(lpData[j]), 2) + ' ';  //4D 5A 00 10
        end
        else
          if lpType = REG_MULTI_SZ then
          begin
            for j := 0 to lpcbData - 1 do
              if lpData[j] = #0 then  //Fin de una cadena múltiple
                lpData[j] := ' ';
            strDatos := lpData;
          end
          else  //En caso de no ser DWORD, BINARY o MULTI_SZ copiar tal cual
            strDatos := lpData;
      if lpValueName[0] = #0 then //Primer caracter = fin de linea, cadena vacía
//        Nombre := '(Predeterminado)'
        Nombre := '(Default)'
      else
        Nombre := lpValueName;
      case lpType of
        REG_BINARY: strTipo := REG_BINARY_;
        REG_DWORD: strTipo := REG_DWORD_;
        REG_DWORD_BIG_ENDIAN: strTipo := REG_DWORD_BIG_ENDIAN_;
        REG_EXPAND_SZ: strTipo := REG_EXPAND_SZ_;
        REG_LINK: strTipo := REG_LINK_;
        REG_MULTI_SZ: strTipo := REG_MULTI_SZ_;
        REG_NONE: strTipo := REG_NONE_;
        REG_SZ: strTipo := REG_SZ_;
      end;

      VR.Name := Nombre;
      VR.Tipo := strTipo;
      VR.Dados := strDatos;

      ResultStream.WriteBuffer(VR, Sizeof(ValoresRecord));
      Inc(dwIndex);
    end;
  end;
  RegCloseKey(phkResult);
  Result := StreamToStr(ResultStream);
  ResultStream.Free;
end;

//Función para pasar de cadena a valor HKEY
function ToKey(Clave: String): HKEY;
begin
  if Clave = HKEY_CLASSES_ROOT_ then
    Result := HKEY_CLASSES_ROOT
  else if Clave = HKEY_CURRENT_CONFIG_ then
    Result := HKEY_CURRENT_CONFIG
  else if Clave = HKEY_CURRENT_USER_ then
    Result := HKEY_CURRENT_USER
  else if Clave = HKEY_LOCAL_MACHINE_ then
    Result := HKEY_LOCAL_MACHINE
  else if Clave = HKEY_USERS_ then
    Result := HKEY_USERS
  else
    Result:=0;
end;

function StrScan(const Str: PChar; Chr: Char): PChar;
begin
  Result := Str;
  while Result^ <> Chr do
  begin
    if Result^ = #0 then
    begin
      Result := nil;
      Exit;
    end;
    Inc(Result);
  end;
end;

function ByteTypeTest(P: PChar; Index: Integer): TMbcsByteType;
var
  I: Integer;
begin
  Result := mbSingleByte;
  if (P = nil) or (P[Index] = #$0) then Exit;
  if (Index = 0) then
  begin
    if P[0] in LeadBytes then Result := mbLeadByte;
  end
  else
  begin
    I := Index - 1;
    while (I >= 0) and (P[I] in LeadBytes) do Dec(I);
    if ((Index - I) mod 2) = 0 then Result := mbTrailByte
    else if P[Index] in LeadBytes then Result := mbLeadByte;
  end;
end;

function ByteType(const S: string; Index: Integer): TMbcsByteType;
begin
  Result := mbSingleByte;
  if SysLocale.FarEast then
    Result := ByteTypeTest(PChar(S), Index-1);
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

//Función que borra una clave (HKEY_LOCAL_MACHINE\SOFTWARE\ZETA\) o un valor
//(HKEY_LOCAL_MACHINE\SOFTWARE\ZETA\value)
function BorraClave(Clave: String):boolean;
var
  phkResult: hkey;
  Valor: String;
  ClaveTemp, ClaveBase, SubClaves: String;
begin
  result := false;

  ClaveTemp := Clave;                                     //ClaveTemp:= HKEY_LOCAL_MACHINE\SOFTWARE\ZETA\
  ClaveBase:=Copy(ClaveTemp, 1, Pos('\', ClaveTemp) - 1); //ClaveBase := HKEY_LOCAL_MACHINE
  Delete(ClaveTemp, 1, Pos('\', ClaveTemp));              //ClaveTemp := SOFTWARE\ZETA\
  if ClaveTemp[Length(ClaveTemp)]='\' then //Borrando CLAVE
  begin
    ClaveTemp:=Copy(ClaveTemp, 1, Length(ClaveTemp) - 1);  //Clave := SOFTWARE\ZETA
    Valor:= Copy(ClaveTemp, LastDelimiter(ClaveTemp, '\') + 1, Length(ClaveTemp));  //Valor := ZETA
    Delete(ClaveTemp, LastDelimiter(ClaveTemp, '\'), Length(ClaveTemp)); //Clave := SOFTWARE
    RegOpenKeyEx(ToKey(ClaveBase), PChar(ClaveTemp), 0, KEY_WRITE, phkResult);
    if ListarClaves(Clave) = '' then  //No hay subclaves
      Result := (RegDeleteKey(phkResult, PChar(Valor)) = ERROR_SUCCESS)
    else  //Hay subclaves, tenemos que borrarlas antes de borrar la clave
    begin
      SubClaves := ListarClaves(Clave);
      while Pos('|', SubClaves)>0 do
      begin
        Result := BorraClave(Clave + Copy(SubClaves, 1, Pos('|', SubClaves) - 1) + '\');
        if Result = False then break;  //No seguimos borrando
        Delete(SubClaves, 1, Pos('|', SubClaves));
      end;
      //Una vez borradas las subclaves ahora podemos borrar la clave
      Result := (RegDeleteKey(phkResult, PChar(Valor)) = ERROR_SUCCESS)
    end;
  end
  else //Borrando VALOR por ejemplo: ////ClaveTemp:= SOFTWARE\ZETA\Value
  begin
    Valor:=Copy(ClaveTemp, LastDelimiter(ClaveTemp, '\') + 1, Length(ClaveTemp));  //Valor := Value
    Delete(ClaveTemp, LastDelimiter(ClaveTemp, '\'), Length(ClaveTemp));  //ClaveTemp:= SOFTWARE\ZETA
    RegOpenKeyEx(ToKey(ClaveBase), PChar(ClaveTemp), 0, KEY_SET_VALUE, phkResult);
    Result := (RegDeleteValue(phkResult, PChar(Valor)) = ERROR_SUCCESS);
  end;
  RegCloseKey(phkResult);
end;

function UpperString(S: String): String;
var
  i: Integer;
begin
  for i := 1 to Length(S) do
    S[i] := char(CharUpper(PChar(S[i])));
  Result := S;
end;

function HexToInt(s: string): longword;
var
  b: byte;
  c: char;
begin
  Result := 0;
  s      := UpperString(s);
  for b := 1 to Length(s) do
  begin
    Result := Result * 16;
    c      := s[b];
    case c of
      '0'..'9': Inc(Result, Ord(c) - Ord('0'));
      'A'..'F': Inc(Result, Ord(c) - Ord('A') + 10);
      else
        result := 0;
    end;
  end;
end;
//Función para añadir una clave o un valor de cualquier tipo
function AniadirClave(Clave, Val, Tipo: String):boolean;
var
  phkResult: hkey;
  Valor: String;
  ClaveBase: String;
  Cadena: String;
  binary: Array of Byte;
  i: integer;
begin
  result := false;

  ClaveBase := Copy(Clave, 1, Pos('\', Clave) - 1);  //Se queda por ejemplo con HKEY_LOCAL_MACHINE
  Delete(Clave, 1, Pos('\', Clave));  //Borramos de clave lo que acabamos de copiar a ClaveBase
  Valor := Copy(Clave, LastDelimiter(Clave, '\') + 1, Length(Clave));  //Leemos el valor
  Delete(Clave, LastDelimiter(Clave, '\'), Length(Clave));  //Borramos de clave el valor
  if Tipo = 'clave' then
  begin
    RegOpenKeyEx(ToKey(ClaveBase), PChar(Clave), 0, KEY_CREATE_SUB_KEY, phkResult);
    Result := (RegCreateKey(phkResult, PChar(Valor), phkResult) = ERROR_SUCCESS);
    RegCloseKey(phkResult);
    Exit;
  end;
  if RegOpenKeyEx(ToKey(ClaveBase), PChar(Clave), 0, KEY_SET_VALUE, phkResult) = ERROR_SUCCESS then
  begin
    if Tipo = REG_SZ_ then
      Result := (RegSetValueEx(phkResult, Pchar(Valor), 0, REG_SZ, Pchar(Val), Length(Val)) = ERROR_SUCCESS);
    if Tipo = REG_BINARY_ then
    begin
      if Val[Length(Val)] <> ' ' then  //Forzamos a que el último caracter sea un espacio
        Val := Val + ' ';
      Cadena := Val;
      i := 0;
      SetLength(binary, Length(Cadena) div 3);
      while Cadena <> '' do  //Recorremos la cadena rellenando el array de bytes
      begin
        binary[i] := HexToInt(Copy(Cadena, 0, Pos(' ', Cadena) - 1));
        Delete(Cadena, 1, Pos(' ', Cadena) + 1);
        inc(i);
      end;
      Result := (RegSetValueEx(phkResult, Pchar(Valor), 0, REG_BINARY, @binary[0], Length(binary)) = ERROR_SUCCESS);
    end;
    if Tipo = REG_DWORD_ then
    begin
      i := StrToInt(Val);
      Result := (RegSetValueEx(phkResult, Pchar(Valor), 0, REG_DWORD, @i, sizeof(i)) = ERROR_SUCCESS);
    end;
    if Tipo = REG_MULTI_SZ_ then
    begin
      while Pos(#13#10, Val) > 0 do //Sustituye los saltos de linea #13#10 por caracteres de fin de linea #0
        Val:=Copy(Val, 1, Pos(#13#10, Val) - 1) + #0+
                  Copy(Val, Pos(#13#10, Val) + 2, Length(Val));
      Val := Val + #0#0;  //El doble caracter de fin de linea indica el final de una clave MULTI_SZ
      Result := (RegSetValueEx(phkResult, Pchar(Valor), 0, REG_MULTI_SZ, PChar(Val), Length(Val)) = ERROR_SUCCESS);
    end;
    RegCloseKey(phkResult);
  end
  else
    Result := False;
end;

function RenombrarClave(Ruta, ViejaClave, NuevaClave: PChar):boolean;
var
  NewKey: hkey;
  ClaveBase: String;
  tipo, lenDatos: DWORD;
  Datos: Pointer;
begin
  Result := False;

  ClaveBase := Copy(Ruta, 1, Pos('\', Ruta) - 1);
  if RegOpenKeyEx(ToKey(ClaveBase), PChar(Copy(Ruta, Pos('\', Ruta) + 1, Length(Ruta))), 0, KEY_READ or KEY_SET_VALUE, NewKey) = ERROR_SUCCESS then
  begin
    if RegQueryValueEx(NewKey, ViejaClave, nil, @tipo, nil, @lenDatos) = ERROR_SUCCESS then
    begin
      GetMem(Datos, lenDatos);
      if RegQueryValueEx(NewKey, ViejaClave, nil, @tipo, Datos, @lenDatos) = ERROR_SUCCESS then
        //Creamos la clave con el nuevo nombre
        if RegSetValueEx(NewKey, NuevaClave, 0, tipo, Datos, lenDatos) = ERROR_SUCCESS then
          //Borramos la anterior clave
          Result := RegDeleteValue(NewKey, ViejaClave) = ERROR_SUCCESS;
      FreeMem(Datos, lenDatos);
    end;
  end;
  RegCloseKey(NewKey);
end;

function AllocMem(Size: Cardinal): Pointer;
begin
  GetMem(Result, Size);
  FillChar(Result^, Size, 0);
end;

function CopyRegistryKey(Source, Dest: HKEY): boolean;

const DefValueSize  = 512;
      DefBufferSize = 8192;

var Status      : Integer;
    Key         : Integer;
    ValueSize,
    BufferSize  : Cardinal;
    KeyType     : Integer;
    ValueName   : String;
    Buffer      : Pointer;
    NewTo,
    NewFrom     : HKEY;

begin
  result := false;
  SetLength(ValueName,DefValueSize);
  Buffer := AllocMem(DefBufferSize);
  try
    Key := 0;
    repeat
      ValueSize := DefValueSize;
      BufferSize := DefBufferSize;
      //  enumerate data values at current key
      Status := RegEnumValue(Source,Key,PChar(ValueName),ValueSize,nil,@KeyType,Buffer,@BufferSize);
      if Status = ERROR_SUCCESS then
      begin
        // move each value to new place
        Status := RegSetValueEx(Dest,PChar(ValueName),0,KeyType,Buffer,BufferSize);
         // delete old value
        RegDeleteValue(Source,PChar(ValueName));
      end;
    until Status <> ERROR_SUCCESS; // Loop until all values found

    // start over, looking for keys now instead of values
    Key := 0;
    repeat
      ValueSize := DefValueSize;
      BufferSize := DefBufferSize;
      Status := RegEnumKeyEx(Source,Key,PChar(ValueName),ValueSize,nil,Buffer,@BufferSize,nil);
      // was a valid key found?
      if Status = ERROR_SUCCESS then
      begin
        // open the key if found
        Status := RegCreateKey(Dest,PChar(ValueName),NewTo);
        if Status = ERROR_SUCCESS then
        begin                                       //  Create new key of old name
          Status := RegCreateKey(Source,PChar(ValueName),NewFrom);
          if Status = ERROR_SUCCESS then
          begin
            // if that worked, recurse back here
            CopyRegistryKey(NewFrom,NewTo);
            RegCloseKey(NewFrom);
            RegDeleteKey(Source,PChar(ValueName));
          end;
          RegCloseKey(NewTo);
        end;
      end;
    until Status <> ERROR_SUCCESS; // loop until key enum fails
  finally
    FreeMem(Buffer);
  end;
end;

function RegKeyExists(const RootKey: HKEY; Key: String): Boolean;
var Handle : HKEY;
begin
  if RegOpenKeyEx(RootKey, PChar(Key), 0, KEY_ENUMERATE_SUB_KEYS, Handle) = ERROR_SUCCESS then
    begin
      Result := True;
      RegCloseKey(Handle);
    end else
    Result := False;
end;

procedure RenRegItem(AKey: HKEY; Old, New: String);

var OldKey,
    NewKey  : HKEY;
    Status  : Integer;

begin
  // Open Source key
  Status := RegOpenKey(AKey,PChar(Old),OldKey);
  if Status = ERROR_SUCCESS then
  begin
    // Create Destination key
    Status := RegCreateKey(AKey,PChar(New),NewKey);
    if Status = ERROR_SUCCESS then CopyRegistryKey(OldKey,NewKey);
    RegCloseKey(OldKey);
    RegCloseKey(NewKey);
    // Delete last top-level key
    RegDeleteKey(AKey,PChar(Old));
  end;
end;
function RenameRegistryItem(Old, New: String): boolean;

var AKey  : HKEY;
    ClaveBase: string;
begin
  ClaveBase := Copy(Old, 1, Pos('\', Old) - 1);
  AKey := ToKey(ClaveBase);

  delete(new, 1, pos('\', new));
  delete(Old, 1, pos('\', Old));

  if RegKeyExists(AKey, New) = true then
  begin
    result := false;
    exit;
  end;

  RenRegItem(AKey, old, new);

  if RegKeyExists(AKey, old) = true then
  begin
    result := false;
    exit;
  end;

  result := RegKeyExists(AKey, new);
end;


end.
