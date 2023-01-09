//
//  TIFFReadTest.m
//  tiff-ios
//
//  Created by Brian Osborn on 1/17/17.
//  Copyright © 2017 NGA. All rights reserved.
//

#import "TIFFReadTest.h"
#import "TIFFTestUtils.h"
#import "TIFFTestConstants.h"
#import "TIFFReader.h"

@implementation TIFFReadTest

/**
 * Test the stripped TIFF file vs the same data tiled
 */
-(void) testStrippedVsTiled{
    
    NSString *strippedFile = [TIFFTestUtils testFileWithName:TIFF_TEST_FILE_STRIPPED];
    TIFFImage *strippedTiff = [TIFFReader readTiffFromFile:strippedFile];
    
    NSString *file = [TIFFTestUtils testFileWithName:TIFF_TEST_FILE_TILED];
    TIFFImage *tiff = [TIFFReader readTiffFromFile:file];
    
    [TIFFTestUtils compareTIFFImagesWithImage1:strippedTiff andImage2:tiff];

}

/**
 * Test the stripped TIFF file vs the same data as int 32
 */
-(void) testStrippedVsInt32{
    
    NSString *strippedFile = [TIFFTestUtils testFileWithName:TIFF_TEST_FILE_STRIPPED];
    TIFFImage *strippedTiff = [TIFFReader readTiffFromFile:strippedFile];
    
    NSString *file = [TIFFTestUtils testFileWithName:TIFF_TEST_FILE_INT32];
    TIFFImage *tiff = [TIFFReader readTiffFromFile:file];
    
    [TIFFTestUtils compareTIFFImagesWithImage1:strippedTiff andImage2:tiff andExactType:true andSameBitsPerSample:false];
    
}

/**
 * Test the stripped TIFF file vs the same data as unsigned int 32
 */
-(void) testStrippedVsUInt32{
    
    NSString *strippedFile = [TIFFTestUtils testFileWithName:TIFF_TEST_FILE_STRIPPED];
    TIFFImage *strippedTiff = [TIFFReader readTiffFromFile:strippedFile];
    
    NSString *file = [TIFFTestUtils testFileWithName:TIFF_TEST_FILE_UINT32];
    TIFFImage *tiff = [TIFFReader readTiffFromFile:file];
    
    [TIFFTestUtils compareTIFFImagesWithImage1:strippedTiff andImage2:tiff andExactType:false andSameBitsPerSample:false];
    
}

/**
 * Test the stripped TIFF file vs the same data as float 32
 */
-(void) testStrippedVsFloat32{
    
    NSString *strippedFile = [TIFFTestUtils testFileWithName:TIFF_TEST_FILE_STRIPPED];
    TIFFImage *strippedTiff = [TIFFReader readTiffFromFile:strippedFile];
    
    NSString *file = [TIFFTestUtils testFileWithName:TIFF_TEST_FILE_FLOAT32];
    TIFFImage *tiff = [TIFFReader readTiffFromFile:file];
    
    [TIFFTestUtils compareTIFFImagesWithImage1:strippedTiff andImage2:tiff andExactType:false andSameBitsPerSample:false];
    
}

/**
 * Test the stripped TIFF file vs the same data as float 64
 */
-(void) testStrippedVsFloat64{
    
    NSString *strippedFile = [TIFFTestUtils testFileWithName:TIFF_TEST_FILE_STRIPPED];
    TIFFImage *strippedTiff = [TIFFReader readTiffFromFile:strippedFile];
    
    NSString *file = [TIFFTestUtils testFileWithName:TIFF_TEST_FILE_FLOAT64];
    TIFFImage *tiff = [TIFFReader readTiffFromFile:file];
    
    [TIFFTestUtils compareTIFFImagesWithImage1:strippedTiff andImage2:tiff andExactType:false andSameBitsPerSample:false];
    
}

/**
 * Test the stripped TIFF file vs the same data compressed as LZW
 */
-(void) testStrippedVsLzw{
    
    NSString *strippedFile = [TIFFTestUtils testFileWithName:TIFF_TEST_FILE_STRIPPED];
    TIFFImage *strippedTiff = [TIFFReader readTiffFromFile:strippedFile];
    
    NSString *file = [TIFFTestUtils testFileWithName:TIFF_TEST_FILE_LZW];
    TIFFImage *tiff = [TIFFReader readTiffFromFile:file];
    
    [TIFFTestUtils compareTIFFImagesWithImage1:strippedTiff andImage2:tiff];
    
}

/**
 * Test the stripped TIFF file vs the same data compressed as Packbits
 */
