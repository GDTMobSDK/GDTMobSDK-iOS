//
//  BUGDT_RewardVideoAdDelegateObject.m
//  GDTMobApp
//
//  Created by Nancy on 2021/1/12.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "BUGDT_RewardVideoAdDelegateObject.h"

@implementation BUGDT_RewardVideoAdDelegateObject

#pragma mark - BURewardedVideoAdDelegate
/**
 rewardedVideoAd 激励视频广告-物料-加载成功
 @param rewardedVideoAd 当前激励视频素材
 */
- (void)rewardedVideoAdDidLoad:(BURewardedVideoAd *)rewardedVideoAd
{
    self.adDidLoaded = YES;
    self.loadedTime = [[NSDate date] timeIntervalSince1970];
    [self.rewardVideoAdConnector adapter_rewardVideoAdDidLoad:self.adapter];
}

/**
 rewardedVideoAd 激励视频广告-视频-加载成功
 @param rewardedVideoAd 当前激励视频素材
 */
- (void)rewardedVideoAdVideoDidLoad:(BURewardedVideoAd *)rewardedVideoAd
{
    [self.rewardVideoAdConnector adapter_rewardVideoAdVideoDidLoad:self.adapter];
}

/**
 rewardedVideoAd 广告位即将展示
 
 @param rewardedVideoAd 当前激励视频对象
 */
- (void)rewardedVideoAdWillVisible:(BURewardedVideoAd *)rewardedVideoAd
{
    [self.rewardVideoAdConnector adapter_rewardVideoAdWillVisible:self.adapter];
}

/**
 rewardedVideoAd 广告位已经展示
 
 @param rewardedVideoAd 当前激励视频对象
 */
- (void)rewardedVideoAdDidVisible:(BURewardedVideoAd *)rewardedVideoAd
{
    [self.rewardVideoAdConnector adapter_rewardVideoAdDidExposed:self.adapter];
}

/**
 rewardedVideoAd 激励视频广告关闭
 
 @param rewardedVideoAd 当前激励视频对象
 */
- (void)rewardedVideoAdDidClose:(BURewardedVideoAd *)rewardedVideoAd
{
    [self.rewardVideoAdConnector adapter_rewardVideoAdDidClose:self.adapter];
}

/**
 rewardedVideoAd 激励视频广告点击
 
 @param rewardedVideoAd 当前激励视频对象
 */
- (void)rewardedVideoAdDidClick:(BURewardedVideoAd *)rewardedVideoAd
{
    [self.rewardVideoAdConnector adapter_rewardVideoAdDidClicked:self.adapter];
}

/**
 rewardedVideoAd 激励视频广告素材加载失败
 
 @param rewardedVideoAd 当前激励视频对象
 @param error 错误对象
 */
- (void)rewardedVideoAd:(BURewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error
{
    // TODO  头条 error -> GDT error
    [self.rewardVideoAdConnector adapter_rewardVideoAd:self.adapter didFailWithError:error];
}

/**
 rewardedVideoAd 激励视频广告播放完成或发生错误
 
 @param rewardedVideoAd 当前激励视频对象
 @param error 错误对象
 */
- (void)rewardedVideoAdDidPlayFinish:(BURewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error
{
    if (error) {
        // TODO  头条 error -> GDT error
        [self.rewardVideoAdConnector adapter_rewardVideoAd:self.adapter didFailWithError:error];
    } else {
        [self.rewardVideoAdConnector adapter_rewardVideoAdDidPlayFinish:self.adapter];
    }
}

/**
 Server verification which is requested asynchronously is succeeded.
 @param verify :return YES when return value is 2000.
 */
- (void)rewardedVideoAdServerRewardDidSucceed:(BURewardedVideoAd *)rewardedVideoAd verify:(BOOL)verify {
    [self.rewardVideoAdConnector adapter_rewardVideoAdDidRewardEffective:self.adapter];
}

/**
  Server verification which is requested asynchronously is failed.
  @param rewardedVideoAd rewarded Video ad
  @param error request error info
 */
- (void)rewardedVideoAdServerRewardDidFail:(BURewardedVideoAd *)rewardedVideoAd error:(NSError *)error {
    // TODO  头条 error -> GDT error
    [self.rewardVideoAdConnector adapter_rewardVideoAd:self.adapter didFailWithError:nil];
}

@end
