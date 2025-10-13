//
//  BannerViewController.m
//  PlaywireDemo
//
//  Created by Playwire Mobile Team on 01/06/23.
//  Copyright © 2023 Playwire. All rights reserved.
//

#import "BannerViewController.h"
#import <Playwire-Swift.h>

@interface BannerViewController () <PWViewAdDelegate>
@property (strong, nonatomic) UILabel *statusLabel;
@property (strong, nonatomic, readwrite) NSString *adUnitName;
@property (strong, nonatomic) NSString *bannerType;
@property (strong, nonatomic) PWBannerViewBase *bannerViewBase;
@end

@implementation BannerViewController

- (instancetype)initWithAdUnitName:(NSString *)adUnitName bannerType:(NSString *)bannerType {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _adUnitName = adUnitName;
        _bannerType = bannerType;
    }
    return self;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Use initWithAdUnitName:bannerType: instead"
                                 userInfo:nil];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Use initWithAdUnitName:bannerType: instead"
                                 userInfo:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Create status label
    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.textColor = [UIColor blackColor];
    
    // Create banner view based on type
    if ([self.bannerType isEqualToString:PWAdUnit.PWAdMode_Banner]) {
        self.bannerViewBase = [[PWBannerView alloc] initWithAdUnitName:self.adUnitName delegate:self];
    } else if ([self.bannerType isEqualToString:PWAdUnit.PWAdMode_BannerAnchored]) {
        self.bannerViewBase = [[PWBannerViewAnchored alloc] initWithAdUnitName:self.adUnitName delegate:self];
    } else if ([self.bannerType isEqualToString:PWAdUnit.PWAdMode_BannerInline]) {
        self.bannerViewBase = [[PWBannerViewInline alloc] initWithAdUnitName:self.adUnitName delegate:self];
    }
    
    if (self.bannerViewBase) {
        self.bannerViewBase.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:self.bannerViewBase];
        
        [NSLayoutConstraint activateConstraints:@[
            [self.bannerViewBase.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
            [self.bannerViewBase.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
        ]];
        
        // Use `[[PWLoadParams new] withTargeting:]` to pass your custom targets to ad request.
        //     PWLoadParams *params = [[PWLoadParams new] withTargeting:@{
        //       @"age": @"18-32",
        //       @"page": @"travel"
        //     }];
        //     [self.bannerViewBase loadWithParams:params];
        
        [self.bannerViewBase load];
    }
    
    self.statusLabel.text = [NSString stringWithFormat: @"⏳ The banner \"%@\" is loading.", self.adUnitName];
}

-(IBAction)refreshAction:(UIButton *)sender {
    // Refresh will start only if the ad unit contains `refresh` object.
    // See logs from `PWNotifier` to track status of refresh.
    
    [self.bannerViewBase refresh];
    
    NSArray *adUnits = [[[PlaywireSDK shared] config] adUnits];
    PWBannerRefresh *refresh;
    for(PWAdUnit *adUnit in adUnits) {
        if([adUnit.name isEqualToString:self.adUnitName]) {
            refresh = adUnit.refresh;
            break;
        }
    }
    
    if (!refresh) {
        self.statusLabel.text = [NSString stringWithFormat:@"⚠️ The banner \"%@\" can't be refreshed manually.\nSee logs to get more details.", self.adUnitName];
        return;
    }
    
    self.statusLabel.text = [NSString stringWithFormat:@"🔄 The banner \"%@\" is refreshing.", self.adUnitName];
}

#pragma mark - PWViewAdDelegate -

- (void)viewAdDidLoad:(PWViewAd * _Nonnull)ad {
    if (!self.bannerViewBase.isLoaded) return;
    
    self.statusLabel.text = [NSString stringWithFormat: @"✅ The banner \"%@\" is loaded.", self.adUnitName];
}

- (void)viewAdDidFailToLoad:(PWViewAd * _Nonnull)ad {
    self.statusLabel.text = [NSString stringWithFormat: @"❌ Failed to load the banner \"%@\".", self.adUnitName];
}

- (void)viewAdWillPresentFullScreenContent:(PWViewAd * _Nonnull)ad {}
- (void)viewAdWillDismissFullScreenContent:(PWViewAd * _Nonnull)ad {}
- (void)viewAdDidDismissFullScreenContent:(PWViewAd * _Nonnull)ad {}
- (void)viewAdDidRecordImpression:(PWViewAd * _Nonnull)ad {}
- (void)viewAdDidRecordClick:(PWViewAd * _Nonnull)ad {}

@end
