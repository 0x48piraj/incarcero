// A BMP truecolor to JPEG encoder
// Copyright 1999 Cristi Cuturicu
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "jtypes.h"
#include "jglobals.h"
#include "jtables.h"


void write_APP0info()
//Nothing to overwrite for APP0info
{
 writeword(APP0info.marker);
 writeword(APP0info.length);
 writebyte('J');writebyte('F');writebyte('I');writebyte('F');writebyte(0);
 writebyte(APP0info.versionhi);writebyte(APP0info.versionlo);
 writebyte(APP0info.xyunits);
 writeword(APP0info.xdensity);writeword(APP0info.ydensity);
 writebyte(APP0info.thumbnwidth);writebyte(APP0info.thumbnheight);
}

void write_SOF0info()
// We should overwrite width and height
{
 writeword(SOF0info.marker);
 writeword(SOF0info.length);
 writebyte(SOF0info.precision);
 writeword(SOF0info.height);writeword(SOF0info.width);
 writebyte(SOF0info.nrofcomponents);
 writebyte(SOF0info.IdY);writebyte(SOF0info.HVY);writebyte(SOF0info.QTY);
 writebyte(SOF0info.IdCb);writebyte(SOF0info.HVCb);writebyte(SOF0info.QTCb);
 writebyte(SOF0info.IdCr);writebyte(SOF0info.HVCr);writebyte(SOF0info.QTCr);
}

void write_DQTinfo()
{
 BYTE i;
 writeword(DQTinfo.marker);
 writeword(DQTinfo.length);
 writebyte(DQTinfo.QTYinfo);for (i=0;i<64;i++) writebyte(DQTinfo.Ytable[i]);
 writebyte(DQTinfo.QTCbinfo);for (i=0;i<64;i++) writebyte(DQTinfo.Cbtable[i]);
}

void set_quant_table(BYTE *basic_table,BYTE scale_factor,BYTE *newtable)
// Set quantization table and zigzag reorder it
{
 BYTE i;
 long temp;
 for (i = 0; i < 64; i++) {
      temp = ((long) basic_table[i] * scale_factor + 50L) / 100L;
	/* limit the values to the valid range */
    if (temp <= 0L) temp = 1L;
    if (temp > 255L) temp = 255L; /* limit to baseline range if requested */
    newtable[zigzag[i]] = (WORD) temp;
			  }
}

void set_DQTinfo()
{
 BYTE scalefactor=50;// scalefactor controls the visual quality of the image
			 // the smaller is, the better image we'll get, and the smaller
			 // compression we'll achieve
 DQTinfo.marker=0xFFDB;
 DQTinfo.length=132;
 DQTinfo.QTYinfo=0;
 DQTinfo.QTCbinfo=1;
 set_quant_table(std_luminance_qt,scalefactor,DQTinfo.Ytable);
 set_quant_table(std_chrominance_qt,scalefactor,DQTinfo.Cbtable);
}

void write_DHTinfo()
{
 BYTE i;
 writeword(DHTinfo.marker);
 writeword(DHTinfo.length);
 writebyte(DHTinfo.HTYDCinfo);
 for (i=0;i<16;i++)  writebyte(DHTinfo.YDC_nrcodes[i]);
 for (i=0;i<=11;i++) writebyte(DHTinfo.YDC_values[i]);
 writebyte(DHTinfo.HTYACinfo);
 for (i=0;i<16;i++)  writebyte(DHTinfo.YAC_nrcodes[i]);
 for (i=0;i<=161;i++) writebyte(DHTinfo.YAC_values[i]);
 writebyte(DHTinfo.HTCbDCinfo);
 for (i=0;i<16;i++)  writebyte(DHTinfo.CbDC_nrcodes[i]);
 for (i=0;i<=11;i++)  writebyte(DHTinfo.CbDC_values[i]);
 writebyte(DHTinfo.HTCbACinfo);
 for (i=0;i<16;i++)  writebyte(DHTinfo.CbAC_nrcodes[i]);
 for (i=0;i<=161;i++) writebyte(DHTinfo.CbAC_values[i]);
}

