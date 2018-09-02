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
    UIButton *cancelBtn;
    UIButton *confirmDateBtn;
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
        
        cancelBtn = [[UIButton alloc] init];
        [cancelBtn.layer setCornerRadius:5.0];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont font_30];
        [cancelBtn setBackgroundColor:[UIColor mainThemeColor]];
        [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
        
        confirmDateBtn = [[UIButton alloc] init];
        [confirmDateBtn.layer setMasksToBounds:YES];
        [confirmDateBtn.layer setCornerRadius:5.0];
        [confirmDateBtn setTitle:@"确定" forState:UIControlStateNormal];
        confirmDateBtn.titleLabel.font = [UIFont font_30];
        [confirmDateBtn setBackgroundColor:[UIColor mainThemeColor]];
        [confirmDateBtn addTarget:self action:@selector(confirmDateBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:confirmDateBtn];
        
        datePicker = [[UIDatePicker alloc] init];
        datePicker.backgroundColor = [UIColor whiteColor];
        [self addSubview:datePicker];

        [self subviewLayout];
    }
    return self;
}

- (void)subviewLayout
{
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(30);
        make.top.equalTo(self).with.offset(2);
        make.size.mas_equalTo(CGSizeMake(40, 30));
    }];
    
    [confirmDateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-30);
        make.top.equalTo(self).with.offset(2);
        make.size.mas_equalTo(CGSizeMake(40, 30));
    }];
    
    [datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cancelBtn.mas_bottom).with.offset(3);
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
    [self removeFromSuperview];    

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd  HH:mm"];
    
    if ([datePicker.date compare:[NSDate date]] == NSOrderedDescending)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"时间有误" message:@"选择时间不对，请重新选择。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    
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
