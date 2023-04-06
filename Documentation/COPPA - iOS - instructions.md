# Playwire SDK
###### COPPA Version 8.1.0 - iOS

> **COPPA applications** have a reduced set of networks providing ads for children. The documentation below is only to be used on COPPA applications.

## Tech Stack
- XCode 13 - Objective-C / Swift
- iOS target: 11.0

## Contents
- [Project Configuration](#project-configuration)
  - [CocoaPods dependencies](#cocoapods-dependencies)
  - [Info.plist](#infoplist)
    - [Playwire Mobile CLI tool](#playwire-mobile-cli-tool)
    - [Manual Configuration](#manual-configuration)
  - [Build Settings](#build-settings)
- [Usage](#usage)
  - [Initialization](#initialization)
  - [Firebase Initialization](#firebase-initialization)
  - [Test Ads](#test-ads)
  - [View Ads](#view-ads)
    - [Banner](#banner)
    - [Adaptive Anchored Banner](#adaptive-anchored-banner)
    - [Adaptive Inline Banner](#adaptive-inline-banner)
    - [Native Ad](#native-ad)
    - [View Ad Delegate](#view-ad-delegate)
  - [Fullscreen Ads](#full-screen-ads)
    - [Interstitial](#interstitial)
    - [Rewarded](#rewarded)
    - [Rewarded Interstitial](#rewarded-interstitial)
    - [App Open Ad](#app-open-ad)
    - [Full Screen Ads Delegate](#full-screen-ads-delegate)
  - [Migrate to SDK 6.0.0+](#migrate-to-sdk-600)
    - [SDK initialization](#sdk-initialization)
    - [Partner registration](#partner-registration)
  - [Migrate to SDK 8.1.0+](#migrate-to-sdk-810)
    - [iab/GDPR/CMP/TCF](#iabgdprcmptcf)
  - [Debugging and Analytics](#debugging-and-analytics)
    - [Registering a Listener into the Notifier](#registering-a-listener-into-the-notifier)
    - [Console Logger](#console-logger)

## Project Configuration
### CocoaPods dependencies

Integrate PlaywireSDK frameworks and dependencies.
Use [CocoaPods](https://guides.cocoapods.org/using/getting-started.html#getting-started) to install the Playwire SDK into your projects.

> **COPPA version** (**ONLY** to be used for **COPPA applications** as it has a reduced set of networks providing ads for children.)

```rb
source 'https://github.com/CocoaPods/Specs.git'
# declare you will use Playwire repository 
source 'https://github.com/intergi/playwire-ios-podspec'
use_frameworks!
# In your application target define Playwire pod

pod 'Playwire/Coppa', '8.1.0'
```

### Info.plist

You have 2 options to configure Info.plist file with mandatory values: manually or using the Playwire Mobile CLI tool to run commands via terminal. Select which one is more preferable for you and follow the instructions.

#### Playwire Mobile CLI tool

- See the instructions [here](https://docs.google.com/document/d/1xeAOWQWOrZXp22aYa5yf7s1J-60UZBhPxPjvQ43vPwM/edit#heading=h.7i983aw6sqxo) to install our Playwire Mobile CLI tool to your working machine.
- Playwire will provide you **publisher\_id** and **app\_id**, along with a config file. Use [the command](https://docs.google.com/document/d/1xeAOWQWOrZXp22aYa5yf7s1J-60UZBhPxPjvQ43vPwM/edit#heading=h.c5m1p39kmh7b) to get **GADApplicationIdentifier** and update your Info.plist with this value.
- Run [this command](https://docs.google.com/document/d/1xeAOWQWOrZXp22aYa5yf7s1J-60UZBhPxPjvQ43vPwM/edit#heading=h.mtvw5sts9f5i) to get the list of SKAdNetworkItems and update your Info.plist with this list.
> **Note**: In case any issues with the Playwire Mobile CLI tool contact your Playwire Account Manager to resolve issues or follow the Manual configuration section below.
#### Manual configuration

- Playwire will provide GADApplicationIdentifier, along with a config file. Add the **GADApplicationIdentifer** to the Info.plist file of your application.
- Search for skadnetworkids.xml, which is distributed together with this document, to get the complete [SKAdNetworkItems](https://developers.google.com/ad-manager/mobile-ads-sdk/ios/quick-start) array. Playwire will provide this as an XML file in an attached Google drive link.

```xml
    <plist version="1.0">
    <dict>
        <!--  Replace with your GAD App Identifier  -->
        <key>GADApplicationIdentifier</key>
        <string>YOUR_GAM_APP_ID</string>

        <key>SKAdNetworkItems</key>
        <array>
            <!--  A9 Inc  -->
            <dict>
                <key>SKAdNetworkIdentifier</key>
            <string>p78axxw29g.skadnetwork</string>
            </dict>
            <!--  ...  -->
        </array>
    </dict>
    </plist>
```

### Build Settings

If your project is Objective-C. *must be set to true.
```bash
Always Embed Swift Standard Libraries = true
```

## Usage
### Initialization
Initialization must be done from a ViewController and using the main thread.. This must be done during the early stage of your app life cycle.
Search for the initialization metadata (**publisherId** and **appId**) emailed by your Playwire Account Manager.
Completion Handler only will be called on initialization success and that means you can start requesting ads

###### Objective-C
[Initialization](https://github.com/intergi/playwire-ios-sample-app/blob/3e404417bca1f3efb9a94435a91ae8e4e4ce611d/PlaywireSDKAppsObjC/adtypes/AdTypesViewController.m#L39-L44)
###### Swift
[Initialization](https://github.com/intergi/playwire-ios-sample-app/blob/3e404417bca1f3efb9a94435a91ae8e4e4ce611d/PlaywireSDKAppsSwift/adtypes/AdTypesViewController.swift#L31-L33)

### Firebase Initialization
If you want to integrate Firebase into the project, see the [iOS Firebase guide](https://firebase.google.com/docs/ios/setup) to complete the integration properly. Make sure the project contains the **GoogleService-Info.plist** file and Firebase app configuration is called before Playwire SDK initialization.

###### Objective-C
[Firebase setup](https://github.com/intergi/playwire-ios-sample-app/blob/3e404417bca1f3efb9a94435a91ae8e4e4ce611d/PlaywireSDKAppsObjC/adtypes/AdTypesViewController.m#L39-L44)
###### Swift
[Firebase setup](https://github.com/intergi/playwire-ios-sample-app/blob/3e404417bca1f3efb9a94435a91ae8e4e4ce611d/PlaywireSDKAppsSwift/adtypes/AdTypesViewController.swift#L31-L33)

### Test Ads
In order to get **test** ads, the test property needs to be set to **true**. This can be done before the initialization. The recommended way would be to set the **test** to **true** for **debug** builds only. For banners, interstitials and app open ads, test mode will show a blue ad. For video ads, i.e - rewarded and rewarded interstitials, test mode will show an actual video instead of a blue ad.

###### Objective-C
[Test Ads](https://github.com/intergi/playwire-ios-sample-app/blob/e26a8c10a0d8721715e453d9e634878a04e4d8b7/PlaywireSDKAppsObjC/adtypes/AdTypesViewController.m#L65-L68)
###### Swift
[Test Ads](https://github.com/intergi/playwire-ios-sample-app/blob/e26a8c10a0d8721715e453d9e634878a04e4d8b7/PlaywireSDKAppsSwift/adtypes/AdTypesViewController.swift#L68-L71)

### View Ads
#### Banner

Banner ads are located in a spot within an app's layout, either at the top or bottom of the screen. Banners may stay on screen while a user is interacting with the app, and can be refreshed automatically or manually on a specific condition.

To show banner ads 4 sequential steps should be completed:

1. Instantiation
2. Configuration
3. Loading
4. Showing

These steps can be completely done using Storyboards but you can decide to make them through code.

[PWViewAdDelegate](#view-ad-delegate) provides methods to inform you about a view ad lifecycle. You can implement it to be notified about events regarding loading and ad content presentation status. See [PWViewAdDelegate](#view-ad-delegate) for more details.

###### Storyboard

Instantiation: You have to add a generic View to the Storyboard and change its Custom Class to **PWBannerView** and its Module to **Playwire**

<img src="screenshots/ios_banner_storyboard.png" style="display: block; margin: 0 auto"/>

You can configure your banner using runtime attributes

**adUnitName - String**: it’s the name in the config file identifying your banner. You can set this property or wait to be done by code.

**autoload - Boolean**: This property configures this banner to be loaded as soon your view is instantiated. If you don’t define this property or if you set this property to false, you must load your banner using code. You don’t have to set this to true if the adUnitName is not configured. It will throw an error.

###### Objective-C
[Banner Implementation via Storyboard](https://github.com/intergi/playwire-ios-sample-app/blob/playwiresdk/8.1.0/PlaywireSDKAppsObjC/ads/view/banner/BannerLayoutViewController.m)
###### Swift
[Banner Implementation via Storyboard](https://github.com/intergi/playwire-ios-sample-app/blob/playwiresdk/8.1.0/PlaywireSDKAppsSwift/ads/view/banner/BannerLayoutViewController.swift)

###### Source Code

If you do not use Storyboards in your app, you can make banners through code. See examples below how to configure a banner programmatically.

###### Objective-C
[Banner Implementation](https://github.com/intergi/playwire-ios-sample-app/blob/playwiresdk/8.1.0/PlaywireSDKAppsObjC/ads/view/banner/BannerViewController.m)
###### Swift
[Banner Implementation](https://github.com/intergi/playwire-ios-sample-app/blob/playwiresdk/8.1.0/PlaywireSDKAppsSwift/ads/view/banner/BannerViewController.swift)

##### Refresh
Depending on the banner configuration, it can be either automatically or manually refreshed or both. If a banner can be manually refreshed: you can fire a refresh in the banner as described below. 

###### Objective-C
[Refresh Implementation](https://github.com/intergi/playwire-ios-sample-app/blob/3e404417bca1f3efb9a94435a91ae8e4e4ce611d/PlaywireSDKAppsObjC/ads/view/banner/BannerViewController.m#L51-L54)
###### Swift
[Refresh Implementation](https://github.com/intergi/playwire-ios-sample-app/blob/3e404417bca1f3efb9a94435a91ae8e4e4ce611d/PlaywireSDKAppsSwift/ads/view/banner/BannerViewController.swift#L54-L57)

##### Adaptive Anchored Banner

Adaptive banners are the next generation of responsive ads, maximizing performance by optimizing ad size for each device. Improving on smart banners, which only supported fixed heights, adaptive banners let developers specify the ad-width and use this to determine the optimal ad size.

Adaptive banners are designed to be a drop-in replacement for the industry standard 320x50 banner size.

These banner sizes are commonly used as anchored banners, which are usually locked to the top or bottom of the screen. For such anchored banners, the aspect ratio when using adaptive banners will be similar to that of a standard 320x50.

As a difference with Normal Banners, at load time the actual width of the container view is taken into account. To do this you can either add the banner to the parent view before loading or send the required width as part of the load parameters.

###### Objective-C
[Anchored Banner Implementation](https://github.com/intergi/playwire-ios-sample-app/blob/playwiresdk/8.1.0/PlaywireSDKAppsObjC/ads/view/banner/AnchoredBannerViewController.m)
###### Swift
[Anchored Banner Implementation](https://github.com/intergi/playwire-ios-sample-app/blob/playwiresdk/8.1.0/PlaywireSDKAppsSwift/ads/view/banner/AnchoredBannerViewController.swift)

##### Adaptive Inline Banner
Inline adaptive banners are larger, taller banners compared to anchored adaptive banners. They are of variable height, and can be as tall as the device screen.

They are intended to be placed in scrolling content.

In addition to the required width you are required to define the device orientation at loading time. The current device orientation is used as a default in case you don’t define one.

###### Objective-C
[Inline Banner Implementation](https://github.com/intergi/playwire-ios-sample-app/blob/playwiresdk/8.1.0/PlaywireSDKAppsObjC/ads/view/banner/InlineBannerViewController.m)

###### Swift
[Inline Banner Implementation](https://github.com/intergi/playwire-ios-sample-app/blob/playwiresdk/8.1.0/PlaywireSDKAppsSwift/ads/view/banner/InlineBannerViewController.swift)

#### Native Ad

Native ads are ad assets that are presented to users via UI components that are native to the platform. They're shown using the same classes you already use in your storyboards, and can be formatted to match your app's visual design.

You have to create a View to display the ad content and configure this view with the ad data that is returned after the ad loading. You can create this view either programmatically or using Storyboard.

###### Storyboard

<img src="screenshots/ios_native_storyboard.png" style="display: block; margin: 0 auto"/>

At the top-left corner you will find the **ad attribution** view. When displaying programmatic native ads, you must display an ad attribution to denote that the view is an advertisement.

The **content view** is the main view containing all views that will display the ad data.

The **action view** is a special view that will redirect users to the ad related information when it’s clicked. It’s usually a button but you can decide as SDK only requires it to be a generic view.

The **media view** holder is a generic view used to hold the media content of the ad. It can be simply an image or it can be a video.

You can use any kind of view to display the ad content, you will be in charge of configuring the view based on the content when the ad is loaded. As an example, the star rating is usually a number between 0 and 5 and it is usually presented as a view with actual stars filled depending on the attribute value.

In order to interact with SDK to properly show the native ad you have to implement two protocols.

[PWViewAdDelegate](#view-ad-delegate) provides methods to inform you about a view ad lifecycle. You can implement it to be notified about events regarding loading and ad content presentation status. See [PWViewAdDelegate](#view-ad-delegate) for more details.

PWNativeViewFactory protocol provides methods being used by the SDK to get the view that has been configured using the ad content given by the SDK. A special method in this protocol is used to specify which view in the ad view is the action view that will be used to handle the user action.

###### Objective-C
[Custom Native Ad View](https://github.com/intergi/playwire-ios-sample-app/blob/playwiresdk/8.1.0/PlaywireSDKAppsObjC/ads/view/native/CustomNativeAdView.m)

[Native Ad Implementation](https://github.com/intergi/playwire-android-sample-app/blob/playwiresdk/8.0.1/demo-java/src/main/java/com/playwire/demo_java/ads/view/nativead/NativeAdActivity.java)
###### Swift
[Custom Native Ad View](https://github.com/intergi/playwire-ios-sample-app/blob/playwiresdk/8.1.0/PlaywireSDKAppsSwift/ads/view/native/CustomNativeAdView.swift)

[Native Ad Implementation](https://github.com/intergi/playwire-ios-sample-app/blob/playwiresdk/8.1.0/PlaywireSDKAppsSwift/ads/view/native/NativeAdViewController.swift)

#### View Ad Delegate

In order to receive events of view ads lifecycle, you have to implement the **PWViewAdDelegate** protocol and pass it during initialization of the selected view ad unit. The **PWViewAdDelegate** protocol handles callbacks when the ad content is loaded successfully or not, if the ad destination is presented or ad content is clicked.

###### Objective-C
```objc
#import <Playwire-Swift.h>

@interface ViewAdViewController () <PWViewAdDelegate>
@end

@implementation ViewAdViewController
- (void)viewAdDidLoad:(PWViewAd * _Nonnull)ad {
  // add your ad to ViewController’s view hierarchy if ad was not created in Storyboard
}
- (void)viewAdDidFailToLoad:(PWViewAd *_Nonnull)ad {}
- (void)viewAdWillPresentFullScreenContent:(PWViewAd * _Nonnull)ad {}
- (void)viewAdWillDismissFullScreenContent:(PWViewAd * _Nonnull)ad {}
- (void)viewAdDidDismissFullScreenContent:(PWViewAd * _Nonnull)ad {}
- (void)viewAdDidRecordImpression:(PWViewAd * _Nonnull)ad {}
- (void)viewAdDidRecordClick:(PWViewAd * _Nonnull)ad {}
@end
```

###### Swift
```swift
extension ViewAdViewController: PWViewAdDelegate {
    func viewADidLoad(_ ad: PWViewAd) {
      // add your ad to ViewController’s view hierarchy if ad was not created in Storyboard
    }
    func viewAdDidFailToLoad(_ ad: PWViewAd) {}
    func viewAdWillPresentFullScreenContent(_ ad: PWViewAd) {}
    func viewAdWillDismissFullScreenContent(_ ad: PWViewAd) {}
    func viewAdDidDismissFullScreenContent(_ ad: PWViewAd) {}
    func viewAdDidRecordImpression(_ ad: PWViewAd) {}
    func viewAdDidRecordClick(_ ad: PWViewAd) {}
}
```

### Full Screen Ads
#### Interstitial

Interstitial ad is a full-screen ad that covers the interface of an app until closed by a user.

Once an interstitial ad is presented, a user may redirect to ad destination or close and back to the application.

To display an interstitial ad on your app, you must first request it and provide the ad unit.

When requesting  an interstitial ad, we recommend that you do so in advance before planning to present it to your user as the loading process may take time.

[PWFullScreenAdDelegate](#full-screen-ads-delegate) provides methods to inform you about an interstitial ad lifecycle. You can implement it to be notified about events regarding loading and presentation status. See [PWFullScreenAdDelegate](#full-screen-ads-delegate) for more details.

###### Objective-C
[Interstitial Implementation](https://github.com/intergi/playwire-ios-sample-app/blob/playwiresdk/8.1.0/PlaywireSDKAppsObjC/ads/fullscreen/interstitial/InterstitialViewController.m)
###### Swift
[Interstitial Implementation](https://github.com/intergi/playwire-ios-sample-app/blob/playwiresdk/8.1.0/PlaywireSDKAppsSwift/ads/fullscreen/interstitial/InterstitialViewController.swift)

> **Note**: An interstitial ad is a one-time-use object, which means it must be initialized and loaded again after its presentation.

#### Rewarded
Rewarded ad is a full-screen ad that covers the interface of an app until closed by a user. It is used to give the option for a user to earn some in-app rewards, which are configured during ad unit creation. A user is given the option to watch a video ad or view a display ad to receive an in-app reward, e.g. a new level or an extra life in a game, access to premium content, etc.

To display a rewarded ad on your app, you must first request it and provide the ad unit.

When requesting a rewarded ad, we recommend that you do so in advance before planning to present it to your user as the loading process may take time.

[FullScreenAdDelegate](#full-screen-ads-delegate) provides methods to inform you about a rewarded ad lifecycle. You can implement it to be notified about events regarding loading and presentation status. See [FullScreenAdDelegate](#full-screen-ads-delegate) for more details.
###### Objective-C
[Rewarded Implementation](https://github.com/intergi/playwire-ios-sample-app/blob/playwiresdk/8.1.0/PlaywireSDKAppsObjC/ads/fullscreen/rewarded/RewardedViewController.m)
###### Swift
[Rewarded Implementation](https://github.com/intergi/playwire-ios-sample-app/blob/playwiresdk/8.1.0/PlaywireSDKAppsSwift/ads/fullscreen/rewarded/RewardedViewController.swift)

> **Note**: A rewarded ad is a one-time-use object, which means it must be initialized and loaded again after its presentation.

#### Rewarded Interstitial

Rewarded interstitial is a full-screen ad that covers the interface of an app until closed by a user. This type of ad format allows you to offer in-app rewards for ads that can appear automatically during app transitions. Rewards may be represented as any in-app values, e.g. a new level or an extra life in a game, access to premium content, etc.

To display a rewarded interstitial ad on your app, you must first request it and provide the ad unit.

When requesting a rewarded interstitial ad, we recommend that you do so in advance before planning to present it to your user as the loading process may take time.

[FullScreenAdDelegate](#full-screen-ads-delegate) provides methods to inform you about a rewarded interstitial ad lifecycle. You can implement it to be notified about events regarding loading and presentation status. See [FullScreenAdDelegate](#full-screen-ads-delegate) for more details.

###### Objective-C
[Rewarded Interstitial Implementation](https://github.com/intergi/playwire-ios-sample-app/blob/playwiresdk/8.1.0/PlaywireSDKAppsObjC/ads/fullscreen/rewarded/RewardedInterstitialViewController.m)
###### Swift
[Rewarded Interstitial Implementation](https://github.com/intergi/playwire-ios-sample-app/blob/playwiresdk/8.1.0/PlaywireSDKAppsSwift/ads/fullscreen/rewarded/RewardedInterstitialViewController.swift)
> **Note**: A rewarded interstitial ad is a one-time-use object, which means it must be initialized and loaded again after its presentation.

#### App Open Ad

App open ads are a special ad format intended for publishers wishing to monetize their app load screens. This format of ads can be shown when a user brings the app to the foreground.

To request an app open ad you have to make initialization first.

An app open ad will time out after four hours. If you present an ad content that was requested for more than four hours, it will no longer be valid and may not earn revenue.

To ensure you do not show an expired ad, you can check how long it has been since your ad loaded and reload it manually, or you may enable **autoReloadOnExpiration** to let the PlaywireSDK monitor the ad expiration and take care about reloading the expired ad. It is disabled by default.

When your app displays an app open ad, you should rely on the [PWFullScreenAdDelegate](#full-screen-ads-delegate) to handle presentation events. In particular, you’ll want to request the next app open ad once the first one finishes presenting.

As app open ads are designed to be shown when a user brings your app to the foreground, you need to listen to the application state changes.

###### Objective-C
[App Open Ad Implementation](https://github.com/intergi/playwire-ios-sample-app/blob/playwiresdk/8.1.0/PlaywireSDKAppsObjC/ads/fullscreen/appopenad/AppOpenAdViewController.m)
###### Swift
[App Open Ad Implementation](https://github.com/intergi/playwire-ios-sample-app/blob/playwiresdk/8.1.0/PlaywireSDKAppsSwift/ads/fullscreen/appopenad/AppOpenAdViewController.swift)

> **Note**: An app open ad is a one-time-use object, which means it must be initialized and loaded again after its presentation.

#### Full Screen Ads Delegate 

In order to receive events of full screen ads lifecycle, you have to implement the **PWFullScreenAdDelegate** protocol and pass it during initialization of the selected full screen ad unit. The **PWFullScreenAdDelegate** protocol handles callbacks when the ad content is loaded successfully or not, if the ad is presented, when it is dismissed and a reward-compatible ads earned a reward.

###### Objective-C
```objc
#import <Playwire-Swift.h>

@interface FullScreenAdViewController () <PWFullScreenAdDelegate>
@end

@implementation FullScreenAdViewController
- (void)fullScreenAdDidLoad:(PWFullScreenAd * _Nonnull)ad {}
- (void)fullScreenAdDidFailToLoad:(PWFullScreenAd *_Nonnull)ad {}
- (void)fullScreenAdWillPresentFullScreenContent:(PWFullScreenAd * _Nonnull)ad {}
- (void)fullScreenAdDidFailToPresentFullScreenContent:(PWFullScreenAd * _Nonnull)ad {}
- (void)fullScreenAdWillDismissFullScreenContent:(PWFullScreenAd * _Nonnull)ad {}
- (void)fullScreenAdDidDismissFullScreenContent:(PWFullScreenAd * _Nonnull)ad {}
- (void)fullScreenAdDidRecordImpression:(PWFullScreenAd * _Nonnull)ad {}
- (void)fullScreenAdDidRecordClick:(PWFullScreenAd * _Nonnull)ad {}
- (void)fullScreenAdDidUserEarn:(PWFullScreenAd * _Nonnull)ad 
                           type:(NSString * _Nonnull)type 
                         amount:(double)amount {}
@end
```

###### Swift
```swift
extension FullScreenAdViewController: PWFullScreenAdDelegate {
    func fullScreenAdDidLoad(_ ad: PWFullScreenAd) {}
    func fullScreenAdDidFailToLoad(_ ad: PWFullScreenAd) {}
    func fullScreenAdWillPresentFullScreenContent(_ ad: PWFullScreenAd) {}
    func fullScreenAdDidFailToPresentFullScreenContent(_ ad: PWFullScreenAd) {}
    func fullScreenAdWillDismissFullScreenContent(_ ad: PWFullScreenAd) {}
    func fullScreenAdDidDismissFullScreenContent(_ ad: PWFullScreenAd) {}
    func fullScreenAdDidRecordImpression(_ ad: PWFullScreenAd) {}
    func fullScreenAdDidRecordClick(_ ad: PWFullScreenAd) {}
    func fullScreenAdDidUserEarn(_ ad: PWFullScreenAd, type: String, amount: Double) {}
}
```

### Migrate to SDK 6.0.0+
The Playwire SDK version 6.0.0 contains a few major changes in public APIs. Follow this section to check what has been changed.
#### SDK initialization
- No version is required in SDK initialization. SDK will get the right version from the backend
- Initialization callback will only be called on success to start requesting ads.

#### Partner registration
SDK will automatically register for you all available header bidders and mediation partners

### Migrate to SDK 8.1.0+
Loading-time parameters have been added. This has been reflected in the Adaptive Banners section.
#### iab/GDPR/CMP/TCF
To comply with the [General Data Protection Regulation (GDPR) of the Interactive Advertising Bureau (iab)](https://www.iab.com/topics/privacy/gdpr/), PlaywireSDK uses a Consent Management Platform (CMP) compatible with the iab [Transparence and Consent Framework (TCF)](https://github.com/InteractiveAdvertisingBureau/GDPR-Transparency-and-Consent-Framework/tree/master/TCFv2)

If you want to use your own CMP, in order to avoid colliding with the CMP used by PlaywireSDK, it has to be compatible with TCF.
You have to launch your CMP and wait for the user response before you initialize our SDK.

### Debugging and Analytics

For debugging and analytics purposes, Playwire SDK offers a notifier that acts as a broadcaster of events. Diverse modules within the SDK send events to the notifier, which then broadcasts those events to all registered listeners.

### Registering a Listener into the Notifier
A publisher can register a custom-made listener to handle events with custom actions as it’s explained below.

###### Objective-C
[Event Listener](https://github.com/intergi/playwire-ios-sample-app/blob/e26a8c10a0d8721715e453d9e634878a04e4d8b7/PlaywireSDKAppsObjC/adtypes/AdTypesViewController.m#L49-L57)

[Event Listener Cancellation](https://github.com/intergi/playwire-ios-sample-app/blob/e26a8c10a0d8721715e453d9e634878a04e4d8b7/PlaywireSDKAppsObjC/adtypes/AdTypesViewController.m#L102-L104)

###### Swift
[Event Listener](https://github.com/intergi/playwire-ios-sample-app/blob/e26a8c10a0d8721715e453d9e634878a04e4d8b7/PlaywireSDKAppsSwift/adtypes/AdTypesViewController.swift#L50-L58)

[Event Listener Cancellation](https://github.com/intergi/playwire-ios-sample-app/blob/e26a8c10a0d8721715e453d9e634878a04e4d8b7/PlaywireSDKAppsSwift/adtypes/AdTypesViewController.swift#L24-L26)

In the examples above:
- **addListener**: adds a new listener into the notifier;
- **self**: is the actual listener; whenever self is cleaned from memory, listener will be cleaned too;
- **filter**: the block of code to select which events will be addressed by the action block, based on event name, critical status and event context;
- **action**: handles the event data.

### Console Logger
A default listener is available to log events to the console. It can be launched on the notifier for all events or passing a filter as a parameter to select what events should be logged.

###### Objective-C
[Console Logger](https://github.com/intergi/playwire-ios-sample-app/blob/e26a8c10a0d8721715e453d9e634878a04e4d8b7/PlaywireSDKAppsObjC/adtypes/AdTypesViewController.m#L36-L47)

###### Swift
[Console Logger](https://github.com/intergi/playwire-ios-sample-app/blob/e26a8c10a0d8721715e453d9e634878a04e4d8b7/PlaywireSDKAppsSwift/adtypes/AdTypesViewController.swift#L35-L48)