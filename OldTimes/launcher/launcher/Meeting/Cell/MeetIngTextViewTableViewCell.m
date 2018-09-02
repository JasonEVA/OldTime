//
//  MeetIngTextViewTableViewCell.m
//  launcher
//
//  Created by Conan Ma on 15/8/7.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "MeetIngTextViewTableViewCell.h"
#import <Masonry/Masonry.h>
#import "MyDefine.h"
#import "UIColor+Hex.h"
#import "NSString+HandleEmoji.h"
@interface MeetIngTextViewTableViewCell()

@property (nonatomic, strong) UILabel *placeholderLabel;

@end

@implementation MeetIngTextViewTableViewCell

+ (NSString *)identifier { return NSStringFromClass(self); }

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = [UIColor whiteColor];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange:) name:UITextViewTextDidChangeNotification object:self.textView];
        
        [self initCompenents];
    }
    return self;
}

#pragma mark - Privite Methods
- (void)initCompenents
{
    [self.contentView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-20);
        make.bottom.equalTo(self.contentView).offset(-5);
    }];
    
    [self.contentView addSubview:self.placeholderLabel];
    [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView).offset(7);
        make.left.equalTo(self.textView).offset(5);
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)dismissKeyBoard
{
    [self.textView resignFirstResponder];
}

#pragma mark - UITextView Delegate
- (void)textViewDidChange:(NSNotification *)noti {
    self.placeholderLabel.hidden = [self cellText].length;
    UITextView *textView = (UITextView *)noti.object;
	NSString *text = [textView.text stringByRemovingEmoji];
    if (![text isEqualToString:textView.text]) {
        textView.text = text;
    }
}

#pragma mark - Getter And Setter
- (NSString *)cellText {
    return self.textView.text;
}

- (void)setDelegate:(id<UITextViewDelegate>)delegate {
    self.textView.delegate = delegate;
}

- (void)setContent:(NSString *)content {
    self.textView.text = content;
    [self.placeholderLabel setHidden:[content length]];
}

#pragma mark - Initializer
@synthesize textView = _textView;
- (UITextView *)textView
{
    if (!_textView)
    {
        _textView = [[UITextView alloc] initWithFrame:CGRectZero];
        [_textView setTextColor:[UIColor themeGray]];
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.textColor = [UIColor blackColor];
    }
    return _textView;
}

- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.font = [UIFont systemFontOfSize:15];
        _placeholderLabel.textColor = [UIColor mtc_colorWithW:183];
        _placeholderLabel.text = LOCAL(CALENDAR_ADD_DETAIL);
        _placeholderLabel.userInteractionEnabled = YES;
    }
    return _placeholderLabel;
}
@end
