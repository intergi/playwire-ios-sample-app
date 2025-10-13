//
//  NativeAdState.swift
//  PlaywireSDKApps
//
//  Created by Inder Dhir on 10/7/25.
//

import Foundation
import Playwire
import SwiftUI

enum NativeAdState: Equatable {
    case none, loading, loaded, failed
}

func nativeAdStatus(state: NativeAdState, adUnitName: String, mode: PWAdUnit.PWAdMode) -> some View {
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
