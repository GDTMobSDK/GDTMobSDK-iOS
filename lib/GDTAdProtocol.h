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

#endif /* GDTAdProtocol_h */
