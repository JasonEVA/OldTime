//
//  BreathingUpdateSymptomView.m
//  HMClient
//
//  Created by lkl on 16/7/6.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BreathingUpdateSymptomView.h"

@interface BreathingUpdateSymptomView ()
{


}
@end

@implementation BreathingUpdateSymptomView

- (id) init
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        _txView = [[UITextView alloc] init];
        [self addSubview:_txView];
        [_txView.layer setBorderWidth:1.0f];
        [_txView.layer setBorderColor:[[UIColor commonControlBorderColor] CGColor]];
        [_txView setFont:[UIFont font_28]];
        
        _label = [[UILabel alloc] init];
        [_label setEnabled:NO];
        [_label setText:@"如果您有呼吸不适的症状，请输入您的症状"];
        [_label setFont:[UIFont font_28]];
        [_label setTextColor:[UIColor commonGrayTextColor]];
        [self addSubview:_label];
        
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_saveButton];
        [_saveButton.layer setMasksToBounds:YES];
        [_saveButton.layer setCornerRadius:5.0];
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [_saveButton.titleLabel setFont: [UIFont font_30]];
        [_saveButton setBackgroundColor:[UIColor mainThemeColor] ];
        [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_txView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(5);
            make.left.mas_equalTo(10);
            make.right.equalTo(self).with.offset(-10);
            make.height.mas_equalTo(100);
        }];
        
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(5);
            make.left.mas_equalTo(14);
            make.right.equalTo(self).with.offset(-10);
            make.height.mas_equalTo(35);
        }];
        
        [_saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.equalTo(_txView.mas_bottom).with.offset(30);
            make.right.equalTo(self.mas_right).with.offset(-15);
            make.height.mas_equalTo(45);
        }];
        
    }
    return self;
}

@end

