//
//  MainConsoleFunctionView.m
//  HMDoctor
//
//  Created by yinquan on 2017/5/18.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "MainConsoleFunctionView.h"
#import "MainConsoleFunctionButton.h"

@interface MainConsoleFunctionView ()

@property (nonatomic, readonly) UIView* scrollView;


@end

@implementation MainConsoleFunctionView

@synthesize scrollView = _scrollView;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
}

- (void) setFunctionModels:(NSArray*) models
{
    if (_functionButtons) {
        [_functionButtons enumerateObjectsUsingBlock:^(UIButton* button, NSUInteger idx, BOOL * _Nonnull stop) {
            [button removeFromSuperview];
        }];
        
        [_functionButtons removeAllObjects];
    }
    _functionButtons = [NSMutableArray array];
    
    __block MASViewAttribute* buttonleft = self.scrollView.mas_left;
    __block MASViewAttribute* buttontop = self.scrollView.mas_top;
    __block UIButton* preButton = nil;
    
    
    [models enumerateObjectsUsingBlock:^(MainConsoleFunctionModel* model, NSUInteger idx, BOOL * _Nonnull stop) {
        MainConsoleFunctionButton* button = [self createFunctionButton];
        [self.scrollView addSubview:button];
        
        [button setFunctionModel:model];
        [button showRightLine];
        [button showBottomLine];
        [button setTitleColor:[UIColor commonTextColor] forState:UIControlStateNormal];
        [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        
        [_functionButtons addObject:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(buttonleft);
//            make.height.mas_equalTo(@116);
            make.top.equalTo(buttontop);
            make.width.height.mas_equalTo(@((kScreenWidth - 30)/3));
        }];
        
        buttonleft = button.mas_right;
        
        if ((idx % 3) == 2) {
            buttontop = button.mas_bottom;
            buttonleft = self.scrollView.mas_left;
        }
        
        preButton = button;
    }];
    
}

- (MainConsoleFunctionButton*) createFunctionButton
{
    MainConsoleFunctionButton* functionButton = [MainConsoleFunctionButton buttonWithType:UIButtonTypeCustom];
    return functionButton;
}

- (UIView*) scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIView alloc] init];
        [self addSubview:_scrollView];
    }
    return _scrollView;
}




@end

@implementation MainConsoleStartFunctionView

- (MainConsoleFunctionButton*) createFunctionButton
{
    MainConsoleFunctionButton* functionButton = [MainConsoleStartFunctionButton buttonWithType:UIButtonTypeCustom];
    return functionButton;
}


@end

@implementation MainConsoleDisplayFunctionView

- (MainConsoleFunctionButton*) createFunctionButton
{
    MainConsoleFunctionButton* functionButton = [MainConsoleDisplayFunctionButton buttonWithType:UIButtonTypeCustom];
    return functionButton;
}

@end


@implementation MainConsoleEditSelectedFunctionView

- (MainConsoleFunctionButton*) createFunctionButton
{
    MainConsoleFunctionButton* functionButton = [MainConsoleEditSelectedFunctionButton buttonWithType:UIButtonTypeCustom];
    return functionButton;
}

- (CGRect) functionButtonFrame:(NSInteger) index
{
    CGRect frame = CGRectMake((index % 3) * (self.width / 3), (self.width / 3) * (index / 3), self.width / 3, (self.width / 3));
    return frame;
}

- (void) replaceSortAnimation:(NSInteger) startIndex endIndex:(NSInteger) endIndex
{
    if (startIndex == endIndex) {
        //不需要滑动
    }
    
    if (startIndex > 0 && startIndex < endIndex) {
        //向前滑动
        for (NSInteger index = startIndex + 1; index <= endIndex; ++index)
        {
            MainConsoleFunctionButton* button = self.functionButtons[index];
            [button setFrame:[self functionButtonFrame:index-1]];
            [UIView animateWithDuration: 0.2 animations: ^{
                [button setFrame:[self functionButtonFrame:index]];
            } completion: nil];
        }
    }
    
    if (startIndex > endIndex) {
        //向后滑动
        for (NSInteger index = endIndex ; index < startIndex; ++index)
        {
            MainConsoleFunctionButton* button = self.functionButtons[index];
            [button setFrame:[self functionButtonFrame:index + 1]];
            [UIView animateWithDuration: 0.2 animations: ^{
                [button setFrame:[self functionButtonFrame:index]];
            } completion: nil];
        }
    }
}


@end

@implementation MainConsoleEditUnSelectedFunctionView

- (MainConsoleFunctionButton*) createFunctionButton
{
    MainConsoleFunctionButton* functionButton = [MainConsoleEditUnSelectedFunctionButton buttonWithType:UIButtonTypeCustom];
    return functionButton;
}



@end
