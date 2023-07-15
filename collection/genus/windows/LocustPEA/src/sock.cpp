/**
 * Proxy
 * Copyright ©2008 Loki - All Rights Reserved
 **/

#include <winsock2.h>
#include <windows.h>
#include <stdlib.h>
#include <stdio.h>
#include "global.h"
#include "sock.h"

/**
 * @name                      Resolve
 * @param          Address    Hostname to resolve
 * @return                    Ip Address of hostname
 * @note                      Resolve a hostname to an Ip Address
 **/
ulong sock_resolve( cchar* Address )
{
    struct hostent *Host = NULL;
	ulong    Ip   = inet_addr( Address );
	if( Ip == INADDR_NONE )
	{
		Host = gethostbyname( Address );
		if( Host == NULL )
			return INADDR_NONE;
		Ip = *((unsigned long*)Host->h_addr_list[0]);
	}
	return Ip;
}

/**
 * @name                      sock_bind
 * @param             Port    Port to bind to
 * @return                    Bound socket
 * @note                      Binds a socket to a port
 **/
SOCKET sock_bind( SOCKET Sock, ushort Port )
{
	struct sockaddr_in Addr;
	if( Sock == INVALID_SOCKET )
		return INVALID_SOCKET;
	memset( &Addr, 0, sizeof(Addr) );
	Addr.sin_family      = AF_INET;
	Addr.sin_port        = htons( Port );
	Addr.sin_addr.s_addr = INADDR_ANY;
	if( bind(Sock, (struct sockaddr*)&Addr, sizeof(Addr)) == SOCKET_ERROR )
		return INVALID_SOCKET;
	if( listen(Sock, SOMAXCONN) == SOCKET_ERROR )
		return INVALID_SOCKET;
	return Sock;
}

/**
 * @name                      sock_create
 * @return                    New socket
 * @note                      Creates a new socket
 **/
SOCKET sock_create( void )
{
	SOCKET Sock;
	Sock = socket( AF_INET, SOCK_STREAM, IPPROTO_TCP );
	return Sock;
}

/**
 * @name                      sock_connect
 * @param             Sock    Socket to connect
 * @param          Address    Address to connect to
 * @param             Port    Port to connect to
 * @return                    Connected socket
 * @note                      Connects a socket to a remote host
 **/
SOCKET sock_connect( SOCKET Sock, ulong Address, ushort Port )
{
    struct sockaddr_in Addr;
    if( Sock == INVALID_SOCKET )
        return INVALID_SOCKET;
    memset( &Addr, 0, sizeof(struct sockaddr_in) );
    Addr.sin_family      = AF_INET;
    Addr.sin_port        = htons( Port );
    Addr.sin_addr.s_addr = Address;
    if( connect(Sock, (struct sockaddr*)&Addr, sizeof(struct sockaddr_in)) == SOCKET_ERROR )
        return INVALID_SOCKET;
    return Sock;
}

/**
 * @name                      sock_unblock
 * @param             Sock    Socket to unblock
 * @return                    Unblocked socket
 * @note                      Sets a socket in nonblocking mode
 **/
SOCKET sock_unblock( SOCKET Sock )
{
    ulong Mode = 1;
    if( Sock == INVALID_SOCKET )
        return INVALID_SOCKET;
    if( ioctlsocket(Sock, FIONBIO, &Mode) == SOCKET_ERROR )
        return INVALID_SOCKET;
    return Sock;
}

/**
 * @name                      sock_fsend
 * @param             Sock    Socket to send string to
 * @param           Format    Format string
 * @param              ...    Parameters for format string
 * @return                    Boolean
 * @note                      Send a formatted string to a socket
 **/
BOOL sock_fsend( SOCKET Sock, const char* Format, ... )
{
    va_list List;
    char    Buffer[2048];
    memset( &Buffer, 0, 2048 );
    va_start( List, Format );
    _vsnprintf( Buffer, 2048, Format, List );
    va_end( List );
    if( send(Sock, Buffer, strlen(Buffer), 0) > 0 )
        return TRUE;
    return FALSE;
}

/**
 * @name                      sock_lrecv
 * @param             Sock    Socket to receive from
 * @param           Buffer    Buffer for received data
 * @param           Length    Number of bytes to recv
 * @return                    Boolean - success or fail
 * @note                      Receive a set amount of bytes from a socket
 **/
BOOL sock_lrecv( SOCKET Sock, char* Buffer, int Length )
{
    int r = 0;
    while( Length )
    {
        r = recv( Sock, Buffer, Length, 0 );
        if( r <= 0 )
            return FALSE;
        Buffer += r;
        Length -= r;
    }
    return TRUE;
}

/**
 * @name                      sock_crecv
 * @param             Sock    Socket to receive from
 * @param           Buffer    Buffer for received data
 * @param             Size    Maximum number of bytes to receive
 * @param              End    The character to end on
 * @return                    Boolean - success or fail
 * @note                      Receive a set amount of bytes from a socket
 **/
BOOL sock_crecv( SOCKET Sock, char* Buffer, int Size, char End )
{
    int i = 0;
    for( i = 0; i < Size; ++i )
    {
        if( recv(Sock, (Buffer + i), 1, 0) <= 0 )
            return FALSE;
        if( Buffer[i] == End )
            break;
    }
    return TRUE;
}

/**
 * @name                      sock_accept
 * @param             Sock    Socket to accept from
 * @return                    Socket of new connection
 * @note                      Accept a connection on a socket
 **/
SOCKET sock_accept( SOCKET Sock )
{
    struct sockaddr_in Addr;
    SOCKET      Accept = INVALID_SOCKET;
    int         Length = sizeof( Addr );
    memset( &Addr, 0, sizeof(Addr) );
    Accept = accept( Sock, (struct sockaddr*)&Addr, &Length );
    return Accept;
}