void set_DHTinfo()
{
 BYTE i;
 DHTinfo.marker=0xFFC4;
 DHTinfo.length=0x01A2;
 DHTinfo.HTYDCinfo=0;
 for (i=0;i<16;i++)  DHTinfo.YDC_nrcodes[i]=std_dc_luminance_nrcodes[i+1];
 for (i=0;i<=11;i++)  DHTinfo.YDC_values[i]=std_dc_luminance_values[i];
 DHTinfo.HTYACinfo=0x10;
 for (i=0;i<16;i++)  DHTinfo.YAC_nrcodes[i]=std_ac_luminance_nrcodes[i+1];
 for (i=0;i<=161;i++) DHTinfo.YAC_values[i]=std_ac_luminance_values[i];
 DHTinfo.HTCbDCinfo=1;
 for (i=0;i<16;i++)  DHTinfo.CbDC_nrcodes[i]=std_dc_chrominance_nrcodes[i+1];
 for (i=0;i<=11;i++)  DHTinfo.CbDC_values[i]=std_dc_chrominance_values[i];
 DHTinfo.HTCbACinfo=0x11;
 for (i=0;i<16;i++)  DHTinfo.CbAC_nrcodes[i]=std_ac_chrominance_nrcodes[i+1];
 for (i=0;i<=161;i++) DHTinfo.CbAC_values[i]=std_ac_chrominance_values[i];
}

void write_SOSinfo()
//Nothing to overwrite for SOSinfo
{
 writeword(SOSinfo.marker);
 writeword(SOSinfo.length);
 writebyte(SOSinfo.nrofcomponents);
 writebyte(SOSinfo.IdY);writebyte(SOSinfo.HTY);
 writebyte(SOSinfo.IdCb);writebyte(SOSinfo.HTCb);
 writebyte(SOSinfo.IdCr);writebyte(SOSinfo.HTCr);
 writebyte(SOSinfo.Ss);writebyte(SOSinfo.Se);writebyte(SOSinfo.Bf);
}

void write_comment(BYTE *comment)
{
 WORD i,length;
 writeword(0xFFFE); //The COM marker
 length=strlen((const char *)comment);
 writeword(length+2);
 for (i=0;i<length;i++) writebyte(comment[i]);
}

void writebits(bitstring bs)
// A portable version; it should be done in assembler
{
 WORD value;
 SBYTE posval;//bit position in the bitstring we read, should be<=15 and >=0
 value=bs.value;
 posval=bs.length-1;
 while (posval>=0)
  {
   if (value & mask[posval]) bytenew|=mask[bytepos];
   posval--;bytepos--;
   if (bytepos<0) { if (bytenew==0xFF) {writebyte(0xFF);writebyte(0);}
		     else {writebyte(bytenew);}
		    bytepos=7;bytenew=0;
		  }
  }
}

void compute_Huffman_table(BYTE *nrcodes,BYTE *std_table,bitstring *HT)
{
 BYTE k,j;
 BYTE pos_in_table;
 WORD codevalue;
 codevalue=0; pos_in_table=0;
 for (k=1;k<=16;k++)
   {
     for (j=1;j<=nrcodes[k];j++) {HT[std_table[pos_in_table]].value=codevalue;
				  HT[std_table[pos_in_table]].length=k;
				  pos_in_table++;
				  codevalue++;
				 }
     codevalue*=2;
   }
}
void init_Huffman_tables()
{
 compute_Huffman_table(std_dc_luminance_nrcodes,std_dc_luminance_values,YDC_HT);
 compute_Huffman_table(std_dc_chrominance_nrcodes,std_dc_chrominance_values,CbDC_HT);
 compute_Huffman_table(std_ac_luminance_nrcodes,std_ac_luminance_values,YAC_HT);
 compute_Huffman_table(std_ac_chrominance_nrcodes,std_ac_chrominance_values,CbAC_HT);
}

void exitmessage(char *error_message)
{
 printf("%s\n",error_message);exit(EXIT_FAILURE);
}

