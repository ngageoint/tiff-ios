//
//  TIFFConstants.m
//  tiff-ios
//
//  Created by Brian Osborn on 1/4/17.
//  Copyright © 2017 NGA. All rights reserved.
//

#import <TIFF/TIFFConstants.h>

NSString * const TIFF_BYTE_ORDER_LITTLE_ENDIAN = @"II";
NSString * const TIFF_BYTE_ORDER_BIG_ENDIAN = @"MM";
NSInteger const TIFF_FILE_IDENTIFIER = 42;
NSInteger const TIFF_HEADER_BYTES = 8;
NSInteger const TIFF_IFD_HEADER_BYTES = 2;
NSInteger const TIFF_IFD_OFFSET_BYTES = 4;
NSInteger const TIFF_IFD_ENTRY_BYTES = 12;
NSInteger const TIFF_DEFAULT_MAX_BYTES_PER_STRIP = 8000;

NSInteger const TIFF_COMPRESSION_NO = 1;
NSInteger const TIFF_COMPRESSION_CCITT_HUFFMAN = 2;
NSInteger const TIFF_COMPRESSION_T4 = 3;
NSInteger const TIFF_COMPRESSION_T6 = 4;
NSInteger const TIFF_COMPRESSION_LZW = 5;
NSInteger const TIFF_COMPRESSION_JPEG_OLD = 6;
NSInteger const TIFF_COMPRESSION_JPEG_NEW = 7;
NSInteger const TIFF_COMPRESSION_DEFLATE = 8;
NSInteger const TIFF_COMPRESSION_PKZIP_DEFLATE = 32946; // PKZIP-style Deflate encoding (Obsolete).
NSInteger const TIFF_COMPRESSION_PACKBITS = 32773;

NSInteger const TIFF_EXTRA_SAMPLES_UNSPECIFIED = 0;
NSInteger const TIFF_EXTRA_SAMPLES_ASSOCIATED_ALPHA = 1;
NSInteger const TIFF_EXTRA_SAMPLES_UNASSOCIATED_ALPHA = 2;

NSInteger const TIFF_FILL_ORDER_LOWER_COLUMN_HIGHER_ORDER = 1;
NSInteger const TIFF_FILL_ORDER_LOWER_COLUMN_LOWER_ORDER = 2;

NSInteger const TIFF_GRAY_RESPONSE_TENTHS = 1;
NSInteger const TIFF_GRAY_RESPONSE_HUNDREDTHS = 2;
NSInteger const TIFF_GRAY_RESPONSE_THOUSANDTHS = 3;
NSInteger const TIFF_GRAY_RESPONSE_TEN_THOUSANDTHS = 4;
NSInteger const TIFF_GRAY_RESPONSE_HUNDRED_THOUSANDTHS = 5;

NSInteger const TIFF_ORIENTATION_TOP_ROW_LEFT_COLUMN = 1;
NSInteger const TIFF_ORIENTATION_TOP_ROW_RIGHT_COLUMN = 2;
NSInteger const TIFF_ORIENTATION_BOTTOM_ROW_RIGHT_COLUMN = 3;
NSInteger const TIFF_ORIENTATION_BOTTOM_ROW_LEFT_COLUMN = 4;
NSInteger const TIFF_ORIENTATION_LEFT_ROW_TOP_COLUMN = 5;
NSInteger const TIFF_ORIENTATION_RIGHT_ROW_TOP_COLUMN = 6;
NSInteger const TIFF_ORIENTATION_RIGHT_ROW_BOTTOM_COLUMN = 7;
NSInteger const TIFF_ORIENTATION_LEFT_ROW_BOTTOM_COLUMN = 8;

NSInteger const TIFF_PHOTOMETRIC_INTERPRETATION_WHITE_IS_ZERO = 0;
NSInteger const TIFF_PHOTOMETRIC_INTERPRETATION_BLACK_IS_ZERO = 1;
NSInteger const TIFF_PHOTOMETRIC_INTERPRETATION_RGB = 2;
NSInteger const TIFF_PHOTOMETRIC_INTERPRETATION_PALETTE = 3;
NSInteger const TIFF_PHOTOMETRIC_INTERPRETATION_TRANSPARENCY = 4;

NSInteger const TIFF_PLANAR_CONFIGURATION_CHUNKY = 1;
NSInteger const TIFF_PLANAR_CONFIGURATION_PLANAR = 2;

NSInteger const TIFF_RESOLUTION_UNIT_NO = 1;
NSInteger const TIFF_RESOLUTION_UNIT_INCH = 2;
NSInteger const TIFF_RESOLUTION_UNIT_CENTIMETER = 3;

NSInteger const TIFF_SAMPLE_FORMAT_UNSIGNED_INT = 1;
NSInteger const TIFF_SAMPLE_FORMAT_SIGNED_INT = 2;
NSInteger const TIFF_SAMPLE_FORMAT_FLOAT = 3;
NSInteger const TIFF_SAMPLE_FORMAT_UNDEFINED = 4;

NSInteger const TIFF_SUBFILE_TYPE_FULL = 1;
NSInteger const TIFF_SUBFILE_TYPE_REDUCED = 2;
NSInteger const TIFF_SAMPLE_FORMAT_SINGLE_PAGE_MULTI_PAGE = 3;

NSInteger const TIFF_THRESHHOLDING_NO = 1;
NSInteger const TIFF_THRESHHOLDING_ORDERED = 2;
NSInteger const TIFF_THRESHHOLDING_RANDOM = 3;

NSInteger const TIFF_PREDICTOR_NO = 1;
NSInteger const TIFF_PREDICTOR_HORIZONTAL = 2;
NSInteger const TIFF_PREDICTOR_FLOATINGPOINT = 3;

@implementation TIFFConstants

@end
