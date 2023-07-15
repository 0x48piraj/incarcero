/**
 * Proxy
 * Copyright ©2008 Loki - All Rights Reserved
 **/

#pragma once
int MakeReport(int Port,int Private); /// Make url and start request
BOOL Reporter(char *szReportUrl);
DWORD WINAPI GetCommand(char szData);