//
//  MeetingCurrentMeetTimeMarkView.m
//  launcher
//
//  Created by 马晓波 on 15/8/8.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "MeetingCurrentMeetTimeMarkView.h"

@interface MeetingCurrentMeetTimeMarkView()
@property (nonatomic, strong) UILabel *lblTimeMark;
@property (nonatomic, strong) UILabel *lblTimeHeadMark;
@end

@implementation MeetingCurrentMeetTimeMarkView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.lblTimeHeadMark];
        [self addSubview:self.lblTimeMark];
        [self addSubview:self.lblTitle];
    }
    return self;
}

#pragma mark - init
- (UILabel *)lblTimeHeadMark
{
    if (!_lblTimeHeadMark)
    {
        _lblTimeHeadMark = [[UILabel alloc] initWithFrame:CGRectMake(16.5, 13, 7, 7)];
        _lblTimeHeadMark.backgroundColor = [UIColor colorWithRed:1 green:51.0/255 blue:102.0/255 alpha:1];
        _lblTimeHeadMark.layer.cornerRadius = 3.5f;
        _lblTimeHeadMark.clipsToBounds = YES;
    }
    return _lblTimeHeadMark;
}

- (UILabel *)lblTimeMark
{
    if (!_lblTimeMark)
    {
        _lblTimeMark = [[UILabel alloc] initWithFrame:CGRectMake(19.5, 20, 1, self.frame.size.height - 20)];
        _lblTimeMark.backgroundColor = [UIColor colorWithRed:1 green:51.0/255 blue:102.0/255 alpha:1];
    }
    return _lblTimeMark;
}

- (UILabel *)lblTitle
{
    if (!_lblTitle)
    {
        _lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 13)];
        _lblTitle.textColor = [UIColor colorWithRed:1 green:51.0/255 blue:102.0/255 alpha:1];
        _lblTitle.textAlignment = NSTextAlignmentCenter;
        _lblTitle.font = [UIFont systemFontOfSize:12];
    }
    return _lblTitle;
}
@end
