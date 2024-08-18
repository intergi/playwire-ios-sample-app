//
//  RewardedView.swift
//  PlaywireSDKAppsSwiftUI
//
//

import SwiftUI

struct RewardedView: View {
    
    // The ad unit name, e.g. 'banner-320x50', 'interstitial-home', 'rewarded-coins', etc.
    private let adUnitName: String
    private let viewControllerRepresentable = EmptyViewControllerRepresentable()

    @ObservedObject private var coordinator: RewardedAdCoordinator
    
    init(adUnitName: String) {
        self.adUnitName = adUnitName
        self.coordinator = RewardedAdCoordinator(adUnitName: adUnitName, viewController: viewControllerRepresentable.viewController)
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            fullScreenAdStatus(state: coordinator.state, adUnitName: adUnitName, mode: .Rewarded)
            Button("Show Rewarded") {
                coordinator.show()
            }.disabled(coordinator.state != .loaded)
        }
        .padding(.all)
        .background {
            viewControllerRepresentable.frame(width: .zero, height: .zero)
        }
        .onLoad {
            coordinator.load()
        }
    }
}

