//
//  CreateDocumentAssessmentContentViewController.m
//  HMDoctor
//
//  Created by yinqaun on 16/8/24.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "CreateDocumentAssessmentContentViewController.h"
#import "CreateDocumetnMessionInfo.h"
#import "CDATemplateTypeTableViewCell.h"
#import "CDASelectCommitDoctorViewController.h"
#import "CDADocumentDetailViewController.h"

@interface CreateDocumetnTemplateTypeModel (CDATableCellHeight)

- (CGFloat) cellHeight;
@end

@implementation CreateDocumetnTemplateTypeModel (CDATableCellHeight)

- (CGFloat) cellHeight
{
    CGFloat cellHeight = 45;
    switch (self.status)
    {
        case 1:
        {
            //已填写
            cellHeight = 45;
        }
            break;
        case 2:
        {
            //已填写
            cellHeight = 60;
            break;
        }
        default:
            break;
    }
    
    if (TemplateType_Diagnosis == self.dataType) {
        
        NSString* reportComments = self.reportComments;
        if (!reportComments || 0 == reportComments.length)
        {
            reportComments = @"尚无诊断内容。";
        }
        cellHeight = [reportComments heightSystemFont:[UIFont font_30] width:(kScreenWidth - 25)] + 20;
    }
    return cellHeight;
}

@end

@interface CADTableSectionModel : NSObject
{
    
}

@property (nonatomic, assign) NSInteger dataType;
@property (nonatomic, readonly) NSString* dataName;
@property (nonatomic, readonly) NSMutableArray* rows;

+ (NSString*) dataNameWithDataType:(NSInteger) dataType;

- (id) initWithDataType:(NSInteger) dataType ;

@end

@implementation CADTableSectionModel

+ (NSString*) dataNameWithDataType:(NSInteger) dataType
{
    NSString* dataName = nil;
    switch (dataType)
    {
        case TemplateType_CommonaAsessment:
        {
            dataName = @"一般性建档评估";
            break;
        }
        case TemplateType_TreatmentRiskAssessment:
        {
            dataName = @"治疗风险评估";
            break;
        }
        case TemplateType_ConcurrentRiskAssessment:
        {
            dataName = @"并发症风险评估";
            break;
        }
        case TemplateType_Diagnosis:
        {
            dataName = @"诊断";
            break;
        }
        default:
            break;
    }
    return dataName;
}

- (id) initWithDataType:(NSInteger) dataType
{
    self = [super init];
    if (self)
    {
        _dataType = dataType;
        _dataName = [CADTableSectionModel dataNameWithDataType:dataType];
        _rows = [NSMutableArray array];
    }
    return self;
}

@end


@interface CreateDocumentAssessmentContentTableViewController : UITableViewController
<TaskObserver>
{
    NSMutableDictionary* dicTableSections;
}

@property (nonatomic, readonly) NSString* assessmentReportId;
@property (nonatomic, readonly) NSString* templateId;
@property (nonatomic, readonly) NSInteger status;


- (id) initWithAssessmentReportId:(NSString*) assessmentReportId
                       templateId:(NSString*) templateId
                           status:(NSInteger) status;

- (void) setAssessmentTemplateId:(NSString*) templateId
                          status:(NSInteger) status;
/*
 判断是否已经全部填写完成，可以提交给医生
 */
- (BOOL) canCommitToDoctor;
@end

@interface CreateDocumentAssessmentContentViewController ()
<TaskObserver>
{
    CreateDocumentAssessmentContentTableViewController* tvcAssessment;
    UIView* commitView; //提交给医生
}

@property (nonatomic, readonly) NSString* assessmentReportId;
@property (nonatomic, readonly) NSString* templateId;
@property (nonatomic, readonly) NSInteger status;


- (id) initWithAssessmentReportId:(NSString*) assessmentReportId
                       templateId:(NSString*) templateId
                           status:(NSInteger) status;

@end



@implementation CreateDocumentAssessmentContentViewController

- (id) initWithAssessmentReportId:(NSString*) assessmentReportId
                       templateId:(NSString*) templateId
                           status:(NSInteger) status
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        _assessmentReportId = assessmentReportId;
        _templateId = templateId;
        _status = status;
    }
    return self;
}


