//
//  MsgEmojiBackspaceCollectionViewCell.m
//  Titans
//
//  Created by Wythe Zhou on 1/23/15.
//  Copyright (c) 2015 Remon Lv. All rights reserved.
//

#import "MsgEmojiBackspaceCollectionViewCell.h"

@implementation MsgEmojiBackspaceCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.image = [UIImage imageNamed:@"message_chat_btnBackspace"];
        imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:imageView];
    }
    return self;
}

@end
