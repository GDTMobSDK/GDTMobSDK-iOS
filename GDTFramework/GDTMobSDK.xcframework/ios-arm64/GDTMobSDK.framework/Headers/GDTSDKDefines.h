//
//  GDTSDKDefines.h
//  GDTMobApp
//
//  Created by royqpwang on 2017/11/6.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

#if defined(__has_attribute)
#if __has_attribute(deprecated)
#define GDT_DEPRECATED_MSG_ATTRIBUTE(s) __attribute__((deprecated(s)))
#define GDT_DEPRECATED_ATTRIBUTE __attribute__((deprecated))
#else
#define GDT_DEPRECATED_MSG_ATTRIBUTE(s)
#define GDT_DEPRECATED_ATTRIBUTE
#endif
#else
#define GDT_DEPRECATED_MSG_ATTRIBUTE(s)
#define GDT_DEPRECATED_ATTRIBUTE
#endif

#define GDTScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define GDTScreenWidth  ([UIScreen mainScreen].bounds.size.width)

#define GDTPerformSelector(target,selector,type,defualtValue) \
({\
    type result = defualtValue;\
    if ([target respondsToSelector:selector]) {\
        result = (type)[target performSelector:selector];\
    }\
    (result);\
})

/**
 *  视频播放器状态
 *
 *  播放器只可能处于以下状态中的一种
 *
 */
typedef NS_ENUM(NSUInteger, GDTMediaPlayerStatus) {
    GDTMediaPlayerStatusInitial = 0,         // 初始状态
    GDTMediaPlayerStatusLoading = 1,         // 加载中
    GDTMediaPlayerStatusStarted = 2,         // 开始播放
    GDTMediaPlayerStatusPaused = 3,          // 用户行为导致暂停
    GDTMediaPlayerStatusError = 4,           // 播放出错
    GDTMediaPlayerStatusStoped = 5,          // 播放停止
    
    GDTMediaPlayerStatusWillStart = 10,      // 即将播放
};

typedef enum GDTSDKLoginType {
    GDTSDKLoginTypeUnknow = 0,
    GDTSDKLoginTypeWeiXin = 1,    //微信账号
    GDTSDKLoginTypeQQ = 2,        //QQ账号
} GDTSDKLoginType;

typedef NS_ENUM(NSUInteger, GDTVideoPlayPolicy) {
    GDTVideoPlayPolicyUnknow = 0, // 默认值，未设置
    GDTVideoPlayPolicyAuto = 1,   // 用户角度看起来是自动播放
    GDTVideoPlayPolicyManual = 2  // 用户角度看起来是手动播放或点击后播放
};

typedef NS_ENUM(NSUInteger, GDTVideoRenderType) {
    GDTVideoRenderTypeUnknow = 0,
    GDTVideoRenderTypeSDK = 1,
    GDTVideoRenderTypeDeveloper = 2
};

typedef NS_ENUM (NSUInteger, GDTRewardAdType) {
    GDTRewardAdTypeVideo = 0,//激励视频
    GDTRewardAdTypePage = 1 //激励浏览
};

typedef NS_ENUM(NSInteger, GDTAdBiddingLossReason) {
    GDTAdBiddingLossReasonLowPrice          = 1,        // 有广告回包，竞败(竞争力不足)
    GDTAdBiddingLossReasonNoAd              = 2,        // 无广告回包
    GDTAdBiddingLossReasonAdSuccNoBid       = 101,      // 有回包但未竞价
    GDTAdBiddingLossReasonOther             = 10001     // 其他
};


