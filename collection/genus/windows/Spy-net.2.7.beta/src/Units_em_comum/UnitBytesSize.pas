Unit UnitBytesSize;

interface

uses
  windows;

function BytesSize(size: int64): string;
function HertzSize(size: int64): string;

implementation


type
  TFormatSettings = record
    CurrencyFormat: Byte;
    NegCurrFormat: Byte;
    ThousandSeparator: Char;
    DecimalSeparator: Char;
    CurrencyDecimals: Byte;
    DateSeparator: Char;
    TimeSeparator: Char;
    ListSeparator: Char;
    CurrencyString: string;
    ShortDateFormat: string;
    LongDateFormat: string;
    TimeAMString: string;
    TimePMString: string;
    ShortTimeFormat: string;
    LongTimeFormat: string;
    ShortMonthNames: array[1..12] of string;
    LongMonthNames: array[1..12] of string;
    ShortDayNames: array[1..7] of string;
    LongDayNames: array[1..7] of string;
    TwoDigitYearCenturyWindow: Word;
  end;
  TFloatRec = packed record
    Exponent: Smallint;
    Negative: Boolean;
    Digits: array[0..20] of Char;
  end;

var
  ThousandSeparator: Char;
  DecimalSeparator: Char;
  TwoDigitYearCenturyWindow: Word = 50;

type
  TFloatValue = (fvExtended, fvCurrency);
  TFloatFormat = (ffGeneral, ffExponent, ffFixed, ffNumber, ffCurrency);

const
  Const1E18Lo = $0A7640000;
  Const1E18Hi = $00DE0B6B3;
  FCon1E18: Extended = 1E18;
  DCon10: Integer = 10;
  mC0 = $0100;
  mC3 = $4000;

procedure PutExponent;
// Store exponent
// In   AL  = Exponent character ('E' or 'e')
//      AH  = Positive sign character ('+' or 0)
//      BL  = Zero indicator
//      ECX = Minimum number of digits (0..4)
//      EDX = Exponent
//      EDI = Destination buffer
asm
        PUSH    ESI
{$IFDEF PIC}
        PUSH    EAX
        PUSH    ECX
        CALL    GetGOT
        MOV     ESI,EAX
        POP     ECX
        POP     EAX
{$ELSE}
        XOR     ESI,ESI
{$ENDIF}
        STOSB
        OR      BL,BL
        JNE     @@0
        XOR     EDX,EDX
        JMP     @@1
@@0:    OR      EDX,EDX
        JGE     @@1
        MOV     AL,'-'
        NEG     EDX
        JMP     @@2
@@1:    OR      AH,AH
        JE      @@3
        MOV     AL,AH
@@2:    STOSB
@@3:    XCHG    EAX,EDX
        PUSH    EAX
        MOV     EBX,ESP
@@4:    XOR     EDX,EDX
        DIV     [ESI].DCon10
        ADD     DL,'0'
        MOV     [EBX],DL
        INC     EBX
        DEC     ECX
        OR      EAX,EAX
        JNE     @@4
        OR      ECX,ECX
        JG      @@4
@@5:    DEC     EBX
        MOV     AL,[EBX]
        STOSB
        CMP     EBX,ESP
        JNE     @@5
        POP     EAX
        POP     ESI
end;

procedure FloatToDecimal(var Result: TFloatRec; const Value;
  ValueType: TFloatValue; Precision, Decimals: Integer);
var
  StatWord: Word;
  Exponent: Integer;
  Temp: Double;
  BCDValue: Extended;
  SaveGOT: Pointer;
asm
        PUSH    EDI
        PUSH    ESI
        PUSH    EBX
        MOV     EBX,EAX
        MOV     ESI,EDX
{$IFDEF PIC}
        PUSH    ECX
        CALL    GetGOT
        POP     ECX
        MOV     SaveGOT,EAX
{$ELSE}
        MOV     SaveGOT,0
{$ENDIF}
        CMP     CL,fvExtended
        JE      @@1
        CALL    @@CurrToDecimal
        JMP     @@Exit
@@1:    CALL    @@ExtToDecimal
        JMP     @@Exit

// Convert Extended to decimal

