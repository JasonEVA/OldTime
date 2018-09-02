//
//  DealUserWarningViewController.m
//  HMDoctor
//
//  Created by lkl on 16/8/8.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "DealUserWarningViewController.h"
#import "DealUserAdjustWarningValueViewController.h"
#import "DealUserWarningTableViewCell.h"
#import "ATModuleInteractor+PatientChat.h"
#import "PatientInfo.h"
#import "DealUserAlertOtherwayView.h"
#import "DealUserAlertOtherWayViewController.h"

static NSString * const DealAlertNotification = @"isDeal";

typedef NS_ENUM(NSInteger,UserWarning){
    UserWarning_DoWay,
    UserWarning_Record,
    UserWarningMaxSectionCount,
};

@interface DealUserWarningViewController ()<UITableViewDelegate,UITableViewDataSource,TaskObserver>
{
    UserAlertInfo* alertInfo;
    NSArray *doWayArray;
    NSArray *doWayTypeArray;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *warningRecordArray;
@property (nonatomic, assign) NSInteger selectDoWayIndex;
@property (nonatomic, assign) BOOL isDeal;
@property (nonatomic, strong) DealUserAlertInfoView *alertView;
@property (nonatomic, copy) NSString *opinion;  //其他方式 处理建议
@end

@implementation DealUserWarningViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"预警处理"];
    
    if (self.paramObject && [self.paramObject isKindOfClass:[UserAlertInfo class]]) {
        alertInfo = (UserAlertInfo *)self.paramObject;
    }
    
    // 设置元素控件
    [self configElements];
    
    //获取要处理的预警信息
    [self.view showWaitView];
    NSMutableDictionary *dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:alertInfo.testResulId forKey:@"testResulId"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"GetWarningDetTask" taskParam:dicPost TaskObserver:self];
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

// 设置数据
- (void)configData {
    doWayArray = @[@"调整预警值",@"调整用药",@"继续监测",@"通知复诊",@"其他方式"];
    doWayTypeArray = @[@"TZYJZ",@"TZYY",@"JXJC",@"TZFZ",@"QTFS"];
    
    //获取最近三天的预警记录
    NSMutableDictionary *dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSString stringWithFormat:@"%ld",(long)alertInfo.userId] forKey:@"userId"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"UserWarningRecordTask" taskParam:dicPost TaskObserver:self];
}

// 设置约束
- (void)configConstraints {
    [self.view addSubview:self.alertView];
    [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(@65);
    }];
    
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.alertView.mas_bottom);
    }];
}


#pragma mark - Delegate


#pragma mark -- init
- (UITableView *)tableView{

    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_tableView setBackgroundColor:[UIColor colorWithHexString:@"EFF0F1"]];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
    }
    return _tableView;
}

- (NSArray *)warningRecordArray{

    if (!_warningRecordArray) {
        _warningRecordArray = [NSArray array];
    }
    return _warningRecordArray;
}

- (DealUserAlertInfoView *)alertView{
    if (!_alertView) {
        _alertView = [[DealUserAlertInfoView alloc] init];
    }
    return _alertView;
}