- (void) setAssessmentTemplateId:(NSString*) templateId
                          status:(NSInteger) status
{
    _templateId = templateId;
    _status = status;
    if (tvcAssessment)
    {
        [tvcAssessment setAssessmentTemplateId:templateId status:status];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    BOOL commitPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeCreateDocumentMode Status:2 OperateCode:kPrivilegeSubmitOperate];
    BOOL reportPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeCreateDocumentMode Status:3 OperateCode:kPrivilegeReportOperate];
    if (2 == self.status && commitPrivilege)
    {
        //提交给医生控件
        commitView = [[UIView alloc]init];
        [self.view addSubview:commitView];
        [commitView setBackgroundColor:[UIColor whiteColor]];
        [commitView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.and.bottom.equalTo(self.view);
            make.height.mas_equalTo(@70);
        }];
        
        UIButton* commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [commitView addSubview:commitButton];
        [commitButton setBackgroundImage:[UIImage rectImage:CGSizeMake(60, 30) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
        [commitButton setTitle:@"提交给医生" forState:UIControlStateNormal];
        [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [commitButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        
        commitButton.layer.borderWidth = 0.5;
        commitButton.layer.borderColor = [UIColor commonControlBorderColor].CGColor;
        commitButton.layer.cornerRadius = 2.5;
        commitButton.layer.masksToBounds = YES;
        
        [commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(commitView).with.offset(12.5);
            make.right.equalTo(commitView).with.offset(-12.5);
            make.top.equalTo(commitView).with.offset(12.5);
            make.bottom.equalTo(commitView).with.offset(-12.5);
        }];
        
        [commitButton addTarget:self action:@selector(commitToDoctorButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (3 == self.status && reportPrivilege) {
        StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
        if (self.staffUserId == staff.userId)
        {
            //是指定给我的
            commitView = [[UIView alloc]init];
            [self.view addSubview:commitView];
            [commitView setBackgroundColor:[UIColor whiteColor]];
            [commitView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.and.right.and.bottom.equalTo(self.view);
                make.height.mas_equalTo(@70);
            }];
            
            UIButton* commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [commitView addSubview:commitButton];
            [commitButton setBackgroundImage:[UIImage rectImage:CGSizeMake(60, 30) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
            [commitButton setTitle:@"生成报告" forState:UIControlStateNormal];
            [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [commitButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
            
            commitButton.layer.borderWidth = 0.5;
            commitButton.layer.borderColor = [UIColor commonControlBorderColor].CGColor;
            commitButton.layer.cornerRadius = 2.5;
            commitButton.layer.masksToBounds = YES;
            
            [commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(commitView).with.offset(12.5);
                make.right.equalTo(commitView).with.offset(-12.5);
                make.top.equalTo(commitView).with.offset(12.5);
                make.bottom.equalTo(commitView).with.offset(-12.5);
            }];
            
            [commitButton addTarget:self action:@selector(reportAssessmentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        
    }
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self createAssessmentTable];
}


- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   

}



- (void) createAssessmentTable
{
    tvcAssessment = [[CreateDocumentAssessmentContentTableViewController alloc]initWithAssessmentReportId:self.assessmentReportId templateId:self.templateId status:self.status];
    
    [self addChildViewController:tvcAssessment];
    [self.view addSubview:tvcAssessment.tableView];
    
    BOOL commitPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeCreateDocumentMode Status:2 OperateCode:kPrivilegeSubmitOperate];
    BOOL reportPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeCreateDocumentMode Status:3 OperateCode:kPrivilegeReportOperate];
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    MASViewAttribute* tableBottom = self.view.mas_bottom;
    if ((2 == self.status && commitPrivilege) ||
        (3 == self.status && reportPrivilege && self.staffUserId == staff.userId))

    {
        tableBottom = commitView.mas_top;
    }
    
    [tvcAssessment.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(tableBottom);
    }];
}

#pragma mark - CommitToDoctor
- (void) commitToDoctorButtonClicked:(id) sender
{
    if (!tvcAssessment)
    {
        return;
    }
    if (![tvcAssessment canCommitToDoctor])
    {
        [self showAlertMessage:@"您还有未填写的评估项目，所有评估项目完成才能生成报告哦"];
        return;
    }
    __weak typeof(self) weakSelf = self;
    [CDASelectCommitDoctorViewController showInParentController:[HMViewControllerManager topMostController] userId:self.userId  commitDoctorSelectedBlock:^(NSInteger staffId) {
        //提交给医生
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.view showWaitView];
        NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
        [dicPost setValue:strongSelf.assessmentReportId forKey:@"assessmentReportId"];
        [dicPost setValue:[NSNumber numberWithInteger:staffId] forKey:@"staffUserId"];
        [[TaskManager shareInstance] createTaskWithTaskName:@"CDASendAssessmentToDoctorTask" taskParam:dicPost TaskObserver:strongSelf];
    }];
}

- (void) reportAssessmentButtonClicked:(id) sender
{
    //CDABuildAssessmentReportTask
    [self.view showWaitView];
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:self.assessmentReportId forKey:@"assessmentReportId"];
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    [dicPost setValue:[NSNumber numberWithInteger:staff.userId] forKey:@"doctorUserId"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"CDABuildAssessmentReportTask" taskParam:dicPost TaskObserver:self];
}

#pragma mark TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    [self.view closeWaitView];
    if (taskError != StepError_None)
    {
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
    
    if ([taskname isEqualToString:@"CDASendAssessmentToDoctorTask"])
    {
        //提交给医生成功, 返回建档任务列表
        [HMViewControllerManager createViewControllerWithControllerName:@"CreateDocumentStartViewController" ControllerObject:nil];
    }
    if ([taskname isEqualToString:@"CDABuildAssessmentReportTask"])
    {
        [HMViewControllerManager createViewControllerWithControllerName:@"CreateDocumentStartViewController" ControllerObject:nil];
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
    
    
}
@end


@implementation CreateDocumentAssessmentContentTableViewController

- (id) initWithAssessmentReportId:(NSString*) assessmentReportId
                       templateId:(NSString*) templateId
                           status:(NSInteger)status
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        _assessmentReportId = assessmentReportId;
        _templateId = templateId;
        _status = status;
    }
    return self;
}

- (void) setAssessmentTemplateId:(NSString*) templateId
                          status:(NSInteger) status
{
    _templateId = templateId;
    _status = status;
    if (dicTableSections) {
        [dicTableSections removeAllObjects];
    }
    
    [self loadTemplateTypeList];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setBackgroundColor:[UIColor commonBackgroundColor]];
    [self loadTemplateTypeList];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadTemplateTypeList];
}