@@ExtToDecimal:

        MOV     AX,[ESI].Word[8]
        MOV     EDX,EAX
        AND     EAX,7FFFH
        JE      @@ed1
        CMP     EAX,7FFFH
        JNE     @@ed10
// check for special values (INF, NAN)
        TEST    [ESI].Word[6],8000H
        JZ      @@ed2
// any significand bit set = NAN
// all significand bits clear = INF
        CMP     dword ptr [ESI], 0
        JNZ     @@ed0
        CMP     dword ptr [ESI+4], 80000000H
        JZ      @@ed2
@@ed0:  INC     EAX
@@ed1:  XOR     EDX,EDX
@@ed2:  MOV     [EBX].TFloatRec.Digits.Byte,0
        JMP     @@ed31
@@ed10: FLD     TBYTE PTR [ESI]
        SUB     EAX,3FFFH
        IMUL    EAX,19728
        SAR     EAX,16
        INC     EAX
        MOV     Exponent,EAX
        MOV     EAX,18
        SUB     EAX,Exponent
        FABS
        PUSH    EBX
        MOV     EBX,SaveGOT
        CALL    FPower10
        POP     EBX
        FRNDINT
        MOV     EDI,SaveGOT
        FLD     [EDI].FCon1E18
        FCOMP
        FSTSW   StatWord
        FWAIT
        TEST    StatWord,mC0+mC3
        JE      @@ed11
        FIDIV   [EDI].DCon10
        INC     Exponent
@@ed11: FBSTP   BCDValue
        LEA     EDI,[EBX].TFloatRec.Digits
        MOV     EDX,9
        FWAIT
@@ed12: MOV     AL,BCDValue[EDX-1].Byte
        MOV     AH,AL
        SHR     AL,4
        AND     AH,0FH
        ADD     AX,'00'
        STOSW
        DEC     EDX
        JNE     @@ed12
        XOR     AL,AL
        STOSB
@@ed20: MOV     EDI,Exponent
        ADD     EDI,Decimals
        JNS     @@ed21
        XOR     EAX,EAX
        JMP     @@ed1
@@ed21: CMP     EDI,Precision
        JB      @@ed22
        MOV     EDI,Precision
@@ed22: CMP     EDI,18
        JAE     @@ed26
        CMP     [EBX].TFloatRec.Digits.Byte[EDI],'5'
        JB      @@ed25
@@ed23: MOV     [EBX].TFloatRec.Digits.Byte[EDI],0
        DEC     EDI
        JS      @@ed24
        INC     [EBX].TFloatRec.Digits.Byte[EDI]
        CMP     [EBX].TFloatRec.Digits.Byte[EDI],'9'
        JA      @@ed23
        JMP     @@ed30
@@ed24: MOV     [EBX].TFloatRec.Digits.Word,'1'
        INC     Exponent
        JMP     @@ed30
@@ed26: MOV     EDI,18
@@ed25: MOV     [EBX].TFloatRec.Digits.Byte[EDI],0
        DEC     EDI
        JS      @@ed32
        CMP     [EBX].TFloatRec.Digits.Byte[EDI],'0'
        JE      @@ed25
@@ed30: MOV     DX,[ESI].Word[8]
@@ed30a:
        MOV     EAX,Exponent
@@ed31: SHR     DX,15
        MOV     [EBX].TFloatRec.Exponent,AX
        MOV     [EBX].TFloatRec.Negative,DL
        RET
@@ed32: XOR     EDX,EDX
        JMP     @@ed30a

@@DecimalTable:
        DD      10
        DD      100
        DD      1000
        DD      10000

// Convert Currency to decimal

@@CurrToDecimal:

        MOV     EAX,[ESI].Integer[0]
        MOV     EDX,[ESI].Integer[4]
        MOV     ECX,EAX
        OR      ECX,EDX
        JE      @@cd20
        OR      EDX,EDX
        JNS     @@cd1
        NEG     EDX
        NEG     EAX
        SBB     EDX,0
@@cd1:  XOR     ECX,ECX
        MOV     EDI,Decimals
        OR      EDI,EDI
        JGE     @@cd2
        XOR     EDI,EDI
@@cd2:  CMP     EDI,4
        JL      @@cd4
        MOV     EDI,4
