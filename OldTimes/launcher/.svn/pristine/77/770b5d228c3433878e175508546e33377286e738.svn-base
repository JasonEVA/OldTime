//
//  ApplyAddExpendTxtFieldTableViewCell.m
//  launcher
//
//  Created by Kyle He on 15/8/17.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "ApplyAddExpendTxtFieldTableViewCell.h"
#import <Masonry/Masonry.h>
#import "Category.h"

@interface ApplyAddExpendTxtFieldTableViewCell()<UITextFieldDelegate>

@end

@implementation ApplyAddExpendTxtFieldTableViewCell
+ (NSString *)identifier {
    return NSStringFromClass([self class]);;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
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

- (UITextField *)expendField
{
    if (!_expendField)
    {
        _expendField = [[UITextField alloc] init];
        _expendField.tag = 11;
        _expendField.textAlignment = NSTextAlignmentRight;
        //带小数点的键盘
        _expendField.keyboardType = UIKeyboardTypeDecimalPad;
        _expendField.font = [UIFont mtc_font_30];
        _expendField.textColor = [UIColor minorFontColor];
    }
    return _expendField;
}

#pragma mark - setter and getter

- (void)setDelegate:(id<UITextFieldDelegate>)delegate
{
    self.expendField.delegate = delegate;
}

@end
