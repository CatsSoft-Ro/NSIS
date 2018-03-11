
// ****************************************************************************
//
// WINIMAGE.CPP : Generic classes for raster images (MSWindows specialization)
//
//  Content: Member definitions for:
//  - class C_Image             : Storage class for single images
//  - class C_ImageSet          : Storage class for sets of images
//  - class C_AnimationWindow   : Window Class to display animations
//
//  (Includes routines to Load and Save BMP files and to load GIF files into
// these classes).
//
//  --------------------------------------------------------------------------
//
// Copyright © 2000, Juan Soulie <jsoulie@cplusplus.com>
//
// Permission to use, copy, modify, distribute and sell this software or any
// part thereof and/or its documentation for any purpose is granted without fee
// provided that the above copyright notice and this permission notice appear
// in all copies.
//
// This software is provided "as is" without express or implied warranty of
// any kind. The author shall have no liability with respect to the
// infringement of copyrights or patents that any modification to the content
// of this file or this file itself may incur.
//
// Code was partly cutted and reworked by Takhir Bedertdinov:
// transparency, draw on any target window, memdc image, stretch, dispose method.
// Still crashes on some images (like runrabbit.gif)
//
// ****************************************************************************

#include <windows.h>
#include <tchar.h>
#include <fstream.h>
#include "winimage.h"

// Error processing macro (NO-OP by default):
#define ERRORMSG(PARAM) {/*MessageBox(NULL, PARAM, "", 0);*/}

// ****************************************************************************
// * C_Image Member definitions                                               *
// ****************************************************************************

// Init: Allocates space for raster and palette in GDI-compatible structures.
void C_Image::Init(int iWidth, int iHeight, int iBPP) {
	if (Raster) {delete[]Raster;Raster=0;}
	if (pbmi) {delete[]pbmi;pbmi=0;}
	// Standard members setup
	Transparent=-1;
	BytesPerRow = Width = iWidth; Height=iHeight; BPP=iBPP;
	// Animation Extra members setup:
	xPos=xPos=Delay=0;

	if (BPP==24)
		{BytesPerRow*=3; pbmi=(BITMAPINFO*)new char [sizeof(BITMAPINFO)];}
	else
	{
		pbmi=(BITMAPINFO*)
			new char[sizeof(BITMAPINFOHEADER)+(1<<BPP)*sizeof(COLOR)];
		Palette=(COLOR*)((char*)pbmi+sizeof(BITMAPINFOHEADER));
	}

	BytesPerRow += (ALIGN-Width%ALIGN) % ALIGN;	// Align BytesPerRow
	
	Raster = new char [BytesPerRow*Height];

	pbmi->bmiHeader.biSize=sizeof (BITMAPINFOHEADER);
	pbmi->bmiHeader.biWidth=Width;
	pbmi->bmiHeader.biHeight=-Height;			// negative means up-to-bottom 
	pbmi->bmiHeader.biPlanes=1;
	pbmi->bmiHeader.biBitCount=(BPP<8?8:BPP);	// Our raster is byte-aligned
	pbmi->bmiHeader.biCompression=BI_RGB;
	pbmi->bmiHeader.biSizeImage=0;
	pbmi->bmiHeader.biXPelsPerMeter=11811;
	pbmi->bmiHeader.biYPelsPerMeter=11811;
	pbmi->bmiHeader.biClrUsed=0;
	pbmi->bmiHeader.biClrImportant=0;
}

// GDIPaint: Paint the raster image onto a DC
int C_Image::GDIPaint (HDC hdc, int x, int y)
{
	return SetDIBitsToDevice (hdc, x, y, Width, Height, 0, 0,
								0, Height, (LPVOID)Raster, pbmi, 0);
}

// operator=: copies an object's content to another
C_Image& C_Image::operator = (C_Image& rhs)
	{
		Init(rhs.Width,rhs.Height,rhs.BPP);	// respects virtualization
		memcpy (Raster,rhs.Raster,BytesPerRow*Height);
		memcpy ((char*)Palette,(char*)rhs.Palette,(1<<BPP)*sizeof(*Palette));
		return *this;
	}



// ****************************************************************************
// * C_ImageSet Member definitions                                            *
// ****************************************************************************

// AddImage: Adds an image object to the back of the img vector.
void C_ImageSet::AddImage (C_Image* newimage)
{
	C_Image ** pTempImg = new C_Image* [nImages+1];
	for (int n=0;n<nImages;n++) pTempImg[n]=img[n];	// (pointer copy)
	delete[] img;
	img=pTempImg;
	img[n]=newimage;
	nImages++;
}


