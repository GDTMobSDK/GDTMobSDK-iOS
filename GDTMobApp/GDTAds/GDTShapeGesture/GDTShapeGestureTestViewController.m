//
//  GDTShapeGestureTestViewController.m
//  GDTMobApp
//
//  Created by nimomeng on 2022/3/4.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import "GDTShapeGestureTestViewController.h"
#import "GDTShapeGestureRecognizerManager.h"
#import <AudioToolbox/AudioServices.h>

@interface GDTShapeGestureTestViewController ()
@property (weak, nonatomic) IBOutlet UILabel *tolerantValue;
@property (weak, nonatomic) IBOutlet UIView *testView;
@property (nonatomic,strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) NSMutableArray<NSValue *> *trajectoryPoints;
@property (weak, nonatomic) IBOutlet UILabel *decideResult;
@property (weak, nonatomic) IBOutlet UISlider *tolerantSliderBar;
@property (nonatomic, strong) CAShapeLayer *trajectoryLayer;
@property (nonatomic, strong) UIBezierPath *trajectoryPath;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UITextView *targetArrayInputArea;
@property (weak, nonatomic) IBOutlet UILabel *selectedTargetShapDescription;
@property (nonatomic, strong) UIAlertController *changeShapeController;
@property (nonatomic, assign) NSInteger strictRecognizeMode;// 严格模式 目前建议线性形状填0，闭合形状填1
@end

@implementation GDTShapeGestureTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tolerantSliderBar addTarget:self action:@selector(tolerantSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.trajectoryPath = [UIBezierPath bezierPath];
    self.trajectoryPoints = [NSMutableArray array];
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandler:)];
    self.panGesture.maximumNumberOfTouches = 1;
    self.strictRecognizeMode = 0;
    [self.testView addGestureRecognizer:self.panGesture];
    self.trajectoryLayer = ({
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.lineWidth = 5;
        layer.lineCap = kCALineCapRound;
        layer.lineJoin = kCALineJoinRound;
        layer.fillColor = NULL;
        layer.strokeColor = UIColor.grayColor.CGColor;
        layer;
    });
    [self.testView.layer addSublayer:self.trajectoryLayer];
    self.targetArrayInputArea.editable = NO;
    self.targetArrayInputArea.text = @"请点击顶部按钮选择要识别的形状";
    self.targetArrayInputArea.layer.borderWidth = 1.0;
    self.targetArrayInputArea.layer.borderColor = [UIColor blackColor].CGColor;
    [self.targetArrayInputArea.layer setMasksToBounds:YES];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)selectTargetShape:(id)sender {
    self.changeShapeController = [UIAlertController alertControllerWithTitle:@"选择要识别的锚点形状" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    if (self.changeShapeController.popoverPresentationController) {
        [self.changeShapeController.popoverPresentationController setPermittedArrowDirections:0];//去掉arrow箭头
        self.changeShapeController.popoverPresentationController.sourceView=self.view;
        self.changeShapeController.popoverPresentationController.sourceRect=CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height);
    }
    UIAlertAction *leftToRightAction = [UIAlertAction actionWithTitle:@"从左往右" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.selectedTargetShapDescription.text = @"从左往右";
        self.targetArrayInputArea.text = @"0_0|1_0";
        self.targetArrayInputArea.editable = NO;
        self.strictRecognizeMode = 0;
    }];
    [self.changeShapeController addAction:leftToRightAction];
    
    UIAlertAction *bottomToUpAction = [UIAlertAction actionWithTitle:@"从下往上" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.selectedTargetShapDescription.text = @"从下往上";
        self.targetArrayInputArea.text = @"0_1|0_0";
        self.targetArrayInputArea.editable = NO;
        self.strictRecognizeMode = 0;
    }];
    [self.changeShapeController addAction:bottomToUpAction];
    
    UIAlertAction *circleAction = [UIAlertAction actionWithTitle:@"画个圈圈" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.selectedTargetShapDescription.text = @"画个圈圈";
        self.targetArrayInputArea.editable = NO;
        self.targetArrayInputArea.text = @"0_-2|2_0|0_2|-2_0|0_-2";
        self.strictRecognizeMode = 1;
    }];
    [self.changeShapeController addAction:circleAction];
    
    UIAlertAction *triangleAction = [UIAlertAction actionWithTitle:@"画个正方形" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.selectedTargetShapDescription.text = @"正方形";
        self.targetArrayInputArea.text = @"0_0|2_0|2_2|0_2|0_0";
        self.targetArrayInputArea.editable = NO;
        self.strictRecognizeMode = 1;
    }];
    [self.changeShapeController addAction:triangleAction];
    
    UIAlertAction *customAction = [UIAlertAction actionWithTitle:@"自定义" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.selectedTargetShapDescription.text = @"自定义";
        self.targetArrayInputArea.text = @"请输入点串（x1_y1|x2_y2|x3_y3）";
        self.targetArrayInputArea.editable = YES;
        self.strictRecognizeMode = 1;
    }];
    [self.changeShapeController addAction:customAction];
    
    [self presentViewController:self.changeShapeController animated:YES completion:^{ [self clickBackToMainView];}];
}

