//
//  PatientReceiptMessageRightTableViewCell.m
//  HMDoctor
//
//  Created by jasonwang on 2017/8/3.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "PatientReceiptMessageRightTableViewCell.h"
#import <MJExtension/MJExtension.h>
#import <Masonry/Masonry.h>
#import "LinkLabel.h"
//#import "Category.h"
#import "Slacker.h"
#import "MessageBaseModel+CellSize.h"

#define MAX_W (165 + [Slacker getXMarginFrom320ToNowScreen] * 2 - RECEIPTSTATUSLBWIDTH)           // 文本最大宽度

#define RECEIPTSTATUSLBWIDTH        50

@interface PatientReceiptMessageRightTableViewCell ()
@property (nonatomic, strong) UILabel *receiptStatusLb;
@end

@implementation PatientReceiptMessageRightTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.wz_contentView addSubview:self.messageLabel];
        [self.wz_contentView addSubview:self.receiptStatusLb];

        [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.imgViewBubble).insets(UIEdgeInsetsMake(10, 10, 10, 15));
        }];
        [self.receiptStatusLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.messageLabel);
            make.width.equalTo(@RECEIPTSTATUSLBWIDTH);
            make.right.equalTo(self.imgViewBubble.mas_left).offset(-5);
        }];
    }
    
    return self;
}

- (void)showTextMessage:(MessageBaseModel *)message {
    
    NSString *text = message._content;
    
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@" "];
    
    [self.messageLabel setRichText:text atUserList:nil];
    
    if (!message._markReaded) {
        [self.receiptStatusLb setText:@"患者未读"];
    }
    else {
        [self.receiptStatusLb setText:@"患者已读"];
    }
    
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
        
        [_messageLabel setTextColor:ChatBubbleRightConfigShare.textColor];
        [_messageLabel setFont:[UIFont systemFontOfSize:15]];
        [_messageLabel setHighlightColor:ChatBubbleRightConfigShare.atUserColor];
        [_messageLabel setHighlightBackgroundColor:ChatBubbleRightConfigShare.atUserBackgroudColor];
        
        UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        press.minimumPressDuration = 0.5;
        [_messageLabel addGestureRecognizer:press];
    }
    
    return _messageLabel;
}

- (UILabel *)receiptStatusLb {
    if (!_receiptStatusLb) {
        _receiptStatusLb = [UILabel new];
        [_receiptStatusLb setText:@"患者已读"];
        [_receiptStatusLb setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_receiptStatusLb setFont:[UIFont systemFontOfSize:12]];
    }
    return _receiptStatusLb;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
