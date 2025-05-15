//
//  NativeExpressAdEntranceViewController.m
//  GDTMobApp
//
//  Created by nancynan on 2024/11/29.
//  Copyright © 2024 Tencent. All rights reserved.
//

#import "NativeExpressAdEntranceViewController.h"

@interface NativeExpressAdEntranceViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *demoArray;
@end

@implementation NativeExpressAdEntranceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.tableView.frame = self.view.bounds;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSArray *)demoArray {
    if (!_demoArray) {
        _demoArray = @[
            @[@"原生图文模板广告(优量汇渲染)", @"NativeExpressAdViewController"],
            @[@"原生视频模板广告(优量汇渲染)", @"NativeExpressVideoAdViewController"],
            @[@"原生沉浸式模板广告(优量汇渲染)", @"NativeFullExpressAdViewController"],
            @[@"原生模板广告简单接入(优量汇渲染)", @"NativeExpressAdNotInFeedViewController"],
        ];
    }
    
    return _demoArray;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.demoArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
    }
    cell.textLabel.text = self.demoArray[indexPath.row][0];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *vc = [[NSClassFromString([self.demoArray objectAtIndex:indexPath.row][1]) alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
