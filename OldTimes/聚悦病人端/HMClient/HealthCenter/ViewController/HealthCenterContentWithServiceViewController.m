//
//  HealthCenterContentWithServiceViewController.m
//  HMClient
//
//  Created by yinqaun on 16/6/7.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HealthCenterContentWithServiceViewController.h"
#import "HeathPlansTimeLineTableViewController.h"

@interface HealthCenterContentWithServiceHeaderView : UIControl
{
    
}
@end

@implementation HealthCenterContentWithServiceHeaderView

- (id) init
{
    self = [super init];
    if (self)
    {
        UILabel* lbPlan = [[UILabel alloc]init];
        [self addSubview:lbPlan];
        [lbPlan setText:@"健康计划"];
        [lbPlan setTextColor:[UIColor commonTextColor]];
        [lbPlan setFont:[UIFont font_30]];
        
        [lbPlan mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(12.5);
            make.centerY.equalTo(self);
        }];
        
        UIImageView* icArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_x_arrows"]];
        [self addSubview:icArrow];
        [icArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).with.offset(-12.5);
            make.size.mas_equalTo(CGSizeMake(7, 14));
        }];
        
        [self setBackgroundColor:[UIColor whiteColor]];
        [self showBottomLine];
    }
    return self;
}

@end

@interface HealthCenterContentWithServiceViewController ()
{
    HealthCenterContentWithServiceHeaderView* headerview;
    HeathPlansTimeLineTableViewController* tvcPlans;
}
@end

@implementation HealthCenterContentWithServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) createSubviews
{
    headerview = [[HealthCenterContentWithServiceHeaderView alloc]init];
    [self.view addSubview:headerview];
    [headerview addTarget:self action:@selector(headerviewClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [headerview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(@45);
    }];
    
    tvcPlans = [[HeathPlansTimeLineTableViewController alloc]initWithStyle:UITableViewStylePlain];
    [self addChildViewController:tvcPlans];
    [self.view addSubview:tvcPlans.tableView];
    [tvcPlans.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(headerview.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
}

- (void) headerviewClicked:(id) sender
{
    
    //跳转到健康计划界面
    [HMViewControllerManager createViewControllerWithControllerName:@"HealthPlanStartViewController" ControllerObject:nil];
}

@end
