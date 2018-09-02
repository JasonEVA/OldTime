//
//  AppointmentNoTimesViewController.m
//  HMClient
//
//  Created by yinquan on 2017/10/18.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "AppointmentNoTimesViewController.h"
#import "RecentlyAppointmentsTableViewController.h"

@interface AppointmentNoTimesViewController ()

@property (nonatomic, strong) UIView* headerView;
@property (nonatomic, strong) UILabel* headerLabel;
@property (nonatomic, strong) UITableViewController* resentlyAppointedStaffTableViewController;     //最近预约过的医生列表

@property (nonatomic, strong) UIView* lineView;
@property (nonatomic, strong) UILabel* moreServiceLabel;
@property (nonatomic, strong) UIButton* moreServiceButton;

@end

@implementation AppointmentNoTimesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"约专家";
    [self layoutElements];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) layoutElements{
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(@38.5);
    }];
    
    [self.headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headerView);
        make.left.equalTo(self.headerView).offset(12.5);
    }];
    
    [self.resentlyAppointedStaffTableViewController.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.headerView.mas_bottom);
        make.height.mas_equalTo(@242);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(@0.5);
        make.top.equalTo(self.resentlyAppointedStaffTableViewController.tableView.mas_bottom);
        
    }];
    
    [self.moreServiceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(12.5);
        make.top.equalTo(self.resentlyAppointedStaffTableViewController.tableView.mas_bottom).offset(19);
    }];
    
    [self.moreServiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view).offset(-30);
        make.height.mas_equalTo(@45);
        make.top.equalTo(self.moreServiceLabel.mas_bottom).offset(17);
    }];
}
#pragma mark - settingAndGetting
- (UIView*) headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        [self.view addSubview:_headerView];
        [_headerView setBackgroundColor:[UIColor whiteColor]];
        [_headerView showBottomLine];
    }
    return _headerView;
}

- (UILabel*) headerLabel
{
    if (!_headerLabel) {
        _headerLabel = [[UILabel alloc] init];
        [self.view addSubview:_headerLabel];
        [_headerLabel setTextColor:[UIColor commonRedColor]];
        [_headerLabel setFont:[UIFont font_28]];
        [_headerLabel setText:@"没有可以预约的医生了！您曾预约过的医生："];
    }
    
    return _headerLabel;
}

- (UITableViewController*) resentlyAppointedStaffTableViewController{
    if (!_resentlyAppointedStaffTableViewController) {
        _resentlyAppointedStaffTableViewController = [[RecentlyAppointmentsTableViewController alloc] initWithStyle:UITableViewStylePlain];
        [self addChildViewController: _resentlyAppointedStaffTableViewController];
        [self.view addSubview:_resentlyAppointedStaffTableViewController.tableView];
        
    }
    return _resentlyAppointedStaffTableViewController;
}

- (UIView*) lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        [self.view addSubview:_lineView];
        [_lineView setBackgroundColor:[UIColor commonControlBorderColor]];
    }
    return _lineView;
}

- (UILabel*) moreServiceLabel
{
    if (!_moreServiceLabel) {
        _moreServiceLabel = [[UILabel alloc] init];
        [self.view addSubview:_moreServiceLabel];
        [_moreServiceLabel setTextColor:[UIColor commonGrayTextColor]];
        [_moreServiceLabel setFont:[UIFont font_24]];
        [_moreServiceLabel setText:@"没有想预约的专家？\n前往聚悦服务，查看更多约诊服务。"];
        [_moreServiceLabel setNumberOfLines:2];
    }
    
    return _moreServiceLabel;
}

- (UIButton*) moreServiceButton{
    if(!_moreServiceButton)
    {
        _moreServiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:_moreServiceButton];
        [_moreServiceButton setBackgroundImage:[UIImage rectImage:CGSizeMake(320, 44) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
        [_moreServiceButton setTitle:@"约诊服务" forState:UIControlStateNormal];
        [_moreServiceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_moreServiceButton.titleLabel setFont:[UIFont font_30]];
        
        _moreServiceButton.layer.cornerRadius = 2.5;
        _moreServiceButton.layer.masksToBounds = YES;
        [_moreServiceButton addTarget:self action:@selector(moreServiceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _moreServiceButton;
}

#pragma mark - button event
- (void) moreServiceButtonClicked:(id) sender{
    //跳转到购买套餐界面
    [HMViewControllerManager createViewControllerWithControllerName:@"AppointmentServiceListViewController" ControllerObject:nil];
}
@end