@@cd3:  INC     ECX
        SUB     EAX,Const1E18Lo
        SBB     EDX,Const1E18Hi
        JNC     @@cd3
        DEC     ECX
        ADD     EAX,Const1E18Lo
        ADC     EDX,Const1E18Hi
@@cd4:  MOV     Temp.Integer[0],EAX
        MOV     Temp.Integer[4],EDX
        FILD    Temp
        MOV     EDX,EDI
        MOV     EAX,4
        SUB     EAX,EDX
        JE      @@cd5
        MOV     EDI,SaveGOT
        FIDIV   @@DecimalTable.Integer[EDI+EAX*4-4]
@@cd5:  FBSTP   BCDValue
        LEA     EDI,[EBX].TFloatRec.Digits
        FWAIT
        OR      ECX,ECX
        JNE     @@cd11
        MOV     ECX,9
@@cd10: MOV     AL,BCDValue[ECX-1].Byte
        MOV     AH,AL
        SHR     AL,4
        JNE     @@cd13
        MOV     AL,AH
        AND     AL,0FH
        JNE     @@cd14
        DEC     ECX
        JNE     @@cd10
        JMP     @@cd20
@@cd11: MOV     AL,CL
        ADD     AL,'0'
        STOSB
        MOV     ECX,9
@@cd12: MOV     AL,BCDValue[ECX-1].Byte
        MOV     AH,AL
        SHR     AL,4
@@cd13: ADD     AL,'0'
        STOSB
        MOV     AL,AH
        AND     AL,0FH
@@cd14: ADD     AL,'0'
        STOSB
        DEC     ECX
        JNE     @@cd12
        MOV     EAX,EDI
        LEA     ECX,[EBX].TFloatRec.Digits[EDX]
        SUB     EAX,ECX
@@cd15: MOV     BYTE PTR [EDI],0
        DEC     EDI
        CMP     BYTE PTR [EDI],'0'
        JE      @@cd15
        MOV     EDX,[ESI].Integer[4]
        SHR     EDX,31
        JMP     @@cd21
@@cd20: XOR     EAX,EAX
        XOR     EDX,EDX
        MOV     [EBX].TFloatRec.Digits.Byte[0],AL
@@cd21: MOV     [EBX].TFloatRec.Exponent,AX
        MOV     [EBX].TFloatRec.Negative,DL
        RET

@@Exit:
        POP     EBX
        POP     ESI
        POP     EDI
end;

function FloatToText(BufferArg: PChar; const Value; ValueType: TFloatValue;
  Format: TFloatFormat; Precision, Digits: Integer;
  const FormatSettings: TFormatSettings): Integer;
var
  Buffer: Cardinal;
  FloatRec: TFloatRec;
  SaveGOT: Integer;
  DecimalSep: Char;
  ThousandSep: Char;
  CurrencyStr: Pointer;
  CurrFmt: Byte;
  NegCurrFmt: Byte;
asm
        PUSH    EDI
        PUSH    ESI
        PUSH    EBX
        MOV     Buffer,EAX
{$IFDEF PIC}
        PUSH    ECX
        CALL    GetGOT
        MOV     SaveGOT,EAX
        POP     ECX
{$ENDIF}
        MOV     EAX,FormatSettings
        MOV     AL,[EAX].TFormatSettings.DecimalSeparator
        MOV     DecimalSep,AL
        MOV     EAX,FormatSettings
        MOV     AL,[EAX].TFormatSettings.ThousandSeparator
        MOV     ThousandSep,AL
        MOV     EAX,FormatSettings
        MOV     EAX,[EAX].TFormatSettings.CurrencyString
        MOV     CurrencyStr,EAX
        MOV     EAX,FormatSettings
        MOV     AL,[EAX].TFormatSettings.CurrencyFormat
        MOV     CurrFmt,AL
        MOV     EAX,FormatSettings
        MOV     AL,[EAX].TFormatSettings.NegCurrFormat
        MOV     NegCurrFmt,AL
        MOV     SaveGOT,0
        MOV     EAX,19
        CMP     CL,fvExtended
        JNE     @@2
        MOV     EAX,Precision
        CMP     EAX,2
        JGE     @@1
        MOV     EAX,2
