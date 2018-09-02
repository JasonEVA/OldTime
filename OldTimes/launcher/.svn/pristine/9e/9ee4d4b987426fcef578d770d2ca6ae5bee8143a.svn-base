//
//  CalendarTextViewTableViewCell.m
//  launcher
//
//  Created by William Zhang on 15/7/31.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "CalendarTextViewTableViewCell.h"
#import <Masonry/Masonry.h>
#import "Category.h"
#import "MyDefine.h"
#import "NSString+HandleEmoji.h"
@interface CalendarTextViewTableViewCell ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;

@end

@implementation CalendarTextViewTableViewCell

+ (NSString *)identifier {
    return NSStringFromClass([self class]);;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
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
        make.top.equalTo(self.contentView).offset(5);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(2);
        make.bottom.equalTo(self.contentView).offset(-5).priorityLow();
    }];
    
    [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView).offset(7);
        make.left.equalTo(self).offset(15);
    }];
}

#pragma mark - UITextView Delegate
- (void)textViewDidChange:(NSNotification *)noti {
    self.placeholderLabel.hidden = [self cellText].length;
    //禁用emoji表情
    UITextView *textview = (UITextView *)noti.object;
	NSString *text = [self.textView.text stringByRemovingEmoji];
    if (![text isEqualToString:textview.text]) {
        textview.text = text;
    }
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
	
	NSLog(@"%@", URL.host);
	if ([[URL scheme] isEqualToString:@"tel"]) {
		NSString *phone = URL.host;
		if ([self.clickDelegate respondsToSelector:@selector(calendarTextViewTableViewCellDidClickSpecialText:textType:)]) {
			[self.clickDelegate calendarTextViewTableViewCellDidClickSpecialText:phone textType:RichTextNumber];
		}
		return NO;
	}
	
	return YES;
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
	
	if (content && !self.textView.editable) {
		NSString *regexStr = @"\\d{11}|\\d{10}|\\d{9}|\\d{8}|\\d{7}|\\d{6}|\\d{5}|\\d{4}|\\d{3}-\\d{8}|\\d{3}-\\d{7}|\\d{4}-\\d{8}|\\d{4}-\\d{7}";
		NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:0 error:nil];
		[regex enumerateMatchesInString:content options:0 range:NSMakeRange(0, content.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
			NSRange range = result.range;
			NSString *matchText = [content substringWithRange:range];
			NSLog(@"%lu-%@", range.location, matchText);
			[self.textView.textStorage addAttributes:@{NSUnderlineStyleAttributeName: @(1), NSForegroundColorAttributeName: [UIColor themeBlue]} range:range];
			
			NSURL *appURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", matchText]];
			[self.textView.textStorage addAttribute:NSLinkAttributeName value:appURL range:range];
		}];
	}

}
- (void)textViewEditable:(BOOL)Editable
{
    [self.textView setEditable:Editable];
}


+ (CGFloat)cellForRowHeightWithText:(NSString *)text {
	
	CGSize size = [text boundingRectWithSize:CGSizeMake(IOS_SCREEN_WIDTH - 26,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:NULL].size;
	if (size.height + 10 < 72)
	{
		return size.height + 23;
	}
	else
	{
		return 72;
	}
}
#pragma mark - Initializer
- (UITextView *)textView {
    if (!_textView) {
        NSTextStorage* textStorage = [[NSTextStorage alloc] init];
        NSLayoutManager* layoutManager = [NSLayoutManager new];
        [textStorage addLayoutManager:layoutManager];
        NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:CGSizeZero];
        textContainer.widthTracksTextView = YES;
        [layoutManager addTextContainer:textContainer];
        _textView = [[UITextView alloc] initWithFrame:CGRectZero textContainer:textContainer];
		_textView.userInteractionEnabled = YES;
		_textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:15];
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
