//
//  NativeContainerView.swift
//  PlaywireSDKApps
//
//  Created by Playwire Mobile Team on 2026-04-10.
//

import UIKit

// MARK: - Delegate

@MainActor
@objc(NativeContainerViewDelegate)
public protocol NativeContainerViewDelegate: AnyObject {
    @objc optional func nativeContainerViewDidStartLoading(_ containerView: NativeContainerView, adUnitName: String)
    @objc optional func nativeContainerViewDidLoad(_ containerView: NativeContainerView, adUnitName: String)
    @objc optional func nativeContainerViewDidFailToLoad(_ containerView: NativeContainerView, adUnitName: String)
    @objc optional func nativeContainerViewDidRecordImpression(_ containerView: NativeContainerView, adUnitName: String)
    @objc optional func nativeContainerViewDidRecordClick(_ containerView: NativeContainerView, adUnitName: String)
}

// MARK: - Container View

@MainActor
@objc(NativeContainerView)
@objcMembers
public final class NativeContainerView: UIView {

    public weak var delegate: NativeContainerViewDelegate?

    private let adUnitName: String
    private weak var controller: UIViewController?

    private lazy var impl: NativeContainerViewImpl = {
        NativeContainerViewImpl(
            adUnitName: adUnitName,
            controller: controller,
            onLoad: { [weak self] in
                guard let self else { return }
                self.delegate?.nativeContainerViewDidLoad?(self, adUnitName: self.adUnitName)
            },
            onFailToLoad: { [weak self] in
                guard let self else { return }
                self.delegate?.nativeContainerViewDidFailToLoad?(self, adUnitName: self.adUnitName)
            },
            onImpression: { [weak self] in
                guard let self else { return }
                self.delegate?.nativeContainerViewDidRecordImpression?(self, adUnitName: self.adUnitName)
            },
            onClick: { [weak self] in
                guard let self else { return }
                self.delegate?.nativeContainerViewDidRecordClick?(self, adUnitName: self.adUnitName)
            }
        )
    }()

    // MARK: - Init

    @objc(initWithAdUnitName:controller:)
    public init(adUnitName: String, controller: UIViewController) {
        self.adUnitName = adUnitName
        self.controller = controller
        super.init(frame: .zero)
        setupView()
    }

    override init(frame: CGRect) {
        fatalError("Use init(adUnitName:controller:) instead")
    }

    required init?(coder: NSCoder) {
        fatalError("Use init(adUnitName:controller:) instead")
    }

    // MARK: - Setup

    private func setupView() {
        let nativeView = impl.nativeView
        nativeView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nativeView)

        NSLayoutConstraint.activate([
            nativeView.topAnchor.constraint(equalTo: topAnchor),
            nativeView.leadingAnchor.constraint(equalTo: leadingAnchor),
            nativeView.trailingAnchor.constraint(equalTo: trailingAnchor),
            nativeView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    // MARK: - Public API

    @objc(loadAd)
    public func loadAd() {
        delegate?.nativeContainerViewDidStartLoading?(self, adUnitName: adUnitName)
        impl.load()
    }
}
