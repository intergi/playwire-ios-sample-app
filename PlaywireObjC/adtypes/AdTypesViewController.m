//
//  AdTypesViewController.m
//  PlaywireDemo
//
//  Created by Playwire Mobile Team on 01/05/23.
//  Copyright © 2023 Playwire. All rights reserved.
//

#import "AdTypesViewController.h"
#import <Playwire-Swift.h>
#import "../ads/view/banner/BannerViewController.h"
#import "../ads/fullscreen/interstitial/InterstitialViewController.h"
#import "../ads/fullscreen/rewarded/RewardedViewController.h"
#import "../ads/fullscreen/appopenad/AppOpenAdViewController.h"
#import "../ads/fullscreen/rewarded/RewardedInterstitialViewController.h"
#import "../ads/view/native/NativeAdViewController.h"

@interface AdUnit: NSObject
@property (nonatomic, copy) NSString *mode;
@property (nonatomic, copy) NSString *alias;
@end

@implementation AdUnit
@end

@interface AdTypesViewController()
@property (strong, nonatomic) NSArray<AdUnit *> *adUnits;
@property (strong, nonatomic) NSString *cellId;
@end

@implementation AdTypesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.cellId = @"BasicCell";
    self.adUnits = @[];
    
    self.title = @"Playwire Demo";
    self.navigationController.navigationItem.title = @"Playwire Demo";
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:self.cellId];
    
    [self setupTableView];

    __weak typeof(self) wself = self;
    
    // Initialize Playwire SDK with `publisherId` and `appId`, when initialization done, you will be able to load ad units.
    // Make sure you run SDK initialization only once.
    [PlaywireSDK.shared initializeWithPublisherId:@"1024407"
                                            appId:@"702"
                                   viewController:self
                                completionHandler:^() {
        [wself setupAdUnits];
    }];
}

- (void)setupAdUnits {
    NSMutableArray<AdUnit *> *adUnits = [[NSMutableArray alloc] init];
    [PlaywireSDK.shared.adUnitsDictionary
     enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key,
                                         NSArray <NSString *> * _Nonnull values,
                                         BOOL * _Nonnull stop) {
        for (NSString *value in values) {
            AdUnit *adUnit = [AdUnit new];
            adUnit.alias = value;
            adUnit.mode = key;
            [adUnits addObject:adUnit];
        }
    }];
    
    // Sort by mode first, then by name
    self.adUnits = [adUnits sortedArrayUsingComparator:^NSComparisonResult(AdUnit *first, AdUnit *second) {
        if ([first.mode isEqualToString:second.mode]) {
            return [first.alias compare:second.alias];
        }
        return [first.mode compare:second.mode];
    }];
    
    self.tableView.backgroundView = nil;
    [self.tableView reloadData];
}

- (void)setupTableView {
    UILabel *statusLabel = [UILabel new];
    statusLabel.textAlignment = NSTextAlignmentCenter;
    statusLabel.text = @"⏳ SDK initialization..";
    self.tableView.backgroundView = statusLabel;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellId forIndexPath:indexPath];
    AdUnit *adUnit = self.adUnits[indexPath.row];
    
    cell.textLabel.text = adUnit.alias;
    cell.detailTextLabel.text = adUnit.mode;
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.adUnits.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AdUnit *adUnit = [self.adUnits objectAtIndex:indexPath.row];
    [self presentViewControllerForAdUnit:adUnit];
}

- (void)presentViewControllerForAdUnit:(AdUnit *)adUnit {
    UIViewController *viewController = nil;
    
    if ([adUnit.mode isEqualToString:@"Banner"]) {
        viewController = [[BannerViewController alloc] initWithAdUnitName:adUnit.alias bannerType:PWAdUnit.PWAdMode_Banner];
    } else if ([adUnit.mode isEqualToString:@"BannerAnchored"]) {
        viewController = [[BannerViewController alloc] initWithAdUnitName:adUnit.alias bannerType:PWAdUnit.PWAdMode_BannerAnchored];
    } else if ([adUnit.mode isEqualToString:@"BannerInline"]) {
        viewController = [[BannerViewController alloc] initWithAdUnitName:adUnit.alias bannerType:PWAdUnit.PWAdMode_BannerInline];
    } else if ([adUnit.mode isEqualToString:@"Interstitial"]) {
        viewController = [[InterstitialViewController alloc] initWithAdUnitName:adUnit.alias];
    } else if ([adUnit.mode isEqualToString:@"Rewarded"]) {
        viewController = [[RewardedViewController alloc] initWithAdUnitName:adUnit.alias];
    } else if ([adUnit.mode isEqualToString:@"AppOpenAd"]) {
        viewController = [[AppOpenAdViewController alloc] initWithAdUnitName:adUnit.alias];
    } else if ([adUnit.mode isEqualToString:@"RewardedInterstitial"]) {
        viewController = [[RewardedInterstitialViewController alloc] initWithAdUnitName:adUnit.alias];
    } else if ([adUnit.mode isEqualToString:@"Native"]) {
        viewController = [[NativeAdViewController alloc] initWithAdUnitName:adUnit.alias];
    } else {
        NSLog(@"Unknown ad unit mode: %@", adUnit.mode);
        return;
    }
    
    if (viewController) {
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

@end
