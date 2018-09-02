//
//  ApplyTableBar.m
//  launcher
//
//  Created by Kyle He on 15/8/7.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "ApplyTableBar.h"
#import "ApplyTableBarButton.h"
#import "UIColor+Hex.h"

@interface ApplyTableBar ()
/*
 *  选中的按钮
 */
@property (nonatomic , strong) ApplyButton  *selectedBtn;


@end

@implementation ApplyTableBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor mtc_colorWithHex:0xcccccc];
    }
    return self;
}

//从自带的item中获取需要的按钮数据
- (void)addTabeBarButtonWitItem:(UITabBarItem *)item
{
    ApplyButton *btn  = [[ApplyButton alloc]init];
    btn.item = item;
    [self addSubview:btn];
    [btn addTarget:self action:@selector(ButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    if (self.subviews.count == 1)
    {
        [self ButtonClicked:btn];
    }
}

- (void)setSelectedIndexWithTag:(int)tag
{
    for (ApplyButton *btn in self.subviews)
    {
        if (tag == btn.tag)
        {
            [self ButtonClicked:btn];
        }
    }
}

//代理告知控制器被选中按钮
- (void)ButtonClicked:(ApplyButton*)btn
{
    if ([self.delegate respondsToSelector:@selector(ApplytabBar:CurrentSelectedIndex:)])
    {
        [self.delegate ApplytabBar:self CurrentSelectedIndex:(NSInteger)btn.tag];
    }
    self.selectedBtn.isSelected = NO;
    btn.isSelected = YES;
    self.selectedBtn = btn;
}

//设置tabBar按钮的位置
- (void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat btnY = 0 ;
    CGFloat btnW = self.frame.size.width /self.subviews.count;
    CGFloat btnH = self.frame.size.height;
    
    for (int index = 0; index<self.subviews.count; index++)
    {
        ApplyButton *btn = self.subviews[index];
        CGFloat btnX = index*btnW;
        btn.frame = CGRectMake(btnX, btnY, btnW-1, btnH);
        [btn setBackgroundColor:[UIColor whiteColor]];
        btn.tag = index;
        if (index == self.subviews.count-1)
        {
           btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        }
    }
}



@end
