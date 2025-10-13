//
//  InterstitialView.swift
//  PlaywireSDKAppsSwiftUI
//
//

import Playwire
import SwiftUI

struct InterstitialView: View {
    
    // The ad unit name, e.g. 'banner-320x50', 'interstitial-home', 'rewarded-coins', etc.
    private let adUnitName: String
    private let viewControllerRepresentable = EmptyViewControllerRepresentable()
    private var viewModel: InterstitialAdViewModel
    
    init(adUnitName: String) {
        self.adUnitName = adUnitName
        self.viewModel = InterstitialAdViewModel(adUnitName: adUnitName, viewController: viewControllerRepresentable.viewController)
    }
    
    var body: some View {
        fullScreenAdStatus(state: viewModel.state, adUnitName: adUnitName, mode: .Interstitial)
        .onChange(of: viewModel.state) { _, newValue in
            guard newValue == .loaded else { return }
            
            viewModel.show()
        }
        .background {
            viewControllerRepresentable.frame(width: .zero, height: .zero)
        }
        .onFirstAppear {
            viewModel.load()
        }
    }
}
