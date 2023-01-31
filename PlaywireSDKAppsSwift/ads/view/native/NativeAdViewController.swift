//
//  NativeAdViewController.swift
//  PlaywireDemo
//
//  Created by Playwire Mobile Team on 12/20/22.
//  Copyright © 2022 Playwire. All rights reserved.
//

import Playwire
import UIKit

import GoogleMobileAds

final class NativeAdViewController: UIViewController, AdUnitViewControllerType {
    
    @IBOutlet weak var statusLabel: UILabel!
    
    // The ad unit name, e.g. 'banner-320x50', 'interstitial-home', 'rewarded-coins', etc.
    var adUnitName: String!
    
    private lazy var nativeView = PWNativeView(adUnitName: adUnitName, controller: self, factory: self, delegate: self)
    private var isNativeViewAdded: Bool = false
    private var name: String { adUnitName ?? "NULL"}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Use `PWLoadParams().withTargeting()` to pass your custom targets to ad request.
        // let params = PWLoadParams().withTargeting(
        //  [
        //    "age": "18-32",
        //    "page": "travel"
        //  ]
        // )
        // nativeView.load(params: params)
        
        nativeView.load()
        
        statusLabel.text = "⏳ The native ad \"\(name)\" is loading."
    }
    
    private func addNativeViewToSuperView() {
        guard !isNativeViewAdded else { return }
        isNativeViewAdded = true
        
        // Native view is ready to be added to view hierarchy
        nativeView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nativeView)
        NSLayoutConstraint.activate([
            nativeView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            nativeView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            nativeView.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])
    }
    
    @IBAction func refreshAction(_ sender: UIButton) {
        // Refresh will start only if the ad unit contains `refresh` object.
        // See logs from `PWNotifier` to track status of refresh.
        
        nativeView.refresh()
        
        let adUnits = PlaywireSDK.shared.config?.adUnits
        let refresh = adUnits?.first { $0.name == adUnitName }?.refresh
        guard refresh != nil else {
            statusLabel.text = "⚠️ The native ad \"\(name)\" can't be refreshed manually.\nSee logs to get more details."
            return
        }
        statusLabel.text = "🔄 The native ad \"\(name)\" is refreshing."
    }
}

// MARK: - PWViewAdDelegate -
extension NativeAdViewController: PWViewAdDelegate {
    func viewAdDidLoad(_ ad: PWViewAd) {
        guard nativeView.isLoaded else { return }
        
        statusLabel.text = "✅ The native ad \"\(name)\" is loaded."
        addNativeViewToSuperView()
    }
    
    func viewAdDidFailToLoad(_ ad: PWViewAd) {
        statusLabel.text = "❌ Failed to load the native ad \"\(name)\"."
    }
    
    func viewAdWillPresentFullScreenContent(_ ad: PWViewAd) {
    }
    
    func viewAdWillDismissFullScreenContent(_ ad: PWViewAd) {
    }
    
    func viewAdDidDismissFullScreenContent(_ ad: PWViewAd) {
    }
    
    func viewAdDidRecordImpression(_ ad: PWViewAd) {
    }
    
    func viewAdDidRecordClick(_ ad: PWViewAd) {
    }
}

extension NativeAdViewController: PWNativeViewFactory {
    func createAdContentView(nativeView: PWNativeView, adContent: PWNativeViewContent) -> UIView {
        // Creates your custom view which can be configurable with `PWNativeViewContent`.
        // `CustomNativeAdView` is a `UIView` subclass for our custom native ad layout. See `CustomNativeAdView` class for more
        // details.
        
        let customView = CustomNativeAdView()
        customView.configure(adContent)
        return customView
    }
    
    func callToActionView(nativeView: PWNativeView, adContentView: UIView) -> UIView? {
        guard let customView = adContentView as? CustomNativeAdView else {
            return nil
        }
        // Defines action view to handle a user's taps on a native ad view.
        return customView.actionButton
    }
}
