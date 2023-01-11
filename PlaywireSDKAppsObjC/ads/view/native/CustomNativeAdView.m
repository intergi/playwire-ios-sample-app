//
//  CustomNativeAdView.m
//  PlaywireDemo
//
//  Created by Playwire Mobile Team on 01/06/23.
//  Copyright © 2023 Playwire. All rights reserved.
//

#import "CustomNativeAdView.h"

@interface CustomNativeAdView ()
@property (weak, nonatomic) IBOutlet UILabel *headlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *starLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeLabel;
@property (weak, nonatomic) IBOutlet UILabel *advertiserLabel;
@property (weak, nonatomic) IBOutlet UIView *mediaViewHolder;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@end

@implementation CustomNativeAdView

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)init {
    self = [self initWithFrame:CGRectZero];
    return self;
}

- (void)setupView {
    [[NSBundle mainBundle] loadNibNamed:@"CustomNativeAdView" owner:self options:nil];
    
    self.contentView.translatesAutoresizingMaskIntoConstraints = false;
    [self addSubview: self.contentView];
    self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
    [NSLayoutConstraint activateConstraints:@[
        [self.contentView.leftAnchor constraintEqualToAnchor:self.leftAnchor],
        [self.contentView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.contentView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.contentView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ]];
}

- (void)configure:(PWNativeViewContent *)adContent {
    // Configure views with ad content
    self.iconView.image = adContent.image;
    self.headlineLabel.text = adContent.headline;
    self.actionButton.titleLabel.text = adContent.callToAction;
    self.bodyLabel.text = adContent.body;
    
    if (adContent.starRating) {
        self.starLabel.text = [NSString stringWithFormat:@"%@ ⭐️", [adContent.starRating stringValue]];
    }
    // Hide view in case ad content doesn't contain required information
    [self.starLabel setHidden:adContent.starRating == NULL];

    self.priceLabel.text = adContent.price;
    [self.priceLabel setHidden:adContent.price == NULL];
    
    self.advertiserLabel.text = adContent.advertiser;
    [self.advertiserLabel setHidden:adContent.advertiser == NULL];
    
    self.storeLabel.text = adContent.store;
    [self.storeLabel setHidden:adContent.store == NULL];
    

    UIView* mediaView = adContent.mediaView;
    if (mediaView) {
        mediaView.translatesAutoresizingMaskIntoConstraints = false;
        [self.mediaViewHolder addSubview:mediaView];
        [NSLayoutConstraint activateConstraints:@[
            [mediaView.topAnchor constraintEqualToAnchor: self.mediaViewHolder.topAnchor],
            [mediaView.bottomAnchor constraintEqualToAnchor: self.mediaViewHolder.bottomAnchor],
            [mediaView.leadingAnchor constraintEqualToAnchor: self.mediaViewHolder.leadingAnchor],
            [mediaView.trailingAnchor constraintEqualToAnchor: self.mediaViewHolder.trailingAnchor],
        ]];
    }
}


@end