// ****************************************************************************
// * C_AnimationWindow Member definitions                                     *
// ****************************************************************************

// fnThread: Thread function in charge of looping animation frames.
DWORD WINAPI C_AnimationWindow::fnThread (LPVOID lpParameter)
{
	C_AnimationWindow* window;
	C_ImageSet* anim;

	window=(C_AnimationWindow*)lpParameter;
	anim=window->pAnimation;
	window->bAnimationPlaying=TRUE;
	C_Image* prvImg = NULL;
	while (	anim->nLoops ? window->CurrentLoop < anim->nLoops : true )
	{
         HRGN prvRgn = NULL;
			C_Image* curImg = anim->img[window->CurrentImage];
// after previous show: disposal methods. 04h - todo
         if(prvImg != NULL && prvImg->Dispose == 2)
         {
            prvRgn = CreateRectRgn(prvImg->xPos, prvImg->yPos,
               prvImg->xPos + prvImg->Width, prvImg->yPos + prvImg->Height);
            FillRgn(window->memdc, prvRgn, window->bgBrush);
            SetRectRgn(prvRgn, window->paintRect.left + prvImg->xPos,
               window->paintRect.top + prvImg->yPos,
               window->paintRect.left + prvImg->xPos + prvImg->Width,
               window->paintRect.top + prvImg->yPos + prvImg->Height);
// invalidate later with new image for less flicking
         }
         SetDIBitsToDevice (window->memdc, curImg->xPos, curImg->yPos,
            curImg->Width, curImg->Height,
            0, 0,	0, curImg->Height, (LPVOID)(curImg->Raster), curImg->pbmi, 0);
         HRGN s = CreateRectRgn(window->paintRect.left + curImg->xPos,
            window->paintRect.top + curImg->yPos,
            window->paintRect.left + curImg->xPos + curImg->Width,
            window->paintRect.top + curImg->yPos + curImg->Height);
// region to invalidate, this and previous if disposal 02h
         if(prvRgn != NULL)
            CombineRgn(s, prvRgn, s, RGN_OR);
//         if(IsWindowVisible(window->m_hWnd)) UpdateWindow(window->m_hWnd);
         InvalidateRgn(window->m_hWnd, s, FALSE);
         DeleteObject(s);
         if(prvRgn != NULL)
            DeleteObject(prvRgn);
			Sleep (curImg->Delay>50?curImg->Delay:100);

         prvImg = curImg;
			if (++window->CurrentImage == anim->nImages)
			{
            window->CurrentImage = 0;
   		   ++window->CurrentLoop;
   		} 
	}
	window->Rewind();
	window->bAnimationPlaying=FALSE;
	return 0;
}


// Play: Start/Resume animation loop
void C_AnimationWindow::Play (HWND hwnd, RECT r, C_ImageSet * is, COLORREF ulCol)
{
   BITMAPINFOHEADER bmih={40,is->FrameWidth,is->FrameHeight,1,24,BI_RGB,0,0,0,0,0};
   COLORREF trCol, mgCol;
   int trInd = -1, disp = 0;

   Stop();
	Rewind();
   if(is->nImages < 1)
      return;
   if(is->nImages == 1)
   {
      is->img[0]->Delay = 10000;
      is->img[0]->Dispose = 1;
   }
   m_hWnd = hwnd;
	pAnimation= is;
// underlaying color
   if(ulCol == CLR_INVALID)
   {
      HDC hdc = GetDC(hwnd);
      ulCol =  GetPixel(hdc, r.left, r.top);
      ReleaseDC(hwnd, hdc);
// if window is hidden and GetPixel() fails.
// GetDCBrushColor() compatibility is limited and also may give NULL
      if(ulCol  == CLR_INVALID)
         ulCol = GetSysColor(COLOR_BTNFACE);
   }
// colorref -> color (for images with trInd == bgInd)
   trCol = ((ulCol & 0xFF) << 16) | (ulCol & 0xFF00) | ((ulCol & 0xFF0000) >> 16);
// color for images with trInd != bgInd
   mgCol = ((pAnimation->bgCol & 0xFF) << 16) | (pAnimation->bgCol & 0xFF00) | ((pAnimation->bgCol & 0xFF0000) >> 16);
   for(int i=0; i<pAnimation->nImages;i++)
   {
      if(pAnimation->img[i]->Transparent >= 0)
      {
         trInd = pAnimation->img[i]->Transparent;
         disp = pAnimation->img[i]->Dispose;
         memcpy(pAnimation->img[i]->Palette + trInd,
            trInd == pAnimation->bgInd || disp == 2 ?
            &trCol : &mgCol, sizeof(COLOR));
      }
   }
// based on the LAST (?) transp. index :(
   bgBrush = CreateSolidBrush(trInd == pAnimation->bgInd || disp == 2 ?
      ulCol : pAnimation->bgCol);
   paintRect = r;
// memDC bitmap
   memdc = CreateCompatibleDC(NULL);
   HDC hdc = GetDC(m_hWnd);
	membmp = CreateDIBitmap(hdc, &bmih, 0, NULL, (LPBITMAPINFO)(&bmih), DIB_RGB_COLORS);
   SelectObject(memdc, (HGDIOBJ)membmp);
   SetRect(&r, 0, 0, pAnimation->FrameWidth, pAnimation->FrameHeight);
   FillRect(memdc, &r, bgBrush);
   ReleaseDC(m_hWnd, hdc);
   hThreadAnim = CreateThread(NULL,0,fnThread,this,0,&dwThreadIdAnim);
}

