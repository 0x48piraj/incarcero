static BYTE bytenew=0; // The byte that will be written in the JPG file
static SBYTE bytepos=7; //bit position in the byte we write (bytenew)
			//should be<=7 and >=0
static WORD mask[16]={1,2,4,8,16,32,64,128,256,512,1024,2048,4096,8192,16384,32768};

// The Huffman tables we'll use:
static bitstring YDC_HT[12];
static bitstring CbDC_HT[12];
static bitstring YAC_HT[256];
static bitstring CbAC_HT[256];

static BYTE *category_alloc;
static BYTE *category; //Here we'll keep the category of the numbers in range: -32767..32767
static bitstring *bitcode_alloc;
static bitstring *bitcode; // their bitcoded representation

//Precalculated tables for a faster YCbCr->RGB transformation
// We use a SDWORD table because we'll scale values by 2^16 and work with integers
static SDWORD YRtab[256],YGtab[256],YBtab[256];
static SDWORD CbRtab[256],CbGtab[256],CbBtab[256];
static SDWORD CrRtab[256],CrGtab[256],CrBtab[256];
static float fdtbl_Y[64];
static float fdtbl_Cb[64]; //the same with the fdtbl_Cr[64]

colorRGB *RGB_buffer; //image to be encoded
WORD Ximage,Yimage;// image dimensions divisible by 8
static SBYTE YDU[64]; // This is the Data Unit of Y after YCbCr->RGB transformation
static SBYTE CbDU[64];
static SBYTE CrDU[64];
static SWORD DU_DCT[64]; // Current DU (after DCT and quantization) which we'll zigzag
static SWORD DU[64]; //zigzag reordered DU which will be Huffman coded
