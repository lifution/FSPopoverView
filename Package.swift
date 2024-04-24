// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(name: "FSPopoverView",
                      platforms: [.iOS(.v12)],
                      products: [
                          .library(name: "FSPopoverView", targets: ["FSPopoverView"])
                      ],
	                    targets: [
	                        .target(name: "FSPopoverView", path: "Sources")
                    	],
                      swiftLanguageVersions: [.v5]
)
