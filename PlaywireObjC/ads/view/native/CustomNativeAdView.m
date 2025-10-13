//
//  CustomNativeAdView.m
//  PlaywireDemo
//
//  Created by Playwire Mobile Team on 01/06/23.
//  Copyright © 2023 Playwire. All rights reserved.
//

#import "CustomNativeAdView.h"

@interface CustomNativeAdView ()
@property (strong, nonatomic) UILabel *headlineLabel;
@property (strong, nonatomic) UILabel *bodyLabel;
@property (strong, nonatomic) UIImageView *iconView;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *starLabel;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UILabel *storeLabel;
@property (strong, nonatomic) UILabel *advertiserLabel;
@property (strong, nonatomic, readwrite) UIButton *button;
@property (strong, nonatomic) PWNativeViewContent *adContent;
@end

@implementation CustomNativeAdView

- (instancetype)initWithAdContent:(PWNativeViewContent *)adContent {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _adContent = adContent;
        [self setupView];
    }
    return self;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Use initWithAdContent: instead"
                                 userInfo:nil];
}

- (instancetype)initWithFrame:(CGRect)frame {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Use initWithAdContent: instead"
                                 userInfo:nil];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Use initWithAdContent: instead"
                                 userInfo:nil];
}

- (void)setupView {
    // Create UI elements
    self.headlineLabel = [[UILabel alloc] init];
    self.headlineLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle2];
    self.headlineLabel.adjustsFontSizeToFitWidth = YES;
    
    self.bodyLabel = [[UILabel alloc] init];
    self.bodyLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle2];
    
    self.iconView = [[UIImageView alloc] init];
    self.imageView = [[UIImageView alloc] init];
    
    self.advertiserLabel = [[UILabel alloc] init];
    self.advertiserLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle3];
    
    self.button = [[UIButton alloc] init];
    [self.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.button setTitle:@"Click" forState:UIControlStateNormal];
    
    // Add subviews
    [self addSubview:self.iconView];
    [self addSubview:self.headlineLabel];
    [self addSubview:self.advertiserLabel];
    [self addSubview:self.imageView];
    [self addSubview:self.bodyLabel];
    [self addSubview:self.button];
    
    // Setup constraints
    self.iconView.translatesAutoresizingMaskIntoConstraints = NO;
    self.headlineLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.advertiserLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.bodyLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.button.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
        [self.iconView.widthAnchor constraintEqualToConstant:30],
        [self.iconView.heightAnchor constraintEqualToConstant:30],
        [self.iconView.topAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor constant:10],
        [self.iconView.leadingAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.leadingAnchor constant:10],
        
        [self.headlineLabel.topAnchor constraintEqualToAnchor:self.iconView.topAnchor],
        [self.headlineLabel.leadingAnchor constraintEqualToAnchor:self.iconView.trailingAnchor constant:10],
        [self.headlineLabel.trailingAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.trailingAnchor constant:-10],
        
        [self.advertiserLabel.bottomAnchor constraintEqualToAnchor:self.iconView.bottomAnchor],
        [self.advertiserLabel.leadingAnchor constraintEqualToAnchor:self.iconView.trailingAnchor constant:10],
        [self.advertiserLabel.widthAnchor constraintEqualToConstant:50],
        
        [self.imageView.topAnchor constraintEqualToAnchor:self.advertiserLabel.topAnchor],
        [self.imageView.leadingAnchor constraintEqualToAnchor:self.advertiserLabel.trailingAnchor],
        [self.imageView.widthAnchor constraintEqualToConstant:20],
        [self.imageView.heightAnchor constraintEqualToConstant:20],
        
        [self.bodyLabel.topAnchor constraintEqualToAnchor:self.iconView.bottomAnchor constant:20],
        [self.bodyLabel.leadingAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.leadingAnchor],
        [self.bodyLabel.trailingAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.trailingAnchor],
        
        [self.button.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        [self.button.widthAnchor constraintEqualToConstant:200],
        [self.button.heightAnchor constraintEqualToConstant:50]
    ]];
    
    // Configure with ad content
    self.iconView.image = self.adContent.icon;
    self.headlineLabel.text = self.adContent.headline;
    self.advertiserLabel.text = self.adContent.advertiser;
    self.imageView.image = self.adContent.image;
    self.bodyLabel.text = self.adContent.body;
    
    UIView *mediaView = self.adContent.mediaView;
    if (mediaView) {
        mediaView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:mediaView];
        
        [NSLayoutConstraint activateConstraints:@[
            [mediaView.topAnchor constraintEqualToAnchor:self.bodyLabel.bottomAnchor constant:10],
            [mediaView.leadingAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.leadingAnchor],
            [mediaView.trailingAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.trailingAnchor],
            [mediaView.heightAnchor constraintEqualToConstant:200],
            
            [self.button.topAnchor constraintEqualToAnchor:mediaView.bottomAnchor constant:10]
        ]];
    }
    
    [self.button setTitle:self.adContent.callToAction forState:UIControlStateNormal];
}


@end