- (void) loadTemplateTypeList
{
    [self.tableView.superview showWaitView];
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:self.assessmentReportId forKey:@"assessmentReportId"];
    [dicPost setValue:[NSNumber numberWithInteger:2] forKey:@"reportType"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"CDAHealthTemplateTypeListTask" taskParam:dicPost TaskObserver:self];

}

- (CADTableSectionModel*) sectionModelWithSection:(NSInteger) section
{
    if (!dicTableSections)
    {
        return nil;
    }
    
    NSArray *sortedKeys = [dicTableSections keysSortedByValueUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 isKindOfClass:[CADTableSectionModel class]] && [obj2 isKindOfClass:[CADTableSectionModel class]])
        {
            CADTableSectionModel* model1 = (CADTableSectionModel*) obj1;
            CADTableSectionModel* model2 = (CADTableSectionModel*) obj2;
            
            if (model1.dataType < model2.dataType) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            
            if (model1.dataType > model2.dataType) {
                return (NSComparisonResult)NSOrderedDescending;}
        }
        
        return (NSComparisonResult)NSOrderedSame;
        
    }];
    
    NSString* sectionname = sortedKeys[section];
    CADTableSectionModel* model = [dicTableSections valueForKey:sectionname];
    if (model && [model isKindOfClass:[CADTableSectionModel class]])
    {
        return model;
    }
    return nil;
}

- (BOOL) canCommitToDoctor
{
    if (!dicTableSections)
    {
        return NO;
    }
    NSArray* keys = [dicTableSections allKeys];
    for (NSString* key in keys)
    {
        CADTableSectionModel* sectionModel = dicTableSections[key];
        for (CreateDocumetnTemplateTypeModel* typeModel in sectionModel.rows)
        {
            if (1 == typeModel.status) {
                return NO;
            }
        }
    }
    
    return YES;
}

#pragma mark - UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if (dicTableSections)
    {
        return dicTableSections.count;
    }
    return 0;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CADTableSectionModel* sectionModel = [self sectionModelWithSection:section];
    if (!sectionModel)
    {
        return 0;
    }
    switch (sectionModel.dataType)
    {
        case TemplateType_CommonaAsessment:
        case TemplateType_TreatmentRiskAssessment:
        case TemplateType_ConcurrentRiskAssessment:
        case TemplateType_Diagnosis:
        {
            if (sectionModel.rows)
            {
                return sectionModel.rows.count;
            }
            break;
        }
        
    }
    if (sectionModel.rows)
    {
        return sectionModel.rows.count;
    }
    return 0;
}

