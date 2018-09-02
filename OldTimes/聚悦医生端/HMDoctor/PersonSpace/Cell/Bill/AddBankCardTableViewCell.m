//
//  AddBankCardTableViewCell.m
//  HMDoctor
//
//  Created by lkl on 16/6/13.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "AddBankCardTableViewCell.h"

@implementation AddBankCardTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@interface AddBankCardCardholderTableViewCell ()
{
    UILabel *lbName;
    UITextField *tfCardNum;
    UIButton *iconButton;
}
@end

@implementation AddBankCardCardholderTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        
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
        
        tfCardNum = [[UITextField alloc] init];
        [self addSubview:tfCardNum];
        
        [tfCardNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbName.mas_right);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(240, 20));
        }];
    }
    
    return self;
}

@end


@interface AddBankCardNumTableViewCell ()<UITextFieldDelegate>
{
    UILabel *lbName;
    UITextField *tfCardNum;
}
@end

@implementation AddBankCardNumTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
     
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
        
        tfCardNum = [[UITextField alloc] init];
        [self addSubview:tfCardNum];
        [tfCardNum setDelegate:self];
        [tfCardNum setPlaceholder:@"请输入银行卡号"];
        [tfCardNum setFont:[UIFont systemFontOfSize:15]];
        [tfCardNum setKeyboardType:UIKeyboardTypeNumberPad];
        
        [tfCardNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbName.mas_right);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(240, 20));
        }];
        
    }
    
    return self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{

    if (textField == tfCardNum)
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

@interface addbankCardBankTableViewCell ()
{
    UILabel *lbName;
    UIImageView *ivRightArrow;
}
@end

@implementation addbankCardBankTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        
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


@interface AddBankCardNextTableViewCell ()
{
    UILabel *lbNext;
}
@end

@implementation AddBankCardNextTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        [self.contentView setBackgroundColor:[UIColor commonBackgroundColor]];
        lbNext = [[UILabel alloc] init];
        [lbNext setBackgroundColor:[UIColor mainThemeColor]];
        [lbNext setFont:[UIFont systemFontOfSize:15]];
        [lbNext setText:@"下一步"];
        [lbNext setTextColor:[UIColor whiteColor]];
        [lbNext setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:lbNext];
        
        lbNext.layer.borderColor = [[UIColor mainThemeColor] CGColor];
        lbNext.layer.borderWidth = 0.5;
        lbNext.layer.cornerRadius = 2.5f;
        lbNext.layer.masksToBounds = YES;
        
        [self subviewsLayout];
    }
    return self;
}

- (void)subviewsLayout
{
    [lbNext mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(12.5);
        make.right.equalTo(self.contentView).with.offset(-12.5);
        make.top.and.bottom.equalTo(self.contentView);
        //make.height.mas_equalTo(47);
    }];
}


@end
