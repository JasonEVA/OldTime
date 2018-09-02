//
//  JWDatePickerView.m
//  HMDoctor
//
//  Created by jasonwang on 2017/9/6.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "JWDatePickerView.h"

#define TOOLBARHEIGHT    40

@interface JWDatePickerView ()
@property (nonatomic, strong) UIView *toolBarView;
@property (nonatomic, copy) pickerBlock block;
@end

@implementation JWDatePickerView

- (instancetype)initWithFrame:(CGRect)frame dateMode:(UIDatePickerMode)mode backColor:(UIColor *)backColor maxDate:(NSDate *)maxDate block:(pickerBlock)block
{
    self = [super init];
    if (self) {
        self.block = block;
        self.toolBarView = [[UIView alloc] init];
        [self.toolBarView setBackgroundColor:backColor];
        [self addSubview:self.toolBarView];
        
        [self.toolBarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.equalTo(@TOOLBARHEIGHT);
        }];
        
        self.datePicker = [[UIDatePicker alloc]init];
        self.datePicker.datePickerMode = mode;
        self.datePicker.backgroundColor = backColor;
        
//        [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];//重点：UIControlEventValueChanged
        
        //设置显示格式
        //默认根据手机本地设置显示为中文还是其他语言
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文显示
        self.datePicker.locale = locale;
        if (maxDate) {
            [self.datePicker setMaximumDate:maxDate];
        }
        
        [self addSubview:self.datePicker];
        [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.left.equalTo(self);
            make.top.equalTo(self.toolBarView.mas_bottom);
        }];
        
        UIButton *cancelBtn = [UIButton new];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor mainThemeColor] forState:UIControlStateNormal];
        [cancelBtn setTag:0];
        [cancelBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *configBtn = [UIButton new];
        [configBtn setTitle:@"确定" forState:UIControlStateNormal];
        [configBtn setTitleColor:[UIColor mainThemeColor] forState:UIControlStateNormal];
        [configBtn setTag:1];
        [configBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

        [self.toolBarView addSubview:cancelBtn];
        [self.toolBarView addSubview:configBtn];
        
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.toolBarView);
            make.left.equalTo(self.toolBarView).offset(10);
        }];
        
        [configBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.toolBarView);
            make.right.equalTo(self.toolBarView).offset(-10);
        }];
        
        
        
    }
    return self;
}

- (void)btnClick:(UIButton *)btn {
    if (self.block) {
        self.block(btn.tag);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
