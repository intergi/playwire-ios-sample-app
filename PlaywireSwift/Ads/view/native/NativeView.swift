//
//  NativeView.swift
//  PlaywireSDKApps
//
//  Created by Enosh Mosuganti on 2026-04-08.
//

import UIKit
import Playwire

final class NativeView: UIStackView, PWNativeViewContentView {
    
    var headlineLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        label.numberOfLines = 0
        return label
    }()
    
    var adAttributionView: UIView = {
        let label = UILabel()
        label.text = "Sponsored"
        label.font = .systemFont(ofSize: 11, weight: .semibold)
        label.textColor = .secondaryLabel
        return label
    }()
    
    var mediaView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(greaterThanOrEqualToConstant: 120).isActive = true
        view.widthAnchor.constraint(greaterThanOrEqualToConstant: 120).isActive = true
        view.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        return view
    }()
    
    var bodyLabel: UILabel? = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        return label
    }()
    
    var advertiserLabel: UILabel? = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()
    
    var iconImageView: UIImageView? = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 6
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 40).isActive = true
        view.widthAnchor.constraint(equalToConstant: 40).isActive = true
        return view
    }()
    
    var storeLabel: UILabel? = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    
    var priceLabel: UILabel? = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = .systemGreen
        return label
    }()
    
    var starRatingView: UIView? = {
        let view = UIView()
        return view
    }()
    
    private lazy var metadataStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [starRatingView!, priceLabel!, storeLabel!])
        stack.axis = .horizontal
        stack.spacing = 6
        stack.alignment = .center
        return stack
    }()
    
    var callToActionButton: UIButton? = {
        let button = UIButton(type: .system)
        return button
    }()
    
    private lazy var headerStack: UIStackView = {
        let textStack = UIStackView(arrangedSubviews: [headlineLabel, advertiserLabel!, metadataStack])
        textStack.axis = .vertical
        textStack.spacing = 4
            
        let stack = UIStackView(arrangedSubviews: [iconImageView!, textStack])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .top
        return stack
    }()

    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        axis = .vertical
        spacing = 12
        alignment = .fill
        distribution = .fill
        
        addArrangedSubview(adAttributionView)
        addArrangedSubview(headerStack)
        addArrangedSubview(bodyLabel!)
        addArrangedSubview(mediaView)
        addArrangedSubview(callToActionButton!)
    }
}
