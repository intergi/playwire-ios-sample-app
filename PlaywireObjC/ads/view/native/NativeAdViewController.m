//
//  NativeAdViewController.m
//  PlaywireDemo
//
//  Created by Playwire Mobile Team on 01/06/23.
//  Copyright © 2023 Playwire. All rights reserved.
//

#import "NativeAdViewController.h"
#import <Playwire-Swift.h>
#import "PlaywireObjC-Swift.h"

@interface NativeAdViewController () <NativeContainerViewDelegate>
@property (strong, nonatomic) UILabel *statusLabel;
@property (strong, nonatomic) NativeContainerView *nativeContainerView;
@property (strong, nonatomic) UIStackView *mainStack;
@end

@implementation NativeAdViewController

- (instancetype)initWithAdUnitName:(NSString *)adUnitName {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _adUnitName = [adUnitName copy];
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
    
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    
    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.textColor = [UIColor labelColor];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    self.statusLabel.numberOfLines = 0;
    
    self.nativeContainerView = [[NativeContainerView alloc] initWithAdUnitName:self.adUnitName
                                                                    controller:self];
    self.nativeContainerView.delegate = self;
    
    self.mainStack = [[UIStackView alloc] initWithArrangedSubviews:@[
        self.nativeContainerView,
        self.statusLabel
    ]];
    self.mainStack.axis = UILayoutConstraintAxisVertical;
    self.mainStack.spacing = 12;
    self.mainStack.alignment = UIStackViewAlignmentFill;
    self.mainStack.distribution = UIStackViewDistributionFill;
    self.mainStack.translatesAutoresizingMaskIntoConstraints = NO;
    self.mainStack.layoutMarginsRelativeArrangement = YES;
    self.mainStack.layoutMargins = UIEdgeInsetsMake(12, 12, 12, 12);
    
    [self.view addSubview:self.mainStack];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.mainStack.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.mainStack.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
        [self.mainStack.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
        [self.mainStack.bottomAnchor constraintLessThanOrEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
    ]];
    
    [self.nativeContainerView loadAd];
}

#pragma mark - NativeContainerViewDelegate

- (void)nativeContainerViewDidStartLoading:(NativeContainerView *)containerView
                                adUnitName:(NSString *)adUnitName {
    self.statusLabel.text = [NSString stringWithFormat:@"The native ad \"%@\" is loading.", adUnitName];
}

- (void)nativeContainerViewDidLoad:(NativeContainerView *)containerView
                        adUnitName:(NSString *)adUnitName {
    self.statusLabel.text = [NSString stringWithFormat:@"The native ad \"%@\" is loaded.", adUnitName];
}

- (void)nativeContainerViewDidFailToLoad:(NativeContainerView *)containerView
                              adUnitName:(NSString *)adUnitName {
    self.statusLabel.text = [NSString stringWithFormat:@"Failed to load the native ad \"%@\".", adUnitName];
}

- (void)nativeContainerViewDidRecordImpression:(NativeContainerView *)containerView
                                    adUnitName:(NSString *)adUnitName {
    self.statusLabel.text = [NSString stringWithFormat:@"The native ad \"%@\" recorded an impression.", adUnitName];
}

- (void)nativeContainerViewDidRecordClick:(NativeContainerView *)containerView
                               adUnitName:(NSString *)adUnitName {
    self.statusLabel.text = [NSString stringWithFormat:@"The native ad \"%@\" was clicked.", adUnitName];
}

@end
