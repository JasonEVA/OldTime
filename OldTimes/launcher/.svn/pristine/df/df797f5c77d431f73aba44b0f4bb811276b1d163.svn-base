//
//  ApplyButtonView.m
//  launcher
//
//  Created by Kyle He on 15/8/6.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

//角标半径
#define corRadius 20
#import "ApplyButtonView.h"
#import <Masonry/Masonry.h>
#import "Category.h"
@interface ApplyButtonView ()<UIGestureRecognizerDelegate>
/**
 *
 */
@property (nonatomic ,strong)  UIButton  *maintBtn;

@end

@implementation ApplyButtonView

- (instancetype)initWithTitle:(NSString *)title img:(NSString *)imgstr selectImg:(NSString *)selectedImg
{
    if (self = [super init])
    {
        [self.maintBtn setTitle:title forState:UIControlStateNormal];
        
        [self.maintBtn setImage:[UIImage imageNamed:imgstr] forState:UIControlStateNormal];
        [self.maintBtn setImage:[UIImage imageNamed:selectedImg] forState:UIControlStateHighlighted];
        
        [self.maintBtn setBackgroundImage:[UIImage mtc_imageColor:[UIColor themeBlue]] forState:UIControlStateHighlighted];
        
        [self createFrame];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.maintBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -(CGRectGetWidth(self.maintBtn.bounds) / 4), 0, 0)];
    [self.maintBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, CGRectGetWidth(self.maintBtn.bounds) / 4, 0, 0)];
}

#pragma mark - interface method
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [self.maintBtn addTarget:target action:action forControlEvents:controlEvents];
}

#pragma mark - createFrame
- (void)createFrame
{
    [self addSubview:self.maintBtn];
    [self.maintBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self addSubview:self.roundView];
    [self.roundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.maintBtn.mas_right).offset(corRadius);
        make.top.equalTo(self.maintBtn).offset(-corRadius);
//        make.width.height.equalTo(@(2*corRadius));
    }];
}

#pragma mark - getter and setter
- (UIButton *)maintBtn
{
    if (!_maintBtn) {
        _maintBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _maintBtn.titleLabel.font = [UIFont mtc_font_30];
        
        [self.maintBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.maintBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
        [_maintBtn.layer setMasksToBounds:YES];
        [_maintBtn.layer setBorderWidth:1];
        [_maintBtn.layer setBorderColor:[UIColor borderColor].CGColor];
        _maintBtn.layer.cornerRadius = 15;
    }
    return _maintBtn;
}

- (RoundCountView *)roundView
{
    if (!_roundView) {
        _roundView = [[RoundCountView alloc] initWithFrame:CGRectZero];
        _roundView.layer.cornerRadius = corRadius;
        _roundView.lblTitle.font = [UIFont mtc_font_30];
    }
    return _roundView;
}

@end
