//
//  MeSuggestEditContentTableViewCell.m
//  launcher
//
//  Created by Kyle He on 15/9/22.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "MeSuggestEditContentTableViewCell.h"
#import "Masonry.h"
#import "UIColor+Hex.h"
#import "MyDefine.h"

@interface MeSuggestEditContentTableViewCell ()<UITextViewDelegate>

@property(nonatomic, strong) UILabel  *placeHoldLbl;

@property(nonatomic, strong) UITextView  *textView;

@end

@implementation MeSuggestEditContentTableViewCell

+ (NSString *)identifier
{
    return NSStringFromClass([self class]);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self createFrame];
    }
    return self;
}

#pragma mark -  UITextFieldDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    self.placeHoldLbl.hidden = textView.text.length;
}

#pragma mark - SetterAndGetter
- (void)createFrame
{
    [self addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(10);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self);
    }];
    [self addSubview:self.placeHoldLbl];
    [self.placeHoldLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView).offset(4);
        make.left.equalTo(self.contentView).offset(19);
        make.right.equalTo(self.textView);
    }];
}

- (UILabel *)placeHoldLbl
{
    if (!_placeHoldLbl)
    {
        _placeHoldLbl = [[UILabel alloc] init];
        _placeHoldLbl.text = LOCAL(ME_INPUT_BACKCONTENT);
        _placeHoldLbl.textColor = [UIColor mtc_colorWithHex:0xc5c5c5];
    }
    return _placeHoldLbl;
}

- (UITextView *)textView
{
    if (!_textView)
    {
        _textView = [[UITextView alloc] init];
        _textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:15.0f];
    }
    return _textView;
}
@end
