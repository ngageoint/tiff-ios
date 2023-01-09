//
//  TIFFLZWCompression.m
//  tiff-ios
//
//  Created by Brian Osborn on 1/9/17.
//  Copyright © 2017 NGA. All rights reserved.
//

#import "TIFFLZWCompression.h"
#import "TIFFByteReader.h"

/**
 * Clear code
 */
NSInteger const TIFF_LZW_CLEAR_CODE = 256;

/**
 * End of information code
 */
NSInteger const TIFF_LZW_EOI_CODE = 257;

/**
 * Min bits
 */
NSInteger const TIFF_LZW_MIN_BITS = 9;

@interface TIFFLZWCompression()

@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSMutableArray<NSNumber *> *> *table;
@property (nonatomic) int maxCode;
@property (nonatomic) int byteLength;
@property (nonatomic) int position;

@end

@implementation TIFFLZWCompression

-(NSData *) decodeData: (NSData *) data withByteOrder: (CFByteOrder) byteOrder{
    
    // Create the byte reader and decoded stream to write to
    TIFFByteReader *reader = [[TIFFByteReader alloc] initWithData:data andByteOrder:byteOrder];
    NSOutputStream *decodedStream = [NSOutputStream outputStreamToMemory];
    [decodedStream open];
    
    // Initialize the table, starting position, and old code
    [self initializeTable];
    self.position = 0;
    int oldCode = 0;
    
    // Read codes until end of input
    int code = [self nextCodeWithReader:reader];
    while (code != TIFF_LZW_EOI_CODE) {
        
        // If a clear code
        if (code == TIFF_LZW_CLEAR_CODE) {
            
            // Reset the table
            [self initializeTable];
            
            // Read past clear codes
            code = [self nextCodeWithReader:reader];
            while (code == TIFF_LZW_CLEAR_CODE) {
                code = [self nextCodeWithReader:reader];
            }
            if (code == TIFF_LZW_EOI_CODE) {
                break;
            }
            if (code > TIFF_LZW_CLEAR_CODE) {
                [NSException raise:@"Corrupted Code" format:@"Corrupted code at scan line: %d", code];
            }
            
            // Write the code value
            NSMutableArray<NSNumber *> *value = [self.table objectForKey:[NSNumber numberWithInt:code]];
            [self writeValue:value toStream:decodedStream];
            oldCode = code;
            
        } else {
            
            // If already in the table
            NSArray<NSNumber *> *value = [self.table objectForKey:[NSNumber numberWithInt:code]];
            if (value != nil) {
                
                // Write the code value
                [self writeValue:value toStream:decodedStream];
                
                // Create new value and add to table
                NSMutableArray<NSNumber *> *newValue = [self concatArray:[self.table objectForKey:[NSNumber numberWithInt:oldCode]] withNumber:[[self.table objectForKey:[NSNumber numberWithInt:code]] objectAtIndex:0]];
                [self addToTableWithValue:newValue];
                oldCode = code;
                
            } else {
                
                // Create and write new value from old value
                NSArray<NSNumber *> *oldValue = [self.table objectForKey:[NSNumber numberWithInt:oldCode]];
                NSMutableArray<NSNumber *> *newValue = [self concatArray:oldValue withNumber:[oldValue objectAtIndex:0]];
                [self writeValue:newValue toStream:decodedStream];
                
                // Write value to the table
                [self addToTableWithCode:code andValue:newValue];
                oldCode = code;
            }
        }
        
        // Get the next code
        code = [self nextCodeWithReader:reader];
    }
    
    NSData *decoded = [decodedStream propertyForKey:NSStreamDataWrittenToMemoryStreamKey];
    
    [decodedStream close];
    
    return decoded;
}

/**
 * Initialize the table and byte length
 */
-(void) initializeTable{
    self.table = [[NSMutableDictionary alloc] init];
    for (int i = 0; i <= 257; i++) {
        [self.table setObject:[[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:i], nil] forKey:[NSNumber numberWithInt:i]];
    }
    self.maxCode = 257;
    self.byteLength = TIFF_LZW_MIN_BITS;
}

/**
 * Check the byte length and increase if needed
 */
