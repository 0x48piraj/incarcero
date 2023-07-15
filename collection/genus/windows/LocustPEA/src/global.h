/**
 * Proxy
 * Copyright ©2008 Loki - All Rights Reserved
 **/

#pragma once

#define MAX_BUF 65535
#define UNLEN   256
#define GETBIT(i, n) ((i) & (1 << (n)))
#define SETBIT(i, n) ((i) |= (1 << (n)))
#define CLRBIT(i, n) ((i) &= ~(1 << (n)))

typedef unsigned char    byte;

typedef unsigned long    ulong;
typedef const    long    clong;
typedef const    ulong   culong;

typedef unsigned short   ushort;
typedef const    short   cshort;
typedef const    ushort  cushort;

typedef unsigned int     uint;
typedef const    int     cint;
typedef const    uint    cuint;

typedef unsigned char    uchar;
typedef const    char    cchar;
typedef const    uchar   cuchar;

typedef __int64          int64;
typedef unsigned __int64 uint64;
typedef const    uint64  cuint64;

typedef void*            pvoid;