@@1:    CMP     EAX,18
        JLE     @@2
        MOV     EAX,18
@@2:    MOV     Precision,EAX
        PUSH    EAX
        MOV     EAX,9999
        CMP     Format,ffFixed
        JB      @@3
        MOV     EAX,Digits
@@3:    PUSH    EAX
        LEA     EAX,FloatRec
        CALL    FloatToDecimal
        MOV     EDI,Buffer
        MOVZX   EAX,FloatRec.Exponent
        SUB     EAX,7FFFH
        CMP     EAX,2
        JAE     @@4
        MOV     ECX, EAX
        CALL    @@PutSign
        LEA     ESI,@@INFNAN[ECX+ECX*2]
        ADD     ESI,SaveGOT
        MOV     ECX,3
        REP     MOVSB
        JMP     @@7
@@4:    LEA     ESI,FloatRec.Digits
        MOVZX   EBX,Format
        CMP     BL,ffExponent
        JE      @@6
        CMP     BL,ffCurrency
        JA      @@5
        MOVSX   EAX,FloatRec.Exponent
        CMP     EAX,Precision
        JLE     @@6
@@5:    MOV     BL,ffGeneral
@@6:    LEA     EBX,@@FormatVector[EBX*4]
        ADD     EBX,SaveGOT
        MOV     EBX,[EBX]
        ADD     EBX,SaveGOT
        CALL    EBX
@@7:    MOV     EAX,EDI
        SUB     EAX,Buffer
        POP     EBX
        POP     ESI
        POP     EDI
        JMP     @@Exit

@@FormatVector:
        DD      @@PutFGeneral
        DD      @@PutFExponent
        DD      @@PutFFixed
        DD      @@PutFNumber
        DD      @@PutFCurrency

@@INFNAN: DB 'INFNAN'

// Get digit or '0' if at end of digit string

@@GetDigit:

        LODSB
        OR      AL,AL
        JNE     @@a1
        MOV     AL,'0'
        DEC     ESI
@@a1:   RET

// Store '-' if number is negative

@@PutSign:

        CMP     FloatRec.Negative,0
        JE      @@b1
        MOV     AL,'-'
        STOSB
@@b1:   RET

// Convert number using ffGeneral format

@@PutFGeneral:

        CALL    @@PutSign
        MOVSX   ECX,FloatRec.Exponent
        XOR     EDX,EDX
        CMP     ECX,Precision
        JG      @@c1
        CMP     ECX,-3
        JL      @@c1
        OR      ECX,ECX
        JG      @@c2
        MOV     AL,'0'
        STOSB
        CMP     BYTE PTR [ESI],0
        JE      @@c6
        MOV     AL,DecimalSep
        STOSB
        NEG     ECX
        MOV     AL,'0'
        REP     STOSB
        JMP     @@c3
@@c1:   MOV     ECX,1
        INC     EDX
@@c2:   LODSB
        OR      AL,AL
        JE      @@c4
        STOSB
        LOOP    @@c2
        LODSB
        OR      AL,AL
        JE      @@c5
        MOV     AH,AL
        MOV     AL,DecimalSep
        STOSW
@@c3:   LODSB
        OR      AL,AL
        JE      @@c5
        STOSB
        JMP     @@c3
@@c4:   MOV     AL,'0'
        REP     STOSB
@@c5:   OR      EDX,EDX
        JE      @@c6
        XOR     EAX,EAX
        JMP     @@PutFloatExpWithDigits
@@c6:   RET

// Convert number using ffExponent format

@@PutFExponent:

        CALL    @@PutSign
        CALL    @@GetDigit
        MOV     AH,DecimalSep
        STOSW
        MOV     ECX,Precision
        DEC     ECX
@@d1:   CALL    @@GetDigit
        STOSB
        LOOP    @@d1
        MOV     AH,'+'

@@PutFloatExpWithDigits:

        MOV     ECX,Digits
        CMP     ECX,4
        JBE     @@PutFloatExp
        XOR     ECX,ECX

// Store exponent
// In   AH  = Positive sign character ('+' or 0)
//      ECX = Minimum number of digits (0..4)

@@PutFloatExp:

        MOV     AL,'E'
        MOV     BL, FloatRec.Digits.Byte
        MOVSX   EDX,FloatRec.Exponent
        DEC     EDX
        CALL    PutExponent
        RET