void set_numbers_category_and_bitcode()
{
 SDWORD nr;
 SDWORD nrlower,nrupper;
 BYTE cat,value;

 category_alloc=(BYTE *)malloc(65535*sizeof(BYTE));
 if (category_alloc==NULL) exitmessage("Not enough memory.");
 category=category_alloc+32767; //allow negative subscripts
 bitcode_alloc=(bitstring *)malloc(65535*sizeof(bitstring));
 if (bitcode_alloc==NULL) exitmessage("Not enough memory.");
 bitcode=bitcode_alloc+32767;
 nrlower=1;nrupper=2;
 for (cat=1;cat<=15;cat++) {
				 //Positive numbers
				 for (nr=nrlower;nr<nrupper;nr++)
				  { category[nr]=cat;
				bitcode[nr].length=cat;
				bitcode[nr].value=(WORD)nr;
				  }
				 //Negative numbers
				 for (nr=-(nrupper-1);nr<=-nrlower;nr++)
				  { category[nr]=cat;
				bitcode[nr].length=cat;
				bitcode[nr].value=(WORD)(nrupper-1+nr);
				  }
				 nrlower<<=1;
				 nrupper<<=1;
			   }
}

void precalculate_YCbCr_tables()
{
 WORD R,G,B;
 for (R=0;R<=255;R++) {YRtab[R]=(SDWORD)(65536*0.299+0.5)*R;
			   CbRtab[R]=(SDWORD)(65536*-0.16874+0.5)*R;
			   CrRtab[R]=(SDWORD)(32768)*R;
			  }
 for (G=0;G<=255;G++) {YGtab[G]=(SDWORD)(65536*0.587+0.5)*G;
			   CbGtab[G]=(SDWORD)(65536*-0.33126+0.5)*G;
			   CrGtab[G]=(SDWORD)(65536*-0.41869+0.5)*G;
			  }
 for (B=0;B<=255;B++) {YBtab[B]=(SDWORD)(65536*0.114+0.5)*B;
			   CbBtab[B]=(SDWORD)(32768)*B;
			   CrBtab[B]=(SDWORD)(65536*-0.08131+0.5)*B;
			  }
}

// Using a bit modified form of the FDCT routine from IJG's C source:
// Forward DCT routine idea taken from Independent JPEG Group's C source for
// JPEG encoders/decoders

/* For float AA&N IDCT method, divisors are equal to quantization
   coefficients scaled by scalefactor[row]*scalefactor[col], where
   scalefactor[0] = 1
   scalefactor[k] = cos(k*PI/16) * sqrt(2)    for k=1..7
   We apply a further scale factor of 8.
   What's actually stored is 1/divisor so that the inner loop can
   use a multiplication rather than a division. */
void prepare_quant_tables()
{
 double aanscalefactor[8] = {1.0, 1.387039845, 1.306562965, 1.175875602,
			   1.0, 0.785694958, 0.541196100, 0.275899379};
 BYTE row, col;
 BYTE i = 0;
 for (row = 0; row < 8; row++)
 {
   for (col = 0; col < 8; col++)
     {
       fdtbl_Y[i] = (float) (1.0 / ((double) DQTinfo.Ytable[zigzag[i]] *
			  aanscalefactor[row] * aanscalefactor[col] * 8.0));
       fdtbl_Cb[i] = (float) (1.0 / ((double) DQTinfo.Cbtable[zigzag[i]] *
			  aanscalefactor[row] * aanscalefactor[col] * 8.0));

	   i++;
     }
 }
}

