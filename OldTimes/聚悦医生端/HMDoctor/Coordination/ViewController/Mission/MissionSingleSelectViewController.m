//
//  MissionSingleSelectViewController.m
//  HMDoctor
//
//  Created by jasonwang on 16/4/25.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "MissionSingleSelectViewController.h"

#import <Masonry/Masonry.h>
#import "SelectContactTabbarView.h"
#import "ContactsMainTableViewCell.h"
#import "CoordinationContactsManager.h"
#import "ContactInfoModel.h"


#import "GetStaffTeamsTask.h"
#import "CoordinationContactTableViewCell.h"
#import "ServiceGroupTeamInfoModel.h"
#import "ServiceGroupMemberModel.h"
#import "CoordinationContactsSelectAdapter.h"
#import "GetOrgTeamPatientsTask.h"
#import "PatientInfo.h"
#import "PatientInfo+SelectEX.h"

@interface MissionSingleSelectViewController()<ATTableViewAdapterDelegate,TaskObserver,CoordinationContactsSelectAdapterDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CoordinationContactsSelectAdapter *adapter;
@property (nonatomic, strong) SelectContactTabbarView *headSearchView;
@property (nonatomic, copy)  SelectPeopleHandler  completionHandler; // <##>
@property (nonatomic, strong)  MASConstraint  *headSearchViewHeight; // <##>

@property (nonatomic) BOOL patientSelect;
@property (nonatomic, copy)  NSArray  *selectedPeople; // <##>
@property (nonatomic, copy) NSString *teamIds; //团队ID集合
@end

@implementation MissionSingleSelectViewController

- (void)dealloc {
    [self.headSearchView removeObserver:self forKeyPath:@"arraySelect"];
}

- (instancetype)initWithSelectedPeople:(NSArray *)selectedPeople patientSelect:(BOOL)patientSelect
{
    self = [super init];
    if (self) {
        self.patientSelect = patientSelect;
        self.selectedPeople = selectedPeople;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.patientSelect ? @"选择用户" : @"选择参与者";
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
    [self.navigationItem setRightBarButtonItem:rightBtn];
    [self configElements];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)addSelectedPeopleNoti:(SelectPeopleHandler)completionHandler {
    self.completionHandler = completionHandler;
}

#pragma mark - private method

// 设置元素控件
- (void)configElements {
    // 设置约束
    [self configConstraints];

    // 设置数据
    [self configData];
    
}

// 设置数据
- (void)configData {
    
    self.patientSelect ? [self getPatientsList] : [self getStaffList];
    
    if (self.patientSelect) {
        __weak typeof(self) weakSelf = self;
        [self.headSearchView addTabbarViewDeleteContactNoti:^(id deleteModel) {
            [weakSelf.adapter deselectDataObject:deleteModel];
        }];
    }
    
    [self.headSearchView addObserver:self forKeyPath:@"arraySelect" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:nil];

}

// 设置约束
- (void)configConstraints {
    
    [self.view addSubview:self.tableView];
    if (self.patientSelect) {
        [self.view addSubview:self.headSearchView];
        [self.headSearchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.left.equalTo(self.view);
            self.headSearchViewHeight = make.height.mas_equalTo(0.5);
        }];
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.left.equalTo(self.view);
            make.top.equalTo(self.headSearchView.mas_bottom);
        }];
    } else {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }

}


// 获取参与者列表
- (void)getStaffList {
    UserInfo *info = [UserInfoHelper defaultHelper].currentUserInfo;

    NSDictionary *dictParam = @{
                                @"userId" : [NSString stringWithFormat:@"%ld",info.userId],
                                @"hasOwn" : @"1"
                                    };
    
    [[TaskManager shareInstance] createTaskWithTaskName:NSStringFromClass([GetStaffTeamsTask class]) taskParam:dictParam TaskObserver:self];
    [self at_postLoading];
    
}

// 获取患者列表
- (void)getPatientsList {
    
    if (self.staffID.length == 0 || !self.staffID) {
        return;
    }
    
    NSDictionary *dictParam = @{
                                @"staffId" : self.staffID
                                };
    
    [[TaskManager shareInstance] createTaskWithTaskName:NSStringFromClass([GetOrgTeamPatientsTask class]) taskParam:dictParam TaskObserver:self];
    [self at_postLoading];
}
#pragma mark - event Response

