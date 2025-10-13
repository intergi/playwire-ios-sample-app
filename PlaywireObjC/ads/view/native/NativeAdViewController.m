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
@property (strong, nonatomic) UILabel *statusLabel;
@property (strong, nonatomic) PWNativeView *nativeView;
@property (strong, nonatomic) CustomNativeAdView *nativeAdView;

@end

@implementation NativeAdViewController

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
    self.statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.statusLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.statusLabel.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
    ]];
    
    self.nativeView = [[PWNativeView alloc] initWithAdUnitName:self.adUnitName
                                                    controller:self
                                                       factory:self
                                                      delegate:self];
    [self.view addSubview:self.nativeView];
    self.nativeView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.nativeView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.nativeView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
        [self.nativeView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
        [self.nativeView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor]
    ]];
    
    // Use `[[PWLoadParams new] withTargeting:]` to pass your custom targets to ad request.
    //    PWLoadParams* params = [[PWLoadParams new] withTargeting:@{@"age": @"18-32", @"page": @"travel"}];
    //    [self.nativeView loadWithParams:params];
    
    [self.nativeView load];

    self.statusLabel.text = [NSString stringWithFormat: @"⏳ The native ad \"%@\" is loading.", self.adUnitName];
}



#pragma mark - PWViewAdDelegate -

- (void)viewAdDidLoad:(PWViewAd * _Nonnull)ad {
    if (!self.nativeView.isLoaded) return;
    
    self.statusLabel.text = [NSString stringWithFormat: @"✅ The native ad \"%@\" is loaded.", self.adUnitName];
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

- (UIView * _Nonnull)createAdContentViewWithNativeView:(PWNativeView * _Nonnull)nativeView
                                             adContent:(PWNativeViewContent * _Nonnull)adContent {
    // Creates your custom view which can be configurable with `PWNativeViewContent`.
    // `CustomNativeAdView` is a `UIView` subclass for our custom native ad layout. See `CustomNativeAdView` class for more
    // details.
    
    self.nativeAdView = [[CustomNativeAdView alloc] initWithAdContent:adContent];
    return self.nativeAdView;
}

- (UIView * _Nullable)callToActionViewWithNativeView:(PWNativeView * _Nonnull)nativeView
                                       adContentView:(UIView * _Nonnull)adContentView {
    // Defines action view to handle a user's taps on a native ad view.
    return self.nativeAdView.button;
}
@end
