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
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *showAppOpenAdButton;
@property (strong, nonatomic) PWAppOpenAd *appOpenAd;
@end

@implementation AppOpenAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self subscribeToAppStateNotificaions];
    [self.showAppOpenAdButton setEnabled:NO];
    
    [self loadAppOpenAd];
}

- (void)subscribeToAppStateNotificaions {
    // Observe an app state to show the ad when a user open the app.
    // As alternative you can handle an app state in the `AppDelegate` or `SceneDelegate`.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleResignActiveState) name:UIApplicationWillResignActiveNotification
                                               object:NULL];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleBecomeActiveState) name:UIApplicationDidBecomeActiveNotification
                                               object:NULL];
}

- (void)handleResignActiveState {
    // Check if we need to load app open ad before next presentation
    if (!self.appOpenAd.isLoaded) return;
    [self loadAppOpenAd];
}

- (void)handleBecomeActiveState {
    [self showAppOpenAd];
}

- (void)loadAppOpenAd {
    self.appOpenAd = [[PWAppOpenAd alloc] initWithAdUnitName:self.adUnitName viewController: self delegate:self];
    
    // Ads rendered more than four hours after request time will no longer be valid and may not earn revenue.
    // Enable the proprety below to start loading new ad automatically if more than a certain number of hours have passed since your ad loaded.
    // It equals to `NO` by default.
    self.appOpenAd.autoReloadOnExpiration = YES;
    
    // Use `[[PWLoadParams new] withTargeting:]` to pass your custom targets to ad request.
    // Use `[[PWLoadParams new] withDeviceOrientation:]` to pass the orientation you want to use in the ad request.
    // PWLoadParams *params = [[[PWLoadParams new] withDeviceOrientation: UIInterfaceOrientationPortrait] withTargeting:@{
    //   @"age": @"18-32",
    //   @"page": @"travel"
    // }];
    // [self.appOpenAd loadWithParams:params];
    
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
    [self.showAppOpenAdButton setEnabled:YES];
}

- (void)fullScreenAdDidFailToLoad:(PWFullScreenAd * _Nonnull)ad {
    self.statusLabel.text = [NSString stringWithFormat: @"❌ Failed to load the app open ad \"%@\".", self.adUnitName];
}

- (void)fullScreenAdDidFailToPresentFullScreenContent:(PWFullScreenAd * _Nonnull)ad {
    self.statusLabel.text = [NSString stringWithFormat: @"❌ Failed to show the app open ad \"%@\".", self.adUnitName];
    self.appOpenAd = NULL;
}

- (void)fullScreenAdWillPresentFullScreenContent:(PWFullScreenAd * _Nonnull)ad {}

- (void)fullScreenAdWillDismissFullScreenContent:(PWFullScreenAd * _Nonnull)ad {}

- (void)fullScreenAdDidDismissFullScreenContent:(PWFullScreenAd * _Nonnull)ad {
    self.appOpenAd = NULL;
    
    // Load app open ad content to be ready for the next presentation
    [self loadAppOpenAd];
}

- (void)fullScreenAdDidRecordClick:(PWFullScreenAd * _Nonnull)ad {}

- (void)fullScreenAdDidRecordImpression:(PWFullScreenAd * _Nonnull)ad {
    self.statusLabel.text = [NSString stringWithFormat: @"👍 The app open ad \"%@\" was successfully shown.", self.adUnitName];
    [self.showAppOpenAdButton setEnabled:NO];
}

- (void)fullScreenAdDidUserEarn:(PWFullScreenAd * _Nonnull)ad type:(NSString * _Nonnull)type amount:(double)amount {}
@end
