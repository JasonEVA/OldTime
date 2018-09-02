//
//  HeathPlanFillFormEditViewController.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/24.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HeathPlanFillFormEditViewController.h"
#import "HealthPlanFillFormEditPeriodView.h"
#import "HealthDetectPeriodTypePickerViewController.h"
#import "HealthFillFormTemplateListViewController.h"

@interface HeathPlanFillFormEditTemplateControl : UIControl

@property (nonatomic, strong) UILabel* titleLable;
@property (nonatomic, strong) UILabel* templateNameLabel;
@property (nonatomic, strong) UIImageView* arrowImageView;

- (void) setHealthPlanDetCriteriaModel:(HealthPlanDetCriteriaModel*) model;
@end

@implementation HeathPlanFillFormEditTemplateControl

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self showBottomLine];
        [self layoutElements];
        
        
    }
    return self;
}

- (void) layoutElements
{
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12.5);
        make.centerY.equalTo(self);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(6, 10));
    }];
    
    [self.templateNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrowImageView.mas_left).offset(-7.5);
        make.left.greaterThanOrEqualTo(self.titleLable.mas_right).offset(5);
        make.centerY.equalTo(self);
    }];
}

- (void) setHealthPlanDetCriteriaModel:(HealthPlanDetCriteriaModel*) model
{
    [self.templateNameLabel setText:model.surveyMoudleName];
}

#pragma mark - settingAndGetting
- (UILabel*) titleLable
{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] init];
        [self addSubview:_titleLable];
        [_titleLable setFont:[UIFont systemFontOfSize:15]];
        [_titleLable setTextColor:[UIColor commonTextColor]];
    }
    return _titleLable;
}

- (UILabel*) templateNameLabel
{
    if (!_templateNameLabel) {
        _templateNameLabel = [[UILabel alloc] init];
        [self addSubview:_templateNameLabel];
        [_templateNameLabel setFont:[UIFont systemFontOfSize:15]];
        [_templateNameLabel setTextColor:[UIColor commonTextColor]];
    }
    return _templateNameLabel;
}

- (UIImageView*) arrowImageView
{
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_right_arrow"]];
        [self addSubview:_arrowImageView];
    }
    return _arrowImageView;
}

@end

@interface HeathPlanFillFormEditViewController ()

@property (nonatomic, strong) NSString* code;
@property (nonatomic, strong) HealthPlanDetCriteriaModel* criteriaModel;
@property (nonatomic, strong) HeathPlanFillFormEditHandle editHandle;

@property (nonatomic, strong) UIControl* editView;
@property (nonatomic, strong) HeathPlanFillFormEditTemplateControl* editTemplateControl;
@property (nonatomic, strong) HealthPlanFillFormEditPeriodView* editPeriodControl;

@property (nonatomic, strong) UIView* commitView;
@property (nonatomic, strong) UIButton* commitButton;

@end

@implementation HeathPlanFillFormEditViewController

- (id) initWithHealthPlanDetCriteriaModel:(HealthPlanDetCriteriaModel*) model
                                     code:(NSString*) code
                                   handle:(HeathPlanFillFormEditHandle) handle
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        NSDictionary* criteriaDictionary = model.mj_keyValues;
        _criteriaModel = [HealthPlanDetCriteriaModel mj_objectWithKeyValues:criteriaDictionary];
        _code = code;
        _editHandle = handle;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self.navigationItem setTitle:[NSString stringWithFormat:@"%@设置", [self codeTitle]]];
    [self layoutElements];
    
    [self.editTemplateControl.titleLable setText:[self codeTitle]];
    [self.editTemplateControl setHealthPlanDetCriteriaModel:self.criteriaModel];
    
    [self.editPeriodControl.titleLabel setText:[NSString stringWithFormat:@"%@频率", [self codeTitle]]];
    
    if (self.criteriaModel.periodValue && self.criteriaModel.periodValue.length > 0) {
        [self.editPeriodControl.periodValueTextField setText:self.criteriaModel.periodValue];
    }
    else
    {
        [self.editPeriodControl.periodValueTextField setText:@"1"];
    }
    
    HealthPlanEditPeriodControl* periodTypeControl = (HealthPlanEditPeriodControl*) self.editPeriodControl.periodTypeControl;
    
    if (self.criteriaModel.periodType && self.criteriaModel.periodType.length) {
        [periodTypeControl setPeriodTypeStr:self.criteriaModel.periodType];
    }
    else
    {
        [periodTypeControl setPeriodTypeStr:@"2"];
    }
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.editView addGestureRecognizer:tapGesturRecognizer];
    
    UITapGestureRecognizer *tapSecondGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSecondView:)];

    [self.editPeriodControl.periodTypeControl addGestureRecognizer:tapSecondGesture];
    
    UITapGestureRecognizer *tapTemplateGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTemplateView:)];
    
    [self.editTemplateControl addGestureRecognizer:tapTemplateGesture];
}

- (void)tapAction:(id) tag
{
    NSLog(@"tapAction %@", [tag class]);
    
    [self closeKeyboard];
}

- (void)tapSecondView:(id) tag
{
    [self closeKeyboard];
    
    __weak typeof(self) weakSelf = self;
    [HealthDetectPeriodTypePickerViewController showWithPeriodTypeStr:self.criteriaModel.periodType PeriodTypePickerBlock:^(NSString *pickertype) {
        if (!weakSelf) {
            return ;
        }
        __strong typeof(self) strongSelf = weakSelf;
        
        self.criteriaModel.periodType = pickertype;
        HealthPlanEditPeriodControl* periodTypeControl = (HealthPlanEditPeriodControl*) strongSelf.editPeriodControl.periodTypeControl;
        [periodTypeControl setPeriodTypeStr:pickertype];
    }];
}

