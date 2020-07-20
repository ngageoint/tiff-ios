//
//  TIFFSwiftReadmeTest.swift
//  tiff-iosTests
//
//  Created by Brian Osborn on 7/20/20.
//  Copyright © 2020 NGA. All rights reserved.
//

import XCTest

class TIFFSwiftReadmeTest: XCTestCase{
    
    /**
     * Test write and read
     */
    func testWriteAndRead(){
        testRead(testWrite())
    }
    
    /**
     * Test read
     */
    func testRead(_ data: Data){
        
        // let data: Data = ...
        // let file: String = ...
        // let stream: NSInputStream = ...
        // let reader: TIFFByteReader = ...

        let tiffImage: TIFFImage = TIFFReader.readTiff(from: data)
        // let tiffImage: TIFFImage = TIFFReader.readTiff(fromFile: file)
        // let tiffImage: TIFFImage = TIFFReader.readTiff(from: stream)
        // let tiffImage: TIFFImage = TIFFReader.readTiff(from: reader)
        let directories: [TIFFFileDirectory] = tiffImage.fileDirectories()
        let directory: TIFFFileDirectory = directories[0]
        let rasters: TIFFRasters = directory.readRasters()
        
    }
    
    /**
     * Test write
     */
    func testWrite() -> Data{
        
        let width: UInt16 = 256
        let height: UInt16 = 256
        let samplesPerPixel: UInt16 = 1
        let bitsPerSample: UInt16 = 32

        let rasters: TIFFRasters = TIFFRasters(width: Int32(width), andHeight: Int32(height), andSamplesPerPixel: Int32(samplesPerPixel), andSingleBitsPerSample: Int32(bitsPerSample))

        let rowsPerStrip: UInt16 = UInt16(rasters.calculateRowsPerStrip(withPlanarConfiguration: Int32(TIFF_PLANAR_CONFIGURATION_CHUNKY)))

        let directory: TIFFFileDirectory = TIFFFileDirectory()
        directory.setImageWidth(width)
        directory.setImageHeight(height)
        directory.setBitsPerSampleAsSingleValue(bitsPerSample)
        directory.setCompression(UInt16(TIFF_COMPRESSION_NO))
        directory.setPhotometricInterpretation(UInt16(TIFF_PHOTOMETRIC_INTERPRETATION_BLACK_IS_ZERO))
        directory.setSamplesPerPixel(samplesPerPixel)
        directory.setRowsPerStrip(rowsPerStrip)
        directory.setPlanarConfiguration(UInt16(TIFF_PLANAR_CONFIGURATION_CHUNKY))
        directory.setSampleFormatAsSingleValue(UInt16(TIFF_SAMPLE_FORMAT_FLOAT))
        directory.writeRasters = rasters

        for y in 0..<height {
            for x in 0..<width {
                let pixelValue: Float = 1.0 // any pixel value
                rasters.setFirstPixelSampleAtX(Int32(x), andY: Int32(y), withValue: NSDecimalNumber(value: pixelValue))
            }
        }

        let tiffImage: TIFFImage = TIFFImage()
        tiffImage.addFileDirectory(directory)
        let data: Data = TIFFWriter.writeTiffToData(with: tiffImage)
        // or
        // let file: String = ...
        // TIFFWriter.writeTiff(withFile: file, andImage: tiffImage)
        
        return data
    }
    
}

