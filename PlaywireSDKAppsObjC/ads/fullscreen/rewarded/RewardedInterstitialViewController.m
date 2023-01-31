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
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) PWRewardedInterstitial *rewardedInterstitial;
@end

@implementation RewardedInterstitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadRewardedInterstitial];
}

- (void)loadRewardedInterstitial {
    self.rewardedInterstitial = [[PWRewardedInterstitial alloc] initWithAdUnitName:self.adUnitName delegate:self];
    
    // Use `[[PWLoadParams new] withTargeting:]` to pass your custom targets to ad request.
    // PWLoadParams *params = [[PWLoadParams new] withTargeting:@{
    //   @"age": @"18-32",
    //   @"page": @"travel"
    // }];
    // [self.rewardedInterstitial loadWithParams:params];
    
    [self.rewardedInterstitial load];
    self.statusLabel.text = [NSString stringWithFormat: @"⏳ The rewarded interstitial \"%@\" is loading.", self.adUnitName];
}

- (void)showRewardedInterstitial {
    if (!self.rewardedInterstitial.isLoaded) {
        // Load rewarded interstitial one more time or notify a user about error
        return;
    }
    
    [self.rewardedInterstitial showFromViewController:self];
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
    self.statusLabel.text = [NSString stringWithFormat: @"🎉 The reward is earned.\n Type: %@\n Amount: %0.f.", type, amount];
}

@end
