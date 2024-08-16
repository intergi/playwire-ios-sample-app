//
//  AdaptiveBannerCoordinator.swift
//  PlaywireSDKAppsSwiftUI
//
//

import SwiftUI
import Playwire

protocol AdaptiveBannerType {
    var state: ViewAdState { get set }
    var viewWidth: CGFloat { get set }
}

class AdaptiveBannerCoordinator: NSObject, PWViewAdDelegate, BannerViewControllerWidthDelegate {
    
    private var banner: AdaptiveBannerType
    var bannerView: PWBannerViewInline!

    init(_ banner: AdaptiveBannerType) {
        self.banner = banner
    }

    // MARK: - PWViewAdDelegate
    func viewAdDidLoad(_ ad: Playwire.PWViewAd) {
        banner.state = .loaded
    }
    
    func viewAdDidFailToLoad(_ ad: Playwire.PWViewAd) {
        banner.state = .failed
    }
    
    func viewAdWillPresentFullScreenContent(_ ad: Playwire.PWViewAd) {
    }
    
    func viewAdWillDismissFullScreenContent(_ ad: Playwire.PWViewAd) {
    }
    
    func viewAdDidDismissFullScreenContent(_ ad: Playwire.PWViewAd) {
    }
    
    func viewAdDidRecordImpression(_ ad: Playwire.PWViewAd) {
    }
    
    func viewAdDidRecordClick(_ ad: Playwire.PWViewAd) {
    }
    
    // MARK: - BannerViewControllerWidthDelegate methods
    
    func bannerViewController(_ bannerViewController: BannerViewController, didUpdate width: CGFloat) {
        banner.viewWidth = width
        banner.state = .loading
    }
}
