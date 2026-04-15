//
//  NativeViewController.swift
//  PlaywireDemo
//
//  Created by Playwire Mobile Team on 12/20/22.
//  Copyright © 2022 Playwire. All rights reserved.
//

import GoogleMobileAds
import Playwire
import UIKit

final class NativeViewController: UIViewController {
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    // The ad unit name, e.g. 'banner-320x50', 'interstitial-home', 'rewarded-coins', etc.
    private let adUnitName: String
    
    private lazy var nativeView: PWNativeView = {
        PWNativeView(
            adUnitName: adUnitName,
            controller: self,
            factory: self,
            delegate: self
        )
    }()
    
    private lazy var mainStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nativeView, statusLabel])
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .fill
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        return stack
    }()
    
    init(adUnitName: String) {
        self.adUnitName = adUnitName
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        setupLayout()
        
        // Use `PWLoadParams().withTargeting()` to pass your custom targets to ad request.
        // let params = PWLoadParams().withTargeting(
        //  [
        //    "age": "18-32",
        //    "page": "travel"
        //  ]
        // )
        // nativeView.load(params: params)
        nativeView.load()
        
        statusLabel.text = "⏳ The native ad \"\(adUnitName)\" is loading."
    }
    
    private func setupLayout() {
        view.addSubview(mainStack)
            
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainStack.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension NativeViewController: PWViewAdDelegate {
    func viewAdDidLoad(_ ad: PWViewAd) {
        guard nativeView.isLoaded else { return }
        
        statusLabel.text = "✅ The native ad \"\(adUnitName)\" is loaded."
    }
    
    func viewAdDidFailToLoad(_ ad: PWViewAd) {
        statusLabel.text = "❌ Failed to load the native ad \"\(adUnitName)\"."
    }
    
    func viewAdWillPresentFullScreenContent(_ ad: PWViewAd) {
    }
    
    func viewAdWillDismissFullScreenContent(_ ad: PWViewAd) {
    }
    
    func viewAdDidDismissFullScreenContent(_ ad: PWViewAd) {
    }
    
    func viewAdDidRecordImpression(_ ad: PWViewAd) {
        statusLabel.text = "The native ad \"\(adUnitName)\" recorded an impression."
    }
    
    func viewAdDidRecordClick(_ ad: PWViewAd) {
        statusLabel.text = "The native ad \"\(adUnitName)\" was clicked."
    }
}

extension NativeViewController: PWNativeViewFactory {
    func createAdContentView() -> PWNativeViewContentView {
        NativeView()
    }
}