#pragma mark - UITableViewDataSource And Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return UserWarningMaxSectionCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (indexPath.section) {
        case UserWarning_DoWay:
            return 45;
            break;
                
        case UserWarning_Record:
            return 85;
            break;
                
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.tableHeaderView.width, tableView.tableHeaderView.height)];
    [headerView setBackgroundColor:[UIColor colorWithHexString:@"EFF0F1"]];
    UILabel *lbTitle = [[UILabel alloc] init];
    [headerView addSubview:lbTitle];
    [lbTitle setFont:[UIFont systemFontOfSize:14.0f]];
    [lbTitle setTextColor:[UIColor commonLightGrayTextColor]];

    [lbTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).with.offset(12);
        make.centerY.equalTo(headerView);
    }];
    
    UIView* cuttinglineView = [[UIView alloc] init];
    [headerView addSubview:cuttinglineView];
    [cuttinglineView setBackgroundColor:[UIColor whiteColor]];
    [cuttinglineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(headerView);
        make.height.mas_equalTo(@1);
        make.top.equalTo(headerView.mas_bottom).with.offset(-1);
    }];
    
    switch (section) {
        case UserWarning_DoWay:
        {
            [lbTitle setText:@"选择预警处理方式"];
            break;
        }
        case UserWarning_Record:
        {
            [lbTitle setText:[NSString stringWithFormat:@"用户【%@】最近的预警记录",alertInfo.userName]];
            if (!self.warningRecordArray || self.warningRecordArray.count <= 0) {

                [headerView setHidden:YES];
            }
            break;
        }
            
        default:
            break;
    }
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case UserWarning_DoWay:
            return doWayArray.count;
            break;
            
        case UserWarning_Record:
            return self.warningRecordArray.count;
            break;
            
        default:
            break;
    }
    return 0;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    switch (indexPath.section) {
        case UserWarning_DoWay:
        {
            SelectDealUserWarningTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SelectDealUserWarningTableViewCell"];
            if (!cell)
            {
                cell = [[SelectDealUserWarningTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SelectDealUserWarningTableViewCell"];
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            
            NSString *dowayStr = [doWayArray objectAtIndex:indexPath.row];
            [cell setNameTitle:dowayStr];
            return cell;
            break;
        }
            
        case UserWarning_Record:
        {
            DealUserWarningTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DealUserWarningTableViewCell"];
            if (!cell)
            {
                cell = [[DealUserWarningTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DealUserWarningTableViewCell"];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell setBackgroundColor:[UIColor colorWithHexString:@"EFF0F1"]];
            }
            
            UserWarningRecord *record = [self.warningRecordArray objectAtIndex:indexPath.row];
            [cell setWarningRecordInfo:record];
            
            return cell;
            break;
        }
        default:
            break;
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == UserWarning_DoWay) {
        
        if (_isDeal) {
            __weak typeof(self) weakSelf = self;
            [self showAlertMessage:@"您已处理过这条预警" clicked:^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf.navigationController popViewControllerAnimated:YES];
            }];
            return;
        }
        
        //如果选择其他方式，不再弹出提示框确认是否处理该预警 lkl 2017-09-12
        _selectDoWayIndex = indexPath.row;
        NSString *typeCode = [doWayTypeArray objectAtIndex:indexPath.row];
        if ([typeCode isEqualToString:@"QTFS"]) {
            [self checkAlertIsAppear];
            return;
        }
        
        //Add by YinQ at 2017-03-06
        //新需求，要求首先弹出提示框确认是否处理该预警
        NSString *typeMsg = [doWayArray objectAtIndex:indexPath.row];
        NSString* confirmMessage = [NSString stringWithFormat:@"确定选择\"%@\"的处理方式吗", typeMsg];
        __weak __typeof(self)weakSelf = self;
        __block BOOL cancelDeal = NO;
        [AlertUtil showAlert:confirmMessage alertConfirmButtonClickBlock:^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf checkAlertIsAppear];
            }
            [self checkAlertIsAppear];
        } alertCancelButtonClickBlock:^{
            cancelDeal =YES;
        }];
        
        if (cancelDeal)
        {
            //取消
            return;
        }
        //End of Add by YinQ
    }
}

- (void) checkAlertIsAppear
{
    NSMutableDictionary *dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSString stringWithFormat:@"%ld",(long)alertInfo.userId] forKey:@"userId"];
    
    NSString *type = [doWayTypeArray objectAtIndex:_selectDoWayIndex];
    [dicPost setValue:type forKey:@"type"];
    [dicPost setValue:alertInfo.kpiCode forKey:@"kpiCode"];
    
    [self.view showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"checkAlertIsAppearTask" taskParam:dicPost TaskObserver:self];
}

- (void) dealWarning:(NSInteger)index
{
    NSString *type = [doWayTypeArray objectAtIndex:index];
    if ([type isEqualToString:@"TZYY"])
    {
        //跳转患者处方
        BOOL prescribePrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeCreatePrescriptionMode Status:0xFF OperateCode:kPrivilegeProcessOperate];
        if(!prescribePrivilege)
        {
            [self showAlertMessage:@"对不起，您没有该权限。"];
            return;
        }
    }
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    
    [dicPost setValue:type forKey:@"type"];
    [dicPost setValue:[NSString stringWithFormat:@"%ld",(long)alertInfo.userId] forKey:@"userId"];
    [dicPost setValue:alertInfo.kpiCode forKey:@"kpiCode"];
    
    [dicPost setValue:[NSString stringWithFormat:@"%ld", (long)staff.userId] forKey:@"staffUserId"];
    [dicPost setValue:alertInfo.testResulId forKey:@"testResulId"];
    
    if ([type isEqualToString:@"QTFS"] && self.opinion) {
        [dicPost setValue:self.opinion forKey:@"opinion"];
    }
    [self.view showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"DealWarningTask" taskParam:dicPost TaskObserver:self];
}

