//
//  KSGDT_RewardVideoAdDelegateObject.m
//  GDTMobApp
//
//  Created by Nancy on 2021/1/15.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "KSGDT_RewardVideoAdDelegateObject.h"

@implementation KSGDT_RewardVideoAdDelegateObject

#pragma mark - KSRewardedVideoAdDelegate

/**
 This method is called when video ad material loaded successfully.
 */
- (void)rewardedVideoAdDidLoad:(KSRewardedVideoAd *)rewardedVideoAd
{
    self.loadedTime = [[NSDate date] timeIntervalSince1970];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.rewardVideoAdConnector adapter_rewardVideoAdDidLoad:self.adapter];
    });
}
/**
 This method is called when video ad materia failed to load.
 @param error : the reason of error
 */
- (void)rewardedVideoAd:(KSRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *_Nullable)error
{
    [self.rewardVideoAdConnector adapter_rewardVideoAd:self.adapter didFailWithError:error];
}
/**
 This method is called when cached successfully.
 */
- (void)rewardedVideoAdVideoDidLoad:(KSRewardedVideoAd *)rewardedVideoAd
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.rewardVideoAdConnector adapter_rewardVideoAdVideoDidLoad:self.adapter];
    });
}
/**
 This method is called when video ad slot will be showing.
 */
- (void)rewardedVideoAdWillVisible:(KSRewardedVideoAd *)rewardedVideoAd
{
    [self.rewardVideoAdConnector adapter_rewardVideoAdWillVisible:self.adapter];
}
/**
 This method is called when video ad slot has been shown.
 */
- (void)rewardedVideoAdDidVisible:(KSRewardedVideoAd *)rewardedVideoAd
{
    [self.rewardVideoAdConnector adapter_rewardVideoAdDidExposed:self.adapter];
}
/**
 This method is called when video ad is about to close.
 */
- (void)rewardedVideoAdWillClose:(KSRewardedVideoAd *)rewardedVideoAd
{
    
}
/**
 This method is called when video ad is closed.
 */
- (void)rewardedVideoAdDidClose:(KSRewardedVideoAd *)rewardedVideoAd
{
    [self.rewardVideoAdConnector adapter_rewardVideoAdDidClose:self.adapter];
}

/**
 This method is called when video ad is clicked.
 */
- (void)rewardedVideoAdDidClick:(KSRewardedVideoAd *)rewardedVideoAd
{
    [self.rewardVideoAdConnector adapter_rewardVideoAdDidClicked:self.adapter];
}
/**
 This method is called when video ad play completed or an error occurred.
 @param error : the reason of error
 */
- (void)rewardedVideoAdDidPlayFinish:(KSRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *_Nullable)error
{
    if (error) {
        [self.rewardVideoAdConnector adapter_rewardVideoAd:self.adapter didFailWithError:error];
    } else {
        [self.rewardVideoAdConnector adapter_rewardVideoAdDidPlayFinish:self.adapter];
    }
}
/**
 This method is called when the user clicked skip button.
 */
- (void)rewardedVideoAdDidClickSkip:(KSRewardedVideoAd *)rewardedVideoAd
{
    
}
/**
 This method is called when the video begin to play.
 */
- (void)rewardedVideoAdStartPlay:(KSRewardedVideoAd *)rewardedVideoAd
{
    
}
/**
 This method is called when the user close video ad.
 */
- (void)rewardedVideoAd:(KSRewardedVideoAd *)rewardedVideoAd hasReward:(BOOL)hasReward
{
    if (hasReward) {
        [self.rewardVideoAdConnector adapter_rewardVideoAdDidRewardEffective:self.adapter];
    }
}

@end
