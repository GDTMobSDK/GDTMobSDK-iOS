//
//  DemoUtil.m
//  GDTMobApp
//
//  Created by Andrew on 2022/5/16.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import "DemoUtil.h"

@implementation DemoUtil

+ (NSString *)videoPlayerStatusStringFromStatus:(GDTMediaPlayerStatus)status {
    
    NSString *statusString = @"Unknown Status";
    switch (status) {
        case GDTMediaPlayerStatusInitial:
            statusString = @"GDTMediaPlayerStatusInitial";
            break;
        case GDTMediaPlayerStatusLoading:
            statusString = @"GDTMediaPlayerStatusLoading";
            break;
        case GDTMediaPlayerStatusStarted:
            statusString = @"GDTMediaPlayerStatusStarted";
            break;
        case GDTMediaPlayerStatusPaused:
            statusString = @"GDTMediaPlayerStatusPaused";
            break;
        case GDTMediaPlayerStatusError:
            statusString = @"GDTMediaPlayerStatusError";
            break;
        case GDTMediaPlayerStatusStoped:
            statusString = @"GDTMediaPlayerStatusStoped";
            break;
        case GDTMediaPlayerStatusWillStart:
            statusString = @"GDTMediaPlayerStatusWillStart";
            break;
        default:
            break;
    }
    
    return statusString;
}
@end
