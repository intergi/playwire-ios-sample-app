//
//  RewardedAdViewModel.swift
//  PlaywireSDKAppsSwiftUI
//
//

import SwiftUI
import Playwire
import Observation

@Observable class RewardedAdViewModel {
    
    // The ad unit name, e.g. 'banner-320x50', 'interstitial-home', 'rewarded-coins', etc.
    private let adUnitName: String
    private let viewController: UIViewController
    private var rewarded: PWRewarded?
    
    var state: FullScreenAdState = .none

    init(adUnitName: String, viewController: UIViewController) {
        self.adUnitName = adUnitName
        self.viewController = viewController
    }
    
    func load() {
        rewarded = PWRewarded(adUnitName: adUnitName, viewController: viewController, delegate: self)
        
        // Use `PWLoadParams().withTargeting()` to pass your custom targets to ad request.
//        let params = PWLoadParams()
//            .withTargeting(
//          [
//            "age": "18-32",
//            "page": "travel"
//          ]
//         )
//         rewarded?.load(params: params)
        
        rewarded?.load()
        
        state = .loading
    }

    func show() {
        guard rewarded?.isLoaded == true else {
            // Load rewarded one more time or notify a user about error
            return
        }
        rewarded?.show()
    }
}

extension RewardedAdViewModel: PWFullScreenAdDelegate {
    
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
        rewarded = nil
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
        state = .earnedReward(type, Int(amount))
    }
}
