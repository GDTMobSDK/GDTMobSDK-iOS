//
//  NativeExpressAdViewController.h
//  GDTMobApp
//
//  Created by michaelxing on 2017/4/17.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface NativeExpressVideoAdViewController : UIViewController
@property (assign, nonatomic)  CGFloat widthSliderValue;
@property (assign, nonatomic)  CGFloat heightSliderValue;
- (IBAction)refreshButton:(id)sender;
- (void)changeTemplateSize;
@end
