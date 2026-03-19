//
//  PlaywireSwiftUIApp.swift
//  PlaywireSwiftUI
//
//  Created by Inder Dhir on 10/7/25.
//

import Playwire
import SwiftUI

@main
struct PlaywireSwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            AdTypesView()
                .onFirstAppear {
                    PWNotifier.shared.startConsoleLogger()
                    PlaywireSDK.shared.test = false
                }

        }
    }
}
