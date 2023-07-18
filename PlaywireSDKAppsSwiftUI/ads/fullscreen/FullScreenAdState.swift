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
    case .failedToPresent:
        title = "❌ Failed to present the \(mode.statusTitle) \"\(adUnitName)\"."
    case .presented:
        title = "👍 The \(mode.statusTitle) \"\(adUnitName)\" was successfully presented."
    case .earnedReward(let type, let amount):
        title = "🎉 The reward is earned.\n Type: \(type)  \n Amount: \(amount)."
    }
    
    return Text(title)
        .font(.body)
        .multilineTextAlignment(.center)
}
