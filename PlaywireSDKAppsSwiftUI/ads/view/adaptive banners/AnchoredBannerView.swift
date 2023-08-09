//
//  AnchoredBannerView.swift
//  PlaywireSDKAppsSwiftUI
//
//

import SwiftUI
import Playwire

struct AnchoredBannerView: View {
        
    // The ad unit name, e.g. 'banner-320x50', 'interstitial-home', 'rewarded-coins', etc.
    let adUnitName: String
    @State var state: ViewAdState = .none
    
    var body: some View {
        viewAdStatus(state: state, adUnitName: adUnitName, mode: .Banner)
        AnchoredBannerContainer(adUnitName: adUnitName, state: $state)
    }
}

struct AnchoredBannerContainer: UIViewControllerRepresentable, AdaptiveBannerType {
    
    private let bannerView: PWBannerViewAnchored
    @State var viewWidth: CGFloat = .zero
    @Binding var state: ViewAdState

    init(adUnitName: String, state: Binding<ViewAdState>) {
        self.bannerView = PWBannerViewAnchored(adUnitName: adUnitName)
        self._state = state
    }

    func makeUIViewController(context: Context) -> some UIViewController {
        let hostViewController = BannerViewController()
        hostViewController.delegate = context.coordinator
        return hostViewController
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        guard viewWidth != .zero && state == .loading else { return }
        
        // remove banner which was added in the previous orientation
        uiViewController.view.subviews
            .filter { $0 is PWBannerViewInline }
            .forEach { $0.removeFromSuperview() }
        
        // configure banner and activate constraints
        bannerView.delegate = context.coordinator
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        uiViewController.view.addSubview(bannerView)
        
        NSLayoutConstraint.activate([
          bannerView.bottomAnchor.constraint(equalTo: uiViewController.view.safeAreaLayoutGuide.bottomAnchor),
          bannerView.centerXAnchor.constraint(equalTo: uiViewController.view.centerXAnchor),
        ])
        
        // Use `PWLoadParams().withTargeting()` to pass your custom targets to ad request.
        // Use `PWLoadParams().withWidth()` to pass available width to fill with ad content. Get the width of the device in use, or set your own width if you don’t want to use the full width of the screen.
        // let params = PWLoadParams().withTargeting(
        //  [
        //    "age": "18-32",
        //    "page": "travel"
        //  ]
        // )
        // .withWidth(320)
        // bannerView.load(params: params)

        let params = PWLoadParams()
            .withWidth(viewWidth)

        bannerView.load(params: params)
    }
    
    func makeCoordinator() -> AdaptiveBannerCoordinator {
        AdaptiveBannerCoordinator(self)
    }
}

