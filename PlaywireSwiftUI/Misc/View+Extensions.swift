//
//  View+Extensions.swift
//  PlaywireSwiftUI
//
//  Created by Inder Dhir on 10/7/25.
//

import SwiftUI

extension View {
    func onFirstAppear(_ action: @escaping () async -> Void) -> some View {
        modifier(FirstAppearModifier(action))
    }
}

struct FirstAppearModifier: ViewModifier {

    private let action: () async -> Void
    @State private var hasAppeared = false
    
    public init(_ action: @escaping () async -> Void) {
        self.action = action
    }
    
    public func body(content: Content) -> some View {
        content
            .task {
                guard !hasAppeared else { return }
                hasAppeared = true
                await action()
            }
    }
}
