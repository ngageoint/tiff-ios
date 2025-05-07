//
//  TIFFRawCompression.h
//  tiff-ios
//
//  Created by Brian Osborn on 1/9/17.
//  Copyright © 2017 NGA. All rights reserved.
//

#import <TIFF/TIFFCompressionDecoder.h>
#import <TIFF/TIFFCompressionEncoder.h>

/**
 * Raw / no compression
 */
@interface TIFFRawCompression : NSObject<TIFFCompressionDecoder, TIFFCompressionEncoder>

@end
