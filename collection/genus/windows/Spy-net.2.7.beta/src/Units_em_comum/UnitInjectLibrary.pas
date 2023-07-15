unit UnitInjectLibrary;

interface

uses
  windows;

function InjectPointerLibrary(Process: longword; Src: pointer): boolean;

implementation

const
  IMPORTED_NAME_OFFSET = $00000002;
  IMAGE_ORDINAL_FLAG32 = $80000000;
  IMAGE_ORDINAL_MASK32 = $0000FFFF;

type
  PImageImportDescriptor = ^TImageImportDescriptor;
  TImageImportDescriptor = packed record
    OriginalFirstThunk: longword;
    TimeDateStamp: longword;
    ForwarderChain: longword;
    Name: longword;
    FirstThunk: longword;
  end;

  PImageBaseRelocation = ^TImageBaseRelocation;
  TImageBaseRelocation = packed record
    VirtualAddress: cardinal;
    SizeOfBlock:    cardinal;
  end;

  TDllEntryProc = function(hinstDLL: HMODULE; dwReason: longword;
    lpvReserved: pointer): boolean; stdcall;

  TStringArray = array of string;

  TLibInfo = record
    ImageBase: pointer;
    ImageSize: longint;
    DllProc:   TDllEntryProc;
    DllProcAddress: pointer;
    LibsUsed:  TStringArray;
  end;
  PLibInfo = ^TLibInfo;
  TSections = array [0..0] of TImageSectionHeader;

function SizeOfProc(pAddr: pointer): Cardinal;
var
  dwSize: Cardinal;
begin
  dwSize := 0;
  repeat
    inc(dwSize); 
  until PByte(Cardinal(pAddr)+dwSize-1)^ = $C3;
  Result := dwSize;
end;

function InjectString(Process: longword; Text: PChar): PChar;
var
  BytesWritten: longword;
begin
  Result := VirtualAllocEx(Process, nil, Length(Text) + 1, MEM_COMMIT or MEM_RESERVE, PAGE_EXECUTE_READWRITE);
  WriteProcessMemory(Process, Result, Text, Length(Text) + 1, BytesWritten);
end;

function InjectMemory(Process: longword; Memory: pointer; Len: longword): pointer;
var
  BytesWritten: longword;
begin
  Result := VirtualAllocEx(Process, nil, Len, MEM_COMMIT or MEM_RESERVE,
    PAGE_EXECUTE_READWRITE);
  WriteProcessMemory(Process, Result, Memory, Len, BytesWritten);
end;

function InjectThread(Process: longword; Thread: pointer; Info: pointer;
  InfoLen: longword; Results: boolean): THandle;
var
  pThread, pInfo: pointer;
  BytesRead, TID: longword;
begin
  pInfo   := InjectMemory(Process, Info, InfoLen);
  pThread := InjectMemory(Process, Thread, SizeOfProc(Thread));
  Result  := CreateRemoteThread(Process, nil, 0, pThread, pInfo, 0, TID);
  if Results then
  begin
    WaitForSingleObject(Result, INFINITE);
    ReadProcessMemory(Process, pInfo, Info, InfoLen, BytesRead);
  end;
end;

function InjectLibrary(Process: longword; ModulePath: string): boolean;
type
  TInjectLibraryInfo = record
    pLoadLibrary: pointer;
    lpModuleName: pointer;
    pSleep: pointer;
  end;
var
  InjectLibraryInfo: TInjectLibraryInfo;
  Thread: THandle;

  procedure InjectLibraryThread(lpParameter: pointer); stdcall;
  var
    InjectLibraryInfo: TInjectLibraryInfo;
  begin
    InjectLibraryInfo := TInjectLibraryInfo(lpParameter^);
    asm
      PUSH    InjectLibraryInfo.lpModuleName
      CALL    InjectLibraryInfo.pLoadLibrary
      @noret:
      MOV     EAX, $FFFFFFFF
      PUSH    EAX
      CALL    InjectLibraryInfo.pSleep
      JMP     @noret
    end;
  end;

begin
  Result := False;
  InjectLibraryInfo.pSleep := GetProcAddress(GetModuleHandle('kernel32'), 'Sleep');
  InjectLibraryInfo.pLoadLibrary := GetProcAddress(GetModuleHandle('kernel32'), 'LoadLibraryA');
  InjectLibraryInfo.lpModuleName := InjectString(Process, PChar(ModulePath));
  Thread := InjectThread(Process, @InjectLibraryThread, @InjectLibraryInfo, SizeOf(TInjectLibraryInfo), False);
  if Thread = 0 then Exit;
  CloseHandle(Thread);
  Result := True;
