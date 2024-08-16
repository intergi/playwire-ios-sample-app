//
//  RewardedViewController.swift
//  PlaywireDemo
//
//  Created by Playwire Mobile Team on 12/20/22.
//  Copyright © 2022 Playwire. All rights reserved.
//

import Playwire
import UIKit

final class RewardedViewController: UIViewController, AdUnitViewControllerType {
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var getRewardButton: UIButton!
    
    // The ad unit name, e.g. 'banner-320x50', 'interstitial-home', 'rewarded-coins', etc.
    var adUnitName: String!
    
    private var rewarded: PWRewarded?
    private var name: String { adUnitName ?? "NULL"}
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        getRewardButton.isEnabled = false
        loadRewarded()
    }
    @IBAction func getRewardAction(_ sender: UIButton) {
        showRewarded()
    }
    
    private func loadRewarded() {
        rewarded = PWRewarded(adUnitName: adUnitName, viewController: self, delegate: self)
        
        // Use `PWLoadParams().withTargeting()` to pass your custom targets to ad request.
        // let params = PWLoadParams().withTargeting(
        //  [
        //    "age": "18-32",
        //    "page": "travel"
        //  ]
        // )
        // rewarded?.load(params: params)
        
        rewarded?.load()
        statusLabel.text = "⏳ The rewarded \"\(name)\" is loading."
    }
    
    private func showRewarded() {
        guard rewarded?.isLoaded == true else {
            // Load rewarded one more time or notify a user about error
            loadRewarded()
            return
        }
        
        rewarded?.show()
    }
}

// MARK: - PWFullScreenAdDelegate -
extension RewardedViewController: PWFullScreenAdDelegate {
    func fullScreenAdDidLoad(_ ad: PWFullScreenAd) {
        statusLabel.text = "✅ The rewarded \"\(name)\" is loaded."
        getRewardButton.isEnabled = true
    }
    
    func fullScreenAdDidFailToLoad(_ ad: PWFullScreenAd) {
        statusLabel.text = "❌ Failed to load the rewarded \"\(name)\"."
    }
    
    func fullScreenAdWillPresentFullScreenContent(_ ad: PWFullScreenAd) {
        
    }
    
    func fullScreenAdWillDismissFullScreenContent(_ ad: PWFullScreenAd) {

    }
    
    func fullScreenAdDidDismissFullScreenContent(_ ad: PWFullScreenAd) {
        rewarded = nil
        getRewardButton.isEnabled = false
    }
    
    func fullScreenAdDidFailToPresentFullScreenContent(_ ad: PWFullScreenAd) {
        statusLabel.text = "❌ Failed to show the rewarded \"\(name)\"."
    }
    
    func fullScreenAdDidRecordImpression(_ ad: PWFullScreenAd) {
        statusLabel.text = "👍 The rewarded \"\(name))\" was successfully shown."
    }
    
    func fullScreenAdDidRecordClick(_ ad: PWFullScreenAd) {
        
    }
    
    func fullScreenAdDidUserEarn(_ ad: PWFullScreenAd, type: String, amount: Double) {
        // Handle a reward regarding your business objectives.
        statusLabel.text =  "🎉 The reward is earned.\n Type: \(type)\n Amount: \(String(format: "%.2f", amount))."
    }
}