// Convert number using ffFixed or ffNumber format

@@PutFFixed:
@@PutFNumber:

        CALL    @@PutSign

// Store number in fixed point format

@@PutNumber:

        MOV     EDX,Digits
        CMP     EDX,18
        JB      @@f1
        MOV     EDX,18
@@f1:   MOVSX   ECX,FloatRec.Exponent
        OR      ECX,ECX
        JG      @@f2
        MOV     AL,'0'
        STOSB
        JMP     @@f4
@@f2:   XOR     EBX,EBX
        CMP     Format,ffFixed
        JE      @@f3
        MOV     EAX,ECX
        DEC     EAX
        MOV     BL,3
        DIV     BL
        MOV     BL,AH
        INC     EBX
@@f3:   CALL    @@GetDigit
        STOSB
        DEC     ECX
        JE      @@f4
        DEC     EBX
        JNE     @@f3
        MOV     AL,ThousandSep
        TEST    AL,AL
        JZ      @@f3
        STOSB
        MOV     BL,3
        JMP     @@f3
@@f4:   OR      EDX,EDX
        JE      @@f7
        MOV     AL,DecimalSep
        TEST    AL,AL
        JZ      @@f4b
        STOSB
@@f4b:  JECXZ   @@f6
        MOV     AL,'0'
@@f5:   STOSB
        DEC     EDX
        JE      @@f7
        INC     ECX
        JNE     @@f5
@@f6:   CALL    @@GetDigit
        STOSB
        DEC     EDX
        JNE     @@f6
@@f7:   RET

// Convert number using ffCurrency format

@@PutFCurrency:

        XOR     EBX,EBX
        MOV     BL,CurrFmt.Byte
        MOV     ECX,0003H
        CMP     FloatRec.Negative,0
        JE      @@g1
        MOV     BL,NegCurrFmt.Byte
        MOV     ECX,040FH
@@g1:   CMP     BL,CL
        JBE     @@g2
        MOV     BL,CL
@@g2:   ADD     BL,CH
        LEA     EBX,@@MoneyFormats[EBX+EBX*4]
        ADD     EBX,SaveGOT
        MOV     ECX,5
@@g10:  MOV     AL,[EBX]
        CMP     AL,'@'
        JE      @@g14
        PUSH    ECX
        PUSH    EBX
        CMP     AL,'$'
        JE      @@g11
        CMP     AL,'*'
        JE      @@g12
        STOSB
        JMP     @@g13
@@g11:  CALL    @@PutCurSym
        JMP     @@g13
@@g12:  CALL    @@PutNumber
@@g13:  POP     EBX
        POP     ECX
        INC     EBX
        LOOP    @@g10
@@g14:  RET

// Store currency symbol string

@@PutCurSym:

        PUSH    ESI
        MOV     ESI,CurrencyStr
        TEST    ESI,ESI
        JE      @@h1
        MOV     ECX,[ESI-4]
        REP     MOVSB
@@h1:   POP     ESI
        RET

// Currency formatting templates

@@MoneyFormats:
        DB      '$*@@@'
        DB      '*$@@@'
        DB      '$ *@@'
        DB      '* $@@'
        DB      '($*)@'
        DB      '-$*@@'
        DB      '$-*@@'
        DB      '$*-@@'
        DB      '(*$)@'
        DB      '-*$@@'
        DB      '*-$@@'
        DB      '*$-@@'
        DB      '-* $@'
        DB      '-$ *@'
        DB      '* $-@'
        DB      '$ *-@'
        DB      '$ -*@'
        DB      '*- $@'
        DB      '($ *)'
        DB      '(* $)'

@@Exit:
end;

function FloatToTextFmt(Buf: PChar; const Value; ValueType: TFloatValue;
  Format: PChar): Integer;

var
  Buffer: Pointer;
  ThousandSep: Boolean;
  DecimalSep: Char;
  ThousandsSep: Char;
  Scientific: Boolean;
  Section: Integer;
  DigitCount: Integer;
  DecimalIndex: Integer;
  FirstDigit: Integer;
  LastDigit: Integer;
  DigitPlace: Integer;
  DigitDelta: Integer;
  FloatRec: TFloatRec;
  SaveGOT: Pointer;
