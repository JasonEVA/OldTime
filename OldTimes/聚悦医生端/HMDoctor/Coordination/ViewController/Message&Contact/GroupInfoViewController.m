//
//  GroupInfoViewController.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/16.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "GroupInfoViewController.h"
#import "GroupInfoAdapter.h"
#import "ATModuleInteractor+CoordinationInteractor.h"
#import "GroupInfoHeaderTableViewCell.h"
#import "CoordinationPatientInfoCell.h"
#import "GroupInfoPatientInfoModel.h"
#import "GroupInfoHeaderModel.h"
#import "GetUserTeamCreateTimeAndServicePatientNumTask.h"
#import "TaskManager.h"
#import "UIViewController+Loading.h"
#import "StaffServiceInfoModel.h"
#import "GetOrgTeamServiceTask.h"
#import <MJExtension/MJExtension.h>
static NSInteger const ROW = 10; //每次请求固定的行数

@interface GroupInfoViewController ()<ATTableViewAdapterDelegate,GroupInfoAdapterDelegate,TaskObserver,MessageManagerDelegate>
@property (nonatomic, strong)  GroupInfoAdapter  *adapter; // <##>
@property (nonatomic, strong)  UITableView  *tableView; // <##>
@property(nonatomic, strong) StaffServiceInfoModel  *serviceInfoModel;
@property(nonatomic, assign) BOOL  isAllPatient;
@property(nonatomic, strong) NSMutableArray  *currentModelArray; //
@property(nonatomic, strong) NSMutableArray  *totalModelArray;
@property (nonatomic, strong)  UserProfileModel  *groupInfo; // <##>
@property (nonatomic) NSInteger patientInfoRequestCount;
@end

@implementation GroupInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"群名片"];
    self.patientInfoRequestCount = 0;
    [self configElements];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
#pragma mark - Interface Method

#pragma mark - Private Method

- (void)getServiceInfoRequeste
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    [dict setValue:@"ALL" forKey:@"orgGroupCode"];
    [dict setValue:self.groupID  forKey:@"imGroupId"];
    [[TaskManager shareInstance] createTaskWithTaskName:NSStringFromClass([GetUserTeamCreateTimeAndServicePatientNumTask class]) taskParam:dict TaskObserver:self];
    [self at_postLoading];
}

- (void)getPatientInfoRequest
{
    self.patientInfoRequestCount ++;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.groupID forKey:@"imGroupId"];
    [dict setValue:@(self.isAllPatient?0:1) forKey:@"type"];
//    [dict setValue:@(self.currentModelArray.count) forKey:@"startRow"];
//    [dict setValue:@(ROW) forKey:@"rows"];
    [[TaskManager shareInstance] createTaskWithTaskName:NSStringFromClass([GetOrgTeamServiceTask class]) taskParam:dict TaskObserver:self];
    [self at_postLoading];
}

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
    __weak typeof(self) weakSelf = self;
    [[MessageManager share] MTRequestGroupInfoWirhGroupId:self.groupID completion:^(UserProfileModel *model) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.groupInfo = model;
        
            [strongSelf.adapter.adapterArray replaceObjectAtIndex:0 withObject:@[strongSelf.groupInfo]];
            [strongSelf.tableView reloadData];
        
    }];
    
    self.currentModelArray = self.totalModelArray[0];
    self.adapter.adapterArray[1] = self.currentModelArray;

    // 获取数据
    [self getServiceInfoRequeste];

}

- (void)configPatientsList:(BOOL)allPatients {
    self.currentModelArray = self.totalModelArray[allPatients ? 1 : 0];
    self.adapter.adapterArray[1] = self.currentModelArray;
    [self.tableView reloadData];
}
#pragma mark - Event Response

#pragma mark - TaskObsever Delegate
- (void)task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    if (!errorMessage || !errorMessage.length) {
        return;
    }
    [self at_hideLoading];
    [self at_postError:errorMessage];
}

