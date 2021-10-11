# Change Log
All notable changes to this project will be documented in this file.
Adheres to [Semantic Versioning](http://semver.org/).

---

## 3.0.1 (TBD)

* FileDirectory setModelPixelScale and setModelTiepoint methods

## [3.0.0](https://github.com/ngageoint/tiff-ios/releases/tag/3.0.0) (03-01-2021)

* iOS platform and deployment target 12.0

## [2.0.0](https://github.com/ngageoint/tiff-ios/releases/tag/2.0.0) (07-20-2020)

* Model pixel scale and model tiepoint retrieval methods
* Method renames to drop "get" prefix

## [1.1.2](https://github.com/ngageoint/tiff-ios/releases/tag/1.1.2) (04-03-2019)

* xResolution and yResolution write fix
* Skip unknown tags while reading
* Allow headers to be read for unsupported compression types
* JPEG field tags

## [1.1.1](https://github.com/ngageoint/tiff-ios/releases/tag/1.1.1) (09-24-2018)

* Xcode 10 fix
* Dropping "geopackage" from library name

## [1.1.0](https://github.com/ngageoint/tiff-ios/releases/tag/1.1.0) (11-21-2017)

* TIFF Field Type sample format utilities
* Rasters initializer support for multiple samples per pixel
* Handle missing samples per pixel with default value of 1
* Public access to tiff tags
* String Entry Value getter and setter

## [1.0.3](https://github.com/ngageoint/tiff-ios/releases/tag/1.0.3) (07-10-2017)

* Handle writing file directory entry ASCII values ending with more than one null

## [1.0.2](https://github.com/ngageoint/tiff-ios/releases/tag/1.0.2) (06-13-2017)

* Handle fewer SampleFormat values specified than SamplesPerPixel. Defaults to 1 (unsigned integer data)

## [1.0.1](https://github.com/ngageoint/tiff-ios/releases/tag/1.0.1) (03-02-2017)

* LZW Compression modified to handle non contiguous table codes

## [1.0.0](https://github.com/ngageoint/tiff-ios/releases/tag/1.0.0) (01-24-2017)

* Initial Release
