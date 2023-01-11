//
//  InterstitialViewController.m
//  PlaywireDemo
//
//  Created by Playwire Mobile Team on 01/05/23.
//  Copyright © 2023 Playwire. All rights reserved.
//

#import "InterstitialViewController.h"
#import <Playwire-Swift.h>

@interface InterstitialViewController () <PWFullScreenAdDelegate>
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) PWInterstitial *interstitial;
@end

@implementation InterstitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadInterstitial];
}

- (void)loadInterstitial {
    self.interstitial = [[PWInterstitial alloc] initWithAdUnitName:self.adUnitName delegate:self];
    
    // Use `[[PWLoadParams new] withTargeting:]` to pass your custom targets to ad request.
    // PWLoadParams *params = [[PWLoadParams new] withTargeting:@{
    //   @"age": @"18-32",
    //   @"page": @"travel"
    // }];
    // [self.interstitial loadWithParams:params];
    
    [self.interstitial load];
    self.statusLabel.text = [NSString stringWithFormat: @"⏳ The interstitial \"%@\" is loading.", self.adUnitName];
}

- (void)showInterstitial {
    if (!self.interstitial.isLoaded) {
        // Load interstitial one more time or notify a user about error
        return;
    }
    
    [self.interstitial showFromViewController:self];
}

#pragma mark - PWFullScreenAdDelegate -

- (void)fullScreenAdDidLoad:(PWFullScreenAd * _Nonnull)ad {
    self.statusLabel.text = [NSString stringWithFormat: @"✅ The interstitial \"%@\" is loaded.", self.adUnitName];
    [self showInterstitial];
}

- (void)fullScreenAdDidFailToLoad:(PWFullScreenAd * _Nonnull)ad {
    self.statusLabel.text = [NSString stringWithFormat: @"❌ Failed to load the interstitial \"%@\".", self.adUnitName];
}


- (void)fullScreenAdDidFailToPresentFullScreenContent:(PWFullScreenAd * _Nonnull)ad {
    self.statusLabel.text = [NSString stringWithFormat: @"❌ Failed to show the interstitial \"%@\".", self.adUnitName];
}

- (void)fullScreenAdWillPresentFullScreenContent:(PWFullScreenAd * _Nonnull)ad {}

- (void)fullScreenAdWillDismissFullScreenContent:(PWFullScreenAd * _Nonnull)ad {}

- (void)fullScreenAdDidDismissFullScreenContent:(PWFullScreenAd * _Nonnull)ad {}

- (void)fullScreenAdDidRecordClick:(PWFullScreenAd * _Nonnull)ad {}

- (void)fullScreenAdDidRecordImpression:(PWFullScreenAd * _Nonnull)ad {
    self.statusLabel.text = [NSString stringWithFormat: @"👍 The interstitial \"%@\" was successfully shown.", self.adUnitName];
}

- (void)fullScreenAdDidUserEarn:(PWFullScreenAd * _Nonnull)ad type:(NSString * _Nonnull)type amount:(double)amount {}

@end
