//
//  TaskSegmentWithButtonView.m
//  launcher
//
//  Created by Conan Ma on 15/8/31.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "TaskSegmentWithButtonView.h"
#import "UIImage+Manager.h"
#import "UIColor+Hex.h"
#import "UIButton+DeterReClicked.h"
#import "MyDefine.h"
#import "Masonry.h"

@interface TaskSegmentWithButtonView ()

@property (nonatomic, strong) UIButton *btnLeft;
@property (nonatomic, strong) UIButton *btnMiddle;
@property (nonatomic, strong) UIButton *btnRight;

@end

@implementation TaskSegmentWithButtonView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.selectedIndex = -1;
        self.layer.cornerRadius = frame.size.height / 2;
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        
        [self addSubview:self.btnLeft];
        [self addSubview:self.btnRight];
        [self addSubview:self.btnMiddle];
        
        [self createFrames];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat offset = -CGRectGetWidth(self.frame) / 3;
    [self.btnLeft setTitleEdgeInsets:UIEdgeInsetsMake(0, offset, 0, 0)];
    [self.btnRight setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, offset)];
}

#pragma mark - Privite Methods
- (void)createFrames
{
    [self.btnLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.top.equalTo(self);
        make.right.equalTo(self.btnMiddle);
    }];
    
    [self.btnMiddle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_right).dividedBy(3.0);
        make.right.equalTo(self.mas_right).multipliedBy(2.0 / 3);
        make.top.bottom.equalTo(self);
    }];
    
    [self.btnRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.btnMiddle);
        make.top.bottom.right.equalTo(self);
    }];
}

- (void)btn_click:(UIButton *)btn {
    //按钮暴力点击防御
    [self.btnLeft mtc_deterClickedRepeatedly];
    [self.btnRight mtc_deterClickedRepeatedly];
    [self.btnMiddle mtc_deterClickedRepeatedly];
    
    if (self.selectedIndex == btn.tag) {
        return;
    }
    
    self.selectedIndex = btn.tag;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

#pragma mark - Setter
- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    self.btnLeft.selected = self.btnLeft.tag == selectedIndex;
    self.btnMiddle.selected = self.btnMiddle.tag == selectedIndex;
    self.btnRight.selected = self.btnRight.tag == selectedIndex;
}

#pragma mark - Create
- (UIButton *)createButtonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor selectedBackgroundColor:(UIColor *)backgroundColor {
    UIButton *button = [UIButton new];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage mtc_imageColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [button setBackgroundImage:[UIImage mtc_imageColor:backgroundColor] forState:UIControlStateSelected];
    
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    button.layer.borderColor = titleColor.CGColor;
    button.layer.borderWidth = 1.0;
    
    
    return button;
}

#pragma mark - Initializer
- (UIButton *)btnLeft {
    if (!_btnLeft) {
        _btnLeft = [self createButtonWithTitle:LOCAL(MISSION_HIGH) titleColor:[UIColor mtc_colorWithHex:0xff3366] selectedBackgroundColor:[UIColor mtc_colorWithHex:0xff3366]];
        [_btnLeft addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
        _btnLeft.tag = 2;
        _btnLeft.layer.cornerRadius = CGRectGetHeight(self.frame) / 2;
    }
    return _btnLeft;
}

- (UIButton *)btnMiddle {
    if (!_btnMiddle) {
        _btnMiddle = [self createButtonWithTitle:LOCAL(MISSION_MEDIUM) titleColor:[UIColor mtc_colorWithHex:0xffac4f] selectedBackgroundColor:[UIColor mtc_colorWithHex:0xffac4f]];
        [_btnMiddle addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
        _btnMiddle.backgroundColor = [UIColor whiteColor];
        _btnMiddle.tag = 1;
    }
    return _btnMiddle;
}

- (UIButton *)btnRight {
    if (!_btnRight) {
        _btnRight = [self createButtonWithTitle:LOCAL(MISSION_LOW) titleColor:[UIColor mtc_colorWithHex:0xacacac] selectedBackgroundColor:[UIColor mtc_colorWithHex:0xacacac]];
        [_btnRight addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
        _btnRight.selected = YES;
        _btnRight.tag = 0;
        _btnRight.layer.cornerRadius = CGRectGetHeight(self.frame) / 2;
    }
    return _btnRight;
}

@end
