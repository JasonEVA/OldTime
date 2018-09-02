//
//  ApplyNavBar.h
//  launcher
//
//  Created by Kyle He on 15/8/8.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  送信的导航条

#import <UIKit/UIKit.h>
@class ApplyNavBar;

@protocol ApplyNavBarDelegate <NSObject>

@optional
- (void)ApplyNavigationBar:(ApplyNavBar*)navBar CurrentSelectedIndex:(NSInteger)index;

@end

@interface ApplyNavBar : UIView

@property (nonatomic , weak) id <ApplyNavBarDelegate>  delegate;

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles;
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles hasBottomLine:(BOOL)hasBottomLine;

- (void)setCountViewWithArray:(NSArray*)dataArray;

- (void)selectIndex:(NSInteger)selectIndex;

@end
