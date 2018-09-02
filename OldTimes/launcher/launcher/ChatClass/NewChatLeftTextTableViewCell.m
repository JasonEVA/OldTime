//
//  NewChatLeftTextTableViewCell.m
//  launcher
//
//  Created by Lars Chen on 15/9/28.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "NewChatLeftTextTableViewCell.h"
#import <MJExtension/MJExtension.h>
#import <Masonry/Masonry.h>
#import "LinkLabel.h"
#import "Category.h"
#import "Slacker.h"

#define MAX_W (165 + [Slacker getXMarginFrom320ToNowScreen] * 2)           // 文本最大宽度

@interface NewChatLeftTextTableViewCell ()
@end

@implementation NewChatLeftTextTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.wz_contentView addSubview:self.messageLabel];
        
        [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.imgViewBubble).insets(UIEdgeInsetsMake(10, 15, 10, 10));
        }];
    }
    
    return self;
}

- (void)setData:(MessageBaseModel *)model {
    [super setData:model];
    
    NSArray *atUserList = [model atUser];
    NSString *text = model._content;
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@" "];
    [self.messageLabel setRichText:text atUserList:atUserList];
}

#define H_GROUPNICK 10
#define H_MIN 80
#define INCREAMENT 25

+ (CGFloat)cellHeightWithContent:(id)content needShowNickName:(BOOL)needShow {
	if (![content isKindOfClass:[NSString class]]) {
		return 0;
	}
	
	// 得到输入文字内容长度
	NSString *text = (NSString *)content;
	text = [text stringByReplacingOccurrencesOfString:@" " withString:@" "];
	
	static LinkLabel *linkLabel = nil;
	if (!linkLabel) {
		linkLabel = [LinkLabel new];
	}
	linkLabel.font = [UIFont mtc_font_30];
	[linkLabel setRichText:text atUserList:nil];
	CGSize size = [TTTAttributedLabel sizeThatFitsAttributedString:linkLabel.attributedText
												   withConstraints:CGSizeMake(MAX_W, CGFLOAT_MAX)
											limitedToNumberOfLines:0];
	
	CGFloat height = MAX(size.height + (INCREAMENT * 2) + 8, H_MIN) + (needShow ? H_GROUPNICK : 0);
	return height;
}

- (void)longPress:(UIGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self.imgViewBubble showTheMenu];
    }
}

#pragma mark - Initializer
@synthesize messageLabel = _messageLabel;
- (LinkLabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [LinkLabel new];
        _messageLabel.userInteractionEnabled = YES;
        _messageLabel.numberOfLines = 0;
        _messageLabel.backgroundColor = [UIColor clearColor];
        
        _messageLabel.preferredMaxLayoutWidth = MAX_W;
        [_messageLabel setLineBreakMode:NSLineBreakByWordWrapping];
        
        [_messageLabel setTextColor:ChatBubbleLeftConfigShare.textColor];
        [_messageLabel setFont:[UIFont mtc_font_30]];
        [_messageLabel setHighlightColor:ChatBubbleLeftConfigShare.atUserColor];
        [_messageLabel setHighlightBackgroundColor:ChatBubbleLeftConfigShare.atUserBackgroudColor];
        
        UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [_messageLabel addGestureRecognizer:press];

    }
    return _messageLabel;
}

@end