- (void)clickBackToMainView {
    NSArray *arrayViews = [UIApplication sharedApplication].keyWindow.subviews;
    UIView *backToMainView = [[UIView alloc] init];
    for (int i = 1; i < arrayViews.count; i++) {
        NSString *viewNameStr = [NSString stringWithFormat:@"%s",object_getClassName(arrayViews[i])];
        if ([viewNameStr isEqualToString:@"UITransitionView"]) {
            backToMainView = [arrayViews[i] subviews][0];
            break;
        }
    }
    backToMainView.userInteractionEnabled = YES;
    UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTap)];
    [backToMainView addGestureRecognizer:backTap];
}

- (void)backTap {
    [self.changeShapeController dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)panGestureHandler:(UIPanGestureRecognizer *)panGesture
{
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        [self.trajectoryPoints removeAllObjects];
        [self.trajectoryPath removeAllPoints];
    } else {
        CGPoint point = [panGesture locationInView:self.testView];
        [self.trajectoryPoints addObject:@(point)];
        
        if (self.trajectoryPoints.count == 1) {
            [self.trajectoryPath moveToPoint:point];
        } else {
            [self.trajectoryPath addLineToPoint:point];
        }
        self.trajectoryLayer.path = self.trajectoryPath.CGPath;
        
        if (panGesture.state == UIGestureRecognizerStateEnded) {
            [self decide];
        }
    }
}

- (void)decide
{
    NSArray *targetPoints = [GDTShapeGestureRecognizerManager convertGesturePointsFromStringToArray:self.targetArrayInputArea.text];
    if (!self.panGesture.numberOfTouches && (self.trajectoryPoints.count == 0 ||
                                             targetPoints.count == 0)) {
        self.resultLabel.text = @"点串解析失败";
        return;
    }
    
    double similarity = [GDTShapeGestureRecognizerManager recognizeGestureWithSourceArray:self.trajectoryPoints targetArray:targetPoints strictRecognizeMode:self.strictRecognizeMode];
    self.decideResult.text = [NSString stringWithFormat:@"%f",similarity];
    
    if (similarity >= self.tolerantSliderBar.value) {
        self.resultLabel.text = @"识别成功";
        self.resultLabel.textColor = [UIColor greenColor];
        // 震动
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    } else {
        self.resultLabel.text = @"识别失败";
        self.resultLabel.textColor = [UIColor redColor];
    }
}

- (IBAction)tolerantSliderValueChanged:(UISlider *)sender
{
    self.tolerantValue.text = [NSString stringWithFormat:@"%.2f",sender.value];
}

@end
