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
                    #if DEBUG
                    // Logging
                    PWNotifier.shared.startConsoleLogger()
                    
                    // Enable test mode for debug builds to avoid `no fill` issues and be able to test your implementation with test ads.
                    PlaywireSDK.shared.test = true
                    #endif
                }

        }
    }
}
