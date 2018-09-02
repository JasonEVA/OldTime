//
//  HealthPlanMentailitDetailViewController.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/28.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanMentailitDetailViewController.h"
#import "HealthPlanMentailityPeriodPickerViewController.h"

@interface HealthPlanMentailitPeriodEditControl : UIControl

@property (nonatomic, strong) UILabel* titleLable;
@property (nonatomic, strong) UILabel* periodLable;
@property (nonatomic, strong) UIImageView* arrowImageView;

- (void) setHealthPlanDetCriteriaModel:(HealthPlanDetCriteriaModel*) criteriaModel;

@end

@implementation HealthPlanMentailitPeriodEditControl

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
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(12.5);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-12.5);
        make.size.mas_equalTo(CGSizeMake(8, 15));
    }];
    
    [self.periodLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.arrowImageView.mas_left).offset(-7.5);
    }];
}

- (void) setHealthPlanDetCriteriaModel:(HealthPlanDetCriteriaModel*) criteriaModel
{
    [self.periodLable setText:criteriaModel.mentalityPeriodString];
}

#pragma mark - settingAndGetting
- (UILabel*) titleLable
{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] init];
        [self addSubview:_titleLable];
        [_titleLable setText:@"记录心情"];
        
        [_titleLable setFont:[UIFont systemFontOfSize:15]];
        [_titleLable setTextColor:[UIColor commonTextColor]];
    }
    return _titleLable;
}

- (UILabel*) periodLable
{
    if (!_periodLable) {
        _periodLable = [[UILabel alloc] init];
        [self addSubview:_periodLable];
        
        [_periodLable setFont:[UIFont systemFontOfSize:15]];
        [_periodLable setTextColor:[UIColor commonTextColor]];
    }
    return _periodLable;
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

@interface HealthPlanMentailitDetailViewController ()

@property (nonatomic, strong) NSString* status;
@property (nonatomic, strong) HealthPlanDetailSectionModel* detailModel;
@property (nonatomic, strong) HealthPlanDetCriteriaModel* criteriaModel;

@property (nonatomic, strong) HealthPlanMentailitPeriodEditControl* editPeriodControl;

@end

@implementation HealthPlanMentailitDetailViewController

- (id) initWithDetailModel:(HealthPlanDetailSectionModel*) detailModel status:(NSString*) status
{
    self = [super init];
    if (self) {
        _detailModel = detailModel;
        _criteriaModel = [self.detailModel.criterias firstObject];
        _status = status;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationItem setTitle:self.detailModel.title];
    [self layoutElements];
    
    [self.editPeriodControl setHealthPlanDetCriteriaModel:self.criteriaModel];
    [self.editPeriodControl addTarget:self action:@selector(editPeriodControlClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) layoutElements
{
    [self.editPeriodControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(@56);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) editPeriodControlClicked:(id) sender
{
    BOOL staffPrivilege = [HealthPlanUtil staffHasEditPrivilege:self.status];
    if (!staffPrivilege) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [HealthPlanMentailityPeriodPickerViewController showWithPeriodType:self.criteriaModel.periodType
                                                           periodValue:self.criteriaModel.periodValue
                                                                handle:^(NSString *periodValue, NSString *periodType)
     {
         if (!weakSelf) {
             return ;
         }
         __strong typeof(self) strongSelf = weakSelf;
         strongSelf.criteriaModel.periodValue = periodValue;
         strongSelf.criteriaModel.periodType = periodType;
         
         [strongSelf.editPeriodControl setHealthPlanDetCriteriaModel:self.criteriaModel];
         
         [HealthPlanUtil postEditNotification];
     }];
}

#pragma mark settingAndGetting
- (HealthPlanMentailitPeriodEditControl*) editPeriodControl
{
    if (!_editPeriodControl) {
        _editPeriodControl = [[HealthPlanMentailitPeriodEditControl alloc] init];
        [self.view addSubview:_editPeriodControl];
    }
    return _editPeriodControl;
}

@end
