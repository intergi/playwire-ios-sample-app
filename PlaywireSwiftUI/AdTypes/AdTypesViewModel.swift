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
        let mode: String
    }

    var adUnits: [AdUnit] = []
    
    func initializeSDK(publisherId: String, appId: String, viewController: UIViewController) {
        PlaywireSDK.shared.start(
            publisherId: publisherId,
            appId: appId,
            viewController: viewController
        ) { success, error in
            if success {
                var units: [AdUnit] = []
                PlaywireSDK.shared.adUnitsDictionary.forEach { (key, values) in
                    for value in values {
                        let adUnit = AdUnit(name: value, mode: key)
                        units.append(adUnit)
                    }
                }
                self.adUnits = units.sorted(by: { $0.name < $1.name })
            } else {
                self.adUnits = []
                print("SDK start failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
}
