//
//  AddAerobicDataView.m
//  Shape
//
//  Created by Andrew Shen on 15/10/29.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "AddAerobicDataView.h"
#import "BaseToolBarTextField.h"
#import "MyDefine.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"

typedef enum : NSUInteger {
    tag_weight,
    tag_fatPercentage,
} AerobicDataTag;

static CGFloat const kWeightMin = 30.0;
static CGFloat const kWeightMax = 150.0;

static CGFloat const kWeightIncrement = 0.5;

@interface AddAerobicDataView()<MyToolBarDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong)  UILabel  *title; // <##>
@property (nonatomic, strong)  UIView  *horizonLine1; // 顶部水平线
@property (nonatomic, strong)  UILabel  *weightTitle; // 体重title
@property (nonatomic, strong)  BaseToolBarTextField  *weightTxfd; // 体重输入框
@property (nonatomic, strong)  UILabel  *fatTitle; // 体脂率title
@property (nonatomic, strong)  BaseToolBarTextField  *fatTxfd; // 体脂率输入框
@property (nonatomic, strong)  UIButton  *btnCancel; //
@property (nonatomic, strong)  UIButton  *btnConfirm; //
@property (nonatomic, strong) UIPickerView *pickerViewWeight;
@property (nonatomic, strong) UIPickerView *pickerViewFat;


@property (nonatomic, copy)  AddWeightAndFatBlock  callBack; // <##>

@property (nonatomic)  CGFloat  weight; // 体重
@property (nonatomic, strong)  NSString  *fatRange; // <##>
@property (nonatomic, copy)  NSArray  *arrayFatRange; // <##>
@end
@implementation AddAerobicDataView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setClipsToBounds:YES];
        self.backgroundColor = [UIColor whiteColor];
        [self.layer setCornerRadius:5];
        [self.layer setMasksToBounds:YES];
        [self.layer setBorderColor:[UIColor lineGray_dbd8d8].CGColor];
        [self.layer setBorderWidth:0.5];
        [self configElements];
    }
    return self;
}

// 设置元素控件
- (void)configElements {
    [self addSubview:self.title]; // <##>
    [self addSubview:self.horizonLine1]; // 顶部水平线
    [self addSubview:self.weightTitle]; // 体重title
    [self addSubview:self.weightTxfd]; // 体重输入框
    [self addSubview:self.fatTitle]; // 体脂率title
    [self addSubview:self.fatTxfd]; // 体脂率输入框
    [self addSubview:self.btnCancel]; //
    [self addSubview:self.btnConfirm]; //
    
    self.arrayFatRange = @[@"<8%",@"8%~12%",@"12%~15%",@"15%~20%",@"20%~25%",@"25%~30%",@"30%~35%",@">35%"];
    [self needsUpdateConstraints];
}

- (void)updateConstraints {
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self);
        make.left.equalTo(self).offset(leftSpacing);
        make.height.equalTo(@(height_44));
    }];
    [self.horizonLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(7);
        make.right.equalTo(self).offset(-7);
        make.top.equalTo(self.title.mas_bottom);
        make.height.equalTo(@0.5);
    }];
    [self.weightTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title);
        make.height.equalTo(@(height_40));
        make.top.equalTo(self.horizonLine1.mas_bottom).offset(20);
    }];
    [self.weightTxfd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(74);
        make.right.equalTo(self).offset(-20);
        make.height.equalTo(self.weightTitle);
        make.centerY.equalTo(self.weightTitle);
    }];
    [self.fatTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title);
        make.height.equalTo(@(height_40));
        make.top.equalTo(self.weightTitle.mas_bottom).offset(15);
    }];
    [self.fatTxfd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.weightTxfd);
        make.centerY.equalTo(self.fatTitle);
    }];
    [self.btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fatTxfd.mas_bottom).offset(20);
        make.left.equalTo(self);
        make.width.equalTo(self).multipliedBy(0.5);
        make.height.equalTo(self.title);
    }];
    [self.btnConfirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.btnCancel.mas_right);
        make.top.width.height.equalTo(self.btnCancel);
        
    }];
    
    [super updateConstraints];
}

- (void)setWeight:(CGFloat)weight fatRange:(NSString *)fatRange callBack:(AddWeightAndFatBlock)callBack {
    self.callBack = callBack;
    self.weight = weight;
    self.fatRange = fatRange;
    
    [self.weightTxfd setText:[NSString stringWithFormat:@"%.1f",self.weight]];
    [self.fatTxfd setText:self.fatRange];
    [self.pickerViewWeight selectRow:[self selectedRowWithValueMin:kWeightMin increment:kWeightIncrement value:weight] inComponent:0 animated:YES];
    for (NSInteger i = 0; i < self.arrayFatRange.count; i ++) {
        if ([self.fatRange isEqualToString:self.arrayFatRange[i]]) {
            [self.pickerViewFat selectRow:i inComponent:0 animated:YES];
            break;
        }
    }
}

#pragma mark - Pravite Method
- (void)btnClicked:(UIButton *)sender {
    if (self.callBack == NULL) {
        return;
    }
    if (sender.tag == 0) {
        // 取消
        self.callBack(0,@"",NO);
    } else {
        // 保存
        self.callBack(self.weight,self.fatRange,YES);
    }
    [self resignAllResponder];
}

- (void)resignAllResponder {
    [self.fatTxfd resignFirstResponder];
    [self.weightTxfd resignFirstResponder];
}
// 根据第几行，计算pickerView每一行数据
- (NSString *)pickerViewTitleWithValueMin:(CGFloat)min increment:(CGFloat)increment row:(NSInteger)row {
    NSString *title = [NSString stringWithFormat:@"%.1f",min + increment * row];
    return title;
}