#pragma mark - UITableViewDelegate
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 51;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CADTableSectionModel* sectionModel = [self sectionModelWithSection:indexPath.section];
    if (sectionModel.rows && 0 < sectionModel.rows.count)
    {
        CreateDocumetnTemplateTypeModel* typeModel = sectionModel.rows[indexPath.row];
        
        return [typeModel cellHeight];
    }
    

    return 45;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 41)];
    
    [headerview setBackgroundColor:[UIColor whiteColor]];
    [headerview showBottomLine];
    
    CADTableSectionModel* sectionModel = [self sectionModelWithSection:section];
    
    UIView* lineview = [[UIView alloc]init];
    [headerview addSubview:lineview];
    [lineview setBackgroundColor:[UIColor mainThemeColor]];
    [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerview).with.offset(12.5);
        make.centerY.equalTo(headerview);
        make.height.mas_equalTo(@15);
        make.width.mas_equalTo(@3);
    }];
    lineview.layer.cornerRadius = 1.5;
    lineview.layer.masksToBounds = YES;
    
    UILabel* sectionLable = [[UILabel alloc]init];
    [headerview addSubview:sectionLable];
    [sectionLable setFont:[UIFont systemFontOfSize:15]];
    [sectionLable setText:sectionModel.dataName];
    [sectionLable setTextColor:[UIColor mainThemeColor]];
    
    [sectionLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineview.mas_right).with.offset(2);
        make.centerY.equalTo(headerview);
    }];
    
    
    if (TemplateType_Diagnosis == sectionModel.dataType) {
        //诊断Section
        UIButton* editDiagnosisButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [headerview addSubview:editDiagnosisButton];
        [editDiagnosisButton setTitle:@"去编辑>>" forState:UIControlStateNormal];
        [editDiagnosisButton setTitleColor:[UIColor mainThemeColor] forState:UIControlStateNormal];
        [editDiagnosisButton.titleLabel setFont:[UIFont font_26]];
        [editDiagnosisButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headerview);
            make.right.equalTo(headerview).with.offset(-12.5);
        }];
        
        BOOL editPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeCreateDocumentMode Status:self.status OperateCode:kPrivilegeAddDiagnoseOperate];
        [editDiagnosisButton setHidden:!editPrivilege];
        [editDiagnosisButton addTarget:self action:@selector(editDiagnosisButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return headerview;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    
    [footerview setBackgroundColor:[UIColor commonBackgroundColor]];
    return footerview;
}

- (void) makeTableSections:(NSArray*) templateTypes
{
    dicTableSections = [NSMutableDictionary dictionary];
    if (templateTypes && 0 < templateTypes.count)
    {
        for (CreateDocumetnTemplateTypeModel* typeModel in templateTypes)
        {
            NSString* sectionName = [CADTableSectionModel dataNameWithDataType:typeModel.dataType];
            if (!sectionName || 0 == sectionName.length)
            {
                continue;
            }
            CADTableSectionModel* sectionModel = [dicTableSections valueForKey:sectionName];
            
            if (!sectionModel)
            {
                sectionModel = [[CADTableSectionModel alloc]initWithDataType:typeModel.dataType];
                [dicTableSections setValue:sectionModel forKey:sectionName];
                
            }
            
            [sectionModel.rows addObject:typeModel];
        }
    }
    
   
    
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CADTableSectionModel* sectionModel = [self sectionModelWithSection:indexPath.section];
    //CreateDocumetnTemplateTypeModel* typeModel = sectionModel.rows[indexPath.row];
    UITableViewCell* cell = nil;
    switch (sectionModel.dataType)
    {
        case TemplateType_CommonaAsessment:
        case TemplateType_TreatmentRiskAssessment:
        case TemplateType_ConcurrentRiskAssessment:
        {
            cell = [self assessmentTypeCell:indexPath];
        }
            break;
        case TemplateType_Diagnosis:
        {
            //诊断
            cell = [self assessmentDiagnosisCell:indexPath];
            break;
        }
        default:
            break;
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (UITableViewCell*) assessmentDiagnosisCell:(NSIndexPath*) indexPath
{
    CDATemplateDiagnosisTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CDATemplateDiagnosisTableViewCell"];
    if (!cell)
    {
        cell = [[CDATemplateDiagnosisTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CDATemplateDiagnosisTableViewCell"];
    }
//    BOOL diagnosisPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeCreateDocumentMode Status:self.status OperateCode:kPrivilegeAddDiagnoseOperate];
    CADTableSectionModel* sectionModel = [self sectionModelWithSection:indexPath.section];
    CreateDocumetnTemplateTypeModel* typeModel = sectionModel.rows[indexPath.row];
//    [cell.diagnosisTextView setText:typeModel.reportComments];
    [cell setCreateDocumetnTemplateTypeModel:typeModel];
    return cell;
}

- (void) editDiagnosisButtonClicked:(id) sender
{
    //跳转到编辑诊断界面
    NSString* diagnosisKey = [CADTableSectionModel dataNameWithDataType:TemplateType_Diagnosis];
    if (!diagnosisKey)
    {
        return;
    }
    if (!dicTableSections)
    {
        return;
    }
    CADTableSectionModel* sectionModel = [dicTableSections valueForKey:diagnosisKey];
    if (!sectionModel || 0 == sectionModel.rows.count)
    {
        return;
    }
    
    CreateDocumetnTemplateTypeModel* typeModel = sectionModel.rows[0];
    [HMViewControllerManager createViewControllerWithControllerName:@"CDADiagnosisInputViewController" ControllerObject:typeModel];
}

- (UITableViewCell*) assessmentTypeCell:(NSIndexPath*) indexPath
{
    NSString* cellClassName = [self assessmentTypeTableCellClassName:indexPath];
    CDATemplateTypeTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:cellClassName];
    if (!cell)
    {
        cell = [[NSClassFromString(cellClassName) alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellClassName];
    }
    
    CADTableSectionModel* sectionModel = [self sectionModelWithSection:indexPath.section];
    CreateDocumetnTemplateTypeModel* typeModel = sectionModel.rows[indexPath.row];
    
    [cell setCreateDocumetnTemplateTypeModel:typeModel];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;

}

- (NSString*) assessmentTypeTableCellClassName:(NSIndexPath *)indexPath
{
    NSString* className = @"CDATemplateTypeTableViewCell";
    CADTableSectionModel* sectionModel = [self sectionModelWithSection:indexPath.section];
    CreateDocumetnTemplateTypeModel* typeModel = sectionModel.rows[indexPath.row];
    switch (typeModel.status)
    {
        case 1:
        {
            className = @"CDAUnAssessedTemplateTypeTableViewCell";
        }
            break;
        case 2:
        {
            className = @"CDAAssessedTemplateTypeTableViewCell";
        }
            break;
        default:
            break;
    }
    return className;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CADTableSectionModel* sectionModel = [self sectionModelWithSection:indexPath.section];
    CreateDocumetnTemplateTypeModel* typeModel = sectionModel.rows[indexPath.row];
    
    if (typeModel.dataType == TemplateType_Diagnosis) {
        return;
    }
    switch (typeModel.status)
    {
        case 1:
        {
            //未填写，跳转到填写建档评估
            NSString* operateMode = kPrivilegeNormalAssessOperate;
            switch (typeModel.dataType)
            {
                case TemplateType_CommonaAsessment:
                {
                    operateMode = kPrivilegeNormalAssessOperate;
                }
                    break;
                case TemplateType_TreatmentRiskAssessment:
                {
                    operateMode = kPrivilegeTreatAssessOperate;
                }
                    break;
                case TemplateType_ConcurrentRiskAssessment:
                {
                    operateMode = kPrivilegeComplicationAssessOperate;
                }
                    break;
                default:
                    break;
            }
            BOOL editPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeCreateDocumentMode Status:self.status OperateCode:operateMode];
            if (!editPrivilege)
            {
                [self showAlertMessage:@"对不起，您没有该权限。"];
                break;
            }
            [HMViewControllerManager createViewControllerWithControllerName:@"CDAFillAssessmentDocumentDetailViewController" ControllerObject:typeModel];
        }
            break;
        case 2:
        {
            //已填写，跳转到查看界面
            BOOL viewPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeCreateDocumentMode Status:self.status OperateCode:kPrivilegeViewOperate];
            if (!viewPrivilege)
            {
                [self showAlertMessage:@"对不起，您没有该权限。"];
                break;
            }
            CDAFilledAssessmentDocumentDetailViewController* vcDetail =  (CDAFilledAssessmentDocumentDetailViewController*)[HMViewControllerManager createViewControllerWithControllerName:@"CDAFilledAssessmentDocumentDetailViewController" ControllerObject:typeModel];
            [vcDetail setStatus:self.status];
        }
            break;
        default:
            break;
    }
}





#pragma mark TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    [self.tableView.superview closeWaitView];
    
    if (taskError != StepError_None) {
        [self showAlertMessage:errorMessage];
        return;
    }
    
    [self.tableView reloadData];
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
    
    if ([taskname isEqualToString:@"CDAHealthTemplateTypeListTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSArray class]])
        {
            [self makeTableSections:taskResult];
        }
    }
}
@end
