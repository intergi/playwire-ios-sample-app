//
//  AppOpenAdView.swift
//  PlaywireSDKAppsSwiftUI
//
//

import SwiftUI

struct AppOpenAdView: View {
    
    // The ad unit name, e.g. 'banner-320x50', 'interstitial-home', 'rewarded-coins', etc.
    private let adUnitName: String
    private let adViewControllerRepresentable = AdViewControllerRepresentable()
    @ObservedObject private var coordinator: AppOpenAdCoordinator
    
    init(adUnitName: String) {
        self.adUnitName = adUnitName
        self.coordinator = AppOpenAdCoordinator(adUnitName: adUnitName, topViewController: adViewControllerRepresentable.viewController)
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            fullScreenAdStatus(state: coordinator.state, adUnitName: adUnitName, mode: .AppOpenAd)
            Text("\nGo to Home screen and open the app again to see the app open ad.\n\nOR\n")
                .multilineTextAlignment(.center)
            Button("Show App Open Ad") {
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
