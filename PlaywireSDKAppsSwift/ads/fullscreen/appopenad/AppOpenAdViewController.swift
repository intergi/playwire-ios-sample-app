//
//  AppOpenAdViewController.swift
//  PlaywireDemo
//
//  Created by Playwire Mobile Team on 12/20/22.
//  Copyright © 2022 Playwire. All rights reserved.
//

import UIKit
import Playwire

final class AppOpenAdViewController: UIViewController, AdUnitViewControllerType {
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var showAppOpenAdButton: UIButton!
    
    // The ad unit name, e.g. 'banner-320x50', 'interstitial-home', 'rewarded-coins', etc.
    var adUnitName: String!
    
    private var appOpenAd: PWAppOpenAd?
    private var name: String { adUnitName ?? "NULL"}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscribeToAppStateNotificaions()
        showAppOpenAdButton.isEnabled = false
        
        loadAppOpenAd()
    }
    
    private func subscribeToAppStateNotificaions() {
        // Observe an app state to show the ad when a user open the app.
        // As alternative you can handle an app state in the `AppDelegate` or `SceneDelegate`.
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleResignActiveState),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleBecomeActiveState),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    @objc
    private func handleResignActiveState() {
        // Check if we need to load app open ad before next presentation
        if let appOpenAd = appOpenAd, appOpenAd.isLoaded { return }
        loadAppOpenAd()
    }
    
    @objc
    private func handleBecomeActiveState() {
        showAppOpenAd()
    }
    
    private func loadAppOpenAd() {
        
        appOpenAd = PWAppOpenAd(adUnitName: adUnitName, viewController: self, delegate: self)
        
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
        
        statusLabel.text = "⏳ The app open ad \"\(name)\" is loading."
    }
    
    private func showAppOpenAd() {
        guard appOpenAd?.isLoaded == true else {
            // Load app open ad one more time or notify a user about error
            return
        }
        appOpenAd?.show()
    }
    
    @IBAction func showAction(_ sender: UIButton) {
        showAppOpenAd()
    }
}

// MARK: - PWFullScreenAdDelegate -

extension AppOpenAdViewController: PWFullScreenAdDelegate {
    func fullScreenAdDidLoad(_ ad: PWFullScreenAd) {
        statusLabel.text = "✅ The app open ad \"\(name)\" is loaded."
        showAppOpenAdButton.isEnabled = true
    }
    
    func fullScreenAdDidFailToLoad(_ ad: PWFullScreenAd) {
        statusLabel.text = "❌ Failed to load the app open ad \"\(name)\"."
    }
    
    func fullScreenAdWillPresentFullScreenContent(_ ad: PWFullScreenAd) {
        
    }
    
    func fullScreenAdWillDismissFullScreenContent(_ ad: PWFullScreenAd) {

    }
    
    func fullScreenAdDidDismissFullScreenContent(_ ad: PWFullScreenAd) {
        appOpenAd = nil
        
        // Load app open ad content to be ready for the next presentation
        loadAppOpenAd()
    }
    
    func fullScreenAdDidFailToPresentFullScreenContent(_ ad: PWFullScreenAd) {
        statusLabel.text = "❌ Failed to show the app open ad \"\(name)\"."
        appOpenAd = nil
    }
    
    func fullScreenAdDidRecordImpression(_ ad: PWFullScreenAd) {
        statusLabel.text = "👍 The app open ad \"\(name)\" was successfully shown."
        showAppOpenAdButton.isEnabled = false
    }
    
    func fullScreenAdDidRecordClick(_ ad: PWFullScreenAd) {
        
    }
    
    func fullScreenAdDidUserEarn(_ ad: PWFullScreenAd, type: String, amount: Double) {
        
    }
}
