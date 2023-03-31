//
//  BannerLayoutViewController.swift
//  PlaywireSDKApps
//
//  Created by Playwire Mobile Team on 03/30/23.
//  Copyright © 2022 Playwire. All rights reserved.
//

import Playwire
import UIKit

final class BannerLayoutViewController: UIViewController {
    
    @IBOutlet weak var userDefinedAttributesBannerStatusLabel: UILabel!
    @IBOutlet weak var codeSetupBannerStatusLabel: UILabel!

    @IBOutlet weak var userDefinedAttributesBanner: PWBannerView!
    @IBOutlet weak var codeSetupBanner: PWBannerView!

    // The ad unit name, e.g. 'banner-320x50', 'interstitial-home', 'rewarded-coins', etc.
    let userDefinedAttributesBannerName: String = "Banner-320x50"
    
    // The ad unit name, e.g. 'banner-320x50', 'interstitial-home', 'rewarded-coins', etc.
    let codeSetupBannerName: String = "Banner-300x250"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // See `User Defined Runtime Attributes` section in the Main.storyboad where params are configured.
        // Set `PWViewAdDelegate` delegate to inform you about a view ad lifecycle.
        userDefinedAttributesBanner.delegate = self
        
        // Add view to a `.storyboad` file and configure with required parameters.
        // Set `PWViewAdDelegate` delegate to inform you about a view ad lifecycle.
        codeSetupBanner.delegate = self
        codeSetupBanner.adUnitName = codeSetupBannerName
        // Use `PWLoadParams().withTargeting()` to pass your custom targets to ad request.
        // let params = PWLoadParams().withTargeting(
        //  [
        //    "age": "18-32",
        //    "page": "travel"
        //  ]
        // )
        // bannerView.load(params: params)
        codeSetupBanner.load()
        
        userDefinedAttributesBannerStatusLabel.text = "⏳ The banner \"\(userDefinedAttributesBannerName)\" is loading."
        codeSetupBannerStatusLabel.text = "⏳ The banner \"\(codeSetupBannerName)\" is loading."
    }
}

// MARK: - PWViewAdDelegate -
extension BannerLayoutViewController: PWViewAdDelegate {
    func viewAdDidLoad(_ ad: PWViewAd) {
        if (ad === userDefinedAttributesBanner) {
            userDefinedAttributesBannerStatusLabel.text = "✅ The banner \"\(userDefinedAttributesBannerName)\" is loaded."
        } else {
            codeSetupBannerStatusLabel.text = "✅ The banner \"\(codeSetupBannerName)\" is loaded."
        }
    }
    
    func viewAdDidFailToLoad(_ ad: PWViewAd) {
        if (ad === userDefinedAttributesBanner) {
            userDefinedAttributesBannerStatusLabel.text = "❌ Failed to load the banner \"\(userDefinedAttributesBannerName)\"."
        } else {
            codeSetupBannerStatusLabel.text = "❌ Failed to load the banner \"\(codeSetupBannerName)\"."
        }
    }
    
    func viewAdWillPresentFullScreenContent(_ ad: PWViewAd) {
    }
    
    func viewAdWillDismissFullScreenContent(_ ad: PWViewAd) {
    }
    
    func viewAdDidDismissFullScreenContent(_ ad: PWViewAd) {
    }
    
    func viewAdDidRecordImpression(_ ad: PWViewAd) {
    }
    
    func viewAdDidRecordClick(_ ad: PWViewAd) {
    }
}
