//
//  BDGDT_RewardVideoAdDelegateObject.m
//  GDTMobApp
//
//  Created by Nancy on 2021/4/27.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "BDGDT_RewardVideoAdDelegateObject.h"

@implementation BDGDT_RewardVideoAdDelegateObject

#pragma mark - BaiduMobAdRewardVideoDelegate

- (void)rewardedVideoAdLoaded:(BaiduMobAdRewardVideo *)video {
    [self.connector adapter_rewardVideoAdDidLoad:self.adapter];
}

- (void)rewardedVideoAdLoadFailed:(BaiduMobAdRewardVideo *)video withError:(BaiduMobFailReason)reason {
    [self.connector adapter_rewardVideoAd:self.adapter didFailWithError:nil];
}

- (void)rewardedVideoAdShowFailed:(BaiduMobAdRewardVideo *)video withError:(BaiduMobFailReason)reason {
    [self.connector adapter_rewardVideoAd:self.adapter didFailWithError:nil];
}

- (void)rewardedVideoAdDidStarted:(BaiduMobAdRewardVideo *)video {
    [self.connector adapter_rewardVideoAdDidExposed:self.adapter];
}

- (void)rewardedVideoAdDidPlayFinish:(BaiduMobAdRewardVideo *)video {
    [self.connector adapter_rewardVideoAdDidPlayFinish:self.adapter];
}

- (void)rewardedVideoAdRewardDidSuccess:(BaiduMobAdRewardVideo *)video verify:(BOOL)verify {
    [self.connector adapter_rewardVideoAdDidRewardEffective:self.adapter];
}

- (void)rewardedVideoAdDidClick:(BaiduMobAdRewardVideo *)video withPlayingProgress:(CGFloat)progress {
    [self.connector adapter_rewardVideoAdDidClicked:self.adapter];
}

- (void)rewardedVideoAdDidClose:(BaiduMobAdRewardVideo *)video withPlayingProgress:(CGFloat)progress {
    [self.connector adapter_rewardVideoAdDidClose:self.adapter];
}


@end
