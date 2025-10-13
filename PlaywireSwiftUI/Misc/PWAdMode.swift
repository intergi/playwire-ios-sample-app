//
//  PWAdMode.swift
//  PlaywireSDKAppsSwiftUI
//
//

import Playwire

extension PWAdUnit.PWAdMode {
    var statusTitle: String {
        switch self {
        case .AppOpenAd:
            "AppOpen"
        case .Banner, .BannerInline, .BannerAnchored:
            "Banner"
        case .Interstitial:
            "Interstitial"
        case .Rewarded:
            "Rewarded"
        case .RewardedInterstitial:
            "Rewarded Interstitial"
        case .Native:
            "Native"
        @unknown default:
            fatalError()
        }
    }
}
