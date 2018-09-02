//
//  DeviceInputView.m
//  HMClient
//
//  Created by lkl on 16/5/4.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "DeviceInputView.h"

@interface  DeviceInputControl ()<UITextFieldDelegate>
{
    UILabel* lbName;
    UILabel *lbUnit;
    UIImageView *arrowImage;
    UIView *toplineView;
    UIView *bottomlineView;
}
@end

@implementation DeviceInputControl

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
        
        _tfValue = [[UITextField alloc] init];
        [_tfValue setPlaceholder:@"0"];
        [_tfValue setDelegate:self];
        [_tfValue setFont:[UIFont font_28]];
        [_tfValue setTextAlignment:NSTextAlignmentRight];
        [self addSubview:_tfValue];
        [_tfValue setKeyboardType:UIKeyboardTypeDecimalPad];
        
        lbUnit = [[UILabel alloc]init];
        [self addSubview:lbUnit];
        [lbUnit setBackgroundColor:[UIColor clearColor]];
        [lbUnit setFont:[UIFont font_30]];
        [lbUnit setTextAlignment:NSTextAlignmentRight];
        [lbUnit setTextColor:[UIColor commonTextColor]];
    
        arrowImage = [[UIImageView alloc] init];
        [arrowImage setImage:[UIImage imageNamed:@"icon_x_arrows"]];
        [self addSubview:arrowImage];
        
        bottomlineView = [[UIView alloc] init];
        [bottomlineView setBackgroundColor:[UIColor commonCuttingLineColor]];
        [self addSubview:bottomlineView];
        
        [self addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    
        [self subviewLayout];
    }
    
    return self;
}

- (void) subviewLayout
{
    [lbName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12);
        make.centerY.equalTo(self);
    }];
    
    [arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self.mas_right).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(7, 13));
    }];
    
    [lbUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(arrowImage.mas_left).with.offset(-10);
        make.centerY.equalTo(self);
    }];
    
    [_tfValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lbUnit.mas_left).with.offset(-2);
        make.centerY.equalTo(self);
        make.width.mas_greaterThanOrEqualTo(@60);
    }];
    
    
    [bottomlineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_bottom).with.offset(-1);
        make.left.and.right.equalTo(self);
        make.height.mas_equalTo(1);
    }];
}

- (void) setName:(NSString*) name unit:(NSString*)unit
{
    [lbName setText:name];
    [lbUnit setText:unit];
    
    [lbUnit mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo([lbUnit.text widthSystemFont:lbUnit.font] + 2);
    }];
}

- (void) setPlaceholder:(NSString*) placeholder
{
    [_tfValue setPlaceholder:placeholder];
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType
{
    [_tfValue setKeyboardType:keyboardType];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void) controlClicked
{
    if (_tfValue)
    {
        [_tfValue becomeFirstResponder];
    }
}

- (void)setArrowHide:(BOOL)isHide {
    arrowImage.hidden = isHide;
}

- (void)selectAction:(UIControl *)sender{
    sender.selected ^= 1;
    if (sender.selected) {
        self.backgroundColor = [UIColor commonGrayTouchHihtLightColor];
        sender.selected = NO;
        [UIView animateWithDuration:0.25 animations:^{
            self.backgroundColor = [UIColor whiteColor];
        }completion:^(BOOL finished) {
        }];
    }
}



@end



@interface DeviceTestTimeControl ()
{
    UILabel *lbName;
    UIImageView *arrowImage;
    UIView *lineView;
}
@end

@implementation DeviceTestTimeControl

- (id) init
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        lbName = [[UILabel alloc]init];
        [self addSubview:lbName];
        [lbName setText:@"测试时间"];
        [lbName setBackgroundColor:[UIColor clearColor]];
        [lbName setFont:[UIFont font_30]];
        [lbName setTextColor:[UIColor commonGrayTextColor]];
        
        arrowImage = [[UIImageView alloc] init];
        [arrowImage setImage:[UIImage imageNamed:@"icon_x_arrows"]];
        [self addSubview:arrowImage];
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString* timeString = [formatter stringFromDate:[NSDate date]];

        _lbtestTime = [[UILabel alloc] init];
        [_lbtestTime setTextAlignment:NSTextAlignmentRight];
        [_lbtestTime setText:timeString];
        [_lbtestTime setFont:[UIFont font_30]];
        [_lbtestTime setTextColor:[UIColor colorWithHexString:@"333333"]];
        [self addSubview:_lbtestTime];
        
        lineView = [[UIView alloc] init];
        [lineView setBackgroundColor:[UIColor commonCuttingLineColor]];
        [self addSubview:lineView];
        
        
        [self addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self subviewLayout];
    }
    
    return self;
}

- (void)selectAction:(UIControl *)sender{
    sender.selected ^= 1;
    if (sender.selected) {
        self.backgroundColor = [UIColor commonGrayTouchHihtLightColor];
        sender.selected = NO;
        [UIView animateWithDuration:0.25 animations:^{
            self.backgroundColor = [UIColor whiteColor];
        }completion:^(BOOL finished) {
        }];
    }
}


- (void) subviewLayout
{
    [lbName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12);
        make.centerY.equalTo(self);
    }];
    
    [arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self.mas_right).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(7, 13));
    }];
    
    [_lbtestTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(arrowImage.mas_left).with.offset(-10);
        make.centerY.equalTo(self);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_bottom).with.offset(-1);
        make.left.and.right.equalTo(self);
        make.height.mas_equalTo(1);
    }];
}

- (void)setTestTime:(NSString *)testTime
{
    [_lbtestTime setText:testTime];
}

- (void)setArrowHide:(BOOL)isHide {
    arrowImage.hidden = isHide;
}
@end


