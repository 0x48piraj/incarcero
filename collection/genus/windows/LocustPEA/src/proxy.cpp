/**
 * Proxy
 * Copyright ©2008 Loki - All Rights Reserved
 **/

#include <winsock2.h>
#include <windows.h>
#include <process.h>
#include <stdlib.h>
#include "global.h"
#include "proxy.h"
#include "sock.h"
#include "socks4.h"
#include "socks5.h"
#include "http.h"

/**
 * @name                      proxy_relay
 * @param           Client    Client socket
 * @param           Target    Target socket
 * @param           Buffer    Buffer for reads and writes
 * @param           Tunnel    Tunnel connection or not
 * @note                      Relays data between the client and the target
 **/
BOOL proxy_relay( SOCKET Client, SOCKET Target, char* Buffer, BOOL Tunnel )
{
    struct timeval Timeout;
    fd_set         Read;
    int            r = 0;
    for( ;; )
    {
        FD_ZERO( &Read );
        FD_SET( Client, &Read );
        FD_SET( Target, &Read );
        Timeout.tv_sec  = 120;
        Timeout.tv_usec = 0;
        if( select(0, &Read, NULL, NULL, &Timeout) <= 0 )
            return FALSE;
        if( FD_ISSET(Client, &Read) )
        {
            if( !Tunnel )
                return TRUE;
            r = recv( Client, Buffer, sizeof(Buffer), 0 );
            if( r <= 0 )
            {
                closesocket( Target );    
                return FALSE;
            }
            send( Target, Buffer, r, 0 );
        }
        if( FD_ISSET(Target, &Read) )
        {
            r = recv( Target, Buffer, sizeof(Buffer), 0 );
            if( r <= 0 )
            {
                closesocket( Target );
                Target = INVALID_SOCKET;
                if( Tunnel )
                    return FALSE;
                return TRUE;
            }
            send( Client, Buffer, r, 0 );
        }
    }
}

/**
 * @name                      proxy_thread_client
 * @param              Arg    Client socket
 * @note                      Handles proxy clients
 **/
void proxy_thread_client( pvoid Arg )
{
    SOCKET          Client = *((SOCKET*)Arg),
                    Target = INVALID_SOCKET;
    char           *Buffer;
    BOOL            Tunnel = TRUE;
    int             r      = 0;
    Buffer = (char*)malloc( MAX_BUF );
    if( Buffer != NULL )
    {
        for( ;; )
        {
            if( sock_lrecv(Client, Buffer, 1) < 0 )
                break;
            if( Buffer[0] == 0x04 ) {
                Target = socks4_handle( Client, Buffer );
                if( Target == INVALID_SOCKET )
                    break;
            } else if( Buffer[0] == 0x05 ) {
                Target = socks5_handle( Client, Buffer );
                if( Target == INVALID_SOCKET )
                    break;
            } else {
                Target = http_handle( Client, Target, Buffer, &Tunnel );
                if( Target == INVALID_SOCKET )
                    break;
            }
            if( !proxy_relay(Client, Target, Buffer, Tunnel) )
                break;
        }
        free( Buffer );
    }
    closesocket( Client );
}

/**
 * @name                      proxy_thread_server
 * @param              Arg    Port to listen on
 * @note                      Listens for proxy connections
 **/
void proxy_thread_server( pvoid Arg )
{
    ushort Port = *((ushort*)Arg);
    SOCKADDR_IN Addr;
    SOCKET      Server,
                Client;
    memset( &Addr, 0, sizeof(Addr) );
    Addr.sin_family      = AF_INET;
    Addr.sin_port        = htons( Port );
    Addr.sin_addr.s_addr = INADDR_ANY;
    Server = socket( AF_INET, SOCK_STREAM, IPPROTO_TCP );
    if( bind(Server, (struct sockaddr*)&Addr, sizeof(Addr)) == 0 )
    {
        if( listen(Server, SOMAXCONN) == 0 )
        {
            for( ;; )
            {
                Client = accept( Server, NULL, NULL );
                _beginthread( proxy_thread_client, 0, &Client );
            }
        }
    }
    closesocket( Server );
}
