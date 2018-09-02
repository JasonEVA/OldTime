//
//  DeviceTestTimeSelectView.m
//  HMClient
//
//  Created by Dee on 16/10/8.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "DeviceTestTimeSelectView.h"

@interface DeviceTestTimeSelectView ()

@property(nonatomic, strong) UIDatePicker  *datePicker; //时间选择

@property(nonatomic, strong) UIView  *contentView;      //pickerVie的容器

@property(nonatomic, copy) dateCallBackBlock  myBlock;  //回调方法

@property(nonatomic, strong) NSDate  *selectedDate;

@end

@implementation DeviceTestTimeSelectView

- (instancetype)init {
    if (self = [super init]) {
        self.datePicker =  [[UIDatePicker alloc] init];
        [self.datePicker setMaximumDate:[NSDate date]];
        self.datePicker.backgroundColor = [UIColor commonPickViewBackGroundColor];
        [self.datePicker addTarget:self action:@selector(dateValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self createFrame];
    }
    return self;
}

- (void)getSelectedItemWithBlock:(dateCallBackBlock)block {
    self.myBlock = block;
}

- (void)setDate:(NSDate *)date {
    [self.datePicker setDate:date];
}

- (void)setDateModel:(UIDatePickerMode )mode {
    self.datePicker.datePickerMode = mode;
}

#pragma mark - privateMethod

- (void)createFrame {
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self addSubview:self.contentView];
    [self.contentView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [self.contentView addSubview:self.datePicker];
    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (void)dateValueChanged:(UIDatePicker *)datePicker {
    self.selectedDate = datePicker.date;
    if (self.myBlock) {
        self.myBlock(self.selectedDate?:self.datePicker.date);
    }
}

#pragma mark - setterAndGetter

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor commonPickViewBackGroundColor];
    }
    return _contentView;
}



@end
