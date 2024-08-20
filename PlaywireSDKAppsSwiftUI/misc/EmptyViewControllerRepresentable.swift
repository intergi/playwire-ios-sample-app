//
//  EmptyViewControllerRepresentable.swift
//  PlaywireSDKAppsSwiftUI
//
//

import SwiftUI

struct EmptyViewControllerRepresentable: UIViewControllerRepresentable {
    let viewController = UIViewController()

    func makeUIViewController(context: Context) -> some UIViewController {
      return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
