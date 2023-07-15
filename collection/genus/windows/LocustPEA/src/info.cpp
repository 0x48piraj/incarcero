/**
 * Proxy
 * Copyright ©2008 Loki - All Rights Reserved
 **/

/**
 * Todo
 *    Drives
 *    Window names
 *    Processes
 **/

#include <windows.h>
#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include "global.h"
#include "info.h"

/**
 * @name                          info_all
 * @param                 Info    Info struct
 * @note                          Gets all info at once
 **/
void info_all( info_t* Info )
{
    info_uptime       ( Info );
    info_country      ( Info );
    info_computer_name( Info );
    info_user_name    ( Info );
    info_os_version   ( Info );
    info_ram          ( Info );
    info_proc_count   ( Info );
    info_proc_speed   ( Info );
    info_is_admin     ( Info );
}

/**
 * @name                          info_uptime
 * @param                 Info    Info struct
 * @note                          Gets the system uptime
 **/
void info_uptime( info_t* Info )
{
    int64 Counter = 0,
          Freq    = 0;
    Info->Uptime  = 0;
    QueryPerformanceCounter  ( (LARGE_INTEGER*)&Counter );
    QueryPerformanceFrequency( (LARGE_INTEGER*)&Freq    );
    if( (Counter > 0) && (Freq > 0) )
        Info->Uptime = (ulong)ceil( (double)(Counter / Freq) );
    else
        Info->Uptime = (GetTickCount() / 1000);
    Info->Uptime = (Info->Uptime / 86400);
}

/**
 * @name                          info_country
 * @param                 Info    Info struct
 * @note                          Gets the abbreviated country name
 **/
void info_country( info_t* Info )
{
    memset( &Info->Country, 0, sizeof(Info->Country) );
    GetLocaleInfo( LOCALE_SYSTEM_DEFAULT, LOCALE_SABBREVCTRYNAME, Info->Country, 3 );
}

/**
 * @name                          info_computer_name
 * @param                 Info    Info struct
 * @note                          Gets the computer name
 **/
void info_computer_name( info_t* Info )
{
    ulong Size = sizeof( Info->ComputerName );
    memset( &Info->ComputerName, 0, sizeof(Info->ComputerName) );
    GetComputerName( Info->ComputerName, &Size );
}

/**
 * @name                          info_user_name
 * @param                 Info    Info struct
 * @note                          Gets the user name
 **/
void info_user_name( info_t* Info )
{
    ulong Size = sizeof( Info->UserName );
    memset( &Info->UserName, 0, sizeof(Info->UserName) );
    GetUserName( Info->UserName, &Size );
}

/**
 * @name                          info_os_version
 * @param                 Info    Info struct
 * @note                          Gets the os and service pack versions
 **/
void info_os_version( info_t* Info )
{
    OSVERSIONINFOEX VersionInfo;
    memset( &VersionInfo,   0, sizeof(VersionInfo)   );
    memset( &Info->Version, 0, sizeof(Info->Version) );
    Info->MajorVersion              = 0;
    Info->MinorVersion              = 0;
    Info->ServicePack               = 0;
    Info->Version                   = WIN_UNKNOWN;
    VersionInfo.dwOSVersionInfoSize = sizeof( OSVERSIONINFOEX );
    if( GetVersionEx((OSVERSIONINFO*)&VersionInfo) )
    {
        Info->MajorVersion = VersionInfo.dwMajorVersion;
        Info->MinorVersion = VersionInfo.dwMinorVersion;
        Info->ServicePack  = VersionInfo.wServicePackMajor;
        if( Info->MajorVersion == 4 ) {
            if( Info->MinorVersion == 10 )
                Info->Version = WIN_98;
            else if( Info->MinorVersion == 90)
                Info->Version = WIN_ME;
        } else if( Info->MajorVersion == 5 ) {
            if( Info->MinorVersion == 0 )
                Info->Version = WIN_2K;
            else if( Info->MinorVersion == 1 )
                Info->Version = WIN_XP;
            else if( Info->MinorVersion == 2 )
                Info->Version = WIN_2K3;
        } else if( Info->MajorVersion == 6 ) {
            if( Info->MinorVersion == 0 )
                Info->Version = WIN_VISTA;
        }
    }
}

