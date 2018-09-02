//
//  AddAerobicDataViewController.m
//  Shape
//
//  Created by Andrew Shen on 15/10/28.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "AddAerobicDataViewController.h"
#import "BaseToolBarTextField.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"
#import "MyDefine.h"

typedef enum : NSUInteger {
    tag_weight,
    tag_fatPercentage,
} AerobicDataTag;

static CGFloat const kWeightMin = 30.0;
static CGFloat const kWeightMax = 150.0;

static CGFloat const kFatMin = 4.0;
static CGFloat const kFatMax = 50.0;

static CGFloat const kWeightIncrement = 0.5;
static CGFloat const kFatIncrement = 0.2;

@interface AddAerobicDataViewController ()<MyToolBarDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, strong)  UILabel  *weightTitle; // 体重
@property (nonatomic, strong)  UILabel  *fatPercentageTitle; // 体重

@property (nonatomic, strong)  BaseToolBarTextField  *weight; // 体重
@property (nonatomic, strong)  BaseToolBarTextField  *fatPercentage; // 体脂率

@property (nonatomic, strong) UIPickerView *pickerViewWeight;
@property (nonatomic, strong) UIPickerView *pickerViewFat;

@property (nonatomic, copy) NSString *weightValue;
@property (nonatomic, copy) NSString *fatValue;

@end

@implementation AddAerobicDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithR:0 g:0 b:0 alpha:0.7];
//    UIView *baseView = [[UIView alloc] initWithFrame:self.view.frame];
//    baseView.backgroundColor = [UIColor blackColor];
//    baseView.alpha = 0.7;
//    [self.view addSubview:baseView];
    
    // Do any additional setup after loading the view.
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelEvent)];
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveEvent)];
    [self.navigationItem setLeftBarButtonItem:cancelItem];
    [self.navigationItem setRightBarButtonItem:saveItem];
    [self configElements];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateViewConstraints {
    
    [self.weightTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.left.equalTo(self.view).offset(40);
    }];
    [self.weight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.weightTitle.mas_bottom).offset(9);
        make.left.equalTo(self.view).offset(40);
        make.right.equalTo(self.view).offset(-40);
        make.height.mas_equalTo(height_44);
    }];
    
    [self.fatPercentageTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.weight.mas_bottom).offset(27);
        make.left.equalTo(self.view).offset(40);
    }];

    [self.fatPercentage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fatPercentageTitle.mas_bottom).offset(9);
        make.left.right.height.equalTo(self.weight);
    }];

    [super updateViewConstraints];
    
}

#pragma mark - Interface Mehtod
- (void)setWeight:(CGFloat)weight fatPercentage:(CGFloat)fatPercentage {
    self.weightValue = [NSString stringWithFormat:@"%.1f",weight];
    self.fatValue = [NSString stringWithFormat:@"%.1f",fatPercentage * 100];
    [self.weight setText:self.weightValue];
    [self.fatPercentage setText:self.fatValue];
    [self.pickerViewWeight selectRow:[self selectedRowWithValueMin:kWeightMin increment:kWeightIncrement value:weight] inComponent:0 animated:YES];
    [self.pickerViewFat selectRow:[self selectedRowWithValueMin:kFatMin increment:kFatIncrement value:fatPercentage * 100] inComponent:0 animated:YES];

}

#pragma mark - Private Method

// 设置元素控件
- (void)configElements {
    [self.view addSubview:self.weightTitle];
    [self.view addSubview:self.fatPercentageTitle];
    [self.view addSubview:self.weight];
    [self.view addSubview:self.fatPercentage];
    
    [self updateViewConstraints];
}

- (void)resignAllFirstResponder {
    [self.weight resignFirstResponder];
    [self.fatPercentage resignFirstResponder];

}

- (void)cancelEvent {
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)saveEvent {
    // TODO:保存进数据库
    
    [self dismissViewControllerAnimated:YES completion:nil];

}
#pragma mark - MyToolBarDelegate
- (void)MyToolBarDelegateCallBack_SaveClickWithTag:(NSInteger)tag
{
    [self resignAllFirstResponder];
    switch (tag) {
        case tag_weight:
            [self.weight setText:self.weightValue];
            break;
            
        case tag_fatPercentage:
            [self.fatPercentage setText:self.fatValue];
            break;
            
        default:
            break;
    }
}

- (void)MyToolBarDelegateCallBack_CancelClickWithTag:(NSInteger)tag
{
    [self resignAllFirstResponder];
}

