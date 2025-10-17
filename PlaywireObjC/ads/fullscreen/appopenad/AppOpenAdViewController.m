//
//  AppOpenAdViewController.m
//  PlaywireDemo
//
//  Created by Playwire Mobile Team on 01/05/23.
//  Copyright © 2023 Playwire. All rights reserved.
//

#import "AppOpenAdViewController.h"
#import <Playwire-Swift.h>

@interface AppOpenAdViewController () <PWFullScreenAdDelegate>
@property (strong, nonatomic) UILabel *statusLabel;
@property (strong, nonatomic) PWAppOpenAd *appOpenAd;
@end

@implementation AppOpenAdViewController

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
    [self.view addSubview:self.statusLabel];
    
    // Setup constraints
    self.statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
        [self.statusLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.statusLabel.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor]
    ]];
    
    [self loadAppOpenAd];
}

- (void)loadAppOpenAd {
    self.appOpenAd = [[PWAppOpenAd alloc] initWithAdUnitName:self.adUnitName viewController: self delegate:self];
    
    // Ads rendered more than four hours after request time will no longer be valid and may not earn revenue.
    // Enable the proprety below to start loading new ad automatically if more than a certain number of hours have passed since your ad loaded.
    // It equals to `NO` by default.
    self.appOpenAd.autoReloadOnExpiration = YES;
    
    // Use `[[PWLoadParams new] withTargeting:]` to pass your custom targets to ad request.
    // Use `[[PWLoadParams new] withDeviceOrientation:]` to pass the orientation you want to use in the ad request.
//     PWLoadParams *params = [[[PWLoadParams new] withDeviceOrientation: UIInterfaceOrientationPortrait] withTargeting:@{
//       @"age": @"18-32",
//       @"page": @"travel"
//     }];
//     [self.appOpenAd loadWithParams:params];
    
    [self.appOpenAd load];
    
    self.statusLabel.text = [NSString stringWithFormat: @"⏳ The app open ad \"%@\" is loading.", self.adUnitName];
}

- (void)showAppOpenAd {
    if (!self.appOpenAd.isLoaded) {
        // Load app open ad one more time or notify a user about error
        return;
    }
    
    [self.appOpenAd show];
}

- (IBAction)showAction:(UIButton *)sender {
    [self showAppOpenAd];
}

#pragma mark - PWFullScreenAdDelegate -

- (void)fullScreenAdDidLoad:(PWFullScreenAd * _Nonnull)ad {
    self.statusLabel.text = [NSString stringWithFormat: @"✅ The app open ad \"%@\" is loaded.", self.adUnitName];
    [self showAppOpenAd];
}

- (void)fullScreenAdDidFailToLoad:(PWFullScreenAd * _Nonnull)ad {
    self.statusLabel.text = [NSString stringWithFormat: @"❌ Failed to load the app open ad \"%@\".", self.adUnitName];
}

- (void)fullScreenAdDidFailToPresentFullScreenContent:(PWFullScreenAd * _Nonnull)ad {
    self.statusLabel.text = [NSString stringWithFormat: @"❌ Failed to show the app open ad \"%@\".", self.adUnitName];
}

- (void)fullScreenAdWillPresentFullScreenContent:(PWFullScreenAd * _Nonnull)ad {}

- (void)fullScreenAdWillDismissFullScreenContent:(PWFullScreenAd * _Nonnull)ad {}

- (void)fullScreenAdDidDismissFullScreenContent:(PWFullScreenAd * _Nonnull)ad {    
}

- (void)fullScreenAdDidRecordClick:(PWFullScreenAd * _Nonnull)ad {}

- (void)fullScreenAdDidRecordImpression:(PWFullScreenAd * _Nonnull)ad {
    self.statusLabel.text = [NSString stringWithFormat: @"👍 The app open ad \"%@\" was successfully shown.", self.adUnitName];
}

- (void)fullScreenAdDidUserEarn:(PWFullScreenAd * _Nonnull)ad type:(NSString * _Nonnull)type amount:(double)amount {}
@end
