//
//  NativeAdViewFactory.swift
//  PlaywireSDKApps
//
//  Created by Inder Dhir on 10/7/25.
//

import GoogleMobileAds
import Foundation
import Playwire
import UIKit

final class NativeAdViewFactory: PWNativeViewFactory {
    func createAdContentView(nativeView: PWNativeView, adContent: PWNativeViewContent) -> UIView {
        CustomNativeAdView(adContent: adContent)
    }

    func callToActionView(nativeView: PWNativeView, adContentView: UIView) -> UIView? {
        (adContentView as? CustomNativeAdView)?.button
    }
}
