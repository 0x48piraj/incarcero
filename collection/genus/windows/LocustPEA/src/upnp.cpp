/**
 * Proxy
 * Copyright ©2008 Loki - All Rights Reserved
 **/

#include <winsock2.h>
#include <windows.h>
#include <stdlib.h>
#include <stdio.h>
#include "global.h"
#include "upnp.h"

/**
 * @name                      upnp_discover
 * @param           Device    Struct to hold upnp device data
 * @param            Tries    Times to try discovery
 * @return                    Boolean - success or fail
 * @note                      Attempts to discover upnp devices
 **/
BOOL upnp_discover( upnp_device_t* Device, ushort Tries )
{
    SOCKET              Sock;
    struct sockaddr_in  Addr;
    char                Buffer[1450],
                       *Begin   = NULL,
                       *End     = NULL;
    int                 i       = 0,
                        t       = 0,
                        Ret     = 0,
                        TrueLen = sizeof(bool);
    bool                True    = true;
    ulong               One     = 1,
                        Zero    = 0;
    Sock = socket( AF_INET, SOCK_DGRAM, IPPROTO_UDP );
    memset( &Addr, 0, sizeof(Addr) );
    Addr.sin_family      = AF_INET;
    Addr.sin_port        = htons( upnp_broadcast_port );
    Addr.sin_addr.s_addr = inet_addr( upnp_broadcast_ip );
    Ret = setsockopt( Sock, SOL_SOCKET, SO_BROADCAST, (char*)&True, TrueLen );
    for( i = 0; i < Tries; ++i )
    {
        memset( &Buffer, 0, sizeof(Buffer) );
        strcpy( Buffer, upnp_search_request );
        sendto( Sock, Buffer, strlen(Buffer), 0, (struct sockaddr*)&Addr, sizeof(Addr) );
        for( t = 0; t < 10; ++t )
        {
            ioctlsocket( Sock, FIONBIO, &One );
            memset( &Buffer, 0, sizeof(Buffer) );
            Ret = recvfrom( Sock, Buffer, (sizeof(Buffer) - 1), 0, NULL, NULL );
            if( Ret == SOCKET_ERROR)
            {
                Sleep( 1000 );
                continue;
            } else {
                Begin = strstr( Buffer, "http://" );
                if( Begin != NULL )
                {
                    End = strchr( Begin, '\r' );
                    if( End != NULL )
                    {
                        *End = '\0';
                        strncpy( Device->Location, Begin, (sizeof(Device->Location) - 1) );
                        upnp_parse_url( Device );
                        closesocket( Sock );
                        return TRUE;
                    }
                }
            }
        }
        ioctlsocket( Sock, FIONBIO, &Zero );
    }
    closesocket( Sock );
    return FALSE;
}

/**
 * @name                      upnp_parse_url
 * @param           Device    Struct to hold upnp device data
 * @return                    Boolean - success or fail
 * @note                      Parses a upnp device location url into its parts
 **/
BOOL upnp_parse_url( upnp_device_t* Device )
{
    char* Begin = strstr( Device->Location, "http://" );
    if( Begin != NULL )
    {
        Begin += 7;
        char* End = strchr( Begin, ':' );
        if( End != NULL )
        {
            *End = '\0';
            strncpy( Device->Host, Begin, (sizeof(Device->Host) - 1) );
            *End = ':';
            Begin = strchr( End, '/' );
            if( Begin == NULL )
                return FALSE;
            *Begin = '\0';
            End += 1;
            Device->Port = (ushort)atoi( End );
            if( Device->Port == 0 )
                Device->Port = 80;
            *Begin = '/';
            End = Begin;
        } else {
            End = strchr( Begin, '/' );
            if( End == NULL )
                return FALSE;
            *End = '\0';
            strncpy( Device->Host, Begin, (sizeof(Device->Host) - 1) );
            *End = '/';
            Device->Port = 80;
        }
        strncpy( Device->Path, End, (sizeof(Device->Path) - 1) );
        return TRUE;
    }
    return FALSE;
}

/**
 * @name                      upnp_read_desc
 * @param           Device    Struct to hold upnp device data
 * @return                    Boolean - success or fail
 * @note                      Parses a upnp device location url into its parts
 **/
