# TIFF iOS

#### Tagged Image File Format Lib ####

The [GeoPackage Libraries](http://ngageoint.github.io/GeoPackage/) were developed at the [National Geospatial-Intelligence Agency (NGA)](http://www.nga.mil/) in collaboration with [BIT Systems](https://www.caci.com/bit-systems/). The government has "unlimited rights" and is releasing this software to increase the impact of government investments by providing developers with the opportunity to take things in new directions. The software use, modification, and distribution rights are stipulated within the [MIT license](http://choosealicense.com/licenses/mit/).

### Pull Requests ###
If you'd like to contribute to this project, please make a pull request. We'll review the pull request and discuss the changes. All pull request contributions to this project will be released under the MIT license.

Software source code previously released under an open source license and then modified by NGA staff is considered a "joint work" (see 17 USC § 101); it is partially copyrighted, partially public domain, and as a whole is protected by the copyrights of the non-government authors and must be released according to the terms of the original open source license.

### About ###

[TIFF](http://ngageoint.github.io/tiff-ios/) is an iOS Objective-C library for reading and writing Tagged Image File Format files. It was primarily created to provide license friendly TIFF functionality to iOS applications. Implementation is based on the [TIFF specification](https://partners.adobe.com/public/developer/en/tiff/TIFF6.pdf) and this JavaScript implementation: https://github.com/constantinius/geotiff.js

### Usage ###

View the latest [Appledoc](http://ngageoint.github.io/tiff-ios/docs/api/)

#### Read ####

```objectivec

// NSData *data = ...;
// NSString *file = ...;
// NSInputStream *stream = ...;
// TIFFByteReader *reader = ...;

TIFFImage *tiffImage = [TIFFReader readTiffFromData:data];
// TIFFImage *tiffImage = [TIFFReader readTiffFromFile:file];
// TIFFImage *tiffImage = [TIFFReader readTiffFromStream:stream];
// TIFFImage *tiffImage = [TIFFReader readTiffFromReader:reader];
NSArray<TIFFFileDirectory *> *directories = [tiffImage fileDirectories];
TIFFFileDirectory *directory  = [directories objectAtIndex:0];
TIFFRasters *rasters = [directory readRasters];

```

#### Write ####

```objectivec

int width = 256;
int height = 256;
int samplesPerPixel = 1;
int bitsPerSample = 32;

TIFFRasters *rasters = [[TIFFRasters alloc] initWithWidth:width andHeight:height andSamplesPerPixel:samplesPerPixel andSingleBitsPerSample:bitsPerSample];

int rowsPerStrip = [rasters calculateRowsPerStripWithPlanarConfiguration:(int)TIFF_PLANAR_CONFIGURATION_CHUNKY];

TIFFFileDirectory *directory = [[TIFFFileDirectory alloc] init];
[directory setImageWidth: width];
[directory setImageHeight: height];
[directory setBitsPerSampleAsSingleValue: bitsPerSample];
[directory setCompression: TIFF_COMPRESSION_NO];
[directory setPhotometricInterpretation: TIFF_PHOTOMETRIC_INTERPRETATION_BLACK_IS_ZERO];
[directory setSamplesPerPixel: samplesPerPixel];
[directory setRowsPerStrip: rowsPerStrip];
[directory setPlanarConfiguration: TIFF_PLANAR_CONFIGURATION_CHUNKY];
[directory setSampleFormatAsSingleValue: TIFF_SAMPLE_FORMAT_FLOAT];
[directory setWriteRasters: rasters];

for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
        float pixelValue = 1.0; // any pixel value
        [rasters setFirstPixelSampleAtX:x andY:y withValue:[[NSDecimalNumber alloc] initWithFloat:pixelValue]];
    }
}

TIFFImage *tiffImage = [[TIFFImage alloc] init];
[tiffImage addFileDirectory:directory];
NSData *data = [TIFFWriter writeTiffToDataWithImage:tiffImage];
// or
// NSString *file = ...;
// [TIFFWriter writeTiffWithFile:file andImage:tiffImage];

```

### Build ###

[![Build & Test](https://github.com/ngageoint/tiff-ios/workflows/Build%20&%20Test/badge.svg)](https://github.com/ngageoint/tiff-ios/actions/workflows/build-test.yml)

Build this repository using Xcode and/or CocoaPods:

    pod install

Open tiff-ios.xcworkspace in Xcode or build from command line:

    xcodebuild -workspace 'tiff-ios.xcworkspace' -scheme tiff-ios build

Run tests from Xcode or from command line:

    xcodebuild test -workspace 'tiff-ios.xcworkspace' -scheme tiff-ios -destination 'platform=iOS Simulator,name=iPhone 14'

### Include Library ###

Include this repository by specifying it in a Podfile using a supported option.

Pull from [CocoaPods](https://cocoapods.org/pods/tiff-ios):

    pod 'tiff-ios', '~> 4.0.1'

Pull from GitHub:

    pod 'tiff-ios', :git => 'https://github.com/ngageoint/tiff-ios.git', :branch => 'master'
    pod 'tiff-ios', :git => 'https://github.com/ngageoint/tiff-ios.git', :tag => '4.0.1'

Include as local project:

    pod 'tiff-ios', :path => '../tiff-ios'

### Swift ###

To use from Swift, import the tiff-ios bridging header from the Swift project's bridging header

    #import "tiff-ios-Bridging-Header.h"

#### Read ####

```swift

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

```

#### Write ####

```swift

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

```
