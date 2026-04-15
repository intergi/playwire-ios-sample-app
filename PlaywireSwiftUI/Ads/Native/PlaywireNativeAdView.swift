//
//  PlaywireNativeAdView.swift
//  PlaywireSDKApps
//
//  Created by Inder Dhir on 10/7/25.
//

import Playwire
import SwiftUI

struct PlaywireNativeAdView: View {
    
    // The ad unit name, e.g. 'banner-320x50', 'interstitial-home', 'rewarded-coins', etc.
    private let adUnitName: String
    private let viewControllerRepresentable = EmptyViewControllerRepresentable()
    @State private var viewModel: NativeAdViewModel
    
    init(adUnitName: String) {
        self.adUnitName = adUnitName
        self._viewModel = State(initialValue: NativeAdViewModel())
    }
    
    var body: some View {
        Group {
            nativeAdStatus(state: viewModel.state, adUnitName: adUnitName, mode: .Native)
            
            NativeAdViewSwiftUI(
                adUnitName: adUnitName,
                viewController: viewControllerRepresentable.viewController,
                factory: viewModel,
                delegate: viewModel
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background {
            viewControllerRepresentable.frame(width: .zero, height: .zero)
        }
        .onAppear {
            if viewModel.state == .none {
                viewModel.state = .loading
            }
        }
    }
}
