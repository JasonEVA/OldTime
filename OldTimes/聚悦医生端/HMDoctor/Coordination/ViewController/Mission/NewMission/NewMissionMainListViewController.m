//
//  NewMissionMainListViewController.m
//  HMDoctor
//
//  Created by jasonwang on 16/8/3.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "NewMissionMainListViewController.h"
#import "NewMissionMainListAdapter.h"
#import "MissionDetailModel.h"
#import "TaskTypeTitleAndCountModel.h"
#import "GetTaskTypePageListTask.h"
#import "MissionListModel.h"
#import "NewMissionMainListTableViewCell.h"
#import "ATModuleInteractor+MissionInteractor.h"
#import "NewMissionGetTeamTaskListRequest.h"
#import "NewMissionGroupModel.h"

@interface NewMissionMainListViewController ()<ATTableViewAdapterDelegate,TaskObserver>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NewMissionMainListAdapter *adapter;
@property (nonatomic, strong) id model;
@property(nonatomic, strong) UIView  *emptyPageView;   //空白页
@property (nonatomic) BOOL isFromTeam;
@end

@implementation NewMissionMainListViewController

- (instancetype)initWithTeamModel:(NewMissionGroupModel *)model {
    if (self = [super init]) {
        [self.navigationItem setTitle:model.teamName];
        self.model = model;
        UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Mission_chengyuan"] style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
        [self.navigationItem setRightBarButtonItem:rightBtn];

    }
    return self;

}
- (instancetype)initWithTypeModel:(TaskTypeTitleAndCountModel *)model {
    if (self = [super init]) {
        [self.navigationItem setTitle:model.tabName];
        self.model = model;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([self.model isKindOfClass:[NewMissionGroupModel class]]) {
        [self requestWithTeamModel:self.model];
    }
    else if([self.model isKindOfClass:[TaskTypeTitleAndCountModel class]]){
        [self requestTypeTaskListWithTypeData:self.model];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.emptyPageView];
    [self.view addSubview:self.tableView];
    [self configElements];
        // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -private method
- (void)configElements {
    [self.emptyPageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
// 请求某服务群的任务列表
- (void)requestWithTeamModel:(NewMissionGroupModel *)model {
    if (!model) {
        return;
    }
    UserInfo *info = [UserInfoHelper defaultHelper].currentUserInfo;
    NSDictionary *dict = @{
                           @"userId" : [NSString stringWithFormat:@"%ld",info.userId],
                           @"teamId" : model.teamId,
                           @"pageSize":@100,
                           @"pageIndex":@1
                           };
    [[TaskManager shareInstance] createTaskWithTaskName:NSStringFromClass([NewMissionGetTeamTaskListRequest class]) taskParam:dict TaskObserver:self];
    [self at_postLoading];

}
// 请求某类型任务列表
- (void)requestTypeTaskListWithTypeData:(TaskTypeTitleAndCountModel *)model {
    if (!model) {
        return;
    }
    UserInfo *info = [UserInfoHelper defaultHelper].currentUserInfo;
    NSDictionary *dict = @{
                           @"userId" : [NSString stringWithFormat:@"%ld",info.userId],
                           @"tabInd" : [NSString stringWithFormat:@"%ld",model.tabInd]
                           };
    [[TaskManager shareInstance] createTaskWithTaskName:NSStringFromClass([GetTaskTypePageListTask class]) taskParam:dict TaskObserver:self];
    [self at_postLoading];
}
// 配置任务列表
- (void)configTaskListDataWithListData:(MissionListModel *)model {
    [self.adapter.adapterArray removeAllObjects];
    if (model.history) {
        [self.adapter.adapterArray addObject:model.history];
        self.adapter.headViewTitelArr = [@[@"已过期",@"待执行"] mutableCopy];
    }
    if (self.isFromTeam) {
        for (MissionDetailModel *missionModel in model.records) {
            missionModel.isFromTeam = YES;
        }
    }
        [self.adapter.adapterArray addObject:model.records];
//    if (self.adapter.arrayButtons.count > 0) {
//        [self.adapter.arrayButtons[0] selectButton].selected = NO;
//    }
    [self.tableView reloadData];
    
    self.tableView.hidden = ![self judgementWithArray:self.adapter.adapterArray];
    self.emptyPageView.hidden = !self.tableView.hidden;
}

- (BOOL)judgementWithArray:(NSArray *)array {
    
    //对应二维的情况
    if (array.count == 2){
        for (NSArray *object in array){
            if (object.count > 0) {
                return YES;
            }
            else {
                continue;
            }
            return NO;
        }
    }
    //对应一维的情况
    NSArray *arr = array.firstObject;
    return arr.count;
}
#pragma mark - event Response
- (void)rightClick {
    if ([self.model isKindOfClass:[NewMissionGroupModel class]]) {
        [[ATModuleInteractor sharedInstance] goToTeamMemberListVCWithTeamID:[self.model teamId]];
    }

}
#pragma mark - Delegate

#pragma mark - UITableViewDelegate
- (void)didSelectCellData:(id)cellData index:(NSIndexPath *)indexPath
{
    [[ATModuleInteractor sharedInstance] goToMissionDetailVCWithModel:(MissionDetailModel *)cellData];
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
    if ([taskname isEqualToString:NSStringFromClass([GetTaskTypePageListTask class])]) {
        if ([taskResult isKindOfClass:[MissionListModel class]]) {
            // 配置列表
            [self configTaskListDataWithListData:taskResult];
        }
    }
    else if ([taskname isEqualToString:NSStringFromClass([NewMissionGetTeamTaskListRequest class])]) {
        if ([taskResult isKindOfClass:[MissionListModel class]]) {
            // 配置列表
            self.isFromTeam = YES;
            [self configTaskListDataWithListData:taskResult];
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
        _tableView.delegate = self.adapter;
        _tableView.dataSource = self.adapter;
        _tableView.rowHeight = 70;
        [_tableView registerClass:[NewMissionMainListTableViewCell class] forCellReuseIdentifier:[NewMissionMainListTableViewCell at_identifier]];
    }
    return _tableView;
}

- (NewMissionMainListAdapter *)adapter
{
    if (!_adapter) {
        _adapter = [NewMissionMainListAdapter new];
        _adapter.adapterDelegate = self;
        _adapter.tableView = self.tableView;
//        _adapter.adapterArray = [@[@[[MissionDetailModel new]],@[[MissionDetailModel new],[MissionDetailModel new],[MissionDetailModel new],[MissionDetailModel new]]] mutableCopy];
    }
    return _adapter;
}

- (UIView *)emptyPageView
{
    if (!_emptyPageView) {
        _emptyPageView = [[UIView alloc] init];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"empty_nounfinishjob"]];
        UILabel *titel = [[UILabel alloc]init];
        [titel setText:@"赞！没有未完成的任务"];
        [titel setTextColor:[UIColor commonBlueColor]];
        [_emptyPageView addSubview:imageView];
        [_emptyPageView addSubview:titel];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_emptyPageView).offset(15);
            make.bottom.equalTo(_emptyPageView.mas_centerY);
        }];
        [titel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_emptyPageView);
            make.top.equalTo(_emptyPageView.mas_centerY).offset(20);
        }];
    }
    return _emptyPageView;
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
