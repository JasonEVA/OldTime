//
//  ApplyNavBar.m
//  launcher
//
//  Created by Kyle He on 15/8/8.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "ApplyNavBar.h"
#import "ApplyNavBtn.h"
#import "UIColor+Hex.h"
#import "ApplyNavBtn.h"
#import "MyDefine.h"

@interface ApplyNavBar()
/**
 *   被选择的按钮
 */
@property (nonatomic , strong) ApplyNavBtn  *selectedBtn;
/**
 *  底部蓝色的线
 */
@property (nonatomic , strong) UIView  *blueLineview;

@property (nonatomic, strong) NSMutableArray *arrayButtons;

@end

@implementation ApplyNavBar
/**
 *  初始化方法
 *  @param titles 存放item的名字的数组
 */
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles
{
    return [self initWithFrame:frame titles:titles hasBottomLine:NO];
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles hasBottomLine:(BOOL)hasBottomLine {
    if (self = [super initWithFrame:frame])
    {
        _arrayButtons = [NSMutableArray array];
        [self addItems:titles];
        [self setCountViewWithArray:nil];
        
        if (hasBottomLine) {
            UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 1, CGRectGetWidth(self.frame), 1)];
            bottomLine.backgroundColor = [UIColor mtc_colorWithR:227 g:227 b:229];
            [self addSubview:bottomLine];
        }
        
        //蓝色底线
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,self.frame.size.height - 1, self.frame.size.width/titles.count, 1)];
        view.backgroundColor = [UIColor themeBlue];
        self.blueLineview  = view;
        //[self addSubview:self.blueLineview];
    }
    return self;
}

//添加导航条中的按钮
- (void)addItems:(NSArray *)titles
{
    for (int i = 0; i < titles.count; i++)
    {
        CGFloat btnW = self.frame.size.width / titles.count;
        CGFloat btnH = self.frame.size.height;
        CGFloat btnX = btnW * i;
        CGFloat btnY = 0;
        ApplyNavBtn *btn = [[ApplyNavBtn alloc]initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
        [btn setTite:titles[i]];
        
        btn.tag = i;
        [btn addTarget:self action:@selector(selectedItem:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0)
        {
            self.selectedBtn = btn;
            btn.isSelected = YES;
        }else
        {
            btn.isSelected = NO;
        }
        [self addSubview:btn];
        [self.arrayButtons addObject:btn];
    }
}

//设置选择状态显示
- (void)selectedItem:(ApplyNavBtn *)button
{
    self.selectedBtn.isSelected = NO;
    self.selectedBtn = button;
    button.isSelected = YES;
    
    CGRect tempFrame  =  self.blueLineview.frame;
    tempFrame.origin.x = button.frame.origin.x;
    self.blueLineview.frame  = tempFrame;

    //代理方法
    if([self.delegate respondsToSelector:@selector(ApplyNavigationBar:CurrentSelectedIndex:)])
    {
        [self.delegate ApplyNavigationBar:self CurrentSelectedIndex:(NSInteger)button.tag];
    }
}   

- (void)setCountViewWithArray:(NSArray*)dataArray
{
    for (ApplyNavBtn *btn in self.arrayButtons)
    {
        if (btn.tag == 0)
        {
            NSNumber *num = dataArray[0];
            [btn setCount:[num integerValue]];
        }
        else if (btn.tag == 1)
        {
            NSNumber *num = dataArray[1];
            [btn setCount:[num integerValue]];
        }
    }
}

#pragma mark - Interface Method
- (void)selectIndex:(NSInteger)selectIndex
{
    if (selectIndex >= [self.arrayButtons count]) {
        return;
    }
    
    ApplyNavBtn *button = [self.arrayButtons objectAtIndex:selectIndex];
    [self selectedItem:button];
}

@end
