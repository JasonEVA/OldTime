//
//  PersonServicesStartViewController.m
//  HMClient
//
//  Created by yinqaun on 16/6/28.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "PersonServicesStartViewController.h"
#import "HMSwitchView.h"
#import "PersonServiceTableViewCell.h"

#import "OrderedServiceListTableViewController.h"
#import "OrderedHistoryServicesTableViewController.h"

typedef enum : NSUInteger {
    PersonServices_Inservice,       //服务中
    PersonServices_History,         //订购历史
} PersonServicesSwitchIndex;




@interface PersonServicesStartViewController ()
<HMSwitchViewDelegate>
{
    HMSwitchView* switchview;
    UITabBarController* tabbarController;
    
    OrderedServiceListTableViewController* orderServiceListTableViewController;
    OrderedHistoryServicesTableViewController* orderServiceHistoryTableViewController;
}
@end

@implementation PersonServicesStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"我的服务"];
    
    
    switchview = [[HMSwitchView alloc]init];
    [switchview setDelegate:self];
    [self.view addSubview:switchview];
    [switchview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(@45);
    }];
    
    [switchview createCells:@[@"当前服务", @"订购历史"]];
    
    NSInteger defaultIndex = PersonServices_History;
    if (self.paramObject && [self.paramObject isKindOfClass:[NSNumber class]])
    {
        NSNumber* numIndex = (NSNumber*) self.paramObject;
        if (0 <= numIndex.integerValue && PersonServices_History >= numIndex.integerValue)
        {
            defaultIndex = numIndex.integerValue;
        }
    }
    
    [switchview setSelectedIndex:defaultIndex];
    
    tabbarController = [[UITabBarController alloc]initWithNibName:nil bundle:nil];
    [self addChildViewController:tabbarController];
    orderServiceListTableViewController = [[OrderedServiceListTableViewController alloc]initWithStyle:UITableViewStylePlain];
    [orderServiceListTableViewController acquireServiceStatus:^(BOOL isHaveService) {
        // 有服务显示右上角投诉按钮
        if (isHaveService) {
            UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"me_ic_ts-1"] style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
            [self.navigationItem setRightBarButtonItem:rightBtn];
        }
    }];
    orderServiceHistoryTableViewController = [[OrderedHistoryServicesTableViewController alloc]initWithStyle:UITableViewStylePlain];
    
    [tabbarController setViewControllers:@[orderServiceListTableViewController, orderServiceHistoryTableViewController]];
    
    [self.view addSubview:tabbarController.view];
    [tabbarController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(switchview.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    [tabbarController.tabBar setHidden:YES];
    
    
    [tabbarController setSelectedIndex:defaultIndex];
}

- (void)rightClick {
    // 服务投诉
    [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"我的-服务投诉"];
    [HMViewControllerManager createViewControllerWithControllerName:@"PersonServiceComplainViewController" ControllerObject:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) switchview:(HMSwitchView *)switchview SelectedIndex:(NSInteger)selectedIndex
{
    [tabbarController setSelectedIndex:selectedIndex];
}

@end
