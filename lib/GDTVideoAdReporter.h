//
//  GDTVideoAdReporter.h
//  GDTMobSDK
//
//  Created by Nancy on 2022/10/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GDTVideoAdReporter <NSObject>

@required

/**
 * 视频开始播放
 * @param duration 视频总时长，单位毫秒
 */
- (void)didStartPlayVideoWithVideoDuration:(NSTimeInterval)duration;

/**
 * 视频播放完成
 */
- (void)didFinishPlayingVideo;

/**
 * 视频暂停播放
 * @param duration 视频已播放时长，单位毫秒
 */
- (void)didPauseVideoWithCurrentDuration:(NSTimeInterval)duration;

/**
 * 视频恢复播放
 * @param duration 视频已播放时长，单位毫秒
 */
- (void)didResumeVideoWithCurrentDuration:(NSTimeInterval)duration;

/**
 * 视频播放失败
 * @param error 失败原因
 */
- (void)didPlayFailedWithError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