-(void) checkByteLength{
    if (self.maxCode >= pow(2, self.byteLength) - 2) {
        self.byteLength++;
    }
}

/**
 * Add the value to the table
 *
 * @param value
 *            value
 */
-(void) addToTableWithValue: (NSMutableArray<NSNumber *> *) value{
    [self addToTableWithCode:self.maxCode + 1 andValue:value];
}

/**
 * Add the code and value to the table
 *
 * @param code
 *            code
 * @param value
 *            value
 */
-(void) addToTableWithCode: (int) code andValue: (NSMutableArray<NSNumber *> *) value{
    [self.table setObject:value forKey:[NSNumber numberWithInt:code]];
    self.maxCode = MAX(self.maxCode, code);
    [self checkByteLength];
}

/**
 * Concatenate the two values
 *
 * @param first
 *            first value
 * @param second
 *            second value
 * @return concatenated value
 */
-(NSMutableArray<NSNumber *> *) concatArray: (NSArray<NSNumber *> *) first withNumber: (NSNumber *) second{
    return [self concatArray:first withArray:[[NSArray alloc] initWithObjects:second, nil]];
}

/**
 * Concatenate the two values
 *
 * @param first
 *            first value
 * @param second
 *            second value
 * @return concatenated value
 */
-(NSMutableArray<NSNumber *> *) concatArray: (NSArray<NSNumber *> *) first withArray: (NSArray<NSNumber *> *) second{
    NSMutableArray<NSNumber *> *combined = [[NSMutableArray alloc] initWithArray:first];
    [combined addObjectsFromArray:second];
    return combined;
}

/**
 * Write the value to the decoded stream
 *
 * @param decodedStream
 *            decoded byte stream
 * @param value
 *            value
 */
-(void) writeValue: (NSArray<NSNumber *> *) value toStream: (NSOutputStream *) decodedStream{
    for (int i = 0; i < value.count; i++) {
        unsigned char byte = [[value objectAtIndex:i] unsignedCharValue];
        [decodedStream write:&byte maxLength:1];
    }
}

/**
 * Get the next code
 *
 * @param reader
 *            byte reader
 * @return code
 */
-(int) nextCodeWithReader: (TIFFByteReader *) reader{
    int nextByte = [self byteWithReader:reader];
    self.position += self.byteLength;
    return nextByte;
}

/**
 * Get the next byte
 *
 * @param reader
 *            byte reader
 * @return byte
 */
-(int) byteWithReader: (TIFFByteReader *) reader{

    int d = self.position % 8;
    int a = (int) floor(self.position / 8.0);
    int de = 8 - d;
    int ef = (self.position + self.byteLength) - ((a + 1) * 8);
    int fg = 8 * (a + 2) - (self.position + self.byteLength);
    int dg = (a + 2) * 8 - self.position;
    fg = MAX(0, fg);
    if (a >= [reader byteLength]) {
        NSLog(@"End of data reached without an end of input code");
        return TIFF_LZW_EOI_CODE;
    }
    int chunk1 = [[reader readUnsignedByteWithOffset:a] unsignedCharValue]
				& ((int) (pow(2, 8 - d) - 1));
    chunk1 = chunk1 << (self.byteLength - de);
    int chunks = chunk1;
    if (a + 1 < [reader byteLength]) {
        int chunk2 = [[reader readUnsignedByteWithOffset:a + 1] unsignedCharValue] >> fg;
        chunk2 = chunk2 << MAX(0, self.byteLength - dg);
        chunks += chunk2;
    }
    if (ef > 8 && a + 2 < [reader byteLength]) {
        int hi = (a + 3) * 8 - (self.position + self.byteLength);
        int chunk3 = [[reader readUnsignedByteWithOffset:a + 2] unsignedCharValue] >> hi;
        chunks += chunk3;
    }
    return chunks;
}

-(BOOL) rowEncoding{
    return false;
}

-(NSData *) encodeData: (NSData *) data withByteOrder: (CFByteOrder) byteOrder{
    [NSException raise:@"Not Implemented" format:@"LZW encoder is not yet implemented"];
    return data;
}

@end