- (void) tapTemplateView:(id) sender
{
    [self closeKeyboard];
    //模版列表
    __weak typeof(self) weakSelf = self;
    HealthFillFormTemplateListViewController* templatelistViewController = [[HealthFillFormTemplateListViewController alloc] initWithCode:self.code handle:^(HealthPlanFillFormTemplateModel *model) {
        if (!weakSelf) {
            return ;
        }
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.criteriaModel.surveyMoudleId = [NSString stringWithFormat:@"%ld", model.surveyMoudleId];
        strongSelf.criteriaModel.surveyMoudleName = model.surveyMoudleName;
        [strongSelf.editTemplateControl setHealthPlanDetCriteriaModel:self.criteriaModel];
    }];
    HMBaseNavigationViewController* templatelistNavigationController = [[HMBaseNavigationViewController alloc] initWithRootViewController:templatelistViewController];
    
    [self presentViewController:templatelistNavigationController animated:YES completion:nil];
}

- (void) closeKeyboard
{
    [self.editPeriodControl.periodValueTextField resignFirstResponder];
}

- (NSString*) codeTitle
{
    NSString* codeTitle = @"";
    if ([self.code isEqualToString:@"survey"]) {
        codeTitle = @"随访";
    }
    if ([self.code isEqualToString:@"assessment"]) {
        codeTitle = @"评估";
    }
    if ([self.code isEqualToString:@"wards"]) {
        codeTitle = @"查房";
    }
    return codeTitle;
}

- (NSDictionary*) controllerParamDictionary
{
    NSMutableDictionary* paramDictionary = [NSMutableDictionary dictionary];
    if (self.criteriaModel && self.criteriaModel.planId) {
        [paramDictionary setValue:self.criteriaModel.planId forKey:@"planId"];
    }
    
    return paramDictionary;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void) layoutElements
{
    [self.editView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-64);
    }];
    
    [self.editTemplateControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.editView);
        make.height.mas_equalTo(@57.5);
    }];
    
    [self.editPeriodControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.editView);
        make.height.mas_equalTo(@60);
        make.top.equalTo(self.editTemplateControl.mas_bottom);
    }];
    
    [self.commitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(@59);
    }];
    
    [self.commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.commitView).insets(UIEdgeInsetsMake(10, 12.5, 10, 12.5));
    }];
}

#pragma mark - Control click event
- (void) commitButtonClicked:(id) sender
{
    NSString* periodValueText = self.editPeriodControl.periodValueTextField.text;
    if (!periodValueText && periodValueText.length == 0) {
        
        [self showAlertMessage:@"请正确输入。"];
        return;
    }
    if (![periodValueText mj_isPureInt] ||
        periodValueText.integerValue <= 0) {
        [self showAlertMessage:@"请正确输入。"];
        return;

    }
    if (![periodValueText mj_isPureInt] && periodValueText.integerValue == 0) {
        [self showAlertMessage:@"请正确输入。"];
        return;
    }
    self.criteriaModel.periodValue = periodValueText;
    
    if (!self.criteriaModel.surveyMoudleName || self.criteriaModel.surveyMoudleName.length == 0) {
        [self showAlertMessage:@"请选择模版。"];
        return;
    }
    if (!self.criteriaModel.surveyMoudleId || self.criteriaModel.surveyMoudleId.length == 0) {
        [self showAlertMessage:@"请选择模版。"];
        return;
    }
    
    if (self.editHandle) {
        self.editHandle(self.criteriaModel);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - settingAndGetting

- (UIControl*) editView
{
    if (!_editView)
    {
        _editView = [[UIControl alloc] init];
        [self.view addSubview:_editView];
        [_editView setBackgroundColor:[UIColor whiteColor]];
    }
    return _editView;
}

- (HeathPlanFillFormEditTemplateControl*) editTemplateControl
{
    if (!_editTemplateControl) {
        _editTemplateControl = [[HeathPlanFillFormEditTemplateControl alloc] init];
        [self.editView addSubview:_editTemplateControl];
    }
    return _editTemplateControl;
}

- (HealthPlanFillFormEditPeriodView*) editPeriodControl
{
    if (!_editPeriodControl)
    {
        _editPeriodControl = [[HealthPlanFillFormEditPeriodView alloc] init];
        [self.editView addSubview:_editPeriodControl];
    }
    return _editPeriodControl;
}

- (UIView*) commitView
{
    if (!_commitView) {
        _commitView = [[UIView alloc] init];
        [self.view addSubview:_commitView];
        [_commitView setBackgroundColor:[UIColor whiteColor]];
    }
    return _commitView;
}

- (UIButton*) commitButton
{
    if (!_commitButton) {
        _commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.commitView addSubview:_commitButton];
        
        [_commitButton setTitle:@"保存" forState:UIControlStateNormal];
        [_commitButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        
        [_commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_commitButton setBackgroundImage:[UIImage rectImage:CGSizeMake(120, 45) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
        _commitButton.layer.cornerRadius = 4;
        _commitButton.layer.masksToBounds = YES;
        [_commitButton addTarget:self action:@selector(commitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitButton;
}


@end
