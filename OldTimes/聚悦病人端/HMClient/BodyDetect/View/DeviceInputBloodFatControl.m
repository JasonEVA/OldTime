//
//  DeviceInputBloodFatControl.m
//  HMClient
//
//  Created by lkl on 16/5/4.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "DeviceInputBloodFatControl.h"

@interface DeviceInputBloodFatControl ()
<UITextFieldDelegate>
{
    UILabel *lbName;
    UILabel *lbSubName;
    UILabel *lbUnit;

    UIView *bottomlineView;
}
@end

@implementation DeviceInputBloodFatControl

- (id) init
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];

        
        lbName = [[UILabel alloc]init];
        [self addSubview:lbName];
        [lbName setBackgroundColor:[UIColor clearColor]];
        [lbName setFont:[UIFont font_30]];
        [lbName setTextColor:[UIColor commonGrayTextColor]];
        
        lbSubName = [[UILabel alloc]init];
        [self addSubview:lbSubName];
        [lbSubName setBackgroundColor:[UIColor clearColor]];
        [lbSubName setFont:[UIFont font_30]];
        [lbSubName setTextColor:[UIColor commonGrayTextColor]];
        
        _tfValue = [[UITextField alloc] init];
        [_tfValue setPlaceholder:@"0"];
        [_tfValue setDelegate:self];
        [_tfValue setFont:[UIFont font_28]];
        [_tfValue setTextAlignment:NSTextAlignmentRight];
        [self addSubview:_tfValue];
        [_tfValue setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        
        lbUnit = [[UILabel alloc]init];
        [self addSubview:lbUnit];
        [lbUnit setBackgroundColor:[UIColor clearColor]];
        [lbUnit setText:@"mmol/L"];
        [lbUnit setFont:[UIFont font_30]];
        [lbUnit setTextAlignment:NSTextAlignmentRight];
        [lbUnit setTextColor:[UIColor commonGrayTextColor]];
        
        bottomlineView = [[UIView alloc] init];
        [bottomlineView setBackgroundColor:[UIColor commonCuttingLineColor]];
        [self addSubview:bottomlineView];
        
        [self subviewLayout];
    }
    
    return self;
}

- (void) subviewLayout
{
    [lbName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(15);
        make.top.equalTo(self).with.offset(10);
        make.height.mas_equalTo(20);
    }];
    
    [lbSubName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(15);
        make.top.equalTo(lbName.mas_bottom);
        make.height.mas_equalTo(20);
    }];
    
    [lbUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.centerY.equalTo(self);
    }];
    
    [_tfValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lbUnit.mas_left).with.offset(-2);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(@100);
        make.height.mas_equalTo(@30);
    }];
    
    
    [bottomlineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_bottom).with.offset(-1);
        make.left.and.right.equalTo(self);
        make.height.mas_equalTo(1);
    }];
}

- (void) setName:(NSString*) name SubName:(NSString*) subname
{
    [lbName setText:name];
    [lbSubName setText:subname];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
