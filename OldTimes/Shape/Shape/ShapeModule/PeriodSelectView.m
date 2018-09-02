//
//  PeriodSelectView.m
//  Shape
//
//  Created by Andrew Shen on 15/11/2.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "PeriodSelectView.h"
#import "MyDefine.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"

typedef enum : NSUInteger {
    tag_left,
    tag_right
} PeriodBtnTag;
@interface PeriodSelectView()
@property (nonatomic, strong)  UIButton  *btnLeft; // <##>
@property (nonatomic, strong)  UIButton  *btnRight; // <##>
@property (nonatomic, strong)  UIImageView  *imgViewLeft; // <##>
@property (nonatomic, strong)  UIImageView  *imgViewRight; // <##>
@property (nonatomic, strong)  UILabel  *period; // <##>
@property (nonatomic, strong)  UIView  *line; // <##>
@end
@implementation PeriodSelectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor themeBackground_373737]];
        [self configElements];
    }
    return self;
}

- (void)updateConstraints {
    [self.imgViewLeft mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(leftSpacing);
        make.centerY.equalTo(self);
        make.width.equalTo(self.imgViewLeft);
        make.height.equalTo(self.imgViewLeft);
    }];
    [self.period mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.greaterThanOrEqualTo(self.imgViewLeft.mas_right);
        make.center.equalTo(self);
        make.right.lessThanOrEqualTo(self.imgViewRight.mas_left);
    }];
    [self.imgViewRight mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-rightSpacing);
        make.centerY.equalTo(self.imgViewLeft);
        make.width.equalTo(self.imgViewRight);
        make.height.equalTo(self.imgViewRight);

    }];
    [self.btnLeft mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.height.equalTo(self);
        make.width.equalTo(self).multipliedBy(0.5);
    }];
    [self.btnRight mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.centerY.height.equalTo(self);
        make.left.equalTo(self.btnLeft.mas_right);
    }];
    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@0.5);
    }];
    [super updateConstraints];
}

#pragma mark - Interface Method

// 隐藏箭头
- (void)hideLeftArrow:(BOOL)leftHide rightArrow:(BOOL)rightHide {
    [self.imgViewLeft setHidden:leftHide];
    [self.imgViewRight setHidden:rightHide];
    [self.btnLeft setEnabled:!leftHide];
    [self.btnRight setEnabled:!rightHide];
    
}

// 设置周期title
- (void)setPeriodTitle:(NSString *)periodTitle {
    [self.period setText:periodTitle];
}
#pragma mark - Private Method

// 设置元素控件
- (void)configElements {
    [self addSubview:self.btnLeft];
    [self addSubview:self.btnRight];
    [self addSubview:self.imgViewLeft];
    [self addSubview:self.imgViewRight];
    [self addSubview:self.period];
    [self addSubview:self.line];
    
    [self needsUpdateConstraints];
}

- (void)btnClicked:(UIButton *)sender {
    switch (sender.tag) {
        case tag_left:
            if ([self.delegate respondsToSelector:@selector(PeriodSelectViewDelegateCallBack_beforeButtonClicked)]) {
                [self.delegate PeriodSelectViewDelegateCallBack_beforeButtonClicked];
            }
            break;
            
        case tag_right:
            if ([self.delegate respondsToSelector:@selector(PeriodSelectViewDelegateCallBack_afterButtonClicked)]) {
                [self.delegate PeriodSelectViewDelegateCallBack_afterButtonClicked];
            }
            break;
            
        default:
            break;
    }
}

#pragma mark - Init
- (UIButton *)btnLeft {
    if (!_btnLeft) {
        _btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnLeft setBackgroundColor:[UIColor clearColor]];
        [_btnLeft addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _btnLeft.tag = tag_left;
    }
    return _btnLeft;
}
- (UIButton *)btnRight {
    if (!_btnRight) {
        _btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnRight setBackgroundColor:[UIColor clearColor]];
        [_btnRight addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _btnRight.tag = tag_right;
    }
    return _btnRight;
}
- (UIImageView *)imgViewLeft {
    if (!_imgViewLeft) {
        _imgViewLeft = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shape_analysis_leftArrow"]];
    }
    return _imgViewLeft;
}
- (UIImageView *)imgViewRight {
    if (!_imgViewRight) {
        _imgViewRight = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shape_analysis_rightArrow"]];
    }
    return _imgViewRight;
}

- (UILabel *)period {
    if (!_period) {
        _period = [[UILabel alloc] init];
        [_period setTextColor:[UIColor whiteColor]];
        [_period setFont:[UIFont systemFontOfSize:fontSize_13]];
        [_period setText:@""];
    }
    return _period;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        [_line setBackgroundColor:[UIColor lineDarkGray_4e4e4e]];
    }
    return _line;
}
@end
