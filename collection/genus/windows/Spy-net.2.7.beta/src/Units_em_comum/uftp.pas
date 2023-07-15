unit uftp;

interface

uses
  windows,
  wininet,
  UnitDiversos,
  UnitServerUtils;

type
  tProgressProc = procedure(afile: string; Done, Total: cardinal; var abort:boolean) of object;

const
  BlockSize = 1024;

type
  tFtpAccess = class(tObject)
  private
    fSession: hINTERNET;
    fConnect: hInternet;
    fOnProgress: tProgressProc;
    fConnected: boolean;
    fSiteName: string;
    fUsername: string;
    fPassword: string;
  public
    constructor create(SiteName,UserName,Password: string; Port: integer);
    destructor Destroy; override;
    function GetDir: string;
    function SetDir(WebDir: string): boolean;
    function GetFile(WebName: string): string;
    function PutFile(Source, RemoteName: string): boolean;
    function FileSize(WebName: string): integer;
    function DeleteFile(WebName: string): boolean;
    property connected: boolean read fConnected;
    property onProgress: tProgressProc read fOnProgress write fOnProgress;
end;

implementation

//####################### tFtpAccess ##############################
constructor tFtpAccess.create(SiteName, UserName, Password: string; Port: integer);
var
  appName: string;
begin
  fSiteName := SiteName;
  fUsername := UserName;
  fPassword := Password;
  appName := extractFileName(paramstr(0));
  fSession := InternetOpen(pchar(appName),
                           INTERNET_OPEN_TYPE_PRECONFIG,
                           nil,
                           nil,
                           0);
  if assigned(fSession) then
  fConnect := InternetConnect(fsession,
                              pchar(fSiteName),
                              Port,
                              pchar(fUserName),
                              pchar(fPassword),
                              INTERNET_SERVICE_FTP,
                              INTERNET_FLAG_PASSIVE,
                              0);
  fConnected := assigned(fSession) and assigned(fConnect);
end { Create };

destructor tFtpAccess.Destroy;
begin
  if fConnected then
  InternetCloseHandle(fConnect);
  if assigned(fSession) then
  InternetCloseHandle(fSession);
  inherited;
end { Destroy };

function tFtpAccess.GetDir: string;
var
  buffer: array[0..MAX_PATH] of char;
  bfsize: cardinal;
begin
  result := '';
  if fConnected then
  begin
    fillchar(buffer,MAX_PATH,0);
    bfSize := MAX_PATH;
    if ftpGetCurrentDirectory(fConnect,buffer,bfSize) then
    result := buffer;
  end;
end { GetDir };

function tFtpAccess.SetDir(WebDir: string): boolean;
begin
  result := fConnected and
  FtpSetCurrentDirectory(fConnect,pchar(WebDir));
end { SetDir };

function tFtpAccess.DeleteFile(WebName: string): boolean;
begin
  result := fConnected and
  FtpDeleteFile(fConnect,pchar(Webname));
end { DeleteFile };

//======================================================
// FileSize - Returns -1 if file doesn't exist
// max file size here is maxint
//------------------------------------------------------
function tFtpAccess.FileSize(WebName: string): integer;
var
  f: hINTERNET;
begin
  result := -1;
  if fConnected then
  begin
    f := ftpOpenfile(fConnect,
                     Pchar(WebName),
                     GENERIC_READ,
                     FTP_TRANSFER_TYPE_BINARY,
                     0);
    if assigned(f) then
    try
      result := ftpGetFileSize(f,nil);
      finally
      InternetClosehandle(f);
    end;
  end;
end { FileSize };

function tFtpAccess.GetFile(WebName: string): string;
var
  f: HInternet;
  size: integer;
  ndx: integer;
  amtRead: cardinal;
  abort: boolean;
  avail: cardinal;
  ok: boolean;
  toRead: cardinal;
begin
  abort := false;
  result := '';
  if fConnected then
  begin
    f := ftpOpenfile(fConnect,
                     pchar(WebName),
                     GENERIC_READ,
                     FTP_TRANSFER_TYPE_BINARY,
                     0);
    if assigned(f) then
    try
      size := ftpGetFileSize(f,nil);
      setlength(result,size);
      fillchar(result[1],size,0);
      ndx := 1;
      avail := size;
      repeat
        toRead := Avail;
        if toread>Blocksize then toRead := BlockSize;
        amtRead := 0;
        if InternetReadFile(f,@result[ndx],toRead,AmtRead) then
        begin
          dec(avail,AmtRead);
          inc(ndx,AmtRead);
          if assigned(fOnProgress) then
          fOnProgress(WebName,ndx,size,abort);
        end;
      until (avail = 0) or (ndx>= size);
      finally
      InternetCloseHandle(f);
    end;
  end;
end { GetFile };

function tFtpAccess.PutFile(Source, RemoteName: string): boolean;
var
  f: HInternet;
  size: integer;
  ndx: integer;
  ToWrite: cardinal;
  Written: cardinal;
  abort: boolean;
begin
  abort := false;
  result := false;
  if fConnected and (length(Source)>0) then
  begin
    f := ftpOpenfile(fConnect,
                     pchar(RemoteName),
                     GENERIC_WRITE,
                     FTP_TRANSFER_TYPE_BINARY,
                     0);
    if assigned(f) then
    try
      size := length(source);
      ndx := 1;
      repeat
        toWrite := Size - ndx + 1;
        if toWrite>Blocksize then
        toWrite := blocksize;
        written := 0;
        if InternetWriteFile(f,@source[ndx],toWrite,Written) then
        begin
          inc(ndx,Written);
          if assigned(fOnProgress) then
          fOnProgress(RemoteName,ndx,size,abort);
        end;
      until (Written < Blocksize) or (ndx>size);
      result := true;
      finally
      InternetCloseHandle(f);
    end;
  end;
end { PutFile };

end.