BOOL upnp_read_desc( upnp_device_t* Device )
{
    SOCKET              Sock;
    struct sockaddr_in  Addr;
    char                Buffer [16384],
                        Request[256],
                       *Find  = NULL,
                       *Find2 = NULL,
                       *Find3 = NULL;
    int                 i     = 0;
    Sock = socket( AF_INET, SOCK_STREAM, IPPROTO_TCP );
    memset( &Addr, 0, sizeof(Addr) );
    Addr.sin_family      = AF_INET;
    Addr.sin_port        = htons    ( Device->Port );
    Addr.sin_addr.s_addr = inet_addr( Device->Host );
    if( connect(Sock, (struct sockaddr*)&Addr, sizeof(Addr)) != 0 )
    {
        closesocket( Sock );
        return FALSE;
    }
    memset( &Request, 0, sizeof(Request) );
	_snprintf( Request, sizeof(Request),
               "GET %s HTTP/1.1\r\nHost: %s:%d\r\n\r\n",
               Device->Path, Device->Host, Device->Port );
    if( send(Sock, Request, strlen(Request), 0) <= 0 )
    {
        closesocket( Sock );
        return FALSE;
    }
    memset( &Buffer, 0, sizeof(Buffer) );
    while( recv(Sock, (char *)&Buffer[i], 1, 0) > 0 )
        ++i;
    closesocket( Sock );
    Find = strstr( Buffer, upnp_service_wanip );
    if( Find == NULL )
    {
        Find = strstr( Buffer, upnp_service_ppp );
        if( Find == NULL )
            return FALSE;
        strncpy( Device->Service, upnp_service_ppp,   (sizeof(Device->Service) - 1) );
    } else
        strncpy( Device->Service, upnp_service_wanip, (sizeof(Device->Service) - 1) );
    Find2 = strstr( Find, "<controlURL>" );
    if( Find2 == NULL )
        return FALSE;
    Find2 += 12;
    Find3 = strchr( Find2, '<' );
    if( Find3 == NULL )
        return FALSE;
    *Find3 = '\0';
    strncpy( Device->Control, Find2, (sizeof(Device->Control) - 1) );
    return TRUE;
}

/**
 * @name                      upnp_add_port
 * @param           Device    Struct to hold upnp device data
 * @param         Protocol    Protocol for port foward
 * @param               Ip    Internal ip to forward to
 * @param            IPort    Internal port
 * @param            EPort    External port
 * @param             Desc    Description of port
 * @return                    Boolean - success or fail
 * @note                      Forward an external port to an internal ip
 **/
BOOL upnp_add_port( upnp_device_t* Device, char* Protocol, char* Ip, ushort IPort, ushort EPort, char* Desc )
{
    SOCKET              Sock;
    struct sockaddr_in  Addr;
    char                Xml [1024],
                        Soap[1024],
                        Post[2048];
    int                 i     = 0;
    Sock = socket( AF_INET, SOCK_STREAM, IPPROTO_TCP );
    memset( &Addr, 0, sizeof(Addr) );
    Addr.sin_family      = AF_INET;
    Addr.sin_port        = htons    ( Device->Port );
    Addr.sin_addr.s_addr = inet_addr( Device->Host );
    if( connect(Sock, (struct sockaddr*)&Addr, sizeof(Addr)) != 0 )
    {
        closesocket( Sock );
        return FALSE;
    }
    memset( &Xml,  0, sizeof(Xml)  );
    memset( &Soap, 0, sizeof(Soap) );
    memset( &Post, 0, sizeof(Post) );
    _snprintf( Xml,  sizeof(Xml),  upnp_add_port_mapping,
               EPort, Protocol, IPort, Ip, Desc );
    _snprintf( Soap, sizeof(Soap), upnp_soap_action,
               Device->Service, Xml );
    _snprintf( Post, sizeof(Post), upnp_http_post,
               Device->Control, Device->Host, Device->Port, strlen(Soap), Device->Service, Soap );
    if( send(Sock, Post, strlen(Post), 0) <= 0 )
    {
        closesocket( Sock );
        return FALSE;
    }
    memset( &Post, 0, sizeof(Post) );
    while( recv(Sock, (char *)&Post[i], 1, 0) > 0 )
        ++i;
    closesocket( Sock );
    if( strstr(Post, "200 OK") != NULL )
        return TRUE;
    return FALSE;
}
