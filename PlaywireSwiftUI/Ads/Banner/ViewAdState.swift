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

func viewAdStatus(state: ViewAdState, adUnitName: String) -> some View {
    let title = switch state {
    case .none:
        ""
    case .loading:
        "⏳ The \"\(adUnitName)\" is loading."
    case .loaded:
        "✅ The \"\(adUnitName)\" is loaded."
    case .failed:
        "❌ Failed to load the \"\(adUnitName)\"."
    }
    
    return Text(title)
        .font(.body)
        .multilineTextAlignment(.center)
}
