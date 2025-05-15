//
//  UnifiedBannerViewController.h
//  GDTMobApp
//
//  Created by nimomeng on 2019/3/7.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface UnifiedBannerViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISlider *heightSlide;
@property (weak, nonatomic) IBOutlet UISlider *layoutAspectRatioSlide;
- (void)changeTemplateSize;
@end

NS_ASSUME_NONNULL_END
