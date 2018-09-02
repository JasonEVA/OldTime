//
//  NewMissionTeamMemberListViewController.m
//  HMDoctor
//
//  Created by jasonwang on 16/8/5.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "NewMissionTeamMemberListViewController.h"
#import "NewMissionGetTeamMemberRequest.h"
#import "ServiceGroupMemberModel.h"
#import "NewMissionTeamMemberTableViewCell.h"
#import "ATModuleInteractor+CoordinationInteractor.h"

@interface NewMissionTeamMemberListViewController ()<UITableViewDelegate,UITableViewDataSource,TaskObserver>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataList;
@end

@implementation NewMissionTeamMemberListViewController

- (instancetype)initWithTeamID:(NSString *)teamID {
    if (self = [super init]) {
        [self startGetTeamMemberRequestWithTeamID:teamID];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"所有成员"];
    [self configElements];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -private method
- (void)configElements {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)startGetTeamMemberRequestWithTeamID:(NSString *)teamID {
    if (!teamID) {
        return;
    }
    NSDictionary *dict = @{
                           @"teamId" : teamID
                           };
    [[TaskManager shareInstance] createTaskWithTaskName:NSStringFromClass([NewMissionGetTeamMemberRequest class]) taskParam:dict TaskObserver:self];
    [self at_postLoading];
}

#pragma mark - event Response

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"myCell";
    NewMissionTeamMemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[NewMissionTeamMemberTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell setSeparatorInset:UIEdgeInsetsZero];
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    
    ServiceGroupMemberModel *model = self.dataList[indexPath.row];
    [cell fillDataWithModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ServiceGroupMemberModel *model = self.dataList[indexPath.row];
    [[ATModuleInteractor sharedInstance] goDoctorDetailInfoWithRelationType:ContactRelationshipType_stranger model:model];
}
#pragma mark - request Delegate
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    if (taskError == StepError_None) {
        return;
    }
    
    [self at_hideLoading];
    [self.view closeWaitView];
    [self showAlertMessage:errorMessage];
}

- (void) task:(NSString *)taskId Result:(id) taskResult
{
    [self at_hideLoading];
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    if ([taskname isEqualToString:NSStringFromClass([NewMissionGetTeamMemberRequest class])]) {
        if ([taskResult isKindOfClass:[NSArray class]]) {
            // 配置列表
            self.dataList = taskResult;
        }
    }
        [self.tableView reloadData];
    
}

#pragma mark - Interface

#pragma mark - init UI

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60;
    }
    return _tableView;
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
