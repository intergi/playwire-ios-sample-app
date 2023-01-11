//
//  BannerViewController.swift
//  PlaywireDemo
//
//  Created by Playwire Mobile Team on 12/20/22.
//  Copyright © 2022 Playwire. All rights reserved.
//

import Playwire
import UIKit

final class BannerViewController: UIViewController, AdUnitViewControllerType {
    
    @IBOutlet weak var statusLabel: UILabel!
    
    // The ad unit name, e.g. 'banner-320x50', 'interstitial-home', 'rewarded-coins', etc.
    var adUnitName: String!
    
    private lazy var bannerView = PWBannerView(adUnitName: adUnitName, delegate: self)
    private var isBannerAdded: Bool = false
    private var name: String { adUnitName ?? "NULL"}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use `PWLoadParams().withTargeting()` to pass your custom targets to ad request.
        // let params = PWLoadParams().withTargeting(
        //  [
        //    "age": "18-32",
        //    "page": "travel"
        //  ]
        // )
        // bannerView.load(params: params)
        
        bannerView.load()
        statusLabel.text = "⏳ The banner \"\(name)\" is loading."
    }
    
    private func addBannerToSuperView() {
        guard !isBannerAdded else { return }
        isBannerAdded = true
        
        // Banner is ready to be added to view hierarchy
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        NSLayoutConstraint.activate([
            bannerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            bannerView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            bannerView.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])
    }
    
    @IBAction func refreshAction(_ sender: UIButton) {
        // Refresh will start only if the ad unit contains `refresh` object.
        // See logs from `PWNotifier` to track status of refresh.
        
        bannerView.refresh()

        let adUnits = PlaywireSDK.shared.config?.adUnits
        let refresh = adUnits?.first { $0.name == adUnitName }?.refresh
        guard refresh != nil else {
            statusLabel.text = "⚠️ The banner \"\(name)\" can't be refreshed manually.\nSee logs to get more details."
            return
        }
        statusLabel.text = "🔄 The banner \"\(name)\" is refreshing."
    }
}

// MARK: - PWViewAdDelegate -
extension BannerViewController: PWViewAdDelegate {
    func viewAdDidLoad(_ ad: PWViewAd) {
        guard bannerView.isLoaded else { return }
        
        statusLabel.text = "✅ The banner \"\(name)\" is loaded."
        addBannerToSuperView()
    }
    
    func viewAdDidFailToLoad(_ ad: PWViewAd) {
        statusLabel.text = "❌ Failed to load the banner \"\(name)\"."
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
