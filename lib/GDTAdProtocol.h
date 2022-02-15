//
//  GDTAdProtocol.h
//  GDTMobApp
//
//  Created by rowanzhang on 2021/12/23.
//  Copyright © 2021 Tencent. All rights reserved.
//

#ifndef GDTAdProtocol_h
#define GDTAdProtocol_h

#define GDT_REQ_ID_KEY @"request_id"

@protocol GDTAdProtocol <NSObject>

@optional
- (NSDictionary *)extraInfo;

@end

@protocol GDTAdDelegate <NSObject>

@optional
/**
  投诉成功回调
  @params ad 广告对象实例
 */
- (void)gdtAdComplainSuccess:(id)ad;

@end
#endif /* GDTAdProtocol_h */