end;

function GetProcAddressEx(Process: longword; lpModuleName, lpProcName: PChar): pointer;
type
  TGetProcAddrExInfo = record
    pExitThread: pointer;
    pGetProcAddress: pointer;
    pGetModuleHandle: pointer;
    lpModuleName: pointer;
    lpProcName: pointer;
  end;
var
  GetProcAddrExInfo: TGetProcAddrExInfo;
  ExitCode: longword;
  Thread:   THandle;

  procedure GetProcAddrExThread(lpParameter: pointer); stdcall;
  var
    GetProcAddrExInfo: TGetProcAddrExInfo;
  begin
    GetProcAddrExInfo := TGetProcAddrExInfo(lpParameter^);
    asm
      PUSH    GetProcAddrExInfo.lpModuleName
      CALL    GetProcAddrExInfo.pGetModuleHandle
      PUSH    GetProcAddrExInfo.lpProcName
      PUSH    EAX
      CALL    GetProcAddrExInfo.pGetProcAddress
      PUSH    EAX
      CALL    GetProcAddrExInfo.pExitThread
    end;
  end;

begin
  Result := nil;
  GetProcAddrExInfo.pGetModuleHandle := GetProcAddress(GetModuleHandle('kernel32'), 'GetModuleHandleA');
  GetProcAddrExInfo.pGetProcAddress := GetProcAddress(GetModuleHandle('kernel32'), 'GetProcAddress');
  GetProcAddrExInfo.pExitThread := GetProcAddress(GetModuleHandle('kernel32'), 'ExitThread');
  GetProcAddrExInfo.lpProcName := InjectString(Process, lpProcName);
  GetProcAddrExInfo.lpModuleName := InjectString(Process, lpModuleName);
  Thread := InjectThread(Process, @GetProcAddrExThread, @GetProcAddrExInfo,
    SizeOf(GetProcAddrExInfo), False);
  if Thread <> 0 then
  begin
    WaitForSingleObject(Thread, INFINITE);
    GetExitCodeThread(Thread, ExitCode);
    Result := pointer(ExitCode);
  end;
end;

