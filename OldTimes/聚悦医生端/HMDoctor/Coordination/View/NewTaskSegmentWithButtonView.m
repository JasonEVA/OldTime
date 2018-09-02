//
//  NewTaskSegmentWithButtonView.m
//  launcher
//
//  Created by jasonwang on 16/2/17.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewTaskSegmentWithButtonView.h"
#import "UIImage+EX.h"
#import "UIColor+Hex.h"
#import "Masonry.h"

@interface NewTaskSegmentWithButtonView ()

@property (nonatomic, strong) UIButton *btnLeft;
@property (nonatomic, strong) UIButton *btnMiddle;
@property (nonatomic, strong) UIButton *btnRight;
@property (nonatomic, strong) UIButton *btnWithout;

@end

@implementation NewTaskSegmentWithButtonView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.selectedIndex = 4;
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.btnLeft];
        [self addSubview:self.btnRight];
        [self addSubview:self.btnMiddle];
        [self addSubview:self.btnWithout];
        [self createFrames];
    }
    return self;
}



#pragma mark - Privite Methods
- (void)createFrames
{
    [self.btnWithout mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.top.equalTo(self);
        make.left.equalTo(self.btnRight.mas_right).offset(15);
        make.width.equalTo(self.btnRight);
        make.height.equalTo(@25);
    }];
    
    [self.btnRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.btnMiddle.mas_right).offset(15);
        make.top.bottom.equalTo(self);
        make.width.height.equalTo(_btnWithout);
    }];
    
    [self.btnMiddle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.btnLeft.mas_right).offset(15);
        make.top.bottom.equalTo(self);
        make.width.height.equalTo(_btnWithout);

    }];
    [self.btnLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.top.equalTo(self);
        make.width.height.equalTo(_btnWithout);

    }];
    
}


- (void)btn_click:(UIButton *)btn {
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
    self.btnWithout.selected = self.btnWithout.tag == selectedIndex;
}

#pragma mark - Create
- (UIButton *)createButtonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor selectedBackgroundColor:(UIColor *)backgroundColor pointColor:(UIColor *)pointColor{
    UIButton *button = [UIButton new];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage at_imageWithColor:[UIColor whiteColor] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [button setBackgroundImage:[UIImage at_imageWithColor:backgroundColor size:CGSizeMake(1, 1)] forState:UIControlStateSelected];
    [button.layer setCornerRadius:3];
    [button setClipsToBounds:YES];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:pointColor];
    [view.layer setCornerRadius:6];
    view.userInteractionEnabled = NO;
    [button addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(button.titleLabel.mas_left).offset(-5);
        make.centerY.equalTo(button.titleLabel);
        make.width.height.equalTo(@12);
    }];

    return button;
}

#pragma mark - Initializer
- (UIButton *)btnLeft {
    if (!_btnLeft) {
        _btnLeft = [self createButtonWithTitle:@"高" titleColor:[UIColor blackColor] selectedBackgroundColor:[UIColor themeBlue] pointColor:[UIColor colorWithHex:0xff3366]];
        [_btnLeft addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
        _btnLeft.tag = 3;
        
            }
    return _btnLeft;
}

- (UIButton *)btnMiddle {
    if (!_btnMiddle) {
        _btnMiddle = [self createButtonWithTitle:@"中" titleColor:[UIColor blackColor] selectedBackgroundColor:[UIColor themeBlue] pointColor:[UIColor colorWithHex:0xffac4f]];
        [_btnMiddle addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
        _btnMiddle.backgroundColor = [UIColor whiteColor];
        _btnMiddle.tag = 2;
    }
    return _btnMiddle;
}

- (UIButton *)btnRight {
    if (!_btnRight) {
        _btnRight = [self createButtonWithTitle:@"低" titleColor:[UIColor blackColor] selectedBackgroundColor:[UIColor themeBlue] pointColor:[UIColor colorWithHex:0xcccccc]];
        [_btnRight addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
        _btnRight.tag = 1;
    }
    return _btnRight;
}

- (UIButton *)btnWithout {
    if (!_btnWithout) {
        _btnWithout = [UIButton new];
        [_btnWithout setTitle:@"无" forState:UIControlStateNormal];
        [_btnWithout setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btnWithout setBackgroundImage:[UIImage at_imageWithColor:[UIColor whiteColor] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        
        [_btnWithout setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_btnWithout setBackgroundImage:[UIImage at_imageWithColor:[UIColor themeBlue] size:CGSizeMake(1, 1)] forState:UIControlStateSelected];
        
        _btnWithout.titleLabel.font = [UIFont systemFontOfSize:14];

        [_btnWithout addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
        _btnWithout.selected = YES;
        _btnWithout.tag = 0;
        [_btnWithout.layer setCornerRadius:3];
        [_btnWithout setClipsToBounds:YES];
    }
    return _btnWithout;
}

@end
