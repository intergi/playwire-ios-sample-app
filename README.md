# Playwire iOS Sample Apps

These samples show how to install Playwire with CocoaPods or Swift Package Manager and use it from Objective-C, Swift, or SwiftUI. Both dependency-manager projects reference the same app sources, so only the installation changes between examples.

Playwire version: `13.0.1`. The SDK supports iOS 13 and later; these sample apps currently target iOS 26.

## Choose a Sample

| Installation | Objective-C | Swift | SwiftUI |
| --- | --- | --- | --- |
| CocoaPods | Open `CocoaPods/PlaywireSDKApps-CocoaPods.xcworkspace` and run `PlaywireObjC` | Open `CocoaPods/PlaywireSDKApps-CocoaPods.xcworkspace` and run `PlaywireSwift` | Open `CocoaPods/PlaywireSDKApps-CocoaPods.xcworkspace` and run `PlaywireSwiftUI` |
| Swift Package Manager | Open `SwiftPackageManager/PlaywireSDKApps-SPM.xcodeproj` and run `PlaywireObjC` | Open `SwiftPackageManager/PlaywireSDKApps-SPM.xcodeproj` and run `PlaywireSwift` | Open `SwiftPackageManager/PlaywireSDKApps-SPM.xcodeproj` and run `PlaywireSwiftUI` |

## CocoaPods

Install dependencies from the repository root:

```sh
cd CocoaPods
pod install
open PlaywireSDKApps-CocoaPods.xcworkspace
```

Select `PlaywireObjC`, `PlaywireSwift`, or `PlaywireSwiftUI`, then run the app.

## Swift Package Manager

Open the project:

```sh
open SwiftPackageManager/PlaywireSDKApps-SPM.xcodeproj
```

Xcode resolves `https://github.com/intergi/playwire-ios-spm.git` automatically. Select `PlaywireObjC`, `PlaywireSwift`, or `PlaywireSwiftUI`, then run the app.

## Repository Layout

- `Apps/` contains the shared Objective-C, Swift, and SwiftUI sample sources.
- `CocoaPods/` contains CocoaPods installation configuration.
- `SwiftPackageManager/` contains Swift Package Manager installation configuration.