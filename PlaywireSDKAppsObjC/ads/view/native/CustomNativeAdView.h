//
//  CustomNativeAdView.h
//  PlaywireDemo
//
//  Created by Playwire Mobile Team on 01/06/23.
//  Copyright © 2023 Playwire. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Playwire-Swift.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomNativeAdView : UIView
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

- (void)configure:(PWNativeViewContent *)adContent;
@end

NS_ASSUME_NONNULL_END
