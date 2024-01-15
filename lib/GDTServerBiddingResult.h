//
//  GDTServerBiddingResult.h
//  GDTMobApp
//
//  Created by Nancy on 2022/8/8.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GDTServerBiddingResult : NSObject
@property (nonatomic, assign) NSInteger adnet_id;
@property (nonatomic, copy) NSString *posId;
@property (nonatomic, assign) NSInteger ecpm;//竞价价格/失败价格
@property (nonatomic, copy) NSString *payload;//得标票据
@property (nonatomic, copy) NSString *nurl;//得标url
@property (nonatomic, copy) NSString *lurl;//失标url
@property (nonatomic, assign) NSInteger load_ec;//adn返回code
@property (nonatomic, copy) NSString *load_em;//adn返回msg
@property (nonatomic, copy) NSString *load_stat;//失败原因

@end


NS_ASSUME_NONNULL_END
