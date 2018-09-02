//
//  HealthPlanSummaryViewController.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/7.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanSummaryViewController.h"
#import "HealthPlanDetModel.h"
#import "HealthPlanSummaryHeaderView.h"
#import "HealthPlanSummaryOperateView.h"
#import "HealthPlanSummaryFormulateView.h"
#import "HealthPlanInvalidView.h"

#import "HealthPlanSummaryTableViewCell.h"

#import "HealthPlanAppendDetPickerViewController.h"
#import "HealthPlanCommitToDoctorPickerViewController.h"

static const NSInteger kFormulateViewTag = 0x3821;
static const NSInteger kCannotPerviewViewTag = 0x7232;

@interface HealthPlanSummaryViewController ()
<TaskObserver, UITableViewDelegate, UITableViewDataSource,
HealthPlanSummaryOperateDelegate>
{
    HealthPlanDetailSectionModel* appendSectionModel;
}
@property (nonatomic, readonly) NSInteger userId;
//@property (nonatomic, readonly) NSMutableDictionary* healthPlanSummaryDictionary;

@property (nonatomic, readonly) HealthPlanDetailModel* healthPlanDetModel;

@property (nonatomic, strong) HealthPlanSummaryHeaderView* summaryHeaderView;
@property (nonatomic, strong) HealthPlanSummaryOperateView* operationView;
@property (nonatomic, strong) UITableView* tableView;


@end

@implementation HealthPlanSummaryViewController

- (id) initWithUserId:(NSInteger) userId
{
    self = [super init];
    if (self) {
        _userId = userId;
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"健康计划";
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    [self.summaryHeaderView.templateButton setHidden:YES];
    
    [self.summaryHeaderView.templateButton addTarget:self action:@selector(formulateButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self layoutElements];
//    [self loadHealthPlanSummary];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(healthPlanEditHandle:) name:kHealthPlanEditedNotificationName object:nil];
    
    if (self.formulatePlan) {
        //制定计划
        __weak typeof(self) weakSelf = self;
        [HealthPlanViewControllerManager createHealthPlanTemplateViewController:^(HealthPlanTemplateModel *model) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf closeFormulateView];
            //获取模版内容
            [strongSelf loadHealthPlanSummaryWithTemplateId:model.id];
        }];
    }
    
    if (self.groupId) {
        //服务是否过期 HealthPlanCheckServiceTask
        NSMutableDictionary* paramDictionary = [NSMutableDictionary dictionary];
        [paramDictionary setValue:[NSString stringWithFormat:@"%ld", self.userId] forKey:@"userId"];
        StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
        
        [paramDictionary setValue:[NSString stringWithFormat:@"%ld", staff.staffId] forKey:@"staffId"];
        [paramDictionary setValue:self.groupId forKey:@"imGroupId"];
        
        [[TaskManager shareInstance] createTaskWithTaskName:@"HealthPlanCheckServiceTask" taskParam:paramDictionary TaskObserver:self];
    }
    else
    {
        [self loadHealthPlanSummary];
    }
}