-(void) testStrippedVsPackbits{
    
    NSString *strippedFile = [TIFFTestUtils testFileWithName:TIFF_TEST_FILE_STRIPPED];
    TIFFImage *strippedTiff = [TIFFReader readTiffFromFile:strippedFile];
    
    NSString *file = [TIFFTestUtils testFileWithName:TIFF_TEST_FILE_PACKBITS];
    TIFFImage *tiff = [TIFFReader readTiffFromFile:file];
    
    [TIFFTestUtils compareTIFFImagesWithImage1:strippedTiff andImage2:tiff];
    
}

/**
 * Test the stripped TIFF file vs the same data as interleaved
 */
-(void) testStrippedVsInterleave{
    
    NSString *strippedFile = [TIFFTestUtils testFileWithName:TIFF_TEST_FILE_STRIPPED];
    TIFFImage *strippedTiff = [TIFFReader readTiffFromFile:strippedFile];
    
    NSString *file = [TIFFTestUtils testFileWithName:TIFF_TEST_FILE_INTERLEAVE];
    TIFFImage *tiff = [TIFFReader readTiffFromFile:file];
    
    [TIFFTestUtils compareTIFFImagesWithImage1:strippedTiff andImage2:tiff];
    
}

/**
 * Test the stripped TIFF file vs the same data as tiled planar
 */
-(void) testStrippedVsTiledPlanar{
    
    NSString *strippedFile = [TIFFTestUtils testFileWithName:TIFF_TEST_FILE_STRIPPED];
    TIFFImage *strippedTiff = [TIFFReader readTiffFromFile:strippedFile];
    
    NSString *file = [TIFFTestUtils testFileWithName:TIFF_TEST_FILE_TILED_PLANAR];
    TIFFImage *tiff = [TIFFReader readTiffFromFile:file];
    
    [TIFFTestUtils compareTIFFImagesWithImage1:strippedTiff andImage2:tiff];
    
}

/**
 * Test the JPEG file header
 */
-(void) testJPEGHeader{
    
    NSString *file = [TIFFTestUtils testFileWithName:TIFF_TEST_FILE_JPEG];
    TIFFImage *tiff = [TIFFReader readTiffFromFile:file];
    
    [TIFFTestUtils assertNotNil:tiff];
    [TIFFTestUtils assertTrue:[tiff fileDirectories].count > 0];
    for (int i = 0; i < [tiff fileDirectories].count; i++) {
        TIFFFileDirectory *fileDirectory = [tiff fileDirectoryAtIndex:i];
        [TIFFTestUtils assertNotNil:fileDirectory];
        
        @try {
            [fileDirectory readRasters];
            [NSException raise:@"Unexpected" format:@"JPEG compression was not expected to be implemented"];
        } @catch (NSException *exception) {
            // expected
        }

    }
    
}

/**
 * Test the stripped TIFF file vs the same data as LZW predictor
 */
-(void) testStrippedVsLZWPredictor{
    
    NSString *strippedFile = [TIFFTestUtils testFileWithName:TIFF_TEST_FILE_STRIPPED];
    TIFFImage *strippedTiff = [TIFFReader readTiffFromFile:strippedFile];
    
    NSString *file = [TIFFTestUtils testFileWithName:TIFF_TEST_FILE_LZW_PREDICTOR];
    TIFFImage *tiff = [TIFFReader readTiffFromFile:file];
    
    [TIFFTestUtils compareTIFFImagesWithImage1:strippedTiff andImage2:tiff];
    
}

/**
 * Test the stripped TIFF file vs the same data as tiled planar LZW
 */
-(void) testStrippedVsTiledPlanarLZW{
    
    NSString *strippedFile = [TIFFTestUtils testFileWithName:TIFF_TEST_FILE_STRIPPED];
    TIFFImage *strippedTiff = [TIFFReader readTiffFromFile:strippedFile];
    
    NSString *file = [TIFFTestUtils testFileWithName:TIFF_TEST_FILE_TILED_PLANAR_LZW];
    TIFFImage *tiff = [TIFFReader readTiffFromFile:file];
    
    [TIFFTestUtils compareTIFFImagesWithImage1:strippedTiff andImage2:tiff];
    
}

/**
 * Test the float 32 TIFF file vs the same data as LZW predictor floating point
 */
-(void) testFloat32VsLZWPredictorFloatingPoint{
    
    NSString *float32File = [TIFFTestUtils testFileWithName:TIFF_TEST_FILE_FLOAT32];
    TIFFImage *float32Tiff = [TIFFReader readTiffFromFile:float32File];
    
    NSString *file = [TIFFTestUtils testFileWithName:TIFF_TEST_FILE_LZW_PREDICTOR_FLOATING];
    TIFFImage *tiff = [TIFFReader readTiffFromFile:file];
    
    [TIFFTestUtils compareTIFFImagesWithImage1:float32Tiff andImage2:tiff];
    
}

@end
