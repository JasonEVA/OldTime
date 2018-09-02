//
//  MeHeadView.m
//  Shape
//
//  Created by jasonwang on 15/11/13.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "MeHeadView.h"


@implementation MeHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        self.ponit = [[MePointView alloc]initWithFrame:CGRectMake(62, 50, 15, 15)];
        [self addSubview:self.ponit];
    }
    return self;
}
@end
