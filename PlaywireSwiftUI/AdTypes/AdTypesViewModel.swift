//
//  AdTypesViewModel.swift
//  PlaywireSDKAppsSwiftUI
//
//

import SwiftUI
import Observation
import Playwire

@Observable final class AdTypesViewModel {
    struct AdUnit: Identifiable {
        var id: String { name }
        
        let name: String
        let mode: PWAdUnit.PWAdMode
    }

    var adUnits: [AdUnit] = []
    
    func initializeSDK(publisherId: String, appId: String, viewController: UIViewController) {
        PlaywireSDK.shared.initialize(publisherId: publisherId, appId: appId, viewController: viewController) {
            let units = PlaywireSDK.shared.config?.adUnits.map { AdUnit(name: $0.name, mode: $0.mode) } ?? []
            self.adUnits = units.sorted(by: { $0.name < $1.name })
        }
    }
}
