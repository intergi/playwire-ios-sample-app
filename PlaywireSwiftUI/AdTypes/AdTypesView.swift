//
//  AdTypesView.swift
//  PlaywireSDKAppsSwiftUI
//
//

import SwiftUI
import Playwire

struct AdTypesView: View {
    private let viewControllerRepresentable = EmptyViewControllerRepresentable()
    private var viewModel = AdTypesViewModel()
    
    var body: some View {
        let title = "Playwire Demo"
        
        NavigationStack {
            if viewModel.adUnits.isEmpty {
                Text("⏳ SDK initialization..")
                    .frame(alignment: .center)
                    .navigationTitle(title)
            } else {
                List(viewModel.adUnits) { item in
                    let destination = destinationView(adUnitName: item.name, mode: item.mode)
                    NavigationLink(destination: destination) {
                        VStack(alignment: .leading) {
                            Text(item.name).font(.body)
                            Text(item.mode.rawValue).font(.caption)
                        }
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
    func destinationView(adUnitName: String, mode: PWAdUnit.PWAdMode) -> some View {
        switch mode {
        case .Banner:
            BannerView(adUnitName: adUnitName)
        case .BannerAnchored:
            AnchoredBannerView(adUnitName: adUnitName)
        case .BannerInline:
            InlineBannerView(adUnitName: adUnitName)
        case .Interstitial:
            InterstitialView(adUnitName: adUnitName)
        case .Rewarded:
            RewardedView(adUnitName: adUnitName)
        case .AppOpenAd:
            AppOpenAdView(adUnitName: adUnitName)
        case .RewardedInterstitial:
            RewardedInterstitialView(adUnitName: adUnitName)
        case .Native:
            PlaywireNativeAdView(adUnitName: adUnitName)
            
        @unknown default:
            EmptyView()
        }
    }
}
