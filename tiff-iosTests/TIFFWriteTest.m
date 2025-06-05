//
//  TIFFWriteTest.m
//  tiff-ios
//
//  Created by Brian Osborn on 1/17/17.
//  Copyright © 2017 NGA. All rights reserved.
//

#import "TIFFWriteTest.h"
#import "TIFFTestUtils.h"
#import "TIFFTestConstants.h"

@import TIFF;

@implementation TIFFWriteTest

/**
 * Test writing and reading a stripped TIFF file
 */
-(void) testWriteStrippedChunky{

    NSString *strippedFile = [TIFFTestUtils testFileWithName:TIFF_TEST_FILE_STRIPPED];
    TIFFImage *strippedTiff = [TIFFReader readTiffFromFile:strippedFile];
    
    TIFFFileDirectory *fileDirectory = [strippedTiff fileDirectory];
    TIFFRasters *rasters = [fileDirectory readRasters];
    TIFFRasters *rastersInterleaved = [fileDirectory readInterleavedRasters];

    [fileDirectory setWriteRasters:rasters];
    [fileDirectory setCompression:TIFF_COMPRESSION_NO];
    [fileDirectory setPlanarConfiguration:TIFF_PLANAR_CONFIGURATION_CHUNKY];
    int rowsPerStrip = [rasters calculateRowsPerStripWithPlanarConfiguration:[[fileDirectory planarConfiguration] intValue]];
    [fileDirectory setRowsPerStrip:rowsPerStrip];
    NSData *tiffBytes = [TIFFWriter writeTiffToDataWithImage:strippedTiff];
    
    TIFFImage *readTiffImage = [TIFFReader readTiffFromData:tiffBytes];
    TIFFFileDirectory *fileDirectory2 = [readTiffImage fileDirectory];
    TIFFRasters *rasters2 = [fileDirectory2 readRasters];
    TIFFRasters *rasters2Interleaved = [fileDirectory2 readInterleavedRasters];
    
    [TIFFTestUtils compareRastersSampleValuesWithRasters1:rasters andRasters2:rasters2];
    [TIFFTestUtils compareRastersInterleaveValuesWithRasters1:rastersInterleaved andRasters2:rasters2Interleaved];
    
}

/**
 * Test writing and reading a stripped TIFF file
 */
-(void) testWriteStrippedPlanar{

    NSString *strippedFile = [TIFFTestUtils testFileWithName:TIFF_TEST_FILE_STRIPPED];
    TIFFImage *strippedTiff = [TIFFReader readTiffFromFile:strippedFile];
    
    TIFFFileDirectory *fileDirectory = [strippedTiff fileDirectory];
    TIFFRasters *rasters = [fileDirectory readRasters];
    TIFFRasters *rastersInterleaved = [fileDirectory readInterleavedRasters];
    
    [fileDirectory setWriteRasters:rasters];
    [fileDirectory setCompression:TIFF_COMPRESSION_NO];
    [fileDirectory setPlanarConfiguration:TIFF_PLANAR_CONFIGURATION_PLANAR];
    int rowsPerStrip = [rasters calculateRowsPerStripWithPlanarConfiguration:[[fileDirectory planarConfiguration] intValue]];
    [fileDirectory setRowsPerStrip:rowsPerStrip];
    NSData *tiffBytes = [TIFFWriter writeTiffToDataWithImage:strippedTiff];
    
    TIFFImage *readTiffImage = [TIFFReader readTiffFromData:tiffBytes];
    TIFFFileDirectory *fileDirectory2 = [readTiffImage fileDirectory];
    TIFFRasters *rasters2 = [fileDirectory2 readRasters];
    TIFFRasters *rasters2Interleaved = [fileDirectory2 readInterleavedRasters];
    
    [TIFFTestUtils compareRastersSampleValuesWithRasters1:rasters andRasters2:rasters2];
    [TIFFTestUtils compareRastersInterleaveValuesWithRasters1:rastersInterleaved andRasters2:rasters2Interleaved];
    
}

/**
 * Test writing and reading and custom tiff
 */
