//
//  RewardedView.swift
//  PlaywireSDKAppsSwiftUI
//
//

import SwiftUI

struct RewardedView: View {
    
    // The ad unit name, e.g. 'banner-320x50', 'interstitial-home', 'rewarded-coins', etc.
    private let adUnitName: String
    private let adViewControllerRepresentable = AdViewControllerRepresentable()
    @ObservedObject private var coordinator: RewardedAdCoordinator
    
    init(adUnitName: String) {
        self.adUnitName = adUnitName
        self.coordinator = RewardedAdCoordinator(adUnitName: adUnitName)
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            fullScreenAdStatus(state: coordinator.state, adUnitName: adUnitName, mode: .Rewarded)
            Button("Show Rewarded") {
                coordinator.show(from: adViewControllerRepresentable.viewController)
            }.disabled(coordinator.state != .loaded)
        }
        .padding(.all)
        .background {
            adViewControllerRepresentable.frame(width: .zero, height: .zero)
        }
        .onLoad {
            coordinator.load()
        }
    }
}

