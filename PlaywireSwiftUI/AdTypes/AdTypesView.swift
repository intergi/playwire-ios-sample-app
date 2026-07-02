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
                            Text(item.mode).font(.caption)
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
    func destinationView(adUnitName: String, mode: String) -> some View {
        switch mode {
        case "Banner":
            if adUnitName == "floating-banner" {
                // TODO: add floating banner example
                EmptyView()
            } else {
                BannerView(adUnitName: adUnitName)
            }
            
        case "Interstitial":
            InterstitialView(adUnitName: adUnitName)
        case "Rewarded":
            RewardedView(adUnitName: adUnitName)
        case "AppOpenAd":
            AppOpenAdView(adUnitName: adUnitName)
        case "Native":
            PlaywireNativeAdView(adUnitName: adUnitName)
        default:
            EmptyView()
        }
    }
}
