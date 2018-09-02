//
//  ChatBaseTableViewCell.m
//  launcher
//
//  Created by williamzhang on 15/12/21.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ChatBaseTableViewCell.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"
#import <MintcodeIMKit/MintcodeIMKit.h>

static const long long kRecallTimeInterval = 2 * 60 * 1000;

@implementation ChatBaseTableViewCell

+ (NSString *)identifier { return NSStringFromClass(self);}
+ (CGFloat)height { return 0; }

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.selectedBackgroundView = [UIView new];
        self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        self.tintColor = [UIColor themeBlue];
        
        self.backgroundColor = [UIColor clearColor];
        self.wz_contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - MenuMessageView Delegate
// 愚蠢的人类，拿去继承吧 不给继承了，别继承
- (BOOL)menuImageViewCanBecomeFirstResponder:(MenuImageView *)imageView {
    if ([self.delegate respondsToSelector:@selector(chatBaseTableViewCellCanBecomeFirstResponder:menuImageView:)]) {
        return [self.delegate chatBaseTableViewCellCanBecomeFirstResponder:self menuImageView:imageView];
    }
    return NO;
}

- (BOOL)menuImageViewCanRecallMessage:(MenuImageView *)imageView {
    long long currentTimestamp = [MessageManager currentServerMsTimestamp];
    long long interval = currentTimestamp - self.cellMsgID;
    if (interval <= kRecallTimeInterval) {
        return YES;
    }
    return NO;
}

- (void)menuImageViewClickEmphasis:(MenuImageView *)imageView {
    if ([self.delegate respondsToSelector:@selector(chatBaseTableViewCell:clickedToEmphasisAtIndexPath:)]) {
        [self.delegate chatBaseTableViewCell:self clickedToEmphasisAtIndexPath:[self getIndexPath]];
    }
}
- (void)menuImageViewClickCancelEmphasis:(MenuImageView *)imageView {
    if ([self.delegate respondsToSelector:@selector(chatBaseTableViewCell:clickedToCancelEmphasisAtIndexPath:)]) {
        [self.delegate chatBaseTableViewCell:self clickedToCancelEmphasisAtIndexPath:[self getIndexPath]];
    }
}
- (void)menuImageViewClickCopy:(MenuImageView *)imageView {
    if ([self.delegate respondsToSelector:@selector(chatBaseTableViewCell:clickedToCopyAtIndexPath:)]) {
        [self.delegate chatBaseTableViewCell:self clickedToCopyAtIndexPath:[self getIndexPath]];
    }
}
- (void)menuImageViewClickSchedule:(MenuImageView *)imageView {
    if ([self.delegate respondsToSelector:@selector(chatBaseTableViewCell:clickedToScheduleAtIndexPath:)]) {
        [self.delegate chatBaseTableViewCell:self clickedToScheduleAtIndexPath:[self getIndexPath]];
    }
}
- (void)menuImageViewClickMission:(MenuImageView *)imageView {
    if ([self.delegate respondsToSelector:@selector(chatBaseTableViewCell:clickedToMissionAtIndexPath:)]) {
        [self.delegate chatBaseTableViewCell:self clickedToMissionAtIndexPath:[self getIndexPath]];
    }
}

- (void)menuImageViewClickRecall:(MenuImageView *)imageView {
    if ([self.delegate respondsToSelector:@selector(chatBaseTableViewCell:clickedToRecallAtIndexPath:)]) {
        [self.delegate chatBaseTableViewCell:self clickedToRecallAtIndexPath:[self getIndexPath]];
    }
}

- (void)menuImageViewClickForward:(MenuImageView *)imageView {
    if ([self.delegate respondsToSelector:@selector(chatBaseTableViewCell:clickedToForwardAtIndexPath:)]) {
        [self.delegate chatBaseTableViewCell:self clickedToForwardAtIndexPath:[self getIndexPath]];
    }
    
}

- (void)menuImageViewClickMore:(MenuImageView *)imageView {
    if ([self.delegate respondsToSelector:@selector(chatBaseTableViewCell:clickedToMoreAtIndexPath:)]) {
        [self.delegate chatBaseTableViewCell:self clickedToMoreAtIndexPath:[self getIndexPath]];
    }
}

- (void)menuImageViewTap:(MenuImageView *)imageView {
    if ([self.delegate respondsToSelector:@selector(chatBaseTableViewCell:tappedAtIndexPath:)]) {
        [self.delegate chatBaseTableViewCell:self tappedAtIndexPath:[self getIndexPath]];
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if ([self.delegate respondsToSelector:@selector(chatBaseTableViewCellIsEdtingMode:)]) {
        if ([self.delegate chatBaseTableViewCellIsEdtingMode:self]) {
            return self;
        }
    }
    
    return [super hitTest:point withEvent:event];
}

#pragma mark - Private Method
- (NSIndexPath *)getIndexPath {
    
    UIView *superView = self.superview;
    
    while (superView) {
        if ([superView isKindOfClass:[UITableView class]]) {
            break;
        }
        
        superView = superView.superview;
    }
    if (!superView) {
        return nil;
    }
    
    return [(UITableView *)superView indexPathForCell:self];
}

@end
