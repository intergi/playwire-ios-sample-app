//
//  ViewAdState.swift
//  PlaywireSDKAppsSwiftUI
//
//

import SwiftUI
import Playwire

enum ViewAdState: Equatable {
    case none, loading, loaded, failed
}

func viewAdStatus(state: ViewAdState, adUnitName: String, mode: PWAdUnit.PWAdMode) -> some View {
    let title = switch state {
    case .none:
        ""
    case .loading:
        "⏳ The \(mode.statusTitle) \"\(adUnitName)\" is loading."
    case .loaded:
        "✅ The \(mode.statusTitle) \"\(adUnitName)\" is loaded."
    case .failed:
        "❌ Failed to load the \(mode.statusTitle) \"\(adUnitName)\"."
    }
    
    return Text(title)
        .font(.body)
        .multilineTextAlignment(.center)
}
