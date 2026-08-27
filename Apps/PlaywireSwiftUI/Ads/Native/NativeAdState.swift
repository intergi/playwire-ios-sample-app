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

func nativeAdStatus(state: NativeAdState, adUnitName: String) -> some View {
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