- (void)rightClick
{
    self.completionHandler(self.adapter.arraySelectedContacts,self.teamIds);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"arraySelect"]) {
        
        if (self.headSearchView.arraySelect.count == 0) {
            self.headSearchViewHeight.offset = 0.5;
        }
        else {
            self.headSearchViewHeight.offset = 55;
        }
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.24 animations:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.view layoutIfNeeded];
        }];
    }
}
#pragma mark - Delegate

#pragma mark - TableViewAdapter Delegate

- (void)didSelectCellData:(id)cellData index:(NSIndexPath *)indexPath {
    
    if ([cellData isKindOfClass:[ServiceGroupMemberModel class]]) {
        ServiceGroupMemberModel *model = (ServiceGroupMemberModel *)cellData;
        if (model.selected) {
            
        }
        else {
            
        }
    }
    else if ([cellData isKindOfClass:[PatientInfo class]]) {
        PatientInfo *model = (PatientInfo *)cellData;
        if (model.at_selected) {
            
        }
        else {
            
        }
    }
    [self.headSearchView configData:self.adapter.arraySelectedContacts];
}

- (void)coordinationContactsSelectAdapterDelegateCallBack_sectionSelectStateChangedWithChangedContacts:(NSArray *)changedContacts {
    [self.headSearchView configData:self.adapter.arraySelectedContacts];
}
#pragma mark - request Delegate

- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    if (taskError == StepError_None) {
        return;
    }
    [self at_postError:errorMessage];
}

- (void) task:(NSString *)taskId Result:(id) taskResult
{
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    
    if ([taskname isEqualToString:NSStringFromClass([GetStaffTeamsTask class])])
    {
        [self at_hideLoading];
        [self.adapter.sectionData removeAllObjects];
        [self.adapter.adapterArray removeAllObjects];
        NSMutableArray *temp = [NSMutableArray array];
        NSMutableArray *tempTeamIDs = [NSMutableArray array];

        for (ServiceGroupTeamInfoModel *model in taskResult) {
            [self.adapter.sectionData addObject:model.teamName];
//            [self.adapter.adapterArray addObject:model.orgTeamDet];
            [temp addObject:model.orgTeamDet];
            [tempTeamIDs addObject:[NSString stringWithFormat:@"%ld",(long)model.teamId]];
        }
        self.teamIds = [tempTeamIDs componentsJoinedByString:@","];
        [self.adapter configDataSource:temp];

        [self.tableView reloadData];
    }
    else if ([taskname isEqualToString:NSStringFromClass([GetOrgTeamPatientsTask class])]) {
        [self at_hideLoading];
        [self.adapter.sectionData removeAllObjects];
        [self.adapter.adapterArray removeAllObjects];
        NSMutableArray *temp = [NSMutableArray array];
        for (PatientGroupInfo *model in taskResult) {
            [self.adapter.sectionData addObject:model.teamName];
//            [self.adapter.adapterArray addObject:model.users];
            [temp addObject:model.users];
        }
        [self.adapter configDataSource:temp];
        [self.headSearchView addPeople:self.adapter.arraySelectedContacts];
        [self.tableView reloadData];

    }
    else {
        [self at_hideLoading];
    }
}

#pragma mark - Interface

#pragma mark - init UI

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self.adapter;
        _tableView.dataSource = self.adapter;
        _tableView.rowHeight = 60;
        [_tableView registerClass:[CoordinationContactTableViewCell class] forCellReuseIdentifier:[CoordinationContactTableViewCell at_identifier]];
    }
    return _tableView;
}

- (CoordinationContactsSelectAdapter *)adapter
{
    if (!_adapter) {
        _adapter = [[CoordinationContactsSelectAdapter alloc] initWithSelectType:!self.patientSelect ? ContactsSelectTypeSingleSelect : ContactsSelectTypeMutableSelect selectedContacts:self.selectedPeople nonSelectableContacts:nil];
        _adapter.adapterDelegate = self;
        _adapter.customDelegate = self;
        _adapter.tableView = self.tableView;
    }
    return _adapter;
}

- (SelectContactTabbarView *)headSearchView
{
    if (!_headSearchView) {
        _headSearchView = [SelectContactTabbarView new];
    }
    return _headSearchView;
}

@end
