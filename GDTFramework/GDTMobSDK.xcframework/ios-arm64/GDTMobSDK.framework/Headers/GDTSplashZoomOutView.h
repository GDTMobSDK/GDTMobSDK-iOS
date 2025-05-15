//
//  GDTSplashZoomOutView.h
//  GDTMobApp
//
//  Created by nimomeng on 2020/11/11.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@class GDTSplashZoomOutView;

@protocol GDTSplashZoomOutViewDelegate <NSObject>
@optional
//挂件开始展示
- (void)splashZoomOutViewDidShow:(GDTSplashZoomOutView *)splashZoomOutView;
//挂件被点击
- (void)splashZoomOutViewDidClick:(GDTSplashZoomOutView *)splashZoomOutView;
//挂件关闭
- (void)splashZoomOutViewAdDidClose:(GDTSplashZoomOutView *)splashZoomOutView;
@end

@interface GDTSplashZoomOutView : UIView
@property (nonatomic, weak) UIViewController *rootViewController;
@property (nonatomic, weak) id<GDTSplashZoomOutViewDelegate> delegate;
@property (nonatomic, assign)BOOL isVideoAd;
@end

NS_ASSUME_NONNULL_END
