//
//  AnchoredBannerViewController.swift
//  PlaywireDemo
//
//  Created by Playwire Mobile Team on 12/20/22.
//  Copyright © 2023 Playwire. All rights reserved.
//

import Playwire
import UIKit

final class AnchoredBannerViewController: UIViewController, AdUnitViewControllerType {
    
    @IBOutlet weak var statusLabel: UILabel!
    
    // The ad unit name, e.g. 'banner-320x50', 'interstitial-home', 'rewarded-coins', etc.
    var adUnitName: String!
    
    private var bannerView: PWBannerViewAnchored!
    private var isBannerAdded: Bool = false
    private var name: String { adUnitName ?? "NULL"}
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard !isBannerAdded else { return }
        loadBanner()
    }
    
    private func loadBanner() {
        bannerView = PWBannerViewAnchored(adUnitName: adUnitName, delegate: self)
        
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
        
        
        // Determine the view width to use for the ad width.
        let frame = { () -> CGRect in
            // Here safe area is taken into account, hence the view frame is used after the view has been laid out.
            if #available(iOS 11.0, *) {
                return view.frame.inset(by: view.safeAreaInsets)
            } else {
                return view.frame
            }
        }()
        let viewWidth = frame.size.width
        
        let params = PWLoadParams()
            .withWidth(viewWidth)
        
        bannerView.load(params: params)
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
extension AnchoredBannerViewController: PWViewAdDelegate {
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


