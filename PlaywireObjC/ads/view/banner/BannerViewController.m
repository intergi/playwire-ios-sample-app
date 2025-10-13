//
//  BannerViewController.m
//  PlaywireDemo
//
//  Created by Playwire Mobile Team on 01/06/23.
//  Copyright © 2023 Playwire. All rights reserved.
//

#import "BannerViewController.h"
#import <Playwire-Swift.h>

@interface BannerViewController () <PWViewAdDelegate>
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) PWBannerView *bannerView;
@property (assign, nonatomic) BOOL isBannerAdded;
@end

@implementation BannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bannerView = [[PWBannerView alloc] initWithAdUnitName:self.adUnitName delegate:self];
    
    // Use `[[PWLoadParams new] withTargeting:]` to pass your custom targets to ad request.
//     PWLoadParams *params = [[PWLoadParams new] withTargeting:@{
//       @"age": @"18-32",
//       @"page": @"travel"
//     }];
//     [self.bannerView loadWithParams:params];
    [self.bannerView load];
    
    self.statusLabel.text = [NSString stringWithFormat: @"⏳ The banner \"%@\" is loading.", self.adUnitName];
}

- (void)addBannerToSuperView {
    if (self.isBannerAdded) return;
    self.isBannerAdded = YES;
    
    // Banner is ready to be added to view hierarchy
    self.bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.bannerView];
    [NSLayoutConstraint activateConstraints:@[
        [self.bannerView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-16],
        [self.bannerView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.bannerView.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor]
    ]];
}

-(IBAction)refreshAction:(UIButton *)sender {
    // Refresh will start only if the ad unit contains `refresh` object.
    // See logs from `PWNotifier` to track status of refresh.
    
    [self.bannerView refresh];
    
    NSArray *adUnits = [[[PlaywireSDK shared] config] adUnits];
    PWBannerRefresh *refresh;
    for(PWAdUnit *adUnit in adUnits) {
        if([adUnit.name isEqualToString:self.adUnitName]) {
            refresh = adUnit.refresh;
            break;
        }
    }
    
    if (!refresh) {
        self.statusLabel.text = [NSString stringWithFormat:@"⚠️ The banner \"%@\" can't be refreshed manually.\nSee logs to get more details.", self.adUnitName];
        return;
    }
    
    self.statusLabel.text = [NSString stringWithFormat:@"🔄 The banner \"%@\" is refreshing.", self.adUnitName];
}

#pragma mark - PWViewAdDelegate -

- (void)viewAdDidLoad:(PWViewAd * _Nonnull)ad {
    if (!ad.isLoaded) return;
    
    self.statusLabel.text = [NSString stringWithFormat: @"✅ The banner \"%@\" is loaded.", self.adUnitName];
    [self addBannerToSuperView];
}

- (void)viewAdDidFailToLoad:(PWViewAd * _Nonnull)ad {
    self.statusLabel.text = [NSString stringWithFormat: @"❌ Failed to load the banner \"%@\".", self.adUnitName];
}

- (void)viewAdDidRecordClick:(PWViewAd * _Nonnull)ad {}
- (void)viewAdDidRecordImpression:(PWViewAd * _Nonnull)ad {}
- (void)viewAdWillPresentFullScreenContent:(PWViewAd * _Nonnull)ad {}
- (void)viewAdWillDismissFullScreenContent:(PWViewAd * _Nonnull)ad {}
- (void)viewAdDidDismissFullScreenContent:(PWViewAd * _Nonnull)ad {}

@end
