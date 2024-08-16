//
//  RewardedView.swift
//  PlaywireSDKAppsSwiftUI
//
//

import SwiftUI

struct RewardedView: View {
    
    // The ad unit name, e.g. 'banner-320x50', 'interstitial-home', 'rewarded-coins', etc.
    private let adUnitName: String
    @ObservedObject private var coordinator: RewardedAdCoordinator
    
    init(adUnitName: String, viewController: UIViewController) {
        self.adUnitName = adUnitName
        self.coordinator = RewardedAdCoordinator(adUnitName: adUnitName, viewController: viewController)
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            fullScreenAdStatus(state: coordinator.state, adUnitName: adUnitName, mode: .Rewarded)
            Button("Show Rewarded") {
                coordinator.show()
            }.disabled(coordinator.state != .loaded)
        }
        .padding(.all)
//        .background {
//             adViewControllerRepresentable.frame(width: .zero, height: .zero)
//        }
        .onLoad {
            coordinator.load()
        }
    }
}

