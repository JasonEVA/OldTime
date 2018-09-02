//
//  CustomProgressView.m
//  chongyiclient
//
//  Created by lkl on 16/3/2.
//  Copyright © 2016年 yinqaun. All rights reserved.
//

#import "CustomProgressView.h"

@implementation CustomProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.trackTintColor = [UIColor colorWithRed:104 green:143 blue:18 alpha:0.9];
        self.progressTintColor = [UIColor colorWithHexString:@"26AB5F"];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //放大倍数
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0, 3.0);

    self.transform = transform;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