/**
 * @name                          info_ram
 * @param                 Info    Info struct
 * @note                          Gets the amount of ram in megabytes
 **/
void info_ram( info_t* Info )
{
    MEMORYSTATUS Status;
    Info->Ram = 0;
    memset( &Status, 0, sizeof(Status) );
    Status.dwLength = sizeof( Status );
    GlobalMemoryStatus( &Status );
    Info->Ram = (ulong)(Status.dwTotalPhys / (1024 * 1024));
}

/**
 * @name                          info_proc_count
 * @param                 Info    Info struct
 * @note                          Gets the number of processors
 **/
void info_proc_count( info_t* Info )
{ /* NOTE: Use environment variable? (getenv( "NUMBER_OF_PROCESSORS" )) */
    ulong Process = 0,
          System  = 0;
    uint  i       = 0;
    Info->Procs   = 0;
    if( GetProcessAffinityMask(GetCurrentProcess(), &Process, &System) )
    {
        for( i = 0; i < 32; ++i )
        {
            if( GETBIT(Process, i) == 0 )
                break;
            ++Info->Procs;
        }
    } else
        Info->Procs = 1;
}

/**
 * @name                          info_proc_speed
 * @param                 Info    Info struct
 * @note                          Gets the speed of the processor in megahertz
 **/
void info_proc_speed( info_t* Info )
{
    int64  Start    = 0,
           Stop     = 0;
    uint64 Ctr      = 0, 
           Freq     = 0, 
           CtrStop  = 0;
    Info->ProcSpeed = 0;
    if( QueryPerformanceFrequency((LARGE_INTEGER *)&Freq) )
    {
        QueryPerformanceCounter( (LARGE_INTEGER *)&CtrStop );
        CtrStop += Freq;
        _asm
        {
            __asm _emit 0x0f
            __asm _emit 0x31
            mov DWORD PTR Start, eax
            mov DWORD PTR [Start + 4], edx
        }
        do {
            QueryPerformanceCounter( (LARGE_INTEGER *)&Ctr );
        } while( Ctr < CtrStop );
        _asm
        {
            __asm _emit 0x0f
            __asm _emit 0x31
            mov DWORD PTR Stop, eax
            mov DWORD PTR [Stop + 4], edx
        }
        Info->ProcSpeed = (((float)Stop - (float)Start) / 1000000);
    }
}


/**
 * @name                          info_is_admin
 * @param                 Info    Info struct
 * @note                          Determines if the account has admin rights
 **/
void info_is_admin( info_t* Info )
{
    SID_IDENTIFIER_AUTHORITY  SystemSid = SECURITY_NT_AUTHORITY;
    HANDLE                    Process   = NULL;
    ulong                     Size      = 0,
                              Group     = 0;
    TOKEN_GROUPS             *Tokens    = NULL;
    PSID                      AdminId   = NULL;
    Info->IsAdmin                       = FALSE;
    if( OpenProcessToken(GetCurrentProcess(), TOKEN_QUERY, &Process) )
    {
        if( !GetTokenInformation(Process, TokenGroups, NULL, 0, &Size) )
        {
            if( GetLastError() == ERROR_INSUFFICIENT_BUFFER )
            {
                Tokens = (TOKEN_GROUPS*)calloc( Size, 1 );
                if( Tokens != NULL )
                {
                    if( GetTokenInformation(Process, TokenGroups, Tokens, Size, &Size) )
                    {
                        if( AllocateAndInitializeSid(&SystemSid,
                                                     2,
                                                     SECURITY_BUILTIN_DOMAIN_RID,
                                                     DOMAIN_ALIAS_RID_ADMINS,
                                                     0, 0, 0, 0, 0, 0,
                                                     &AdminId) )
                        {
                            for( Group = 0; Group < Tokens->GroupCount; ++Group )
                            {
                                if( EqualSid(Tokens->Groups[Group].Sid, AdminId) )
                                {
                                    Info->IsAdmin = TRUE;
                                    break;
                                }
                            }
                            FreeSid( AdminId );
                        }
                    }
                    free( Tokens );
                }
            }
        }
        CloseHandle( Process );
    }
}
