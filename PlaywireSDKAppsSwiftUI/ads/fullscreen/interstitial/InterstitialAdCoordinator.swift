//
//  InterstitialAdCoordinator.swift
//  PlaywireSDKAppsSwiftUI
//
//

import SwiftUI
import Playwire

class InterstitialAdCoordinator: ObservableObject {
    
    // The ad unit name, e.g. 'banner-320x50', 'interstitial-home', 'rewarded-coins', etc.
    private let adUnitName: String
    private var interstitial: PWInterstitial?
    
    @Published var state: FullScreenAdState = .none

    init(adUnitName: String) {
        self.adUnitName = adUnitName
    }
    
    func load() {
        interstitial = PWInterstitial(adUnitName: adUnitName, delegate: self)
        
        // Use `PWLoadParams().withTargeting()` to pass your custom targets to ad request.
        // let params = PWLoadParams().withTargeting(
        //  [
        //    "age": "18-32",
        //    "page": "travel"
        //  ]
        // )
        // interstitial?.load(params: params)
        
        interstitial?.load()
        state = .loading
    }

    func show(from viewController: UIViewController) {
        guard interstitial?.isLoaded == true else {
            // Load interstitial one more time or notify a user about error
            return
        }
        interstitial?.show(fromViewController: viewController)
    }
}

// MARK: - PWFullScreenAdDelegate -
extension InterstitialAdCoordinator: PWFullScreenAdDelegate {
    
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
