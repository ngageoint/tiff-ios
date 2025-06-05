// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "TIFF",
    platforms: [
        .iOS(.v13), .macOS(.v12)
    ],
    products: [
        .library(
            name: "TIFF",
            targets: ["TIFF"])
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "TIFF",
            dependencies: [
            ],
            path: "tiff-ios"
        ),
        .testTarget(
            name: "TiffTests",
            dependencies: [
                "TIFF"
            ],
            path: "tiff-iosTests",
            resources: [
                .copy("Resources/deflate.tiff"),
                .copy("Resources/float32.tiff"),
                .copy("Resources/float64.tiff"),
                .copy("Resources/initial.tiff"),
                .copy("Resources/int32.tiff"),
                .copy("Resources/interleave.tiff"),
                .copy("Resources/lzw_predictor_floating.tiff"),
                .copy("Resources/lzw_predictor.tiff"),
                .copy("Resources/lzw.tiff"),
                .copy("Resources/overviews.tiff"),
                .copy("Resources/packbits.tiff"),
                .copy("Resources/quad-jpeg.tif"),
                .copy("Resources/rgb.tiff"),
                .copy("Resources/small.tiff"),
                .copy("Resources/stripped.tiff"),
                .copy("Resources/tiled.tiff"),
                .copy("Resources/tiledplanar.tiff"),
                .copy("Resources/tiledplanarlzw.tiff"),
                .copy("Resources/uint32.tiff")
            ]
        ),
        .testTarget(
            name: "TiffTestsSwift",
            dependencies: [
                "TIFF"
            ],
            path: "tiff-iosTests-swift",
            resources: [
            ]
        )

    ]
)
