//
//  TIFFUnsupportedCompression.m
//  tiff-ios
//
//  Created by Brian Osborn on 12/13/18.
//  Copyright © 2018 NGA. All rights reserved.
//

#import "TIFFUnsupportedCompression.h"

@interface TIFFUnsupportedCompression()

@property (nonatomic, strong) NSString *message;

@end

@implementation TIFFUnsupportedCompression

-(instancetype) initWithMessage: (NSString *) message{
    self = [super init];
    if(self != nil){
        self.message = message;
    }
    return self;
}

-(NSData *) decodeData: (NSData *) data withByteOrder: (CFByteOrder) byteOrder{
    [NSException raise:@"Unsupported Compression" format:@"%@", self.message];
    return data;
}

-(BOOL) rowEncoding{
    return false;
}

-(NSData *) encodeData: (NSData *) data withByteOrder: (CFByteOrder) byteOrder{
    [NSException raise:@"Unsupported Compression" format:@"%@", self.message];
    return data;
}

@end
