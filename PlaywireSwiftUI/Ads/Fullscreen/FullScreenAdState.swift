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

func fullScreenAdStatus(state: FullScreenAdState, adUnitName: String, mode: PWAdUnit.PWAdMode) -> some View {
    let title = switch state {
    case .none:
        ""
    case .loading:
        "⏳ The \(mode.statusTitle) \"\(adUnitName)\" is loading."
    case .loaded:
        "✅ The \(mode.statusTitle) \"\(adUnitName)\" is loaded."
    case .failed:
        "❌ Failed to load the \(mode.statusTitle) \"\(adUnitName)\"."
    case .failedToPresent:
        "❌ Failed to present the \(mode.statusTitle) \"\(adUnitName)\"."
    case .presented:
        "👍 The \(mode.statusTitle) \"\(adUnitName)\" was successfully presented."
    case .earnedReward(let type, let amount):
        "🎉 The reward was earned.\n Type: \(type)  \n Amount: \(amount)."
    }
    
    return Text(title)
        .font(.body)
        .multilineTextAlignment(.center)
}
