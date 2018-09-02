//
//  ApplyTextFieldTableViewCell.m
//  launcher
//
//  Created by Kyle He on 15/8/14.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "ApplyTextFieldTableViewCell.h"
#import <Masonry/Masonry.h>
#import "Category.h"
#import "MyDefine.h"

@interface ApplyTextFieldTableViewCell () <UITextFieldDelegate>

@property(nonatomic, strong) UITextField  *textField;
@property (nonatomic, copy) void (^textEndEdtingBlock)(NSString *);

@end

@implementation ApplyTextFieldTableViewCell

+ (NSString *)identifier
{
    return NSStringFromClass([self class]);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
       [self.contentView addSubview:self.textField];
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 14, 0, 13));
        }];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textfieldTextChanged:) name:nil object:self.textField];
    }
    return  self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma interface method
- (void)setTitle:(NSString *)title
{
    self.textField.text = title;
}

- (void)settextfieldPlaceHolder:(NSString *)string
{
    self.textField.placeholder = string;
}

- (void)textEndEdting:(void (^)(NSString *))textBlock {
    self.textEndEdtingBlock = textBlock;
}

#pragma mark - UITextField Delegate
- (void)textfieldTextChanged:(NSNotification *)noti
{
    UITextField *textfield = noti.object;
    !self.textEndEdtingBlock ?: self.textEndEdtingBlock(textfield.text);
}

#pragma mark - initializer

- (void)setDelegate:(id<UITextFieldDelegate>)delegate
{
    self.textField.delegate = delegate;
}

- (UITextField *)textField
{
    if (!_textField)
    {
        _textField = [[UITextField alloc]init];
        _textField.font = [UIFont systemFontOfSize:15];
        _textField.textColor = [UIColor blackColor];
        _textField.placeholder = LOCAL(MEETING_TITLE);
        _textField.tag = 10;
    }
    return _textField;
}

- (NSString *)cellText
{
    return self.textField.text;
}

@end