// 根据数值计算是第几行
- (NSInteger)selectedRowWithValueMin:(CGFloat)min increment:(CGFloat)increment value:(CGFloat)value {
    NSInteger row = (value - min) / increment;
    return row >= 0 ? row : 0 ;
}
#pragma mark - TextFieldDelegate
- (void)MyToolBarDelegateCallBack_SaveClickWithTag:(NSInteger)tag {
    switch (tag) {
        case tag_weight:
        {
            NSInteger selectRow = [self.pickerViewWeight selectedRowInComponent:0];
            
            // 保存体重
            NSString *temp = [self pickerViewTitleWithValueMin:kWeightMin increment:kWeightIncrement row:selectRow];
            [self.weightTxfd setText:temp];
            self.weight = temp.floatValue;
        }
            
            break;
            
        case tag_fatPercentage:
        {
            NSInteger selectRow = [self.pickerViewFat selectedRowInComponent:0];
            
            // 保存体脂率范围
            [self.fatTxfd setText:self.arrayFatRange[selectRow]];
            self.fatRange = self.fatTxfd.text;

        }
            break;
            

        default:
            break;
    }
    [self resignAllResponder];
}
- (void)MyToolBarDelegateCallBack_CancelClickWithTag:(NSInteger)tag {
    [self resignAllResponder];
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
            rows = self.arrayFatRange.count;
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
            title = self.arrayFatRange[row];
            break;
            
        default:
            break;
    }
    return title;
}

//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
//{
//    switch (pickerView.tag) {
//        case tag_weight:
//        {
//            NSString *temp = [self pickerViewTitleWithValueMin:kWeightMin increment:kWeightIncrement row:row];
//            self.weight = temp.floatValue;
//            break;
//
//        }
//            
//        case tag_fatPercentage:
//            self.fatRange = self.arrayFatRange[row];
//            break;
//            
//        default:
//            break;
//    }
//}

#pragma mark - Initzz
- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        [_title setText:@"个人数据"];
        [_title setFont:[UIFont systemFontOfSize:fontSize_15]];
    }
    return _title;
}

- (UIView *)horizonLine1 {
    if (!_horizonLine1) {
        _horizonLine1 = [[UIView alloc] init];
        [_horizonLine1 setBackgroundColor:[UIColor lineGray_dbd8d8]];
    }
    return _horizonLine1;
}
- (UILabel *)weightTitle {
    if (!_weightTitle) {
        _weightTitle = [[UILabel alloc] init];
        [_weightTitle setText:@"体重"];
        [_weightTitle setFont:[UIFont systemFontOfSize:fontSize_15]];
    }
    return _weightTitle;

}

- (UILabel *)fatTitle {
    if (!_fatTitle) {
        _fatTitle = [[UILabel alloc] init];
        [_fatTitle setText:@"体脂率"];
        [_fatTitle setFont:[UIFont systemFontOfSize:fontSize_15]];
    }
    return _fatTitle;
    
}

- (BaseToolBarTextField *)weightTxfd {
    if (!_weightTxfd) {
        _weightTxfd = [[BaseToolBarTextField alloc] initWithToolBar:YES backgroundColor:[UIColor whiteColor] textColor:[UIColor blackColor] alignment:NSTextAlignmentCenter tag:tag_weight text:@"" inputView:self.pickerViewWeight];
        [_weightTxfd setTintColor:[UIColor clearColor]];
        [_weightTxfd.layer setBorderColor:[UIColor lineGray_dbd8d8].CGColor];
        [_weightTxfd.layer setBorderWidth:0.5];
        [_weightTxfd setToolBarTitle:@""];
        [_weightTxfd setToolBarDeletate:self];
    }
    return _weightTxfd;
}
- (BaseToolBarTextField *)fatTxfd {
    if (!_fatTxfd) {
        _fatTxfd = [[BaseToolBarTextField alloc] initWithToolBar:YES backgroundColor:[UIColor whiteColor] textColor:[UIColor blackColor] alignment:NSTextAlignmentCenter tag:tag_fatPercentage text:@"" inputView:self.pickerViewFat];
        [_fatTxfd setTintColor:[UIColor clearColor]];
        [_fatTxfd.layer setBorderColor:[UIColor lineGray_dbd8d8].CGColor];
        [_fatTxfd.layer setBorderWidth:0.5];
        [_fatTxfd setToolBarTitle:@""];
        [_fatTxfd setToolBarDeletate:self];
    }
    return _fatTxfd;
}

- (UIButton *)btnCancel {
    if (!_btnCancel) {
        _btnCancel = [UIButton buttonWithType:UIButtonTypeSystem];
        [_btnCancel setTitle:@"取消" forState:UIControlStateNormal];
        [_btnCancel setTitleColor:[UIColor colorLightGray_898888] forState:UIControlStateNormal];
        [_btnCancel.layer setBorderColor:[UIColor lineGray_dbd8d8].CGColor];
        [_btnCancel.layer setBorderWidth:0.5];
        [_btnCancel setTag:0];
        [_btnCancel addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnCancel;
}
- (UIButton *)btnConfirm {
    if (!_btnConfirm) {
        _btnConfirm = [UIButton buttonWithType:UIButtonTypeSystem];
        [_btnConfirm setTitle:@"确定" forState:UIControlStateNormal];
        [_btnConfirm setTitleColor:[UIColor themeOrange_ff5d2b] forState:UIControlStateNormal];
        [_btnConfirm.layer setBorderColor:[UIColor lineGray_dbd8d8].CGColor];
        [_btnConfirm.layer setBorderWidth:0.5];
        [_btnConfirm setTag:1];
        [_btnConfirm addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnConfirm;
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
