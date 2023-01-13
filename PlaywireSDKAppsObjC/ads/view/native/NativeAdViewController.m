//
//  NativeAdViewController.m
//  PlaywireDemo
//
//  Created by Playwire Mobile Team on 01/06/23.
//  Copyright © 2023 Playwire. All rights reserved.
//

#import "NativeAdViewController.h"
#import <Playwire-Swift.h>
#import "CustomNativeAdView.h"

@interface NativeAdViewController ()<PWViewAdDelegate, PWNativeViewFactory>
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) PWNativeView *nativeView;
@property (assign, nonatomic) BOOL isNativeViewAdded;

@end

@implementation NativeAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nativeView = [[PWNativeView alloc] initWithAdUnitName:self.adUnitName
                                                    controller:self
                                                       factory:self
                                                      delegate:self];
    
    // Use `[[PWLoadParams new] withTargeting:]` to pass your custom targets to ad request.
    // PWLoadParams *params = [[PWLoadParams new] withTargeting:@{
    //   @"age": @"18-32",
    //   @"page": @"travel"
    // }];
    // [self.nativeView loadWithParams:params];
    [self.nativeView load];

    self.statusLabel.text = [NSString stringWithFormat: @"⏳ The native ad \"%@\" is loading.", self.adUnitName];
}

- (void)addNativeViewToSuperView {
    if (self.isNativeViewAdded) return;
    self.isNativeViewAdded = YES;
    
    // Native view is ready to be added to view hierarchy
    self.nativeView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.nativeView];
    [NSLayoutConstraint activateConstraints:@[
        [self.nativeView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-16],
        [self.nativeView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.nativeView.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor]
    ]];
}

-(IBAction)refreshAction:(UIButton *)sender {
    // Refresh will start only if the ad unit contains `refresh` object.
    // See logs from `PWNotifier` to track status of refresh.
    
    [self.nativeView refresh];
    
    NSArray *adUnits = [[[PlaywireSDK shared] config] adUnits];
    PWBannerRefresh *refresh;
    for(PWAdUnit *adUnit in adUnits) {
        if([adUnit.name isEqualToString:self.adUnitName]) {
            refresh = adUnit.refresh;
            break;
        }
    }
    
    if (!refresh) {
        self.statusLabel.text = [NSString stringWithFormat:@"⚠️ The native ad \"%@\" can't be refreshed manually.\nSee logs to get more details.", self.adUnitName];
        return;
    }
    
    self.statusLabel.text = [NSString stringWithFormat:@"🔄 The native ad \"%@\" is refreshing.", self.adUnitName];
}

#pragma mark - PWViewAdDelegate -

- (void)viewAdDidLoad:(PWViewAd * _Nonnull)ad {
    if (!ad.isLoaded) return;
    
    self.statusLabel.text = [NSString stringWithFormat: @"✅ The native ad \"%@\" is loaded.", self.adUnitName];
    [self addNativeViewToSuperView];
}

- (void)viewAdDidFailToLoad:(PWViewAd * _Nonnull)ad {
    self.statusLabel.text = [NSString stringWithFormat: @"❌ Failed to load the native ad \"%@\".", self.adUnitName];
}

- (void)viewAdDidRecordClick:(PWViewAd * _Nonnull)ad {}
- (void)viewAdDidRecordImpression:(PWViewAd * _Nonnull)ad {}
- (void)viewAdWillPresentFullScreenContent:(PWViewAd * _Nonnull)ad {}
- (void)viewAdWillDismissFullScreenContent:(PWViewAd * _Nonnull)ad {}
- (void)viewAdDidDismissFullScreenContent:(PWViewAd * _Nonnull)ad {}

#pragma mark - PWNativeViewFactory -

- (UIView * _Nullable)callToActionViewWithNativeView:(PWNativeView * _Nonnull)nativeView
                                       adContentView:(UIView * _Nonnull)adContentView {
    // Defines action view to handle a user's taps on a native ad view.
    return ((CustomNativeAdView *)adContentView).actionButton;
}

- (UIView * _Nonnull)createAdContentViewWithNativeView:(PWNativeView * _Nonnull)nativeView
                                             adContent:(PWNativeViewContent * _Nonnull)adContent {
    // Creates your custom view which can be configurable with `PWNativeViewContent`.
    // `CustomNativeAdView` is a `UIView` subclass for our custom native ad layout. See `CustomNativeAdView` class for more
    // details.
    CustomNativeAdView *customView = [CustomNativeAdView new];
    [customView configure:adContent];
    return customView;
}
@end
