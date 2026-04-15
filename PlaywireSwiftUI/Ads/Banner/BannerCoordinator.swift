//
//  BannerCoordinator.swift
//  PlaywireSDKAppsSwiftUI
//
//

import Playwire
import SwiftUI

class BannerCoordinator: NSObject, PWViewAdDelegate {
    
    private let state: Binding<ViewAdState>

    init(state: Binding<ViewAdState>) {
        self.state = state
    }
        
    func viewAdDidLoad(_ ad: Playwire.PWViewAd) {
        state.wrappedValue = .loaded
    }
    
    func viewAdDidFailToLoad(_ ad: Playwire.PWViewAd) {
        state.wrappedValue = .failed
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
