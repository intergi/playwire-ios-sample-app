//
//  AdTypesViewController.m
//  PlaywireDemo
//
//  Created by Playwire Mobile Team on 01/05/23.
//  Copyright © 2023 Playwire. All rights reserved.
//

#import "AdTypesViewController.h"
#import <Playwire/Playwire-Swift.h>
#import "../ads/view/banner/BannerViewController.h"
#import "../ads/fullscreen/interstitial/InterstitialViewController.h"
#import "../ads/fullscreen/rewarded/RewardedViewController.h"
#import "../ads/fullscreen/appopenad/AppOpenAdViewController.h"
#import "../ads/view/native/NativeAdViewController.h"

typedef NS_ENUM(NSInteger, AdMode) {
    AdModeBanner,
    AdModeInterstitial,
    AdModeRewarded,
    AdModeAppOpen,
    AdModeNative,
};

@interface AdUnitItem: NSObject
@property (nonatomic, copy, readonly) NSString *alias;
@property (nonatomic, assign, readonly) AdMode mode;

- (instancetype)initWithAlias:(NSString *)alias mode:(AdMode)mode;
@end

@implementation AdUnitItem

- (instancetype)initWithAlias:(NSString *)alias mode:(AdMode)mode {
    self = [super init];
    if (self) {
        _alias = [alias copy];
        _mode = mode;
    }
    return self;
}

@end

@interface AdTypesViewController()
@property (strong, nonatomic) NSArray<AdUnitItem *> *adUnitItems;
@property (strong, nonatomic) NSString *cellId;
@end

@implementation AdTypesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.cellId = @"BasicCell";
    self.adUnitItems = @[
        [[AdUnitItem alloc] initWithAlias:@"banner-320x50-gam" mode:AdModeBanner],
        [[AdUnitItem alloc] initWithAlias:@"banner-320x50-max" mode:AdModeBanner],
        [[AdUnitItem alloc] initWithAlias:@"banner-300x250-gam" mode:AdModeBanner],
        [[AdUnitItem alloc] initWithAlias:@"banner-300x250-max" mode:AdModeBanner],
        [[AdUnitItem alloc] initWithAlias:@"native-gam" mode:AdModeNative],
        [[AdUnitItem alloc] initWithAlias:@"native-max" mode:AdModeNative],
        [[AdUnitItem alloc] initWithAlias:@"app-open-gam" mode:AdModeAppOpen],
        [[AdUnitItem alloc] initWithAlias:@"app-open-max" mode:AdModeAppOpen],
        [[AdUnitItem alloc] initWithAlias:@"interstitial-gam" mode:AdModeInterstitial],
        [[AdUnitItem alloc] initWithAlias:@"interstitial-max" mode:AdModeInterstitial],
        [[AdUnitItem alloc] initWithAlias:@"rewarded-gam" mode:AdModeRewarded],
        [[AdUnitItem alloc] initWithAlias:@"rewarded-video-max" mode:AdModeRewarded],
    ];
    
    self.title = @"Playwire Demo";
    self.navigationController.navigationItem.title = @"Playwire Demo";
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:self.cellId];
    
    [self setupTableView];

    __weak typeof(self) wself = self;
    
    // Start Playwire SDK with `publisherId` and `appId`.
    // Make sure you run SDK initialization only once.
    [PlaywireSDK.shared startWithPublisherId:@"1024407"
                                       appId:@"702"
                              viewController:self
                                  completion:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            [wself showAdUnits];
        } else {
            [wself showInitializationError:error];
        }
    }];
}

- (void)showAdUnits {
    self.tableView.backgroundView = nil;
    [self.tableView reloadData];
}

- (void)setupTableView {
    UILabel *statusLabel = [UILabel new];
    statusLabel.textAlignment = NSTextAlignmentCenter;
    statusLabel.numberOfLines = 0;
    statusLabel.text = @"⏳ SDK start..";
    self.tableView.backgroundView = statusLabel;
}

- (void)showInitializationError:(NSError * _Nullable)error {
    UILabel *statusLabel = [UILabel new];
    statusLabel.textAlignment = NSTextAlignmentCenter;
    statusLabel.numberOfLines = 0;
    statusLabel.text = [NSString stringWithFormat:@"SDK failed to start.\n%@",
                        error.localizedDescription ?: @"Unknown error"];
    self.tableView.backgroundView = statusLabel;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellId forIndexPath:indexPath];
    AdUnitItem *adUnitItem = self.adUnitItems[indexPath.row];
    
    cell.textLabel.text = adUnitItem.alias;
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.adUnitItems.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AdUnitItem *adUnitItem = [self.adUnitItems objectAtIndex:indexPath.row];
    [self presentViewControllerForAdUnitItem:adUnitItem];
}

- (void)presentViewControllerForAdUnitItem:(AdUnitItem *)adUnitItem {
    UIViewController *viewController = nil;
    
    switch (adUnitItem.mode) {
        case AdModeBanner:
            viewController = [[BannerViewController alloc] initWithAdUnitName:adUnitItem.alias];
            break;
        case AdModeInterstitial:
            viewController = [[InterstitialViewController alloc] initWithAdUnitName:adUnitItem.alias];
            break;
        case AdModeRewarded:
            viewController = [[RewardedViewController alloc] initWithAdUnitName:adUnitItem.alias];
            break;
        case AdModeAppOpen:
            viewController = [[AppOpenAdViewController alloc] initWithAdUnitName:adUnitItem.alias];
            break;
        case AdModeNative:
            viewController = [[NativeAdViewController alloc] initWithAdUnitName:adUnitItem.alias];
            break;
    }
    
    if (viewController) {
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

@end
