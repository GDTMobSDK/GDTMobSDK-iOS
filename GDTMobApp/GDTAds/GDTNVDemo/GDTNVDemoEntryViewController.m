//
//  GDTNVDemoEntryViewController.m
//  GDTMobApp
//
//  Created by zhangzilong on 2021/12/21.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "GDTNVDemoEntryViewController.h"
#import "GDTScanViewController.h"
#import "GDTNVDemoViewController.h"
#import "GDTNVDemoManager.h"

@interface GDTNVDemoEntryViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *templateTableView;
@property (weak, nonatomic) IBOutlet UITableView *dataTableView;

@property (nonatomic, copy) NSArray *templates;
@property (nonatomic, copy) NSArray *datas;

@end

@implementation GDTNVDemoEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.dataTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.templateTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self reload];
}

- (IBAction)handleScan:(id)sender {
    GDTScanViewController *vc = [[GDTScanViewController alloc] init];
    __weak __typeof(self) ws = self;
    vc.backBlock = ^{
        [ws reload];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)handleReload:(id)sender {
    [self reload];
}

- (IBAction)handleShow:(id)sender {
    GDTNVDemoViewController *vc = [GDTNVDemoViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)reload {
    [GDTNVDemoManager loadLocalFile:[GDTNVDemoManager fileUrl] completion:^(NSDictionary * _Nonnull data) {
        self.templates = data[@"data"];
        [self.templateTableView reloadData];
    }];
    [GDTNVDemoManager loadLocalFile:[GDTNVDemoManager dataUrl] completion:^(NSArray * _Nonnull data) {
        self.datas = data;
        [self.dataTableView reloadData];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (tableView == self.templateTableView) {
        cell.textLabel.text = self.templates[indexPath.row];
        if ([cell.textLabel.text isEqualToString:GDTNVDemoManager.selectedTemplate]) {
            cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
        } else {
            cell.backgroundColor = [UIColor whiteColor];
        }
    } else {
        cell.textLabel.text = self.datas[indexPath.row];
        if ([cell.textLabel.text isEqualToString:GDTNVDemoManager.selectedData]) {
            cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
        } else {
            cell.backgroundColor = [UIColor whiteColor];
        }
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.templateTableView) {
        return self.templates.count;
    } else {
        return self.datas.count;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.templateTableView) {
        GDTNVDemoManager.selectedTemplate = self.templates[indexPath.row];
    } else {
        GDTNVDemoManager.selectedData = self.datas[indexPath.row];
    }
    [tableView reloadData];
}

@end
