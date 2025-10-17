//
//  AppOpenViewController.swift
//  PlaywireDemo
//
//  Created by Playwire Mobile Team on 12/20/22.
//  Copyright © 2022 Playwire. All rights reserved.
//

import UIKit
import Playwire

final class AppOpenViewController: UIViewController {
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
        
    // The ad unit name, e.g. 'banner-320x50', 'interstitial-home', 'rewarded-coins', etc.
    let adUnitName: String

    private var appOpenAd: PWAppOpenAd?
    
    init(adUnitName: String) {
        self.adUnitName = adUnitName
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        view.addSubview(statusLabel)
        
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
                
        loadAppOpenAd()
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
        
        statusLabel.text = "⏳ The app open ad \"\(adUnitName)\" is loading."
    }
    
    @objc private func showAppOpenAd() {
        guard appOpenAd?.isLoaded == true else {
            // Load app open ad one more time or notify a user about error
            return
        }
        appOpenAd?.show()
    }
}

extension AppOpenViewController: PWFullScreenAdDelegate {
    func fullScreenAdDidLoad(_ ad: PWFullScreenAd) {
        statusLabel.text = "✅ The app open ad \"\(adUnitName)\" is loaded."
        showAppOpenAd()
    }
    
    func fullScreenAdDidFailToLoad(_ ad: PWFullScreenAd) {
        statusLabel.text = "❌ Failed to load the app open ad \"\(adUnitName)\"."
    }
    
    func fullScreenAdWillPresentFullScreenContent(_ ad: PWFullScreenAd) {
        
    }
    
    func fullScreenAdWillDismissFullScreenContent(_ ad: PWFullScreenAd) {

    }
    
    func fullScreenAdDidDismissFullScreenContent(_ ad: PWFullScreenAd) {
    }
    
    func fullScreenAdDidFailToPresentFullScreenContent(_ ad: PWFullScreenAd) {
        statusLabel.text = "❌ Failed to show the app open ad \"\(adUnitName)\"."
    }
    
    func fullScreenAdDidRecordImpression(_ ad: PWFullScreenAd) {
        statusLabel.text = "👍 The app open ad \"\(adUnitName)\" was successfully shown."
    }
    
    func fullScreenAdDidRecordClick(_ ad: PWFullScreenAd) {
        
    }
    
    func fullScreenAdDidUserEarn(_ ad: PWFullScreenAd, type: String, amount: Double) {
        
    }
}
