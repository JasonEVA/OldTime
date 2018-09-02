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
//#import "Category.h"
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

- (void)showTextMessage:(MessageBaseModel *)message {
    
    NSArray *atUserList = [message atUser];
    NSString *text = message._content;
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@" "];
    [self.messageLabel setRichText:text atUserList:atUserList];
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
        [_messageLabel setFont:[UIFont systemFontOfSize:15]];
        [_messageLabel setHighlightColor:ChatBubbleLeftConfigShare.atUserColor];
        [_messageLabel setHighlightBackgroundColor:ChatBubbleLeftConfigShare.atUserBackgroudColor];
        
        UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [_messageLabel addGestureRecognizer:press];

    }
    return _messageLabel;
}

@end
