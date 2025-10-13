//
//  NativeViewController.swift
//  PlaywireDemo
//
//  Created by Playwire Mobile Team on 12/20/22.
//  Copyright © 2022 Playwire. All rights reserved.
//

import GoogleMobileAds
import Playwire
import UIKit

final class NativeViewController: UIViewController {
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    // The ad unit name, e.g. 'banner-320x50', 'interstitial-home', 'rewarded-coins', etc.
    let adUnitName: String
    
    private var nativeView: PWNativeView!
    private var nativeAdView: CustomNativeAdView!
    
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
            statusLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        nativeView = PWNativeView(
            adUnitName: adUnitName,
            controller: self,
            factory: self,
            delegate: self
        )
        view.addSubview(nativeView)
        nativeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nativeView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            nativeView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            nativeView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            nativeView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        // Use `PWLoadParams().withTargeting()` to pass your custom targets to ad request.
        // let params = PWLoadParams().withTargeting(
        //  [
        //    "age": "18-32",
        //    "page": "travel"
        //  ]
        // )
        // nativeView.load(params: params)
        nativeView?.load()
        
        statusLabel.text = "⏳ The native ad \"\(adUnitName)\" is loading."
    }
}

extension NativeViewController: PWViewAdDelegate {
    func viewAdDidLoad(_ ad: PWViewAd) {
        guard nativeView.isLoaded else { return }
        
        statusLabel.text = "✅ The native ad \"\(adUnitName)\" is loaded."
    }
    
    func viewAdDidFailToLoad(_ ad: PWViewAd) {
        statusLabel.text = "❌ Failed to load the native ad \"\(adUnitName)\"."
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

extension NativeViewController: PWNativeViewFactory {
    func createAdContentView(nativeView: PWNativeView, adContent: PWNativeViewContent) -> UIView {
        // Creates your custom view which can be configurable with `PWNativeViewContent`.
        // `CustomNativeAdView` is a `UIView` subclass for our custom native ad layout. See `CustomNativeAdView` class for more
        // details.
        
        nativeAdView = CustomNativeAdView(adContent: adContent)
        return nativeAdView
    }
    
    func callToActionView(nativeView: PWNativeView, adContentView: UIView) -> UIView? {
        // Defines action view to handle a user's taps on a native ad view.
        nativeAdView.button
    }
}
