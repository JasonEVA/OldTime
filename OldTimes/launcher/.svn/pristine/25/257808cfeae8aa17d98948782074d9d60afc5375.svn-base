//
//  ChatForwardTableHeaderView.m
//  launcher
//
//  Created by williamzhang on 16/4/5.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "ChatForwardTableHeaderView.h"
#import <Masonry/Masonry.h>
#import "UIView+Util.h"
#import "Category.h"

@implementation ChatForwardTableHeaderView

- (instancetype)initWithMessage:(NSString *)message {
    self = [super initWithFrame:CGRectMake(0, 0, 0, 25)];
    if (self) {
        
        {
            UIView *lineView = [UIView new];
            lineView.backgroundColor = [UIColor minorFontColor];
            [self addSubview:lineView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.centerY.equalTo(self);
                make.height.equalTo(@0.5);
            }];
        }
        
        {
            UILabel *messageLabel = [UILabel new];
            messageLabel.backgroundColor = [UIColor whiteColor];
            messageLabel.font = [UIFont mtc_font_24];
            messageLabel.textColor = [UIColor minorFontColor];
            messageLabel.text = message;
            messageLabel.expandSize = CGSizeMake(30, 0);
            
            [self addSubview:messageLabel];
            [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self);
            }];
        }
    }
    return self;
}

@end
