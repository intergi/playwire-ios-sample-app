//
//  AdTypesView.swift
//  PlaywireSDKAppsSwiftUI
//
//

import SwiftUI
import Playwire

struct AdTypesView: View {
    let viewControllerRepresentable = EmptyViewControllerRepresentable()
    
    @StateObject var viewModel: AdTypesViewModel = AdTypesViewModel()
    
    var body: some View {
        
        #if COPPA_APP
            let title = "Playwire Demo COPPA"
        #else
            let title = "Playwire Demo"
        #endif
                
        
        NavigationStack {
            if (viewModel.adUnits.isEmpty) {
                Text("⏳ SDK initializaton..")
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
        .onLoad {
             viewModel.inititalizeSDK(publisherId: "playwire", appId: "test", viewController: viewControllerRepresentable.viewController)
        }
    }
    
    func destinationView(adUnitName: String, mode: PWAdUnit.PWAdMode) -> AnyView {
        switch mode {
        case .Banner:
            return AnyView(BannerView(adUnitName: adUnitName))
        case .BannerAnchored:
            return AnyView(AnchoredBannerView(adUnitName: adUnitName))
        case .BannerInline:
            return AnyView(InlineBannerView(adUnitName: adUnitName))
        case .Interstitial:
            return AnyView(InterstitialView(adUnitName: adUnitName, viewController: viewControllerRepresentable.viewController))
        case .Rewarded:
            return AnyView(RewardedView(adUnitName: adUnitName, viewController: viewControllerRepresentable.viewController))
        case .AppOpenAd:
            return AnyView(AppOpenAdView(adUnitName: adUnitName, viewController: viewControllerRepresentable.viewController))
        case .RewardedInterstitial:
            return AnyView(RewardedInterstitialView(adUnitName: adUnitName, viewController: viewControllerRepresentable.viewController))
        case .Native:
            return AnyView(
                Text("⚠️ Native ad is not supported.").multilineTextAlignment(.center)
            )
        @unknown default:
            return AnyView(EmptyView())
        }
    }
}
