//
//  DataDetectorViewController.m
//  GDTMobApp
//
//  Created by nimo on 2020/8/25.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "DataDetectorViewController.h"
#import "GDTDataDetector.h"

@interface DataDetectorViewController ()
@property (weak, nonatomic) IBOutlet UITextField *customEventName;
@property (weak, nonatomic) IBOutlet UITextField *customEventParamKey;
@property (weak, nonatomic) IBOutlet UITextField *customEventParamValue;
@end

@implementation DataDetectorViewController

- (IBAction)sendEvent:(id)sender {
    NSDictionary *dict = nil;
    if (self.customEventParamKey.text.length > 0 ||
        self.customEventParamValue.text.length > 0) {
        dict = @{self.customEventParamKey.text:self.customEventParamValue.text};
    }
    [GDTDataDetector sendEventWithName:self.customEventName.text extParams:dict];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

@end
