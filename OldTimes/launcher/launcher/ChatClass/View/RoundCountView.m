//
//  RoundCountView.m
//  Titans
//
//  Created by Remon Lv on 14-8-25.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//

#import "RoundCountView.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"
#import "UIView+Util.h"

#define COLOR_BG [UIColor colorWithRed:238.0/255.0 green:44.0/255.0 blue:76.0/255.0 alpha:1.0]

@implementation RoundCountView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [super setBackgroundColor:[UIColor themeRed]];
        [self addSubview:self.lblTitle];
        [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(self);
            make.left.equalTo(self).offset(5);
            make.height.equalTo(self).offset(-5);
        }];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.lblTitle.layer.cornerRadius = self.frame.size.height / 2;
    self.layer.cornerRadius = CGRectGetHeight(self.frame) / 2;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    
}

// 设置信息条数
- (void)setCount:(NSInteger)count
{
    if (count >= 100)
    {
        /*
        // 改变控件尺寸
        CGRect rect = self.bounds;
        rect.size.width += 10;
        rect.origin.x -= 5;
        self.frame= rect;
         */
        // 只显示99条
        self.lblTitle.text = [NSString stringWithFormat:@"⋅⋅⋅"];
    }
    else
    {
        self.lblTitle.text = [NSString stringWithFormat:@"%ld",(long)count];
    }
    
    // 如果信息条数小于1，就隐藏自身
    [self setHidden:(count < 1)];
}

- (void)setCount:(NSInteger)count Animation:(BOOL)animated
{
    [self setCount:count];
    
    if (animated)
    {
        [self fadeIn];
    }
}

// 设置应用消息
- (void)setAppCount:(NSInteger)count
{
    self.lblTitle.text = [NSString stringWithFormat:@""];
    
    // 如果信息条数小于1，就隐藏自身
    [self setHidden:(count < 1)];
}

#pragma mark - Private Methods
- (void)fadeIn
{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    //    self.alpha = 0.5;
    [UIView animateWithDuration:0.6 animations:^{
        //        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

#pragma mark - Initializer
@synthesize lblTitle = _lblTitle;
- (UILabel *)lblTitle
{
    if (!_lblTitle)
    {
        _lblTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        _lblTitle.textColor = [UIColor whiteColor];
        _lblTitle.font = [UIFont systemFontOfSize:13];
        [_lblTitle setTextAlignment:NSTextAlignmentCenter];
        [_lblTitle setBackgroundColor:[UIColor clearColor]];
        _lblTitle.expandSize = CGSizeMake(10, 10);
    }
    return _lblTitle;
}
@end
