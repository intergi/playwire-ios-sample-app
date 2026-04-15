//
//  NativeContainerViewImpl.swift
//  PlaywireSDKApps
//
//  Created by Playwire Mobile Team on 2026-04-10.
//

import UIKit
import Playwire

// MARK: - Impl

final class NativeContainerViewImpl: NSObject {

    let nativeView: PWNativeView

    private let factory = NativeAdFactory()

    private let onLoad: () -> Void
    private let onFailToLoad: () -> Void
    private let onImpression: () -> Void
    private let onClick: () -> Void

    init(
        adUnitName: String,
        controller: UIViewController?,
        onLoad: @escaping () -> Void,
        onFailToLoad: @escaping () -> Void,
        onImpression: @escaping () -> Void,
        onClick: @escaping () -> Void
    ) {
        self.onLoad = onLoad
        self.onFailToLoad = onFailToLoad
        self.onImpression = onImpression
        self.onClick = onClick

        self.nativeView = PWNativeView(
            adUnitName: adUnitName,
            controller: controller,
            factory: factory,
            delegate: nil
        )

        super.init()
        self.nativeView.delegate = self
    }

    func load() {
        nativeView.load()
    }
}

// MARK: - PWViewAdDelegate

extension NativeContainerViewImpl: PWViewAdDelegate {
    func viewAdDidLoad(_ ad: PWViewAd) {
        guard nativeView.isLoaded else { return }
        onLoad()
    }

    func viewAdDidFailToLoad(_ ad: PWViewAd) {
        onFailToLoad()
    }

    func viewAdWillPresentFullScreenContent(_ ad: PWViewAd) { }

    func viewAdWillDismissFullScreenContent(_ ad: PWViewAd) { }

    func viewAdDidDismissFullScreenContent(_ ad: PWViewAd) { }

    func viewAdDidRecordImpression(_ ad: PWViewAd) {
        onImpression()
    }

    func viewAdDidRecordClick(_ ad: PWViewAd) {
        onClick()
    }
}

// MARK: - PWNativeViewFactory

private final class NativeAdFactory: PWNativeViewFactory {
    func createAdContentView() -> PWNativeViewContentView {
        NativeContentView()
    }
}
