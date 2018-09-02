//
//  CreateDocumentStartViewController.m
//  HMDoctor
//
//  Created by yinqaun on 16/8/19.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "CreateDocumentStartViewController.h"
#import "HMSwitchView.h"
#import "CreateDocumentMessionTableViewController.h"

@interface CreateDocumentStartViewController ()
<HMSwitchViewDelegate,
TaskObserver>
{
    HMSwitchView* switchview;
//    CreateDocumentMessionTableViewController* tvcMessions;
    UITabBarController* tabbarController;
}
@end

@implementation CreateDocumentStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"建档"];
    [self createSwitchView];
    [self createTababr];
    if (UMSDK_isOn) {
        [MobClick event:UMCustomEvent_EnterWorkDesk_CreateDoc];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadMessionCount];
    
    
    
}

- (void) createSwitchView
{
    switchview = [[HMSwitchView alloc]init];
    [self.view addSubview:switchview];
    [switchview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(@45);
    }];
    
    [switchview createCells:@[@"待处理", @"全部"]];
    [switchview setDelegate:self];
}

- (void) createTababr
{
    tabbarController = [[UITabBarController alloc]init];
    [self addChildViewController:tabbarController];
    NSArray* unDealedMessionsStatus = [self unDealedMessionsStatus];
    CreateDocumentMessionTableViewController* tvcUnDealed = [[CreateDocumentMessionTableViewController alloc]initWithStatus:unDealedMessionsStatus];
    CreateDocumentMessionTableViewController* tvcAllStatus = [[CreateDocumentMessionTableViewController alloc]initWithStatus:nil];
    [tabbarController setViewControllers:@[tvcUnDealed, tvcAllStatus]];
    [self.view addSubview:tabbarController.view];
    [tabbarController.tabBar setHidden:YES];
    [tabbarController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(self.view);
        make.top.equalTo(switchview.mas_bottom);
    }];
}



#pragma mark - HMSwitchViewDelegate
- (void) switchview:(HMSwitchView*) switchview SelectedIndex:(NSUInteger) selectedIndex
{
        [[ActionStatusManager shareInstance] addActionStatusWithPageName:selectedIndex>0?@"工作台－建档－全部":@"工作台－建档－待处理"];
    if (tabbarController)
    {
        [tabbarController setSelectedIndex:selectedIndex];
    }
}

                   
//待处理建档任务
- (NSArray*) unDealedMessionsStatus
{
    NSMutableArray* statusList = [NSMutableArray array];
    BOOL chooseIllPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeCreateDocumentMode Status:2 OperateCode:kPrivilegeChooseIllOperate];
    if (chooseIllPrivilege)
    {
        [statusList addObject:@"1"];
    }
//    选择疾病类型[CHOOSE-ILL]
    chooseIllPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeCreateDocumentMode Status:2 OperateCode:kPrivilegeChooseIllOperate];
//    一般建档评估[NORMAL-ASSESS]
    BOOL normalAssessPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeCreateDocumentMode Status:2 OperateCode:kPrivilegeNormalAssessOperate];
//    治疗风险评估[TREAT-ASSESS]
    BOOL treatAssessPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeCreateDocumentMode Status:2 OperateCode:kPrivilegeTreatAssessOperate];
//    并发症风险评估[COMPLICATION-ASSESS]
    BOOL complicationAssessPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeCreateDocumentMode Status:2 OperateCode:kPrivilegeComplicationAssessOperate];
//    录入诊断[ADD-DIAGNOSE]
    BOOL addDiagnosePrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeCreateDocumentMode Status:2 OperateCode:kPrivilegeAddDiagnoseOperate];
//    提交给医生[SUBMIT]
    BOOL submitPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeCreateDocumentMode Status:2 OperateCode:kPrivilegeSubmitOperate];
    
    if (chooseIllPrivilege || normalAssessPrivilege ||
        treatAssessPrivilege || complicationAssessPrivilege ||
        addDiagnosePrivilege || submitPrivilege)
    {
        [statusList addObject:@"2"];
    }
    
    // 编辑
    BOOL editPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeCreateDocumentMode Status:3 OperateCode:kPrivilegeEditOperate];
    // 生成报告
    BOOL reportPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeCreateDocumentMode Status:3 OperateCode:kPrivilegeReportOperate];
    if (editPrivilege || reportPrivilege)
    {
        [statusList addObject:@"3"];
    }
    
    return statusList;
}



//
- (void) loadMessionCount
{
    NSMutableArray* statusList = [NSMutableArray array];
    BOOL chooseIllPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeCreateDocumentMode Status:2 OperateCode:kPrivilegeChooseIllOperate];
    if (chooseIllPrivilege)
    {
        [statusList addObject:@"1"];
    }
    //    选择疾病类型[CHOOSE-ILL]
    chooseIllPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeCreateDocumentMode Status:2 OperateCode:kPrivilegeChooseIllOperate];
    //    一般建档评估[NORMAL-ASSESS]
    BOOL normalAssessPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeCreateDocumentMode Status:2 OperateCode:kPrivilegeNormalAssessOperate];
    //    治疗风险评估[TREAT-ASSESS]
    BOOL treatAssessPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeCreateDocumentMode Status:2 OperateCode:kPrivilegeTreatAssessOperate];
    //    并发症风险评估[COMPLICATION-ASSESS]
    BOOL complicationAssessPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeCreateDocumentMode Status:2 OperateCode:kPrivilegeComplicationAssessOperate];
    //    录入诊断[ADD-DIAGNOSE]
    BOOL addDiagnosePrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeCreateDocumentMode Status:2 OperateCode:kPrivilegeAddDiagnoseOperate];
    //    提交给医生[SUBMIT]
    BOOL submitPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeCreateDocumentMode Status:2 OperateCode:kPrivilegeSubmitOperate];
    
    if (chooseIllPrivilege || normalAssessPrivilege ||
        treatAssessPrivilege || complicationAssessPrivilege ||
        addDiagnosePrivilege || submitPrivilege)
    {
        [statusList addObject:@"2"];
    }
    
    if (0 == statusList.count)
    {
        return;
    }
    
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", staff.staffId] forKey:@"staffId"];
    NSString* staffRole = [[UserInfoHelper defaultHelper] staffRole];
    if (staffRole)
    {
        [dicPost setValue:staffRole forKey:@"staffRole"];
    }
    
    [dicPost setValue:statusList forKey:@"status"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"CreateDocumentMessionListCountTask" taskParam:dicPost TaskObserver:self];
}

#pragma mark TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    
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
    
    if ([taskname isEqualToString:@"CreateDocumentMessionListCountTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSNumber class]])
        {
            NSNumber* numCount = (NSNumber*) taskResult;
            [switchview setCellTitle:[NSString stringWithFormat:@"待处理(%ld)", numCount.integerValue] index:0];
        }
    }
}

@end
