//
//  DocumentDiseaseSelectViewController.m
//  HMDoctor
//
//  Created by yinqaun on 16/8/23.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "DocumentDiseaseSelectViewController.h"
#import "CoordinationDepartmentModel.h"
#import "CreateDocumetnMessionInfo.h"

@interface DocumentDiseaseSelectView : UIView

@property (nonatomic, readonly) UIView* tileView;
@property (nonatomic, readonly) UILabel* deptLable;
@property (nonatomic, readonly) UILabel* diseaseLable;

@property (nonatomic, readonly) UIPickerView* selectPicker;
@property (nonatomic, readonly) UIView* bottomView;
@property (nonatomic, readonly) UIButton* confirmButton;
@end

@implementation DocumentDiseaseSelectView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        _tileView = [[UIView alloc]init];
        [self addSubview:_tileView];
        [_tileView setBackgroundColor:[UIColor whiteColor]];
        [_tileView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self);
            make.top.equalTo(self);
            make.height.mas_equalTo(@55);
        }];
        
        _deptLable = [[UILabel alloc]init];
        [_tileView addSubview:_deptLable];
        [_deptLable setText:@"选择科室"];
        [_deptLable setFont:[UIFont systemFontOfSize:13]];
        [_deptLable setTextAlignment:NSTextAlignmentCenter];
        [_deptLable setTextColor:[UIColor commonGrayTextColor]];
        [_deptLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.tileView);
            make.top.and.bottom.equalTo(self.tileView);
        }];
        
        _diseaseLable = [[UILabel alloc]init];
        [_tileView addSubview:_diseaseLable];
        [_diseaseLable setText:@"选择疾病"];
        [_diseaseLable setFont:[UIFont systemFontOfSize:13]];
        [_diseaseLable setTextAlignment:NSTextAlignmentCenter];
        [_diseaseLable setTextColor:[UIColor commonGrayTextColor]];
        [_diseaseLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.tileView);
            make.width.equalTo(_deptLable);
            make.left.equalTo(_deptLable.mas_right);
            make.top.and.bottom.equalTo(self.tileView);
        }];
        
        _selectPicker = [[UIPickerView alloc]init];
        [self addSubview:_selectPicker];
        [_selectPicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self);
            make.top.equalTo(self.tileView.mas_bottom);
        }];
        
        _bottomView = [[UIView alloc]init];
        [_bottomView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:_bottomView];
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self);
            make.bottom.equalTo(self);
            make.height.mas_equalTo(@55);
            make.top.equalTo(self.selectPicker.mas_bottom);
        }];
        
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomView addSubview:_confirmButton];
        [_confirmButton setBackgroundImage:[UIImage rectImage:CGSizeMake(150, 45) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
        [_confirmButton setTitle:@"确认" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        
        [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(150, 45));
            make.center.equalTo(_bottomView);
        }];
        
        _confirmButton.layer.cornerRadius = 2.5;
        _confirmButton.layer.masksToBounds = YES;

        self.layer.cornerRadius = 2.5;
        self.layer.masksToBounds = YES;
    }
    return self;
}

@end



@interface DocumentDiseaseSelectViewController ()
<TaskObserver, UIPickerViewDelegate, UIPickerViewDataSource>
{
    DocumentDiseaseSelectView* selectView;
    NSArray* standardDepartList;        //标准科室列表
    NSArray* templateList;
    
}

@property (nonatomic, retain) CreateDocumetnMessionInfo* messionModel;
@property (nonatomic, strong) DocumentDiseaseSelectedBlock selectedBlock;
@end

@implementation DocumentDiseaseSelectViewController

