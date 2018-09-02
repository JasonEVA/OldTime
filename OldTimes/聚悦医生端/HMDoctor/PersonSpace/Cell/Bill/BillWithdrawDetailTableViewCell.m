//
//  BillWithdrawDetailTableViewCell.m
//  HMDoctor
//
//  Created by lkl on 16/6/13.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "BillWithdrawDetailTableViewCell.h"

@interface BillWithdrawDetailTableViewCell ()
{
    UILabel *lbName;  
}
@end

@implementation BillWithdrawDetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        lbName = [[UILabel alloc] init];
        [self addSubview:lbName];
        [lbName setText:@"账户余额"];
        [lbName setTextColor:[UIColor commonGrayTextColor]];
        [lbName setFont:[UIFont systemFontOfSize:14]];
        
        _lbAmount = [[UILabel alloc] init];
        [self addSubview:_lbAmount];
        [_lbAmount setText:@"500"];
        [_lbAmount setTextColor:[UIColor commonTextColor]];
        [_lbAmount setFont:[UIFont systemFontOfSize:14]];
        
        [self subViewsLayout];
    }
    return self;
}

- (void)subViewsLayout
{
    [lbName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(70, 20));
    }];
    
    [_lbAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbName.mas_right).with.offset(10);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(120, 20));
    }];
}


@end


@interface BillWithdrawBankCardTableViewCell ()
{
    UIImageView *ivLogo;
    UILabel     *lbBankName;
    UILabel     *lbBankCardNum;
}
@end

@implementation BillWithdrawBankCardTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        ivLogo = [[UIImageView alloc] init];
        [self addSubview:ivLogo];
        [ivLogo setImage:[UIImage imageNamed:@"img_default"]];
        
        lbBankName = [[UILabel alloc] init];
        [self addSubview:lbBankName];
        [lbBankName setTextColor:[UIColor commonTextColor]];
        [lbBankName setFont:[UIFont systemFontOfSize:14]];
        [lbBankName setText:@"点击选择银行卡"];
        
        lbBankCardNum = [[UILabel alloc] init];
        [self addSubview:lbBankCardNum];
        [lbBankCardNum setTextColor:[UIColor commonGrayTextColor]];
        [lbBankCardNum setFont:[UIFont systemFontOfSize:14]];
        
        _ivRightArrow = [[UIImageView alloc] init];
        [self addSubview:_ivRightArrow];
        [_ivRightArrow setImage:[UIImage imageNamed:@"ic_right_arrow"]];

        
        [ivLogo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(12.5);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        [lbBankName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ivLogo.mas_right).with.offset(10);
            make.top.equalTo(self).with.offset(8);
            make.size.mas_equalTo(CGSizeMake(200, 20));
        }];
        
        [lbBankCardNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ivLogo.mas_right).with.offset(10);
            make.top.equalTo(lbBankName.mas_bottom).with.offset(4);
            make.size.mas_equalTo(CGSizeMake(240, 20));
        }];
        
        [_ivRightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).with.offset(-12.5);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(8, 15));
        }];
    }
    return self;
}

- (void)setBankCardInfo:(BankCardInfo *)bankCard
{
    [lbBankName setText:bankCard.bankName];
    [lbBankCardNum setText:bankCard.cardNo];
}

@end


@interface BillWithdrawMoneyTableViewCell ()<UITextFieldDelegate>
{
    UILabel *lbName;
    BOOL isHaveDian;
}
@end

@implementation BillWithdrawMoneyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        lbName = [[UILabel alloc] init];
        [self addSubview:lbName];
        [lbName setText:@"提现金额"];
        [lbName setTextColor:[UIColor commonGrayTextColor]];
        [lbName setFont:[UIFont systemFontOfSize:14]];
        
        _tfMoney = [[UITextField alloc] init];
        [self addSubview:_tfMoney];
        [_tfMoney setPlaceholder:@"最低提现金额¥100元"];
        [_tfMoney setFont:[UIFont systemFontOfSize:15]];
        [_tfMoney setKeyboardType:UIKeyboardTypeDecimalPad];
        [_tfMoney setDelegate:self];
        
        [self subViewsLayout];
    }
    return self;
}

- (void)subViewsLayout
{
    [lbName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(70, 20));
    }];
    
    [_tfMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbName.mas_right);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        isHaveDian = NO;
    }
    
    if ([string length] > 0) {
        
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
            
            //首字母不能为0和小数点
            if([textField.text length] == 0){
                if(single == '.') {
                    [self showAlertMessage:@"亲，第一个数字不能为小数点"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
                /*if (single == '0') {
                    [self showAlertMessage:@"亲，第一个数字不能为0"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }*/
            }
            
            //输入的字符是否是小数点
            if (single == '.') {
                if(!isHaveDian)//text中还没有小数点
                {
                    isHaveDian = YES;
                    return YES;
                    
                }else{
                    [self showAlertMessage:@"亲，您已经输入过小数点了"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }else{
                if (isHaveDian) {//存在小数点
                    
                    //判断小数点的位数
                    NSRange ran = [textField.text rangeOfString:@"."];
                    if (range.location - ran.location <= 2) {
                        return YES;
                    }else{
                        [self showAlertMessage:@"亲，您最多输入两位小数"];
                        return NO;
                    }
                }else{
                    return YES;
                }
            }
        }else{//输入的数据格式不正确
            [self showAlertMessage:@"亲，您输入的格式不正确"];
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        return YES;
    }
}


@end



@interface BillWithdrawConfirmTableViewCell ()
{
    UILabel *lbConfirm;
}
@end

@implementation BillWithdrawConfirmTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        [self.contentView setBackgroundColor:[UIColor commonBackgroundColor]];
        lbConfirm = [[UILabel alloc] init];
        [lbConfirm setBackgroundColor:[UIColor mainThemeColor]];
        [lbConfirm setFont:[UIFont systemFontOfSize:15]];
        [lbConfirm setText:@"确定提现"];
        [lbConfirm setTextColor:[UIColor whiteColor]];
        [lbConfirm setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:lbConfirm];
        
        lbConfirm.layer.borderColor = [[UIColor mainThemeColor] CGColor];
        lbConfirm.layer.borderWidth = 0.5;
        lbConfirm.layer.cornerRadius = 2.5f;
        lbConfirm.layer.masksToBounds = YES;
        
        [self subviewsLayout];
    }
    return self;
}

- (void)subviewsLayout
{
    [lbConfirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(12.5);
        make.right.equalTo(self.contentView).with.offset(-12.5);
        make.top.and.bottom.equalTo(self.contentView);
        //make.height.mas_equalTo(47);
    }];
}


@end

