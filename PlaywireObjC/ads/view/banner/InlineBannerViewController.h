//
//  InlineBannerViewController.h
//  PlaywireDemo
//
//  Created by Playwire Mobile Team on 01/06/23.
//  Copyright © 2023 Playwire. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdUnitViewControllerType.h"

NS_ASSUME_NONNULL_BEGIN

@interface InlineBannerViewController : UIViewController<AdUnitViewControllerType>
// The ad unit name, e.g. 'banner-320x50', 'interstitial-home', 'rewarded-coins', etc.
@property (strong, nonatomic) NSString *adUnitName;
@end

NS_ASSUME_NONNULL_END
