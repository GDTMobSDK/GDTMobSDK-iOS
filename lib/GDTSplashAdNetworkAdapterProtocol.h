//
//  GDTSplashAdNetworkAdapterProtocol.h
//  GDTMobApp
//
//  Created by royqpwang on 2019/7/27.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDTBaseAdNetworkAdapterProtocol.h"
#import "GDTServerSideVerificationOptions.h"

@protocol GDTSplashAdNetworkConnectorProtocol;

NS_ASSUME_NONNULL_BEGIN

@protocol GDTSplashAdNetworkAdapterProtocol <GDTBaseAdNetworkAdapterProtocol>

@property (nonatomic, assign) NSInteger fetchDelay;

@property (nonatomic, strong) UIImage *backgroundImage;

@property (nonatomic, copy) UIColor *backgroundColor;

@property (nonatomic, assign) CGPoint skipButtonCenter;

@property (nonatomic, assign) BOOL shouldLoadFullscreenAd;

- (BOOL)isAdValid;
- (void)loadAd;
- (void)showAdInWindow:(UIWindow *)window withBottomView:(UIView *_Nullable)bottomView skipView:(UIView *)skipView;

@end

NS_ASSUME_NONNULL_END