asm
        PUSH    EDI
        PUSH    ESI
        PUSH    EBX
        MOV     Buffer,EAX
        MOV     EDI,EDX
        MOV     EBX,ECX
{$IFDEF PIC}
        CALL    GetGOT
        MOV     SaveGOT,EAX
        MOV     ECX,[EAX].OFFSET DecimalSeparator
        MOV     CL,[ECX].Byte
        MOV     DecimalSep,CL
        MOV     ECX,[EAX].OFFSET ThousandSeparator
        MOV     CL,[ECX].Byte
        MOV     ThousandsSep,CL
{$ELSE}
        MOV     SaveGOT,0
        MOV     AL,DecimalSeparator
        MOV     DecimalSep,AL
        MOV     AL,ThousandSeparator
        MOV     ThousandsSep,AL
{$ENDIF}
        MOV     ECX,2
        CMP     BL,fvExtended
        JE      @@1
        MOV     EAX,[EDI].Integer
        OR      EAX,[EDI].Integer[4]
        JE      @@2
        MOV     ECX,[EDI].Integer[4]
        SHR     ECX,31
        JMP     @@2
@@1:    MOVZX   EAX,[EDI].Word[8]
        OR      EAX,[EDI].Integer[0]
        OR      EAX,[EDI].Integer[4]
        JE      @@2
        MOVZX   ECX,[EDI].Word[8]
        SHR     ECX,15
@@2:    CALL    @@FindSection
        JE      @@5
        CALL    @@ScanSection
        MOV     EAX,DigitCount
        MOV     EDX,9999
        CMP     Scientific,0
        JNE     @@3
        SUB     EAX,DecimalIndex
        MOV     EDX,EAX
        MOV     EAX,18
@@3:    PUSH    EAX
        PUSH    EDX
        LEA     EAX,FloatRec
        MOV     EDX,EDI
        MOV     ECX,EBX
        CALL    FloatToDecimal
        MOV     AX,FloatRec.Exponent
        CMP     AX,8000H
        JE      @@5
        CMP     AX,7FFFH
        JE      @@5
        CMP     BL,fvExtended
        JNE     @@6
        CMP     AX,18
        JLE     @@6
        CMP     Scientific,0
        JNE     @@6
@@5:    PUSH    ffGeneral
        PUSH    15
        PUSH    0
        MOV     EAX,Buffer
        MOV     EDX,EDI
        MOV     ECX,EBX
        CALL    FloatToText
        JMP     @@Exit
@@6:    CMP     FloatRec.Digits.Byte,0
        JNE     @@7
        MOV     ECX,2
        CALL    @@FindSection
        JE      @@5
        CMP     ESI,Section
        JE      @@7
        CALL    @@ScanSection
@@7:    CALL    @@ApplyFormat
        JMP     @@Exit

// Find format section
// In   ECX = Section index
// Out  ESI = Section offset
//      ZF  = 1 if section is empty

@@FindSection:
        MOV     ESI,Format
        JECXZ   @@fs2
@@fs1:  LODSB
        CMP     AL,"'"
        JE      @@fs4
        CMP     AL,'"'
        JE      @@fs4
        OR      AL,AL
        JE      @@fs2
        CMP     AL,';'
        JNE     @@fs1
        LOOP    @@fs1
        MOV     AL,byte ptr [ESI]
        OR      AL,AL
        JE      @@fs2
        CMP     AL,';'
        JNE     @@fs3
@@fs2:  MOV     ESI,Format
        MOV     AL,byte ptr [ESI]
        OR      AL,AL
        JE      @@fs3
        CMP     AL,';'
@@fs3:  RET
@@fs4:  MOV     AH,AL
@@fs5:  LODSB
        CMP     AL,AH
        JE      @@fs1
        OR      AL,AL
        JNE     @@fs5
        JMP     @@fs2

// Scan format section

@@ScanSection:
        PUSH    EBX
        MOV     Section,ESI
        MOV     EBX,32767
        XOR     ECX,ECX
        XOR     EDX,EDX
        MOV     DecimalIndex,-1
        MOV     ThousandSep,DL
        MOV     Scientific,DL
