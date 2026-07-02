//
//  FullScreenAdState.swift
//  PlaywireSDKAppsSwiftUI
//
//

import SwiftUI
import Playwire

enum FullScreenAdState: Equatable {
    case none
    case loading
    case loaded
    case failed
    case failedToPresent
    case presented
    
    case earnedReward(String, Int)
}

func fullScreenAdStatus(state: FullScreenAdState, adUnitName: String) -> some View {
    let title = switch state {
    case .none:
        ""
    case .loading:
        "⏳ The \"\(adUnitName)\" is loading."
    case .loaded:
        "✅ The \"\(adUnitName)\" is loaded."
    case .failed:
        "❌ Failed to load the \"\(adUnitName)\"."
    case .failedToPresent:
        "❌ Failed to present the \"\(adUnitName)\"."
    case .presented:
        "👍 The \"\(adUnitName)\" was successfully presented."
    case .earnedReward(let type, let amount):
        "🎉 The reward was earned.\n Type: \(type)  \n Amount: \(amount)."
    }
    
    return Text(title)
        .font(.body)
        .multilineTextAlignment(.center)
}
