//
//  CreateDocumentAssessmentDetailViewController.m
//  HMDoctor
//
//  Created by yinqaun on 16/8/24.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "CreateDocumentAssessmentDetailViewController.h"
#import "CreateDocumetnMessionInfo.h"
#import "ChooseDocumentChooseIllViewController.h"
#import "HMSwitchView.h"
#import "DocumentDiseaseSelectViewController.h"

#import "CreateDocumentAssessmentContentViewController.h"
#import "CDAPersonInfoViewController.h"

@interface CreateDocumentAssessmentDetailViewController ()
<HMSwitchViewDelegate,
TaskObserver>
{
    CreateDocumetnMessionInfo* messionModel;
    CreateDocumetnTemplateModel* templateModel;
    UIView* diseaseView;
    UILabel* docuIdLable;
    ChooseDocumentChooseIllControl* chooseControl;
    HMSwitchView* switchView;
    
    UITabBarController* tabbarController;
    
    
}
@end

@implementation CreateDocumentAssessmentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.paramObject && [self.paramObject isKindOfClass:[CreateDocumetnMessionInfo class]]) {
        messionModel = (CreateDocumetnMessionInfo*) self.paramObject;
    }
    
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    [self.navigationItem setTitle:@"建档评估"];
    if (!messionModel.userName)
    {
        //获取用户基本信息 CDATemplateSummaryTask
        
    }
    else
    {
        NSString* navigationTitle = [NSString stringWithFormat:@"%@ (%@|%ld)", messionModel.userName, messionModel.sex, messionModel.age];
        [self.navigationItem setTitle:navigationTitle];
    }
    
    [self createDiseaseView];
    [self createSwitchView];
    //[self createTabbarController];
    
    if (messionModel.status == 3)
    {
        
    }
    
    [self.view showWaitView];
    //获取患者和模版信息
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:messionModel.assessmentReportId forKey:@"assessmentReportId"];
    [dicPost setValue:[NSNumber numberWithInteger:1] forKey:@"reportType"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"CDATemplateSummaryTask" taskParam:dicPost TaskObserver:self];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initialize
- (void) createDiseaseView
{
    diseaseView = [[UIView alloc]init];
    [self.view addSubview:diseaseView];
    [diseaseView setBackgroundColor:[UIColor whiteColor]];
    [diseaseView showBottomLine];
    [diseaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(@72);
    }];
    
    UIView* docuNumberView = [[UIView alloc]init];
    [docuNumberView setBackgroundColor:[UIColor commonBackgroundColor]];
    [docuNumberView showBottomLine];
    [diseaseView addSubview:docuNumberView];
    [docuNumberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(diseaseView);
        make.top.equalTo(diseaseView);
        make.height.mas_equalTo(28);
        
    }];
    
    UILabel* docuIdTitleLable = [[UILabel alloc]init];
    [docuNumberView addSubview:docuIdTitleLable];
    [docuIdTitleLable setFont:[UIFont systemFontOfSize:13]];
    [docuIdTitleLable setTextColor:[UIColor commonGrayTextColor]];
    [docuIdTitleLable setText:@"档案编号："];
    [docuIdTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(docuNumberView);
        make.left.equalTo(docuNumberView).with.offset(12.5);
    }];
    
    docuIdLable = [[UILabel alloc]init];
    [docuNumberView addSubview:docuIdLable];
    
    [docuIdLable setFont:[UIFont systemFontOfSize:13]];
    [docuIdLable setTextColor:[UIColor commonTextColor]];
    [docuIdLable setText:messionModel.healtyRecordId];
    [docuIdLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(docuNumberView);
        make.left.equalTo(docuIdTitleLable.mas_right);
        make.right.lessThanOrEqualTo(docuNumberView).with.offset(-12.5);
    }];
    
    chooseControl = [[ChooseDocumentChooseIllControl alloc]init];
    [diseaseView addSubview:chooseControl];
    [chooseControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(docuNumberView.mas_bottom);
        make.left.and.right.equalTo(diseaseView);
        make.bottom.equalTo(diseaseView);
    }];

    [chooseControl addTarget:self action:@selector(chooseControlClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void) createSwitchView
{
    switchView = [[HMSwitchView alloc]init];
    [self.view addSubview:switchView];
    
    [switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(diseaseView.mas_bottom).with.offset(6);
        make.height.mas_equalTo(@45);
    }];
    
    [switchView createCells:@[@"建档评估", @"个人信息", @"检验检查", @"病历信息", @"用药情况"]];
    [switchView setDelegate:self];
}

