//
//  BannerViewController.swift
//  PlaywireSDKAppsSwiftUI
//
//

import SwiftUI

protocol BannerViewControllerWidthDelegate: AnyObject {
  func bannerViewController(_ bannerViewController: BannerViewController, didUpdate width: CGFloat)
}

final class BannerViewController: UIViewController {
    
    weak var delegate: BannerViewControllerWidthDelegate?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let width = view.frame.inset(by: view.safeAreaInsets).size.width
        delegate?.bannerViewController(self, didUpdate: width)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate { _ in } completion: { _ in
            let width = self.view.frame.inset(by: self.view.safeAreaInsets).size.width
            self.delegate?.bannerViewController(self, didUpdate: width)
        }
    }
}