@interface DeviceTestPeriodControl ()
{
    UILabel *lbName;
    UIImageView *arrowImage;
    UIView *lineView;
}
@end

@implementation DeviceTestPeriodControl

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
        
        arrowImage = [[UIImageView alloc] init];
        [arrowImage setImage:[UIImage imageNamed:@"icon_x_arrows"]];
        [self addSubview:arrowImage];
        
        _lbtestPeriod = [[UILabel alloc] init];
        [_lbtestPeriod setTextAlignment:NSTextAlignmentRight];
        [_lbtestPeriod setText:@"请选择时段"];
        [_lbtestPeriod setFont:[UIFont font_30]];
        [_lbtestPeriod setTextColor:[UIColor colorWithHexString:@"333333"]];
        [self addSubview:_lbtestPeriod];
        
        lineView = [[UIView alloc] init];
        [lineView setBackgroundColor:[UIColor commonCuttingLineColor]];
        [self addSubview:lineView];
    
        [self addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];

        [self subviewLayout];
    }
    
    return self;
}

- (void) subviewLayout
{
    [lbName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12);
        make.centerY.equalTo(self);
    }];
    
    [arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self.mas_right).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(7, 13));
    }];
    
    [_lbtestPeriod mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(arrowImage.mas_left).with.offset(-10);
        make.centerY.equalTo(self);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_bottom).with.offset(-1);
        make.left.and.right.equalTo(self);
        make.height.mas_equalTo(1);
    }];

}

- (void)selectAction:(UIControl *)sender{
    sender.selected ^= 1;
    if (sender.selected) {
        self.backgroundColor = [UIColor commonGrayTouchHihtLightColor];
        sender.selected = NO;
        [UIView animateWithDuration:0.25 animations:^{
            self.backgroundColor = [UIColor whiteColor];
        }completion:^(BOOL finished) {
        }];
    }
}

- (void) setName:(NSString*) name
{
    [lbName setText:name];
}

- (void)setTestPeriod:(NSString *)testPeriod
{
    [_lbtestPeriod setText:testPeriod];
}

- (void)setArrowHide:(BOOL)isHide {
    arrowImage.hidden = isHide;
}

@end



@interface DeviceInputWeightControl ()
{
    UILabel *lbName;
    UILabel *lbUnit;
    UIImageView *arrowImage;
    UIView *bottomlineView;
    UILabel *subLabel;
}
@end

@implementation DeviceInputWeightControl

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
        
        _lbValue = [[UILabel alloc]init];
        [self addSubview:_lbValue];
        [_lbValue setBackgroundColor:[UIColor clearColor]];
        [_lbValue setTextAlignment:NSTextAlignmentRight];
        [_lbValue setFont:[UIFont font_30]];
        [_lbValue setTextColor:[UIColor blackColor]];
        
        lbUnit = [[UILabel alloc]init];
        [self addSubview:lbUnit];
        [lbUnit setBackgroundColor:[UIColor clearColor]];
        [lbUnit setFont:[UIFont font_30]];
        [lbUnit setTextAlignment:NSTextAlignmentRight];
        [lbUnit setTextColor:[UIColor blackColor]];
        
        arrowImage = [[UIImageView alloc] init];
        [arrowImage setImage:[UIImage imageNamed:@"icon_x_arrows"]];
        [self addSubview:arrowImage];
        
        bottomlineView = [[UIView alloc] init];
        [bottomlineView setBackgroundColor:[UIColor commonCuttingLineColor]];
        [self addSubview:bottomlineView];
        [self addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        [self subviewLayout];
    }
    
    return self;
}

- (void)selectAction:(UIControl *)sender{
    sender.selected ^= 1;
    if (sender.selected) {
        self.backgroundColor = [UIColor commonGrayTouchHihtLightColor];
        sender.selected = NO;
        [UIView animateWithDuration:0.25 animations:^{
            self.backgroundColor = [UIColor whiteColor];
        }completion:^(BOOL finished) {
        }];
    }
}


- (void) subviewLayout
{
    [lbName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12);
        make.centerY.equalTo(self);
        make.width.mas_greaterThanOrEqualTo(@50);
    }];
    
    [arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self.mas_right).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(7, 13));
    }];
    
    [lbUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(arrowImage.mas_left).with.offset(-10);
        make.centerY.equalTo(self);
    }];
    
    [_lbValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lbUnit.mas_left).with.offset(-2);
        make.centerY.equalTo(self);
        make.left.equalTo(lbName.mas_right).offset(5);
    }];
    
    
    [bottomlineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_bottom).with.offset(-1);
        make.left.and.right.equalTo(self);
        make.height.mas_equalTo(1);
    }];
}

- (void) setName:(NSString*) name unit:(NSString*)unit
{
    [lbName setText:name];
    [lbUnit setText:unit];
    
    [lbUnit mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo([lbUnit.text widthSystemFont:lbUnit.font] + 2);
    }];
}

- (void)setSubLabelText:(NSString *)subString {
    if (!subLabel) {
        subLabel = [[UILabel alloc] init];
        [self addSubview:subLabel];
        subLabel.textColor = [UIColor commonGrayTextColor];
        [lbName mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(15);
            make.top.equalTo(self).with.offset(10);
            make.height.mas_equalTo(20);
        }];
        [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbName);
            make.top.equalTo(lbName.mas_bottom);
            make.height.mas_equalTo(20);
        }];
    }
   
    subLabel.text = subString;
}

- (void)setLabelValue:(NSString *)aValue
{
    [_lbValue setText:aValue];
}

- (void)setArrowHide:(BOOL)isHide {
    arrowImage.hidden = isHide;
}

@end


