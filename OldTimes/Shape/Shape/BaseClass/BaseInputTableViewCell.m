//
//  BaseInputTableViewCell.m
//  PalmDoctorPT
//
//  Created by Andrew Shen on 15/4/11.
//  Copyright (c) 2015年 Andrew Shen. All rights reserved.
//

#import "BaseInputTableViewCell.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"


@implementation BaseInputTableViewCell


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.txtFd = [UITextField new];
        [self.txtFd setDelegate:self];
        [self.txtFd setTextColor:[UIColor whiteColor]];
        [self.txtFd setTextAlignment:NSTextAlignmentRight];
        [self.txtFd setEnabled:NO];
        [self.contentView addSubview:self.txtFd];
        [self needsUpdateConstraints];
        [self setBackgroundColor:[UIColor themeBackground_373737]];

    }
    return self;
}

- (void)setTextFieldText:(NSString *)text editing:(BOOL)isEditing {
    [self.txtFd setText:text];
    [self.txtFd setEnabled:isEditing];
    [self.txtFd setKeyboardType:UIKeyboardTypeDefault];
    self.isPhone = NO;
}

- (void)setTextFieldISPhone:(BOOL)isPhone
{
    self.isPhone = YES;
    self.txtFd.keyboardType = UIKeyboardTypePhonePad;
}

- (void)updateConstraints
{
    [self.txtFd mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textLabel.mas_right).offset(10);
        make.right.equalTo(self).offset(-35);
        make.height.centerY.equalTo(self.contentView);
    }];
    
    //according to apple super should be called at end of method
    [super updateConstraints];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (_isPhone == NO) {
        NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
        text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSArray *arr=[text componentsSeparatedByString:@"."];
        if(arr.count>1){
            NSString *ss=[arr objectAtIndex:1];
            if(ss.length>2){
                return NO;
            }
        }
        if(_isNumber){
            return [self validateNumber:string text:text];
        }else{
            return YES;
        }

    }else {
            NSString * str = [NSString stringWithFormat:@"%@%@",textField.text,string];
            if (str.length > 11) {
                return NO;
            }else {
                return YES;
            }
    }
}

- (BOOL)validateNumber:(NSString*)number text:(NSString*)text{
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    //判断最大值和最小值
    float value=[text floatValue];
    if(res&&_numberMax>0&&value>_numberMax){
        res=NO;
    }else if(value<_numberMin){
        res=NO;
    }
    return res;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(InputCellDelegateCallBack_startEditWithTag:)])
    {
        [self.delegate InputCellDelegateCallBack_startEditWithTag:self.tag];
    }
    if ([self.delegate respondsToSelector:@selector(InputCellDelegateCallBack_startEditWithIndexPath:)])
    {
        [self.delegate InputCellDelegateCallBack_startEditWithIndexPath:self.indexPath];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(InputCellDelegateCallBack_endEditWithTag:)])
    {
        [self.delegate InputCellDelegateCallBack_endEditWithTag:self.tag];
    }
    if ([self.delegate respondsToSelector:@selector(InputCellDelegateCallBack_endEditWithIndexPath:)])
    {
        [self.delegate InputCellDelegateCallBack_endEditWithIndexPath:self.indexPath];
    }
}
@end