void fdct_and_quantization(SBYTE *data,float *fdtbl,SWORD *outdata)
{
  float tmp0, tmp1, tmp2, tmp3, tmp4, tmp5, tmp6, tmp7;
  float tmp10, tmp11, tmp12, tmp13;
  float z1, z2, z3, z4, z5, z11, z13;
  float *dataptr;
  float datafloat[64];
  float temp;
  SBYTE ctr;
  BYTE i;
  for (i=0;i<64;i++) datafloat[i]=data[i];

  /* Pass 1: process rows. */
  dataptr=datafloat;
  for (ctr = 7; ctr >= 0; ctr--) {
	tmp0 = dataptr[0] + dataptr[7];
    tmp7 = dataptr[0] - dataptr[7];
    tmp1 = dataptr[1] + dataptr[6];
    tmp6 = dataptr[1] - dataptr[6];
    tmp2 = dataptr[2] + dataptr[5];
    tmp5 = dataptr[2] - dataptr[5];
    tmp3 = dataptr[3] + dataptr[4];
    tmp4 = dataptr[3] - dataptr[4];

	/* Even part */

    tmp10 = tmp0 + tmp3;	/* phase 2 */
    tmp13 = tmp0 - tmp3;
    tmp11 = tmp1 + tmp2;
    tmp12 = tmp1 - tmp2;

    dataptr[0] = tmp10 + tmp11; /* phase 3 */
    dataptr[4] = tmp10 - tmp11;

    z1 = (tmp12 + tmp13) * ((float) 0.707106781); /* c4 */
	dataptr[2] = tmp13 + z1;	/* phase 5 */
    dataptr[6] = tmp13 - z1;

    /* Odd part */

    tmp10 = tmp4 + tmp5;	/* phase 2 */
    tmp11 = tmp5 + tmp6;
    tmp12 = tmp6 + tmp7;

	/* The rotator is modified from fig 4-8 to avoid extra negations. */
    z5 = (tmp10 - tmp12) * ((float) 0.382683433); /* c6 */
    z2 = ((float) 0.541196100) * tmp10 + z5; /* c2-c6 */
    z4 = ((float) 1.306562965) * tmp12 + z5; /* c2+c6 */
    z3 = tmp11 * ((float) 0.707106781); /* c4 */

    z11 = tmp7 + z3;		/* phase 5 */
    z13 = tmp7 - z3;

    dataptr[5] = z13 + z2;	/* phase 6 */
    dataptr[3] = z13 - z2;
	dataptr[1] = z11 + z4;
    dataptr[7] = z11 - z4;

    dataptr += 8;		/* advance pointer to next row */
  }

  /* Pass 2: process columns. */

  dataptr = datafloat;
  for (ctr = 7; ctr >= 0; ctr--) {
    tmp0 = dataptr[0] + dataptr[56];
    tmp7 = dataptr[0] - dataptr[56];
    tmp1 = dataptr[8] + dataptr[48];
    tmp6 = dataptr[8] - dataptr[48];
    tmp2 = dataptr[16] + dataptr[40];
    tmp5 = dataptr[16] - dataptr[40];
    tmp3 = dataptr[24] + dataptr[32];
    tmp4 = dataptr[24] - dataptr[32];

    /* Even part */

    tmp10 = tmp0 + tmp3;	/* phase 2 */
    tmp13 = tmp0 - tmp3;
    tmp11 = tmp1 + tmp2;
    tmp12 = tmp1 - tmp2;

    dataptr[0] = tmp10 + tmp11; /* phase 3 */
    dataptr[32] = tmp10 - tmp11;

	z1 = (tmp12 + tmp13) * ((float) 0.707106781); /* c4 */
    dataptr[16] = tmp13 + z1; /* phase 5 */
    dataptr[48] = tmp13 - z1;

    /* Odd part */

    tmp10 = tmp4 + tmp5;	/* phase 2 */
    tmp11 = tmp5 + tmp6;
    tmp12 = tmp6 + tmp7;

    /* The rotator is modified from fig 4-8 to avoid extra negations. */
	z5 = (tmp10 - tmp12) * ((float) 0.382683433); /* c6 */
    z2 = ((float) 0.541196100) * tmp10 + z5; /* c2-c6 */
    z4 = ((float) 1.306562965) * tmp12 + z5; /* c2+c6 */
    z3 = tmp11 * ((float) 0.707106781); /* c4 */

    z11 = tmp7 + z3;		/* phase 5 */
    z13 = tmp7 - z3;

    dataptr[40] = z13 + z2; /* phase 6 */
	dataptr[24] = z13 - z2;
    dataptr[8] = z11 + z4;
    dataptr[56] = z11 - z4;

    dataptr++;			/* advance pointer to next column */
  }

// Quantize/descale the coefficients, and store into output array
 for (i = 0; i < 64; i++) {
 /* Apply the quantization and scaling factor */
			   temp = datafloat[i] * fdtbl[i];
/* Round to nearest integer.
   Since C does not specify the direction of rounding for negative
   quotients, we have to force the dividend positive for portability.
   The maximum coefficient size is +-16K (for 12-bit data), so this
   code should work for either 16-bit or 32-bit ints.
*/
	   outdata[i] = (SWORD) ((SWORD)(temp + 16384.5) - 16384);
			  }
}