- (void)task:(NSString *)taskId Result:(id)taskResult
{
    [self at_hideLoading];

    if (!taskId || 0 == taskId.length){
        return;
    }
    NSString *taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length) {
        return;
    }
    
    if ([taskname isEqualToString:NSStringFromClass([GetUserTeamCreateTimeAndServicePatientNumTask class])])
    {
        self.serviceInfoModel = taskResult;
        self.adapter.serviceInfoModel = self.serviceInfoModel;
        [self.tableView reloadData];
        if (self.patientInfoRequestCount < 1) {
            [self getPatientInfoRequest];
        }
    }
    else if([taskname isEqualToString:NSStringFromClass([GetOrgTeamServiceTask class])])
    {
        if (self.isAllPatient)
        {
            [self.totalModelArray[1] addObjectsFromArray:taskResult];
            self.currentModelArray = self.totalModelArray[1];
        }
        else
        {
            [self.totalModelArray[0] addObjectsFromArray:taskResult];
            self.currentModelArray = self.totalModelArray[0];
        }
        self.adapter.adapterArray[1] = self.currentModelArray;
        [self.tableView reloadData];
    }
}

#pragma mark - ATTableViewAdapterDelegate

- (void)didSelectCellData:(id)cellData index:(NSIndexPath *)indexPath {

}

#pragma mark - MessageManagerDelegate

/**
 *  联系人、群信息改变刷新回调
 *
 *  联系人姓名、群成员增删等
 *
 *  @param userProfile
 */
- (void)MessageManagerDelegateCallBack_refreshContactProfileRefresh:(UserProfileModel *)userProfile {
    if (![userProfile.userName isEqualToString:self.groupID]) {
        return;
    }
    self.groupInfo = [[MessageManager share] queryContactProfileWithUid:self.groupID];
    [self.adapter.adapterArray replaceObjectAtIndex:0 withObject:@[self.groupInfo]];
    [self.tableView reloadData];
}
#pragma mark - GroupInfoAdapterDelegate

- (void)groupInfoAdapterDelegateCallBack_doctorClickedWithIndex:(NSInteger)index {
    UserProfileModel *model = [[MessageManager share] queryContactProfileWithUid:self.groupID];
    [[ATModuleInteractor sharedInstance] goDoctorDetailInfoWithRelationType:ContactRelationshipType_groupMember model:model.memberList[index]];
}

#pragma mark - Init
- (GroupInfoAdapter *)adapter {
    if (!_adapter) {
        _adapter = [GroupInfoAdapter new];
        _adapter.adapterDelegate = self;
        _adapter.doctorClickedDelegate = self;
        _adapter.adapterArray = [@[self.groupInfo ? @[self.groupInfo] : @[],@[]] mutableCopy];
        __weak typeof(self) weakSelf = self;
        [_adapter getTitleSelectIndexWithBlock:^(NSInteger index) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.isAllPatient = index;
            if (![self.totalModelArray[index] count])
            {
                [strongSelf getPatientInfoRequest];
            }
            else {
                [strongSelf configPatientsList:index];
            }
            [strongSelf getServiceInfoRequeste];
        }];
    }
    return _adapter;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self.adapter;
        _tableView.dataSource = self.adapter;
        [_tableView registerClass:[GroupInfoHeaderTableViewCell class] forCellReuseIdentifier:[GroupInfoHeaderTableViewCell at_identifier]];
        [_tableView registerClass:[CoordinationPatientInfoCell class] forCellReuseIdentifier:[CoordinationPatientInfoCell at_identifier]];

    }
    return _tableView;
}

- (NSMutableArray *)totalModelArray
{
    if (!_totalModelArray)
    {
        _totalModelArray = [NSMutableArray array];
        for (int i = 0 ; i < 2; i++)
        {
            NSMutableArray *tempArray = [NSMutableArray array];
            [_totalModelArray addObject:tempArray];
        }
    }
    return _totalModelArray;
}

@end
