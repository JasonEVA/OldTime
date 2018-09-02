//
//  HealthDetectPeriodEditViewController.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/18.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthDetectPeriodEditViewController.h"
#import "HealthDetectPeriodEditView.h"
#import "HealthDetectPeriodTypePickerViewController.h"
#import "HealthDetectAlertTimesViewController.h"

@interface HealthDetectPeriodEditViewController ()
{
    NSString* periodTypeString;
}
@property (nonatomic, strong) HealthPlanDetCriteriaModel* criteriaModel;

@property (nonatomic, strong) HealthDetectPeriodEditView* periodEditView;
@property (nonatomic, strong) HealthDetectAlertTimesViewController* alertTimesViewController;

@property (nonatomic, strong) UIView* commitView;
@property (nonatomic, strong) UIButton* commitButton;
@end

@implementation HealthDetectPeriodEditViewController


- (id) initWithCriteriaModel:(HealthPlanDetCriteriaModel*) criteriaModel
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _criteriaModel = criteriaModel;
        periodTypeString = self.criteriaModel.periodType;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title= [NSString stringWithFormat:@"%@-频率", self.criteriaModel.kpiTitle];
    
    [self layoutElements];
    [self.periodEditView setHealthPlanDetCriteriaModel:self.criteriaModel];
    
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    
    UITapGestureRecognizer *secondGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSecondView:)];
    
    [self.view addGestureRecognizer:tapGesturRecognizer];
    [self.periodEditView.periodTypeControl addGestureRecognizer:secondGesturRecognizer];
}

- (void) tapAction:(id) tag
{
    [self closeKeyboard];
}

- (void)tapSecondView:(id) tag
{
    [self closeKeyboard];
    
    __weak typeof(self) weakSelf = self;
    [HealthDetectPeriodTypePickerViewController showWithPeriodTypeStr:periodTypeString PeriodTypePickerBlock:^(NSString *pickertype) {
        __strong typeof(self) strongSelf = weakSelf;
        periodTypeString = pickertype;
        [strongSelf.periodEditView setPeriodTypeString:pickertype];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) layoutElements
{
    [self.periodEditView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(@59);
    }];
    
    [self.alertTimesViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.periodEditView.mas_bottom);
        make.bottom.equalTo(self.view).offset(-62);
    }];
    
    [self.commitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(@58.5);
    }];
    
    [self.commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.commitView).insets(UIEdgeInsetsMake(10, 12.5, 10, 12.5));
    }];
    
}

- (void) closeKeyboard
{
    [self.periodEditView.periodValueTextField resignFirstResponder];
}

- (void) commitButtonClicked:(id) sender
{
    NSString* periodValue = self.periodEditView.periodValueTextField.text;
    if (!periodValue || periodValue.length == 0) {
        [self showAlertMessage:@"请正确输入。"];
        return;
    }
    
    if (!periodTypeString || periodTypeString.length == 0) {
        [self showAlertMessage:@"请正确输入。"];
        return;
    }
    
//    NSArray* alerttimes = self.alertTimesViewController.alertTimeModels;
//    if (!alerttimes || alerttimes.count == 0) {
//        [self showAlertMessage:@"请输入提醒时间。"];
//        return;
//    }
    
    self.criteriaModel.periodType = periodTypeString;
    self.criteriaModel.periodValue = periodValue;
    
    self.criteriaModel.alertTimes = [NSArray arrayWithArray:self.alertTimesViewController.alertTimeModels];
    if (self.alertTimesBlock) {
        self.alertTimesBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - settingAndGetting
- (HealthDetectPeriodEditView*) periodEditView
{
    if (!_periodEditView) {
        _periodEditView = [[HealthDetectPeriodEditView alloc] init];
        [self.view addSubview:_periodEditView];
    }
    return _periodEditView;
}

- (HealthDetectAlertTimesViewController*) alertTimesViewController
{
    __weak typeof(self) weakSelf = self;
    if (!_alertTimesViewController) {
        __strong typeof(self) strongSelf = weakSelf;
        _alertTimesViewController = [[HealthDetectAlertTimesViewController alloc] initWithAlertTimesModels:strongSelf.criteriaModel.alertTimes countBlock:^(NSInteger count) {
            [strongSelf.periodEditView setAlertTimesCount:count];
        }];
        [strongSelf addChildViewController:_alertTimesViewController];
        [strongSelf.view addSubview:_alertTimesViewController.view];
        
    }
    return _alertTimesViewController;
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
        [_commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_commitButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_commitButton setBackgroundImage:[UIImage rectImage:CGSizeMake(120, 45) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
        _commitButton.layer.cornerRadius = 4;
        _commitButton.layer.masksToBounds = YES;
        
        [_commitButton addTarget:self action:@selector(commitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitButton;
    
}


@end
