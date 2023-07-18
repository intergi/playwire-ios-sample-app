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
            return "app open ad"
        case .Banner, .BannerInline, .BannerAnchored:
            return "banner"
        case .Interstitial:
            return "interstitial"
        case .Rewarded:
            return "rewarded"
        case .RewardedInterstitial:
            return "rewarded interstitial"
        case .Native:
            return "native"
        @unknown default:
            fatalError()
        }
    }
}