- (void) createTabbarController
{
    if (tabbarController)
    {
        return;
    }
    tabbarController = [[UITabBarController alloc]init];
    [self addChildViewController:tabbarController];
    [self.view addSubview:tabbarController.view];
    
    [tabbarController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(switchView.mas_bottom).with.offset(6);
        make.bottom.equalTo(self.view);
    }];
    
    [tabbarController.tabBar setHidden:YES];
    
    
    
    UIViewController* vcAssessmentContent = [[CreateDocumentAssessmentContentViewController alloc]initWithAssessmentReportId:messionModel.assessmentReportId templateId:templateModel.templateId status:messionModel.status];
    CreateDocumentAssessmentContentViewController* vcContent = (CreateDocumentAssessmentContentViewController*) vcAssessmentContent;
    [vcContent setUserId:messionModel.userId];
    [vcContent setStaffUserId:messionModel.staffUserId];
    if (messionModel.status ==4 || messionModel.status == 5)
    {
        vcAssessmentContent = [[CDAAssessmentReportDetailViewController alloc]initWithAssessmentReportId:messionModel.assessmentReportId templateId:templateModel.templateId];
        
    }
    
    CDADocumentInfoViewController* vcPersonInfo = [[CDAPersonInfoViewController alloc]initWithAssessmentReportId:messionModel.assessmentReportId templateId:templateModel.templateId];
    CDADocumentInfoViewController* vcExamine= [[CDAExamineViewController alloc]initWithAssessmentReportId:messionModel.assessmentReportId templateId:templateModel.templateId];
    CDADocumentInfoViewController* vcMedicalHistory = [[CDAMedicalHistoryViewController alloc]initWithAssessmentReportId:messionModel.assessmentReportId templateId:templateModel.templateId];
    CDADocumentInfoViewController* vcMedication = [[CDAMedicationViewController alloc]initWithAssessmentReportId:messionModel.assessmentReportId templateId:templateModel.templateId];
    
    [tabbarController setViewControllers:@[vcAssessmentContent, vcPersonInfo, vcExamine, vcMedicalHistory, vcMedication]];
}



- (void) chooseControlClicked:(id) sender
{
    BOOL editPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeCreateDocumentMode Status:messionModel.status OperateCode:kPrivilegeChooseIllOperate];
    if (!editPrivilege)
    {
        //没有修改疾病模版的权限
        return;
    }
    
    [DocumentDiseaseSelectViewController showInParentController:self messionModel:messionModel selectedBlock:^(BOOL selected, CreateDocumetnTemplateModel* tempModel) {
        if (!selected)
        {
            return ;
            //[self performSelector:@selector(gotoCreateDocumentAssessmentDetailView) withObject:nil afterDelay:0.01];
        }
        
        if (tempModel)
        {
            templateModel = tempModel;
            [chooseControl.diseaseLable setText:tempModel.templateName];
            
            if (!tabbarController.viewControllers || 0 == tabbarController.viewControllers.count) {
                return;
            }
            UIViewController* vcAssementDetail = tabbarController.viewControllers[0];
            if (![vcAssementDetail isKindOfClass:[CreateDocumentAssessmentContentViewController class]])
            {
                return;
            }
            CreateDocumentAssessmentContentViewController* vcAssessment = (CreateDocumentAssessmentContentViewController*)vcAssementDetail;
            [vcAssessment setAssessmentTemplateId:tempModel.templateId status:2];
            
            for (UIViewController* controller in tabbarController.viewControllers) {
                if (![controller isKindOfClass:[CDADocumentInfoViewController class]])
                {
                    continue;
                }
                
                CDADocumentInfoViewController* vcDocument = (CDADocumentInfoViewController*)controller;
                [vcDocument setTemplateId:templateModel.templateId];
            }
        }
    }];
}

//生成报告
- (void) reportAssessmentButtonClicked:(id) sender
{
    //CDABuildAssessmentReportTask
    [self.view showWaitView];
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:messionModel.assessmentReportId forKey:@"assessmentReportId"];
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    [dicPost setValue:[NSNumber numberWithInteger:staff.userId] forKey:@"doctorUserId"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"CDABuildAssessmentReportTask" taskParam:dicPost TaskObserver:self];
}



- (void) loadTemplateTypeList
{
    [self.view showWaitView];
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:messionModel.assessmentReportId forKey:@"assessmentReportId"];
    [dicPost setValue:templateModel.templateId forKey:@"templateId"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"HealthReportListTask" taskParam:dicPost TaskObserver:self];
}

- (void) gotoCreateDocumetnMessionList
{
    [HMViewControllerManager createViewControllerWithControllerName:@"CreateDocumentStartViewController" ControllerObject:nil];
}

#pragma mark - HMSwitchViewDelegate
- (void) switchview:(HMSwitchView*) switchview SelectedIndex:(NSUInteger) selectedIndex
{
    if (tabbarController)
    {
        [tabbarController setSelectedIndex:selectedIndex];
    }
}

#pragma mark TaskObserver
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
    
    if ([taskname isEqualToString:@"CDATemplateSummaryTask"])
    {
        //修改navigationbar title
        NSString* navigationTitle = [NSString stringWithFormat:@"%@ (%@|%ld)", messionModel.userName, messionModel.sex, messionModel.age];
        [self.navigationItem setTitle:navigationTitle];
        
        if (templateModel && templateModel.templateName)
        {
            //修改已选择模版名
            if (chooseControl)
            {
                [chooseControl.diseaseLable setText:templateModel.templateName];
                [chooseControl.diseaseLable setTextColor:[UIColor commonTextColor]];
            }
            
            //获取模板下的所有有效的模板类别信息
            [self createTabbarController];
//            [self refreshNavigationRightButton];
        }
    }
    
    if ([taskname isEqualToString:@"CDABuildAssessmentReportTask"])
    {
        [self gotoCreateDocumetnMessionList];
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
    
    if ([taskname isEqualToString:@"CDATemplateSummaryTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSDictionary class]])
        {
            NSDictionary* dicResult = (NSDictionary*) taskResult;
            CreateDocumetnMessionInfo* messionInfo = [dicResult valueForKey:@"messionModel"];
            messionModel = messionInfo;
            if (messionInfo.healtyRecordId)
            {
                [docuIdLable setText:messionModel.healtyRecordId];
            }
            
            templateModel = [dicResult valueForKey:@"template"];
        }
    }
}

@end
