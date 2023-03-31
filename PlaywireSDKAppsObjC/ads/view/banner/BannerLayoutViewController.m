//
//  BannerLayoutViewController.m
//  PlaywireSDKApps
//
//  Created by Playwire Mobile Team on 03/30/23.
//  Copyright © 2023 Playwire. All rights reserved.
//

#import "BannerLayoutViewController.h"
#import <Playwire-Swift.h>

// The ad unit name, e.g. 'banner-320x50', 'interstitial-home', 'rewarded-coins', etc.
static NSString *userDefinedAttributesBannerName = @"Banner-320x50";

// The ad unit name, e.g. 'banner-320x50', 'interstitial-home', 'rewarded-coins', etc.
static NSString *codeSetupBannerName = @"Banner-300x250";

@interface BannerLayoutViewController () <PWViewAdDelegate>
@property (weak, nonatomic) IBOutlet UILabel *userDefinedAttributesBannerStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeSetupBannerStatusLabel;
@property (weak, nonatomic) IBOutlet PWBannerView *userDefinedAttributesBanner;
@property (weak, nonatomic) IBOutlet PWBannerView *codeSetupBanner;
@end

@implementation BannerLayoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // See `User Defined Runtime Attributes` section in the Main.storyboad where params are configured.
    // Set `PWViewAdDelegate` delegate to inform you about a view ad lifecycle.
    self.userDefinedAttributesBanner.delegate = self;
    
    // Add view to a `.storyboad` file and configure with required parameters.
    // Set `PWViewAdDelegate` delegate to inform you about a view ad lifecycle.
    self.codeSetupBanner.delegate = self;
    self.codeSetupBanner.adUnitName = codeSetupBannerName;
    // Use `[[PWLoadParams new] withTargeting:]` to pass your custom targets to ad request.
    // PWLoadParams *params = [[PWLoadParams new] withTargeting:@{
    //   @"age": @"18-32",
    //   @"page": @"travel"
    // }];
    // [self.bannerView loadWithParams:params];
    [self.codeSetupBanner load];
    
    self.userDefinedAttributesBannerStatusLabel.text = [NSString stringWithFormat: @"⏳ The banner \"%@\" is loading.",
                                                        userDefinedAttributesBannerName];
    self.codeSetupBannerStatusLabel.text = [NSString stringWithFormat: @"⏳ The banner \"%@\" is loading.", codeSetupBannerName];
}

#pragma mark - PWViewAdDelegate -

- (void)viewAdDidLoad:(PWViewAd * _Nonnull)ad {
    if (!ad.isLoaded) return;
    
    if ([ad isEqual:self.userDefinedAttributesBanner]) {
        self.userDefinedAttributesBannerStatusLabel.text = [NSString stringWithFormat: @"✅ The banner \"%@\" is loaded.",
                                                            userDefinedAttributesBannerName];
    } else {
        self.codeSetupBannerStatusLabel.text = [NSString stringWithFormat: @"✅ The banner \"%@\" is loaded.", codeSetupBannerName];
    }
}

- (void)viewAdDidFailToLoad:(PWViewAd * _Nonnull)ad {
    if ([ad isEqual:self.userDefinedAttributesBanner]) {
        self.userDefinedAttributesBannerStatusLabel.text = [NSString stringWithFormat: @"❌ Failed to load the banner \"%@\".",
                                                            userDefinedAttributesBannerName];
    } else {
        self.codeSetupBannerStatusLabel.text = [NSString stringWithFormat: @"❌ Failed to load the banner \"%@\".", codeSetupBannerName];
    }
}

- (void)viewAdDidRecordClick:(PWViewAd * _Nonnull)ad {}
- (void)viewAdDidRecordImpression:(PWViewAd * _Nonnull)ad {}
- (void)viewAdWillPresentFullScreenContent:(PWViewAd * _Nonnull)ad {}
- (void)viewAdWillDismissFullScreenContent:(PWViewAd * _Nonnull)ad {}
- (void)viewAdDidDismissFullScreenContent:(PWViewAd * _Nonnull)ad {}


@end