void process_DU(SBYTE *ComponentDU,float *fdtbl,SWORD *DC,
		bitstring *HTDC,bitstring *HTAC)
{
 bitstring EOB=HTAC[0x00];
 bitstring M16zeroes=HTAC[0xF0];
 BYTE i;
 BYTE startpos;
 BYTE end0pos;
 BYTE nrzeroes;
 BYTE nrmarker;
 SWORD Diff;

 fdct_and_quantization(ComponentDU,fdtbl,DU_DCT);
 //zigzag reorder
 for (i=0;i<=63;i++) DU[zigzag[i]]=DU_DCT[i];
 Diff=DU[0]-*DC;
 *DC=DU[0];
 //Encode DC
 if (Diff==0) writebits(HTDC[0]); //Diff might be 0
  else {writebits(HTDC[category[Diff]]);
	writebits(bitcode[Diff]);
       }
 //Encode ACs
 for (end0pos=63;(end0pos>0)&&(DU[end0pos]==0);end0pos--) ;
 //end0pos = first element in reverse order !=0
 if (end0pos==0) {writebits(EOB);return;}

 i=1;
 while (i<=end0pos)
  {
   startpos=i;
   for (; (DU[i]==0)&&(i<=end0pos);i++) ;
   nrzeroes=i-startpos;
   if (nrzeroes>=16) {
      for (nrmarker=1;nrmarker<=nrzeroes/16;nrmarker++) writebits(M16zeroes);
      nrzeroes=nrzeroes%16;
		     }
   writebits(HTAC[nrzeroes*16+category[DU[i]]]);writebits(bitcode[DU[i]]);
   i++;
  }
 if (end0pos!=63) writebits(EOB);
}

void load_data_units_from_RGB_buffer(WORD xpos,WORD ypos)
{
 BYTE x,y;
 BYTE pos=0;
 DWORD location;
 BYTE R,G,B;
 location=ypos*Ximage+xpos;
 for (y=0;y<8;y++)
 {
  for (x=0;x<8;x++)
   {
    R=RGB_buffer[location].R;G=RGB_buffer[location].G;B=RGB_buffer[location].B;
    YDU[pos]=Y(R,G,B);
    CbDU[pos]=Cb(R,G,B);
    CrDU[pos]=Cr(R,G,B);
    location++;pos++;
   }
  location+=Ximage-8;
 }
}

void main_encoder()
{
 SWORD DCY=0,DCCb=0,DCCr=0; //DC coefficients used for differential encoding
 WORD xpos,ypos;
 for (ypos=0;ypos<Yimage;ypos+=8)
  for (xpos=0;xpos<Ximage;xpos+=8)
   {
    load_data_units_from_RGB_buffer(xpos,ypos);
    process_DU(YDU,fdtbl_Y,&DCY,YDC_HT,YAC_HT);
    process_DU(CbDU,fdtbl_Cb,&DCCb,CbDC_HT,CbAC_HT);
    process_DU(CrDU,fdtbl_Cb,&DCCr,CbDC_HT,CbAC_HT);
   }
}