- (void) layoutElements
{
    [self.summaryHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(@117);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.summaryHeaderView.mas_bottom).offset(5);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadHealthPlanSummary
{
    [self.view showWaitView];
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", (long)self.userId] forKey:@"userId"];
    if (self.healthyPlanId)
    {
        [dicPost setValue:self.healthyPlanId forKey:@"healthyPlanId"];
    }
    [[TaskManager shareInstance] createTaskWithTaskName:@"HealthPlanSummaryTask" taskParam:dicPost TaskObserver:self];
}

- (void) loadHealthPlanSummaryWithTemplateId:(NSString*) templateId
{
    [self.view showWaitView];
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", (long)self.userId] forKey:@"userId"];
    [dicPost setValue:templateId forKey:@"healthyPlanTempId"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"HealthPlanSummaryTask" taskParam:dicPost TaskObserver:self];
}

- (void) showFormulateView
{
    HealthPlanSummaryFormulateView* formaulateView = [self.view viewWithTag:kFormulateViewTag];
    if (!formaulateView) {
        formaulateView = [[HealthPlanSummaryFormulateView alloc] init];
        [self.view addSubview:formaulateView];
        [formaulateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        [formaulateView setTag:kFormulateViewTag];
        
        BOOL staffPrivilege = [HealthPlanUtil staffHasEditPrivilege:self.healthPlanDetModel.status];
        if (staffPrivilege) {
            [formaulateView.formulateButton addTarget:self action:@selector(formulateButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    return;
}

- (void) showCannotPerviewView
{
    //kCannotPerviewViewTag
    HealthPlanSummaryCannotPerviewView* formaulateView = [self.view viewWithTag:kCannotPerviewViewTag];
    if (!formaulateView) {
        formaulateView = [[HealthPlanSummaryCannotPerviewView alloc] init];
        [self.view addSubview:formaulateView];
        [formaulateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        [formaulateView setTag:kCannotPerviewViewTag];
    }

}

- (void) closeFormulateView
{
    HealthPlanSummaryFormulateView* formaulateView = [self.view viewWithTag:kFormulateViewTag];
    [formaulateView removeFromSuperview];
    formaulateView = nil;
}

- (void) healthPlanEditHandle:(NSNotification*) notification
{
    [self.tableView reloadData];
}

#pragma mark - control event
- (void) formulateButtonClicked:(id) sender
{
    __weak typeof(self) weakSelf = self;
    [HealthPlanViewControllerManager createHealthPlanTemplateViewController:^(HealthPlanTemplateModel *model) {
         __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf closeFormulateView];
        //获取模版内容
        [strongSelf loadHealthPlanSummaryWithTemplateId:model.id];
    }];
}

- (void) appendPlanButtonClicked:(id) sender
{
    NSMutableArray* existedDets = [NSMutableArray array];
    [self.healthPlanDetModel.dets enumerateObjectsUsingBlock:^(HealthPlanDetailSectionModel* model, NSUInteger idx, BOOL * _Nonnull stop) {
        HealthPlanDetModel* detModel = [[HealthPlanDetModel alloc] init];
        detModel.code = model.code;
        detModel.title = model.title;
        [existedDets addObject:detModel];
    }];
    
    __weak typeof(self) weakSelf = self;
    [HealthPlanAppendDetPickerViewController showWithExistedDets:existedDets pickHandle:^(HealthPlanDetModel *model) {
        __block NSString* typeCode = model.code;
        [HealthPlanViewControllerManager createHealthPlanTemplateViewController:model.code selectedBlock:^(HealthPlanTemplateModel *templateModel) {
            [weakSelf planTemplateSelected:templateModel typeCode:typeCode];
        }];
    }];
}

- (void) planTemplateSelected:(HealthPlanTemplateModel*) model
                     typeCode:(NSString*) typeCode
{
    //获取模版详情
    NSMutableDictionary* paramDictionary = [NSMutableDictionary dictionary];
    [paramDictionary setValue:model.id forKey:@"subHealthyPlanTempId"];
    [paramDictionary setValue:typeCode forKey:@"typeCode"];
    
    appendSectionModel = [[HealthPlanDetailSectionModel alloc] init];
    appendSectionModel.code = typeCode;
    appendSectionModel.templateDetId = model.id;
    appendSectionModel.title = [appendSectionModel titleWithCode];
    
    [self.view showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"HealthPlanTemplateDetailTask" taskParam:paramDictionary TaskObserver:self];
}

#pragma mark - HealthPlanSummaryOperateDelegate
- (void) operateButtonClicked:(EHealthPlanOperation) operate
{
    //检测健康计划是否已经填写完整
    NSArray* dets = self.healthPlanDetModel.dets;
    if (!dets || dets.count == 0) {
        [self showAlertMessage:@"健康计划的编辑尚未完成。"];
        return;
    }
    
    __block BOOL isValid = YES;
    [dets enumerateObjectsUsingBlock:^(HealthPlanDetailSectionModel* detModel, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![detModel planDetIsValidWithErrorAlert]) {
//            [self showAlertMessage:@"健康计划的编辑尚未完成。"];
            isValid = NO;
            *stop = YES;
            return;
        }
    }];
    
    if (!isValid) {
        return;
    }
    
    switch (operate) {
        case HealthPlanOperation_Commit:
        {
            //提交给医生
            __weak typeof(self) weakSelf = self;
            [HealthPlanCommitToDoctorPickerViewController showWithUserId:[NSString stringWithFormat:@"%ld", (long)self.userId] handle:^(StaffTeamDoctorModel *staffModel) {
                if (!weakSelf) {
                    return ;
                }
                
                [weakSelf submitHealthPlanToDoctor:staffModel];
                
            }];
            break;
        }
        case HealthPlanOperation_Confirm:
        {
            //主治医生确定
            __weak typeof(self) weakSelf = self;
            [self showAlertMessage:@"确认健康计划" cancelTitle:@"取消" cancelClicked:nil confirmTitle:@"确认" confirmClicked:^{
                [weakSelf confirmHealthPlan];
            }];
            break;
        }
        default:
            break;
    }
}

- (void) submitHealthPlanToDoctor:(StaffTeamDoctorModel*) staffModel
{
    
    NSMutableDictionary* planDict = [self.healthPlanDetModel mj_keyValues];
    NSMutableDictionary* paramDict = [NSMutableDictionary dictionary];
    [paramDict setValue:planDict forKey:@"healthyPlan"];
    [paramDict setValue:[NSString stringWithFormat:@"%ld", (long)staffModel.staffId] forKey:@"submitStaffId"];
    [paramDict setValue:@2 forKey:@"type"];
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    [paramDict setValue:[NSString stringWithFormat:@"%ld", (long)staff.staffId] forKey:@"createUserId"];
    //HealthPlanSubmitTask
    [[TaskManager shareInstance] createTaskWithTaskName:@"HealthPlanSubmitTask" taskParam:paramDict TaskObserver:self];
}

- (void) confirmHealthPlan
{
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    if ([self.healthPlanDetModel.status isEqualToString:@"2"] &&
        self.healthPlanDetModel.approveStaffId &&
        [self.healthPlanDetModel.approveStaffId mj_isPureInt]) {
        //健康计划已经提交
        if (self.healthPlanDetModel.approveStaffId.integerValue != staff.staffId) {
            [self showAlertMessage:@"对不起，不是指定给您的健康计划，您不能确认。"];
            return;
        }
    }
    
    
    NSMutableDictionary* planDict = [self.healthPlanDetModel mj_keyValues];
    NSMutableDictionary* paramDict = [NSMutableDictionary dictionary];
    
    [paramDict setValue:planDict forKey:@"healthyPlan"];
    [paramDict setValue:self.healthPlanDetModel.createUserId forKey:@"createUserId"];
    
    [paramDict setValue:@1 forKey:@"type"];
    //HealthPlanSubmitTask
    [[TaskManager shareInstance] createTaskWithTaskName:@"HealthPlanSubmitTask" taskParam:paramDict TaskObserver:self];
}

#pragma mark - settingAndGetting
- (HealthPlanSummaryHeaderView*) summaryHeaderView
{
    if (!_summaryHeaderView) {
        _summaryHeaderView = [[HealthPlanSummaryHeaderView alloc] init];
        [self.view addSubview:_summaryHeaderView];
    }
    return _summaryHeaderView;
}

- (HealthPlanSummaryOperateView*) operationView
{
    if (!_operationView) {
        _operationView = [[HealthPlanSummaryOperateView alloc] init];
        [self.view addSubview:_operationView];
        [_operationView setDelegate:self];
    }
    return _operationView;
}

- (UITableView*) tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        [self.view addSubview:_tableView];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
    }
    return _tableView;
}

#pragma mark - UITableView DataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.healthPlanDetModel && self.healthPlanDetModel.dets) {
        return self.healthPlanDetModel.dets.count;
    }
    return 0;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HealthPlanSummaryTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"HealthPlanSummaryTableViewCell"];
    if (!cell) {
        cell = [[HealthPlanSummaryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HealthPlanSummaryTableViewCell"];
    }
    
    HealthPlanDetailSectionModel* sectionModel = self.healthPlanDetModel.dets[indexPath.row];
    [cell setHealthPlanSection:sectionModel];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (BOOL) needAppendDet
{
    __block BOOL needAppendDet = NO;
    BOOL staffPrivilege = [HealthPlanUtil staffHasEditPrivilege:self.healthPlanDetModel.status];
    if (!staffPrivilege) {
        return needAppendDet;
        
    }
    
    NSArray* detCodes = @[@"test", @"survey", @"nutrition", @"assessment", @"wards", @"sports", @"mentality", @"live", @"review"];
    NSArray* exitedCodes = [self.healthPlanDetModel.dets valueForKey:@"code"];
    
    [detCodes enumerateObjectsUsingBlock:^(NSString* code, NSUInteger idx, BOOL * _Nonnull stop)
    {
        __block BOOL isExisted = NO;
        [exitedCodes enumerateObjectsUsingBlock:^(NSString* exitedCode, NSUInteger idx, BOOL * _Nonnull exitedstop) {
            if ([exitedCode isEqualToString:code])
            {
                isExisted = YES;
                *exitedstop = YES;
            }
        }];
        
        if (!isExisted) {
            needAppendDet = YES;
            *stop = YES;
        }
    }];
    return needAppendDet;
}

#pragma mark - UITableView Delegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
//    HealthPlanDetailSectionModel* sectionModel = self.healthPlanDetModel.dets[indexPath.row];
//    return [sectionModel cellHeight];
}

- (CGFloat) footerviewHeight
{
    BOOL needAppendDet = [self needAppendDet];
    
    if (needAppendDet) {
        return 59;
    }
    return 0.5;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return [self footerviewHeight];
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, [self footerviewHeight])];
    [footerview setBackgroundColor:[UIColor commonBackgroundColor]];
//    BOOL staffPrivilege = [HealthPlanUtil staffHasEditPrivilege:self.healthPlanDetModel.status];
    
    BOOL needAppendDet = [self needAppendDet];
    if (needAppendDet) {
        UIButton* appendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [footerview addSubview:appendButton];
//        [appendButton setBackgroundImage:[UIImage rectImage:CGSizeMake(350, 50) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
        [appendButton setBackgroundImage:[UIImage rectImage:CGSizeMake(350, 50) Color:[UIColor whiteColor]] forState:UIControlStateNormal];
        [appendButton setTitle:@"添加计划项目" forState:UIControlStateNormal];
        [appendButton setTitleColor:[UIColor mainThemeColor] forState:UIControlStateNormal];
        [appendButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        
        appendButton.layer.borderColor = [UIColor mainThemeColor].CGColor;
        appendButton.layer.borderWidth = 1;
        appendButton.layer.cornerRadius = 4;
        appendButton.layer.masksToBounds = YES;
        
        [appendButton addTarget:self action:@selector(appendPlanButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [appendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(footerview).insets(UIEdgeInsetsMake(10, 12.5, 10, 12.5));
        }];
    }
    return footerview;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [HealthPlanViewControllerManager createHealthPlanDetailViewController:self.healthPlanDetModel defaultIndex:indexPath.row];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL staffPrivilege = staffPrivilege = [HealthPlanUtil staffHasEditPrivilege:self.healthPlanDetModel.status];
    if (!staffPrivilege) {
        return NO;
    }
    
    if (self.healthPlanDetModel.dets && self.healthPlanDetModel.dets.count > 1) {
        return YES;
    }
    HealthPlanDetailSectionModel* sectionModel = self.healthPlanDetModel.dets[indexPath.row];
    if (sectionModel.code && [sectionModel.code isEqualToString:@"medicine"])
    {
        //用药模块不能被删除
        return NO;
    }
    
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray* dets = [NSMutableArray arrayWithArray:self.healthPlanDetModel.dets];
    
    [dets removeObjectAtIndex:indexPath.row];
    self.healthPlanDetModel.dets = dets;
    [self.tableView reloadData];
    
}

#pragma mark status and operation
- (NSArray*) healthPlanOperation
{
    NSMutableArray* operations = [NSMutableArray array];
    NSArray* operationCodes = @[kPrivilegeEditOperate, kPrivilegeConfirmOperate];
    
    [operationCodes enumerateObjectsUsingBlock:^(NSString* operationCode, NSUInteger idx, BOOL * _Nonnull stop)
     {
         EHealthPlanOperation operation = HealthPlanOperation_None;
         switch (idx)
         {
             case 0:
                 operation = HealthPlanOperation_Commit;
                 break;
             case 1:
                 operation = HealthPlanOperation_Confirm;
                 break;
                 
         }
         if (operation == HealthPlanOperation_None) {
             return ;
         }
         BOOL staffPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeHealthPlanMode Status:self.healthPlanDetModel.status.integerValue OperateCode:operationCode];
         if (staffPrivilege)
         {
             __block BOOL isExisted = NO;
             [operations enumerateObjectsUsingBlock:^(NSNumber* operationNumber, NSUInteger idx, BOOL * _Nonnull appendstop) {
                 isExisted = (operation == operationNumber.integerValue);
                 if (isExisted)
                 {
                     *appendstop = YES;
                     return;
                 }
             }];
             if (!isExisted) {
                 [operations addObject:@(operation)];
             }
         }
     }];
    return operations;
}



#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    [self.view closeWaitView];
    if (taskError != StepError_None) {
        [self showAlertMessage:errorMessage];
        return;
    }
    
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    
    if ([taskname isEqualToString:@"HealthPlanSummaryTask"])
    {
        //是否有查看权限
        BOOL viewPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeHealthPlanMode Status:self.healthPlanDetModel.status.integerValue OperateCode:kPrivilegeViewOperate];
        if (!viewPrivilege)
        {
            [self showCannotPerviewView];
            return;
        }
        
        if (self.healthPlanDetModel.status.integerValue == 1 && (!self.healthPlanDetModel.healthyPlanTempId || self.healthPlanDetModel.healthyPlanTempId.length == 0) ) {
            //待制定
            [self showFormulateView];
            return;
        }
        
        [self.summaryHeaderView setHealthPlanDet:self.healthPlanDetModel];
        BOOL staffPrivilege = [HealthPlanUtil staffHasEditPrivilege:self.healthPlanDetModel.status];
        [self.summaryHeaderView.templateButton setHidden:!staffPrivilege];
        
        NSArray* healthPlanOperations = [self healthPlanOperation];
        if (healthPlanOperations && healthPlanOperations.count > 0)
        {
            //可操作
            [self.operationView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self.view);
                make.height.mas_equalTo(@57);
            }];
            
            [self.operationView setOpeartions:healthPlanOperations];
            
            [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.right.equalTo(self.view);
                        make.top.equalTo(self.summaryHeaderView.mas_bottom).offset(5);
                        make.bottom.equalTo(self.operationView.mas_top);
                    }];
        }
        
        [self.tableView reloadData];

    }
    
    if ([taskname isEqualToString:@"HealthPlanTemplateDetailTask"]) {
        [self.tableView reloadData];
    }
    
    if ([taskname isEqualToString:@"HealthPlanSubmitTask"]) {
        [self.navigationController popViewControllerAnimated:YES];
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
    if ([taskname isEqualToString:@"HealthPlanSummaryTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[HealthPlanDetailModel class]])
        {
            _healthPlanDetModel = (HealthPlanDetailModel*) taskResult;
            
        }
    }
    
    if ([taskname isEqualToString:@"HealthPlanCheckServiceTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSDictionary class]])
        {
            NSString* inService = taskResult[@"inService"];
            if (inService && [inService isEqualToString:@"N"])
            {
                HealthPlanInvalidView* invalidView = [[HealthPlanInvalidView alloc] init];
                [self.view addSubview:invalidView];
                [invalidView setInService:NO];
                
                [invalidView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(self.view);
                }];
                
                return;
            }
            NSString* hasHealthyPlan = taskResult[@"hasHealthyPlan"];
            if (hasHealthyPlan && [hasHealthyPlan isEqualToString:@"N"])
            {
                HealthPlanInvalidView* invalidView = [[HealthPlanInvalidView alloc] init];
                [self.view addSubview:invalidView];
                [invalidView setHasHealthyPlan:NO];
                
                [invalidView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(self.view);
                }];
                
                return;
            }
            
            
            [self loadHealthPlanSummary];
        }
    }
    
    if ([taskname isEqualToString:@"HealthPlanTemplateDetailTask"]) {
        if (taskResult && [taskResult isKindOfClass:[NSArray class]])
        {
            appendSectionModel.criterias = taskResult;
            NSMutableArray* dets = [NSMutableArray arrayWithArray: self.healthPlanDetModel.dets];
            [dets addObject:appendSectionModel];
            self.healthPlanDetModel.dets = dets;
        }
    }
}

@end
