//
//  TIFFPackbitsCompression.h
//  tiff-ios
//
//  Created by Brian Osborn on 1/9/17.
//  Copyright © 2017 NGA. All rights reserved.
//

#import "TIFFCompressionDecoder.h"
#import "TIFFCompressionEncoder.h"

/**
 * Packbits Compression
 */
@interface TIFFPackbitsCompression : NSObject<TIFFCompressionDecoder, TIFFCompressionEncoder>

@end