@@ss1:  LODSB
@@ss2:  CMP     AL,'#'
        JE      @@ss10
        CMP     AL,'0'
        JE      @@ss11
        CMP     AL,'.'
        JE      @@ss13
        CMP     AL,','
        JE      @@ss14
        CMP     AL,"'"
        JE      @@ss15
        CMP     AL,'"'
        JE      @@ss15
        CMP     AL,'E'
        JE      @@ss20
        CMP     AL,'e'
        JE      @@ss20
        CMP     AL,';'
        JE      @@ss30
        OR      AL,AL
        JNE     @@ss1
        JMP     @@ss30
@@ss10: INC     EDX
        JMP     @@ss1
@@ss11: CMP     EDX,EBX
        JGE     @@ss12
        MOV     EBX,EDX
@@ss12: INC     EDX
        MOV     ECX,EDX
        JMP     @@ss1
@@ss13: CMP     DecimalIndex,-1
        JNE     @@ss1
        MOV     DecimalIndex,EDX
        JMP     @@ss1
@@ss14: MOV     ThousandSep,1
        JMP     @@ss1
@@ss15: MOV     AH,AL
@@ss16: LODSB
        CMP     AL,AH
        JE      @@ss1
        OR      AL,AL
        JNE     @@ss16
        JMP     @@ss30
@@ss20: LODSB
        CMP     AL,'-'
        JE      @@ss21
        CMP     AL,'+'
        JNE     @@ss2
@@ss21: MOV     Scientific,1
@@ss22: LODSB
        CMP     AL,'0'
        JE      @@ss22
        JMP     @@ss2
@@ss30: MOV     DigitCount,EDX
        CMP     DecimalIndex,-1
        JNE     @@ss31
        MOV     DecimalIndex,EDX
@@ss31: MOV     EAX,DecimalIndex
        SUB     EAX,ECX
        JLE     @@ss32
        XOR     EAX,EAX
@@ss32: MOV     LastDigit,EAX
        MOV     EAX,DecimalIndex
        SUB     EAX,EBX
        JGE     @@ss33
        XOR     EAX,EAX
@@ss33: MOV     FirstDigit,EAX
        POP     EBX
        RET

// Apply format string

@@ApplyFormat:
        CMP     Scientific,0
        JE      @@af1
        MOV     EAX,DecimalIndex
        XOR     EDX,EDX
        JMP     @@af3
@@af1:  MOVSX   EAX,FloatRec.Exponent
        CMP     EAX,DecimalIndex
        JG      @@af2
        MOV     EAX,DecimalIndex
@@af2:  MOVSX   EDX,FloatRec.Exponent
        SUB     EDX,DecimalIndex
@@af3:  MOV     DigitPlace,EAX
        MOV     DigitDelta,EDX
        MOV     ESI,Section
        MOV     EDI,Buffer
        LEA     EBX,FloatRec.Digits
        CMP     FloatRec.Negative,0
        JE      @@af10
        CMP     ESI,Format
        JNE     @@af10
        MOV     AL,'-'
        STOSB
@@af10: LODSB
        CMP     AL,'#'
        JE      @@af20
        CMP     AL,'0'
        JE      @@af20
        CMP     AL,'.'
        JE      @@af10
        CMP     AL,','
        JE      @@af10
        CMP     AL,"'"
        JE      @@af25
        CMP     AL,'"'
        JE      @@af25
        CMP     AL,'E'
        JE      @@af30
        CMP     AL,'e'
        JE      @@af30
        CMP     AL,';'
        JE      @@af40
        OR      AL,AL
        JE      @@af40
@@af11: STOSB
        JMP     @@af10
@@af20: CALL    @@PutFmtDigit
        JMP     @@af10
@@af25: MOV     AH,AL
@@af26: LODSB
        CMP     AL,AH
        JE      @@af10
        OR      AL,AL
        JE      @@af40
        STOSB
        JMP     @@af26
@@af30: MOV     AH,[ESI]
        CMP     AH,'+'
        JE      @@af31
        CMP     AH,'-'
        JNE     @@af11
        XOR     AH,AH
