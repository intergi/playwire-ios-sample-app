//
//  RewardedInterstitialViewController.swift
//  PlaywireDemo
//
//  Created by Playwire Mobile Team on 12/20/22.
//  Copyright © 2022 Playwire. All rights reserved.
//

import Playwire
import UIKit

final class RewardedInterstitialViewController: UIViewController, AdUnitViewControllerType {
    
    @IBOutlet weak var statusLabel: UILabel!

    // The ad unit name, e.g. 'banner-320x50', 'interstitial-home', 'rewarded-coins', etc.
    var adUnitName: String!
    
    private var rewardedInterstitial: PWRewardedInterstitial?
    private var name: String { adUnitName ?? "NULL"}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadRewardedInterstitial()
    }
    
    private func loadRewardedInterstitial() {
        rewardedInterstitial = PWRewardedInterstitial(adUnitName: adUnitName, viewController: self, delegate: self)
        
        // Use `PWLoadParams().withTargeting()` to pass your custom targets to ad request.
        // let params = PWLoadParams().withTargeting(
        //  [
        //    "age": "18-32",
        //    "page": "travel"
        //  ]
        // )
        // rewardedInterstitial?.load(params: params)
        
        rewardedInterstitial?.load()
        
        statusLabel.text = "⏳ The rewarded interstitial \"\(name)\" is loading."
    }
    
    private func showRewardedInterstitial() {
        guard rewardedInterstitial?.isLoaded == true else {
            // Load rewarded interstitial one more time or notify a user about error
            return
        }
        rewardedInterstitial?.show()
    }
}

// MARK: - PWFullScreenAdDelegate -

extension RewardedInterstitialViewController: PWFullScreenAdDelegate {
    func fullScreenAdDidLoad(_ ad: PWFullScreenAd) {
        statusLabel.text = "✅ The rewarded interstitial \"\(name)\" is loaded."
        showRewardedInterstitial()
    }
    
    func fullScreenAdDidFailToLoad(_ ad: PWFullScreenAd) {
        statusLabel.text = "❌ Failed to load the rewarded interstitial \"\(name)\"."
    }
    
    func fullScreenAdWillPresentFullScreenContent(_ ad: PWFullScreenAd) {
        
    }
    
    func fullScreenAdWillDismissFullScreenContent(_ ad: PWFullScreenAd) {

    }
    
    func fullScreenAdDidDismissFullScreenContent(_ ad: PWFullScreenAd) {
    }
    
    func fullScreenAdDidFailToPresentFullScreenContent(_ ad: PWFullScreenAd) {
        statusLabel.text = "❌ Failed to show the rewarded interstitial \"\(name)\"."        
    }
    
    func fullScreenAdDidRecordImpression(_ ad: PWFullScreenAd) {
        statusLabel.text = "👍 The rewarded interstitial \"\(name))\" was successfully shown."
    }
    
    func fullScreenAdDidRecordClick(_ ad: PWFullScreenAd) {
        
    }
    
    func fullScreenAdDidUserEarn(_ ad: PWFullScreenAd, type: String, amount: Double) {
        // Handle a reward regarding your business objectives.
        statusLabel.text =  "🎉 The reward is earned.\n Type: \(type)\n Amount: \(String(format: "%0.f", amount))."
    }
}