function MapLibrary(Process: longword; Dest, Src: pointer): TLibInfo;
var
  ImageBase:      pointer;
  ImageBaseDelta: integer;
  ImageNtHeaders: PImageNtHeaders;
  PSections:      ^TSections;
  SectionLoop:    integer;
  SectionBase:    pointer;
  VirtualSectionSize, RawSectionSize: cardinal;
  OldProtect:     cardinal;
  NewLibInfo:     TLibInfo;

  function StrToInt(S: string): integer;
  begin
    Val(S, Result, Result);
  end;

  procedure Add(Strings: TStringArray; Text: string);
  begin
    SetLength(Strings, Length(Strings) + 1);
    Strings[Length(Strings) - 1] := Text;
  end;

  function Find(Strings: array of string; Text: string; var Index: integer): boolean;
  var
    StringLoop: integer;
  begin
    Result := False;
    for StringLoop := 0 to Length(Strings) - 1 do
    begin
      if lstrcmpi(PChar(Strings[StringLoop]), PChar(Text)) = 0 then
      begin
        Index  := StringLoop;
        Result := True;
      end;
    end;
  end;

  function GetSectionProtection(ImageScn: cardinal): cardinal;
  begin
    Result := 0;
    if (ImageScn and IMAGE_SCN_MEM_NOT_CACHED) <> 0 then
    begin
      Result := Result or PAGE_NOCACHE;
    end;
    if (ImageScn and IMAGE_SCN_MEM_EXECUTE) <> 0 then
    begin
      if (ImageScn and IMAGE_SCN_MEM_READ) <> 0 then
      begin
        if (ImageScn and IMAGE_SCN_MEM_WRITE) <> 0 then
        begin
          Result := Result or PAGE_EXECUTE_READWRITE;
        end
        else
        begin
          Result := Result or PAGE_EXECUTE_READ;
        end;
      end
      else if (ImageScn and IMAGE_SCN_MEM_WRITE) <> 0 then
      begin
        Result := Result or PAGE_EXECUTE_WRITECOPY;
      end
      else
      begin
        Result := Result or PAGE_EXECUTE;
      end;
    end
    else if (ImageScn and IMAGE_SCN_MEM_READ) <> 0 then
    begin
      if (ImageScn and IMAGE_SCN_MEM_WRITE) <> 0 then
      begin
        Result := Result or PAGE_READWRITE;
      end
      else
      begin
        Result := Result or PAGE_READONLY;
      end;
    end
    else if (ImageScn and IMAGE_SCN_MEM_WRITE) <> 0 then
    begin
      Result := Result or PAGE_WRITECOPY;
    end
    else
    begin
      Result := Result or PAGE_NOACCESS;
    end;
  end;

  procedure ProcessRelocs(PRelocs: PImageBaseRelocation);
  var
    PReloc:     PImageBaseRelocation;
    RelocsSize: cardinal;
    Reloc:      PWord;
    ModCount:   cardinal;
    RelocLoop:  cardinal;
  begin
    PReloc     := PRelocs;
    RelocsSize := ImageNtHeaders.OptionalHeader.DataDirectory[
      IMAGE_DIRECTORY_ENTRY_BASERELOC].Size;
    while cardinal(PReloc) - cardinal(PRelocs) < RelocsSize do
    begin
      ModCount := (PReloc.SizeOfBlock - Sizeof(PReloc^)) div 2;
      Reloc    := pointer(cardinal(PReloc) + sizeof(PReloc^));
      for RelocLoop := 0 to ModCount - 1 do
      begin
        if Reloc^ and $f000 <> 0 then
          Inc(plongword(cardinal(ImageBase) + PReloc.VirtualAddress + (Reloc^ and $0fff))^,
            ImageBaseDelta);
        Inc(Reloc);
      end;
      PReloc := pointer(Reloc);
    end;
  end;

  procedure ProcessImports(PImports: PImageImportDescriptor);
  var
    PImport:     PImageImportDescriptor;
    Import:      plongword;
    PImportedName: PChar;
    ProcAddress: pointer;
    PLibName:    PChar;
    ImportLoop:  integer;

    function IsImportByOrdinal(ImportDescriptor: longword): boolean;
    begin
      Result := (ImportDescriptor and IMAGE_ORDINAL_FLAG32) <> 0;
    end;

  begin
    PImport := PImports;
    while PImport.Name <> 0 do
    begin
      PLibName := PChar(cardinal(PImport.Name) + cardinal(ImageBase));
      if not Find(NewLibInfo.LibsUsed, PLibName, ImportLoop) then
      begin
        InjectLibrary(Process, string(PLibName));
        Add(NewLibInfo.LibsUsed, PLibName);
      end;
      if PImport.TimeDateStamp = 0 then
      begin
        Import := plongword(pImport.FirstThunk + cardinal(ImageBase));
      end
      else
      begin
        Import := plongword(pImport.OriginalFirstThunk + cardinal(ImageBase));
      end;
      while Import^ <> 0 do
      begin
        if IsImportByOrdinal(Import^) then
        begin
          ProcAddress := GetProcAddressEx(Process, PLibName, PChar(Import^ and $ffff));
        end
        else
        begin
          PImportedName := PChar(Import^ + cardinal(ImageBase) + IMPORTED_NAME_OFFSET);
          ProcAddress   := GetProcAddressEx(Process, PLibName, PImportedName);
        end;
        Ppointer(Import)^ := ProcAddress;
        Inc(Import);
      end;
      Inc(PImport);
    end;
  end;

