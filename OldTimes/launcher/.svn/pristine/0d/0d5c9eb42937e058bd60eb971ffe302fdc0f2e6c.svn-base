//
//  MeetingTimeDetailTimeMarkView.m
//  launcher
//
//  Created by 马晓波 on 15/8/8.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "MeetingTimeDetailTimeMarkView.h"
#import "MyDefine.h"
#import "Masonry.h"

@interface MeetingTimeDetailTimeMarkView()
@property (nonatomic) CGRect SelfFrame;
@end
@implementation MeetingTimeDetailTimeMarkView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.SelfFrame = frame;
        [self CreatFrames];
    }
    return self;
}
#pragma mark - Privite Methods
- (void)CreatFrames
{
//    [self addSubview:self.lblTitle];
//    
//    [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.width.equalTo(self);
//        make.height.equalTo(@(20));
//    }];
    
    [self addSubview:self.lblLine];
    
    [self.lblLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.width.equalTo(@(1));
    }];
}

#pragma mark - init
//- (UILabel *)lblTitle
//{
//    if (!_lblTitle)
//    {
//        _lblTitle = [[UILabel alloc] init];
//        _lblTitle.backgroundColor = [UIColor clearColor];
//        _lblTitle.font = [UIFont systemFontOfSize:12];
//        _lblTitle.textAlignment = NSTextAlignmentCenter;
//        _lblTitle.textColor = [UIColor lightGrayColor];
//    }
//    return _lblTitle;
//}

- (UILabel *)lblLine
{
    if (!_lblLine)
    {
        _lblLine = [[UILabel alloc] init];
        _lblLine.backgroundColor = [UIColor lightGrayColor];
    }
    return _lblLine;
}
@end
