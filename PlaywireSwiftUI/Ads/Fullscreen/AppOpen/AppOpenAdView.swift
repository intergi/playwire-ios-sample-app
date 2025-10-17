//
//  AppOpenAdView.swift
//  PlaywireSDKAppsSwiftUI
//
//

import Playwire
import SwiftUI

struct AppOpenAdView: View {
    
    // The ad unit name, e.g. 'banner-320x50', 'interstitial-home', 'rewarded-coins', etc.
    private let adUnitName: String
    private let viewControllerRepresentable = EmptyViewControllerRepresentable()
    private var viewModel: AppOpenAdViewModel
    
    init(adUnitName: String) {
        self.adUnitName = adUnitName
        self.viewModel = AppOpenAdViewModel(adUnitName: adUnitName, viewController: viewControllerRepresentable.viewController)
    }
    
    var body: some View {
        fullScreenAdStatus(state: viewModel.state, adUnitName: adUnitName, mode: .AppOpenAd)
        .padding(.all)
        .background {
            viewControllerRepresentable.frame(width: .zero, height: .zero)
        }
        .onFirstAppear {
            viewModel.load()
        }
    }
}
