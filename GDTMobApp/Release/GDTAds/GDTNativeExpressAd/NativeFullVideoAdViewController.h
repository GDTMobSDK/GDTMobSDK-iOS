//
//  NativeFullVideoAdViewController.h
//  GDTMobApp
//
//  Created by Andrew on 2024/1/25.
//  Copyright © 2024 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NativeFullVideoAdViewController : UIViewController
@property (nonatomic, copy) NSString *idString;
@property (nonatomic, assign) NSInteger adCount;
@property (nonatomic) float minVideoDuration;
@property (nonatomic) float maxVideoDuration;
@property (nonatomic) BOOL videoAutoPlay;
@property (nonatomic) BOOL videoMuted;
@property (nonatomic) BOOL videoDetailPageVideoMuted;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, assign) BOOL useToken;

@end

NS_ASSUME_NONNULL_END
