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
        [self.contentView addSubview:self.textField];
        [self.textField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.contentView).multipliedBy(0.67);
            make.right.equalTo(self.contentView).offset(-15);
            make.height.centerY.equalTo(self.contentView);
        }];

    }
    return self;
}

- (void)configTextFieldText:(NSString *)text editing:(BOOL)isEditing {
    [self.textField setText:text];
    [self.textField setEnabled:isEditing];
    [self.textField setKeyboardType:UIKeyboardTypeDefault];
    self.isPhone = NO;
}

- (void)configTextFieldISPhone:(BOOL)isPhone
{
    self.isPhone = YES;
    self.textField.keyboardType = UIKeyboardTypePhonePad;
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

- (UITextField *)textField {
    if (!_textField) {
        _textField = [UITextField new];
        [_textField setDelegate:self];
        [_textField setTextColor:[UIColor grayColor]];
        [_textField setTextAlignment:NSTextAlignmentRight];
        [_textField setEnabled:NO];
    }
    return _textField;
}
@end
