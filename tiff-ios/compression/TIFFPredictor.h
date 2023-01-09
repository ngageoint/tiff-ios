//
//  TIFFPredictor.h
//  tiff-ios
//
//  Created by Brian Osborn on 1/7/22.
//  Copyright © 2022 NGA. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Differencing Predictor decoder
 */
@interface TIFFPredictor : NSObject

/**
 * Decode the predictor encoded bytes
 *
 * @param data
 *            data to decode
 * @param predictor
 *            predictor value
 * @param width
 *            tile width
 * @param height
 *            tile height
 * @param bitsPerSample
 *            bits per samples
 * @param planarConfiguration
 *            planar configuration
 * @return decoded or original bytes
 */
+(NSData *) decodeData: (NSData *) data withPredictor: (int) predictor andWidth: (int) width andHeight: (int) height andBitsPerSample: (NSArray<NSNumber *> *) bitsPerSample andPlanarConfiguration: (int) planarConfiguration;
    
@end
