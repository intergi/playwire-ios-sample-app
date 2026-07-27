//
//  AdTypesViewModel.swift
//  PlaywireSDKAppsSwiftUI
//
//

import SwiftUI
import Observation
import Playwire

enum AdMode {
    case banner
    case interstitial
    case rewarded
    case appOpen
    case native
}

struct AdUnitItem: Identifiable {
    var id: String { alias }
    
    let alias: String
    let mode: AdMode
}

@Observable final class AdTypesViewModel {
    private let availableAdUnitItems: [AdUnitItem] = [
        AdUnitItem(alias: "banner-320x50-gam", mode: .banner),
        AdUnitItem(alias: "banner-320x50-max", mode: .banner),
        AdUnitItem(alias: "banner-300x250-gam", mode: .banner),
        AdUnitItem(alias: "banner-300x250-max", mode: .banner),
        AdUnitItem(alias: "native-gam", mode: .native),
        AdUnitItem(alias: "native-max", mode: .native),
        AdUnitItem(alias: "app-open-gam", mode: .appOpen),
        AdUnitItem(alias: "app-open-max", mode: .appOpen),
        AdUnitItem(alias: "interstitial-gam", mode: .interstitial),
        AdUnitItem(alias: "interstitial-max", mode: .interstitial),
        AdUnitItem(alias: "rewarded-gam", mode: .rewarded),
        AdUnitItem(alias: "rewarded-video-max", mode: .rewarded),
    ]
    
    var adUnitItems: [AdUnitItem] = []
    
    func initializeSDK(publisherId: String, appId: String, viewController: UIViewController) {
        PlaywireSDK.shared.start(
            publisherId: publisherId,
            appId: appId,
            viewController: viewController
        ) { success, error in
            if success {
                self.adUnitItems = self.availableAdUnitItems
            } else {
                self.adUnitItems = []
                print("SDK start failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
}
