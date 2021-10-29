//
//  AntiAddictionViewController.m
//  GDTMobApp
//
//  Created by rowanzhang on 2021/10/8.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "AntiAddictionViewController.h"
#import "GDTAntiAddictionManager.h"
#import "AntiAddictionParamsCell.h"

@interface AntiAddictionCostomParam : NSObject
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *value;
@end

@implementation AntiAddictionCostomParam
@end


@interface AntiAddictionViewController () <GDTAntiAddictionManagerDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) GDTAntiAddictionManager *antiAddictionManager;
@property (weak, nonatomic) IBOutlet UITableView *paramsTableView;
@property (nonatomic, strong) NSMutableArray<AntiAddictionCostomParam *> *costomParams;
@property (weak, nonatomic) IBOutlet UITextField *keyTextField;
@property (weak, nonatomic) IBOutlet UITextField *valueTextField;

@end

@implementation AntiAddictionViewController

- (IBAction)queryDeviceAntiAddictionState:(id)sender {
    [self.antiAddictionManager queryDeviceAntiAddictionState:[self ext]];
}

- (IBAction)submitIDCardInfo:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"实名认证" message:nil preferredStyle:UIAlertControllerStyleAlert];
    //增加确定按钮
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"姓名";
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"身份证号";
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    __weak typeof(alert) weakAlert = alert;
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        __strong typeof(weakAlert) strongAlert = weakAlert;
        NSString *name = strongAlert.textFields.firstObject.text;
        NSString *number = strongAlert.textFields.lastObject.text;
        
        [self.antiAddictionManager submitIDCardWithName:name number:number ext:[self ext]];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - GDTAntiAddictionManagerDelegate
- (void)manager:(GDTAntiAddictionManager *)manager didReceiveDeviceAntiAddictionState:(NSString *)state {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"设备防沉迷状态" message:state preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)manager:(GDTAntiAddictionManager *)manager didReceiveIDCardState:(NSString *)state {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"实名认证结果" message:state preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)manager:(GDTAntiAddictionManager *)manager interfaceFailure:(GDTAntiAddictionInterfaceIndex)index error:(NSError *)error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"出现错误" message:[NSString stringWithFormat:@"%@", error] preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}


- (IBAction)addCostomParam:(id)sender {
    if (self.keyTextField.text.length > 0 && self.valueTextField.text.length > 0) {
        AntiAddictionCostomParam *param = [AntiAddictionCostomParam new];
        param.key = self.keyTextField.text;
        param.value = self.valueTextField.text;
        for (AntiAddictionCostomParam *origin in self.costomParams) {
            if ([origin.key isEqualToString:param.key]) {
                [self.costomParams removeObject:origin];
                break;
            }
        }
        self.keyTextField.text = nil;
        self.valueTextField.text = nil;
        [self.costomParams addObject:param];
        [self.paramsTableView reloadData];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"key和value均有值才可以添加参数" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - textfield
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}

#pragma mark - tableview

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.costomParams removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.costomParams.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AntiAddictionParamsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AntiAddictionParamsCell"];
    if (!cell) {
        cell =  [[NSBundle mainBundle] loadNibNamed:@"AntiAddictionParamsCell" owner:self options:nil].firstObject;
    }
    cell.keyLabel.text = self.costomParams[indexPath.row].key;
    cell.valueLabel.text = self.costomParams[indexPath.row].value;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - getter setter

- (GDTAntiAddictionManager *)antiAddictionManager {
    if (!_antiAddictionManager) {
        _antiAddictionManager = [[GDTAntiAddictionManager alloc] init];
        _antiAddictionManager.delegate = self;
    }
    return _antiAddictionManager;
}

- (NSMutableArray<AntiAddictionCostomParam *> *)costomParams {
    if (!_costomParams) {
        _costomParams = [NSMutableArray array];
    }
    return _costomParams;
}

- (NSDictionary *)ext {
    if (self.costomParams.count > 0) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        for (AntiAddictionCostomParam *param in self.costomParams) {
            if (param.key.length > 0 && param.value.length > 0) {
                [dictionary setObject:param.value forKey:param.key];
            }
        }
        return [dictionary copy];
    }
    return nil;
}

@end
