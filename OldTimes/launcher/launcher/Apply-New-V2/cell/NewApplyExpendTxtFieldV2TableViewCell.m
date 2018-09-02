//
//  NewApplyExpendTxtFieldV2TableViewCell.m
//  launcher
//
//  Created by Dee on 16/8/10.
//  Copyright © 2016年 William Zhang. All rights reserved.
// 

#import "NewApplyExpendTxtFieldV2TableViewCell.h"
#import <Masonry/Masonry.h>
#import "Category.h"
#import "NSString+ApplyFeeHandle.h"
#import "NewApplyFormBaseModel.h"
#import "NSString+ApplyFeeHandle.h"
#import "NSString+HandleEmoji.h"
@interface NewApplyExpendTxtFieldV2TableViewCell()<UITextFieldDelegate>

@property(nonatomic, copy) textChangeCallBackBlcok  myblock;

@property(nonatomic, copy) textFieldLocationBlock  locationBlock;

@property(nonatomic, assign) BOOL  isAccountType;

@property(nonatomic, strong) NewApplyFormBaseModel  *model;


@end

@implementation NewApplyExpendTxtFieldV2TableViewCell


+ (NSString *)identifier {
    return NSStringFromClass([self class]);;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isAccountType:(BOOL)isAccountType
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.isAccountType = isAccountType;
        
        [self.expendField addTarget:self action:@selector(TextfieldValueDidChanged:) forControlEvents:UIControlEventEditingChanged];
        
        [self.contentView addSubview:self.expendField];
        [self.expendField mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.right.equalTo(self.contentView).offset(-12);
             make.centerY.equalTo(self.contentView);
             make.left.equalTo(self.contentView).offset(60);
         }];
    }
    return self;
}


#pragma mark - interfaceMethod
- (void)setDataWithModel:(NewApplyFormBaseModel *)model
{
    self.model = model;
    self.expendField.placeholder = [(id)model placeholder];
    self.expendField.text = model.try_inputDetail;
    self.textLabel.text = model.labelText;
}

- (void)getTextWithBlock:(textChangeCallBackBlcok)block
{
    self.myblock = block;
}

- (void)getLocationWithBlock:(textFieldLocationBlock)block
{
    self.locationBlock = block;
}

#pragma mark - uitextfieldDelegate

-(void)TextfieldValueDidChanged:(UITextField *)textField
{
    if (self.isAccountType) {
        if ([textField.text isEqualToString:@""]) {
            textField.text = @"";
            return;
        } else {
            if ([textField.text rangeOfString:@"￥"].location != NSNotFound) {
                textField.text = [textField.text stringByReplacingOccurrencesOfString:@"￥" withString:@""];
                textField.text = [@"￥" stringByAppendingString:textField.text];
            } else {
                textField.text = [@"￥" stringByAppendingString:textField.text];
            }
            
            NSString *str = [textField.text stringByReplacingOccurrencesOfString:@"￥" withString:@""];
            NSString *result = [NSString generateCustomeMoneyTextWithCurrentText:str];
            textField.text = result;
        }
    }
    
    NSString *text = [NSString disable_EmojiString:textField.text];
    if (![text isEqualToString:textField.text]) {
        textField.text = text;
    }
    if (text.length >= 300) {
        textField.text =  [text substringWithRange:NSMakeRange(0, 500)];
    }
    
    [self gettextWithTextField:textField];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.isAccountType) {
        NSRange oldDotRange = [textField.text rangeOfString:@"."];
        NSRange newDotRange = [string rangeOfString:@"."];
        
        if (oldDotRange.location != NSNotFound && newDotRange.location != NSNotFound) {
            return NO;
        }
        
        if (textField.text.length <= 1  && ([string isEqualToString:@"0"] || newDotRange.location != NSNotFound)) {
            textField.text = @"￥0.";
            return NO;
        }
        
        if (oldDotRange.location != NSNotFound) {
            NSArray *numArr = [textField.text componentsSeparatedByString:@"."];
            NSString *str = [numArr lastObject];
            //按减号的时候，允许删除
            if ([string isEqualToString:@""]) {
                return YES;
            }else if (str.length >= 2 ) {
                return NO;
            }
        }
        
        
        NSString *tempStr = [NSString filterStrWithCustomeMoneyStrText:textField.text];
        if (oldDotRange.location == NSNotFound && newDotRange.location == NSNotFound) {
            if (tempStr.length >= 13 && ![string isEqualToString:@""]) {
                return NO;
            }
        }else{
            if (tempStr.length >= 15 && ![string isEqualToString:@""]) {
                return NO;
            }
        }
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    CGRect convertRect = [self.contentView convertRect:self.expendField.bounds  toView:nil];
    CGRect tempRect = CGRectMake(convertRect.origin.x, convertRect.origin.y, self.expendField.frame.size.width, self.expendField.frame.size.height);
    if (self.locationBlock) {
        self.locationBlock(tempRect);
    }
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (self.isAccountType) {
        [self filterWithtext:textField];
    }
    return YES;
}

- (void)filterWithtext:(UITextField *)textfield
{
    if ([textfield.text containsString:@"￥"]) {
        NSRange raneg = [textfield.text rangeOfString:@"."];
        if (raneg.location + 1 == textfield.text.length) {
            textfield.text = [textfield.text stringByReplacingOccurrencesOfString:@"." withString:@""];
            [self gettextWithTextField:textfield];
        }
    }
}

//金额
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.isAccountType) {
        [self filterWithtext:textField];
    }
    return YES;
}

- (void)gettextWithTextField:(UITextField *)textField
{
    
//    BOOL isfeeText = [self.model.labelText isEqualToString:@"金额"];
//    NSString *dealedStr =  isfeeText?[NSString filterStrWithCustomeMoneyStrText:textField.text]:textField.text;
   //只需要带符号的字符串，不用做其他处理 －－ 如果后期改动在这里做进一步处理
    self.model.try_inputDetail = textField.text;
}

#pragma mark - setter and getter

- (UITextField *)expendField
{
    if (!_expendField)
    {
        _expendField = [[UITextField alloc] init];
        _expendField.tag = 11;
        _expendField.textAlignment = NSTextAlignmentRight;
        //带小数点的键盘
        _expendField.keyboardType = self.isAccountType?UIKeyboardTypeDecimalPad:UIKeyboardTypeDefault;
        _expendField.font = [UIFont mtc_font_30];
        _expendField.textColor = [UIColor minorFontColor];
        _expendField.delegate = self;
    }
    return _expendField;
}

@end
