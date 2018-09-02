//
//  MeetingNameListBtn.m
//  launcher
//
//  Created by 马晓波 on 15/8/11.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "MeetingNameListBtn.h"
#import "MyDefine.h"
#import "UIColor+Hex.h"

@implementation MeetingNameListBtn

- (instancetype)init
{
    if (self = [super init])
    {
        [self addSubview:self.label];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)SetBtnBlue
{
    self.label.textColor = [UIColor colorWithRed:0 green:153.0/255 blue:1 alpha:1];
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:self.label.text];
//    NSRange contentRange = {0, [content length]};
//    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    
    self.label.attributedText = content;
}

#pragma mark - init
- (UILabel *)label
{
    if (!_label)
    {
        _label = [[UILabel alloc] init];
        _label.textColor = [UIColor grayColor];
        _label.font = [UIFont systemFontOfSize:12];
        _label.textAlignment = NSTextAlignmentLeft;
    }
    return _label;
}

@end
