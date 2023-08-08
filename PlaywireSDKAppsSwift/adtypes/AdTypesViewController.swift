//
//  AdTypesViewController.swift
//  PlaywireDemo
//
//  Created by Playwire Mobile Team on 12/20/22.
//  Copyright © 2022 Playwire. All rights reserved.
//

import UIKit
import Playwire
import FirebaseCore

protocol AdUnitViewControllerType {
    var adUnitName: String! { get set }
}

final class AdTypesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var adUnits: [(name: String, mode: PWAdUnit.PWAdMode)] = []
    private var interstitialListener: PWListenerToken?
    
    deinit {
        // Cancel subscription once it's not needed.
        interstitialListener?.cancel()
        interstitialListener = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitle()
        setupTableView()
        
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
        
        // Initialize Playwire SDK with `publisherId` and `appId`, when initialization done, you will be able to load ad units.
        // Make sure you run SDK initialization only once.
        PlaywireSDK.shared.initialize(publisherId: "playwire", appId: "test", viewController: self) { [unowned self] in
            let adUnits = PlaywireSDK.shared.config?.adUnits.map { ($0.name, $0.mode) } ?? []
            self.adUnits = adUnits.sorted(by: { $0.0 < $1.0 })
            tableView.backgroundView = nil
            self.tableView.reloadData()
        }
    }
    
    private func setupTitle() {
        #if COPPA_APP
            title = "Playwire Demo COPPA"
        #else
            title = "Playwire Demo"
        #endif
    }
    
    private func setupTableView() {
        let statusLabel = UILabel()
        statusLabel.textAlignment = .center
        statusLabel.text = "⏳ SDK initializaton.."
        tableView.backgroundView = statusLabel
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let adUnit = sender as? (name: String, mode: PWAdUnit.PWAdMode) else { return }
        guard var controller = segue.destination as? AdUnitViewControllerType else { return }
        controller.adUnitName = adUnit.name
    }
}

extension AdTypesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adUnits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let adUnit = adUnits[indexPath.row]
        var config = UIListContentConfiguration.subtitleCell()
        config.text = adUnit.name
        config.secondaryText = adUnit.mode.rawValue
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdTypeCell", for: indexPath)
        cell.contentConfiguration = config
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let adUnit = adUnits[indexPath.row]
        // Show predefined view controller with banners that created in the storyboard
        if(adUnit.mode == PWAdUnit.PWAdMode.Banner && adUnit.name == "Banner-320x50") {
            performSegue(withIdentifier: "BannerLayout", sender: adUnit)
            return
        }
        performSegue(withIdentifier: adUnit.mode.rawValue, sender: adUnit)
    }
}
