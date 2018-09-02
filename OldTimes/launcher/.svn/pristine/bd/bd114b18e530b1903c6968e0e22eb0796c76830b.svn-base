//
//  ForwardBaseTableViewCell.h
//  launcher
//
//  Created by williamzhang on 16/4/5.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  转发Base Cell

#import <UIKit/UIKit.h>
#import <MintcodeIM/MintcodeIM.h>
#import <Masonry/Masonry.h>

/// 基础UI的高度,要算高度之后都加上
static CGFloat wz_forwardExtraHeight = 40;

@interface ForwardBaseTableViewCell : UITableViewCell

+ (NSString *)identifier;
+ (CGFloat)height;

@property (nonatomic, readonly) UIImageView *avatarImageView;
@property (nonatomic, readonly) UILabel *nameLabel;
@property (nonatomic, readonly) UILabel *timeLabel;

/// 用于继承 需要使用`super`
- (void)setMessageModel:(MessageBaseModel *)model;

@end
