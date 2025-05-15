//
//  DemoUtil.h
//  GDTMobApp
//
//  Created by Andrew on 2022/5/16.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDTSDKDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface DemoUtil : NSObject

+ (NSString *)videoPlayerStatusStringFromStatus:(GDTMediaPlayerStatus)status;

@end

NS_ASSUME_NONNULL_END
