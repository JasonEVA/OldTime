//
//  HealthDetectWarningEditViewController.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/21.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthDetectWarningEditViewController.h"
#import "HealthDetectWarningTypeView.h"
#import "HealthDetectWaringTypePickerViewController.h"
#import "HealthDetectWarningValueView.h"
#import "HealtDetectWarningKpiPickerViewController.h"
#import "HealthDetectWarningRelationPickerViewController.h"

@interface HealthDetectWarningEditViewController ()

{
    HealthDetectWarningType warningType;
    NSArray* subKpiList;
    
}
@property (nonatomic, strong) HealthDetectPlanWarningModel* waringModel;
@property (nonatomic, strong) NSString* kpiTitle;
@property (nonatomic, strong) NSString* kpiCode;

@property (nonatomic, strong) UIControl* waringValuesView;

@property (nonatomic, strong) HealthDetectWarningValueView* firstWarningValueView;
@property (nonatomic, strong) HealthDetectWarningRelationView* relationView;
@property (nonatomic, strong) HealthDetectWarningValueView* secondWarningValueView;

@property (nonatomic, strong) HealthDetectWarningTypeView* warningTypeView;
@property (nonatomic, strong) UIView* commitView;
@property (nonatomic, strong) UIButton* commitButton;

@end

@implementation HealthDetectWarningEditViewController

- (id) initWithHealthDetectPlanWarningModel:(HealthDetectPlanWarningModel*) warningModel
                                   kpiTitle:(NSString*) kpiTitle
                                    kpiCode:(NSString*) kpiCode
{
    self = [super init];
    if (self) {
//        _waringModel = warningModel;
        NSMutableDictionary* warningDict = [[warningModel mj_keyValues] mutableCopy];
        _waringModel = [HealthDetectPlanWarningModel mj_objectWithKeyValues:warningDict];
//        warningType = [self.waringModel warningIdentificationType];
        warningType = self.waringModel.signsId.integerValue;
        
        _kpiTitle = kpiTitle;
        _kpiCode = kpiCode;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title= [NSString stringWithFormat:@"%@-预警", self.kpiTitle];

    [self layoutElements];
    [self.warningTypeView setWarningType:[self.waringModel warningIdentificationTypeString]];
    
    [self.warningTypeView.typeControl addTarget:self action:@selector(typeControlClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self createWarningValueViews];
    
    subKpiList = [[HealthPlanUtil shareInstance] warningKpiList:self.kpiCode];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) layoutElements
{
    [self.warningTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(@58);
    }];
    
    [self.waringValuesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.warningTypeView.mas_bottom);
        make.bottom.equalTo(self.view).offset(-64);
    }];
    
    [self.commitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(@59);
    }];
    
    [self.commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.commitView).insets(UIEdgeInsetsMake(10, 12.5, 10, 12.5));
    }];
}



