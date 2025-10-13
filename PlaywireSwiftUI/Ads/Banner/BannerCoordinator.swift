//
//  BannerCoordinator.swift
//  PlaywireSDKAppsSwiftUI
//
//

import Playwire
import SwiftUI

class BannerCoordinator: NSObject, PWViewAdDelegate {
    
    private let banner: BannerContainer

    init(_ banner: BannerContainer) {
        self.banner = banner
    }
        
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
}
