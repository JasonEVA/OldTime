//
//  HMSomeOneALLHistorySessionViewController.m
//  HMDoctor
//
//  Created by jasonwang on 2017/10/18.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMSomeOneALLHistorySessionViewController.h"
#import "NewPatientListInfoModel.h"
#import "HMHistoryChatViewController.h"
#import <MintcodeIMKit/MintcodeIMKit.h>

@interface HMSomeOneALLHistorySessionViewController ()<UITableViewDelegate,UITableViewDataSource,TaskObserver>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataList;
@property (nonatomic, strong) NewPatientListInfoModel *model;
@property (nonatomic) HMFEPatientListViewType type;
@end

@implementation HMSomeOneALLHistorySessionViewController

- (instancetype)initWithModel:(NewPatientListInfoModel *)model type:(HMFEPatientListViewType)type
{
    self = [super init];
    if (self) {
        self.model = model;
        self.type = type;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:self.model.userName];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self startGetSomeAllHistorySessionRequest];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -private method
- (void)configElements {
}
- (void)startGetSomeAllHistorySessionRequest {
    
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    
    StaffInfo* curStaff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    [dicPost setValue:[NSString stringWithFormat:@"%ld",(long)curStaff.staffId] forKey:@"staffId"];
    [dicPost setValue:[NSString stringWithFormat:@"%ld",self.model.userId] forKey:@"userId"];
    [dicPost setValue:@(self.type + 1) forKey:@"paymentType"];
    [dicPost setValue:@(1) forKey:@"pageNum"];
    [dicPost setValue:@(1000) forKey:@"pageSize"];
    
    
    [self at_postLoading];
    [[TaskManager shareInstance] createTaskWithTaskName:@"HMSomeOneAllHistorySessionRequest" taskParam:dicPost TaskObserver:self];
    
    
    /*
     ###
     // 医生团队 患者 历史 会话列表
     // paymentType 0 全部 1 个人免费 2 套餐 3 单次 4 集团套餐用户
     POST http://127.0.0.1:10018/uniqueComservice2/base.do?do=httpInterface&flag=2&module=workBenchPatientService&method=findStaffHistoryPatientSession HTTP/1.1
     Content-Type: application/json
     
     {
     "staffId": "3023819",
     "userId": "10755",
     "paymentType": 4,
     "pageNum": 1,
     "pageSize": 3
     }
     */
    
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
    NewPatientListInfoModel *model = self.dataList[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell at_identifier]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell.textLabel setText:model.teamName];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NewPatientListInfoModel *model = self.dataList[indexPath.row];
    
    
    [[MessageManager share] querySessionDataWithUid:model.imGroupId completion:^(ContactDetailModel *detailModel) {
        
        if (!detailModel && model.imGroupId) {
            detailModel = [[ContactDetailModel alloc] init];
            detailModel._target = model.imGroupId;
        }
        HMHistoryChatViewController *teamChatVC = [[HMHistoryChatViewController alloc] initMeaageListWithStrUid:model.imGroupId begainMsgid:0 endMsgid: -1];
        teamChatVC.IsGroup = [ContactDetailModel isGroupWithTarget:model.imGroupId];
        [teamChatVC setStrUid:model.imGroupId];
        [teamChatVC JWSetNavTitel:[NSString stringWithFormat:@"%@-%@",self.model.userName,model.teamName]];
        
        [self.navigationController pushViewController:teamChatVC animated:YES];
    }];
}

#pragma mark - request Delegate
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    if (StepError_None != taskError ) {
        [self at_hideLoading];
        [self showAlertMessage:errorMessage];
        return;
    }
    
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length) {
        return;
    }
}

- (void) task:(NSString *)taskId Result:(id)taskResult
{
    [self at_hideLoading];
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length) {
        return;
    }
    
    if ([taskname isEqualToString:@"HMSomeOneAllHistorySessionRequest"])
    {
        self.dataList = taskResult;
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
        [_tableView setRowHeight:50];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:[UITableViewCell at_identifier]];
        [_tableView setEstimatedSectionHeaderHeight:0];
        [_tableView setEstimatedSectionFooterHeight:0];
    }
    return _tableView;
}


@end
