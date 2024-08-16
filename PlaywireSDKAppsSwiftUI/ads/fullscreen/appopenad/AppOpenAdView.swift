//
//  AppOpenAdView.swift
//  PlaywireSDKAppsSwiftUI
//
//

import SwiftUI

struct AppOpenAdView: View {
    
    // The ad unit name, e.g. 'banner-320x50', 'interstitial-home', 'rewarded-coins', etc.
    private let adUnitName: String
    @ObservedObject private var coordinator: AppOpenAdCoordinator
    
    init(adUnitName: String, viewController: UIViewController) {
        self.adUnitName = adUnitName
        self.coordinator = AppOpenAdCoordinator(adUnitName: adUnitName, viewController: viewController)
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            fullScreenAdStatus(state: coordinator.state, adUnitName: adUnitName, mode: .AppOpenAd)
            Text("\nGo to Home screen and open the app again to see the app open ad.\n\nOR\n")
                .multilineTextAlignment(.center)
            Button("Show App Open Ad") {
                coordinator.show()
            }.disabled(coordinator.state != .loaded)
        }
        .padding(.all)
//        .background {
//            adViewControllerRepresentable.frame(width: .zero, height: .zero)
//        }
        .onLoad {
            coordinator.load()
        }
    }
}
