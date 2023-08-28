//
//  CustomPlayerVideoView.m
//  GDTMobSDK
//
//  Created by Tencent on 2022/10/24.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import "CustomPlayerVideoView.h"
#import <AVKit/AVKit.h>

@interface CustomPlayerVideoView ()

@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) id observer;
@end

@implementation CustomPlayerVideoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)loadURL:(NSURL *)URL {
    if (![URL isKindOfClass:[NSURL class]]) {
        return;
    }
    
    if (_playerItem) {
        [_playerItem removeObserver:self forKeyPath:@"status"];
    }
    
    AVAsset *avasset = [AVAsset assetWithURL:URL];
    _playerItem = [AVPlayerItem playerItemWithAsset:avasset automaticallyLoadedAssetKeys:@[@"duration"]];
    if (!_playerItem) {
        return;
    }
    
    if (_player) {
        if (self.isPlaying) {
            [_player pause];
        }
            
        if (_observer) {
            [_player removeTimeObserver:_observer];
        }
        
        [_player removeObserver:self forKeyPath:@"rate"];
        [_player replaceCurrentItemWithPlayerItem:_playerItem];
    } else {
        _player = [AVPlayer playerWithPlayerItem:_playerItem];
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        [self.layer addSublayer:_playerLayer];
    }
    
    CMTime time = CMTimeMake(1, 1);
    __weak __typeof(self) ws = self;
    _observer = [_player addPeriodicTimeObserverForInterval:time queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        __strong __typeof(ws) self = ws;
        NSTimeInterval total = self.videoDuration;
        NSTimeInterval current = self.videoPlayTime;
        if (total <= 0)
        {
            return;
        }
        if (current >= total) {
            if (self.status != GDTVideoPlayStatusStopped) {
                self.status = GDTVideoPlayStatusStopped;
            }
        }
    }];
    
    [_playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [_player addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew context:NULL];
    self.status = GDTVideoPlayStatusInit;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.playerItem && [keyPath isEqualToString:@"status"]) {
        if (self.playerItem.status == AVPlayerItemStatusReadyToPlay) {
        } else if (self.playerItem.status == AVPlayerItemStatusFailed) {
            self.status = GDTVideoPlayStatusError;
            self.playError = self.playerItem.error;
        }
    } else if (object == self.player && [keyPath isEqualToString:@"rate"]) {
        float rate = [change[NSKeyValueChangeNewKey] floatValue];
        if (rate == 1.0 && self.status == GDTVideoPlayStatusReady) {
            self.status = GDTVideoPlayStatusPlaying;
        }
    }
}

- (void)play {
    if (!_player || !_player.currentItem) {
        return;
    }
    
    self.status = GDTVideoPlayStatusReady;
    
    [_player seekToTime:kCMTimeZero];
    [_player play];
    _player.muted = NO;
}

- (void)pause {
    if (!_player || !_player.currentItem) {
        return;
    }
    
    [_player pause];
    self.status = GDTVideoPlayStatusPaused;
}

- (void)resume {
    if (!_player || !_player.currentItem) {
        return;
    }
    
    if (_status != GDTVideoPlayStatusPaused) {
        return;
    }
    
    if (_player.status == AVPlayerStatusReadyToPlay) {
        [_player play];
    }
    self.status = GDTVideoPlayStatusResumed;
}

- (void)stop {
    if (!_player || !_player.currentItem) {
        return;
    }
    [_player pause];
    self.status = GDTVideoPlayStatusStopped;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _playerLayer.frame = self.bounds;
}

- (BOOL)isPlaying {
    return _status == GDTVideoPlayStatusPlaying;
}

- (void)setStatus:(GDTVideoPlayStatus)status {
    if (status == _status) return;
    _status = status;
}

- (CGFloat)videoDuration {
    NSTimeInterval sec = CMTimeGetSeconds(self.player.currentItem.duration);
    if (isnan(sec)) {
        return 0;
    }
    return sec * 1000;
}

- (CGFloat)videoPlayTime {
    if (self.status == GDTVideoPlayStatusPlaying || self.status == GDTVideoPlayStatusPaused || self.status == GDTVideoPlayStatusResumed) {
        NSTimeInterval sec = CMTimeGetSeconds(self.player.currentItem.currentTime);
        if (isnan(sec)) {
            return 0;
        }
        return sec * 1000;
    }
    else {
        return 0;
    }
}

- (void)dealloc {
    if (self.player) {
        [self.player pause];
        [self.player removeObserver:self forKeyPath:@"rate"];
    }
    if (self.playerItem) {
        [self.playerItem removeObserver:self forKeyPath:@"status"];
    }
}

@end
