//
//  MeetingSelectAddressBtnsView.m
//  launcher
//
//  Created by Conan Ma on 15/8/12.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "MeetingSelectAddressBtnsView.h"
#import "MyDefine.h"
#import "UIColor+Hex.h"
#import "Masonry.h"
#import "UIImage+Manager.h"

@implementation MeetingSelectAddressBtnsView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self addSubview:self.btnMeetingRoom];
        [self addSubview:self.btnMeetingOutSide];
        
        [self CreatFrame];
    }
    return self;
}

#pragma mark -Privite Methods
- (void)CreatFrame
{
    [self.btnMeetingRoom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.right.equalTo(self.mas_centerX);
    }];
    
    [self.btnMeetingOutSide mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self);
        make.left.equalTo(self.btnMeetingRoom.mas_right);
    }];
}

#pragma mark - Create
- (UIButton *)createButtonWithTitle:(NSString *)title {
    UIButton *button = [UIButton new];
    
    [button setBackgroundImage:[UIImage mtc_imageColor:[UIColor mtc_colorWithHex:0xe1e1e1]] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor mtc_colorWithHex:0x666666] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button titleLabel].font = [UIFont systemFontOfSize:14];
    
    [button setTitleColor:[UIColor mtc_colorWithHex:0x2e92fb] forState:UIControlStateSelected];
    [button setBackgroundImage:[UIImage mtc_imageColor:[UIColor whiteColor]] forState:UIControlStateSelected];
    
    [button layer].borderColor = [UIColor grayBackground].CGColor;
    [button layer].borderWidth = 1.0;
    
    return button;
}

#pragma mark - Initializer
- (UIButton *)btnMeetingRoom
{
    if (!_btnMeetingRoom)
    {
        _btnMeetingRoom = [self createButtonWithTitle:LOCAL(MEETING_INPUT_MEETINGROOM)];
        _btnMeetingRoom.tag = 1;
        _btnMeetingRoom.selected = YES;
    }
    return _btnMeetingRoom;
}

- (UIButton *)btnMeetingOutSide
{
    if (!_btnMeetingOutSide)
    {
        _btnMeetingOutSide = [self createButtonWithTitle:LOCAL(MEETING_INPUT_ADDRESSWITHOUT_MEETINGROOM)];
        _btnMeetingOutSide.tag = 2;
    }
    return _btnMeetingOutSide;
}
@end
