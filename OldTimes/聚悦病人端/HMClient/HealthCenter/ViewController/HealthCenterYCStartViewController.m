//
//  HealthCenterStartViewController.m
//  HMClient
//
//  Created by yinqaun on 16/4/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HealthCenterYCStartViewController.h"
#import "ServiceTeamSystemReminderView.h"
#import "DoctorGreetingViewController.h"
#import "HealthCenterStartHeaderView.h"
#import "HealthCenterPlanTaskTableViewCell.h"
#import "HealthPlanSectionHeaderView.h"
#import "DateUtil.h"

@interface HealthCenterYCStartViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)  ServiceTeamSystemReminderView  *sysReminderView; // <##>
@property (nonatomic, strong)  UITableView  *tableView; // <##>
@property (nonatomic, strong)  HealthCenterStartHeaderView  *headerView; // <##>
@property (nonatomic, strong)  HealthPlanSectionHeaderView  *sectionHeaderView; // <##>
@end

@implementation HealthCenterYCStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"健康中心"];
    [self.navigationController.navigationBar setTranslucent:NO];
    self.edgesForExtendedLayout = UIRectEdgeNone;

    
    [self configElements];
    
    // 设置服务团队view
//    [self configServiceMemberView];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    DoctorGreetingViewController *VC = [DoctorGreetingViewController new];

    [self.view.window.rootViewController presentViewController:VC animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)configServiceMemberView {
    [self.view addSubview:self.sysReminderView];
    [self.sysReminderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(210);
    }];
}
- (ServiceTeamSystemReminderView *)sysReminderView {
    if (!_sysReminderView) {
        _sysReminderView = [[ServiceTeamSystemReminderView alloc] init];
    }
    return _sysReminderView;
}


#pragma mark - Interface Method

#pragma mark - Private Method

// 设置元素控件
- (void)configElements {
    
    // 设置数据
    [self configData];
    
    // 设置约束
    [self configConstraints];
}

// 设置约束
- (void)configConstraints {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

// 设置数据
- (void)configData {
}

#pragma mark - Event Response

#pragma mark - Delegate

#pragma mark - UITableView Delegate & DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 35;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return 0.01;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return self.sectionHeaderView;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView *line = [UIView new];
        line.backgroundColor = [UIColor groupTableViewBackgroundColor];
        return line;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 45;
    }
    static HealthCenterPlanTaskTableViewCell *templateCell;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        templateCell = [[HealthCenterPlanTaskTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[HealthCenterPlanTaskTableViewCell at_identifier]];
    });
    [templateCell configCellData:nil tail:YES testTime:8];
    CGFloat height = [templateCell.contentView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize].height;
    return MAX(45, height);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell0 = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell at_identifier] forIndexPath:indexPath];
        cell0.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell0.textLabel.font = [UIFont font_30];
        cell0.textLabel.textColor = [UIColor commonTextColor];
        [cell0.textLabel setText:@"健康计划"];
        return cell0;
    }
    
    HealthCenterPlanTaskTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:[HealthCenterPlanTaskTableViewCell at_identifier] forIndexPath:indexPath];
    [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell1 configCellData:nil tail:(indexPath.row == 9) testTime:8 + indexPath.row];
    return cell1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        // 健康计划
    }
    else {
        
    }
}


#pragma mark - Override

#pragma mark - Init

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.headerView;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:[UITableViewCell at_identifier]];
        [_tableView registerClass:[HealthCenterPlanTaskTableViewCell class] forCellReuseIdentifier:[HealthCenterPlanTaskTableViewCell at_identifier]];
        [_tableView setEstimatedRowHeight:45];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (HealthCenterStartHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[HealthCenterStartHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 145)];
    }
    return _headerView;
}


- (HealthPlanSectionHeaderView *)sectionHeaderView {
    if (!_sectionHeaderView) {
        _sectionHeaderView = [HealthPlanSectionHeaderView new];
        [_sectionHeaderView configSectionHeaderDataWithDate:[DateUtil stringDateWithDate:[NSDate date] dateFormat:@"MM-dd"] todayTaskCount:10 finishedTaskCount:7];
    }
    return _sectionHeaderView;
}
@end