void load_bitmap(char *bitmap_name, WORD *Ximage_original, WORD *Yimage_original)
{
 WORD Xdiv8,Ydiv8;
 BYTE nr_fillingbytes;//The number of the filling bytes in the BMP file
     // (the dimension in bytes of a BMP line on the disk is divisible by 4)
 colorRGB lastcolor;
 WORD column;
 BYTE TMPBUF[256];
 WORD nrline_up,nrline_dn,nrline;
 WORD dimline;
 colorRGB *tmpline;
 FILE *fp_bitmap=fopen(bitmap_name,"rb");
 if (fp_bitmap==NULL) exitmessage("Cannot open bitmap file.File not found ?");
 if (fread(TMPBUF,1,54,fp_bitmap)!=54)
	 exitmessage("Need a truecolor BMP to encode.");
 if ((TMPBUF[0]!='B')||(TMPBUF[1]!='M')||(TMPBUF[28]!=24))
	 exitmessage("Need a truecolor BMP to encode.");
 Ximage=(WORD)TMPBUF[19]*256+TMPBUF[18];Yimage=(WORD)TMPBUF[23]*256+TMPBUF[22];
 *Ximage_original=Ximage;*Yimage_original=Yimage; //Keep the old dimensions
						// of the image
 if (Ximage%8!=0) Xdiv8=(Ximage/8)*8+8;
	else Xdiv8=Ximage;
 if (Yimage%8!=0) Ydiv8=(Yimage/8)*8+8;
	else Ydiv8=Yimage;
 // The image we encode shall be filled with the last line and the last column
 // from the original bitmap, until Ximage and Yimage are divisible by 8
 // Load BMP image from disk and complete X
 RGB_buffer=(colorRGB *)(malloc(3*Xdiv8*Ydiv8));
 if (RGB_buffer==NULL) exitmessage("Not enough memory for the bitmap image.");
 if (Ximage%4!=0) nr_fillingbytes=4-(Ximage%4);
  else nr_fillingbytes=0;
 for (nrline=0;nrline<Yimage;nrline++)
  {
   fread(RGB_buffer+nrline*Xdiv8,1,Ximage*3,fp_bitmap);
   fread(TMPBUF,1,nr_fillingbytes,fp_bitmap);
   memcpy(&lastcolor,RGB_buffer+nrline*Xdiv8+Ximage-1,3);
   for (column=Ximage;column<Xdiv8;column++)
	{memcpy(RGB_buffer+nrline*Xdiv8+column,&lastcolor,3);}
  }
 Ximage=Xdiv8;
 dimline=Ximage*3;tmpline=(colorRGB *)malloc(dimline);
 if (tmpline==NULL) exitmessage("Not enough memory.");
 //Reorder in memory the inversed bitmap
 for (nrline_up=Yimage-1,nrline_dn=0;nrline_up>nrline_dn;nrline_up--,nrline_dn++)
  {
   memcpy(tmpline,RGB_buffer+nrline_up*Ximage, dimline);
   memcpy(RGB_buffer+nrline_up*Ximage,RGB_buffer+nrline_dn*Ximage,dimline);
   memcpy(RGB_buffer+nrline_dn*Ximage,tmpline,dimline);
  }
 // Y completion:
 memcpy(tmpline,RGB_buffer+(Yimage-1)*Ximage,dimline);
 for (nrline=Yimage;nrline<Ydiv8;nrline++)
  {memcpy(RGB_buffer+nrline*Ximage,tmpline,dimline);}
 Yimage=Ydiv8;
 free(tmpline);fclose(fp_bitmap);
}

void init_all()
{
 set_DQTinfo();
 set_DHTinfo();
 init_Huffman_tables();
 set_numbers_category_and_bitcode();
 precalculate_YCbCr_tables();
 prepare_quant_tables();
}

void main(int argc,char *argv[])
{
 char BMP_filename[64];
 char JPG_filename[64];
 WORD Ximage_original,Yimage_original; //the original image dimensions,
	   // before we made them divisible by 8
 BYTE len_filename;
 bitstring fillbits; //filling bitstring for the bit alignment of the EOI marker
 if (argc>1) { strcpy(BMP_filename,argv[1]);
		   if (argc>2) strcpy(JPG_filename,argv[2]);
		else { strcpy(JPG_filename,BMP_filename);
			   len_filename=strlen(BMP_filename);
			   strcpy(JPG_filename+(len_filename-3),"jpg");
			 }
		 }
  else exitmessage("Syntax: enc fis.bmp [fis.jpg]");
 load_bitmap(BMP_filename, &Ximage_original, &Yimage_original);
 fp_jpeg_stream=fopen(JPG_filename,"wb");
 init_all();
 SOF0info.width=Ximage_original;
 SOF0info.height=Yimage_original;
 writeword(0xFFD8); //SOI
 write_APP0info();
 // write_comment("Cris made this JPEG with his own encoder");
 write_DQTinfo();
 write_SOF0info();
 write_DHTinfo();
 write_SOSinfo();

 bytenew=0;bytepos=7;
 main_encoder();
 //Do the bit alignment of the EOI marker
 if (bytepos>=0) {
		   fillbits.length=bytepos+1;
		   fillbits.value=(1<<(bytepos+1))-1;
		   writebits(fillbits);
		 }
 writeword(0xFFD9); //EOI
 free(RGB_buffer); free(category_alloc);free(bitcode_alloc);
 fclose(fp_jpeg_stream);
}
