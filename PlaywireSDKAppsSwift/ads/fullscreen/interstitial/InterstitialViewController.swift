//
//  InterstitialViewController.swift
//  PlaywireDemo
//
//  Created by Playwire Mobile Team on 12/20/22.
//  Copyright © 2022 Playwire. All rights reserved.
//

import Playwire
import UIKit

final class InterstitialViewController: UIViewController, AdUnitViewControllerType {
    
    @IBOutlet weak var statusLabel: UILabel!
    
    // The ad unit name, e.g. 'banner-320x50', 'interstitial-home', 'rewarded-coins', etc.
    var adUnitName: String!
    
    private var interstitial: PWInterstitial?
    private var name: String { adUnitName ?? "NULL"}
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        loadInterstitial()
    }
    
    private func loadInterstitial() {
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
        
        statusLabel.text = "⏳ The interstitial \"\(name)\" is loading."
    }
    
    private func showInterstitial() {
        guard interstitial?.isLoaded == true else {
            // Load interstitial one more time or notify a user about error
            return
        }
        interstitial?.show(fromViewController: self)
    }
}

// MARK: - PWFullScreenAdDelegate -
extension InterstitialViewController: PWFullScreenAdDelegate {
    func fullScreenAdDidLoad(_ ad: PWFullScreenAd) {
        statusLabel.text = "✅ The interstitial \"\(name)\" is loaded."
        showInterstitial()
    }
    
    func fullScreenAdDidFailToLoad(_ ad: PWFullScreenAd) {
        statusLabel.text = "❌ Failed to load the interstitial \"\(name)\"."
    }
    
    func fullScreenAdWillPresentFullScreenContent(_ ad: PWFullScreenAd) {
    }
    
    func fullScreenAdWillDismissFullScreenContent(_ ad: PWFullScreenAd) {

    }
    
    func fullScreenAdDidDismissFullScreenContent(_ ad: PWFullScreenAd) {
    }
    
    func fullScreenAdDidFailToPresentFullScreenContent(_ ad: PWFullScreenAd) {
        statusLabel.text = "❌ Failed to show the interstitial \"\(name)\"."
    }
    
    func fullScreenAdDidRecordImpression(_ ad: PWFullScreenAd) {
        statusLabel.text = "👍 The interstitial \"\(name)\" was successfully shown."
    }
    
    func fullScreenAdDidRecordClick(_ ad: PWFullScreenAd) {
    }
    
    func fullScreenAdDidUserEarn(_ ad: PWFullScreenAd, type: String, amount: Double) {
    }
}
