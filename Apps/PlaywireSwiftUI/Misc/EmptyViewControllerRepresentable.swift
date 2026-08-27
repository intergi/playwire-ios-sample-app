//
//  EmptyViewControllerRepresentable.swift
//  PlaywireSDKAppsSwiftUI
//
//

import SwiftUI

struct EmptyViewControllerRepresentable: UIViewControllerRepresentable {
    let viewController = UIViewController()

    func makeUIViewController(context: Context) -> some UIViewController {
      viewController
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
