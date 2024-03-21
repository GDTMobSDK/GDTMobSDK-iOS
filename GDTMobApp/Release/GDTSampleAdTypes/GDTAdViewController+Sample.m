//
//  GDTAdViewController+Sample.m
//  GDTMobApp
//
//  Created by royqpwang on 2019/3/26.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "GDTAdViewController+Sample.h"

@implementation GDTAdViewController (Sample)

- (void)loadView
{
    [super loadView];
    self.demoArray = [@[
                        @[@"自渲染2.0", @"UnifiedNativeAdViewController"],
                        @[@"开屏广告", @"SplashViewController"],
                        @[@"原生模板广告(优量汇渲染)", @"NativeExpressAdViewController"],
                        @[@"原生视频模板广告(优量汇渲染)", @"NativeExpressVideoAdViewController"],
                        @[@"原生沉浸式模板广告(优量汇渲染)", @"NativeFullExpressAdViewController"],
                        @[@"激励视频广告", @"RewardVideoViewController"],
                        @[@"Banner2.0", @"UnifiedBannerViewController"],
                        @[@"插屏2.0", @"UnifiedInterstitialViewController"],
                        @[@"插屏2.0全屏", @"UnifiedInterstitialFullScreenVideoViewController"],
                        ] mutableCopy];
}

@end
