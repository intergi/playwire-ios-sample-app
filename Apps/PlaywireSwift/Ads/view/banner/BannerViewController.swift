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

    private var bannerView: PWBannerView?
    private var bannerAdded = false
    
    init(adUnitName: String) {
        self.adUnitName = adUnitName
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(statusLabel)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // Use `PWLoadParams().withTargeting()` to pass your custom targets to ad request.
        // let params = PWLoadParams().withTargeting(
        //  [
        //    "age": "18-32",
        //    "page": "travel"
        //  ]
        // )
        // bannerView.load(params: params)
        
        bannerView = PWBannerView(adUnitName: adUnitName, delegate: self)
        bannerView?.load()
        statusLabel.text = "⏳ The banner \"\(adUnitName)\" is loading."
    }
    
    @IBAction func refreshAction(_ sender: UIButton) {
        // Refresh will start only if the ad unit contains `refresh` object.
        bannerView?.refresh()
    }
}

// MARK: - PWViewAdDelegate -
extension BannerViewController: PWViewAdDelegate{
    func viewAdDidLoad(_ ad: PWViewAd) {
        guard let bannerView = ad as? PWBannerView else { return }
        
        statusLabel.text = "✅ The banner \"\(adUnitName)\" is loaded."
        guard !bannerAdded else { return }
        bannerAdded = true
                
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
                
        NSLayoutConstraint.activate([
            bannerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bannerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func viewAdDidFailToLoad(_ ad: PWViewAd, error: PWAdError) {
        statusLabel.text = "❌ Failed to load the banner: \"\(error)\"."
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
