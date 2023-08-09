//
//  BannerView.swift
//  PlaywireSDKAppsSwiftUI
//
//

import SwiftUI
import Playwire

struct BannerView: View {
        
    // The ad unit name, e.g. 'banner-320x50', 'interstitial-home', 'rewarded-coins', etc.
    let adUnitName: String
    @State var state: ViewAdState = .loading
    
    var body: some View {
        viewAdStatus(state: state, adUnitName: adUnitName, mode: .Banner)
        BannerContainer(adUnitName: adUnitName, state: $state)
    }
}

struct BannerContainer: UIViewControllerRepresentable {
    
    private let bannerView: PWBannerView
    @Binding var state: ViewAdState

    init(adUnitName: String, state: Binding<ViewAdState>) {
        self.bannerView = PWBannerView(adUnitName: adUnitName)
        self._state = state
    }

    func makeUIViewController(context: Context) -> some UIViewController {
        let hostViewController = BannerViewController()
        
        bannerView.delegate = context.coordinator
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        hostViewController.view.addSubview(bannerView)
          
        NSLayoutConstraint.activate([
          bannerView.bottomAnchor.constraint(equalTo: hostViewController.view.safeAreaLayoutGuide.bottomAnchor),
          bannerView.centerXAnchor.constraint(equalTo: hostViewController.view.centerXAnchor),
        ])
        
        // Use `PWLoadParams().withTargeting()` to pass your custom targets to ad request.
        // let params = PWLoadParams().withTargeting(
        //  [
        //    "age": "18-32",
        //    "page": "travel"
        //  ]
        // )
        // bannerView.load(params: params)
        
        bannerView.load()

        return hostViewController
    }
   
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    func makeCoordinator() -> BannerCoordinator {
        BannerCoordinator(self)
    }
}
