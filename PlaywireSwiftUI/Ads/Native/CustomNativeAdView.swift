//
//  CustomNativeAdView.swift
//  PlaywireSDKApps
//
//  Created by Inder Dhir on 10/7/25.
//

import Foundation
import GoogleMobileAds
import Playwire
import UIKit

final class CustomNativeAdView: UIView {
    private var headlineLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private var bodyLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        return label
    }()
    
    private var iconView = UIImageView()
    private var actionButton = UIButton()
    private var imageView = UIImageView()
    
    private var starLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        return label
    }()
    
    private var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        return label
    }()
    
    private var storeLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        return label
    }()
    
    private var advertiserLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        return label
    }()
    
    private var contentView = UIView()
    
    let button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle(String(localized: "Click"), for: .normal)
        return button
    }()
    
    let adContent: PWNativeViewContent
    
    init(adContent: PWNativeViewContent) {
        self.adContent = adContent
        
        super.init(frame: .zero)
        
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        iconView.translatesAutoresizingMaskIntoConstraints = false
        headlineLabel.translatesAutoresizingMaskIntoConstraints = false
        advertiserLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(iconView)
        addSubview(headlineLabel)
        addSubview(advertiserLabel)
        addSubview(imageView)
        addSubview(bodyLabel)
        addSubview(button)

        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 30),
            iconView.heightAnchor.constraint(equalToConstant: 30),
            iconView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            iconView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            
            headlineLabel.topAnchor.constraint(equalTo: iconView.topAnchor),
            headlineLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 10),
            headlineLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            advertiserLabel.bottomAnchor.constraint(equalTo: iconView.bottomAnchor),
            advertiserLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 10),
            advertiserLabel.widthAnchor.constraint(equalToConstant: 50),
            
            imageView.topAnchor.constraint(equalTo: advertiserLabel.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: advertiserLabel.trailingAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 20),
            imageView.heightAnchor.constraint(equalToConstant: 20),
            
            bodyLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 20),
            bodyLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            bodyLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: 200),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        iconView.image = adContent.icon
        headlineLabel.text = adContent.headline
        advertiserLabel.text = adContent.advertiser
        imageView.image = adContent.image
        bodyLabel.text = adContent.body
        
        let mediaView = adContent.mediaView
        if let mediaView {
            mediaView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(mediaView)
            
            NSLayoutConstraint.activate([
                mediaView.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 10),
                mediaView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
                mediaView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
                mediaView.heightAnchor.constraint(equalToConstant: 200),
                
                button.topAnchor.constraint(equalTo: mediaView.bottomAnchor, constant: 10)
            ])
        }
        
        button.setTitle(adContent.callToAction, for: .normal)
    }
}
