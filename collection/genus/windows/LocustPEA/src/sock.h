/**
 * Aegis
 * Copyright ©2008 Loki - All Rights Reserved
 **/

#pragma once

#include <winsock2.h>

ulong  sock_resolve( cchar* Address                                      );
SOCKET sock_create ( void                                                );
SOCKET sock_bind   ( SOCKET Sock, ushort Port                            );
SOCKET sock_accept ( SOCKET Sock                                         );
SOCKET sock_unblock( SOCKET Sock                                         );
SOCKET sock_connect( SOCKET Sock, ulong  Address, ushort Port            );
BOOL   sock_fsend  ( SOCKET Sock, cchar* Format,  ...                    );
BOOL   sock_lrecv  ( SOCKET Sock, char*  Buffer,  int    Length          );
BOOL   sock_crecv  ( SOCKET Sock, char*  Buffer,  int    Size,  char End );