//
//  RewardedViewController.m
//  PlaywireDemo
//
//  Created by Playwire Mobile Team on 01/05/23.
//  Copyright © 2023 Playwire. All rights reserved.
//

#import "RewardedViewController.h"
#import <Playwire-Swift.h>

@interface RewardedViewController () <PWFullScreenAdDelegate>
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *getRewardButton;
@property (strong, nonatomic) PWRewarded *rewarded;
@end

@implementation RewardedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.getRewardButton setEnabled:NO];
    [self loadRewarded];
}

- (IBAction)getRewardAction:(UIButton *)sender {
    [self showRewarded];
}

- (void)loadRewarded {
    self.rewarded = [[PWRewarded alloc] initWithAdUnitName:self.adUnitName delegate:self];
    
    // Use `[[PWLoadParams new] withTargeting:]` to pass your custom targets to ad request.
    // PWLoadParams *params = [[PWLoadParams new] withTargeting:@{
    //   @"age": @"18-32",
    //   @"page": @"travel"
    // }];
    // [self.rewarded loadWithParams:params];
    
    [self.rewarded load];
    self.statusLabel.text = [NSString stringWithFormat: @"⏳ The rewarded \"%@\" is loading.", self.adUnitName];
}

- (void)showRewarded {
    if (!self.rewarded.isLoaded) {
        // Load rewarded one more time or notify a user about error
        [self loadRewarded];
        return;
    }
    
    [self.rewarded showFromViewController:self];
}

#pragma mark - PWFullScreenAdDelegate -

- (void)fullScreenAdDidLoad:(PWFullScreenAd * _Nonnull)ad {
    self.statusLabel.text = [NSString stringWithFormat: @"✅ The rewarded \"%@\" is loaded.", self.adUnitName];
    [self.getRewardButton setEnabled:YES];
}

- (void)fullScreenAdDidFailToLoad:(PWFullScreenAd * _Nonnull)ad {
    self.statusLabel.text = [NSString stringWithFormat: @"❌ Failed to load the rewarded \"%@\".", self.adUnitName];
}


- (void)fullScreenAdDidFailToPresentFullScreenContent:(PWFullScreenAd * _Nonnull)ad {
    self.statusLabel.text = [NSString stringWithFormat: @"❌ Failed to show the rewarded \"%@\".", self.adUnitName];
}

- (void)fullScreenAdWillPresentFullScreenContent:(PWFullScreenAd * _Nonnull)ad {}

- (void)fullScreenAdWillDismissFullScreenContent:(PWFullScreenAd * _Nonnull)ad {}

- (void)fullScreenAdDidDismissFullScreenContent:(PWFullScreenAd * _Nonnull)ad {
    self.rewarded = NULL;
    [self.getRewardButton setEnabled:NO];
}

- (void)fullScreenAdDidRecordClick:(PWFullScreenAd * _Nonnull)ad {}

- (void)fullScreenAdDidRecordImpression:(PWFullScreenAd * _Nonnull)ad {
    self.statusLabel.text = [NSString stringWithFormat: @"👍 The rewarded \"%@\" was successfully shown.", self.adUnitName];
}

- (void)fullScreenAdDidUserEarn:(PWFullScreenAd * _Nonnull)ad type:(NSString * _Nonnull)type amount:(double)amount {
    // Handle a reward regarding your business objectives.
    self.statusLabel.text = [NSString stringWithFormat: @"🎉 The reward is earned.\n Type: %@\n Amount: %0.f.", type, amount];
}

@end
