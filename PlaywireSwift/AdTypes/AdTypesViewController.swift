//
//  AdTypesViewController.swift
//  PlaywireDemo
//
//  Created by Playwire Mobile Team on 12/20/22.
//  Copyright © 2022 Playwire. All rights reserved.
//

import UIKit
import Playwire

enum AdMode {
    case banner
    case interstitial
    case rewarded
    case appOpen
    case native
}

struct AdUnitItem {
    let alias: String
    let mode: AdMode
}

final class AdTypesViewController: UITableViewController {
    private let cellId = "BasicCell"
    
    private let adUnitItems: [AdUnitItem] = [
        AdUnitItem(alias: "banner-320x50-gam", mode: .banner),
        AdUnitItem(alias: "banner-320x50-max", mode: .banner),
        AdUnitItem(alias: "banner-300x250-gam", mode: .banner),
        AdUnitItem(alias: "banner-300x250-max", mode: .banner),
        AdUnitItem(alias: "native-gam", mode: .native),
        AdUnitItem(alias: "native-max", mode: .native),
        AdUnitItem(alias: "app-open-gam", mode: .appOpen),
        AdUnitItem(alias: "app-open-max", mode: .appOpen),
        AdUnitItem(alias: "interstitial-gam", mode: .interstitial),
        AdUnitItem(alias: "interstitial-max", mode: .interstitial),
        AdUnitItem(alias: "rewarded-gam", mode: .rewarded),
        AdUnitItem(alias: "rewarded-video-max", mode: .rewarded),
    ]

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
                self.showAdUnits()
            } else {
                self.showInitializationError(error)
            }
        }
    }
    
    private func showAdUnits() {
        tableView.backgroundView = nil
        tableView.reloadData()
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
        adUnitItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let adUnitItem = adUnitItems[indexPath.row]
        cell.textLabel?.text = adUnitItem.alias
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let adUnitItem = adUnitItems[indexPath.row]
        presentViewController(for: adUnitItem)
    }
    
    private func presentViewController(for adUnitItem: AdUnitItem) {
        switch adUnitItem.mode {
        case .banner:
            let bannerVC = BannerViewController(adUnitName: adUnitItem.alias)
            navigationController?.pushViewController(bannerVC, animated: true)
            
        case .interstitial:
            let interstitialVC = InterstitialViewController(adUnitName: adUnitItem.alias)
            navigationController?.pushViewController(interstitialVC, animated: true)
            
        case .rewarded:
            let rewardedVC = RewardedViewController(adUnitName: adUnitItem.alias)
            navigationController?.pushViewController(rewardedVC, animated: true)
            
        case .appOpen:
            let appOpenVC = AppOpenViewController(adUnitName: adUnitItem.alias)
            navigationController?.pushViewController(appOpenVC, animated: true)
            
        case .native:
            let nativeVC = NativeViewController(adUnitName: adUnitItem.alias)
            navigationController?.pushViewController(nativeVC, animated: true)
        }

    }
}
