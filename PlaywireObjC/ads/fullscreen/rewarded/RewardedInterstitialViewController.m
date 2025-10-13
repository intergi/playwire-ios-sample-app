//
//  RewardedInterstitialViewController.m
//  PlaywireDemo
//
//  Created by Playwire Mobile Team on 01/05/23.
//  Copyright © 2023 Playwire. All rights reserved.
//

#import "RewardedInterstitialViewController.h"
#import <Playwire-Swift.h>

@interface RewardedInterstitialViewController () <PWFullScreenAdDelegate>
@property (strong, nonatomic) UILabel *statusLabel;
@property (strong, nonatomic, readwrite) NSString *adUnitName;
@property (strong, nonatomic) PWRewardedInterstitial *rewardedInterstitial;
@end

@implementation RewardedInterstitialViewController

- (instancetype)initWithAdUnitName:(NSString *)adUnitName {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _adUnitName = adUnitName;
    }
    return self;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Use initWithAdUnitName: instead"
                                 userInfo:nil];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Use initWithAdUnitName: instead"
                                 userInfo:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Create status label
    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.textColor = [UIColor blackColor];
    self.statusLabel.numberOfLines = 2;
    self.statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.statusLabel];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.statusLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.statusLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.statusLabel.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor]
    ]];
    
    [self loadRewardedInterstitial];
}

- (void)loadRewardedInterstitial {
    self.rewardedInterstitial = [[PWRewardedInterstitial alloc] initWithAdUnitName:self.adUnitName viewController: self delegate:self];
    
    // Use `[[PWLoadParams new] withTargeting:]` to pass your custom targets to ad request.
//     PWLoadParams *params = [[PWLoadParams new] withTargeting:@{
//       @"age": @"18-32",
//       @"page": @"travel"
//     }];
//     [self.rewardedInterstitial loadWithParams:params];
    
    [self.rewardedInterstitial load];
    self.statusLabel.text = [NSString stringWithFormat: @"⏳ The rewarded interstitial \"%@\" is loading.", self.adUnitName];
}

- (void)showRewardedInterstitial {
    if (!self.rewardedInterstitial.isLoaded) {
        // Load rewarded interstitial one more time or notify a user about error
        return;
    }
    
    [self.rewardedInterstitial show];
}

#pragma mark - PWFullScreenAdDelegate -

- (void)fullScreenAdDidLoad:(PWFullScreenAd * _Nonnull)ad {
    self.statusLabel.text = [NSString stringWithFormat: @"✅ The rewarded interstitial \"%@\" is loaded.", self.adUnitName];
    [self showRewardedInterstitial];
}

- (void)fullScreenAdDidFailToLoad:(PWFullScreenAd * _Nonnull)ad {
    self.statusLabel.text = [NSString stringWithFormat: @"❌ Failed to load the rewarded interstitial \"%@\".", self.adUnitName];
}


- (void)fullScreenAdDidFailToPresentFullScreenContent:(PWFullScreenAd * _Nonnull)ad {
    self.statusLabel.text = [NSString stringWithFormat: @"❌ Failed to show the rewarded interstitial \"%@\".", self.adUnitName];
}

- (void)fullScreenAdWillPresentFullScreenContent:(PWFullScreenAd * _Nonnull)ad {}

- (void)fullScreenAdWillDismissFullScreenContent:(PWFullScreenAd * _Nonnull)ad {}

- (void)fullScreenAdDidDismissFullScreenContent:(PWFullScreenAd * _Nonnull)ad {}

- (void)fullScreenAdDidRecordClick:(PWFullScreenAd * _Nonnull)ad {}

- (void)fullScreenAdDidRecordImpression:(PWFullScreenAd * _Nonnull)ad {
    self.statusLabel.text = [NSString stringWithFormat: @"👍 The rewarded interstitial \"%@\" was successfully shown.", self.adUnitName];
}

- (void)fullScreenAdDidUserEarn:(PWFullScreenAd * _Nonnull)ad type:(NSString * _Nonnull)type amount:(double)amount {
    // Handle a reward regarding your business objectives.
    self.statusLabel.text = [NSString stringWithFormat: @"🎉 The reward was earned.\n Type: %@\n Amount: %0.f.", type, amount];
}

@end