// 根据第几行，计算pickerView每一行数据
- (NSString *)pickerViewTitleWithValueMin:(CGFloat)min increment:(CGFloat)increment row:(NSInteger)row {
    NSString *title = [NSString stringWithFormat:@"%.1f",min + increment * row];
    return title;
}

// 根据数值计算是第几行
- (NSInteger)selectedRowWithValueMin:(CGFloat)min increment:(CGFloat)increment value:(CGFloat)value {
    NSInteger row = (value - min) / increment;
    return row;
}
#pragma mark - UIpickerView Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger rows = 0;
    switch (pickerView.tag) {
        case tag_weight:
            rows = (kWeightMax - kWeightMin) / kWeightIncrement + 1;
            break;
            
        case tag_fatPercentage:
            rows = (kFatMax - kFatMin) / kFatIncrement + 1;
            break;

        default:
            break;
    }
    return rows;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = @"";
    switch (pickerView.tag) {
        case tag_weight:
            title = [self pickerViewTitleWithValueMin:kWeightMin increment:kWeightIncrement row:row];
            break;
            
        case tag_fatPercentage:
            title = [self pickerViewTitleWithValueMin:kFatMin increment:kFatIncrement row:row];
            break;
            
        default:
            break;
    }
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (pickerView.tag) {
        case tag_weight:
            self.weightValue = [self pickerViewTitleWithValueMin:kWeightMin increment:kWeightIncrement row:row];
            break;
            
        case tag_fatPercentage:
            self.fatValue = [self pickerViewTitleWithValueMin:kFatMin increment:kFatIncrement row:row];
            break;
            
        default:
            break;
    }
}

#pragma mark - Init
- (UILabel *)weightTitle
{
    if (!_weightTitle) {
        _weightTitle = [[UILabel alloc] init];
        [_weightTitle setText:@"体重(KG)"];
        [_weightTitle setTextColor:[UIColor whiteColor]];
        
    }
    return _weightTitle;
}

- (UILabel *)fatPercentageTitle
{
    if (!_fatPercentageTitle) {
        _fatPercentageTitle = [[UILabel alloc] init];
        [_fatPercentageTitle setText:@"体重(%)"];
        [_fatPercentageTitle setTextColor:[UIColor whiteColor]];
        
    }
    return _fatPercentageTitle;
}

- (BaseToolBarTextField *)weight {
    if (!_weight) {
        _weight = [[BaseToolBarTextField alloc] initWithToolBar:YES backgroundColor:[UIColor themeBackground_373737] textColor:[UIColor whiteColor] alignment:NSTextAlignmentCenter tag:tag_weight text:@"" inputView:self.pickerViewWeight];
        [_weight setToolBarDeletate:self];
        [_weight setToolBarTitle:@"选择体重"];
        [_weight setTintColor:[UIColor clearColor]];
    }
    return _weight;
}

- (BaseToolBarTextField *)fatPercentage {
    if (!_fatPercentage) {
        _fatPercentage  = [[BaseToolBarTextField alloc] initWithToolBar:YES backgroundColor:[UIColor themeBackground_373737] textColor:[UIColor whiteColor] alignment:NSTextAlignmentCenter tag:tag_fatPercentage text:@"" inputView:self.pickerViewFat];
        [_fatPercentage setToolBarDeletate:self];
        [_fatPercentage setToolBarTitle:@"选择体脂率"];
        [_fatPercentage setTintColor:[UIColor clearColor]];
    }
    return _fatPercentage;
}

- (UIPickerView *)pickerViewWeight
{
    if (!_pickerViewWeight) {
        _pickerViewWeight = [[UIPickerView alloc] init];
        [_pickerViewWeight setDelegate:self];
        [_pickerViewWeight setDataSource:self];
        [_pickerViewWeight setBackgroundColor:[UIColor whiteColor]];
        [_pickerViewWeight setTag:tag_weight];
    }
    return _pickerViewWeight;
}
- (UIPickerView *)pickerViewFat
{
    if (!_pickerViewFat) {
        _pickerViewFat = [[UIPickerView alloc] init];
        [_pickerViewFat setDelegate:self];
        [_pickerViewFat setDataSource:self];
        [_pickerViewFat setBackgroundColor:[UIColor whiteColor]];
        [_pickerViewFat setTag:tag_fatPercentage];
    }
    return _pickerViewFat;
}
@end
