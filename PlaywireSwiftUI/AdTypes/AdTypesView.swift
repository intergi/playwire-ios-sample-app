//
//  AdTypesView.swift
//  PlaywireSDKAppsSwiftUI
//
//

import SwiftUI
import Playwire

struct AdTypesView: View {
    private let viewControllerRepresentable = EmptyViewControllerRepresentable()
    @State private var viewModel = AdTypesViewModel()
    
    var body: some View {
        let title = "Playwire Demo"
        
        NavigationStack {
            if viewModel.adUnitItems.isEmpty {
                Text("⏳ SDK initialization..")
                    .frame(alignment: .center)
                    .navigationTitle(title)
            } else {
                List(viewModel.adUnitItems) { item in
                    let destination = destinationView(for: item)
                    NavigationLink(destination: destination) {
                        Text(item.alias).font(.body)
                    }
                }
                .navigationTitle(title)
            }
        }
        .background {
             viewControllerRepresentable.frame(width: .zero, height: .zero)
        }
        .onFirstAppear {
             viewModel.initializeSDK(publisherId: "1024407", appId: "702", viewController: viewControllerRepresentable.viewController)
        }
    }
    
    @ViewBuilder
    func destinationView(for adUnitItem: AdUnitItem) -> some View {
        switch adUnitItem.mode {
        case .banner:
            BannerView(adUnitName: adUnitItem.alias)
            
        case .interstitial:
            InterstitialView(adUnitName: adUnitItem.alias)
        case .rewarded:
            RewardedView(adUnitName: adUnitItem.alias)
        case .appOpen:
            AppOpenAdView(adUnitName: adUnitItem.alias)
        case .native:
            PlaywireNativeAdView(adUnitName: adUnitItem.alias)
        }
    }
}
