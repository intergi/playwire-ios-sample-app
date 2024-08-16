//
//  RewardedInterstitialView.swift
//  PlaywireSDKAppsSwiftUI
//
//

import SwiftUI

struct RewardedInterstitialView: View {
    
    // The ad unit name, e.g. 'banner-320x50', 'interstitial-home', 'rewarded-coins', etc.
    private let adUnitName: String
    @ObservedObject private var coordinator: RewardedInterstitialAdCoordinator
    
    init(adUnitName: String, viewController: UIViewController) {
        self.adUnitName = adUnitName
        self.coordinator = RewardedInterstitialAdCoordinator(adUnitName: adUnitName, viewController: viewController)
    }
    
    var body: some View {
        fullScreenAdStatus(state: coordinator.state, adUnitName: adUnitName, mode: .RewardedInterstitial)
        .onChange(of: coordinator.state) { newValue in
            guard newValue == .loaded else { return }
            coordinator.show()
        }
//        .background {
//             adViewControllerRepresentable.frame(width: .zero, height: .zero)
//        }
        .onLoad {
            coordinator.load()
        }
    }
}
