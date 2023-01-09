//
//  TIFFPredictor.m
//  tiff-ios
//
//  Created by Brian Osborn on 1/7/22.
//  Copyright © 2022 NGA. All rights reserved.
//

#import "TIFFPredictor.h"
#import "TIFFByteReader.h"
#import "TIFFByteWriter.h"
#import "TIFFConstants.h"

@implementation TIFFPredictor

+(NSData *) decodeData: (NSData *) data withPredictor: (int) predictor andWidth: (int) width andHeight: (int) height andBitsPerSample: (NSArray<NSNumber *> *) bitsPerSample andPlanarConfiguration: (int) planarConfiguration{

    if (predictor != TIFF_PREDICTOR_NO) {

        int numBitsPerSample = [[bitsPerSample objectAtIndex:0] intValue];
        if (numBitsPerSample % 8 != 0) {
            [NSException raise:@"Unsupported Predictor" format:@"When decoding with predictor, only multiple of 8 bits are supported"];
        }

        for (int i = 1; i < bitsPerSample.count; i++) {
            if ([[bitsPerSample objectAtIndex:i] intValue] != numBitsPerSample) {
                [NSException raise:@"Unsupported Predictor" format:@"When decoding with predictor, all samples must have the same size"];
            }
        }

        int bytesPerSample = numBitsPerSample / 8;
        int samples = planarConfiguration == 2 ? 1 : (int) bitsPerSample.count;

        TIFFByteReader *reader = [[TIFFByteReader alloc] initWithData:data andByteOrder:CFByteOrderLittleEndian];
        TIFFByteWriter *writer = [[TIFFByteWriter alloc] initWithByteOrder:CFByteOrderLittleEndian];
        @try {
            
            for (int row = 0; row < height; row++) {
                // Last strip will be truncated if height % stripHeight != 0
                if (row * samples * width
                        * bytesPerSample >= data.length) {
                    break;
                }
                if(predictor == TIFF_PREDICTOR_HORIZONTAL){
                    [self decodeHorizontalWithReader:reader andWriter:writer andWidth:width andBytesPerSample:bytesPerSample andSamples:samples];
                }else if(predictor == TIFF_PREDICTOR_FLOATINGPOINT){
                    [self decodeFloatingPointWithReader:reader andWriter:writer andWidth:width andBytesPerSample:bytesPerSample andSamples:samples];
                }else{
                    [NSException raise:@"Unsupported Predictor" format:@"Unsupported Predictor %d", predictor];
                }
            }

            data = [writer data];
            
        } @finally {
            [writer close];
        }

    }

    return data;
}

/**
 * Decode a horizontal encoded predictor row
 *
 * @param reader
 *            byte reader
 * @param writer
 *            byte writer
 * @param width
 *            tile width
 * @param bytesPerSample
 *            bytes per sample
 * @param samples
 *            number of samples
 */
+(void) decodeHorizontalWithReader: (TIFFByteReader *) reader andWriter: (TIFFByteWriter *) writer andWidth: (int) width andBytesPerSample: (int) bytesPerSample andSamples: (int) samples{

    int *previous = calloc(samples, sizeof(int));

    for (int pixel = 0; pixel < width; pixel++) {

        for (int sample = 0; sample < samples; sample++) {
            int value = [self readValueWithReader:reader andBytesPerSample:bytesPerSample] + previous[sample];
            [self writeValue:value withWriter:writer andBytesPerSample:bytesPerSample];
            previous[sample] = value;
        }

    }
    
    free(previous);

}

/**
 * Decode a floating point encoded predictor row
 *
 * @param reader
 *            byte reader
 * @param writer
 *            byte writer
 * @param width
 *            tile width
 * @param bytesPerSample
 *            bytes per sample
 * @param samples
 *            number of samples
 */
+(void) decodeFloatingPointWithReader: (TIFFByteReader *) reader andWriter: (TIFFByteWriter *) writer andWidth: (int) width andBytesPerSample: (int) bytesPerSample andSamples: (int) samples{

    int samplesWidth = width * samples;

    char *data = calloc(samplesWidth * bytesPerSample, sizeof(char));

    char *previous = calloc(samples, sizeof(char));

    for (int sampleByte = 0; sampleByte < width
            * bytesPerSample; sampleByte++) {

        for (int sample = 0; sample < samples; sample++) {
            char value = [[reader readByte] charValue] + previous[sample];
            data[sampleByte * samples + sample] = value;
            previous[sample] = value;
        }

    }

    for (int widthSample = 0; widthSample < samplesWidth; widthSample++) {
        for (int sampleByte = 0; sampleByte < bytesPerSample; sampleByte++) {
            int index = ((bytesPerSample - sampleByte - 1) * samplesWidth)
                    + widthSample;
            [writer writeByte:data[index]];
        }
    }

    free(previous);
    free(data);
    
}

/**
 * Read a sample value
 *
 * @param reader
 *            byte reader
 * @param bytesPerSample
 *            bytes per sample
 * @return sample value
 */
+(int) readValueWithReader: (TIFFByteReader *) reader andBytesPerSample: (int) bytesPerSample{

    int value;

    switch (bytesPerSample) {
        case 1:
            value = [[reader readByte] intValue];
            break;
        case 2:
            value = [[reader readShort] intValue];
            break;
        case 4:
            value = [[reader readInt] intValue];
            break;
        default:
            [NSException raise:@"Unsupported Predictor" format:@"Predictor not supported with %d bytes per sample", bytesPerSample];
    }

    return value;
}

/**
 * Write a sample value
 *
 * @param value
 *            sample value
 * @param writer
 *            byte writer
 * @param bytesPerSample
 *            bytes per sample
 */
+(void) writeValue: (int) value withWriter: (TIFFByteWriter *) writer andBytesPerSample: (int) bytesPerSample{
    
    switch (bytesPerSample) {
        case 1:
            [writer writeByte:value];
            break;
        case 2:
            [writer writeShort:value];
            break;
        case 4:
            [writer writeInt:value];
            break;
        default:
            [NSException raise:@"Unsupported Predictor" format:@"Predictor not supported with %d bytes per sample", bytesPerSample];
    }

}

@end
