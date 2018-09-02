//
//  BaseInputTableViewCell.m
//  PalmDoctorPT
//
//  Created by Andrew Shen on 15/4/11.
//  Copyright (c) 2015年 Andrew Shen. All rights reserved.
//

#import "BaseInputTableViewCell.h"
#import <Masonry.h>

@implementation BaseInputTableViewCell

+ (NSString *)identifier { return NSStringFromClass(self); }

- (void)awakeFromNib {
    // Initialization code
    _isNumber=NO;
    _numberMax=0.0;
    _numberMin=0.0;
    _isPhone = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.txtFd = [UITextField new];
        [self.txtFd setDelegate:self];
        [self.contentView addSubview:self.txtFd];
        
        [self.txtFd mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.textLabel.mas_right).offset(10);
            make.left.lessThanOrEqualTo(self.contentView).offset(12).priorityLow();
            make.right.equalTo(self.contentView).offset(-15);
            make.top.bottom.equalTo(self.contentView);
        }];

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

- (void)setPlaceholder:(NSString *)placeholder {
    self.txtFd.placeholder = placeholder;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (_isPhone == NO) {
        if(_isNumber){
            NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
            text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            return [self validateNumber:string text:text];
        }
        
        
        return YES;
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

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(OutputCellDelegateCallBack_endEditWithTag:)])
    {
        [self.delegate OutputCellDelegateCallBack_endEditWithTag:self.tag];
    }
    if ([self.delegate respondsToSelector:@selector(OutputCellDelegateCallBack_startEditWithTag:)])
    {
        [self.delegate OutputCellDelegateCallBack_startEditWithTag:self.indexPath];
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
    if ([self.delegate respondsToSelector:@selector(InputCellEndEdting:)]) {
        [self.delegate InputCellEndEdting:self];
    }
}
@end