//其他方式 处理预警
- (void)dealOtherWayWarning{
    DealUserAlertOtherWayViewController *otherWayVC = [[DealUserAlertOtherWayViewController alloc] initWithjumpToOtherWayVC:^(NSString *str) {
        self.opinion = str;
        [self dealWarning:_selectDoWayIndex];
    }];
    [self.view.window.rootViewController presentViewController:otherWayVC animated:NO completion:nil];
}

#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    [self.view closeWaitView];
    if (StepError_None != taskError) {
        [self showAlertMessage:errorMessage];
        return;
    }
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
    
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    
    if ([taskname isEqualToString:@"GetWarningDetTask"]) {
        if (taskResult && [taskResult isKindOfClass:[UserWarningDetInfo class]]) {
            
            UserWarningDetInfo *detInfo = taskResult;
            [self.alertView setUserAlertInfo:detInfo];
        }
    }
    
    if ([taskname isEqualToString:@"DealWarningTask"])
    {
        [self.view setBackgroundColor:[UIColor clearColor]];
        NSDictionary* dicParam = [TaskManager taskparamWithTaskId:taskId];
        NSString* doWayType = [dicParam valueForKey:@"type"];
        if (doWayType && [doWayType isKindOfClass:[NSString class]])
        {
            //说明：只要跳转到调整预警值、处方、IM界面，界面上暂且提示已处理过该条预警
            
            //从会话消息--预警提示框跳转处理预警，处理过后用通知让提示框消失
            [[NSNotificationCenter defaultCenter] postNotificationName:DealAlertNotification object:nil];

            
            if ([doWayType isEqualToString:@"TZYJZ"]){
                //跳转到调整预警值修改的列表
                [HMViewControllerManager createViewControllerWithControllerName:@"DealUserAdjustWarningValueViewController" ControllerObject:alertInfo];
            }
            else if ([doWayType isEqualToString:@"TZYY"]){
                //跳转患者处方
                BOOL prescribePrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeCreatePrescriptionMode Status:0xFF OperateCode:kPrivilegeProcessOperate];
                if(!prescribePrivilege)
                {
                    [self showAlertMessage:@"对不起，您没有修改权限。"];
                    return;
                }
                
                [HMViewControllerManager createViewControllerWithControllerName:@"PrescribeStartViewController" ControllerObject:alertInfo];
                _isDeal = YES;
            }
//            else if ([doWayType isEqualToString:@"LXHZ"]){
//                //跳转到IM界面
//            }
            else if ([doWayType isEqualToString:@"JXJC"] || [doWayType isEqualToString:@"TZFZ"] || [doWayType isEqualToString:@"QTFS"]){
                //继续监测，通知复诊
                [self.navigationController popViewControllerAnimated:YES];
                _isDeal = YES;
            }
            else{
                
                return;
            }
        }
        
    }
    
    if ([taskname isEqualToString:@"UserWarningRecordTask"]) {
        
        if (taskResult && [taskResult isKindOfClass:[NSArray class]]) {
            
            self.warningRecordArray = (NSArray *)taskResult;
            [self.tableView reloadData];
        }
    }
    
    if ([taskname isEqualToString:@"checkAlertIsAppearTask"]) {
        
        if (taskResult && [taskResult isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *dicResult = (NSDictionary *)taskResult;
            NSString *done = dicResult[@"done"];
            NSString *msg = dicResult[@"msg"];
            
            NSString *type = [doWayTypeArray objectAtIndex:_selectDoWayIndex];
            
            if (msg && msg.length > 0 && done && [done isEqualToString:@"Y"]) {
                
                [AlertUtil showAlert:msg alertConfirmButtonClickBlock:^{
                    if ([type isEqualToString:@"QTFS"]) {
                        [self dealOtherWayWarning];
                        return ;
                    }
                    [self dealWarning:_selectDoWayIndex];
                    
                } alertCancelButtonClickBlock:^{
                    
                }];
            }
            else{
                if ([type isEqualToString:@"QTFS"]) {
                    [self dealOtherWayWarning];
                    return ;
                }
                [self dealWarning:_selectDoWayIndex];
            
            }
        }
    }
}


@end
