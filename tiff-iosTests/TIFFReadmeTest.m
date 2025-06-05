//
//  TIFFReadmeTest.m
//  tiff-iosTests
//
//  Created by Brian Osborn on 7/20/20.
//  Copyright © 2020 NGA. All rights reserved.
//

#import "TIFFReadmeTest.h"

@import TIFF;

@implementation TIFFReadmeTest

/**
 * Test write and read
 */
-(void) testWriteAndRead{
    [self testReadWithInput:[self testWrite]];
}

/**
 * Test read
 */
-(void) testReadWithInput: (NSData *) data{
    
    // NSData *data = ...;
    // NSString *file = ...;
    // NSInputStream *stream = ...;
    // TIFFByteReader *reader = ...;

    TIFFImage *tiffImage = [TIFFReader readTiffFromData:data];
    // TIFFImage *tiffImage = [TIFFReader readTiffFromFile:file];
    // TIFFImage *tiffImage = [TIFFReader readTiffFromStream:stream];
    // TIFFImage *tiffImage = [TIFFReader readTiffFromReader:reader];
    NSArray<TIFFFileDirectory *> *directories = [tiffImage fileDirectories];
    TIFFFileDirectory *directory  = [directories objectAtIndex:0];
    TIFFRasters *rasters = [directory readRasters];
    
}

/**
 * Test write
 */
-(NSData *) testWrite{
    
    int width = 256;
    int height = 256;
    int samplesPerPixel = 1;
    int bitsPerSample = 32;

    TIFFRasters *rasters = [[TIFFRasters alloc] initWithWidth:width andHeight:height andSamplesPerPixel:samplesPerPixel andSingleBitsPerSample:bitsPerSample];

    int rowsPerStrip = [rasters calculateRowsPerStripWithPlanarConfiguration:(int)TIFF_PLANAR_CONFIGURATION_CHUNKY];

    TIFFFileDirectory *directory = [[TIFFFileDirectory alloc] init];
    [directory setImageWidth: width];
    [directory setImageHeight: height];
    [directory setBitsPerSampleAsSingleValue: bitsPerSample];
    [directory setCompression: TIFF_COMPRESSION_NO];
    [directory setPhotometricInterpretation: TIFF_PHOTOMETRIC_INTERPRETATION_BLACK_IS_ZERO];
    [directory setSamplesPerPixel: samplesPerPixel];
    [directory setRowsPerStrip: rowsPerStrip];
    [directory setPlanarConfiguration: TIFF_PLANAR_CONFIGURATION_CHUNKY];
    [directory setSampleFormatAsSingleValue: TIFF_SAMPLE_FORMAT_FLOAT];
    [directory setWriteRasters: rasters];

    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            float pixelValue = 1.0; // any pixel value
            [rasters setFirstPixelSampleAtX:x andY:y withValue:[[NSDecimalNumber alloc] initWithFloat:pixelValue]];
        }
    }

    TIFFImage *tiffImage = [[TIFFImage alloc] init];
    [tiffImage addFileDirectory:directory];
    NSData *data = [TIFFWriter writeTiffToDataWithImage:tiffImage];
    // or
    // NSString *file = ...;
    // [TIFFWriter writeTiffWithFile:file andImage:tiffImage];
    
    return data;
}

@end
