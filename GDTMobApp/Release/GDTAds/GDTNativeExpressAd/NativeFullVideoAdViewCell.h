//
//  NativeFullVideoAdViewCell.h
//  GDTMobApp
//
//  Created by Andrew on 2024/1/25.
//  Copyright © 2024 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDTNativeExpressAdView.h"
NS_ASSUME_NONNULL_BEGIN

@interface NativeFullVideoAdViewCell : UICollectionViewCell
@property (nonatomic, strong, nullable) GDTNativeExpressAdView *adView;
@end

NS_ASSUME_NONNULL_END
