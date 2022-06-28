//
//  S2SManager.h
//  GDTMobApp
//
//  Created by zhangzilong on 2021/7/27.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface S2SBiddingManager : NSObject

+ (void)getTokenWithPlacementId:(NSString *)placementId completion:(void (^)(NSString *token))completion;

@end

NS_ASSUME_NONNULL_END
