//
//  TIFFUnsupportedCompression.h
//  tiff-ios
//
//  Created by Brian Osborn on 12/13/18.
//  Copyright © 2018 NGA. All rights reserved.
//

#import "TIFFCompressionDecoder.h"
#import "TIFFCompressionEncoder.h"

/**
 * Unsupported compression
 */
@interface TIFFUnsupportedCompression : NSObject<TIFFCompressionDecoder, TIFFCompressionEncoder>

/**
 *  Initialize
 *
 *  @param message message of the TiffException
 *
 *  @return new unsupported compression
 */
-(instancetype) initWithMessage: (NSString *) message;

@end