- (void) createWarningValueViews
{
    NSArray* subviews = [self.waringValuesView subviews];
    [subviews enumerateObjectsUsingBlock:^(UIView* subview, NSUInteger idx, BOOL * _Nonnull stop) {
        [subview removeFromSuperview];
    }];
    
    if ([self.kpiCode isEqualToString:@"XY"]) {
        //血压
        
        self.waringModel.oneKpiCode = @"SSY";
        self.waringModel.oneKpiId = 21;
        self.waringModel.oneKpiName = @"收缩压";
        
        self.waringModel.twoKpiCode = @"SZY";
        self.waringModel.twoKpiId = 22;
        self.waringModel.twoKpiName = @"舒张压";
        
        Class viewClass = NSClassFromString(@"HealthDetectBloodPressureWarningValueView");
        switch (warningType) {
            case WarningType_Unknown:
            {
                break;
            }
            case WarningType_Custom:
            {
                viewClass = NSClassFromString(@"HealthDetectBloodPressureWarningValueView");
                break;
            }
            case WarningType_High:
            {
                viewClass = NSClassFromString(@"HealthDetectBloodPressureWarningHighValueView");
                break;
            }
            case WarningType_Low:
            {
                viewClass = NSClassFromString(@"HealthDetectBloodPressureWarningLowValueView");
                break;
            }
        }
        
        _firstWarningValueView = [[viewClass alloc] init];
        [self.waringValuesView addSubview:self.firstWarningValueView];
        
        [self.firstWarningValueView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.waringValuesView);
            make.height.mas_equalTo(@57);
        }];
        
        HealthDetectWarningValueModel* warningValueModel = [[HealthDetectWarningValueModel alloc] init];
        warningValueModel.oneBeginValue = self.waringModel.oneBeginValue;
        warningValueModel.oneEndValue = self.waringModel.oneEndValue;
        warningValueModel.oneKpiName = self.waringModel.oneKpiName;
        warningValueModel.oneKpiCode = self.waringModel.oneKpiCode;
        
        [self.firstWarningValueView setHealthDetectWarningValueModel:warningValueModel];
        
        _relationView = [[HealthDetectWarningRelationView alloc] init];
        [self.waringValuesView addSubview:_relationView];
        [self.relationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.waringValuesView);
            make.top.equalTo(self.firstWarningValueView.mas_bottom);
            make.height.mas_equalTo(@57);
        }];
        if (self.waringModel.oneTwoRelation) {
            [_relationView setRelation:self.waringModel.oneTwoRelation];
        }
        else
        {
            [_relationView setRelation:@"||"];
        }
        
                
        _secondWarningValueView = [[viewClass alloc] init];
        [self.waringValuesView addSubview:self.secondWarningValueView];
        
        [self.secondWarningValueView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.waringValuesView);
            make.top.equalTo(self.relationView.mas_bottom);
            make.height.mas_equalTo(@57);
        }];
        
        HealthDetectWarningValueModel* secondwarningValueModel = [[HealthDetectWarningValueModel alloc] init];
        secondwarningValueModel.oneBeginValue = self.waringModel.twoBeginValue;
        secondwarningValueModel.oneEndValue = self.waringModel.twoEndValue;
        secondwarningValueModel.oneKpiName = self.waringModel.twoKpiName;
        secondwarningValueModel.oneKpiCode = self.waringModel.twoKpiCode;
        
        [self.secondWarningValueView setHealthDetectWarningValueModel:secondwarningValueModel];
        
    }
    else
    {
        Class viewClass = NSClassFromString(@"HealthDetectWarningValueView");
        switch (warningType) {
            case WarningType_Unknown:
            {
                break;
            }
            case WarningType_Custom:
            {
                viewClass = NSClassFromString(@"HealthDetectWarningValueView");
                break;
            }
            case WarningType_High:
            {
                viewClass = NSClassFromString(@"HealthDetectWarningHighValueView");
                break;
            }
            case WarningType_Low:
            {
                viewClass = NSClassFromString(@"HealthDetectWarningLowValueView");
                break;
            }
        }
        
        _firstWarningValueView = [[viewClass alloc] init];
        [self.waringValuesView addSubview:self.firstWarningValueView];
        
        [self.firstWarningValueView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.waringValuesView);
            make.height.mas_equalTo(@57);
        }];
        
        HealthDetectWarningValueModel* warningValueModel = [[HealthDetectWarningValueModel alloc] init];
        warningValueModel.oneBeginValue = self.waringModel.oneBeginValue;
        warningValueModel.oneEndValue = self.waringModel.oneEndValue;
        warningValueModel.oneKpiName = self.waringModel.oneKpiName;
        warningValueModel.oneKpiCode = self.waringModel.oneKpiCode;
        
        [self.firstWarningValueView setHealthDetectWarningValueModel:warningValueModel];
        
        [self.firstWarningValueView.kipControl addTarget:self action:@selector(kpiControlClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

#pragma mark - control clicked event

- (void) closeControlClicked:(id) sender
{
    [self closeAllKeyboard];
}

- (void) closeAllKeyboard
{
    NSArray* subviews = [self.waringValuesView subviews];
    [subviews enumerateObjectsUsingBlock:^(UIView* subview, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![subview isKindOfClass:[HealthDetectWarningValueView class]])
        {
            return;
        }
        HealthDetectWarningHighValueView* valueView = (HealthDetectWarningHighValueView*) subview;
        [valueView.oneEndValueTextField resignFirstResponder];
        [valueView.oneBeginValueTextField resignFirstResponder];
    }];

}

- (void) typeControlClicked:(id) sender
{
    [self closeAllKeyboard];
    //预警标识选择
    [HealthDetectWaringTypePickerViewController showWithDefaultWarningType:warningType PickBlock:^(NSInteger type) {
        warningType = type;
        self.waringModel.signsId = [NSString stringWithFormat:@"%ld", warningType];
        [self.warningTypeView setWarningType:[self warningIdentificationTypeString]];
        
        [self createWarningValueViews];
    }];
}

- (NSString*) warningIdentificationTypeString
{
    [self closeAllKeyboard];
    HealthDetectWarningType warningIdentificationType = warningType;
    switch (warningIdentificationType) {
        case WarningType_Unknown:
        {
            return @"请选择";
            break;

        }
        case WarningType_Custom:
        {
            return @"自定义";
            break;
        }
        case WarningType_High:
        {
            return @"高值预警";
            break;
        }
        case WarningType_Low:
        {
            return @"低值预警";
            break;
        }
    }
    return nil;
}

- (void) kpiControlClicked:(id) sender
{
    [self closeAllKeyboard];
    if (!subKpiList || subKpiList.count == 0) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [HealtDetectWarningKpiPickerViewController showWithKpiCode:self.kpiCode subKpiCode:self.waringModel.oneKpiCode subKpiModels:subKpiList handle:^(HealthDetectWarningSubKpiModel *kpiModel) {
        if (!weakSelf) {
            return ;
        }
        __strong typeof(self) strongSelf = weakSelf;
        
        strongSelf.waringModel.oneKpiCode = kpiModel.subKpiCode;
        strongSelf.waringModel.oneKpiName = kpiModel.subKpiName;
        strongSelf.waringModel.oneKpiId = kpiModel.subKpiId.integerValue;
        [strongSelf.firstWarningValueView setSubKpiModel:kpiModel];
    }];
}

- (void) commitButtonClicked:(id) sender
{
    [self closeAllKeyboard];
    
    if ([self.kpiCode isEqualToString:@"XY"])
    {
        
        
        switch (warningType) {
            case WarningType_Unknown:
            {
                [self showAlertMessage:@"请正确输入预警值。"];
                return;
                break;
            }
            case WarningType_Custom:
            {
                NSString* oneBeginValue = self.firstWarningValueView.oneBeginValueTextField.text;
                NSString* oneEndValue = self.firstWarningValueView.oneEndValueTextField.text;
                NSString* twoBeginValue = self.secondWarningValueView.oneBeginValueTextField.text;
                NSString* twoEndValue = self.secondWarningValueView.oneEndValueTextField.text;
                
                
                
                if (oneBeginValue.length > 6 || oneEndValue.length > 6) {
                    [self showAlertMessage:@"您的输入过长，请输入较短的数字。"];
                    return ;
                }
                if (twoBeginValue.length > 6 || twoEndValue.length > 6) {
                    [self showAlertMessage:@"您的输入过长，请输入较短的数字。"];
                    return ;
                }
                if (!oneBeginValue || oneBeginValue.length == 0) {
                    [self showAlertMessage:@"请正确输入预警值。"];
                    return;
                }
                if (!oneEndValue || oneEndValue.length == 0) {
                    [self showAlertMessage:@"请正确输入预警值。"];
                    return;
                }
                
                if (!twoBeginValue || twoBeginValue.length == 0) {
                    [self showAlertMessage:@"请正确输入预警值。"];
                    return;
                }
                if (!twoEndValue || twoEndValue.length == 0) {
                    [self showAlertMessage:@"请正确输入预警值。"];
                    return;
                }
                
                if (![oneBeginValue isNumberString]) {
                    [self showAlertMessage:@"请正确输入预警值。"];
                    return ;
                }
                
                if (![oneEndValue isNumberString]) {
                    [self showAlertMessage:@"请正确输入预警值。"];
                    return ;
                }
                
                if (![twoBeginValue isNumberString]) {
                    [self showAlertMessage:@"请正确输入预警值。"];
                    return ;
                }
                
                if (![twoEndValue isNumberString]) {
                    [self showAlertMessage:@"请正确输入预警值。"];
                    return ;
                }
                
               
                
                self.waringModel.oneBeginValue = oneBeginValue;
                self.waringModel.oneEndValue = oneEndValue;
                self.waringModel.oneBeginSymbol = @"<";
                self.waringModel.oneEndSymbol = @"<";
                
                self.waringModel.oneTwoRelation = self.relationView.relation;
                
                self.waringModel.twoBeginValue = twoBeginValue;
                self.waringModel.twoEndValue = twoEndValue;
                self.waringModel.twoBeginSymbol = @"<";
                self.waringModel.twoEndSymbol = @"<";
                break;
            }
            case WarningType_High:
            {
                NSString* oneBeginValue = self.firstWarningValueView.oneEndValueTextField.text;
                
                if (!oneBeginValue || oneBeginValue.length == 0) {
                    [self showAlertMessage:@"请正确输入预警值。"];
                    return;
                }
                
                NSString* twoBeginValue = self.secondWarningValueView.oneEndValueTextField.text;
                if (!twoBeginValue || twoBeginValue.length == 0) {
                    [self showAlertMessage:@"请正确输入预警值。"];
                    return;
                }
                
                if (oneBeginValue.length > 6) {
                    [self showAlertMessage:@"您的输入过长，请输入较短的数字。"];
                    return ;
                }
                if (twoBeginValue.length > 6) {
                    [self showAlertMessage:@"您的输入过长，请输入较短的数字。"];
                    return ;
                }
                
                if (![oneBeginValue isNumberString]) {
                    [self showAlertMessage:@"请正确输入预警值。"];
                    return ;
                }
                
                if (![twoBeginValue isNumberString]) {
                    [self showAlertMessage:@"请正确输入预警值。"];
                    return ;
                }

                
                self.waringModel.oneBeginValue = nil;
                self.waringModel.oneEndValue = oneBeginValue;
                self.waringModel.oneBeginSymbol = nil;
                self.waringModel.oneEndSymbol = @">";
                
                self.waringModel.oneTwoRelation = self.relationView.relation;
                
                self.waringModel.twoBeginValue = nil;
                self.waringModel.twoEndValue = twoBeginValue;
                self.waringModel.twoBeginSymbol = nil;
                self.waringModel.twoEndSymbol = @">";
                break;
            }
            case WarningType_Low:
            {
                NSString* oneBeginValue = self.firstWarningValueView.oneEndValueTextField.text;
                if (!oneBeginValue || oneBeginValue.length == 0) {
                    [self showAlertMessage:@"请正确输入预警值。"];
                    return;
                }
                
                NSString* twoBeginValue = self.secondWarningValueView.oneEndValueTextField.text;
                if (!twoBeginValue || twoBeginValue.length == 0) {
                    [self showAlertMessage:@"请正确输入预警值。"];
                    return;
                }
                
                if (oneBeginValue.length > 6) {
                    [self showAlertMessage:@"您的输入过长，请输入较短的数字。"];
                    return ;
                }
                if (twoBeginValue.length > 6) {
                    [self showAlertMessage:@"您的输入过长，请输入较短的数字。"];
                    return ;
                }
                
                if (![oneBeginValue isNumberString]) {
                    [self showAlertMessage:@"请正确输入预警值。"];
                    return ;
                }
                
                if (![twoBeginValue isNumberString]) {
                    [self showAlertMessage:@"请正确输入预警值。"];
                    return ;
                }
                
                

                
                self.waringModel.oneBeginValue = nil;
                self.waringModel.oneEndValue = oneBeginValue;
                self.waringModel.oneBeginSymbol = nil;
                self.waringModel.oneEndSymbol = @"<";
                
                self.waringModel.oneTwoRelation = self.relationView.relation;
                
                self.waringModel.twoBeginValue = nil;
                self.waringModel.twoEndValue = twoBeginValue;
                self.waringModel.twoBeginSymbol = nil;
                self.waringModel.twoEndSymbol = @"<";
                break;
            }
            
        }
    }
    else
    {
        switch (warningType) {
            case WarningType_Unknown:
            {
                [self showAlertMessage:@"请正确输入预警值。"];
                return;
                break;
            }
            case WarningType_Custom:
            {
                NSString* oneBeginValue = self.firstWarningValueView.oneBeginValueTextField.text;
                NSString* oneEndValue = self.firstWarningValueView.oneEndValueTextField.text;
                if (!oneBeginValue || oneBeginValue.length == 0) {
                    [self showAlertMessage:@"请正确输入预警值。"];
                    return;
                }
                if (oneBeginValue.length > 6 || oneEndValue.length > 6) {
                    [self showAlertMessage:@"您的输入过长，请输入较短的数字。"];
                    return ;
                }
                if (!oneEndValue || oneEndValue.length == 0) {
                    [self showAlertMessage:@"请正确输入预警值。"];
                    return;
                }
                if (![oneBeginValue isNumberString]) {
                    [self showAlertMessage:@"请正确输入预警值。"];
                    return ;
                }
                
                if (![oneEndValue isNumberString]) {
                    [self showAlertMessage:@"请正确输入预警值。"];
                    return ;
                }
                self.waringModel.oneBeginValue = oneBeginValue;
                self.waringModel.oneEndValue = oneEndValue;
                self.waringModel.oneBeginSymbol = @"<";
                self.waringModel.oneEndSymbol = @"<";
                
                break;
            }
            case WarningType_High:
            {
                NSString* oneBeginValue = self.firstWarningValueView.oneEndValueTextField.text;
                if (!oneBeginValue || oneBeginValue.length == 0) {
                    [self showAlertMessage:@"请正确输入预警值。"];
                    return;
                }
                if (oneBeginValue.length > 6) {
                    [self showAlertMessage:@"您的输入过长，请输入较短的数字。"];
                    return ;
                }
                if (![oneBeginValue isNumberString]) {
                    [self showAlertMessage:@"请正确输入预警值。"];
                    return ;
                }

                
                self.waringModel.oneBeginValue = nil;
                self.waringModel.oneEndValue = oneBeginValue;
                self.waringModel.oneBeginSymbol = nil;
                self.waringModel.oneEndSymbol = @">";
                break;
            }
            case WarningType_Low:
            {
                NSString* oneBeginValue = self.firstWarningValueView.oneEndValueTextField.text;
                if (!oneBeginValue || oneBeginValue.length == 0) {
                    [self showAlertMessage:@"请正确输入预警值。"];
                    return;
                }
                if (oneBeginValue.length > 6) {
                    [self showAlertMessage:@"您的输入过长，请输入较短的数字。"];
                    return ;
                }
                if (![oneBeginValue isNumberString]) {
                    [self showAlertMessage:@"请正确输入预警值。"];
                    return ;
                }
                self.waringModel.oneBeginValue = nil;
                self.waringModel.oneEndValue = oneBeginValue;
                self.waringModel.oneBeginSymbol = nil;
                self.waringModel.oneEndSymbol = @"<";
                break;
            }
        }

    }
    
    if (self.editHandle) {
        self.editHandle(self.waringModel);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - settingAndGetting
- (HealthDetectWarningTypeView*) warningTypeView
{
    if (!_warningTypeView) {
        _warningTypeView = [[HealthDetectWarningTypeView alloc] init];
        [self.view addSubview:_warningTypeView];
        
        
    }
    return _warningTypeView;
}

- (UIControl*) waringValuesView
{
    if (!_waringValuesView) {
        _waringValuesView = [[UIControl alloc] init];
        [self.view addSubview:_waringValuesView];
        [_waringValuesView setBackgroundColor:[UIColor whiteColor]];
        [_waringValuesView addTarget:self action:@selector(closeControlClicked:) forControlEvents:UIControlEventAllTouchEvents];
    }
    return _waringValuesView;
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
