/**
 * Aegis
 * Copyright ©2008 Loki - All Rights Reserved
 **/

#pragma once

#ifdef __cplusplus
extern "C" {
#endif // __cplusplus
WINBASEAPI DWORD NTAPI ZwUnmapViewOfSection    ( IN HANDLE ProcessHandle,
                                                 IN PVOID  BaseAddress         );
WINBASEAPI LONG  NTAPI NtQuerySystemInformation( DWORD     SysInfClass,
                                                 PVOID     SysInf,
                                                 ULONG     SysInfLength,
                                                 PULONG    ReturnLength        );
WINBASEAPI LONG  NTAPI ZwSystemDebugControl    ( DWORD     ControlCode,
                                                 PVOID     InputBuffer,
                                                 ULONG     InputBufferLength,
                                                 PVOID     OutputBuffer,
                                                 ULONG     OutputBufferLength,
                                                 PULONG    ReturnLength        );
#ifdef __cplusplus
}
#endif // __cplusplus

struct mem_t
{
    pvoid KernelAddr;
    pvoid UserAddr;
    ulong Length;
};

typedef struct sys_info_t
{
    ulong  dwNumberOfModules;
    ulong  Reserved[2];
    pvoid  Base;
    ulong  Size;
    ulong  Flags;
    ushort Index;
    ushort Unknown;
    ushort LoadCount;
    ushort ModuleNameOffset;
    char   ImageName[256];
} sys_info_t;

ulong kernel_read     ( ulong Addr             );
void  kernel_write    ( ulong Addr, ulong Data );
void  kernel_get_priv ( void                   );
void  kernel_proc_hide( ulong ProcessId        );