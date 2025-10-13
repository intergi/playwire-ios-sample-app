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
@property (strong, nonatomic) UILabel *statusLabel;
@property (strong, nonatomic, readwrite) NSString *adUnitName;
@property (strong, nonatomic) PWInterstitial *interstitial;
@end

@implementation InterstitialViewController

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
    self.statusLabel.numberOfLines = 2;
    self.statusLabel.textColor = [UIColor blackColor];
    self.statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.statusLabel];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.statusLabel.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
        [self.statusLabel.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
        [self.statusLabel.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor]
    ]];
    
    [self loadInterstitial];
}

- (void)loadInterstitial {
    self.interstitial = [[PWInterstitial alloc] initWithAdUnitName:self.adUnitName viewController: self delegate:self];
    
    // Use `[[PWLoadParams new] withTargeting:]` to pass your custom targets to ad request.
//     PWLoadParams *params = [[PWLoadParams new] withTargeting:@{
//       @"age": @"18-32",
//       @"page": @"travel"
//     }];
//     [self.interstitial loadWithParams:params];
    
    [self.interstitial load];
    self.statusLabel.text = [NSString stringWithFormat: @"⏳ The interstitial \"%@\" is loading.", self.adUnitName];
}

- (void)showInterstitial {
    if (!self.interstitial.isLoaded) {
        // Load interstitial one more time or notify a user about error
        return;
    }
    
    [self.interstitial show];
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
