//
//  BankCardInfoView.m
//  HMDoctor
//
//  Created by lkl on 16/6/13.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "BankCardInfoView.h"

@implementation BankCardInfoView

@end


@interface BankCardholderView ()<UITextFieldDelegate>
{
    UILabel *lbName;
}
@end

@implementation BankCardholderView

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        lbName = [[UILabel alloc] init];
        [self addSubview:lbName];
        [lbName setText:@"持卡人"];
        [lbName setTextColor:[UIColor commonTextColor]];
        [lbName setFont:[UIFont systemFontOfSize:15]];
        
        [lbName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(12.5);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(70, 20));
        }];
        
        _tfCardName = [[UITextField alloc] init];
        [self addSubview:_tfCardName];
        [_tfCardName setPlaceholder:@"请输入持卡人姓名"];
        [_tfCardName setFont:[UIFont systemFontOfSize:15]];
        
        [_tfCardName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbName.mas_right);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(240, 20));
        }];
        
        _iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_iconButton];
        [_iconButton setImage:[UIImage imageNamed:@"icon_addcard_infor"] forState:UIControlStateNormal];
        
        [_iconButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).with.offset(-12.5);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
    }
    return self;
}

@end



@interface BankCardNumView ()<UITextFieldDelegate>
{
    UILabel *lbName;
}
@end

@implementation BankCardNumView

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        lbName = [[UILabel alloc] init];
        [self addSubview:lbName];
        [lbName setText:@"卡号"];
        [lbName setTextColor:[UIColor commonTextColor]];
        [lbName setFont:[UIFont systemFontOfSize:15]];
        
        [lbName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(12.5);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(70, 20));
        }];
        
        _tfCardNum = [[UITextField alloc] init];
        [self addSubview:_tfCardNum];
        [_tfCardNum setDelegate:self];
        [_tfCardNum setPlaceholder:@"请输入银行卡号"];
        [_tfCardNum setFont:[UIFont systemFontOfSize:15]];
        [_tfCardNum setKeyboardType:UIKeyboardTypeNumberPad];
        
        [_tfCardNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbName.mas_right);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(240, 20));
        }];
        

    }
    return self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField.text.length > 23)
    {
        return NO;
    }
    if (textField == _tfCardNum)
    {
        // 四位加一个空格
        if ([string isEqualToString:@""])
        {
            // 删除字符
            if ((textField.text.length - 2) % 5 == 0)
            {
                textField.text = [textField.text substringToIndex:textField.text.length - 1];
            }
            return YES;
        } else
        {
            if (textField.text.length % 5 == 0) {
                textField.text = [NSString stringWithFormat:@"%@ ", textField.text];
            }
        }
        return YES;
    }
    return YES;
}


@end




@interface BankNameControl ()
{
    UILabel *lbName;
    UIImageView *ivRightArrow;
}
@end

@implementation BankNameControl

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        lbName = [[UILabel alloc] init];
        [self addSubview:lbName];
        [lbName setText:@"银行"];
        [lbName setTextColor:[UIColor commonTextColor]];
        [lbName setFont:[UIFont systemFontOfSize:15]];
        
        [lbName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(12.5);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(70, 20));
        }];
        
        _lbBankName = [[UILabel alloc] init];
        [self addSubview:_lbBankName];
        [_lbBankName setText:@"请选择银行"];
        [_lbBankName setTextColor:[UIColor commonTextColor]];
        [_lbBankName setFont:[UIFont systemFontOfSize:15]];
        
        [_lbBankName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbName.mas_right);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(150, 20));
        }];
        
        ivRightArrow = [[UIImageView alloc] init];
        [self addSubview:ivRightArrow];
        [ivRightArrow setImage:[UIImage imageNamed:@"ic_right_arrow"]];
        
        [ivRightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).with.offset(-12.5);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(8, 15));
        }];
    }
    return self;
}

@end