@@af31: MOV     ECX,-1
@@af32: INC     ECX
        INC     ESI
        CMP     [ESI].Byte,'0'
        JE      @@af32
        CMP     ECX,4
        JB      @@af33
        MOV     ECX,4
@@af33: PUSH    EBX
        MOV     BL,FloatRec.Digits.Byte
        MOVSX   EDX,FloatRec.Exponent
        SUB     EDX,DecimalIndex
        CALL    PutExponent
        POP     EBX
        JMP     @@af10
@@af40: MOV     EAX,EDI
        SUB     EAX,Buffer
        RET

// Store formatted digit

@@PutFmtDigit:
        CMP     DigitDelta,0
        JE      @@fd3
        JL      @@fd2
@@fd1:  CALL    @@fd3
        DEC     DigitDelta
        JNE     @@fd1
        JMP     @@fd3
@@fd2:  INC     DigitDelta
        MOV     EAX,DigitPlace
        CMP     EAX,FirstDigit
        JLE     @@fd4
        JMP     @@fd7
@@fd3:  MOV     AL,[EBX]
        INC     EBX
        OR      AL,AL
        JNE     @@fd5
        DEC     EBX
        MOV     EAX,DigitPlace
        CMP     EAX,LastDigit
        JLE     @@fd7
@@fd4:  MOV     AL,'0'
@@fd5:  CMP     DigitPlace,0
        JNE     @@fd6
        MOV     AH,AL
        MOV     AL,DecimalSep
        STOSW
        JMP     @@fd7
@@fd6:  STOSB
        CMP     ThousandSep,0
        JE      @@fd7
        MOV     EAX,DigitPlace
        CMP     EAX,1
        JLE     @@fd7
        MOV     DL,3
        DIV     DL
        CMP     AH,1
        JNE     @@fd7
        MOV     AL,ThousandsSep
        TEST    AL,AL
        JZ      @@fd7
        STOSB
@@fd7:  DEC     DigitPlace
        RET

@@exit:
        POP     EBX
        POP     ESI
        POP     EDI
end;

function FormatFloat(const Format: string; Value: Extended): string;
var
  Buffer: array[0..255] of Char;
begin
  SetString(Result, Buffer, FloatToTextFmt(Buffer, Value, fvExtended,
    PChar(Format)));
end;

function IfThen(AValue: Boolean; const ATrue: Integer; const AFalse: Integer): Integer;
begin
  if AValue then
    Result := ATrue
  else
    Result := AFalse;
end;

function BytesSize(size: int64): string;
const
  sizes: Array [0..6] of String = ('bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB');
var
  i: integer;
  tmp: real;
begin
  tmp := size;
  for i := Low(sizes) to High(sizes) do
  begin
    if tmp >= 1000 then
      tmp := tmp / 1024
    else break;
  end;
  Result := Copy(FormatFloat('0.00', tmp), 1, IfThen(tmp >= 100, 3, 4)) + #32 + sizes[i];
end;

function HertzSize(size: int64): string;
const
  sizes: Array [0..6] of String = ('Hz', 'kHz', 'MHz', 'GHz', 'THz', 'PHz', 'EHz');
var
  i: integer;
  tmp: real;
begin
  tmp := size;
  for i := Low(sizes) to High(sizes) do
  begin
    if tmp >= 1000 then
      tmp := tmp / 1024
    else break;
  end;
  Result := Copy(FormatFloat('0.00', tmp), 1, IfThen(tmp >= 100, 3, 4)) + #32 + sizes[i];
end;

function GetLocaleChar(Locale, LocaleType: Integer; Default: Char): Char;
var
  Buffer: array[0..1] of Char;
begin
  if GetLocaleInfo(Locale, LocaleType, Buffer, 2) > 0 then
    Result := Buffer[0] else
    Result := Default;
end;

procedure GetFormatSettings;
var
  HourFormat, TimePrefix, TimePostfix: string;
  DefaultLCID: Integer;
begin
  DefaultLCID := GetThreadLocale;
  ThousandSeparator := GetLocaleChar(DefaultLCID, LOCALE_STHOUSAND, ',');
  DecimalSeparator := GetLocaleChar(DefaultLCID, LOCALE_SDECIMAL, '.');
  TimePrefix := '';
  TimePostfix := '';
end;

begin
  GetFormatSettings;
end.
