//
//  InlineBannerView.swift
//  PlaywireSDKAppsSwiftUI
//
//

import SwiftUI
import Playwire

struct InlineBannerView: View {
        
    // The ad unit name, e.g. 'banner-320x50', 'interstitial-home', 'rewarded-coins', etc.
    let adUnitName: String
    @State var state: ViewAdState = .none
    
    var body: some View {
        viewAdStatus(state: state, adUnitName: adUnitName, mode: .Banner)
        InlineBannerContainer(adUnitName: adUnitName, state: $state)
    }
}

struct InlineBannerContainer: UIViewControllerRepresentable, AdaptiveBannerType {
    
    let adUnitName: String
    @State var viewWidth: CGFloat = CGFloat(320)
    @Binding var state: ViewAdState

    init(adUnitName: String, state: Binding<ViewAdState>) {
        self.adUnitName = adUnitName
        self._state = state
    }

    func makeUIViewController(context: Context) -> some UIViewController {
        let hostViewController = BannerViewController()
        let bannerView = PWBannerViewInline(adUnitName: adUnitName)

        context.coordinator.bannerView = bannerView
        bannerView.delegate = context.coordinator
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        hostViewController.view.addSubview(bannerView)
          
        NSLayoutConstraint.activate([
          bannerView.bottomAnchor.constraint(equalTo: hostViewController.view.safeAreaLayoutGuide.bottomAnchor),
          bannerView.centerXAnchor.constraint(equalTo: hostViewController.view.centerXAnchor),
        ])

        hostViewController.delegate = context.coordinator
        return hostViewController
    }
   
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        guard viewWidth != .zero && state == .loading else { return }
        
        // Use `PWLoadParams().withTargeting()` to pass your custom targets to ad request.
        // Use `PWLoadParams().withWidth()` to pass available width to fill with ad content. Get the width of the device in use, or set your own width if you don’t want to use the full width of the screen.
        // Use `PWLoadParams().withDeviceOrientation()` to include the orientation of your interface to ad request. Use `.unknown` value to allow SDK to determine the orientation.
        // let params = PWLoadParams().withTargeting(
        //  [
        //    "age": "18-32",
        //    "page": "travel"
        //  ]
        // )
        // .withWidth(320)
        // .withDeviceOrientation(.unknown)
        // bannerView.load(params: params)
        
        // Take the current orientation of the window scene or we can use `.unknown` value to allow SDK to determine the
        // orientation under the hood.

        let params = PWLoadParams()
            .withWidth(viewWidth)
            .withDeviceOrientation(.unknown)

        context.coordinator.bannerView.load(params: params)
    }
    
    func makeCoordinator() -> AdaptiveBannerCoordinator {
        AdaptiveBannerCoordinator(self)
    }
}
