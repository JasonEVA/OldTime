//
//  HealthPlanReviewEditViewController.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/30.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanReviewEditViewController.h"
#import "HealthPlanFillFormEditPeriodView.h"
#import "HealthPlanReviewIndicesTableViewController.h"
#import "HealthDetectPeriodTypePickerViewController.h"

@interface HealthPlanReviewEditTemplateControl : UIControl

@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* templateLabel;
@property (nonatomic, strong) UIImageView* arrowImageView;

- (void) setHealthPlanDetCriteriaModel:(HealthPlanDetCriteriaModel*) model;

@end

@implementation HealthPlanReviewEditTemplateControl

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self showBottomLine];
        [self layoutElements];
    }
    return self;
}

- (void) layoutElements
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12.5);
        make.centerY.equalTo(self);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(6, 10));
    }];
    
    [self.templateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrowImageView.mas_left).offset(-7.5);
        make.left.greaterThanOrEqualTo(self.titleLabel.mas_right).offset(5);
        make.centerY.equalTo(self);
    }];
}

- (void) setHealthPlanDetCriteriaModel:(HealthPlanDetCriteriaModel*) model
{
    [self.templateLabel setText:model.indicesName];
}

#pragma mark - settingAndGetting
- (UILabel*) titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [self addSubview:_titleLabel];
        [_titleLabel setText:@"复查项目"];
        [_titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_titleLabel setTextColor:[UIColor commonTextColor]];
    }
    return _titleLabel;
}

- (UILabel*) templateLabel
{
    if (!_templateLabel) {
        _templateLabel = [[UILabel alloc] init];
        [self addSubview:_templateLabel];
        [_templateLabel setFont:[UIFont systemFontOfSize:15]];
        [_templateLabel setTextColor:[UIColor commonTextColor]];
    }
    return _templateLabel;
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

@interface HealthPlanReviewEditViewController ()

@property (nonatomic, strong) HealthPlanDetCriteriaModel* criteriaModel;
@property (nonatomic, strong) HeathPlanReviewEditHandle editHandle;

@property (nonatomic, strong) HealthPlanReviewEditTemplateControl* templateControl;
@property (nonatomic, strong) HealthPlanFillFormEditPeriodView* periodView;

@property (nonatomic, strong) UIView* commitView;
@property (nonatomic, strong) UIButton* commitButton;

@end

@implementation HealthPlanReviewEditViewController

- (id) initWithHealthPlanDetCriteriaModel:(HealthPlanDetCriteriaModel*) model
                                   handle:(HeathPlanReviewEditHandle) handle
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        NSDictionary* criteriaDictionary = model.mj_keyValues;
        _criteriaModel = [HealthPlanDetCriteriaModel mj_objectWithKeyValues:criteriaDictionary];
        _editHandle = handle;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"复查设置";
    
    [self layoutElements];
    [self.templateControl setHealthPlanDetCriteriaModel:self.criteriaModel];
    
    [self.periodView.titleLabel setText:@"复查频率"];
    
    if (self.criteriaModel.periodValue && self.criteriaModel.periodValue.length > 0) {
        [self.periodView.periodValueTextField setText:self.criteriaModel.periodValue];
    }
    else
    {
        [self.periodView.periodValueTextField setText:@"1"];
    }
    
    HealthPlanEditPeriodControl* periodTypeControl = (HealthPlanEditPeriodControl*) self.periodView.periodTypeControl;
    
    if (self.criteriaModel.periodType && self.criteriaModel.periodType.length) {
        [periodTypeControl setPeriodTypeStr:self.criteriaModel.periodType];
    }
    else
    {
        [periodTypeControl setPeriodTypeStr:@"2"];
    }
    
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tapGesturRecognizer];
    
    UITapGestureRecognizer *tapSecondGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPeriodView:)];
    
    [self.periodView.periodTypeControl addGestureRecognizer:tapSecondGesture];
    
    UITapGestureRecognizer *tapTemplateGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTemplateView:)];
    
    [self.templateControl addGestureRecognizer:tapTemplateGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) layoutElements
{
    [self.templateControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(@58);
    }];
    
    [self.periodView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.templateControl.mas_bottom);
        make.height.mas_equalTo(@58);
    }];
    
    [self.commitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(@59);
    }];
    
    [self.commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.commitView).insets(UIEdgeInsetsMake(10, 12.5, 10, 12.5));
    }];
}

