//
//  MsgEmojiCollectionViewCell.m
//  Titans
//
//  Created by Wythe Zhou on 1/21/15.
//  Copyright (c) 2015 Remon Lv. All rights reserved.
//

#import "MsgEmojiCollectionViewCell.h"

#define EMOJI_WIDTH 30

@implementation MsgEmojiCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.titleLabel.font = [UIFont systemFontOfSize:EMOJI_WIDTH];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.titleLabel];
    }
    return self;
}

@end
