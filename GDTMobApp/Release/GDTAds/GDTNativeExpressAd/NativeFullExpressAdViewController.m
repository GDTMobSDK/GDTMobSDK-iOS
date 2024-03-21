//
//  NativeFullExpressAdViewController.m
//  GDTMobApp
//
//  Created by Andrew on 2024/1/30.
//  Copyright © 2024 Tencent. All rights reserved.
//

#import "NativeFullExpressAdViewController.h"
#import "NativeFullVideoAdViewController.h"
#import "NativeExpressVideoConfigView.h"

@interface NativeFullExpressAdViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, copy) NSString *idString;
@property (nonatomic, assign) NSInteger adCount;
@property (assign, nonatomic)  float widthSliderValue;
@property (assign, nonatomic)  float heightSliderValue;
@property (nonatomic) float minVideoDuration;
@property (nonatomic) float maxVideoDuration;
@property (nonatomic) BOOL videoAutoPlay;
@property (nonatomic) BOOL videoMuted;
@property (nonatomic) BOOL videoDetailPageVideoMuted;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, assign) BOOL useToken;
@end

@implementation NativeFullExpressAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"更多视频配置" style:UIBarButtonItemStylePlain target:self action:@selector(jumpToAnotherView)];
    CGSize size = self.view.frame.size;
    self.widthSliderValue = size.width;
    self.heightSliderValue = size.height;
    self.adCount = 1;
    _textField.placeholder = [self.getAdvTypeTextArray.firstObject lastObject];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)changeIdAction:(UIButton *)sender {
    UIAlertController *advStyleAlertController = [UIAlertController alertControllerWithTitle:@"请选择需要的广告样式" message:nil preferredStyle:[[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? UIAlertControllerStyleAlert : UIAlertControllerStyleActionSheet];
    NSArray *advTypeTextArray = [self getAdvTypeTextArray];
    
    for (NSInteger i = 0; i < advTypeTextArray.count; i++) {
        UIAlertAction *advTypeAction = [UIAlertAction actionWithTitle:advTypeTextArray[i][0]
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action) {
            _textField.placeholder = advTypeTextArray[i][1];
        }];
        [advStyleAlertController addAction:advTypeAction];
    }
    [advStyleAlertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    if (advStyleAlertController.popoverPresentationController) {
        [advStyleAlertController.popoverPresentationController setPermittedArrowDirections:0];
        advStyleAlertController.popoverPresentationController.sourceView=self.view;
        advStyleAlertController.popoverPresentationController.sourceRect=CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height);
    }
    [self presentViewController:advStyleAlertController
                       animated:YES
                     completion:nil];
}

- (IBAction)loadAndShowAction:(UIButton *)sender {
    NSString *idString = _textField.text.length > 0 ? _textField.text : _textField.placeholder;
    NativeFullVideoAdViewController *vc = [[NativeFullVideoAdViewController alloc] init];
    vc.idString = idString;
    vc.minVideoDuration = self.minVideoDuration;
    vc.maxVideoDuration = self.maxVideoDuration;
    vc.videoAutoPlay = self.videoAutoPlay;
    vc.videoMuted = self.videoMuted;
    vc.videoDetailPageVideoMuted = self.videoDetailPageVideoMuted;
    vc.adCount = self.adCount;
    vc.useToken = self.useToken;
    vc.token = self.token;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

- (NSArray *)getAdvTypeTextArray {
    return @[@[@"DEFAULT",@"8098661343873537"]];
}

- (void)jumpToAnotherView{
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    NativeExpressVideoConfigView *nativeExpressVideoConfigView = [[NativeExpressVideoConfigView alloc]
                                                                     initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
                                                                     minVideoDuration:self.minVideoDuration
                                                                     maxVideoDuration:self.maxVideoDuration
                                                                     videoAutoPlay:self.videoAutoPlay
                                                                     videoMuted:self.videoMuted
                                                                     videoDetailPlageMuted:self.videoDetailPageVideoMuted];
    __weak typeof(self) _weakSelf = self;
    nativeExpressVideoConfigView.placementId = self.textField.text.length > 0? self.textField.text: self.textField.placeholder;
    nativeExpressVideoConfigView.widthSlider.value = self.widthSliderValue;
    nativeExpressVideoConfigView.heightSlider.value = self.heightSliderValue;
    nativeExpressVideoConfigView.widthSlider.enabled = NO;
    nativeExpressVideoConfigView.heightSlider.enabled = NO;
    nativeExpressVideoConfigView.adCountSlider.value = self.adCount;
    nativeExpressVideoConfigView.useTokenSwitch.on = self.useToken;
    nativeExpressVideoConfigView.tokenLabel.text = self.token;
    nativeExpressVideoConfigView.callBackBlock = ^(float widthSliderValue,
                                                      float heightSliderValue,
                                                      float adCountSliderValue,
                                                      BOOL navigationRightButtonIsenabled,
                                                      float minVideoDuration,
                                                      float maxVideoDuration,
                                                      BOOL videoAutoPlay,
                                                      BOOL videoMuted,
                                                      BOOL videoDetailPageVideoMuted) {
        [self.navigationItem.rightBarButtonItem setEnabled:navigationRightButtonIsenabled];
        _weakSelf.minVideoDuration = minVideoDuration;
        _weakSelf.maxVideoDuration = maxVideoDuration;
        _weakSelf.videoAutoPlay = videoAutoPlay;
        _weakSelf.videoMuted = videoMuted;
        _weakSelf.videoDetailPageVideoMuted = videoDetailPageVideoMuted;
        _weakSelf.adCount = adCountSliderValue;
    };
    nativeExpressVideoConfigView.tokenBlock = ^(BOOL useToken, NSString * _Nonnull token) {
        _weakSelf.useToken = useToken;
        _weakSelf.token = token;
    };
    [nativeExpressVideoConfigView showInView:self.view];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
