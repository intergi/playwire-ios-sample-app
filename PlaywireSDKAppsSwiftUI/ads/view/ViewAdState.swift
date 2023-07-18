//
//  ViewAdState.swift
//  PlaywireSDKAppsSwiftUI
//
//

import SwiftUI
import Playwire

enum ViewAdState: Equatable {
    case none
    case loading
    case loaded
    case failed
}

func viewAdStatus(state: ViewAdState, adUnitName: String, mode: PWAdUnit.PWAdMode) -> some View {
    let title: String
    switch state {
    case .none:
        title = ""
    case .loading:
        title = "⏳ The \(mode.statusTitle) \"\(adUnitName)\" is loading."
    case .loaded:
        title = "✅ The \(mode.statusTitle) \"\(adUnitName)\" is loaded."
    case .failed:
        title = "❌ Failed to load the \(mode.statusTitle) \"\(adUnitName)\"."
    }
    return Text(title)
        .font(.body)
        .multilineTextAlignment(.center)
}
