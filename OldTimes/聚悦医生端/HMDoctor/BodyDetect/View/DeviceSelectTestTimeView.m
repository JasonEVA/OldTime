//
//  DeviceSelectTestTimeView.m
//  HMClient
//
//  Created by lkl on 16/5/4.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "DeviceSelectTestTimeView.h"

@interface DeviceSelectTestTimeView ()
{
    UIDatePicker *datePicker;
}

@end

@implementation DeviceSelectTestTimeView

- (id) init
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn.layer setCornerRadius:5.0];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cancelBtn setBackgroundColor:[UIColor mainThemeColor]];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelBtn];
        
        _confirmDateBtn = [[UIButton alloc] init];
        [_confirmDateBtn.layer setMasksToBounds:YES];
        [_confirmDateBtn.layer setCornerRadius:5.0];
        [_confirmDateBtn setTitle:@"确定" forState:UIControlStateNormal];
        _confirmDateBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_confirmDateBtn setBackgroundColor:[UIColor mainThemeColor]];
        [_confirmDateBtn addTarget:self action:@selector(confirmDateBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_confirmDateBtn];
        
        datePicker = [[UIDatePicker alloc] init];
        datePicker.backgroundColor = [UIColor whiteColor];
        [self addSubview:datePicker];


        [self subviewLayout];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if (_pickerMode) {
        [datePicker setDatePickerMode:UIDatePickerModeDate];
    }
}
- (void)subviewLayout
{
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5);
        make.top.equalTo(self).with.offset(6);
        make.size.mas_equalTo(CGSizeMake(40, 20));
    }];
    
    [_confirmDateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-12.5);
        make.top.equalTo(self).with.offset(6);
        make.size.mas_equalTo(CGSizeMake(40, 20));
    }];
    
    [datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_cancelBtn.mas_bottom).with.offset(8);
        make.left.and.right.mas_equalTo(self);
        make.bottom.equalTo(self);
    }];
}

- (void)cancelBtnClick
{
    [self removeFromSuperview];
}

- (void)confirmDateBtnClick
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    if ([datePicker.date compare:[NSDate date]] == NSOrderedDescending)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"时间有误" message:@"选择时间不对，请重新选择。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    
    [self removeFromSuperview];
    
    NSString *testTime = [formatter stringFromDate:datePicker.date];
    
    if (self.testTimeBlock) {
        self.testTimeBlock(testTime);
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
