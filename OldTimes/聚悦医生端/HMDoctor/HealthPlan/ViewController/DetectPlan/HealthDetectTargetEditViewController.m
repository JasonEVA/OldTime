//
//  HealthDetectTargetEditViewController.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/17.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthDetectTargetEditViewController.h"
#import "HealthDetectTargetView.h"

@interface HealthDetectTargetEditViewController ()

@property (nonatomic, strong) NSString* kpiName;
@property (nonatomic, strong) NSString* kpiCode;
@property (nonatomic, strong) NSArray* targets;

@property (nonatomic, strong) UIView* targetsView;
@property (nonatomic, strong) NSMutableArray* targetEditViews;
@property (nonatomic, strong) UIView* commitView;
@property (nonatomic, strong) UIButton* commitButton;

@property (nonatomic, strong) HealthDetectPlanEditTarget editTargetBlock;

@end

@implementation HealthDetectTargetEditViewController

- (id) initWithKpiName:(NSString*) kpiName
               kpiCode:(NSString*) kpiCode
               targets:(NSArray*) targets
       editTargetBlock:(HealthDetectPlanEditTarget) editTargetBlock
{
    self = [super init];
    if (self) {
        _kpiName = kpiName;
        _kpiCode = kpiCode;
        _targets = targets;
        _editTargetBlock = editTargetBlock;
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.navigationItem.title= [NSString stringWithFormat:@"%@-目标", self.kpiName];
    
    [self layoutElements];
    
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.targetsView addGestureRecognizer:tapGesturRecognizer];
    
    [self createDetectTargetViews];
    
    [self.commitButton addTarget:self action:@selector(commitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) tapAction:(id) tag
{
    [self closeKeyboard];
}

- (void) layoutElements
{
    [self.targetsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-62);
    }];
    
    [self.commitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(@59);
    }];
    
    [self.commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.commitView).insets(UIEdgeInsetsMake(10, 12.5, 10, 12.5));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) createDetectTargetViews
{
    _targetEditViews = [NSMutableArray array];
    
    __block MASViewAttribute* targetTop = self.targetsView.mas_top;
    [self.targets enumerateObjectsUsingBlock:^(NSDictionary* targetDict, NSUInteger idx, BOOL * _Nonnull stop) {
        HealthDetectTargetView* targetView = [[HealthDetectTargetView alloc] init];
        [self.view addSubview:targetView];
        [self.targetEditViews addObject:targetView];
        
        [targetView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(@55);
            make.top.equalTo(targetTop);
            
        }];
        targetTop = targetView.mas_bottom;
        HealthDetectPlanTargetModel* targetModel = [HealthDetectPlanTargetModel mj_objectWithKeyValues:targetDict];
        [targetView setHealthDetectTarget:targetModel];
        
        
        [targetView addTarget:self action:@selector(closeKeyboard) forControlEvents:UIControlEventAllTouchEvents];
    }];
}

- (void) closeKeyboard
{
    [self.targetEditViews enumerateObjectsUsingBlock:^(HealthDetectTargetView* targetView, NSUInteger idx, BOOL * _Nonnull stop) {
        [targetView.targetValueTextField resignFirstResponder];
        [targetView.targetMaxValueTextField resignFirstResponder];
    }];
}

- (void) commitButtonClicked:(id) sender
{
//    NSMutableArray* editedTargetDictionarys = [NSMutableArray array];
    
    [self.targetEditViews enumerateObjectsUsingBlock:^(HealthDetectTargetView* targetView, NSUInteger idx, BOOL * _Nonnull stop) {
        HealthDetectPlanTargetModel* targetModel = self.targets[idx];
        
        NSString* targetValue = targetView.targetValueTextField.text;
        [targetModel setTargetValue:targetValue];
        
        NSString* targetMaxValue = targetView.targetMaxValueTextField.text;
        [targetModel setTargetMaxValue:targetMaxValue];
        
        if ((targetValue && targetValue.length > 0) ||
            (targetMaxValue && targetMaxValue.length > 0))
        {
            
            if (!targetValue || targetValue.length == 0)
            {
                [self showAlertMessage:@"请正确输入目标值。"];
                return ;
            }
            if (!targetMaxValue || targetMaxValue.length == 0)
            {
                [self showAlertMessage:@"请正确输入目标值。"];
                return ;
            }
            if (![targetValue isNumberString]) {
                [self showAlertMessage:@"请正确输入目标值。"];
                return ;
            }
            
            if (![targetMaxValue isNumberString]) {
                [self showAlertMessage:@"请正确输入目标值。"];
                return ;
            }
            
            if (targetValue.length > 6 || targetMaxValue.length > 6) {
                [self showAlertMessage:@"您的输入过长，请输入较短的数字。"];
                return ;
            }
            
            if (targetMaxValue.floatValue <= targetValue.floatValue) {
                [self showAlertMessage:@"请正确输入目标值。"];
                return ;
            }
        
        }
    }];
    
    if (self.editTargetBlock)
    {
        self.editTargetBlock(self.targets);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView*) targetsView
{
    if (!_targetsView) {
        _targetsView = [[UIView alloc] init];
        [self.view addSubview:_targetsView];
        [_targetsView setBackgroundColor:[UIColor whiteColor]];
    }
    
    return _targetsView;
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
        
        
    }
    return _commitButton;
}

@end