// Stop: Stop animation loop
void C_AnimationWindow::Stop ()
{
	if (bAnimationPlaying)
	{
		TerminateThread (hThreadAnim,0);
		bAnimationPlaying=FALSE;
      DeleteDC(memdc);
      DeleteObject((HGDIOBJ)membmp);
      DeleteObject((HGDIOBJ)bgBrush);
	}
}

// Rewind: Reset animation loop to its initial values
void C_AnimationWindow::Rewind ()
{
	CurrentLoop=0;
	CurrentImage=0;
}

// Paint: calls the GDIPaint method of the current image in the loop
void C_AnimationWindow::Paint (HDC hdc)
{
	StretchBlt(hdc, paintRect.left, paintRect.top, paintRect.right - paintRect.left, paintRect.bottom - paintRect.top,
      memdc, 0, 0, pAnimation->FrameWidth, pAnimation->FrameHeight, SRCCOPY);
   ValidateRect(m_hWnd, &paintRect);
}



// pre-declaration:
int LZWDecoder (char*, char*, short, int, int, int, const int);

// ****************************************************************************
// * LoadGIF                                                                  *
// *   Load a GIF File into the C_ImageSet object                             *
// *                        (c) Nov 2000, Juan Soulie <jsoulie@cplusplus.com> *
// ****************************************************************************
int C_ImageSet::LoadGIF (TCHAR * szFileName)
{
	int n;
   DWORD nbRead;

	// Global GIF variables:
	int GlobalBPP;						// Bits per Pixel.
	COLOR * GlobalColorMap;				// Global colormap (allocate)

	struct GIFGCEtag {				// GRAPHIC CONTROL EXTENSION
		unsigned char BlockSize;		// Block Size: 4 bytes
		unsigned char PackedFields;		// Packed Fields. Bits detail:
										//    0: Transparent Color Flag
										//    1: User Input Flag
										//  2-4: Disposal Method
		unsigned short Delay;			// Delay Time (1/100 seconds)
		unsigned char Transparent;		// Transparent Color Index
	} gifgce;
	int GraphicExtensionFound = 0;

	// OPEN FILE
   HANDLE giffile = CreateFile(szFileName, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, 0, NULL);
	if (giffile == INVALID_HANDLE_VALUE)
   {ERRORMSG("File not found");return 0;}

	// *1* READ HEADER (SIGNATURE + VERSION)
	char szSignature[6];				// First 6 bytes (GIF87a or GIF89a)
   ReadFile(giffile, szSignature, 6, &nbRead, NULL);
	if ( memcmp(szSignature,"GIF",2) != 0)
		{ ERRORMSG("Not a GIF File"); return 0; }

	// *2* READ LOGICAL SCREEN DESCRIPTOR
	struct GIFLSDtag {
		unsigned short ScreenWidth;		// Logical Screen Width
		unsigned short ScreenHeight;	// Logical Screen Height
		unsigned char PackedFields;		// Packed Fields. Bits detail:
										//  0-2: Size of Global Color Table
										//    3: Sort Flag
										//  4-6: Color Resolution
										//    7: Global Color Table Flag
		unsigned char Background;		// Background Color Index
		unsigned char PixelAspectRatio;	// Pixel Aspect Ratio
	} giflsd;

   ReadFile(giffile, &giflsd,sizeof(giflsd), &nbRead, NULL);

	GlobalBPP = (giflsd.PackedFields & 0x07) + 1;

	// fill some animation data:
	FrameWidth = giflsd.ScreenWidth;
	FrameHeight = giflsd.ScreenHeight;
	nLoops = 0;

	// *3* READ/GENERATE GLOBAL COLOR MAP
	GlobalColorMap = new COLOR [1<<GlobalBPP];
	if (giflsd.PackedFields & 0x80)	// File has global color map?
   {
		for (n=0;n< 1<<GlobalBPP;n++)
		{
         ReadFile(giffile, &(GlobalColorMap[n].r), 1, &nbRead, NULL);
         ReadFile(giffile, &(GlobalColorMap[n].g), 1, &nbRead, NULL);
         ReadFile(giffile, &(GlobalColorMap[n].b), 1, &nbRead, NULL);
		}
      bgInd = giflsd.Background;
      memcpy(&bgCol, &GlobalColorMap[bgInd], sizeof(COLOR));
// color -> colorref
      bgCol = ((bgCol & 0xFF) << 16) | (bgCol & 0xFF00) | ((bgCol & 0xFF0000) >> 16);
   }
	else	// GIF standard says to provide an internal default Palette:
   {
      bgInd = -1; // no global color table, BG color index not valid
		for (n=0;n<256;n++)
			GlobalColorMap[n].r=GlobalColorMap[n].g=GlobalColorMap[n].b=n;
   }

	// *4* NOW WE HAVE 3 POSSIBILITIES:
	//  4a) Get and Extension Block (Blocks with additional information)
	//  4b) Get an Image Separator (Introductor to an image)
	//  4c) Get the trailer Char (End of GIF File)
	do
	{
      int charGot = 0;
      int charSw = 0;
      ReadFile(giffile, &charGot, 1, &nbRead, NULL);

		if (charGot == 0x21)		// *A* EXTENSION BLOCK 
		{
         ReadFile(giffile, &charSw, 1, &nbRead, NULL);
			switch (charSw)
			{

			case 0xF9:			// Graphic Control Extension

            ReadFile(giffile, &gifgce,sizeof(gifgce), &nbRead, NULL);
				GraphicExtensionFound++;
            ReadFile(giffile, &charSw, 1, &nbRead, NULL);
				break;

			case 0xFE:			// Comment Extension: Ignored
			case 0x01:			// PlainText Extension: Ignored
			case 0xFF:			// Application Extension: Ignored
			default:			// Unknown Extension: Ignored
				// read (and ignore) data sub-blocks
            int nBlockLength = 0;
				while (ReadFile(giffile, &nBlockLength, 1, &nbRead, NULL) && nBlockLength > 0)
               SetFilePointer(giffile, nBlockLength, NULL, FILE_CURRENT);
				break;
			}
		}


		else if (charGot == 0x2c) {	// *B* IMAGE (0x2c Image Separator)

			// Create a new Image Object:
			C_Image* NextImage;
			NextImage = new C_Image;

			// Read Image Descriptor
			struct GIFIDtag {	
				unsigned short xPos;			// Image Left Position
				unsigned short yPos;			// Image Top Position
				unsigned short Width;			// Image Width
				unsigned short Height;			// Image Height
				unsigned char PackedFields;		// Packed Fields. Bits detail:
											//  0-2: Size of Local Color Table
											//  3-4: (Reserved)
											//    5: Sort Flag
											//    6: Interlace Flag
											//    7: Local Color Table Flag
			} gifid;

         ReadFile(giffile, &gifid, sizeof(gifid), &nbRead, NULL);

			int LocalColorMap = (gifid.PackedFields & 0x80) >> 7;

			NextImage->Init (gifid.Width, gifid.Height,
				LocalColorMap ? (gifid.PackedFields&7)+1 : GlobalBPP);

			// Fill NextImage Data
			NextImage->xPos = gifid.xPos;
			NextImage->yPos = gifid.yPos;
			if (GraphicExtensionFound)
			{
				NextImage->Transparent = (gifgce.PackedFields & 0x01) ? gifgce.Transparent : -1;
				NextImage->Delay = gifgce.Delay*10;
				NextImage->Dispose = (gifgce.PackedFields&0x1C) >> 2;
			}
		
			if (LocalColorMap)		// Read Color Map (if descriptor says so)
            ReadFile(giffile, NextImage->Palette, sizeof(COLOR)*(1<<NextImage->BPP), &nbRead, NULL);
			else					// Otherwise copy Global
				memcpy (NextImage->Palette, GlobalColorMap,
					sizeof(COLOR)*(1<<NextImage->BPP));

			short firstbyte=0;
         ReadFile(giffile, &firstbyte, 1, &nbRead, NULL);

			// Calculate compressed image block size
				// to fix: this allocates an extra byte per block
			long ImgStart,ImgEnd;				
			ImgEnd = ImgStart = SetFilePointer(giffile, 0, NULL, FILE_CURRENT);
         n = 0;
			while (ReadFile(giffile, &n, 1, &nbRead, NULL) && n > 0)
            SetFilePointer(giffile, ImgEnd+=n+1, NULL, FILE_BEGIN);
			SetFilePointer(giffile, ImgStart, NULL, FILE_BEGIN);

			// Allocate Space for Compressed Image
			char * pCompressedImage = new char [ImgEnd-ImgStart+4];
  
			// Read and store Compressed Image
			char * pTemp = pCompressedImage;
         int nBlockLength = 0;
			while (ReadFile(giffile, &nBlockLength, 1, &nbRead, NULL) && nBlockLength > 0)
			{
				ReadFile(giffile, pTemp, nBlockLength, &nbRead, NULL);
				pTemp+=nBlockLength;
			}

			// Call LZW/GIF decompressor
			n=LZWDecoder(
				(char*) pCompressedImage,
				(char*) NextImage->Raster,
				firstbyte, NextImage->BytesPerRow,//NextImage->AlignedWidth,
				gifid.Width, gifid.Height,
				((gifid.PackedFields & 0x40)?1:0)	//Interlaced?
				);

			if (n)
				AddImage(NextImage);
			else
			{
				delete NextImage;
				ERRORMSG("GIF File Corrupt");
			}

			// Some cleanup
			delete[]pCompressedImage;
			GraphicExtensionFound=0;
		}


		else if (charGot == 0x3b) {	// *C* TRAILER: End of GIF Info
			break; // Ok. Standard End.
		}
      n = 0;
	} while (ReadFile(giffile, &n, 1, &nbRead, NULL) && nbRead == 1 && SetFilePointer(giffile, -1, NULL, FILE_CURRENT));

	CloseHandle(giffile);
	if (nImages==0) ERRORMSG("Premature End Of File");
	return nImages;
}

