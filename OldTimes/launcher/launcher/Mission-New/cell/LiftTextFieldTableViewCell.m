//
//  LiftTextFieldTableViewCell.m
//  launcher
//
//  Created by TabLiu on 16/2/19.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "LiftTextFieldTableViewCell.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"
#import "NSString+HandleEmoji.h"
#define Blue_Color  [UIColor colorWithRed:8/255.0 green:119/255.0 blue:192/255.0 alpha:1]

@interface LiftTextFieldTableViewCell ()<UITextFieldDelegate>

@property (nonatomic,strong) UIImageView * iconImageView;

@property (nonatomic,strong) UITextField * textField;

@end

@implementation LiftTextFieldTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self.contentView setBackgroundColor:Blue_Color];

        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.textField];
        
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.centerY.equalTo(self.contentView);
            make.width.height.equalTo(@20);
        }];
        
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImageView.mas_right).offset(10);
            make.right.equalTo(self.contentView).offset(-25);
            make.centerY.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setIconImg:(NSString *)str
{
    [self.iconImageView setImage:[UIImage imageNamed:str]];
}
- (void)showKeyboard
{
    [self.textField becomeFirstResponder];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textField resignFirstResponder];
    return NO;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (_delegate && [_delegate respondsToSelector:@selector(textField_ShouldBeginEditing)]) {
        [_delegate textField_ShouldBeginEditing];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (_delegate && [_delegate respondsToSelector:@selector(textField_ShouldEndEditingWithText:)]) {
        [_delegate textField_ShouldEndEditingWithText:_textField.text];
    }
}

- (void)textViewDidChange:(NSNotification *)noti
{
    UITextField *textfield = noti.object;
	NSString *text = [textfield.text stringByRemovingEmoji];
    if (![text isEqualToString:textfield.text]) {
        textfield.text = text;
    }
}

- (UIImageView  *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.userInteractionEnabled = YES;
    }
    return _iconImageView;
}

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.delegate = self;
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        _textField.returnKeyType = UIReturnKeyDone;
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange:) name:nil object:_textField];
    }
    return _textField;
}





@end
