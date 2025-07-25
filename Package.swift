// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.
//
//  Package.swift
//  RiggerConnect iOS
//
//  Created by ChaseWhiteRabbit NGO on 2025-01-26.
//  Copyright © 2025 ChaseWhiteRabbit NGO. All rights reserved.
//  Licensed under GPL v3 - see LICENSE.md for details
//

import PackageDescription

let package = Package(
    name: "RiggerConnect",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .watchOS(.v8),
        .tvOS(.v15)
    ],
    products: [
        .library(
            name: "RiggerConnect",
            targets: ["RiggerConnect"]
        ),
        .library(
            name: "RiggerHub",
            targets: ["RiggerHub"]
        ),
        .library(
            name: "RiggerShared",
            targets: ["RiggerShared"]
        )
    ],
    dependencies: [
        // Firebase SDK
        .package(
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            from: "10.20.0"
        ),
        
        // Stripe iOS SDK
        .package(
            url: "https://github.com/stripe/stripe-ios.git",
            from: "23.24.0"
        ),
        
        // SwiftSoup for HTML parsing
        .package(
            url: "https://github.com/scinfu/SwiftSoup.git",
            from: "2.6.1"
        ),
        
        // Alamofire for networking
        .package(
            url: "https://github.com/Alamofire/Alamofire.git",
            from: "5.8.0"
        ),
        
        // SDWebImage for image loading
        .package(
            url: "https://github.com/SDWebImage/SDWebImage.git",
            from: "5.18.0"
        ),
        
        // Keychain Access
        .package(
            url: "https://github.com/kishikawakatsumi/KeychainAccess.git",
            from: "4.2.2"
        ),
        
        // SwiftUI Navigation
        .package(
            url: "https://github.com/pointfreeco/swiftui-navigation.git",
            from: "1.2.0"
        ),
        
        // Swift Collections
        .package(
            url: "https://github.com/apple/swift-collections.git",
            from: "1.0.0"
        ),
        
        // Swift Crypto
        .package(
            url: "https://github.com/apple/swift-crypto.git",
            from: "3.0.0"
        ),
        
        // Swift Log
        .package(
            url: "https://github.com/apple/swift-log.git",
            from: "1.5.0"
        )
    ],
    targets: [
        // RiggerConnect - Business facing app
        .target(
            name: "RiggerConnect",
            dependencies: [
                "RiggerShared",
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk"),
                .product(name: "FirebaseMessaging", package: "firebase-ios-sdk"),
                .product(name: "StripePaymentsUI", package: "stripe-ios"),
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "SDWebImage", package: "SDWebImage"),
                .product(name: "KeychainAccess", package: "KeychainAccess"),
                .product(name: "SwiftUINavigation", package: "swiftui-navigation"),
                .product(name: "Collections", package: "swift-collections"),
                .product(name: "Crypto", package: "swift-crypto"),
                .product(name: "Logging", package: "swift-log")
            ],
            path: "Sources/RiggerConnect",
            resources: [
                .process("Resources")
            ]
        ),
        
        // RiggerHub - Worker facing app
        .target(
            name: "RiggerHub",
            dependencies: [
                "RiggerShared",
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk"),
                .product(name: "FirebaseMessaging", package: "firebase-ios-sdk"),
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "SDWebImage", package: "SDWebImage"),
                .product(name: "KeychainAccess", package: "KeychainAccess"),
                .product(name: "SwiftUINavigation", package: "swiftui-navigation"),
                .product(name: "Collections", package: "swift-collections"),
                .product(name: "Crypto", package: "swift-crypto"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "SwiftSoup", package: "SwiftSoup")
            ],
            path: "Sources/RiggerHub",
            resources: [
                .process("Resources")
            ]
        ),
        
        // RiggerShared - Common libraries
        .target(
            name: "RiggerShared",
            dependencies: [
                .product(name: "Collections", package: "swift-collections"),
                .product(name: "Crypto", package: "swift-crypto"),
                .product(name: "Logging", package: "swift-log")
            ],
            path: "Sources/RiggerShared",
            resources: [
                .process("Resources")
            ]
        ),
        
        // RiggerConnectApp - iOS App executable
        .executableTarget(
            name: "RiggerConnectApp",
            dependencies: [
                "RiggerConnect",
                "RiggerShared",
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk"),
                .product(name: "FirebaseMessaging", package: "firebase-ios-sdk"),
                .product(name: "StripePaymentsUI", package: "stripe-ios"),
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "SDWebImage", package: "SDWebImage"),
                .product(name: "KeychainAccess", package: "KeychainAccess"),
                .product(name: "SwiftUINavigation", package: "swiftui-navigation"),
                .product(name: "Collections", package: "swift-collections"),
                .product(name: "Crypto", package: "swift-crypto"),
                .product(name: "Logging", package: "swift-log")
            ],
            path: "Apps/RiggerConnect",
            resources: [
                .process("Resources")
            ]
        ),
        
        // Test targets
        .testTarget(
            name: "RiggerConnectTests",
            dependencies: ["RiggerConnect"],
            path: "Tests/RiggerConnectTests"
        ),
        .testTarget(
            name: "RiggerHubTests",
            dependencies: ["RiggerHub"],
            path: "Tests/RiggerHubTests"
        ),
        .testTarget(
            name: "RiggerSharedTests",
            dependencies: ["RiggerShared"],
            path: "Tests/RiggerSharedTests"
        )
    ],
    swiftLanguageVersions: [.v5]
)
