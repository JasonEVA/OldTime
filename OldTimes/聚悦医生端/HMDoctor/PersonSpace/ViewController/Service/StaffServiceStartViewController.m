//
//  StaffServiceStartViewController.m
//  HMDoctor
//
//  Created by yinqaun on 16/5/31.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "StaffServiceStartViewController.h"
#import "HMSwitchView.h"

@interface StaffServiceStartViewController ()
<HMSwitchViewDelegate>
{
    HMSwitchView* switchview;
    UITableViewController* tvcService;
}
@end

@implementation StaffServiceStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"我的服务"];
    
    switchview = [[HMSwitchView alloc]init];
    [self.view addSubview:switchview];
    [switchview createCells:@[@"服务套餐", @"订购记录"]];
    [switchview setDelegate:self];
    [switchview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(@50);
    }];
    
    [self createServiceTable:0];
}

- (NSString*) tableClassName:(NSInteger) index
{
    NSString* classname = @"UITableViewController";
    switch (index)
    {
        case 0:
        {
            classname = @"StaffServiceTableViewController";
        }
            break;
        case 1:
        {
            classname = @"StaffServiceHistoryTableViewController";
        }
            break;
        default:
            break;
    }
    return classname;
}

- (void) createServiceTable:(NSInteger) index
{
    NSString* classname = [self tableClassName:index];
    if (tvcService)
    {
        if ([NSStringFromClass([tvcService class]) isEqualToString:classname])
        {
            return;
        }
    }
    
    tvcService = [[NSClassFromString(classname) alloc]initWithStyle:UITableViewStylePlain];
    [self addChildViewController:tvcService];
    [self.view addSubview:tvcService.tableView];
    [tvcService.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(switchview.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - HMSwitchViewDelegate
- (void) switchview:(HMSwitchView*) switchview SelectedIndex:(NSUInteger) selectedIndex
{
    [[ActionStatusManager shareInstance] addActionStatusWithPageName:selectedIndex>0?@"订购记录":@"服务套餐"];
    [self createServiceTable:selectedIndex];
}

@end