-(void) testWriteCustom{

    unsigned short inpWidth = 18;
    unsigned short inpHeight = 11;
    unsigned short bitsPerSample = 16;
    unsigned short samplesPerPixel = 1;
    unsigned long xResolution = 254;
    unsigned long yResolution = 254;
    
    unsigned short *inpPixVals = (unsigned short *)malloc(sizeof(unsigned short) * inpHeight * inpWidth);
    for (int y = 0; y < inpHeight; y++) {
        for (int x = 0; x < inpWidth; x++) {
            inpPixVals[y * inpWidth + x] = (unsigned short)[TIFFTestUtils randomIntLessThan:pow(2.0, bitsPerSample)];
        }
    }
    
    TIFFRasters *newRaster = [[TIFFRasters alloc] initWithWidth:inpWidth andHeight:inpHeight andSamplesPerPixel:samplesPerPixel andSingleBitsPerSample:bitsPerSample];
    TIFFFileDirectory *fileDirs = [[TIFFFileDirectory alloc] init];
    
    unsigned short rowsPerStrip = [newRaster calculateRowsPerStripWithPlanarConfiguration:(int)TIFF_PLANAR_CONFIGURATION_CHUNKY];
    [fileDirs setImageWidth:inpWidth];
    [fileDirs setImageHeight:inpHeight];
    [fileDirs setBitsPerSampleAsSingleValue:bitsPerSample];
    [fileDirs setSamplesPerPixel:samplesPerPixel];
    [fileDirs setSampleFormatAsSingleValue:TIFF_SAMPLE_FORMAT_UNSIGNED_INT];
    [fileDirs setRowsPerStrip:rowsPerStrip];
    [fileDirs setResolutionUnit:TIFF_RESOLUTION_UNIT_INCH];
    [fileDirs setXResolutionAsSingleValue:xResolution];
    [fileDirs setYResolutionAsSingleValue:yResolution];
    [fileDirs setPhotometricInterpretation:TIFF_PHOTOMETRIC_INTERPRETATION_BLACK_IS_ZERO];
    [fileDirs setPlanarConfiguration:TIFF_PLANAR_CONFIGURATION_CHUNKY];
    [fileDirs setCompression:TIFF_COMPRESSION_NO];
    [fileDirs setWriteRasters:newRaster];
    
    for (int y = 0; y < inpHeight; y++) {
        for (int x = 0; x < inpWidth; x++) {
            [newRaster setFirstPixelSampleAtX:x andY:y withValue:[NSNumber numberWithUnsignedShort:inpPixVals[y * inpWidth + x]]];
        }
    }
    TIFFImage *newImage = [[TIFFImage alloc] init];
    [newImage addFileDirectory:fileDirs];
    
    NSData *tiffData = [TIFFWriter writeTiffToDataWithImage:newImage];
    [TIFFTestUtils assertNotNil:tiffData];
    
    TIFFImage *image = [TIFFReader readTiffFromData:tiffData];
    [TIFFTestUtils assertNotNil:image];
    
    TIFFFileDirectory *fileDirectory = [image fileDirectory];
    [TIFFTestUtils assertEqualIntWithValue:inpWidth andValue2:[[fileDirectory imageWidth] unsignedShortValue]];
    [TIFFTestUtils assertEqualIntWithValue:inpHeight andValue2:[[fileDirectory imageHeight] unsignedShortValue]];
    NSArray<NSNumber *> *bitsPerSamp = [fileDirectory bitsPerSample];
    [TIFFTestUtils assertEqualIntWithValue:1 andValue2:(int)bitsPerSamp.count];
    [TIFFTestUtils assertEqualIntWithValue:bitsPerSample andValue2:[[bitsPerSamp objectAtIndex:0] unsignedShortValue]];
    [TIFFTestUtils assertEqualIntWithValue:samplesPerPixel andValue2:[fileDirectory samplesPerPixel]];
    NSArray<NSNumber *> *sampleFormat = [fileDirectory sampleFormat];
    [TIFFTestUtils assertEqualIntWithValue:1 andValue2:(int)sampleFormat.count];
    [TIFFTestUtils assertEqualIntWithValue:(int)TIFF_SAMPLE_FORMAT_UNSIGNED_INT andValue2:[[sampleFormat objectAtIndex:0] unsignedShortValue]];
    [TIFFTestUtils assertEqualIntWithValue:rowsPerStrip andValue2:[[fileDirectory rowsPerStrip] unsignedShortValue]];
    [TIFFTestUtils assertEqualIntWithValue:(int)TIFF_RESOLUTION_UNIT_INCH andValue2:[[fileDirectory resolutionUnit] unsignedShortValue]];
    NSArray<NSNumber *> *xRes = [fileDirectory xResolution];
    [TIFFTestUtils assertEqualIntWithValue:2 andValue2:(int)xRes.count];
    [TIFFTestUtils assertEqualIntWithValue:(int) xResolution andValue2:[[xRes objectAtIndex:0] intValue]];
    [TIFFTestUtils assertEqualIntWithValue:1 andValue2:[[xRes objectAtIndex:1] intValue]];
    NSArray<NSNumber *> *yRes = [fileDirectory yResolution];
    [TIFFTestUtils assertEqualIntWithValue:2 andValue2:(int)yRes.count];
    [TIFFTestUtils assertEqualIntWithValue:(int) yResolution andValue2:[[yRes objectAtIndex:0] intValue]];
    [TIFFTestUtils assertEqualIntWithValue:1 andValue2:[[yRes objectAtIndex:1] intValue]];
    [TIFFTestUtils assertEqualIntWithValue:(int)TIFF_PHOTOMETRIC_INTERPRETATION_BLACK_IS_ZERO andValue2:[[fileDirectory photometricInterpretation] unsignedShortValue]];
    [TIFFTestUtils assertEqualIntWithValue:(int)TIFF_PLANAR_CONFIGURATION_CHUNKY andValue2:[[fileDirectory planarConfiguration] unsignedShortValue]];
    [TIFFTestUtils assertEqualIntWithValue:(int)TIFF_COMPRESSION_NO andValue2:[[fileDirectory compression] unsignedShortValue]];
    
    TIFFRasters *rasters = [fileDirectory readRasters];
    [TIFFTestUtils assertEqualIntWithValue:inpWidth * inpHeight andValue2:[rasters numPixels]];
    [TIFFTestUtils assertEqualIntWithValue:inpWidth andValue2:[rasters width]];
    [TIFFTestUtils assertEqualIntWithValue:inpHeight andValue2:[rasters height]];
    [TIFFTestUtils assertEqualIntWithValue:samplesPerPixel andValue2:[rasters samplesPerPixel]];
    NSArray<NSNumber *> *bps = [rasters bitsPerSample];
    [TIFFTestUtils assertEqualIntWithValue:1 andValue2:(int)bps.count];
    [TIFFTestUtils assertEqualIntWithValue:bitsPerSample andValue2:[[bps objectAtIndex:0] unsignedShortValue]];

    for (int y = 0; y < inpHeight; y++) {
        for (int x = 0; x < inpWidth; x++) {
            [TIFFTestUtils assertEqualIntWithValue:inpPixVals[y * inpWidth + x] andValue2:[[rasters pixelSampleAtSample:0 andX:x andY:y] unsignedShortValue]];
        }
    }
    
    free(inpPixVals);
}



@end
