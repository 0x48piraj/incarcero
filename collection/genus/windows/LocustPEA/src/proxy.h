/**
 * Proxy
 * Copyright ©2008 Loki - All Rights Reserved
 **/

#pragma once

BOOL proxy_relay        ( SOCKET Client, SOCKET Target, char* Buffer, BOOL Tunnel );
void proxy_thread_client( pvoid  Arg                                              );
void proxy_thread_server( pvoid  Arg                                              );