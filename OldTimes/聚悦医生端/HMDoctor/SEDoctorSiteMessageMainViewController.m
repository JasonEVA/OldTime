//
//  SEDoctorSiteMessageMainViewController.m
//  HMDoctor
//
//  Created by jasonwang on 2017/9/11.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "SEDoctorSiteMessageMainViewController.h"
#import "NewSiteMessageMainListTableViewCell.h"
#import <MintcodeIMKit/MintcodeIMKit.h>
#import "SEDoctorSiteMessageItemViewController.h"

@interface SEDoctorSiteMessageMainViewController ()<UITableViewDelegate,UITableViewDataSource,TaskObserver>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataList;
@end

@implementation SEDoctorSiteMessageMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"站内信"];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    //将推送消息session标记已读，去除外面红点
    [[MessageManager share] sendReadedRequestWithUid:@"PUSH@SYS" messages:nil];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self startMainListRequest];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -private method
- (void)configElements {
}

- (void)startMainListRequest {
    NSMutableDictionary* dicPost = [[NSMutableDictionary alloc] init];
    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    [dicPost setValue:@(curUser.userId) forKey:@"userId"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"NewSiteMessageGetMainListRequest" taskParam:dicPost TaskObserver:self];
    [self.view showWaitView];
    
}
#pragma mark - event Response
- (void)rightClick {
    
}
#pragma mark - Delegate

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewSiteMessageMainListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NewSiteMessageMainListTableViewCell at_identifier]];
    [cell fillDataWithModel:self.dataList[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SEDoctorSiteMessageItemViewController *VC = [[SEDoctorSiteMessageItemViewController alloc] initWithSiteType:self.dataList[indexPath.row]];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.view closeWaitView];
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
    
    if ([taskname isEqualToString:@"NewSiteMessageGetMainListRequest"]) {
        NSArray *temp = (NSArray *)taskResult;
        self.dataList = temp;
        [self.tableView reloadData];
    }
    
}

#pragma mark - Interface

#pragma mark - init UI
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        _tableView.rowHeight = 75;
        [_tableView registerClass:[NewSiteMessageMainListTableViewCell class] forCellReuseIdentifier:[NewSiteMessageMainListTableViewCell at_identifier]];
        [_tableView setEstimatedSectionHeaderHeight:0];
        [_tableView setEstimatedSectionFooterHeight:0];
    }
    return _tableView;
}


@end
