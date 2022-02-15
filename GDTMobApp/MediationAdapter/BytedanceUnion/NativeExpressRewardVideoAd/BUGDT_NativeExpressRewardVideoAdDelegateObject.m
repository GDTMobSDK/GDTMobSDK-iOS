//
//  BUGDT_NativeExpressRewardVideoAdDelegateObject.m
//  GDTMobApp
//
//  Created by zhangzilong on 2021/4/27.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "BUGDT_NativeExpressRewardVideoAdDelegateObject.h"

@implementation BUGDT_NativeExpressRewardVideoAdDelegateObject

- (void)nativeExpressRewardedVideoAdDidLoad:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    self.isAdValid = YES;
    self.loadedTime = [[NSDate date] timeIntervalSince1970];
    [self.connector adapter_rewardVideoAdDidLoad:self.adapter];
}

/**
 rewardedVideoAd 激励视频广告-视频-加载成功
 @param rewardedVideoAd 当前激励视频素材
 */
- (void)nativeExpressRewardedVideoAdDidDownLoadVideo:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd
{
    [self.connector adapter_rewardVideoAdVideoDidLoad:self.adapter];
}

/**
 rewardedVideoAd 广告位即将展示
 
 @param rewardedVideoAd 当前激励视频对象
 */
- (void)nativeExpressRewardedVideoAdWillVisible:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    [self.connector adapter_rewardVideoAdWillVisible:self.adapter];
}

/**
 rewardedVideoAd 广告位已经展示
 
 @param rewardedVideoAd 当前激励视频对象
 */
- (void)nativeExpressRewardedVideoAdDidVisible:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd
{
    [self.connector adapter_rewardVideoAdDidExposed:self.adapter];
}

/**
 rewardedVideoAd 激励视频广告关闭
 
 @param rewardedVideoAd 当前激励视频对象
 */
- (void)nativeExpressRewardedVideoAdDidClose:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd
{
    [self.connector adapter_rewardVideoAdDidClose:self.adapter];
}

/**
 rewardedVideoAd 激励视频广告点击
 
 @param rewardedVideoAd 当前激励视频对象
 */
- (void)nativeExpressRewardedVideoAdDidClick:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd
{
    [self.connector adapter_rewardVideoAdDidClicked:self.adapter];
}

/**
 rewardedVideoAd 激励视频广告素材加载失败
 
 @param rewardedVideoAd 当前激励视频对象
 @param error 错误对象
 */
- (void)nativeExpressRewardedVideoAd:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error
{
    [self.connector adapter_rewardVideoAd:self.adapter didFailWithError:error];
}

/**
 rewardedVideoAd 激励视频广告播放完成或发生错误
 
 @param rewardedVideoAd 当前激励视频对象
 @param error 错误对象
 */
- (void)nativeExpressRewardedVideoAdDidPlayFinish:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *_Nullable)error {
    if (error) {
        [self.connector adapter_rewardVideoAd:self.adapter didFailWithError:error];
    } else {
        [self.connector adapter_rewardVideoAdDidPlayFinish:self.adapter];
    }
}

/**
 Server verification which is requested asynchronously is succeeded. now include two v erify methods:
      1. C2C need  server verify  2. S2S don't need server verify
 @param verify :return YES when return value is 2000.
 */
- (void)nativeExpressRewardedVideoAdServerRewardDidSucceed:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd verify:(BOOL)verify {
    [self.connector adapter_rewardVideoAdDidRewardEffective:self.adapter];
}

/**
  Server verification which is requested asynchronously is failed.
  @param rewardedVideoAd express rewardVideo Ad
  @param error request error info
 */
- (void)nativeExpressRewardedVideoAdServerRewardDidFail:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd error:(NSError *_Nullable)error;
{
    [self.connector adapter_rewardVideoAd:self.adapter didFailWithError:nil];
}

@end
