//
//  BannerViewController.swift
//  PlaywireDemo
//
//  Created by Playwire Mobile Team on 12/20/22.
//  Copyright © 2022 Playwire. All rights reserved.
//

import Playwire
import UIKit

final class BannerViewController: UIViewController {
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    // The ad unit name, e.g. 'banner-320x50', 'interstitial-home', 'rewarded-coins', etc.
    let adUnitName: String
    private let bannerType: String

    private var bannerViewBase: PWBannerViewBase!
    
    init(adUnitName: String, bannerType: String) {
        self.adUnitName = adUnitName
        self.bannerType = bannerType
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        bannerViewBase = if bannerType == PWAdUnit.PWAdMode_Banner {
            PWBannerView(adUnitName: adUnitName, delegate: self)
        } else if bannerType == PWAdUnit.PWAdMode_BannerAnchored {
            PWBannerViewAnchored(adUnitName: adUnitName, delegate: self)
        } else if bannerType == PWAdUnit.PWAdMode_BannerInline {
            PWBannerViewInline(adUnitName: adUnitName, delegate: self)
        } else {
            nil
        }
        
        bannerViewBase.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerViewBase)
        
        NSLayoutConstraint.activate([
            bannerViewBase.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bannerViewBase.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        // Use `PWLoadParams().withTargeting()` to pass your custom targets to ad request.
        // let params = PWLoadParams().withTargeting(
        //  [
        //    "age": "18-32",
        //    "page": "travel"
        //  ]
        // )
        // bannerView.load(params: params)
        
        bannerViewBase.load()
        statusLabel.text = "⏳ The banner \"\(adUnitName)\" is loading."
    }
    
    @IBAction func refreshAction(_ sender: UIButton) {
        // Refresh will start only if the ad unit contains `refresh` object.
        // See logs from `PWNotifier` to track status of refresh.
        
        bannerViewBase.refresh()

        let adUnits = PlaywireSDK.shared.config?.adUnits
        let refresh = adUnits?.first { $0.name == adUnitName }?.refresh
        guard refresh != nil else {
            statusLabel.text = "⚠️ The banner \"\(adUnitName)\" can't be refreshed manually.\nSee logs to get more details."
            return
        }
        statusLabel.text = "🔄 The banner \"\(adUnitName)\" is refreshing."
    }
}

// MARK: - PWViewAdDelegate -
extension BannerViewController: PWViewAdDelegate {
    func viewAdDidLoad(_ ad: PWViewAd) {
        guard bannerViewBase.isLoaded else { return }
        
        statusLabel.text = "✅ The banner \"\(adUnitName)\" is loaded."
    }
    
    func viewAdDidFailToLoad(_ ad: PWViewAd) {
        statusLabel.text = "❌ Failed to load the banner \"\(adUnitName)\"."
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