begin
  ImageNtHeaders := pointer(int64(cardinal(Src)) + PImageDosHeader(Src)._lfanew);
  ImageBase := VirtualAlloc(Dest, ImageNtHeaders.OptionalHeader.SizeOfImage, MEM_RESERVE, PAGE_NOACCESS);
  ImageBaseDelta := cardinal(ImageBase) - ImageNtHeaders.OptionalHeader.ImageBase;
  SectionBase := VirtualAlloc(ImageBase, ImageNtHeaders.OptionalHeader.SizeOfHeaders, MEM_COMMIT, PAGE_READWRITE);
  Move(Src^, SectionBase^, ImageNtHeaders.OptionalHeader.SizeOfHeaders);
  VirtualProtect(SectionBase, ImageNtHeaders.OptionalHeader.SizeOfHeaders, PAGE_READONLY, OldProtect);
  PSections := pointer(PChar(@(ImageNtHeaders.OptionalHeader)) + ImageNtHeaders.FileHeader.SizeOfOptionalHeader);
  for SectionLoop := 0 to ImageNtHeaders.FileHeader.NumberOfSections - 1 do
  begin
    VirtualSectionSize := PSections[SectionLoop].Misc.VirtualSize;
    RawSectionSize     := PSections[SectionLoop].SizeOfRawData;
    if VirtualSectionSize < RawSectionSize then
    begin
      VirtualSectionSize := VirtualSectionSize xor RawSectionSize;
      RawSectionSize     := VirtualSectionSize xor RawSectionSize;
      VirtualSectionSize := VirtualSectionSize xor RawSectionSize;
    end;
    SectionBase := VirtualAlloc(PSections[SectionLoop].VirtualAddress + PChar(ImageBase), VirtualSectionSize, MEM_COMMIT, PAGE_READWRITE);
    FillChar(SectionBase^, VirtualSectionSize, 0);
    Move((PChar(src) + PSections[SectionLoop].pointerToRawData)^, SectionBase^, RawSectionSize);
  end;
  NewLibInfo.DllProc   := TDllEntryProc(ImageNtHeaders.OptionalHeader.AddressOfEntryPoint + cardinal(ImageBase));
  NewLibInfo.DllProcAddress :=  pointer(ImageNtHeaders.OptionalHeader.AddressOfEntryPoint + cardinal(ImageBase));
  NewLibInfo.ImageBase := ImageBase;
  NewLibInfo.ImageSize := ImageNtHeaders.OptionalHeader.SizeOfImage;
  SetLength(NewLibInfo.LibsUsed, 0);
  if ImageNtHeaders.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_BASERELOC].VirtualAddress <> 0 then
    ProcessRelocs(pointer(ImageNtHeaders.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_BASERELOC].VirtualAddress + cardinal(ImageBase)));
  if ImageNtHeaders.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_IMPORT].VirtualAddress <> 0 then
    ProcessImports(pointer(ImageNtHeaders.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_IMPORT].VirtualAddress + cardinal(ImageBase)));
  for SectionLoop := 0 to ImageNtHeaders.FileHeader.NumberOfSections - 1 do
  begin
    VirtualProtect(PSections[SectionLoop].VirtualAddress + PChar(ImageBase),
      PSections[SectionLoop].Misc.VirtualSize, GetSectionProtection(
      PSections[SectionLoop].Characteristics), OldProtect);
  end;
  Result := NewLibInfo;
end;

function InjectPointerLibrary(Process: longword; Src: pointer): boolean;
type
  TDllLoadInfo = record
    Module:     pointer;
    EntryPoint: pointer;
  end;
var
  Lib:     TLibInfo;
  DllLoadInfo: TDllLoadInfo;
  BytesWritten: longword;
  ImageNtHeaders: PImageNtHeaders;
  pModule: pointer;
  Offset:  longword;

  procedure DllEntryPoint(lpParameter: pointer); stdcall;
  var
    LoadInfo: TDllLoadInfo;
  begin
    LoadInfo := TDllLoadInfo(lpParameter^);
    asm
      XOR     EAX, EAX
      PUSH    EAX
      PUSH    DLL_PROCESS_ATTACH
      PUSH    LoadInfo.Module
      CALL    LoadInfo.EntryPoint
    end;
  end;

begin
  Result := False;
  ImageNtHeaders := pointer(int64(cardinal(Src)) + PImageDosHeader(Src)._lfanew);
  Offset := $10000000;
  repeat
    Inc(Offset, $10000);
    pModule := VirtualAlloc(pointer(ImageNtHeaders.OptionalHeader.ImageBase + Offset),
      ImageNtHeaders.OptionalHeader.SizeOfImage, MEM_COMMIT or MEM_RESERVE,
      PAGE_EXECUTE_READWRITE);
    if pModule <> nil then
    begin
      VirtualFree(pModule, 0, MEM_RELEASE);
      pModule := VirtualAllocEx(Process,
        pointer(ImageNtHeaders.OptionalHeader.ImageBase + Offset),
        ImageNtHeaders.OptionalHeader.SizeOfImage, MEM_COMMIT or MEM_RESERVE,
        PAGE_EXECUTE_READWRITE);
    end;
  until ((pModule <> nil) or (Offset > $30000000));
  Lib := MapLibrary(Process, pModule, Src);
  if Lib.ImageBase = nil then
    Exit;
  DllLoadInfo.Module     := Lib.ImageBase;
  DllLoadInfo.EntryPoint := Lib.DllProcAddress;
  WriteProcessMemory(Process, pModule, Lib.ImageBase, Lib.ImageSize, BytesWritten);
  if InjectThread(Process, @DllEntryPoint, @DllLoadInfo, SizeOf(TDllLoadInfo), False) <> 0 then Result := True;
end;

end.
