//
//  MeetingSmallRedMarkView.m
//  launcher
//
//  Created by Conan Ma on 15/8/17.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "MeetingSmallRedMarkView.h"

@interface MeetingSmallRedMarkView()
@property (nonatomic, strong) UILabel *lblHead;
@property (nonatomic, strong) UILabel *lblLine;
@end

@implementation MeetingSmallRedMarkView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self addSubview:self.lblHead];
        [self addSubview:self.lblLine];
    }
    return self;
}

#pragma mark - init
- (UILabel *)lblHead
{
    if (!_lblHead)
    {
        _lblHead = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 6, 6)];
        _lblHead.layer.cornerRadius = 3.0f;
        _lblHead.clipsToBounds = YES;
        _lblHead.backgroundColor = [UIColor redColor];
    }
    return _lblHead;
}

- (UILabel *)lblLine
{
    if (!_lblLine)
    {
        _lblLine = [[UILabel alloc] initWithFrame:CGRectMake(6, 2.5, 24, 1)];
        _lblLine.backgroundColor = [UIColor redColor];
    }
    return _lblLine;
}
@end
