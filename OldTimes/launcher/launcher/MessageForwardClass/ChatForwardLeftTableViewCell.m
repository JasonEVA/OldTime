//
//  ChatForwardLeftTableViewCell.m
//  launcher
//
//  Created by williamzhang on 16/3/31.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "ChatForwardLeftTableViewCell.h"
#import "ChatForwardBubbleUtil.h"
#import <Masonry/Masonry.h>
#import "Category.h"

@interface ChatForwardLeftTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel1;
@property (nonatomic, strong) UILabel *messageLabel2;
@property (nonatomic, strong) UILabel *messageLabel3;

@end

@implementation ChatForwardLeftTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imgViewBubble.image = [self bubbleImage];
        [self.imgViewBubble setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        
        [self.imgViewBubble mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.lessThanOrEqualTo(self.contentView).offset(-40);
        }];
        
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imgViewBubble).offset(15);
            make.right.lessThanOrEqualTo(self.imgViewBubble).offset(-12);
            make.top.equalTo(self.imgViewBubble).offset(12);
        }];
        
        [self.contentView addSubview:self.messageLabel1];
        [self.contentView addSubview:self.messageLabel2];
        [self.contentView addSubview:self.messageLabel3];
        
        [self.messageLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.titleLabel);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
        }];
        
        [self.messageLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.messageLabel1);
            make.top.equalTo(self.messageLabel1.mas_bottom).offset(6);
        }];
        
        [self.messageLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.messageLabel2);
            make.top.equalTo(self.messageLabel2.mas_bottom).offset(6);
        }];
    }
    
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.messageLabel1.text = @"";
    self.messageLabel2.text = @"";
    self.messageLabel3.text = @"";
}

- (void)setData:(MessageBaseModel *)model {
    [super setData:model];
    
    [model getForwardMessagesCompletion:^(NSArray<MessageBaseModel *> *messages, NSString *title) {
        self.titleLabel.text = title;
        
        if ([messages count] > 0) {
            MessageBaseModel *message1 = [messages firstObject];
            self.messageLabel1.text = [ChatForwardBubbleUtil singleMessageForwardFormate:message1];
        }
        
        if ([messages count] > 1) {
            MessageBaseModel *message2 = [messages objectAtIndex:1];
            self.messageLabel2.text = [ChatForwardBubbleUtil singleMessageForwardFormate:message2];
        }
        
        if ([messages count] > 2) {
            MessageBaseModel *message3 = [messages objectAtIndex:2];
            self.messageLabel3.text = [ChatForwardBubbleUtil singleMessageForwardFormate:message3];
        }
    }];
}

#define H_GROUPNICK 10
+ (CGFloat)cellHeightWithContent:(id)content needShowNickName:(BOOL)needShow {
	
	return 150 + (needShow ? H_GROUPNICK : 0);
}

#pragma mark - Create
- (UIImage *)bubbleImage {
    UIImage *image = [ChatForwardBubbleUtil bubbleImageViewIsLeft:YES];
    
    image = [image stretchableImageWithLeftCapWidth:image.size.width / 2 topCapHeight:image.size.height * 0.8];
    return image;
}

- (UILabel *)messageLabel {
    UILabel *label = [UILabel new];
    
    label.font = [UIFont mtc_font_30];
    label.textColor = ChatBubbleLeftConfigShare.forwardMessageColor;
    
    return label;
}

#pragma mark - Initializer
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont mtc_font_30];
        _titleLabel.textColor = ChatBubbleLeftConfigShare.forwardTitleColor;
    }
    return _titleLabel;
}

- (UILabel *)messageLabel1 {
    if (!_messageLabel1) {
        _messageLabel1 = [self messageLabel];
    }
    return _messageLabel1;
}

- (UILabel *)messageLabel2 {
    if (!_messageLabel2) {
        _messageLabel2 = [self messageLabel];
    }
    return _messageLabel2;
}

- (UILabel *)messageLabel3 {
    if (!_messageLabel3) {
        _messageLabel3 = [self messageLabel];
    }
    return _messageLabel3;
}

@end
