//
//  MeetingActionSheetView.m
//  launcher
//
//  Created by Conan Ma on 15/8/13.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "MeetingActionSheetView.h"
#import "Masonry.h"
#import "MyDefine.h"
#import "UIColor+Hex.h"

@interface MeetingActionSheetView()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *btnCancel;
@end

@implementation MeetingActionSheetView

- (instancetype)initWithRoomList:(NSArray *)arr
{
    if (self = [super init])
    {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        
        [self addSubview:self.contentView];
        
        [self addSubview:self.btnCancel];
        
        self.PickView = [[MeetingSelectedMeetingRoomView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - 10, 250) MeetingRoomList:arr];
        
        [self.contentView addSubview:self.PickView];
        self.arrRoomList = arr;
    }
    return self;
}

#pragma mark - Setter
- (void)setArrRoomList:(NSArray *)arrRoomList {
    _arrRoomList = arrRoomList;
    [self.PickView setRoomList:arrRoomList];
}

#pragma mark - Initializer
- (UIButton *)btnCancel
{
    if (!_btnCancel)
    {
        _btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(5, self.frame.size.height - 50, self.frame.size.width - 10, 50)];
        _btnCancel.layer.cornerRadius = 4.0f;
        _btnCancel.backgroundColor = [UIColor whiteColor];
        [_btnCancel setTitle:LOCAL(CANCEL) forState:UIControlStateNormal];
        [_btnCancel setTitleColor:[UIColor themeBlue] forState:UIControlStateNormal];
        [_btnCancel addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        _btnCancel.clipsToBounds = YES;
    }
    return _btnCancel;
}

- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(5, self.frame.size.height - 230 - 55, self.frame.size.width - 10, 230)];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 5.0;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (void)show
{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.contentView.frame = CGRectMake(5, self.frame.size.height, self.frame.size.width - 10, 230);
    self.btnCancel.frame = CGRectMake(5, self.frame.size.height +230, self.frame.size.width - 10, 50);
    [window addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.contentView.frame = CGRectMake(5, self.frame.size.height - 230 - 55, self.frame.size.width - 10, 230);
        self.btnCancel.frame = CGRectMake(5, self.frame.size.height - 50, self.frame.size.width - 10, 50);
        
        
    } completion:^(BOOL finished){
        self.contentView.frame = CGRectMake(5, self.frame.size.height - 230 - 55, self.frame.size.width - 10, 230);
        self.btnCancel.frame = CGRectMake(5, self.frame.size.height - 50, self.frame.size.width - 10, 50);
    }];
    
}

- (void)dismiss
{
    [self removeFromSuperview];
}

@end