// ****************************************************************************
// * LZWDecoder (C/C++)                                                       *
// * Codec to perform LZW (GIF Variant) decompression.                        *
// *                         (c) Nov2000, Juan Soulie <jsoulie@cplusplus.com> *
// ****************************************************************************
//
// Parameter description:
//  - bufIn: Input buffer containing a "de-blocked" GIF/LZW compressed image.
//  - bufOut: Output buffer where result will be stored.
//  - InitCodeSize: Initial CodeSize to be Used
//    (GIF files include this as the first byte in a picture block)
//  - AlignedWidth : Width of a row in memory (including alignment if needed)
//  - Width, Height: Physical dimensions of image.
//  - Interlace: 1 for Interlaced GIFs.
//
int LZWDecoder (char * bufIn, char * bufOut,
				short InitCodeSize, int AlignedWidth,
				int Width, int Height, const int Interlace)
{
	int n;
	int row=0,col=0;				// used to point output if Interlaced
	int nPixels, maxPixels;			// Output pixel counter

	short CodeSize;					// Current CodeSize (size in bits of codes)
	short ClearCode;				// Clear code : resets decompressor
	short EndCode;					// End code : marks end of information

	long whichBit;					// Index of next bit in bufIn
	long LongCode;					// Temp. var. from which Code is retrieved
	short Code;						// Code extracted
	short PrevCode;					// Previous Code
	short OutCode;					// Code to output

	// Translation Table:
	short Prefix[4096];				// Prefix: index of another Code
	unsigned char Suffix[4096];		// Suffix: terminating character
	short FirstEntry;				// Index of first free entry in table
	short NextEntry;				// Index of next free entry in table

	unsigned char OutStack[4097];	// Output buffer
	int OutIndex;					// Characters in OutStack

	int RowOffset;					// Offset in output buffer for current row

	// Set up values that depend on InitCodeSize Parameter.
	CodeSize = InitCodeSize+1;
	ClearCode = (1 << InitCodeSize);
	EndCode = ClearCode + 1;
	NextEntry = FirstEntry = ClearCode + 2;

	whichBit=0;
	nPixels = 0;
	maxPixels = Width*Height;
	RowOffset =0;
	while (nPixels<maxPixels) {
		OutIndex = 0;							// Reset Output Stack

		// GET NEXT CODE FROM bufIn:
		// LZW compression uses code items longer than a single byte.
		// For GIF Files, code sizes are variable between 9 and 12 bits 
		// That's why we must read data (Code) this way:
		LongCode=*((long*)(bufIn+whichBit/8));	// Get some bytes from bufIn
		LongCode>>=(whichBit&7);				// Discard too low bits
		Code =(LongCode & ((1<<CodeSize)-1) );	// Discard too high bits
		whichBit += CodeSize;					// Increase Bit Offset

		// SWITCH, DIFFERENT POSIBILITIES FOR CODE:
		if (Code == EndCode)					// END CODE
			break;								// Exit LZW Decompression loop

		if (Code == ClearCode) {				// CLEAR CODE:
			CodeSize = InitCodeSize+1;			// Reset CodeSize
			NextEntry = FirstEntry;				// Reset Translation Table
			PrevCode=Code;				// Prevent next to be added to table.
			continue;							// restart, to get another code
		}
		if (Code < NextEntry)					// CODE IS IN TABLE
			OutCode = Code;						// Set code to output.

		else {									// CODE IS NOT IN TABLE:
			OutIndex++;			// Keep "first" character of previous output.
			OutCode = PrevCode;					// Set PrevCode to be output
		}

		// EXPAND OutCode IN OutStack
		// - Elements up to FirstEntry are Raw-Codes and are not expanded
		// - Table Prefices contain indexes to other codes
		// - Table Suffices contain the raw codes to be output
		while (OutCode >= FirstEntry) {
			if (OutIndex > 4096) return 0;
			OutStack[OutIndex++] = Suffix[OutCode];	// Add suffix to Output Stack
			OutCode = Prefix[OutCode];				// Loop with preffix
		}

		// NOW OutCode IS A RAW CODE, ADD IT TO OUTPUT STACK.
		if (OutIndex > 4096) return 0;
		OutStack[OutIndex++] = (unsigned char) OutCode;

		// ADD NEW ENTRY TO TABLE (PrevCode + OutCode)
		// (EXCEPT IF PREVIOUS CODE WAS A CLEARCODE)
		if (PrevCode!=ClearCode) {
			Prefix[NextEntry] = PrevCode;
			Suffix[NextEntry] = (unsigned char) OutCode;
			NextEntry++;

			// Prevent Translation table overflow:
			if (NextEntry>=4096) return 0;
      
			// INCREASE CodeSize IF NextEntry IS INVALID WITH CURRENT CodeSize
			if (NextEntry >= (1<<CodeSize)) {
				if (CodeSize < 12) CodeSize++;
				else {}				// Do nothing. Maybe next is Clear Code.
			}
		}

		PrevCode = Code;

		// Avoid the possibility of overflow on 'bufOut'.
		if (nPixels + OutIndex > maxPixels) OutIndex = maxPixels-nPixels;

		// OUTPUT OutStack (LAST-IN FIRST-OUT ORDER)
		for (n=OutIndex-1; n>=0; n--) {
			if (col==Width)						// Check if new row.
			{
				if (Interlace) {				// If interlaced::
					     if ((row&7)==0) {row+=8; if (row>=Height) row=4;}
					else if ((row&3)==0) {row+=8; if (row>=Height) row=2;}
					else if ((row&1)==0) {row+=4; if (row>=Height) row=1;}
					else row+=2;
				}
				else							// If not interlaced:
					row++;

				RowOffset=row*AlignedWidth;		// Set new row offset
				col=0;
			}
			bufOut[RowOffset+col]=OutStack[n];	// Write output
			col++;	nPixels++;					// Increase counters.
		}

	}	// while (main decompressor loop)

	return whichBit;
}

// Refer to WINIMAGE.TXT for copyright and patent notices on GIF and LZW.
/*char ss[64];
wsprintf(ss, "tri=%d, trc=0x%x, bgi=%d, bgc=0x%x, disp=%d",
      trInd, trCol, pAnimation->bgInd, mgCol, disp);
MessageBox(NULL, ss, "", 0);*/
