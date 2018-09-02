//
//  ApplyNavBtn.m
//  launcher
//
//  Created by Kyle He on 15/8/8.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "ApplyNavBtn.h"
#import "RoundCountView.h"
#import "Masonry.h"
#import "UIColor+Hex.h"
#import "MyDefine.h"

//角标直径
#define tageRaidus 15
@interface ApplyNavBtn ()
/**
 *  按钮中的文字显示标签
 */
@property (nonatomic , strong) UILabel   *titleLb;
/**
 *  数字显示标签
 */
@property (nonatomic , strong) RoundCountView  *countView;
/**
 *  按钮底部的蓝线
 */
@property (nonatomic , strong) UIView  *blueView;
/**
 *  按钮底部的灰线
 */
@property (nonatomic , strong) UIView  *grayView;
@end

@implementation ApplyNavBtn
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
//        [self addLine];
        [self createFrame];
    }
    return self;
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    //设置选中颜色
    self.titleLb.textColor = isSelected ? [UIColor blackColor] : [UIColor mtc_colorWithHex:0x999999];
//    self.grayView.backgroundColor  = !isSelected ? [UIColor mtc_colorWithHex:0xf0f0f0] : [UIColor clearColor];
}

#pragma mark - 提供外部接口部分

- (void)setTite:(NSString*)title
{
    self.titleLb.text = title;
    self.titleLb.textAlignment = NSTextAlignmentCenter;
}

- (void)setCount:(NSInteger)count
{
    [self.countView setCount:count];
}
#pragma mark - cretaFrame
- (void)createFrame
{
    [self addSubview:self.titleLb];
  
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    [self addSubview:self.countView];
    [self.countView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLb.mas_right).offset(-3);
        make.top.equalTo(self.titleLb.mas_top).offset(-5);
//        make.width.equalTo(@(tageRaidus));
//        make.height.equalTo(@(tageRaidus));
    }];
}

#pragma mark - initilizer
-(UILabel *)titleLb
{
    if(!_titleLb)
    {
        _titleLb = [[UILabel alloc] init];
        _titleLb.font = [UIFont systemFontOfSize:15.0f];
        
    }
    return _titleLb;
}

-(RoundCountView *)countView
{
    if (!_countView)
    {
        _countView = [[RoundCountView alloc] initWithFrame:CGRectMake(0, 0, tageRaidus, tageRaidus)];
    }
    return _countView;
}

-(UIView *)blueView
{
    if (!_blueView)
    {
        _blueView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 3,self.frame.size.width, 3)];
    }
    return _blueView;
}

-(UIView *)grayView
{
    if (!_grayView)
    {
        _grayView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height,self.frame.size.width, 1)];
    }
    return _grayView;
}

#pragma mark - addBlueline
-(void)addLine
{
    [self addSubview:self.grayView];
}



@end
