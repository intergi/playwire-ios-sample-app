//
//  CustomNativeAdView.swift
//  PlaywireDemo
//
//  Created by Playwire Mobile Team on 12/20/22.
//  Copyright © 2022 Playwire. All rights reserved.
//

import UIKit
import Playwire

final class CustomNativeAdView: UIView {
    
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var starLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var storeLabel: UILabel!
    @IBOutlet weak var advertiserLabel: UILabel!
    @IBOutlet weak var mediaViewHolder: UIView!
    @IBOutlet private weak var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        let name = String(describing: CustomNativeAdView.self)
        Bundle.main.loadNibNamed(name, owner: self)
        
        bounds = CGRect(origin: .zero, size: contentView.bounds.size)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configure(_ adContent: PWNativeViewContent) {
        // Configure views with ad content.
        iconView.image = adContent.icon
        
        headlineLabel.text = adContent.headline
        actionButton.setTitle(adContent.callToAction, for: .normal)
        bodyLabel.text = adContent.body
        
        starLabel.text = adContent.starRating.map { "\($0.stringValue) ⭐️" }
        // Hide view in case ad content doesn't contain required information.
        starLabel.isHidden = adContent.starRating == nil

        priceLabel.text = adContent.price
        priceLabel.isHidden = adContent.price == nil
        
        advertiserLabel.text = adContent.advertiser
        advertiserLabel.isHidden = adContent.advertiser == nil
        
        storeLabel.text = adContent.store
        storeLabel.isHidden = adContent.store == nil
                
        if let mediaView = adContent.mediaView {
            mediaView.translatesAutoresizingMaskIntoConstraints = false
            mediaViewHolder.addSubview(mediaView)
            NSLayoutConstraint.activate([
                mediaView.leadingAnchor.constraint(equalTo: mediaViewHolder.leadingAnchor),
                mediaView.trailingAnchor.constraint(equalTo: mediaViewHolder.trailingAnchor),
                mediaView.topAnchor.constraint(equalTo: mediaViewHolder.topAnchor),
                mediaView.bottomAnchor.constraint(equalTo: mediaViewHolder.bottomAnchor)
            ])
        }
    }
}
