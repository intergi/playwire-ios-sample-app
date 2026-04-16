//
//  PlaywireSwiftUIApp.swift
//  PlaywireSwiftUI
//
//  Created by Inder Dhir on 10/7/25.
//

import Playwire
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {

    @objc var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        PWNotifier.shared.startConsoleLogger()
        PlaywireSDK.shared.test = false
        return true
    }
}

@main
struct PlaywireSwiftUIApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            AdTypesView()
        }
    }
}
