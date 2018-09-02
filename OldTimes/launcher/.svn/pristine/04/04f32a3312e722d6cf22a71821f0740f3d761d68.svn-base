//
//  TextViewTableViewCell.m
//  launcher
//
//  Created by TabLiu on 16/3/18.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "TextViewTableViewCell.h"
#import <Masonry/Masonry.h>

@interface TextViewTableViewCell ()<UITextViewDelegate>


@property (nonatomic,strong) UILabel * placeholderLabel;

@end

@implementation TextViewTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.textView];
        [self.textView addSubview:self.placeholderLabel];
        
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(self.contentView).offset(5);
            make.right.equalTo(self.contentView).offset(-15);
            make.bottom.equalTo(self.contentView).offset(-12);
        }];
        [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.textView);
            make.top.equalTo(self.textView).offset(5);
        }];
    }
    return self;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    self.placeholderLabel.text = placeholder;
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.placeholderLabel.hidden = YES;
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    NSString * content = textView.text;
    if (!content.length) {
        self.placeholderLabel.hidden = NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (_delegate && [_delegate respondsToSelector:@selector(cellEndEditingWithStr:)]) {
        [_delegate cellEndEditingWithStr:textView.text];
    }
}

#pragma mark - init
- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:15];
    }
    return _textView;
}
- (UILabel *)placeholderLabel
{
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.userInteractionEnabled = YES;
        _placeholderLabel.font = [UIFont systemFontOfSize:15];
        _placeholderLabel.textAlignment = NSTextAlignmentLeft;
        _placeholderLabel.textColor = [UIColor colorWithRed:121/255.0 green:121/255.0 blue:121/255.0 alpha:1.0];
    }
    return _placeholderLabel;
}

@end
