
//
//  ApplyTextViewTableViewCell.m
//  launcher
//
//  Created by Kyle He on 15/8/14.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "ApplyTextViewTableViewCell.h"
#import <Masonry/Masonry.h>
#import "Category.h"
#import "MyDefine.h"
#import "NSString+HandleEmoji.h"
#import "NewApplyFormBaseModel.h"
@interface ApplyTextViewTableViewCell ()

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *placeholderLabel;

@property(nonatomic, strong) NewApplyFormBaseModel  *model;

@end



@implementation ApplyTextViewTableViewCell

+ (NSString *)identifier {
    return NSStringFromClass([self class]);;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier

{
    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange:) name:UITextViewTextDidChangeNotification object:self.textView];
        [self.contentView addSubview:self.textView];
        [self.contentView addSubview:self.placeholderLabel];
        [self initConstraints];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initConstraints {
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(5, 10, 5, 15));
    }];
    
    [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView).offset(7);
        make.left.equalTo(self.textView).offset(5);
    }];
}

#pragma mark - interface method 

- (void)setTextWithModelStr:(NSString *)str
{
    self.textView.text = str;
    self.placeholderLabel.hidden  = str.length;
}
- (void)setDataWithModel:(NewApplyFormBaseModel *)model
{
    self.model = model;
    if ([model.labelText isEqualToString:@"备注"]) {
        self.placeholderLabel.text  = model.labelText;
    }else
    {
        self.placeholderLabel.text = [(id)model placeholder];
    }
}

#pragma mark - UITextViewDelegate


- (void)textViewDidChange:(NSNotification *)noti {
    self.placeholderLabel.hidden = [self cellText].length;
    UITextView *textView = noti.object;
    NSString *text = [NSString disable_EmojiString:textView.text];
    if(![text isEqualToString:textView.text])
    {
        self.textView.text = text; //去除表情
    }
    
    self.model.try_inputDetail = [self cellText];
}

- (void)setDelegate:(id<UITextViewDelegate>)delegate {
    self.textView.delegate = delegate;
}

- (NSString *)cellText {
    
    return self.textView.text;
}

- (UITextView *)textView {
    if (!_textView)
    {
        _textView = [[UITextView alloc] init];
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.tag = 111;
    }
    return _textView;
}

- (UILabel *)placeholderLabel {
    if (!_placeholderLabel)
    {
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.font = [UIFont systemFontOfSize:15];
        _placeholderLabel.textColor = [UIColor lightGrayColor];
        _placeholderLabel.text = LOCAL(APPLY_ADD_DETAIL);
        _placeholderLabel.userInteractionEnabled = YES;
    }
    return _placeholderLabel;
}

@end