- (void) loadView
{
    UIControl* closeControl = [[UIControl alloc]init];
    [self setView:closeControl];
    [closeControl addTarget:self action:@selector(closeController) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5]];
    
    
    
    selectView = [[DocumentDiseaseSelectView alloc]init];
    [self.view addSubview:selectView];
    [selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(12.5);
        make.right.equalTo(self.view).with.offset(-12.5);
        make.centerY.equalTo(self.view);
    }];
    
    [selectView.selectPicker setDataSource:self];
    [selectView.selectPicker setDelegate:self];
    
    [self loadStandDepartList];
    
    [selectView.confirmButton addTarget:self action:@selector(confirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (void) showInParentController:(UIViewController*) parentController
                   messionModel:(CreateDocumetnMessionInfo*) messionModel
                  selectedBlock:(DocumentDiseaseSelectedBlock) block
{
    if (!parentController)
    {
        return;
    }
    DocumentDiseaseSelectViewController* vcSelect = [[DocumentDiseaseSelectViewController alloc]init];
    [parentController addChildViewController: vcSelect];
    [parentController.view addSubview:vcSelect.view];
    [vcSelect.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(parentController.view);
        make.top.and.bottom.equalTo(parentController.view);
    }];
    
    if (messionModel)
    {
        [vcSelect setMessionModel:messionModel];
    }
    
    [vcSelect setSelectedBlock:block];
}

- (void) closeController
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

//获取标准科室列表
- (void) loadStandDepartList
{
    [self.view showWaitView];
    //StandDepartmentListTask
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", staff.orgId] forKey:@"orgId"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"StandDepartmentListTask" taskParam:dicPost TaskObserver:self];
}

- (void) confirmButtonClicked:(id) sender
{
    if (!templateList || 0 == templateList.count)
    {
        [self showAlertMessage:@"没能获取到疾病列表。"];
        return;
    }
    NSInteger tempIndex = [selectView.selectPicker selectedRowInComponent:1];
    CreateDocumetnTemplateModel* model = templateList[tempIndex];
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    if (_messionModel && _messionModel.assessmentReportId)
    {
        [dicPost setValue:_messionModel.assessmentReportId forKey:@"assessmentReportId"];
    }
    else
    {
        return;
    }
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    [dicPost setValue:[NSNumber numberWithInteger:staff.userId] forKey:@"createUserId"];
    [dicPost setValue:model.templateId forKey:@"templateId"];
    [dicPost setValue:model.templateName forKey:@"templateName"];
    
    //初始化用户健康档案报告信息
    [self.view showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"CreateDocumentInitTemplateListTask" taskParam:dicPost TaskObserver:self];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component)
    {
        case 0:
            if (standardDepartList)
            {
                return standardDepartList.count;
            }
            break;
        case 1:
            {
                if (templateList)
                {
                    return templateList.count;
                }
                break;
            }
        default:
            break;
    }
    
    return 0;
}



#pragma mark - UIPickerViewDelegate
- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component)
    {
        case 0:
        {
            if (standardDepartList && row < standardDepartList.count)
            {
                CoordinationDepartmentModel* depart = standardDepartList[row];
                return depart.depName;
            }
            break;
        }
        case 1:
        {
            if (templateList && row < templateList.count)
            {
                CreateDocumetnTemplateModel* model = templateList[row];
                return model.templateName;
            }
            break;
        }
            
        default:
            break;
    }
    return @"";
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextColor:[UIColor commonGrayTextColor]];
        
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:12]];
        
        
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component)
    {
        case 0:
        {
            CoordinationDepartmentModel* depart = standardDepartList[row];
            //获取标准科室下疾病模版列表
            NSDictionary* dicPost = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:depart.depId] forKey:@"deptId"];
            [[TaskManager shareInstance] createTaskWithTaskName:@"CreateDocumentTemplateListTask" taskParam:dicPost TaskObserver:self];
            break;
        }
        default:
            break;
    }
}


#pragma mark TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    [self.view closeWaitView];
    
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    
    if ([taskname isEqualToString:@"CreateDocumentInitTemplateListTask"])
    {
        if (taskError != StepError_None)
        {
            [self showAlertMessage:errorMessage];
            return;
        }
        
        //选择疾病成功，关闭选择Controller
        if (_selectedBlock)
        {
            NSInteger tempIndex = [selectView.selectPicker selectedRowInComponent:1];
            CreateDocumetnTemplateModel* model = templateList[tempIndex];
            _selectedBlock(YES, model);
        }
        [self closeController];
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
    
    if ([taskname isEqualToString:@"StandDepartmentListTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSArray class]])
        {
            standardDepartList = (NSArray*) taskResult;
            [selectView.selectPicker reloadAllComponents];
            if (standardDepartList && standardDepartList.count > 0)
            {
                CoordinationDepartmentModel* depart = standardDepartList[0];
                //获取标准科室下疾病模版列表
                NSDictionary* dicPost = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:depart.depId] forKey:@"deptId"];
                [[TaskManager shareInstance] createTaskWithTaskName:@"CreateDocumentTemplateListTask" taskParam:dicPost TaskObserver:self];
            }
        }
        return;
    }
    
    if ([taskname isEqualToString:@"CreateDocumentTemplateListTask"])
    {
        NSDictionary* dicParam = [TaskManager taskparamWithTaskId:taskId];
        if (!dicParam || ![dicParam isKindOfClass:[NSDictionary class]])
        {
            return;
        }
        NSNumber* numDeptId = [dicParam valueForKey:@"deptId"];
        if (!numDeptId || ![numDeptId isKindOfClass:[NSNumber class]])
        {
            return;
        }
        
        NSInteger index = [selectView.selectPicker selectedRowInComponent:0];
        CoordinationDepartmentModel* depart = standardDepartList[index];
        if (depart.depId != numDeptId.integerValue)
        {
            return;
        }
        if (taskResult && [taskResult isKindOfClass:[NSArray class]])
        {
            templateList = (NSArray*) taskResult;
            [selectView.selectPicker reloadComponent:1];
        }
        return;
    }
    
    if ([taskname isEqualToString:@"CreateDocumentInitTemplateListTask"])
    {
        
    }
    
    
}
@end
