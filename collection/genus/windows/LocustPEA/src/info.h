/**
 * Aegis
 * Copyright ©2008 Loki - All Rights Reserved
 **/

#pragma once

typedef enum {
    WIN_UNKNOWN,
    WIN_98,
    WIN_ME,
    WIN_2K,
    WIN_2K3,
    WIN_XP,
    WIN_VISTA
} ver_t;

typedef struct info_t
{
    char   Country     [4];
    char   ComputerName[MAX_COMPUTERNAME_LENGTH + 1];
    char   UserName    [UNLEN + 1];
    ver_t  Version;
    ulong  Uptime;
    ulong  Ram;
    ulong  MajorVersion;
    ulong  MinorVersion;
    ulong  ServicePack;
    float  ProcSpeed;
    ushort Procs;
    BOOL   IsAdmin;
} info_t;

void info_all          ( info_t* Info );
void info_uptime       ( info_t* Info );
void info_country      ( info_t* Info );
void info_computer_name( info_t* Info );
void info_user_name    ( info_t* Info );
void info_os_version   ( info_t* Info );
void info_ram          ( info_t* Info );
void info_proc_count   ( info_t* Info );
void info_proc_speed   ( info_t* Info );
void info_is_admin     ( info_t* Info );