/**
 * Proxy
 * Copyright ©2008 Loki - All Rights Reserved
 **/

#include <winsock2.h>
#include <windows.h>
#include "global.h"
#include "socks4.h"
#include "sock.h"

/**
 * @name                      socks4_handle
 * @param           Client    Client socket
 * @param           Buffer    Buffer to receive to
 * @return                    Connected target socket
 * @note                      Handles socks4 connections
 **/
SOCKET socks4_handle( SOCKET Client, char* Buffer )
{
    int     i       = 0;
    SOCKET  Target  = INVALID_SOCKET;
    ulong   Ip      = 0;
    ushort  Port    = 0;
    byte    Command = 0;
    char   *Host    = NULL;
    if( sock_lrecv(Client, Buffer, 7) < 0 )
        return INVALID_SOCKET;
    Command  = Buffer[0];
    Port     = *((ushort*)(Buffer + 1));
    Ip       = *((ulong* )(Buffer + 3));
    if( !sock_crecv(Client, Buffer, MAX_BUF, '\0') )
        return INVALID_SOCKET;
    if( !(ntohl(Ip) >> 8) )
    {
        if( !sock_crecv(Client, Buffer, MAX_BUF, '\0') )
            return INVALID_SOCKET;
        Host = Buffer;
    }
    if( Command != 0x01 )
        return INVALID_SOCKET;
    if( Host )
        Ip = sock_resolve( Host );
    Target = sock_connect( sock_create(), Ip, htons(Port) );
    if( Target == INVALID_SOCKET )
        return INVALID_SOCKET;
    Buffer[0]                = 0;
    Buffer[1]                = 90;
    *((ushort*)(Buffer + 2)) = Port;
    *((ulong* )(Buffer + 4)) = Ip;
    send( Client, Buffer, 8, 0 );
    return Target;
}










////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// void socks4_thread_server( pvoid Arg )
// {
//     ushort      Port = *((ushort*)Arg);
//     SOCKADDR_IN Addr;
//     SOCKET      Server,
//                 Client;
//     memset( &Addr, 0, sizeof(Addr) );
//     Addr.sin_family      = AF_INET;
//     Addr.sin_port        = htons( Port );
//     Addr.sin_addr.s_addr = INADDR_ANY;
//     Server = socket( AF_INET, SOCK_STREAM, IPPROTO_TCP );
//     if( bind(Server, (struct sockaddr*)&Addr, sizeof(Addr)) == 0 )
//     {	
//         if( listen(Server, SOMAXCONN) == 0 )
//         {
//             for( ;; )
//             {
//                 Client = accept( Server, NULL, NULL );
//                 _beginthread( socks4_thread_client, 0, &Client );
//             }
//         }
//     }
//     closesocket( Server );
// }
// 
// void socks4_transfer( SOCKET Target, SOCKET Client )
// {
//     int    Length = 0;
//     char   Buffer[1024];
//     fd_set Read;
//     for( ;; )
//     {
//         FD_ZERO( &Read );
//         FD_SET( Client, &Read );
//         FD_SET( Target, &Read );
//         memset( &Buffer, 0, sizeof(Buffer) );
//         select( 0, &Read, NULL, NULL, NULL );
//         if( FD_ISSET(Client, &Read) )
//         {
//             if( (Length = recv(Client, Buffer, sizeof(Buffer), 0)) == -1 )
//                 break;
//             if( send(Target, Buffer, Length, 0) == -1 )
//                 break;
//         }
//         if( FD_ISSET(Target,&Read) )
//         {
//             if( (Length = recv(Target, Buffer, sizeof(Buffer), 0)) == -1)
//                 break;
//             if( send(Client, Buffer, Length, 0) == -1)
//                 break;
//         }
//     }
//     return;
// }
// 
// void socks4_thread_client( pvoid Arg )
// {
//     SOCKET          Client = *((SOCKET*)Arg),
//                     Target;
//     socks4_header_t Header;
//     SOCKADDR_IN     Addr;
//     TIMEVAL         Timeout;
//     fd_set          Read;
//     Timeout.tv_sec  = 5;
//     Timeout.tv_usec = 0;
//     memset( &Addr, 0, sizeof(Addr) );
//     FD_ZERO( &Read );
//     FD_SET( Client, &Read );
//     if( select(0, &Read, NULL, NULL, &Timeout) == 0 )
//     {
//         closesocket( Client );
//         return;
//     }
//     if( recv(Client, (char *)&Header, sizeof(Header), 0) <= 0 )
//     {
//         closesocket( Client );
//         return;
//     }
//     if( (Header.Version != 4) || (Header.Command != SOCKS4_CONNECT) )
//     {
//         closesocket( Client );
//         return;
//     }
//     Addr.sin_family      = AF_INET;
//     Addr.sin_port        = Header.Port;
//     Addr.sin_addr.s_addr = Header.Addr;
//     if( (Target = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP)) == INVALID_SOCKET )
//     {
//         Header.Version = 0;
//         Header.Command = SOCKS4_REJECT;
//         memset( &Header.User, 0, 1024 );
//         send( Client, (char *)&Header, 8, 0 );
//         closesocket( Client );
//         return;
//     }
//     if( connect(Target, (struct sockaddr*)&Addr, sizeof(Addr)) == SOCKET_ERROR )
//     {
//         Header.Version = 0;
//         Header.Command = SOCKS4_REJECT;
//         memset( &Header.User, 0, 1024 );
//         send( Client, (char *)&Header, 8, 0 );
//         closesocket( Client );
//         return;
//     }
//     Header.Version = 0;
//     Header.Command = SOCKS4_GRANT;
//     memset( &Header.User, 0, 1024 );
//     send( Client, (char *)&Header, 8, 0 );
//     socks4_transfer( Target, Client );
//     closesocket( Target );
//     closesocket( Client );
// }