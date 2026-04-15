//
//  ObjCNativeContainerViewImpl.swift
//  PlaywireSDKApps
//
//  Created by Playwire Mobile Team on 2026-04-10.
//

import UIKit
import Playwire

// MARK: - Impl

final class ObjCNativeContainerViewImpl: NSObject {

    let nativeView: PWNativeView

    private let factory = ObjCNativeAdFactory()

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

extension ObjCNativeContainerViewImpl: PWViewAdDelegate {
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

// MARK: - PWNativeViewFactory (private helper)

private final class ObjCNativeAdFactory: PWNativeViewFactory {
    func createAdContentView() -> PWNativeViewContentView {
        ObjCNativeContentView()
    }
}
