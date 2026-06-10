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
        case .Banner:
            "Banner"
        case .Interstitial:
            "Interstitial"
        case .Rewarded:
            "Rewarded"
        case .Native:
            "Native"
        @unknown default:
            fatalError()
        }
    }
}
