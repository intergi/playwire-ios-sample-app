//
//  AdTypesViewController.swift
//  PlaywireDemo
//
//  Created by Playwire Mobile Team on 12/20/22.
//  Copyright © 2022 Playwire. All rights reserved.
//

import UIKit
import Playwire

struct AdUnit {
    let mode: String
    let alias: String
}

final class AdTypesViewController: UITableViewController {
    private let cellId = "BasicCell"
    
    private var adUnits: [AdUnit] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        title = "Playwire Demo"
        navigationController?.navigationItem.title = "Playwire Demo"
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        setupTableView()
        
        // Start Playwire SDK with `publisherId` and `appId`.
        // Make sure you run SDK initialization only once.
        PlaywireSDK.shared.start(publisherId: "1024407", appId: "702", viewController: self) { [weak self] success, error in
            guard let self else { return }
                    
            if success {
                self.setupAdUnits()
            } else {
                self.showInitializationError(error)
            }
        }
    }
    
    private func setupAdUnits() {
        var adUnits: [AdUnit] = []
        PlaywireSDK.shared.adUnitsDictionary.forEach { (key, values) in
            for value in values {
                let adUnit = AdUnit(mode: key, alias: value)
                adUnits.append(adUnit)
            }
        }
        
        self.adUnits = adUnits
        
        // Sort by mode first, then by name
        self.adUnits = adUnits.sorted { (first, second) in
            if first.mode == second.mode {
                return first.alias < second.alias
            }
            return first.mode < second.mode
        }
    
        tableView.backgroundView = nil
        self.tableView.reloadData()
    }
    
    private func setupTableView() {
        let statusLabel = UILabel()
        statusLabel.textAlignment = .center
        statusLabel.numberOfLines = 0
        statusLabel.text = "SDK start.."
        tableView.backgroundView = statusLabel
    }
    
    private func showInitializationError(_ error: Error?) {
        let statusLabel = UILabel()
        statusLabel.textAlignment = .center
        statusLabel.numberOfLines = 0
        statusLabel.text = "SDK failed to start.\n\(error?.localizedDescription ?? "Unknown error")"
        tableView.backgroundView = statusLabel
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        adUnits.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let adUnit = adUnits[indexPath.row]
        cell.textLabel?.text = adUnit.alias
        cell.detailTextLabel?.text = adUnit.mode
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let adUnit = adUnits[indexPath.row]
        presentViewController(for: adUnit)
    }
    
    private func presentViewController(for adUnit: AdUnit) {
        switch adUnit.mode {
        case "Banner":
            let bannerVC = BannerViewController(adUnitName: adUnit.alias, bannerType: PWAdUnit.PWAdMode_Banner)
            navigationController?.pushViewController(bannerVC, animated: true)
            
        case "Interstitial":
            let interstitialVC = InterstitialViewController(adUnitName: adUnit.alias)
            navigationController?.pushViewController(interstitialVC, animated: true)
            
        case "Rewarded":
            let rewardedVC = RewardedViewController(adUnitName: adUnit.alias)
            navigationController?.pushViewController(rewardedVC, animated: true)
            
        case "AppOpenAd":
            let appOpenVC = AppOpenViewController(adUnitName: adUnit.alias)
            navigationController?.pushViewController(appOpenVC, animated: true)
            
        case "Native":
            let nativeVC = NativeViewController(adUnitName: adUnit.alias)
            navigationController?.pushViewController(nativeVC, animated: true)
            
        default:
            print("Unknown ad unit mode: \(adUnit.mode)")
        }
    }
}
