//
//  PlaywireSDKAppsSwiftUIApp.swift
//  PlaywireSDKAppsSwiftUI
//
//

import SwiftUI

@main
struct PlaywireSDKAppsSwiftUIApp: App {
    
    var body: some Scene {
        WindowGroup {
            AdTypesView()
        }
    }
}

extension UIApplication {
    func rootViewController() -> UIViewController? {
        guard let windowScene = connectedScenes.first as? UIWindowScene else {
            return nil
        }
        return windowScene.windows.first?.rootViewController
    }
}
