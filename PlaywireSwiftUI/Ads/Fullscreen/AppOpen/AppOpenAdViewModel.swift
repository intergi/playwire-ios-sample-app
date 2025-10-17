//
//  AppOpenAdViewModel.swift
//  PlaywireSDKAppsSwiftUI
//
//

import SwiftUI
import Playwire
import Observation

@Observable class AppOpenAdViewModel {
    
    // The ad unit name, e.g. 'banner-320x50', 'interstitial-home', 'rewarded-coins', etc.
    private let adUnitName: String
    private let viewController: UIViewController
    private var appOpenAd: PWAppOpenAd?
    
    var state: FullScreenAdState = .none

    init(adUnitName: String, viewController: UIViewController) {
        self.adUnitName = adUnitName
        self.viewController = viewController
    }
    
    func load() {
        appOpenAd = PWAppOpenAd(adUnitName: adUnitName, viewController: viewController, delegate: self)

        // Ads rendered more than four hours after request time will no longer be valid and may not earn revenue.
        // Enable the property below to start loading new ad automatically if more than a certain number of hours have passed since your ad loaded.
        // It equals to `false` by default.
        appOpenAd?.autoReloadOnExpiration = true
        
        // Use `PWLoadParams().withTargeting()` to pass your custom targets to ad request.
        // Use `PWLoadParams().withDeviceOrientation()` to pass the orientation you want to use in the ad request.
//         let params = PWLoadParams()
//          .withDeviceOrientation(.portrait)
//          .withTargeting(
//          [
//            "age": "18-32",
//            "page": "travel"
//          ]
//         )
//         appOpenAd?.load(params: params)
        
        appOpenAd?.load()
        
        state = .loading
    }

    func show() {
        guard appOpenAd?.isLoaded == true else {
            // Load app open ad one more time or notify a user about error
            return
        }
        appOpenAd?.show()
    }
}

extension AppOpenAdViewModel: PWFullScreenAdDelegate {
    
    func fullScreenAdDidLoad(_ ad: PWFullScreenAd) {
        state = .loaded
        show()
    }
    
    func fullScreenAdDidFailToLoad(_ ad: PWFullScreenAd) {
        state = .failed
    }
    
    func fullScreenAdWillPresentFullScreenContent(_ ad: PWFullScreenAd) {
    }
    
    func fullScreenAdWillDismissFullScreenContent(_ ad: PWFullScreenAd) {
    }
    
    func fullScreenAdDidDismissFullScreenContent(_ ad: PWFullScreenAd) {
    }
    
    func fullScreenAdDidFailToPresentFullScreenContent(_ ad: PWFullScreenAd) {
        state = .failedToPresent
    }
    
    func fullScreenAdDidRecordImpression(_ ad: PWFullScreenAd) {
        state = .presented
    }
    
    func fullScreenAdDidRecordClick(_ ad: PWFullScreenAd) {
    }
    
    func fullScreenAdDidUserEarn(_ ad: PWFullScreenAd, type: String, amount: Double) {
    }
}
