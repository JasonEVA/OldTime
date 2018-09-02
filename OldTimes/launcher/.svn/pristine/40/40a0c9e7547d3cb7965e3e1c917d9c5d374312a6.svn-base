//
//  TiptiltedView.m
//  launcher
//
//  Created by 马晓波 on 16/3/10.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "TiptiltedView.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"
#import "MyDefine.h"

@interface TiptiltedView()
@property (nonatomic, assign) viewKind myType;
@property (nonatomic, strong) UIView *viewDown;
@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) UIColor *colorDark;
@property (nonatomic, strong) UIColor *colorLight;
@property (nonatomic, strong) NSString *string;
@end

@implementation TiptiltedView
- (instancetype)init
{
    if (self = [super init])
    {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.lblTitle];
        [self addSubview:self.viewDown];
        CGAffineTransform t = CGAffineTransformMakeRotation(-M_PI/15);
        self.transform = t;
        [self update];
        
    }
    return self;
}

- (void)update
{
    [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self).offset(6);
    }];
    
    [self.viewDown mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).offset(6);
        make.right.equalTo(self).offset(-6);
    }];
    
//    [super updateConstraintsIfNeeded];
}

- (void)setdataWithType:(viewKind)type
{
    self.myType = type;
    if (type == viewKind_Approve || type == viewKind_Attended || type == viewKind_PassTo || type == viewKind_agree)
    {
        self.colorLight = [UIColor mtc_colorWithHex:0x3e99ff alpha:0.1];
        self.colorDark = [UIColor mtc_colorWithHex:0x3e99ff alpha:0.5];
    }
    else if(type == viewKind_RejectApprove  || type ==	viewKind_RejectAttend)
    {
        self.colorLight = [UIColor mtc_colorWithHex:0xff3366 alpha:0.1];
        self.colorDark = [UIColor mtc_colorWithHex:0xff3366 alpha:0.5];
    }else if (type == viewKind_BackApprove)
    {
        self.colorLight = [UIColor mtc_colorWithHex:0xfab56b alpha:0.1];
        self.colorDark  = [UIColor mtc_colorWithHex:0xfab56b alpha:0.5];
    }
    


    switch (type)
    {
        case viewKind_Approve:
            self.string = LOCAL(APPLY_ACCEPT);
            break;
        case viewKind_PassTo:
            self.string = LOCAL(IM_CHATCARD_TRANSFORM);
            break;
        case viewKind_Attended:
            self.string = LOCAL(IM_CHATCARD_ATTAEND);
            break;
        case viewKind_BackApprove:
            self.string = LOCAL(APPLY_SENDER_BACKWARD_TITLE);
            break;
        case viewKind_RejectApprove:
            self.string = LOCAL(IM_CHATCARD_NOTATTEND);
            break;
        case viewKind_RejectAttend:
            self.string = LOCAL(MEETING_NOTATTEND);
            break;
        case viewKind_agree:
            self.string = LOCAL(FRIEND_AGREE);
            break;
        case viewKind_disAgree:
            self.string = LOCAL(FRIEND_DISAGREE);
            break;
        default:
            break;
    }
    self.lblTitle.text = self.string;
    [self.lblTitle setTextColor:self.colorDark];
    self.viewDown.layer.borderColor = self.colorDark.CGColor;
    self.lblTitle.backgroundColor = self.colorLight;
}

#pragma mark - init
- (UIView *)viewDown
{
    if (!_viewDown)
    {
        _viewDown = [[UIView alloc] init];
        _viewDown.backgroundColor = [UIColor clearColor];
        _viewDown.layer.cornerRadius = 5.0f;
        _viewDown.layer.borderWidth = 3.0f;
        _viewDown.clipsToBounds = YES;
    }
    return _viewDown;
}

- (UILabel *)lblTitle
{
    if (!_lblTitle)
    {
        _lblTitle = [[UILabel alloc] init];
        _lblTitle.layer.cornerRadius = 5.0f;
        _lblTitle.clipsToBounds = YES;
        [_lblTitle setTextAlignment:NSTextAlignmentCenter];
        [_lblTitle setFont:[UIFont boldSystemFontOfSize:15]];
        [_lblTitle setAdjustsFontSizeToFitWidth:YES];
    }
    return _lblTitle;
}

- (NSString *)string
{
    if (!_string)
    {
        _string = [[NSString alloc] init];
    }
    return _string;
}
@end
