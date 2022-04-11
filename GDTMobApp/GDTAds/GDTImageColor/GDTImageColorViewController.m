//
//  GDTImageColorViewController.m
//  GDTMobApp
//
//  Created by Andrew on 2022/3/24.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import "GDTImageColorViewController.h"
#import <Photos/Photos.h>
#import <UIKit/UIKit.h>
#import "UIColor+GDTImageColor.h"

@interface GDTImageColorViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray <GDTPaletteColorModel *> *colorData;
@property (nonatomic, strong) UIView *imageBView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UITextField *textField;
@end

@implementation GDTImageColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *chooseImageBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    chooseImageBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [chooseImageBtn setTitle:@"选择照片" forState:UIControlStateNormal];
    [chooseImageBtn addTarget:self action:@selector(goToChooseImage) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:chooseImageBtn];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[chooseImageBtn]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(chooseImageBtn)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[chooseImageBtn(50)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(chooseImageBtn)]];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    _textField.text = @"12544";
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    _textField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_textField];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-60-[_textField]-60-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_textField)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[chooseImageBtn]-10-[_textField(50)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_textField,chooseImageBtn)]];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.allowsSelection = NO;
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_tableView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_textField]-10-[_tableView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_textField,_tableView)]];
    // Do any additional setup after loading the view.
}

- (void)goToChooseImage {
    [_textField resignFirstResponder];
    __weak typeof (self) weakSelf = self;
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status != PHAuthorizationStatusDenied) {
                [weakSelf openChoice];
            }
        }];
    } else if ([PHPhotoLibrary authorizationStatus] != PHAuthorizationStatusDenied) {
        [weakSelf openChoice];
    }
    
}
- (void)openChoice {
    gdt_dispatch_async_on_main_queue(^{
        UIImagePickerController *vc = [[UIImagePickerController alloc] init];
        vc.delegate = self;
        [self presentViewController:vc animated:YES completion:^{
        }];
    });
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:@"UIImagePickerControllerMediaType"];
    if (![type isEqualToString:@"public.image"]){
        NSLog(@"请选择图片格式");
    }
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = w*9/16.0;
    if (!_imageView) {
        _imageBView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
        _imageBView.backgroundColor = [UIColor clearColor];
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, w*0.7, h*0.7)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_imageBView addSubview:_imageView];
        _imageView.center = _imageBView.center;
    }
    _imageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.tableView reloadData];
    
    __weak typeof (self) weakSelf = self;
    [UIColor gdt_getPaletteColorWithImage:_imageView.image resizeArea:_textField.text.intValue block:^(GDTPaletteColorModel * _Nullable recommendColor, NSArray<GDTPaletteColorModel *> * _Nullable allModeColors, NSError * _Nullable error) {

        weakSelf.colorData = allModeColors;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (_imageBView) {
            return 1;
        } else {
            return 0;
        }
    } else {
        return _colorData.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GDTTableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"GDTTableViewCell"];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
    }
    if (indexPath.section == 0) {
        [cell addSubview:_imageBView];
        cell.textLabel.text = nil;
        cell.detailTextLabel.text = nil;
        cell.backgroundColor = [UIColor gdt_getOptimizedColorWithColors:_colorData];
    } else {
        if (indexPath.row < _colorData.count) {
            GDTPaletteColorModel *model = [_colorData objectAtIndex:indexPath.row];
            cell.textLabel.text = model.modeName;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.3f H:%d S:%.3f L:%.3f",model.percentage,[model.hslData[0] intValue],[model.hslData[1] floatValue],[model.hslData[2] floatValue]];
            cell.backgroundColor = model.rgbColor ?: [UIColor whiteColor];
        }
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            return _imageBView.frame.size.height;
            break;
        }
        default:
            return _imageBView.frame.size.height/4.0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 60;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_textField resignFirstResponder];
    [super touchesBegan:touches withEvent:event];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_textField resignFirstResponder];
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
