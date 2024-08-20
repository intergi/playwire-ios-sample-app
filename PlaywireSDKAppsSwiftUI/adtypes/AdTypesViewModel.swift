//
//  AdTypesViewModel.swift
//  PlaywireSDKAppsSwiftUI
//
//

import SwiftUI
import Playwire

final class AdTypesViewModel: ObservableObject {
    struct AdUnit: Identifiable {
        var id: String { name }
        
        let name: String
        let mode: PWAdUnit.PWAdMode
    }

    @Published var adUnits: [AdUnit] = []
    private var interstitialListener: PWListenerToken?
    
    func inititalizeSDK(publisherId: String, appId: String, viewController: UIViewController) {
        
        #if DEBUG
            // Start `PWNotifier` to log SDK events to console.
            PWNotifier.shared.startConsoleLogger()
            
            // Use method below to filter SDK events by name or severity.
            //
            // Filter and log only events with `PWC.EVT_gamRequestFail` name.
            // PWNotifier.shared.startConsoleLogger { event, critical, context in
            //    event == PWC.EVT_gamRequestFail
            // }
            //
            // Filter and log only critical events.
            // PWNotifier.shared.startConsoleLogger { _, critical, _ in
            //    critical
            // }

            // Use a custom-made listener to handle events with custom actions.
            // You can cancel subscription once it's not needed. See the `deinit` method.
            //
            // In the example below we create a subscription to listen to all successful interstitial loading events.
            interstitialListener = PWNotifier.shared.addListener(self, filter: { event, critical, context in
                event == PWC.EVT_gamRequestSuccess && context[PWC.EVT_CTX_adUnit_mode] as! String == PWAdUnit.PWAdMode.Interstitial.rawValue
             }, action: {listener, event, critical, context, data in
                // Use event data regarding your business objectives, e.g, send analytics record, etc.
            })
        #endif

        // If you use Firebase, don't forget to configure Firebase application.
        // Make sure you run it before Playwire SDK initialization.
        //
        // FirebaseApp.configure()

        #if DEBUG
            // Enable test mode for debug builds to avoid `no fill` issues and be able to test your implementation with test ads.
            PlaywireSDK.shared.test = true
        #endif
        
        PlaywireSDK.shared.initialize(publisherId: publisherId, appId: appId, viewController: viewController) {
            let units = PlaywireSDK.shared.config?.adUnits.map { AdUnit(name: $0.name, mode: $0.mode) } ?? []
            self.adUnits = units.sorted(by: { $0.name < $1.name })
        }
    }
}
