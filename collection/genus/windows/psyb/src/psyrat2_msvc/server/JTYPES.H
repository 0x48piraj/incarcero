#define BYTE unsigned char
#define SBYTE signed char
#define SWORD signed short int
#define WORD unsigned short int
#define DWORD unsigned long int
#define SDWORD signed long int

static struct APP0infotype {
		WORD marker;// = 0xFFE0
		WORD length; // = 16 for usual JPEG, no thumbnail
		BYTE JFIFsignature[5]; // = "JFIF",'\0'
		BYTE versionhi; // 1
		BYTE versionlo; // 1
		BYTE xyunits;   // 0 = no units, normal density
		WORD xdensity;  // 1
		WORD ydensity;  // 1
		BYTE thumbnwidth; // 0
		BYTE thumbnheight; // 0
} APP0info={0xFFE0,16,'J','F','I','F',0,1,1,0,1,1,0,0};

static struct  SOF0infotype {
		WORD marker; // = 0xFFC0
		WORD length; // = 17 for a truecolor YCbCr JPG
		BYTE precision ;// Should be 8: 8 bits/sample
		WORD height ;
		WORD width;
		BYTE nrofcomponents;//Should be 3: We encode a truecolor JPG
		BYTE IdY;  // = 1
		BYTE HVY; // sampling factors for Y (bit 0-3 vert., 4-7 hor.)
		BYTE QTY;  // Quantization Table number for Y = 0
		BYTE IdCb; // = 2
		BYTE HVCb;
		BYTE QTCb; // 1
		BYTE IdCr; // = 3
		BYTE HVCr;
		BYTE QTCr; // Normally equal to QTCb = 1
} SOF0info = { 0xFFC0,17,8,0,0,3,1,0x11,0,2,0x11,1,3,0x11,1};
// Default sampling factors are 1,1 for every image component: No downsampling

static struct DQTinfotype {
		 WORD marker;  // = 0xFFDB
		 WORD length;  // = 132
		 BYTE QTYinfo;// = 0:  bit 0..3: number of QT = 0 (table for Y)
				  //       bit 4..7: precision of QT, 0 = 8 bit
		 BYTE Ytable[64];
		 BYTE QTCbinfo; // = 1 (quantization table for Cb,Cr}
		 BYTE Cbtable[64];
		   } DQTinfo;
// Ytable from DQTinfo should be equal to a scaled and zizag reordered version
// of the table which can be found in "tables.h": std_luminance_qt
// Cbtable , similar = std_chrominance_qt
// We'll init them in the program using set_DQTinfo function

static struct DHTinfotype {
		 WORD marker;  // = 0xFFC4
		 WORD length;  //0x01A2
		 BYTE HTYDCinfo; // bit 0..3: number of HT (0..3), for Y =0
			  //bit 4  :type of HT, 0 = DC table,1 = AC table
				//bit 5..7: not used, must be 0
		 BYTE YDC_nrcodes[16]; //at index i = nr of codes with length i
		 BYTE YDC_values[12];
		 BYTE HTYACinfo; // = 0x10
		 BYTE YAC_nrcodes[16];
		 BYTE YAC_values[162];//we'll use the standard Huffman tables
		 BYTE HTCbDCinfo; // = 1
		 BYTE CbDC_nrcodes[16];
		 BYTE CbDC_values[12];
		 BYTE HTCbACinfo; //  = 0x11
		 BYTE CbAC_nrcodes[16];
		 BYTE CbAC_values[162];
} DHTinfo;

static struct SOSinfotype {
		 WORD marker;  // = 0xFFDA
		 WORD length; // = 12
		 BYTE nrofcomponents; // Should be 3: truecolor JPG
		 BYTE IdY; //1
		 BYTE HTY; //0 // bits 0..3: AC table (0..3)
				   // bits 4..7: DC table (0..3)
		 BYTE IdCb; //2
		 BYTE HTCb; //0x11
		 BYTE IdCr; //3
		 BYTE HTCr; //0x11
		 BYTE Ss,Se,Bf; // not interesting, they should be 0,63,0
} SOSinfo={0xFFDA,12,3,1,0,2,0x11,3,0x11,0,0x3F,0};

typedef struct { BYTE B,G,R; } colorRGB;
typedef struct { BYTE length;
		 WORD value;} bitstring;

#define  Y(R,G,B) ((BYTE)( (YRtab[(R)]+YGtab[(G)]+YBtab[(B)])>>16 ) - 128)
#define Cb(R,G,B) ((BYTE)( (CbRtab[(R)]+CbGtab[(G)]+CbBtab[(B)])>>16 ) )
#define Cr(R,G,B) ((BYTE)( (CrRtab[(R)]+CrGtab[(G)]+CrBtab[(B)])>>16 ) )

#define writebyte(b) fputc((b),fp_jpeg_stream)
#define writeword(w) writebyte((w)/256);writebyte((w)%256);
