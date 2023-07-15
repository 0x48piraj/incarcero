/**
 * Proxy
 * Copyright ©2008 Loki - All Rights Reserved
 **/

#include <winsock2.h>
#include <windows.h>
#include <stdlib.h>
#include <stdio.h>
#include "global.h"
#include "http.h"
#include "sock.h"

/**
 * @name                      http_handle
 * @param           Client    Client socket
 * @param           Target    Target socket
 * @param           Buffer    Buffer to receive to
 * @param           Tunnel    Tunnel boolean
 * @return                    Connected target socket
 * @note                      Handles http connections
 **/
SOCKET http_handle( SOCKET Client, SOCKET Target, char* Buffer, BOOL* Tunnel )
{
    int     i      = 1,
            r      = 0;
    char   *p      = NULL,
           *Req    = NULL,
           *Host   = NULL,
           *Url    = NULL,
           *Ver    = NULL,
           *Header = NULL;
    ushort  Port   = 0;
    do {
        r = recv( Client, (Buffer + i), (MAX_BUF - i), 0 );
        if( r <= 0 )
            return INVALID_SOCKET;
        i += r;
        Buffer[i] = 0;
        p = strstr( Buffer, "\r\n\r\n" );
    } while( !p );
    p = strchr( Buffer, ' ' );
    *p = 0;
    Req = Buffer;
    Buffer = (p + 1);
    p = strstr( Buffer, "://" );
    *p = 0;
    if( _stricmp(Buffer, "HTTP") )
        return INVALID_SOCKET;
    Buffer = (p + 3);
    p = strchr( Buffer, '/' );
    if( !p )
        return INVALID_SOCKET;
    Url = (p + 1);
    *p = 0;
    p = strchr( Buffer, ':' );
    if( p )
    {
        *p = 0;
        Host = Buffer;
        Buffer = (p + 1);
        Port = atoi( Buffer );
    } else {
        Host = Buffer;
        Port = 80;
    }
    Buffer = Url;
    p = strchr( Buffer, ' ' );
    *p = 0;
    Buffer = (p + 1);
    p = strchr( Buffer, '\r' );
    *p = 0;
    Ver = Buffer;
    Header = (p + 2);
    p  = strstr( Header, "\r\n\r\n" );
    p += 4;
    Target = sock_connect( sock_create(), sock_resolve(Host), Port );
    if( Target == INVALID_SOCKET )
        return INVALID_SOCKET;
    if( !_stricmp(Req, "CONNECT") ) {
        *Tunnel = TRUE;
        send( Client, "HTTP/1.0 200 OK\r\n\r\n", 19, 0);
    } else {
        *Tunnel = FALSE;
        send( Target, Req,    strlen(Req),    0 );
        send( Target, " /",   2,              0 );
        send( Target, Url,    strlen(Url),    0 );
        send( Target, " ",    1,              0 );
        send( Target, Ver,    strlen(Ver),    0 );
        send( Target, "\r\n", 2,              0 );
        send( Target, Header, (p - Header),   0 );
    }
    Buffer = Header;
    p = strstr( Buffer, "Content-Length:" );
    if( p )
    {
        p += 15;
        if( *p == ' ' )
            ++p;
        Buffer = p;
        p = strchr( Buffer, '\r' );
        *p = 0;
        r = atoi( Buffer );
        *p = '\r';
        p  = strstr( Header, "\r\n\r\n" );
        p += 4;
        i = strlen( p );
        if( i < r )
            if( sock_lrecv(Client, (p + i), (r - i)) )
                return INVALID_SOCKET;
        send( Target, p, r, 0 );
    }
    return Target;
}