- (void) closeKeyboard
{
    [self.periodView.periodValueTextField resignFirstResponder];
}


#pragma mark - Control Event
- (void)tapAction:(id) tag
{
    NSLog(@"tapAction %@", [tag class]);
    
    [self closeKeyboard];
}

- (void)tapPeriodView:(id) tag
{
    [self closeKeyboard];
    //频率修改
    __weak typeof(self) weakSelf = self;
    [HealthDetectPeriodTypePickerViewController showWithPeriodTypeStr:self.criteriaModel.periodType PeriodTypePickerBlock:^(NSString *pickertype) {
        if (!weakSelf) {
            return ;
        }
        __strong typeof(self) strongSelf = weakSelf;
        
        self.criteriaModel.periodType = pickertype;
        HealthPlanEditPeriodControl* periodTypeControl = (HealthPlanEditPeriodControl*) strongSelf.periodView.periodTypeControl;
        [periodTypeControl setPeriodTypeStr:pickertype];
    }];
}

- (void) tapTemplateView:(id) sender
{
    [self closeKeyboard];
    //模版列表
    __weak typeof(self) weakSelf = self;
    HealthPlanReviewIndicesTableViewController* tableViewController =[[HealthPlanReviewIndicesTableViewController alloc] initWithHandle:^(HealthPlanReviewIndicesModel *model) {
        if (!weakSelf) {
            return ;
        }
        
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.criteriaModel.indicesName = model.name;
        strongSelf.criteriaModel.indicesCode = model.id;
        [strongSelf.templateControl setHealthPlanDetCriteriaModel:self.criteriaModel];

    }];
    HMBaseNavigationViewController* indiceNavigationController = [[HMBaseNavigationViewController alloc] initWithRootViewController:tableViewController];
    [self.navigationController presentViewController:indiceNavigationController animated:YES completion:nil];
    
}

- (void) commitButtonClicked:(id) sender
{
    NSString* periodValueText = self.periodView.periodValueTextField.text;
    if (!periodValueText && periodValueText.length == 0) {
        [self showAlertMessage:@"请正确输入。"];
        return;
    }
    if (![periodValueText mj_isPureInt] && periodValueText.integerValue == 0) {
        [self showAlertMessage:@"请正确输入。"];
        return;
    }
    self.criteriaModel.periodValue = periodValueText;
    
    if (!self.criteriaModel.indicesName || self.criteriaModel.indicesName.length == 0) {
        [self showAlertMessage:@"请选择模版。"];
        return;
    }
    if (!self.criteriaModel.indicesCode || self.criteriaModel.indicesCode.length == 0) {
        [self showAlertMessage:@"请选择模版。"];
        return;
    }
    
    if (self.editHandle) {
        self.editHandle(self.criteriaModel);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - settingAndGetting
- (HealthPlanReviewEditTemplateControl*) templateControl
{
    if (!_templateControl) {
        _templateControl = [[HealthPlanReviewEditTemplateControl alloc] init];
        [self.view addSubview:_templateControl];
    }
    return _templateControl;
}

- (HealthPlanFillFormEditPeriodView*) periodView
{
    if (!_periodView) {
        _periodView = [[HealthPlanFillFormEditPeriodView alloc] init];
        [self.view addSubview:_periodView];
        [_periodView setBackgroundColor:[UIColor whiteColor]];
    }
    return _periodView;
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
