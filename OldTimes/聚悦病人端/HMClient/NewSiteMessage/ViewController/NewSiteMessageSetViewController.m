//
//  NewSiteMessageSetViewController.m
//  HMClient
//
//  Created by jasonwang on 2017/3/2.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "NewSiteMessageSetViewController.h"
#import "NewSiteMessageMainListTableViewCell.h"
#import "SiteMessageSecondEditionMainListModel.h"

@interface NewSiteMessageSetViewController ()<UITableViewDelegate,UITableViewDataSource,TaskObserver>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SiteMessageSecondEditionMainListModel *model;
@property (nonatomic, strong) UISwitch *switchView;
@property (nonatomic, strong) UILabel *subLb;
@end

@implementation NewSiteMessageSetViewController

- (instancetype)initWithModel:(SiteMessageSecondEditionMainListModel *)model {
    if (self = [super init]) {
        self.model = model;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提醒设置";
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -private method
- (void)configElements {
    
}

- (void)startRemindRequest {
    NSMutableDictionary* dicPost = [[NSMutableDictionary alloc] init];
    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    [dicPost setValue:@(curUser.userId) forKey:@"userId"];
    NSArray *array = @[@{@"typeCode":self.model.typeCode,@"status":@(!self.model.status)}];
    [dicPost setValue:array forKey:@"patientMsgStatusList"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"NewSiteMessagechangeRemindStatusRequest" taskParam:dicPost TaskObserver:self];
}
#pragma mark - event Response
- (void)switchClick:(UISwitch *)sender {
    [self.view showWaitView];
    [self performSelector:@selector(startRemindRequest) withObject:nil afterDelay:1.0f];
}
#pragma mark - Delegate

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell at_identifier]];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[UITableViewCell at_identifier]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setSeparatorInset:UIEdgeInsetsZero];
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        [cell.textLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [cell.textLabel setFont:[UIFont font_30]];

        [cell.detailTextLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
        [cell.detailTextLabel setFont:[UIFont font_28]];
        [cell setAccessoryView:self.switchView];
    }
    [cell.textLabel setText:@"通知栏提醒"];
    [cell.detailTextLabel setText:self.model.status ? @"打开":@"关闭"];
    self.subLb = cell.detailTextLabel;
    [self.switchView setOn:self.model.status];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

#pragma mark - request Delegate
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.view closeWaitView];
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    
    if (taskname && [taskname isEqualToString:@"NewSiteMessagechangeRemindStatusRequest"]) {
        [self.tableView reloadData];
    }

    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
    
    
    
}

- (void) task:(NSString *)taskId Result:(id)taskResult
{
    [self.view closeWaitView];

    if (!taskId || 0 == taskId.length) {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length) {
        return;
    }
    
    if ([taskname isEqualToString:@"NewSiteMessagechangeRemindStatusRequest"]) {
        SiteMessageSecondEditionMainListModel *model = [(NSArray *)taskResult firstObject];
        self.model.status = model.status;
        [self.tableView reloadData];
    }
    
}

#pragma mark - Interface

#pragma mark - init UI
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setBackgroundColor:[UIColor colorWithHexString:@"f0f0f0"]];
        [_tableView setEstimatedSectionHeaderHeight:0];
        [_tableView setEstimatedSectionFooterHeight:0];
        _tableView.rowHeight = 75;
    }
    return _tableView;
}

- (UISwitch *)switchView {
    if (!_switchView) {
        _switchView = [[UISwitch alloc] init];
        [_switchView addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventValueChanged];
    }
    return _switchView;
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
