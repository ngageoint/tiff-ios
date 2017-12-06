//
//  TIFFFieldTypes.m
//  tiff-ios
//
//  Created by Brian Osborn on 1/4/17.
//  Copyright © 2017 NGA. All rights reserved.
//

#import "TIFFFieldTypes.h"
#import "TIFFConstants.h"

@implementation TIFFFieldTypes

+(int) value: (enum TIFFFieldType) fieldType{
    return (int) fieldType;
}

+(int) bytes: (enum TIFFFieldType) fieldType{
    
    int bytes = 0;
    
    switch (fieldType) {
        case TIFF_FIELD_BYTE:
            bytes = 1;
            break;
        case TIFF_FIELD_ASCII:
            bytes = 1;
            break;
        case TIFF_FIELD_SHORT:
            bytes = 2;
            break;
        case TIFF_FIELD_LONG:
            bytes = 4;
            break;
        case TIFF_FIELD_RATIONAL:
            bytes = 8;
            break;
        case TIFF_FIELD_SBYTE:
            bytes = 1;
            break;
        case TIFF_FIELD_UNDEFINED:
            bytes = 1;
            break;
        case TIFF_FIELD_SSHORT:
            bytes = 2;
            break;
        case TIFF_FIELD_SLONG:
            bytes = 4;
            break;
        case TIFF_FIELD_SRATIONAL:
            bytes = 8;
            break;
        case TIFF_FIELD_FLOAT:
            bytes = 4;
            break;
        case TIFF_FIELD_DOUBLE:
            bytes = 8;
            break;
        default:
            [NSException raise:@"Unsupported Field" format:@"Unsupported Field Type %u", fieldType];
            break;
    }
    
    return bytes;
}

+(int) bits: (enum TIFFFieldType) fieldType{
    return [self bytes:fieldType] * 8;
}

+(enum TIFFFieldType) typeByValue: (int) value{
    return (enum TIFFFieldType) value;
}

+(enum TIFFFieldType) typeBySampleFormat: (int) sampleFormat andBitsPerSample: (int) bitsPerSample{
    
    enum TIFFFieldType fieldType = TIFF_FIELD_UNDEFINED;
    
    if(sampleFormat == TIFF_SAMPLE_FORMAT_UNSIGNED_INT){
        switch (bitsPerSample) {
            case 8:
                fieldType = TIFF_FIELD_BYTE;
                break;
            case 16:
                fieldType = TIFF_FIELD_SHORT;
                break;
            case 32:
                fieldType = TIFF_FIELD_LONG;
                break;
        }
    }else if(sampleFormat == TIFF_SAMPLE_FORMAT_SIGNED_INT){
        switch (bitsPerSample) {
            case 8:
                fieldType = TIFF_FIELD_SBYTE;
                break;
            case 16:
                fieldType = TIFF_FIELD_SSHORT;
                break;
            case 32:
                fieldType = TIFF_FIELD_SLONG;
                break;
        }
    }else if(sampleFormat == TIFF_SAMPLE_FORMAT_FLOAT){
        switch (bitsPerSample) {
            case 32:
                fieldType = TIFF_FIELD_FLOAT;
                break;
            case 64:
                fieldType = TIFF_FIELD_DOUBLE;
                break;
        }
    }
    
    if (fieldType == TIFF_FIELD_UNDEFINED) {
        [NSException raise:@"Unsupported Sample Format & Bits Per Sample" format:@"Unsupported field type for sample format: %d, bits per sample: %d", sampleFormat, bitsPerSample];
    }
    
    return fieldType;
}

+(int) sampleFormatByType: (enum TIFFFieldType) fieldType{
    
    int sampleFormat;
    
    switch (fieldType) {
        case TIFF_FIELD_BYTE:
        case TIFF_FIELD_SHORT:
        case TIFF_FIELD_LONG:
            sampleFormat = (int) TIFF_SAMPLE_FORMAT_UNSIGNED_INT;
            break;
        case TIFF_FIELD_SBYTE:
        case TIFF_FIELD_SSHORT:
        case TIFF_FIELD_SLONG:
            sampleFormat = (int) TIFF_SAMPLE_FORMAT_SIGNED_INT;
            break;
        case TIFF_FIELD_FLOAT:
        case TIFF_FIELD_DOUBLE:
            sampleFormat = (int) TIFF_SAMPLE_FORMAT_FLOAT;
            break;
        default:
            [NSException raise:@"Unsupported Field Type" format:@"Unsupported sample format for field type: %d", fieldType];
            break;
    }
    
    return sampleFormat;
}

@end
