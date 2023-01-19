//
//  CustomPlayerVideoView.h
//  GDTMobApp
//
//  Created by Tencent on 2022/10/24.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM (NSUInteger, GDTVideoPlayStatus) {
    GDTVideoPlayStatusInit,
    GDTVideoPlayStatusReady,
    GDTVideoPlayStatusPlaying,
    GDTVideoPlayStatusStopped,
    GDTVideoPlayStatusPaused,
    GDTVideoPlayStatusResumed,
    GDTVideoPlayStatusError,
};

@interface CustomPlayerVideoView : UIView

@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) GDTVideoPlayStatus status;
@property (nonatomic, strong) NSError *playError;

- (void)loadURL:(NSURL *)URL;
- (void)play;
- (void)pause;
- (void)resume;
- (void)stop;

/**
 * 视频广告时长，单位 ms
 */
- (CGFloat)videoDuration;

/**
 * 视频广告已播放时长，单位 ms
 */
- (CGFloat)videoPlayTime;

@end

NS_ASSUME_NONNULL_END
