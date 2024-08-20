//
//  AppOpenAdCoordinator.swift
//  PlaywireSDKAppsSwiftUI
//
//

import SwiftUI
import Playwire

class AppOpenAdCoordinator: ObservableObject {
    
    // The ad unit name, e.g. 'banner-320x50', 'interstitial-home', 'rewarded-coins', etc.
    private let adUnitName: String
    private let viewController: UIViewController
    private var appOpenAd: PWAppOpenAd?
    
    @Published var state: FullScreenAdState = .none

    init(adUnitName: String, viewController: UIViewController) {
        self.adUnitName = adUnitName
        self.viewController = viewController
        subscribeToAppStateNotifications()
        
    }
    
    func load() {
        
        appOpenAd = PWAppOpenAd(adUnitName: adUnitName, viewController: viewController, delegate: self)

        // Ads rendered more than four hours after request time will no longer be valid and may not earn revenue.
        // Enable the property below to start loading new ad automatically if more than a certain number of hours have passed since your ad loaded.
        // It equals to `false` by default.
        appOpenAd?.autoReloadOnExpiration = true
        
        // Use `PWLoadParams().withTargeting()` to pass your custom targets to ad request.
        // Use `PWLoadParams().withDeviceOrientation()` to pass the orientation you want to use in the ad request.
        // let params = PWLoadParams()
        //  .withDeviceOrientation(.portrait)
        //  .withTargeting(
        //  [
        //    "age": "18-32",
        //    "page": "travel"
        //  ]
        // )
        // appOpenAd?.load(params: params)
        
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
    
    private func subscribeToAppStateNotifications() {
        // Observe an app state to show the ad when a user open the app.
        // As alternative you can handle an app state in the `SceneDelegate`.
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleBecomeActiveState),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    @objc
    private func handleBecomeActiveState() {
        show()
    }
}

// MARK: - PWFullScreenAdDelegate -
extension AppOpenAdCoordinator: PWFullScreenAdDelegate {
    
    func fullScreenAdDidLoad(_ ad: PWFullScreenAd) {
        state = .loaded
    }
    
    func fullScreenAdDidFailToLoad(_ ad: PWFullScreenAd) {
        state = .failed
    }
    
    func fullScreenAdWillPresentFullScreenContent(_ ad: PWFullScreenAd) {
    }
    
    func fullScreenAdWillDismissFullScreenContent(_ ad: PWFullScreenAd) {
    }
    
    func fullScreenAdDidDismissFullScreenContent(_ ad: PWFullScreenAd) {
        appOpenAd = nil
        
        // Load app open ad content to be ready for the next presentation
        load()
    }
    
    func fullScreenAdDidFailToPresentFullScreenContent(_ ad: PWFullScreenAd) {
        state = .failedToPresent
        appOpenAd = nil
    }
    
    func fullScreenAdDidRecordImpression(_ ad: PWFullScreenAd) {
        state = .presented
    }
    
    func fullScreenAdDidRecordClick(_ ad: PWFullScreenAd) {
    }
    
    func fullScreenAdDidUserEarn(_ ad: PWFullScreenAd, type: String, amount: Double) {
    }
}
