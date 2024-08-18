//
//  InterstitialView.swift
//  PlaywireSDKAppsSwiftUI
//
//

import SwiftUI

struct InterstitialView: View {
    
    // The ad unit name, e.g. 'banner-320x50', 'interstitial-home', 'rewarded-coins', etc.
    private let adUnitName: String
    private let viewControllerRepresentable = EmptyViewControllerRepresentable()

    @ObservedObject private var coordinator: InterstitialAdCoordinator
    
    init(adUnitName: String) {
        self.adUnitName = adUnitName
        self.coordinator = InterstitialAdCoordinator(adUnitName: adUnitName, viewController: viewControllerRepresentable.viewController)
    }
    
    var body: some View {
        fullScreenAdStatus(state: coordinator.state, adUnitName: adUnitName, mode: .Interstitial)
        .onChange(of: coordinator.state) { newValue in
            guard newValue == .loaded else { return }
            coordinator.show()
        }
        .background {
            viewControllerRepresentable.frame(width: .zero, height: .zero)
        }
        .onLoad {
            coordinator.load()
        }
    }
}
