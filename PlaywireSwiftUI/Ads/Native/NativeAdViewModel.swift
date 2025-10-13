//
//  NativeAdViewModel.swift
//  PlaywireSDKApps
//
//  Created by Inder Dhir on 10/7/25.
//

import SwiftUI
import Playwire
import Observation

@Observable class NativeAdViewModel: PWNativeViewFactory {
    
    // The ad unit name, e.g. 'banner-320x50', 'interstitial-home', 'rewarded-coins', etc.
    private let adUnitName: String
    private let viewController: UIViewController
    
    // Tracks the current state of the native ad
    var state: NativeAdState = .none
    
    // Loading and nativeView management handled via NativeAdViewSwiftUI
    // This ViewModel is responsible only for state and delegate callbacks
    
    init(adUnitName: String, viewController: UIViewController) {
        self.adUnitName = adUnitName
        self.viewController = viewController
    }
    
    func createAdContentView(nativeView: PWNativeView, adContent: PWNativeViewContent) -> UIView {
        CustomNativeAdView(adContent: adContent)
    }

    func callToActionView(nativeView: PWNativeView, adContentView: UIView) -> UIView? {
        (adContentView as? CustomNativeAdView)?.button
    }
}

extension NativeAdViewModel: PWViewAdDelegate {
    
    func viewAdDidLoad(_ ad: Playwire.PWViewAd) {
        state = .loaded
    }

    func viewAdDidFailToLoad(_ ad: Playwire.PWViewAd) {
        state = .failed
    }

    func viewAdWillPresentFullScreenContent(_ ad: Playwire.PWViewAd) {
        
    }

    func viewAdWillDismissFullScreenContent(_ ad: Playwire.PWViewAd) {
        
    }

    func viewAdDidDismissFullScreenContent(_ ad: Playwire.PWViewAd) {
        
    }

    func viewAdDidRecordImpression(_ ad: Playwire.PWViewAd) {
        
    }

    func viewAdDidRecordClick(_ ad: Playwire.PWViewAd) {
        
    }
}

public struct NativeAdViewSwiftUI: UIViewRepresentable {
    private let adUnitName: String
    private let viewController: UIViewController
    private var factory: PWNativeViewFactory
    private var delegate: PWViewAdDelegate?

    public init(
        adUnitName: String,
        viewController: UIViewController,
        factory: PWNativeViewFactory,
        delegate: PWViewAdDelegate? = nil
    ) {
        self.adUnitName = adUnitName
        self.viewController = viewController
        self.factory = factory
        self.delegate = delegate
    }

    public func makeUIView(context: Context) -> PWNativeView {
        let nativeView = PWNativeView(
            adUnitName: adUnitName,
            controller: viewController,
            factory: factory,
            delegate: delegate
        )
        nativeView.load()
        return nativeView
    }

    public func updateUIView(_ uiView: PWNativeView, context: Context) {
        uiView.delegate = delegate
    }
}
